Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A797358ED8
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 22:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232469AbhDHU5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 16:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232443AbhDHU5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 16:57:35 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 049F9C061760;
        Thu,  8 Apr 2021 13:57:24 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id k8so2261948pgf.4;
        Thu, 08 Apr 2021 13:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rQVopMjbwxS6uuX7hClZLyWUOrAUL0u79imtqFh3yHc=;
        b=WBBDMayO7i2N+959II5jhtFm3YK8J5WVsPuusv92DSZm7AQll8pdkkUfjya8dDKAW9
         Dxi7Myk+fZCp/48CEWQiQXjehFoE8opzn6zkalSJxx5VI0EuxK0qAJbZdzzGO8ZE2jwa
         fO9cDLbViPswtPeGks3KcQ5u54qT0gp8Dr0I7We2vCfIMREiKI0e+ufQAz15CGEjJ+TK
         kVAOS9J80zpn9NrmeGpstJkWPDyzAdOEaMW90xQwnAKpPz3oEdxPMwuwBWsa0K1GSLtM
         a/wc+up5uExiDKKPwSKeahgpTwT7rvJxMtYTNEWGkwz3Zs+1CRivSpmT7VDrNL04cBN6
         YY3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rQVopMjbwxS6uuX7hClZLyWUOrAUL0u79imtqFh3yHc=;
        b=JgUoHLbJMIIaNfwQQrCkQqztQu9Zva36TNeRVOUfoTftZqao9tfQXgS54vGKda6WsW
         d3/aERUDw3BUYkiyyyneIyPqjnG2+toX1YXZFqAlRHzCvbXLKUKNFxUAQE2+sCcKtLWp
         aUZ42HeQz08shgAN0rwlBFPAWbXXvTSWGpvyVm5E0EkMyasv0yo9YCYesMvkyyHGxzfo
         alz7xGB/kQnNMw35eQhO5DnNmvZ2cFcY7AR+MXWU8gDftGWV/GSC6YXch2JhDtBl8qV1
         SRBRVz1qnMaftmkd28e7uBV1XkkhLxRMxfb8Jgctc7c5WAaddKHz+irbQpkx9c8qEMED
         Rq5g==
X-Gm-Message-State: AOAM532vJ2/oywcQyAEjyWL+4HI3Lj93bBpLp2vTDmuqaks8AJKjzZNE
        Dr72s8uz4TPFL7l75dPN62U=
X-Google-Smtp-Source: ABdhPJzJr8/gZf6UUCV3AgenY/FRY8kZ2EWTavKk9nStDUwx7p9YpLaOrpHM8b7Z6ZZ9R7UT+T+X7Q==
X-Received: by 2002:a05:6a00:170c:b029:225:8851:5b3c with SMTP id h12-20020a056a00170cb029022588515b3cmr9340850pfc.0.1617915443600;
        Thu, 08 Apr 2021 13:57:23 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id z23sm253844pjh.45.2021.04.08.13.57.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 13:57:23 -0700 (PDT)
Date:   Thu, 8 Apr 2021 23:57:09 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        brouer@redhat.com, echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com
Subject: Re: [PATCH v8 bpf-next 09/14] bpd: add multi-buffer support to xdp
 copy helpers
Message-ID: <20210408205709.w6sy5rklphoyl5on@skbuf>
References: <cover.1617885385.git.lorenzo@kernel.org>
 <cc517a20ac0908fa070ee6ba019936a8037a6d8c.1617885385.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc517a20ac0908fa070ee6ba019936a8037a6d8c.1617885385.git.lorenzo@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 08, 2021 at 02:51:01PM +0200, Lorenzo Bianconi wrote:
> From: Eelco Chaudron <echaudro@redhat.com>
> 
> This patch adds support for multi-buffer for the following helpers:
>   - bpf_xdp_output()
>   - bpf_perf_event_output()
> 
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
> diff --git a/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c b/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
> index a038e827f850..d5a5f603d252 100644
> --- a/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
> +++ b/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
> @@ -27,6 +27,7 @@ struct xdp_buff {
>  	void *data_hard_start;
>  	unsigned long handle;
>  	struct xdp_rxq_info *rxq;
> +	__u32 frame_length;

This patch will not work without patch 10, so could you change the order?

>  } __attribute__((preserve_access_index));
>  
>  struct meta {
> @@ -49,7 +50,7 @@ int BPF_PROG(trace_on_entry, struct xdp_buff *xdp)
>  	void *data = (void *)(long)xdp->data;
>  
>  	meta.ifindex = xdp->rxq->dev->ifindex;
> -	meta.pkt_len = data_end - data;
> +	meta.pkt_len = xdp->frame_length;
>  	bpf_xdp_output(xdp, &perf_buf_map,
>  		       ((__u64) meta.pkt_len << 32) |
>  		       BPF_F_CURRENT_CPU,
> -- 
> 2.30.2
> 
