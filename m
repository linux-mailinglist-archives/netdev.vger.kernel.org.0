Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4EE46ACFCF
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 22:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbjCFVGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 16:06:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjCFVG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 16:06:27 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2FE3BDB7;
        Mon,  6 Mar 2023 13:06:20 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 326K42t6011040;
        Mon, 6 Mar 2023 21:06:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=X+l+D0wTEg1NK0XLIfd80zTd+g8fH2sBn/mflmRj/20=;
 b=B9HCWoJBBBU/K7rA2Jx3B6QUjvVXv/QuFq9gFEN8Tam1lmy/fgANGLLjb+x9geEPhPGh
 edcA6ccr0pqmR0MUmgzQydhyMYiIDmGbUjyGcq+ZYRLep4sR1WlE0HVmS3BL5AiDo0l6
 gYZtmbKYjVHKnOS/vzJm/W6MKD0WzEsFJQYjJrNDuVSiXROXtXIy+P1xg370thaP34+V
 lLTNTq+8waD5WFASTvRHgmNUqaMFkSsx4V3n38nLLz9NFikUVjOurFR06lGqMOtjCbdU
 ycPHRPE1EUM8GZXIaNOsoLNJ4rGuHWpg2qGS8XyF+pN1oa76K+CqoFIvO4aQwRxFl32e YQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p50n4fya7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Mar 2023 21:06:13 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 326KUQ4i002476;
        Mon, 6 Mar 2023 21:06:13 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p50n4fy9u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Mar 2023 21:06:13 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 326JWCmT005009;
        Mon, 6 Mar 2023 21:06:12 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([9.208.130.97])
        by ppma01wdc.us.ibm.com (PPS) with ESMTPS id 3p41847a4e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Mar 2023 21:06:12 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
        by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 326L6But46138092
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Mar 2023 21:06:11 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 387D058045;
        Mon,  6 Mar 2023 21:06:11 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 767CA58054;
        Mon,  6 Mar 2023 21:06:09 +0000 (GMT)
Received: from [9.163.94.4] (unknown [9.163.94.4])
        by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  6 Mar 2023 21:06:09 +0000 (GMT)
Message-ID: <76103587-435d-159d-98b7-0c4cbedaf62e@linux.ibm.com>
Date:   Mon, 6 Mar 2023 22:06:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH net] net/smc: fix NULL sndbuf_desc in smc_cdc_tx_handler()
To:     Alexander H Duyck <alexander.duyck@gmail.com>,
        "D. Wythe" <alibuda@linux.alibaba.com>, kgraul@linux.ibm.com,
        jaka@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <1678073786-110013-1-git-send-email-alibuda@linux.alibaba.com>
 <a4a6c3381239d1297f218c5b6d01828bac016660.camel@gmail.com>
From:   Wenjia Zhang <wenjia@linux.ibm.com>
In-Reply-To: <a4a6c3381239d1297f218c5b6d01828bac016660.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: zVbj8YPHySCY0WwmG-Xq2A6BNZSWLC2S
X-Proofpoint-GUID: tgmKc7x-4CZTWDmm1R4mUUSjvp5iNrmF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-06_14,2023-03-06_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 priorityscore=1501 clxscore=1015
 impostorscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303060183
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 06.03.23 17:38, Alexander H Duyck wrote:
> On Mon, 2023-03-06 at 11:36 +0800, D. Wythe wrote:
>> From: "D. Wythe" <alibuda@linux.alibaba.com>
>>
>> When performing a stress test on SMC-R by rmmod mlx5_ib driver
>> during the wrk/nginx test, we found that there is a probability
>> of triggering a panic while terminating all link groups.
>>
>> This issue dues to the race between smc_smcr_terminate_all()
>> and smc_buf_create().
>>
>> 			smc_smcr_terminate_all
>>
>> smc_buf_create
>> /* init */
>> conn->sndbuf_desc = NULL;
>> ...
>>
>> 			__smc_lgr_terminate
>> 				smc_conn_kill
>> 					smc_close_abort
>> 						smc_cdc_get_slot_and_msg_send
>>
>> 			__softirqentry_text_start
>> 				smc_wr_tx_process_cqe
>> 					smc_cdc_tx_handler
>> 						READ(conn->sndbuf_desc->len);
>> 						/* panic dues to NULL sndbuf_desc */
>>
>> conn->sndbuf_desc = xxx;
>>
>> This patch tries to fix the issue by always to check the sndbuf_desc
>> before send any cdc msg, to make sure that no null pointer is
>> seen during cqe processing.
>>
>> Fixes: 0b29ec643613 ("net/smc: immediate termination for SMCR link groups")
>> Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> 
> Looking at the code for __smc_buf_create it seems like you might have
> more issues hiding in the code. From what I can tell smc_buf_get_slot
> can only return a pointer or NULL but it is getting checked for being
> being a PTR_ERR or IS_ERR in several spots that are likely all dead
> code.
> 
This smc_buf_get_slot() is used to get a reusable slot, which is 
originally assigned by smcr_new_buf_create() or smcd_new_buf_create() 
depending on the device being used. In 
smcr_new_buf_create()/smcd_new_buf_create(), the pointer values of the 
return codes are converted from integer values.

>> ---
>>   net/smc/smc_cdc.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
>> index 53f63bf..2f0e2ee 100644
>> --- a/net/smc/smc_cdc.c
>> +++ b/net/smc/smc_cdc.c
>> @@ -114,6 +114,9 @@ int smc_cdc_msg_send(struct smc_connection *conn,
>>   	union smc_host_cursor cfed;
>>   	int rc;
>>   
>> +	if (unlikely(!READ_ONCE(conn->sndbuf_desc)))
>> +		return -EINVAL;
>> +
> 
> This return value doesn't seem right to me. Rather than en EINVAL
> should this be something like a ENOBUFS just to make it easier to debug
> when this issue is encountered?
I agree.
> 
>>   	smc_cdc_add_pending_send(conn, pend);
>>   
>>   	conn->tx_cdc_seq++;
> 
> 
