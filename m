Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2996C57518D
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 17:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239628AbiGNPRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 11:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232135AbiGNPRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 11:17:03 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 080AD459AB;
        Thu, 14 Jul 2022 08:17:02 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26EEwjhX024972;
        Thu, 14 Jul 2022 15:16:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=TDDaVybad1eJo1tWjqcymnOExAMwp7CwDFh/L9Wn1BQ=;
 b=jin5vosk7ImIaOrvpEQqxbt00lvhGVDMxAYLfRqPCZfJyRk+sK8pUtP2VqAQPo3GGz6m
 1t75Y6Jvlmh/F3i0M/nnlawz7B/E1i/PtIXrBDnSaJv2uJG8DLCjioLzvHN3UE62G1TX
 igsKOv+K8s/HnnI/GH2H8QBBMmoUW/9UeM3s4zsbKf4G1pAYi9leUaUS8EcEUH7JNh5+
 zE1KYAqTRu53HusSv8qCjfqNmDFm0LTsaknhLcPXMN3U0SbjIsNKH5M8uD3KJuuJQ9Y4
 sXNRtnxFsUMv+QxTKMkbKnJb8266x+d/umf7toclSTw4OSLqhhyyPOCeps9M3XYKeB6X qg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hancrrgvw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jul 2022 15:16:53 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26EF0X2t003854;
        Thu, 14 Jul 2022 15:16:52 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hancrrgv3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jul 2022 15:16:52 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26EF92A5019475;
        Thu, 14 Jul 2022 15:16:51 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03dal.us.ibm.com with ESMTP id 3ha4qxxe39-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jul 2022 15:16:51 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26EFGoa213763000
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 15:16:50 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 57BA46E056;
        Thu, 14 Jul 2022 15:16:50 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A37F76E052;
        Thu, 14 Jul 2022 15:16:48 +0000 (GMT)
Received: from [9.211.37.111] (unknown [9.211.37.111])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 14 Jul 2022 15:16:48 +0000 (GMT)
Message-ID: <345053d6-5ecb-066d-8eeb-7637da1d7370@linux.ibm.com>
Date:   Thu, 14 Jul 2022 17:16:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v2 0/6] net/smc: Introduce virtually contiguous
 buffers for SMC-R
To:     Wen Gu <guwen@linux.alibaba.com>, kgraul@linux.ibm.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1657791845-1060-1-git-send-email-guwen@linux.alibaba.com>
From:   Wenjia Zhang <wenjia@linux.ibm.com>
In-Reply-To: <1657791845-1060-1-git-send-email-guwen@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: V8MbGJOGymfT2_3iVq_skHNTMXq6T7QS
X-Proofpoint-ORIG-GUID: ctNzSyokK4q1EpdssQNna2VWjldMnz66
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-14_11,2022-07-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 malwarescore=0
 phishscore=0 impostorscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207140065
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 14.07.22 11:43, Wen Gu wrote:
> On long-running enterprise production servers, high-order contiguous
> memory pages are usually very rare and in most cases we can only get
> fragmented pages.
> 
> When replacing TCP with SMC-R in such production scenarios, attempting
> to allocate high-order physically contiguous sndbufs and RMBs may result
> in frequent memory compaction, which will cause unexpected hung issue
> and further stability risks.
> 
> So this patch set is aimed to allow SMC-R link group to use virtually
> contiguous sndbufs and RMBs to avoid potential issues mentioned above.
> Whether to use physically or virtually contiguous buffers can be set
> by sysctl smcr_buf_type.
> 
> Note that using virtually contiguous buffers will bring an acceptable
> performance regression, which can be mainly divided into two parts:
> 
> 1) regression in data path, which is brought by additional address
>     translation of sndbuf by RNIC in Tx. But in general, translating
>     address through MTT is fast. According to qperf test, this part
>     regression is basically less than 10% in latency and bandwidth.
>     (see patch 5/6 for details)
> 
> 2) regression in buffer initialization and destruction path, which is
>     brought by additional MR operations of sndbufs. But thanks to link
>     group buffer reuse mechanism, the impact of this kind of regression
>     decreases as times of buffer reuse increases.
> 
> Patch set overview:
> - Patch 1/6 and 2/6 mainly about simplifying and optimizing DMA sync
>    operation, which will reduce overhead on the data path, especially
>    when using virtually contiguous buffers;
> - Patch 3/6 and 4/6 introduce a sysctl smcr_buf_type to set the type
>    of buffers in new created link group;
> - Patch 5/6 allows SMC-R to use virtually contiguous sndbufs and RMBs,
>    including buffer creation, destruction, MR operation and access;
> - patch 6/6 extends netlink attribute for buffer type of SMC-R link group;
> 
> v1->v2:
> - Patch 5/6 fixes build issue on 32bit;
> - Patch 3/6 adds description of new sysctl in smc-sysctl.rst;
> 
> Guangguan Wang (2):
>    net/smc: remove redundant dma sync ops
>    net/smc: optimize for smc_sndbuf_sync_sg_for_device and
>      smc_rmb_sync_sg_for_cpu
> 
> Wen Gu (4):
>    net/smc: Introduce a sysctl for setting SMC-R buffer type
>    net/smc: Use sysctl-specified types of buffers in new link group
>    net/smc: Allow virtually contiguous sndbufs or RMBs for SMC-R
>    net/smc: Extend SMC-R link group netlink attribute
> 
>   Documentation/networking/smc-sysctl.rst |  13 ++
>   include/net/netns/smc.h                 |   1 +
>   include/uapi/linux/smc.h                |   1 +
>   net/smc/af_smc.c                        |  68 +++++++--
>   net/smc/smc_clc.c                       |   8 +-
>   net/smc/smc_clc.h                       |   2 +-
>   net/smc/smc_core.c                      | 246 +++++++++++++++++++++-----------
>   net/smc/smc_core.h                      |  20 ++-
>   net/smc/smc_ib.c                        |  44 +++++-
>   net/smc/smc_ib.h                        |   2 +
>   net/smc/smc_llc.c                       |  33 +++--
>   net/smc/smc_rx.c                        |  92 +++++++++---
>   net/smc/smc_sysctl.c                    |  11 ++
>   net/smc/smc_tx.c                        |  10 +-
>   14 files changed, 404 insertions(+), 147 deletions(-)
> 
This idea is very cool! Thank you for your effort! But we still need to 
verify if this solution can run well on our system. I'll come to you soon.
