Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99A7A579FE1
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 15:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238670AbiGSNlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 09:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238554AbiGSNl1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 09:41:27 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF392E681;
        Tue, 19 Jul 2022 05:55:23 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26JClq2l026923;
        Tue, 19 Jul 2022 12:55:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=XvZRr+4XsyvLMc9mEfA47H14FhnnGzjLcTEglm3B41A=;
 b=FnbgZLn2WqwErxVOXpXcIAbv2y3DieR/70FEpX9Qlc9RTwpK8hQ7N/ANmjRYWYu5fnwA
 +HMbTtmvOmPwv1k1/YIhTuBz309v+Ej15dNYnnDh63I4gw0G6ljbE/ribcJEPIpR5kW2
 B6Ya+ct3LnLHIc1aTb2udpXnUOPM3vO+bfVxh+o3djbIe4crF+Qu0Nt88T1dvt/AIyaG
 RO7wrAF0V/CQ+Md7qVogSOHbOSvxHEwnhEOwI957ZQ3wq87xQMJ/JgqlqRh7j1Mqkke8
 0qrErm2WzgeQMuLnRvwR5/C29mh9nEEHeUWTGKUl9yCMm439l87guk/ArQaUjBREywo1 cA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hdvxcg5tn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jul 2022 12:55:18 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26JCqoNs023307;
        Tue, 19 Jul 2022 12:55:17 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hdvxcg5t7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jul 2022 12:55:17 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26JCq5JH005598;
        Tue, 19 Jul 2022 12:55:16 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma04wdc.us.ibm.com with ESMTP id 3hbmy9bb65-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jul 2022 12:55:16 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26JCtGCN18743644
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jul 2022 12:55:16 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB16F6E04E;
        Tue, 19 Jul 2022 12:55:15 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 192ED6E054;
        Tue, 19 Jul 2022 12:55:13 +0000 (GMT)
Received: from [9.211.73.90] (unknown [9.211.73.90])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 19 Jul 2022 12:55:13 +0000 (GMT)
Message-ID: <6fe701ac-65fe-61c7-49f6-8b5af8022b55@linux.ibm.com>
Date:   Tue, 19 Jul 2022 14:55:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v2 0/6] net/smc: Introduce virtually contiguous
 buffers for SMC-R
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     Wen Gu <guwen@linux.alibaba.com>, kgraul@linux.ibm.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1657791845-1060-1-git-send-email-guwen@linux.alibaba.com>
 <345053d6-5ecb-066d-8eeb-7637da1d7370@linux.ibm.com>
 <YtVV6IWF0cKxJaWe@TonyMac-Alibaba>
From:   Wenjia Zhang <wenjia@linux.ibm.com>
In-Reply-To: <YtVV6IWF0cKxJaWe@TonyMac-Alibaba>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FruciYD3Lcg3L0Bm4W4SNAEWrglFq-9Q
X-Proofpoint-ORIG-GUID: hJ_vhmUgELO8OsUQiC-pF3md-1fAOHLf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_22,2022-07-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 lowpriorityscore=0 impostorscore=0 priorityscore=1501
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207190052
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 18.07.22 14:45, Tony Lu wrote:
> On Thu, Jul 14, 2022 at 05:16:47PM +0200, Wenjia Zhang wrote:
>>
>>
>> On 14.07.22 11:43, Wen Gu wrote:
>>> On long-running enterprise production servers, high-order contiguous
>>> memory pages are usually very rare and in most cases we can only get
>>> fragmented pages.
>>>
>>> When replacing TCP with SMC-R in such production scenarios, attempting
>>> to allocate high-order physically contiguous sndbufs and RMBs may result
>>> in frequent memory compaction, which will cause unexpected hung issue
>>> and further stability risks.
>>>
>>> So this patch set is aimed to allow SMC-R link group to use virtually
>>> contiguous sndbufs and RMBs to avoid potential issues mentioned above.
>>> Whether to use physically or virtually contiguous buffers can be set
>>> by sysctl smcr_buf_type.
>>>
>>> Note that using virtually contiguous buffers will bring an acceptable
>>> performance regression, which can be mainly divided into two parts:
>>>
>>> 1) regression in data path, which is brought by additional address
>>>      translation of sndbuf by RNIC in Tx. But in general, translating
>>>      address through MTT is fast. According to qperf test, this part
>>>      regression is basically less than 10% in latency and bandwidth.
>>>      (see patch 5/6 for details)
>>>
>>> 2) regression in buffer initialization and destruction path, which is
>>>      brought by additional MR operations of sndbufs. But thanks to link
>>>      group buffer reuse mechanism, the impact of this kind of regression
>>>      decreases as times of buffer reuse increases.
>>>
>>> Patch set overview:
>>> - Patch 1/6 and 2/6 mainly about simplifying and optimizing DMA sync
>>>     operation, which will reduce overhead on the data path, especially
>>>     when using virtually contiguous buffers;
>>> - Patch 3/6 and 4/6 introduce a sysctl smcr_buf_type to set the type
>>>     of buffers in new created link group;
>>> - Patch 5/6 allows SMC-R to use virtually contiguous sndbufs and RMBs,
>>>     including buffer creation, destruction, MR operation and access;
>>> - patch 6/6 extends netlink attribute for buffer type of SMC-R link group;
>>>
>>> v1->v2:
>>> - Patch 5/6 fixes build issue on 32bit;
>>> - Patch 3/6 adds description of new sysctl in smc-sysctl.rst;
>>>
>>> Guangguan Wang (2):
>>>     net/smc: remove redundant dma sync ops
>>>     net/smc: optimize for smc_sndbuf_sync_sg_for_device and
>>>       smc_rmb_sync_sg_for_cpu
>>>
>>> Wen Gu (4):
>>>     net/smc: Introduce a sysctl for setting SMC-R buffer type
>>>     net/smc: Use sysctl-specified types of buffers in new link group
>>>     net/smc: Allow virtually contiguous sndbufs or RMBs for SMC-R
>>>     net/smc: Extend SMC-R link group netlink attribute
>>>
>>>    Documentation/networking/smc-sysctl.rst |  13 ++
>>>    include/net/netns/smc.h                 |   1 +
>>>    include/uapi/linux/smc.h                |   1 +
>>>    net/smc/af_smc.c                        |  68 +++++++--
>>>    net/smc/smc_clc.c                       |   8 +-
>>>    net/smc/smc_clc.h                       |   2 +-
>>>    net/smc/smc_core.c                      | 246 +++++++++++++++++++++-----------
>>>    net/smc/smc_core.h                      |  20 ++-
>>>    net/smc/smc_ib.c                        |  44 +++++-
>>>    net/smc/smc_ib.h                        |   2 +
>>>    net/smc/smc_llc.c                       |  33 +++--
>>>    net/smc/smc_rx.c                        |  92 +++++++++---
>>>    net/smc/smc_sysctl.c                    |  11 ++
>>>    net/smc/smc_tx.c                        |  10 +-
>>>    14 files changed, 404 insertions(+), 147 deletions(-)
>>>
>> This idea is very cool! Thank you for your effort! But we still need to
>> verify if this solution can run well on our system. I'll come to you soon.
> 
> Hi Wenjia,
> 
> We have noticed that SMC community is becoming more active recently.
> More and more companies have shown their interests in SMC.
> Correspondingly, patches are also increasing. We (Alibaba) are trying to
> apply SMC into cloud production environment, extending its abilities and
> enhancing the performance. We also contributed some work to community in
> the past period of time. So we are more than happy to help review SMC
> patches together. If you need, we are very glad to be reviewers to share
> the review work.
> 
> Hope to hear from you, thank you.
> 
> Best wishes,
> Tony Lu

Hi Tony,

That is very nice to hear that from you. It would be great for us. If 
you like, feel free to add your sign after the review.
Thank you!

Best regards
Wenjia Zhang

