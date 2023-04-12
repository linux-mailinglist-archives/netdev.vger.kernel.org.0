Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88B2E6DFBF6
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 18:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbjDLQ4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 12:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjDLQ4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 12:56:35 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA229ECC
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 09:56:07 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-246f8db70bcso131060a91.2
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 09:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681318563;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=r5aQP8BO2zo9XrojS0bD6j1oYwbTGaaKe2CEIkMg+Cc=;
        b=oVLoNRJYCUybQHOCGDc1/+VV+Wd3aSZ7iKoewHhOxr1x7l07u7jhjgNxGtvZ+BZiGP
         c0df6kLIh/auurIKDofimLBIjub63gz2i2tflYknIZNj2NnK506IT3EyqDEs7OBDGJOw
         Du1gx6ak04OGqUV5ei38bvHmLTob16K6WNbOzXVmiZCC6zqQc5aP40cItoZfBTFJxJiR
         Oj7oWnxeVM3mdxoWqLd4ZHyFIzGKvXmkUTBFIJzsVjT/MUQkrsa9QNrCYmRFOXRLWd9b
         TEA6YsK/kVrHl8IF0FY22x7gwd2A6zHfKONJF6sMgQaCSt1EUuPHDQUfPHyBBvBBj1Nf
         kzrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681318563;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r5aQP8BO2zo9XrojS0bD6j1oYwbTGaaKe2CEIkMg+Cc=;
        b=jmiZAZHncdJWEDi1SFfwNxj24kTSoguRdDJkvglIh1iT+RjHjE1MDVTXeXNWVLzk5x
         0c4FpMA3F8ZPQ8ONwj0f4Yd/+uMWcvw0hzC5cYuG7gPQozsi+t8gYj3shim12VpkIfqO
         DYRS28WZzM4rkfG3DXyAHnWbYV540sjPvbuJ2FuIZCSSpUyAlu+XP9YUoqa94JN+o0q7
         kCCrqV36Wuo1BIa3y5Bwmr81QP9Z25CBoR8FkR40gmAhbtvem8vgVOxNtoJTDhBERwBx
         YPuRx6k4USFs3pcDeoPsYzGSkIhQNy2lCDHPOVVDCvYe9HXr/JGaA1zbagxIx5WFdL54
         MucA==
X-Gm-Message-State: AAQBX9dXD8uLZC7dgmD1KghMz73nX/I279IKLMTu6xa3C20Fk8sW3i3/
        y83oDfJF46DGyrprJ0SgQ0eyST8=
X-Google-Smtp-Source: AKy350a13a5HToDhjS1k1UbKJ/IVQbgV0gzzJs4B82pMPsxUQcRF3Po0gAx3EgHJsgANJfb6CfMCn/I=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6a00:2d15:b0:62d:afc6:c152 with SMTP id
 fa21-20020a056a002d1500b0062dafc6c152mr569870pfb.5.1681318563183; Wed, 12 Apr
 2023 09:56:03 -0700 (PDT)
Date:   Wed, 12 Apr 2023 09:56:01 -0700
In-Reply-To: <168130336725.150247.12193228778654006957.stgit@firesoul>
Mime-Version: 1.0
References: <168130333143.150247.11159481574477358816.stgit@firesoul> <168130336725.150247.12193228778654006957.stgit@firesoul>
Message-ID: <ZDbiofWhQhFEfIsr@google.com>
Subject: Re: [PATCH bpf V8 2/7] selftests/bpf: Add counters to xdp_hw_metadata
From:   Stanislav Fomichev <sdf@google.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org,
        "Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?=" <toke@redhat.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        martin.lau@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        alexandr.lobakin@intel.com, larysa.zaremba@intel.com,
        xdp-hints@xdp-project.net, anthony.l.nguyen@intel.com,
        yoong.siang.song@intel.com, boon.leong.ong@intel.com,
        intel-wired-lan@lists.osuosl.org, pabeni@redhat.com,
        jesse.brandeburg@intel.com, kuba@kernel.org, edumazet@google.com,
        john.fastabend@gmail.com, hawk@kernel.org, davem@davemloft.net,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/12, Jesper Dangaard Brouer wrote:
> Add counters for skipped, failed and redirected packets.
> The xdp_hw_metadata program only redirects UDP port 9091.
> This helps users to quickly identify then packets are
> skipped and identify failures of bpf_xdp_adjust_meta.
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  .../testing/selftests/bpf/progs/xdp_hw_metadata.c  |   15 +++++++++++++--
>  tools/testing/selftests/bpf/xdp_hw_metadata.c      |    4 +++-
>  2 files changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> index b0104763405a..a07ef7534013 100644
> --- a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> +++ b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> @@ -25,6 +25,10 @@ struct {
>  	__type(value, __u32);
>  } xsk SEC(".maps");
>  
> +volatile __u64 pkts_skip = 0;
> +volatile __u64 pkts_fail = 0;
> +volatile __u64 pkts_redir = 0;
> +
>  extern int bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx,
>  					 __u64 *timestamp) __ksym;
>  extern int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx,
> @@ -59,16 +63,21 @@ int rx(struct xdp_md *ctx)
>  			udp = NULL;
>  	}
>  
> -	if (!udp)
> +	if (!udp) {
> +		pkts_skip++;
>  		return XDP_PASS;
> +	}
>  
>  	/* Forwarding UDP:9091 to AF_XDP */
> -	if (udp->dest != bpf_htons(9091))
> +	if (udp->dest != bpf_htons(9091)) {
> +		pkts_skip++;
>  		return XDP_PASS;
> +	}
>  
>  	ret = bpf_xdp_adjust_meta(ctx, -(int)sizeof(struct xdp_meta));
>  	if (ret != 0) {

[..]

>  		bpf_printk("bpf_xdp_adjust_meta returned %d", ret);

Maybe let's remove these completely? Merge patch 1 and 2, remove printk,
add counters. We can add more counters in the future if the existing
ones are not enough.. WDYT?

> +		pkts_fail++;
>  		return XDP_PASS;
>  	}
>  
> @@ -78,6 +87,7 @@ int rx(struct xdp_md *ctx)
>  
>  	if (meta + 1 > data) {
>  		bpf_printk("bpf_xdp_adjust_meta doesn't appear to work");
> +		pkts_fail++;
>  		return XDP_PASS;
>  	}
>  
> @@ -91,6 +101,7 @@ int rx(struct xdp_md *ctx)
>  	else
>  		meta->rx_hash = 0; /* Used by AF_XDP as not avail signal */
>  
> +	pkts_redir++;
>  	return bpf_redirect_map(&xsk, ctx->rx_queue_index, XDP_PASS);
>  }
>  
> diff --git a/tools/testing/selftests/bpf/xdp_hw_metadata.c b/tools/testing/selftests/bpf/xdp_hw_metadata.c
> index 1c8acb68b977..3b942ef7297b 100644
> --- a/tools/testing/selftests/bpf/xdp_hw_metadata.c
> +++ b/tools/testing/selftests/bpf/xdp_hw_metadata.c
> @@ -212,7 +212,9 @@ static int verify_metadata(struct xsk *rx_xsk, int rxq, int server_fd)
>  	while (true) {
>  		errno = 0;
>  		ret = poll(fds, rxq + 1, 1000);
> -		printf("poll: %d (%d)\n", ret, errno);
> +		printf("poll: %d (%d) skip=%llu fail=%llu redir=%llu\n",
> +		       ret, errno, bpf_obj->bss->pkts_skip,
> +		       bpf_obj->bss->pkts_fail, bpf_obj->bss->pkts_redir);
>  		if (ret < 0)
>  			break;
>  		if (ret == 0)
> 
> 
