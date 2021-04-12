Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79AAE35CC94
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243355AbhDLQaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:30:25 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39120 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244744AbhDLQ2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 12:28:20 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13CG4lOl158759;
        Mon, 12 Apr 2021 12:28:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version :
 content-type : content-transfer-encoding : date : from : to : cc : subject
 : in-reply-to : references : message-id; s=pp1;
 bh=dnQqFAHRVXNxYeT6RlLZGYhqjuMe3QZ2G4YmSbqa9Hw=;
 b=MD2G26DvywaO4Y2UpYuQqiHOBO+XfMmlQkHYSV1YKlQXLmmD1lzitFaCqlIR1h0U0daH
 WtvHqQx9JdSBdaoC4PeiQOf3qTYDD7SM/JtEaYUBsKMl0Z0KMPPAiX5uCneA44kHRjKa
 FDdweCll6XEwz6kKdodfJEj5Q9I4oFdZ9lTBqML52tHlUbjvKTaW3eEgIEGEoKv4QH+4
 biDAQeQZQ8dJXyICm1A325T0blPDYIhaFae3RnyRESJgAK4aRg5VX/O5PCI5KS1r7H54
 7GXlq1vH0zllO9R6Rp4seJYiY/PyggIIGpC/QHcL+bfu3GbQ3Ps40383wA1SO8G5TSx5 UA== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37uska34u2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 12:28:00 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13CGRsmB023732;
        Mon, 12 Apr 2021 16:27:59 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma04wdc.us.ibm.com with ESMTP id 37u3n9sjqj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 16:27:59 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13CGRxnU29950232
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 16:27:59 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 66CC8112064;
        Mon, 12 Apr 2021 16:27:59 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 168AF112061;
        Mon, 12 Apr 2021 16:27:59 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.10.229.42])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 12 Apr 2021 16:27:58 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Mon, 12 Apr 2021 09:27:58 -0700
From:   Dany Madden <drt@linux.ibm.com>
To:     Lijun Pan <ljp@linux.vnet.ibm.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Rick Lindsley <ricklind@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Subject: Re: [PATCH] ibmvnic: Continue with reset if set link down failed
In-Reply-To: <7202f51714ce5a1ce334f5078b2374f3@imap.linux.ibm.com>
References: <20210406034752.12840-1-drt@linux.ibm.com>
 <D8B915A0-CCBE-4F45-A59C-E6536355F3DC@linux.vnet.ibm.com>
 <7202f51714ce5a1ce334f5078b2374f3@imap.linux.ibm.com>
Message-ID: <54b10b6b08cc1fa40a070b31be43816a@imap.linux.ibm.com>
X-Sender: drt@linux.ibm.com
User-Agent: Roundcube Webmail/1.1.12
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Itx1SuT8q1L8kMaUpWbAuBMEGQpw76Zi
X-Proofpoint-GUID: Itx1SuT8q1L8kMaUpWbAuBMEGQpw76Zi
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-12_11:2021-04-12,2021-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 malwarescore=0 impostorscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=999 phishscore=0 lowpriorityscore=0 spamscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104120102
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-04-07 12:03, Dany Madden wrote:
> On 2021-04-05 23:46, Lijun Pan wrote:
>>> On Apr 5, 2021, at 10:47 PM, Dany Madden <drt@linux.ibm.com> wrote:
>>> 
>>> When an adapter is going thru a reset, it maybe in an unstable state 
>>> that
>>> makes a request to set link down fail. In such a case, the adapter 
>>> needs
>>> to continue on with reset to bring itself back to a stable state.
>>> 
>>> Fixes: ed651a10875f ("ibmvnic: Updated reset handling")
>>> Signed-off-by: Dany Madden <drt@linux.ibm.com>
>>> ---
>>> drivers/net/ethernet/ibm/ibmvnic.c | 6 ++++--
>>> 1 file changed, 4 insertions(+), 2 deletions(-)
>>> 
>>> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c 
>>> b/drivers/net/ethernet/ibm/ibmvnic.c
>>> index 9c6438d3b3a5..e4f01a7099a0 100644
>>> --- a/drivers/net/ethernet/ibm/ibmvnic.c
>>> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
>>> @@ -1976,8 +1976,10 @@ static int do_reset(struct ibmvnic_adapter 
>>> *adapter,
>>> 			rtnl_unlock();
>>> 			rc = set_link_state(adapter, IBMVNIC_LOGICAL_LNK_DN);
>>> 			rtnl_lock();
>>> -			if (rc)
>>> -				goto out;
>>> +			if (rc) {
>>> +				netdev_dbg(netdev,
>>> +					   "Setting link down failed rc=%d. Continue anyway\n", rc);
>>> +			}
>> 
>> What’s the point of checking the return code if it can be neglected 
>> anyway?
>> If we really don’t care if set_link_state succeeds or not, we don’t
>> even need to call
>> set_link_state() here.
>> It seems more correct to me that we find out why set_link_state fails
>> and fix it from that end.
> 
> We know why set link state failed. CRQ is no longer active at this
> point. It is not possible to send a link down request to the VIOS. If
> driver exits here, adapter will be left in an inoperable state. If it
> continues to reinitialize the crq, it can continue to reset and come
> up.
> 
> Prior to submitting this patch, we ran a 17-hour and a 24-hour tests
> (LPM+failover) on 10 vnics. We saw that: 
> 
> 17 hours, hit 4 times
> - 3 times driver is able to continue on to re-init CRQ and continue on
> to bring the adapter up.
> - 1 time driver failed to re-init CRQ due to the last reset failed and
> released the CRQ. Subsequent hard reset from a transport event
> (failover) succeeded.
> 
> 24 hours, hit 10 times
> - 7 times driver is able to continue on to re-init CRQ and continue to
> bring the adapter up.
> - 3 times driver failed to init CRQ due to the last reset failed and
> released the CRQ. Subsequent hard reset from a transport event
> (failover or lpm) succeed.
> 
> In both runs, with the patch, 10 vnics continue to work as expected.

Is there anything else that we need to address before this is accepted?

Dany

> 
>> 
>> Lijun
>> 
>>> 
>>> 			if (adapter->state == VNIC_OPEN) {
>>> 				/* When we dropped rtnl, ibmvnic_open() got
>>> --
>>> 2.26.2
>>> 
