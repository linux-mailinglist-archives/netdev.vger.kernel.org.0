Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECB66A5745
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 11:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbjB1K46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 05:56:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231265AbjB1K4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 05:56:34 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0CB5303EB;
        Tue, 28 Feb 2023 02:55:41 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31SAVISh005743;
        Tue, 28 Feb 2023 10:55:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=MPvyFbexAWJSq49zGEln+BSL24Kg9nKhS5mWLEIaN6A=;
 b=EkaHEuNkqsKDIVYh++u3vMIMmxB+5cmWePyipC3CMj6jMnfQLYBWYUAJpYD2NzuYkdpA
 kuCcfCCAGpMpxonXCpjsr2qRimWzZFkKKmdkHsYOSfouhY0PZzhf8GoCOUkb/Kheqx+r
 Y9RaAl0qHSb7egipLhj0ec4Mxq70/p69pd+KU5Ti1jK1m4SIpWB+zZWBpedQNgbConKC
 LRxtkN0oyCvCn91oDelVofqlUrNiCc+495I/xtBoyqffskpQLuueGeJZRiQ/7sTHZmu2
 RTfM4zgnCPK6tpPmxaNX1aovc5Ko7wWcY2ZYMuImEVK6Yd2zZRkWmrDgRACD8FBjx9B8 gg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p1fxc0h6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Feb 2023 10:55:36 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31SAVavH006382;
        Tue, 28 Feb 2023 10:55:35 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p1fxc0h6e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Feb 2023 10:55:35 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31S8Mw90018847;
        Tue, 28 Feb 2023 10:55:34 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([9.208.130.101])
        by ppma03wdc.us.ibm.com (PPS) with ESMTPS id 3nybcbrhj9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Feb 2023 10:55:34 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
        by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31SAtXkk5309144
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Feb 2023 10:55:33 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E7AB258043;
        Tue, 28 Feb 2023 10:55:32 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EED8858065;
        Tue, 28 Feb 2023 10:55:30 +0000 (GMT)
Received: from [9.211.152.15] (unknown [9.211.152.15])
        by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 28 Feb 2023 10:55:30 +0000 (GMT)
Message-ID: <b869713b-7f1d-4093-432c-9f958f5bd719@linux.ibm.com>
Date:   Tue, 28 Feb 2023 11:55:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v2] net/smc: Use percpu ref for wr tx reference
To:     Kai <KaiShen@linux.alibaba.com>, kgraul@linux.ibm.com,
        jaka@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20230227121616.448-1-KaiShen@linux.alibaba.com>
From:   Wenjia Zhang <wenjia@linux.ibm.com>
In-Reply-To: <20230227121616.448-1-KaiShen@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QVafuGWr_1p-2MyUmP4OT2qwwxDiyRqJ
X-Proofpoint-ORIG-GUID: nbJJ5VwTWcuANi23sRueWEiRU4fuDZXk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-28_06,2023-02-28_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 suspectscore=0 clxscore=1015
 adultscore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302280085
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 27.02.23 13:16, Kai wrote:
> The refcount wr_tx_refcnt may cause cache thrashing problems among
> cores and we can use percpu ref to mitigate this issue here. We
> gain some performance improvement with percpu ref here on our
> customized smc-r verion. Applying cache alignment may also mitigate
> this problem but it seem more reasonable to use percpu ref here.
> 
> redis-benchmark on smc-r with atomic wr_tx_refcnt:
> SET: 525817.62 requests per second, p50=0.087 msec
> GET: 570841.44 requests per second, p50=0.087 msec
> 
> redis-benchmark on the percpu_ref version:
> SET: 539956.81 requests per second, p50=0.087 msec
> GET: 587613.12 requests per second, p50=0.079 msec
> 
> Signed-off-by: Kai <KaiShen@linux.alibaba.com>
> ---
>   net/smc/smc_core.h |  5 ++++-
>   net/smc/smc_wr.c   | 18 ++++++++++++++++--
>   net/smc/smc_wr.h   |  5 ++---
>   3 files changed, 22 insertions(+), 6 deletions(-)
> 
> diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
> index 08b457c2d294..0705e33e2d68 100644
> --- a/net/smc/smc_core.h
> +++ b/net/smc/smc_core.h
> @@ -106,7 +106,10 @@ struct smc_link {
>   	unsigned long		*wr_tx_mask;	/* bit mask of used indexes */
>   	u32			wr_tx_cnt;	/* number of WR send buffers */
>   	wait_queue_head_t	wr_tx_wait;	/* wait for free WR send buf */
> -	atomic_t		wr_tx_refcnt;	/* tx refs to link */
> +	struct {
> +		struct percpu_ref	wr_tx_refs;
> +	} ____cacheline_aligned_in_smp;
> +	struct completion	ref_comp;
>   
>   	struct smc_wr_buf	*wr_rx_bufs;	/* WR recv payload buffers */
>   	struct ib_recv_wr	*wr_rx_ibs;	/* WR recv meta data */
> diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
> index b0678a417e09..dd923e76139f 100644
> --- a/net/smc/smc_wr.c
> +++ b/net/smc/smc_wr.c
> @@ -648,7 +648,8 @@ void smc_wr_free_link(struct smc_link *lnk)
>   
>   	smc_wr_tx_wait_no_pending_sends(lnk);
>   	wait_event(lnk->wr_reg_wait, (!atomic_read(&lnk->wr_reg_refcnt)));
> -	wait_event(lnk->wr_tx_wait, (!atomic_read(&lnk->wr_tx_refcnt)));
> +	percpu_ref_kill(&lnk->wr_tx_refs);
> +	wait_for_completion(&lnk->ref_comp);
>   
>   	if (lnk->wr_rx_dma_addr) {
>   		ib_dma_unmap_single(ibdev, lnk->wr_rx_dma_addr,
> @@ -847,6 +848,13 @@ void smc_wr_add_dev(struct smc_ib_device *smcibdev)
>   	tasklet_setup(&smcibdev->send_tasklet, smc_wr_tx_tasklet_fn);
>   }
>   
> +static void smcr_wr_tx_refs_free(struct percpu_ref *ref)
> +{
> +	struct smc_link *lnk = container_of(ref, struct smc_link, wr_tx_refs);
> +
> +	complete(&lnk->ref_comp);
> +}
> +
>   int smc_wr_create_link(struct smc_link *lnk)
>   {
>   	struct ib_device *ibdev = lnk->smcibdev->ibdev;
> @@ -890,7 +898,13 @@ int smc_wr_create_link(struct smc_link *lnk)
>   	smc_wr_init_sge(lnk);
>   	bitmap_zero(lnk->wr_tx_mask, SMC_WR_BUF_CNT);
>   	init_waitqueue_head(&lnk->wr_tx_wait);
> -	atomic_set(&lnk->wr_tx_refcnt, 0);
> +
> +	rc = percpu_ref_init(&lnk->wr_tx_refs, smcr_wr_tx_refs_free,
> +			     PERCPU_REF_ALLOW_REINIT, GFP_KERNEL);
> +	if (rc)
> +		goto dma_unmap;
> +	init_completion(&lnk->ref_comp);
> +
>   	init_waitqueue_head(&lnk->wr_reg_wait);
>   	atomic_set(&lnk->wr_reg_refcnt, 0);
>   	init_waitqueue_head(&lnk->wr_rx_empty_wait);
> diff --git a/net/smc/smc_wr.h b/net/smc/smc_wr.h
> index 45e9b894d3f8..f3008dda222a 100644
> --- a/net/smc/smc_wr.h
> +++ b/net/smc/smc_wr.h
> @@ -63,14 +63,13 @@ static inline bool smc_wr_tx_link_hold(struct smc_link *link)
>   {
>   	if (!smc_link_sendable(link))
>   		return false;
> -	atomic_inc(&link->wr_tx_refcnt);
> +	percpu_ref_get(&link->wr_tx_refs);
>   	return true;
>   }
>   
>   static inline void smc_wr_tx_link_put(struct smc_link *link)
>   {
> -	if (atomic_dec_and_test(&link->wr_tx_refcnt))
> -		wake_up_all(&link->wr_tx_wait);
> +	percpu_ref_put(&link->wr_tx_refs);
>   }
>   
>   static inline void smc_wr_drain_cq(struct smc_link *lnk)

@Tony, thank you for the sugguestion! The decription now looks much 
better to me.

@Kai, the performance improvement seems not so giant, but the method 
looks good, indeed. However, to keep the consistency of the code, I'm 
wondering why you only use the perf_ref for wr_tx_wait, but not for 
wr_reg_refcnt?
