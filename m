Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C59A739927A
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 20:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbhFBSYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 14:24:51 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43462 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229489AbhFBSYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 14:24:51 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 152IJ135189642
        for <netdev@vger.kernel.org>; Wed, 2 Jun 2021 14:23:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type : date :
 from : to : cc : subject : in-reply-to : references : message-id :
 content-transfer-encoding : mime-version; s=pp1;
 bh=M696bEyUInuxSbgkUw+QRJv4TeXDFKY2Jdn+U8Uclw4=;
 b=omyAJJPqvdBCWLdI7ofINpr+24vBhlHzw9ao4FHjLwwD2OHgI6gL6JIxgMXBEwPnbxUR
 veS8Sbf4/Z4+5J4kC+Wm+D5eN8H+OGeV4tuRM0QQUNieTBL6huI0zbp7ZWVKp794r+fZ
 rNO1/EezFUrTg3nminI99EsZS0lILw2kOKn5Us58ydRLXZRCgx8cQQEd2e4eyirquAaS
 0/2s5HLEMPQOewXuQ8tv5BBn3yJbVcN25uwmCbTlXptqnksIxWFWhvhWUxw8Zu9C+WIh
 LqXv4KtnT4a3ZwhsSdsbj2I1kLQyEB7svDnYzzWVCwkHHPPP/SnJc8Nmi8GQW930JdPa 8w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38xdtttenp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 14:23:07 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 152IK2L7195419
        for <netdev@vger.kernel.org>; Wed, 2 Jun 2021 14:23:07 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38xdtttemt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Jun 2021 14:23:07 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 152IDKPk018269;
        Wed, 2 Jun 2021 18:23:06 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma05wdc.us.ibm.com with ESMTP id 38ud899ne7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Jun 2021 18:23:05 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 152IN54812976412
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Jun 2021 18:23:05 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09C107805F;
        Wed,  2 Jun 2021 18:23:05 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C34FA78060;
        Wed,  2 Jun 2021 18:23:04 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.10.229.42])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  2 Jun 2021 18:23:04 +0000 (GMT)
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date:   Wed, 02 Jun 2021 11:23:04 -0700
From:   Dany Madden <drt@linux.ibm.com>
To:     Lijun Pan <lijunp213@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: ibm: replenish rx pool and poll less
 frequently
In-Reply-To: <4765c54a8cb7b87ae1d7db928c44f40b@imap.linux.ibm.com>
References: <20210602170156.41643-1-lijunp213@gmail.com>
 <4765c54a8cb7b87ae1d7db928c44f40b@imap.linux.ibm.com>
Message-ID: <a85942b56e72cae74d23bd8ab379490e@imap.linux.ibm.com>
X-Sender: drt@linux.ibm.com
User-Agent: Roundcube Webmail/1.1.12
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3haBcDMnLQNsMCxVtTBKhHs18p51hZuo
X-Proofpoint-ORIG-GUID: N_muTg3xiOIS7KUp_pC6iY8fHN9wAcK9
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-02_10:2021-06-02,2021-06-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 priorityscore=1501 mlxscore=0
 mlxlogscore=750 clxscore=1015 impostorscore=0 adultscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106020115
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-06-02 10:58, Dany Madden wrote:
> On 2021-06-02 10:01, Lijun Pan wrote:
>> The old mechanism replenishes rx pool even only one frames is 
>> processed in
>> the poll function, which causes lots of overheads. The old mechanism
>> restarts polling until processed frames reaches the budget, which can
>> cause the poll function to loop into restart_poll 63 times at most and 
>> to
>> call replenish_rx_poll 63 times at most. This will cause soft lockup 
>> very
>> easily. So, don't replenish too often, and don't goto restart_poll in 
>> each
>> poll function. If there are pending descriptors, fetch them in the 
>> next
>> poll instance.
> 
> Does this improve performance?
> 
>> 
>> Signed-off-by: Lijun Pan <lijunp213@gmail.com>
>> ---
>>  drivers/net/ethernet/ibm/ibmvnic.c | 15 +++------------
>>  1 file changed, 3 insertions(+), 12 deletions(-)
>> 
>> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c
>> b/drivers/net/ethernet/ibm/ibmvnic.c
>> index ffb2a91750c7..fae1eaa39dd0 100644
>> --- a/drivers/net/ethernet/ibm/ibmvnic.c
>> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
>> @@ -2435,7 +2435,6 @@ static int ibmvnic_poll(struct napi_struct
>> *napi, int budget)
>>  	frames_processed = 0;
>>  	rx_scrq = adapter->rx_scrq[scrq_num];
>> 
>> -restart_poll:
>>  	while (frames_processed < budget) {
>>  		struct sk_buff *skb;
>>  		struct ibmvnic_rx_buff *rx_buff;
>> @@ -2512,20 +2511,12 @@ static int ibmvnic_poll(struct napi_struct
>> *napi, int budget)
>>  	}
>> 
>>  	if (adapter->state != VNIC_CLOSING &&
>> -	    ((atomic_read(&adapter->rx_pool[scrq_num].available) <
>> -	      adapter->req_rx_add_entries_per_subcrq / 2) ||
>> -	      frames_processed < budget))
> 
> There is a budget that the driver should adhere to. Even one frame, it
> should still process the frame within a budget.
I meant it should replenish the buffer because the commit that added 
this check, 
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=41ed0a00ffcd903ece4304a4a65d95706115ffcb, 
stated that low frame_processed means low incoming packets, so use the 
time to refill the buffers.

So, it would be good to see some numbers of how this change is doing in 
comparison to the code before.

> 
>> +	    (atomic_read(&adapter->rx_pool[scrq_num].available) <
>> +	      adapter->req_rx_add_entries_per_subcrq / 2))
>>  		replenish_rx_pool(adapter, &adapter->rx_pool[scrq_num]);
>>  	if (frames_processed < budget) {
>> -		if (napi_complete_done(napi, frames_processed)) {
>> +		if (napi_complete_done(napi, frames_processed))
>>  			enable_scrq_irq(adapter, rx_scrq);
>> -			if (pending_scrq(adapter, rx_scrq)) {
>> -				if (napi_reschedule(napi)) {
>> -					disable_scrq_irq(adapter, rx_scrq);
>> -					goto restart_poll;
>> -				}
>> -			}
>> -		}
>>  	}
>>  	return frames_processed;
>>  }
