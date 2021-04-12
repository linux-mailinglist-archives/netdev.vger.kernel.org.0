Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05ACD35CC50
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244709AbhDLQ2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:28:10 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23952 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S244428AbhDLQZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 12:25:57 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13CG4iO3000697;
        Mon, 12 Apr 2021 12:25:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version :
 content-type : content-transfer-encoding : date : from : to : cc : subject
 : in-reply-to : references : message-id; s=pp1;
 bh=rkWKF4eOspdKjuwBMEK4vGrF2P4PiC1zhQfvVsWE1+I=;
 b=XlWq3J2PLSrCtbQT9Cz/2tpKxqrxDEdlBpzGp9kd7v8qMEbEQGWJtHMxX5niHIklMwav
 ejWrL1QPxHsV9xjETynIBhZ14hzxt6/BTSG0R+LABcW3RBr7P32ZeLmyNOzsMjovmlDB
 G0YQmTQS8BjHCFywXxYdQ05WwmT8gXIKREkjq4+ByPKP2jP553kTEZNrEliEH5wLm+PV
 AYh3ohTC1Loy/977hzph8Wmk79rGL5FHZVGFcz/ub5H39IzHcQQY+uvIGxAX4zpUjJOP
 8htHdDaGbifVg49Ym65QHGcm7PhKob/WLkiY8Y6j0sNLFyvTn5NnVQhsMayg+sFbewPB Qg== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37vn53axw3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 12:25:37 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13CGMvVf024675;
        Mon, 12 Apr 2021 16:25:36 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma03dal.us.ibm.com with ESMTP id 37u3n8wxns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 16:25:36 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13CGPZGI29098384
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 16:25:35 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72D25B2064;
        Mon, 12 Apr 2021 16:25:35 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1BE3EB205F;
        Mon, 12 Apr 2021 16:25:35 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.10.229.42])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 12 Apr 2021 16:25:34 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Mon, 12 Apr 2021 09:25:34 -0700
From:   Dany Madden <drt@linux.ibm.com>
To:     Lijun Pan <ljp@linux.vnet.ibm.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Rick Lindsley <ricklind@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Subject: Re: [PATCH] ibmvnic: Continue with reset if set link down failed
In-Reply-To: <D8B915A0-CCBE-4F45-A59C-E6536355F3DC@linux.vnet.ibm.com>
References: <20210406034752.12840-1-drt@linux.ibm.com>
 <D8B915A0-CCBE-4F45-A59C-E6536355F3DC@linux.vnet.ibm.com>
Message-ID: <c9b9eab726fda392d05f8e56fd2ccb11@imap.linux.ibm.com>
X-Sender: drt@linux.ibm.com
User-Agent: Roundcube Webmail/1.1.12
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: m11Iz0xs7imGpJdxeXVIzsg_AaTasu5Q
X-Proofpoint-GUID: m11Iz0xs7imGpJdxeXVIzsg_AaTasu5Q
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-12_11:2021-04-12,2021-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 suspectscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015
 impostorscore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104120102
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-04-05 23:46, Lijun Pan wrote:
>> On Apr 5, 2021, at 10:47 PM, Dany Madden <drt@linux.ibm.com> wrote:
>> 
>> When an adapter is going thru a reset, it maybe in an unstable state 
>> that
>> makes a request to set link down fail. In such a case, the adapter 
>> needs
>> to continue on with reset to bring itself back to a stable state.
>> 
>> Fixes: ed651a10875f ("ibmvnic: Updated reset handling")
>> Signed-off-by: Dany Madden <drt@linux.ibm.com>
>> ---
>> drivers/net/ethernet/ibm/ibmvnic.c | 6 ++++--
>> 1 file changed, 4 insertions(+), 2 deletions(-)
>> 
>> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c 
>> b/drivers/net/ethernet/ibm/ibmvnic.c
>> index 9c6438d3b3a5..e4f01a7099a0 100644
>> --- a/drivers/net/ethernet/ibm/ibmvnic.c
>> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
>> @@ -1976,8 +1976,10 @@ static int do_reset(struct ibmvnic_adapter 
>> *adapter,
>> 			rtnl_unlock();
>> 			rc = set_link_state(adapter, IBMVNIC_LOGICAL_LNK_DN);
>> 			rtnl_lock();
>> -			if (rc)
>> -				goto out;
>> +			if (rc) {
>> +				netdev_dbg(netdev,
>> +					   "Setting link down failed rc=%d. Continue anyway\n", rc);
>> +			}
> 
> What’s the point of checking the return code if it can be neglected 
> anyway?
> If we really don’t care if set_link_state succeeds or not, we don’t
> even need to call
> set_link_state() here.
> It seems more correct to me that we find out why set_link_state fails
> and fix it from that end.
> 
> Lijun
> 
>> 
>> 			if (adapter->state == VNIC_OPEN) {
>> 				/* When we dropped rtnl, ibmvnic_open() got
>> --
>> 2.26.2
>> 
