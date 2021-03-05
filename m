Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0310832E1F5
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 07:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbhCEGFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 01:05:03 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:24418 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229448AbhCEGFC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 01:05:02 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 125645DO176273;
        Fri, 5 Mar 2021 01:04:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to; s=pp1;
 bh=fsIDT7dGq1C3PN1Tl3aJgDEQWnUZ2WyKi07Dve8KGp8=;
 b=fKBNTpEyPG0ixr4feEqcgmfVECJAh4/PahhQBPxyEpnkx5s4iSglZIW1bZgPP7cHuTBM
 UfRFBnAsHth9E/9TRloPHDN/WBkIROgS07uAuGmynrosYUpBKEeX5IYR+8S/8buo7bGa
 LNxFIDig77cjJIt3WVTij63wLAM0lZ7NrFphS1ajN8irHWjW8G93jOcHP7asAw7bTM5k
 NgQorT2CJiLkPhd71mi/0wRgV9nfarop0ox4LQh/y9fcSZjtV7OaroBa95KaXsuhQwnR
 3teOBpX/Y1khC+9xM3WLylVSN0HbFj9xesGqNs60WC/7NYpYEJOS6dQR2ntFO97ize7R hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 373f2480g0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Mar 2021 01:04:34 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12564Xlu179250;
        Fri, 5 Mar 2021 01:04:33 -0500
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 373f2480eq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Mar 2021 01:04:33 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 1255mLJ2026365;
        Fri, 5 Mar 2021 06:04:32 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma04wdc.us.ibm.com with ESMTP id 3712pj5a1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Mar 2021 06:04:32 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12564UHG45023548
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Mar 2021 06:04:31 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DDE66C6055;
        Fri,  5 Mar 2021 06:04:30 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 22085C6059;
        Fri,  5 Mar 2021 06:04:29 +0000 (GMT)
Received: from [9.85.134.181] (unknown [9.85.134.181])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Fri,  5 Mar 2021 06:04:28 +0000 (GMT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH] ibmvnic: remove excessive irqsave
From:   Lijun Pan <ljp@linux.vnet.ibm.com>
In-Reply-To: <67215668-0850-a0f3-06e1-49db590b8fcc@csgroup.eu>
Date:   Fri, 5 Mar 2021 00:04:27 -0600
Cc:     angkery <angkery@163.com>, mpe@ellerman.id.au,
        benh@kernel.crashing.org, paulus@samba.org,
        Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Junlin Yang <yangjunlin@yulong.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <753DD123-9E78-4270-B6D8-81A8D07B1FA0@linux.vnet.ibm.com>
References: <20210305014350.1460-1-angkery@163.com>
 <67215668-0850-a0f3-06e1-49db590b8fcc@csgroup.eu>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-05_03:2021-03-03,2021-03-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 adultscore=0 suspectscore=0 impostorscore=0 phishscore=0 spamscore=0
 clxscore=1011 priorityscore=1501 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103050028
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 4, 2021, at 11:49 PM, Christophe Leroy =
<christophe.leroy@csgroup.eu> wrote:
>=20
>=20
>=20
> Le 05/03/2021 =C3=A0 02:43, angkery a =C3=A9crit :
>> From: Junlin Yang <yangjunlin@yulong.com>
>> ibmvnic_remove locks multiple spinlocks while disabling interrupts:
>> spin_lock_irqsave(&adapter->state_lock, flags);
>> spin_lock_irqsave(&adapter->rwi_lock, flags);
>> there is no need for the second irqsave,since interrupts are disabled
>> at that point, so remove the second irqsave:
>=20
> The probl=C3=A8me is not that there is no need. The problem is a lot =
more serious:
> As reported by coccinella, the second _irqsave() overwrites the value =
saved in 'flags' by the first _irqsave, therefore when the second =
_irqrestore comes, the value in 'flags' is not valid, the value saved by =
the first _irqsave has been lost. This likely leads to IRQs remaining =
disabled, which is _THE_ problem really.

That does sounds like a more serious functional problem than coccinella =
check.
Thanks for your explanation.

>=20
>> spin_lock_irqsave(&adapter->state_lock, flags);
>> spin_lock(&adapter->rwi_lock);
>> Generated by: ./scripts/coccinelle/locks/flags.cocci
>> ./drivers/net/ethernet/ibm/ibmvnic.c:5413:1-18:
>> ERROR: nested lock+irqsave that reuses flags from line 5404.
>> Signed-off-by: Junlin Yang <yangjunlin@yulong.com>
>> ---
>>  drivers/net/ethernet/ibm/ibmvnic.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c =
b/drivers/net/ethernet/ibm/ibmvnic.c
>> index 2464c8a..a52668d 100644
>> --- a/drivers/net/ethernet/ibm/ibmvnic.c
>> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
>> @@ -5408,9 +5408,9 @@ static void ibmvnic_remove(struct vio_dev *dev)
>>  	 * after setting state, so __ibmvnic_reset() which is called
>>  	 * from the flush_work() below, can make progress.
>>  	 */
>> -	spin_lock_irqsave(&adapter->rwi_lock, flags);
>> +	spin_lock(&adapter->rwi_lock);
>>  	adapter->state =3D VNIC_REMOVING;
>> -	spin_unlock_irqrestore(&adapter->rwi_lock, flags);
>> +	spin_unlock(&adapter->rwi_lock);
>>    	spin_unlock_irqrestore(&adapter->state_lock, flags);
>> =20

