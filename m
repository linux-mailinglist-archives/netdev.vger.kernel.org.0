Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 232B73574C0
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 21:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355536AbhDGTDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 15:03:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38058 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242414AbhDGTD3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 15:03:29 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 137IY38p176943;
        Wed, 7 Apr 2021 15:03:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version :
 content-type : content-transfer-encoding : date : from : to : cc : subject
 : in-reply-to : references : message-id; s=pp1;
 bh=vUtCz6BSzMYEx5gsTVhYI55rp1C3Eh8a7knaqiVaFsQ=;
 b=p14tF6MNJbH201yTvgjA9c271q6VwB110aRxxC2yyl7XT2plE7C7VomsgBhTegq8WzuV
 yc+3z3OITdJoTkvfGU6Qb3InfhvYIHlGuvp/64cb71CJOvnZ2hBWKkrvRAZdToJqidsP
 LPZ0SbaGW5lwHFbFYhLD92tr10SbkuabN48zK/WHy8Nbs42a70XATW4Xo1UP6+GBkqK6
 o98qZ0E+37+j0oyfnLJszLJ2uJUDzSIQCPo6WFfr3M9p7dyAl4LT64ONaVlK+4n4LhqS
 AGUm31NIma7YunfnW3Z39LJ0Q7x5QtZmJGG7eAPvtDCKquiLH9uFHY36LwZdVHm5vFPH 5g== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37rvpgjwee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Apr 2021 15:03:17 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 137J2Xd9017441;
        Wed, 7 Apr 2021 19:03:16 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma03dal.us.ibm.com with ESMTP id 37rvc2hjg2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Apr 2021 19:03:16 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 137J3G7L24904104
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Apr 2021 19:03:16 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1E87F112062;
        Wed,  7 Apr 2021 19:03:16 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE355112061;
        Wed,  7 Apr 2021 19:03:15 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.10.229.42])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  7 Apr 2021 19:03:15 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Wed, 07 Apr 2021 12:03:15 -0700
From:   Dany Madden <drt@linux.ibm.com>
To:     Lijun Pan <ljp@linux.vnet.ibm.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Rick Lindsley <ricklind@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Subject: Re: [PATCH] ibmvnic: Continue with reset if set link down failed
In-Reply-To: <D8B915A0-CCBE-4F45-A59C-E6536355F3DC@linux.vnet.ibm.com>
References: <20210406034752.12840-1-drt@linux.ibm.com>
 <D8B915A0-CCBE-4F45-A59C-E6536355F3DC@linux.vnet.ibm.com>
Message-ID: <7202f51714ce5a1ce334f5078b2374f3@imap.linux.ibm.com>
X-Sender: drt@linux.ibm.com
User-Agent: Roundcube Webmail/1.1.12
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: j1tJZUJ0b56x9nBHijuvjYMVSo3c9Gy2
X-Proofpoint-GUID: j1tJZUJ0b56x9nBHijuvjYMVSo3c9Gy2
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-07_10:2021-04-07,2021-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 priorityscore=1501 clxscore=1015 malwarescore=0
 suspectscore=0 bulkscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0
 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104070127
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

We know why set link state failed. CRQ is no longer active at this 
point. It is not possible to send a link down request to the VIOS. If 
driver exits here, adapter will be left in an inoperable state. If it 
continues to reinitialize the crq, it can continue to reset and come up.

Prior to submitting this patch, we ran a 17-hour and a 24-hour tests 
(LPM+failover) on 10 vnics. We saw that: 

17 hours, hit 4 times
- 3 times driver is able to continue on to re-init CRQ and continue on 
to bring the adapter up.
- 1 time driver failed to re-init CRQ due to the last reset failed and 
released the CRQ. Subsequent hard reset from a transport event 
(failover) succeeded.

24 hours, hit 10 times
- 7 times driver is able to continue on to re-init CRQ and continue to 
bring the adapter up.
- 3 times driver failed to init CRQ due to the last reset failed and 
released the CRQ. Subsequent hard reset from a transport event (failover 
or lpm) succeed.

In both runs, with the patch, 10 vnics continue to work as expected.

> 
> Lijun
> 
>> 
>> 			if (adapter->state == VNIC_OPEN) {
>> 				/* When we dropped rtnl, ibmvnic_open() got
>> --
>> 2.26.2
>> 
