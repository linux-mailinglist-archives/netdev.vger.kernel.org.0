Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 340204B4D07
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 12:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244169AbiBNLCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 06:02:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349575AbiBNLCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 06:02:00 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E837696808;
        Mon, 14 Feb 2022 02:29:19 -0800 (PST)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21E9kEFE019148;
        Mon, 14 Feb 2022 10:29:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=46RG0QWh1DhR7P7jCSUdqoGwvQntUIQLpqiCssaPJTk=;
 b=thL1hIsXJutsT31MQ3DyJWjflWOHDv1aDmYn/ej/tdMz4b4wg1T1fLB4ugkIkktiDOy5
 FkoOhHGg/gaBmk5mwHwQAOaD1xzV1WO44Pzkth08gakBbWPEsVeYcZqd7SpQFHtM/Ohu
 uYDALnjyT5SCR0YM8Hujv2MwHn0RWtgjRbamvTcd8UiD7x28nBhEUxk5HBcuUGfmgpV3
 yIHxwM6SHAxgoh1IgyVZBP3HALXu8lhTTOaY+PG7ILlRIL4/7t3ZAw1LFKI55AIO98MW
 IFAQ1ZiGQoRfK8y7qYIKhS9k5xsJKtLgcgoABVjV+wurh/R8X2hOlCqoh1I5svS/vJ+/ /g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e71jvm0xd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 10:29:17 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21E9GIvK022239;
        Mon, 14 Feb 2022 10:29:16 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e71jvm0wh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 10:29:16 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21EAHen3007376;
        Mon, 14 Feb 2022 10:29:13 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3e64h9kwf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 10:29:13 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21EATBpK47186332
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Feb 2022 10:29:11 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F01A45205A;
        Mon, 14 Feb 2022 10:29:10 +0000 (GMT)
Received: from [9.171.10.166] (unknown [9.171.10.166])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id ABE1952050;
        Mon, 14 Feb 2022 10:29:10 +0000 (GMT)
Message-ID: <f4166712-9a1e-51a0-409d-b7df25a66c52@linux.ibm.com>
Date:   Mon, 14 Feb 2022 11:29:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH net-next 2/3] net/smc: Remove corked dealyed work
Content-Language: en-US
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org
References: <20220130180256.28303-1-tonylu@linux.alibaba.com>
 <20220130180256.28303-3-tonylu@linux.alibaba.com>
 <becbfd54-5a42-9867-f3ac-b347b561985f@linux.ibm.com>
 <YgYn6jA0i3pFXoCS@TonyMac-Alibaba>
From:   Stefan Raspl <raspl@linux.ibm.com>
In-Reply-To: <YgYn6jA0i3pFXoCS@TonyMac-Alibaba>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MgXhtH8TF6WXmobEeccI-UguzsIqt2gb
X-Proofpoint-GUID: OAsIQhw47ec9LnOVeeP9H2G1Xn0Gy82N
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-14_01,2022-02-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 bulkscore=0 clxscore=1015 spamscore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202140058
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/11/22 10:10, Tony Lu wrote:
> On Mon, Jan 31, 2022 at 08:40:47PM +0100, Stefan Raspl wrote:
>> On 1/30/22 19:02, Tony Lu wrote:
>>> Based on the manual of TCP_CORK [1] and MSG_MORE [2], these two options
>>> have the same effect. Applications can set these options and informs the
>>> kernel to pend the data, and send them out only when the socket or
>>> syscall does not specify this flag. In other words, there's no need to
>>> send data out by a delayed work, which will queue a lot of work.
>>>
>>> This removes corked delayed work with SMC_TX_CORK_DELAY (250ms), and the
>>> applications control how/when to send them out. It improves the
>>> performance for sendfile and throughput, and remove unnecessary race of
>>> lock_sock(). This also unlocks the limitation of sndbuf, and try to fill
>>> it up before sending.
>>>
>>> [1] https://linux.die.net/man/7/tcp
>>> [2] https://man7.org/linux/man-pages/man2/send.2.html
>>>
>>> Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
>>> ---
>>>    net/smc/smc_tx.c | 15 ++++++---------
>>>    1 file changed, 6 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
>>> index 7b0b6e24582f..9cec62cae7cb 100644
>>> --- a/net/smc/smc_tx.c
>>> +++ b/net/smc/smc_tx.c
>>> @@ -31,7 +31,6 @@
>>>    #include "smc_tracepoint.h"
>>>    #define SMC_TX_WORK_DELAY	0
>>> -#define SMC_TX_CORK_DELAY	(HZ >> 2)	/* 250 ms */
>>>    /***************************** sndbuf producer *******************************/
>>> @@ -237,15 +236,13 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
>>>    		if ((msg->msg_flags & MSG_OOB) && !send_remaining)
>>>    			conn->urg_tx_pend = true;
>>>    		if ((msg->msg_flags & MSG_MORE || smc_tx_is_corked(smc)) &&
>>> -		    (atomic_read(&conn->sndbuf_space) >
>>> -						(conn->sndbuf_desc->len >> 1)))
>>> -			/* for a corked socket defer the RDMA writes if there
>>> -			 * is still sufficient sndbuf_space available
>>> +		    (atomic_read(&conn->sndbuf_space)))
>>> +			/* for a corked socket defer the RDMA writes if
>>> +			 * sndbuf_space is still available. The applications
>>> +			 * should known how/when to uncork it.
>>>    			 */
>>> -			queue_delayed_work(conn->lgr->tx_wq, &conn->tx_work,
>>> -					   SMC_TX_CORK_DELAY);
>>> -		else
>>> -			smc_tx_sndbuf_nonempty(conn);
>>> +			continue;
>>
>> In case we just corked the final bytes in this call, wouldn't this
>> 'continue' prevent us from accounting the Bytes that we just staged to be
>> sent out later in the trace_smc_tx_sendmsg() call below?
>>
>>> +		smc_tx_sndbuf_nonempty(conn);
>>>    		trace_smc_tx_sendmsg(smc, copylen);
>>
> 
> If the application send out the final bytes in this call, the
> application should also clear MSG_MORE or TCP_CORK flag, this action is
> required based on the manuals [1] and [2]. So it is safe to cork the data
> if flag is setted, and continue to the next loop until application
> clears the flag.

Yes, I understand. But trace_smc_tx_sendmsg(smc, copylen) should be called for 
each portion of data that we transmit, i.e. each time we run through this loop. 
That is because parameter copylen is reset during each iteration.
Now your patch adds a 'continue', which prevents that trace_smc_tc... call from 
being made. Which means the information that 'copylen' Bytes were transferred is 
lost forever, and the accounting of tx Bytes is off by 'copylen' Bytes, I believe!

Ciao,
Stefan
