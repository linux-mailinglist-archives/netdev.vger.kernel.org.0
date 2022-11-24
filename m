Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D68FB637400
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 09:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbiKXIeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 03:34:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbiKXIeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 03:34:10 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF4FCB9EE;
        Thu, 24 Nov 2022 00:34:09 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AO6Jv0W002523;
        Thu, 24 Nov 2022 08:34:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=kjX0vPnlbc6fCNAC7oTEXR/N8ptimqBExRbi95RSA10=;
 b=h/GaiwdazHh4dMcfLd++R5gwmLxcv0v67fK8q2eawtjxK37b8xYgcLj93M7iy61RsYDH
 Zwdm+L/9IEpnerGarNCu24QE7yAkKIFrYPi+xsU9c8iZ7N//BmnK5U/qqPhGCsiJNVp1
 j0NuYCTn+9MZFoCKSw7qkTw1n/Bp8ax3cO2CZxWUuSLJ/Tsu8eKdIetm0D9crO80Oq0g
 La8AYDEZYdOF5qlT4sI7K7mn316yHRtcfXwYh37HmyFV3yEeU8jjGRB3NTfAYSCCVt8C
 TyJex2A8PRw7ni1RBh5lNAGen2WjvPIOJ9dOVIu+JKqYJoC6bSXDRy3O4LLc8pixxD4W LA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m100tpkuv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Nov 2022 08:34:04 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AO8K5Mo030402;
        Thu, 24 Nov 2022 08:34:03 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m100tpku7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Nov 2022 08:34:03 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AO8KRYR016739;
        Thu, 24 Nov 2022 08:34:01 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 3kxpdj5ppn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Nov 2022 08:34:01 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AO8RfhN4784798
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Nov 2022 08:27:41 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5211D11C050;
        Thu, 24 Nov 2022 08:33:58 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB03011C04C;
        Thu, 24 Nov 2022 08:33:57 +0000 (GMT)
Received: from [9.171.82.62] (unknown [9.171.82.62])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 24 Nov 2022 08:33:57 +0000 (GMT)
Message-ID: <352b1e15-3c6d-a398-3fe6-0f438e0e8406@linux.ibm.com>
Date:   Thu, 24 Nov 2022 09:33:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next v5 00/10] optimize the parallelism of SMC-R
 connections
To:     "D. Wythe" <alibuda@linux.alibaba.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <1669218890-115854-1-git-send-email-alibuda@linux.alibaba.com>
 <c98a8f04-c696-c9e0-4d7e-bc31109a0e04@linux.alibaba.com>
From:   Jan Karcher <jaka@linux.ibm.com>
Organization: IBM - Network Linux on Z
In-Reply-To: <c98a8f04-c696-c9e0-4d7e-bc31109a0e04@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CuiYKrIheu77hmaY9wbrShgjMjLfTlt7
X-Proofpoint-ORIG-GUID: ux7SYLg7iQbNC1qoO-hcMDC0KLqGIXE1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-24_05,2022-11-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 clxscore=1011 bulkscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211240067
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 24/11/2022 06:55, D. Wythe wrote:
> 
> 
> On 11/23/22 11:54 PM, D.Wythe wrote:
>> From: "D.Wythe" <alibuda@linux.alibaba.com>
>>
>> This patch set attempts to optimize the parallelism of SMC-R connections,
>> mainly to reduce unnecessary blocking on locks, and to fix exceptions 
>> that
>> occur after thoses optimization.
>>
> 
>> D. Wythe (10):
>>    net/smc: Fix potential panic dues to unprotected
>>      smc_llc_srv_add_link()
>>    net/smc: fix application data exception
>>    net/smc: fix SMC_CLC_DECL_ERR_REGRMB without smc_server_lgr_pending
>>    net/smc: remove locks smc_client_lgr_pending and
>>      smc_server_lgr_pending
>>    net/smc: allow confirm/delete rkey response deliver multiplex
>>    net/smc: make SMC_LLC_FLOW_RKEY run concurrently
>>    net/smc: llc_conf_mutex refactor, replace it with rw_semaphore
>>    net/smc: use read semaphores to reduce unnecessary blocking in
>>      smc_buf_create() & smcr_buf_unuse()
>>    net/smc: reduce unnecessary blocking in smcr_lgr_reg_rmbs()
>>    net/smc: replace mutex rmbs_lock and sndbufs_lock with rw_semaphore
>>
>>   net/smc/af_smc.c   |  74 ++++----
>>   net/smc/smc_core.c | 541 
>> +++++++++++++++++++++++++++++++++++++++++++++++------
>>   net/smc/smc_core.h |  53 +++++-
>>   net/smc/smc_llc.c  | 285 ++++++++++++++++++++--------
>>   net/smc/smc_llc.h  |   6 +
>>   net/smc/smc_wr.c   |  10 -
>>   net/smc/smc_wr.h   |  10 +
>>   7 files changed, 801 insertions(+), 178 deletions(-)
>>
> 
> Hi Jan and Wenjia,
> 
> I'm wondering whether the bug fix patches need to be put together in 
> this series. I'm considering
> sending these bug fix patches separately now, which may be better, in 
> case that our patch
> might have other problems. These bug fix patches are mainly independent, 
> even without my other
> patches, they may be triggered theoretically.

Hi D.

Wenjia and i just talked about that. For us it would be better 
separating the fixes and the new logic.
If the fixes are independent feel free to post them to net.

> 
> Of course, these bug fix patches may need to ahead before the other PATCH,
> otherwise the probability of the problems they fixed may be amplified in
> an intermediate version.

True. Thanks for pointing that out.

Thank you
- Jan
> 
> What do you think?
> 
> Best Wishes.
> D. Wythe
