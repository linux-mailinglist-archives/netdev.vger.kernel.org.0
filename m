Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F84A354D17
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 08:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237503AbhDFGqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 02:46:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30212 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234317AbhDFGql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 02:46:41 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1366YKKP086164;
        Tue, 6 Apr 2021 02:46:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to; s=pp1;
 bh=Da+ljZnBTLUDl3w+ch76gqnXLfVvopLquigfHEQbjeM=;
 b=WVn+UYehDA/Xv3iAUz/zeXgr++lUvfV4TAEepm/sqKSbsI7gAhWHRS3pHk1HwtDkzMQe
 sXuikBsy8AhYnSTwSiV1VP2T8C2S69Z+kTbbI/8vYm61hnWw43CbIoSewIEi/kOpzX5T
 glIW+Lw/a7HbUt8/u6OCK8q0a5+SbAA3g5EbLVm/NaLA3D+wmbFYSiy9/F4vJluycwJz
 B0bda56EoChQLTJ+jMyoycjjVeJS+snHb0/Q4F8o5MX0ORCD4arfOpd5SF7K7uVqV34Z
 MUvL24ZFbkkBYw+q6tRwEfDfy2e9b4skbCAUyw8XAtkM5NFDvKh9h74RY0tvoN40B9tk 6A== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37q6050phb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 02:46:31 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 1366bdBe022225;
        Tue, 6 Apr 2021 06:46:31 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02wdc.us.ibm.com with ESMTP id 37q32mdu03-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 06:46:31 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1366kRQb25887224
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Apr 2021 06:46:27 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4404678066;
        Tue,  6 Apr 2021 06:46:27 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 847E87805C;
        Tue,  6 Apr 2021 06:46:26 +0000 (GMT)
Received: from [9.85.130.85] (unknown [9.85.130.85])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Tue,  6 Apr 2021 06:46:26 +0000 (GMT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH] ibmvnic: Continue with reset if set link down failed
From:   Lijun Pan <ljp@linux.vnet.ibm.com>
In-Reply-To: <20210406034752.12840-1-drt@linux.ibm.com>
Date:   Tue, 6 Apr 2021 01:46:24 -0500
Cc:     David Miller <davem@davemloft.net>,
        Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <D8B915A0-CCBE-4F45-A59C-E6536355F3DC@linux.vnet.ibm.com>
References: <20210406034752.12840-1-drt@linux.ibm.com>
To:     netdev@vger.kernel.org
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: N70xbTnpC0KTuag33HyTnnT2YzieK9hC
X-Proofpoint-GUID: N70xbTnpC0KTuag33HyTnnT2YzieK9hC
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-06_01:2021-04-01,2021-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 adultscore=0 suspectscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104060045
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 5, 2021, at 10:47 PM, Dany Madden <drt@linux.ibm.com> wrote:
>=20
> When an adapter is going thru a reset, it maybe in an unstable state =
that
> makes a request to set link down fail. In such a case, the adapter =
needs
> to continue on with reset to bring itself back to a stable state.
>=20
> Fixes: ed651a10875f ("ibmvnic: Updated reset handling")
> Signed-off-by: Dany Madden <drt@linux.ibm.com>
> ---
> drivers/net/ethernet/ibm/ibmvnic.c | 6 ++++--
> 1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c =
b/drivers/net/ethernet/ibm/ibmvnic.c
> index 9c6438d3b3a5..e4f01a7099a0 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -1976,8 +1976,10 @@ static int do_reset(struct ibmvnic_adapter =
*adapter,
> 			rtnl_unlock();
> 			rc =3D set_link_state(adapter, =
IBMVNIC_LOGICAL_LNK_DN);
> 			rtnl_lock();
> -			if (rc)
> -				goto out;
> +			if (rc) {
> +				netdev_dbg(netdev,
> +					   "Setting link down failed =
rc=3D%d. Continue anyway\n", rc);
> +			}

What=E2=80=99s the point of checking the return code if it can be =
neglected anyway?
If we really don=E2=80=99t care if set_link_state succeeds or not, we =
don=E2=80=99t even need to call
set_link_state() here.
It seems more correct to me that we find out why set_link_state fails =
and fix it from that end.

Lijun

>=20
> 			if (adapter->state =3D=3D VNIC_OPEN) {
> 				/* When we dropped rtnl, ibmvnic_open() =
got
> --=20
> 2.26.2
>=20

