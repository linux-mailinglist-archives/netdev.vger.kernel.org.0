Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDE306CD6A9
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 11:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbjC2Jl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 05:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbjC2JlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 05:41:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F7F210D;
        Wed, 29 Mar 2023 02:41:25 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32T7tOFP025376;
        Wed, 29 Mar 2023 09:41:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=YFUv0/dqFnXSvIQxyhPwEXa8WZ0jnCbBqY2yrSnzJBM=;
 b=YUeD/aYkqcGNHqkg0Nyj5uTthwecrAhWcZp6ghvMN4vsSn6nm5Lag1YVsXHT9TnhB1jO
 7jFPmeV8oXJjXk/ayCsNUMtFBASED7a3f8wuhCYIBMlUrY1ljAjRiuBPFl/yHQG8a1EJ
 TvrNEqgQrTpnG7CUADY5oN2eobef+VX2XTc7lTZjqcGSmGW64MjMDyS+crN6Q8ro4Sov
 TBmBGcX8DDaR0ZM+jBd2B+tf9xlnsHJt7/B1YssjN7F52Q7A/Ot/yNMH4uds919NPiHa
 S8+7hISIBxMwf3xKy3XYL7tKxRHftdJUNS9b5OH2BVPuigg5MislMit3lb8BB35BUUbR PQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pmhc7akq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Mar 2023 09:41:15 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32T8evQT026364;
        Wed, 29 Mar 2023 09:41:15 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pmhc7akpu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Mar 2023 09:41:15 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32T79YoL003277;
        Wed, 29 Mar 2023 09:41:14 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([9.208.130.99])
        by ppma05wdc.us.ibm.com (PPS) with ESMTPS id 3phrk7dqhy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Mar 2023 09:41:14 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
        by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32T9fD5P36176532
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Mar 2023 09:41:13 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 132AE5805C;
        Wed, 29 Mar 2023 09:41:13 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E3EC58051;
        Wed, 29 Mar 2023 09:41:11 +0000 (GMT)
Received: from [9.211.125.247] (unknown [9.211.125.247])
        by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 29 Mar 2023 09:41:11 +0000 (GMT)
Message-ID: <df825d71-eb6d-ac73-7f7f-33277fde6b12@linux.ibm.com>
Date:   Wed, 29 Mar 2023 11:41:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH net-next] net/smc: introduce shadow sockets for fallback
 connections
To:     Kai <KaiShen@linux.alibaba.com>, kgraul@linux.ibm.com,
        jaka@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        dsahern@kernel.org
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
References: <20230321071959.87786-1-KaiShen@linux.alibaba.com>
 <170b35d9-2071-caf3-094e-6abfb7cefa75@linux.ibm.com>
 <7fa69883-9af5-4b2a-7853-9697ff30beba@linux.alibaba.com>
From:   Wenjia Zhang <wenjia@linux.ibm.com>
In-Reply-To: <7fa69883-9af5-4b2a-7853-9697ff30beba@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: uw_8AnXQi01daLOu1Y2kLZWwD6n4vETg
X-Proofpoint-GUID: jzXDfjbxp84PT191v_xeOarzFTTenKDH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-29_03,2023-03-28_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 phishscore=0 mlxscore=0 suspectscore=0 adultscore=0
 mlxlogscore=999 lowpriorityscore=0 malwarescore=0 impostorscore=0
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303290079
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org




On 24.03.23 08:26, Kai wrote:
> 
> 
> On 3/23/23 1:09 AM, Wenjia Zhang wrote:
>>
>>
>> On 21.03.23 08:19, Kai Shen wrote:
>>> SMC-R performs not so well on fallback situations right now,
>>> especially on short link server fallback occasions. We are planning
>>> to make SMC-R widely used and handling this fallback performance
>>> issue is really crucial to us. Here we introduce a shadow socket
>>> method to try to relief this problem.
>>>
>> Could you please elaborate the problem?
> 
> Here is the background. We are using SMC-R to accelerate server-client 
> applications by using SMC-R on server side, but not all clients use 
> SMC-R. So in these occasions we hope that the clients using SMC-R get 
> acceleration while the clients that fallback to TCP will get the 
> performance no worse than TCP.

I'm wondering how the usecase works? How are the server-client 
applications get accelerated by using SMC-R? If your case rely on the 
fallback, why don't use TCP/IP directly?

> What's more, in short link scenario we may use fallback on purpose for
> SMC-R perform badly with its highly cost connection establishing path.
> So it is very important that SMC-R perform similarly as TCP on fallback 
> occasions since we use SMC-R as a acceleration method and performance 
> compromising should not happen when user use TCP client to connect a 
> SMC-R server.
> In our tests, fallback SMC-R accepting path on server-side contribute to 
> the performance gap compared to TCP a lot as mentioned in the patch and 
> we are trying to solve this problem.
> 
>>
>> Generally, I don't have a good feeling about the two non-listenning 
>> sockets, and I can not see why it is necessary to introduce the socket 
>> actsock instead of using the clcsock itself. Maybe you can convince me 
>> with a good reason.
>>
> First let me explain why we use two sockets here.
> We want the fallback accept path to be similar as TCP so all the 
> fallback connection requests should go to the fallback sock(accept 
> queue) and go a shorter path (bypass tcp_listen_work) while clcsock 
> contains both requests with syn_smc and fallback requests. So we pick 
> requests with syn_smc to actsock and fallback requests to fbsock.
> I think it is the right strategy that we have two queues for two types 
> of incoming requests (which will lead to good performance too).
> On the other hand, the implementation of this strategy is worth discussing.
> As Paolo said, in this implementation only the shadow socket's receive 
> queue is needed. I use this two non-listenning sockets for these 
> following reasons.
> 1. If we implement a custom accept, some of the symbols are not 
> accessible since they are not exported(like mem_cgroup_charge_skmem).
> 2. Here we reuse the accept path of TCP so that the future update of TCP
> may not lead to problems caused by the difference between the custom 
> accept and future TCP accept.
> 3. SMC-R is trying to behave like TCP and if we implement custom accept, 
> there may be repeated code and looks not cool.
> 
> Well, i think two queues is the right strategy but I am not so sure 
> about which implement is better and we really want to solve this 
> problem. Please give advice.
> 
>>> +static inline bool tcp_reqsk_queue_empty(struct sock *sk)
>>> +{
>>> +    struct inet_connection_sock *icsk = inet_csk(sk);
>>> +    struct request_sock_queue *queue = &icsk->icsk_accept_queue;
>>> +
>>> +    return reqsk_queue_empty(queue);
>>> +}
>>> +
>> Since this is only used by smc, I'd like to suggest to use 
>> smc_tcp_reqsk_queue_empty instead of tcp_reqsk_queue_empty.
>>
> Will do.
> 
> Thanks
> 
> Kai
