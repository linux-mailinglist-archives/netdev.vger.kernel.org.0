Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC0C46A375
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 18:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244098AbhLFRu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 12:50:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbhLFRu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 12:50:57 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD6DCC061746;
        Mon,  6 Dec 2021 09:47:28 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id w4so11010300ilv.12;
        Mon, 06 Dec 2021 09:47:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=73aqN2s3B18yzSlLmgmT1PSw+QY0UCj/8HU8uTfT8us=;
        b=TvwckwLoZVMueaSUAmB2+fyq+WsrEm31NRC+tyevYO9ZOuHuzHsVCw9R0Ecoe0J1tt
         zhI3q7T2VLuD0ICYz0HYzgxMWD/ti6YsDphdHOMJ78DivXWZ9hodFV3qyU2IBeytQKMe
         jlYLJwXZJxarl/bvtiQWvSmBEuKEV/ZjvCvz+Als5aSsqqtWzlOGMyg8LuDetcWjL6eg
         3UYRYxcF7Wbze8+w6zXpz7y7vRL4uCgSNPrXwVWaU/NOU7nBGsDmrqG6R15eTq1D80+a
         wOUOwTHDT8jBAzvxiX2bJfx4WoxlDMXEizSDdoB/fq+zfwPe6e1T8CroOmsKNFBxIzP0
         flCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=73aqN2s3B18yzSlLmgmT1PSw+QY0UCj/8HU8uTfT8us=;
        b=ujwTY/nz6B/tC9FGf234mUOcCDMtrvbx6dDjTJwN21FfdMjOIxJ7hhhdUU0Ku8UGLn
         hDsU24lv1bINEABP1FGjPkXzkpnYZXvbNalyJ/GGTuvsSBBqGnVgUqPUSnxIVvaDzl+0
         WNl3v3G+uxCK0zsTdqC8bZfWA9hEmUiN9N+ufBfzzsnA7K+RXIVaU2z98hwTj11O53iR
         7HX5zo82dth5ljqSg7B8OaR8rL7Y1CxFbtTm7tfyJL7bSUmZmxwjRHobvOzZcXt3nABN
         SkJ/f08mxMUdYLCZy+oGxSlgQcceeVnGAC8YSQRrMrLEU8G9dEHWcZPoMIRgmtHJV6Nc
         A2eA==
X-Gm-Message-State: AOAM532foJkgWUZOURqPRYakvh9fS7T4INjGrA0Nwvib+pski1gaGv7j
        njZwn6grx7SxWDQV2xNLCDorGbW/D3/CFw==
X-Google-Smtp-Source: ABdhPJwgH7/ad5lTvhLOYhzDAC/BAM6x94CWUIGOkJNzG6DGD2xHI4Rtb9Df8W6b7lfWq7ojs4JM+g==
X-Received: by 2002:a05:6e02:1a4e:: with SMTP id u14mr35590162ilv.121.1638812848251;
        Mon, 06 Dec 2021 09:47:28 -0800 (PST)
Received: from localhost ([172.243.151.11])
        by smtp.gmail.com with ESMTPSA id x18sm7785088iow.53.2021.12.06.09.47.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 09:47:27 -0800 (PST)
Date:   Mon, 06 Dec 2021 09:47:20 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Message-ID: <61ae4ca834fe6_881820890@john.notmuch>
In-Reply-To: <d388fc02aa0c3cb031f832d98f305db878e3a6e6.1638272239.git.lorenzo@kernel.org>
References: <cover.1638272238.git.lorenzo@kernel.org>
 <d388fc02aa0c3cb031f832d98f305db878e3a6e6.1638272239.git.lorenzo@kernel.org>
Subject: RE: [PATCH v19 bpf-next 18/23] libbpf: Add SEC name for xdp_mb
 programs
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> Introduce support for the following SEC entries for XDP multi-buff
> property:
> - SEC("xdp_mb/")
> - SEC("xdp_devmap_mb/")
> - SEC("xdp_cpumap_mb/")
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  tools/lib/bpf/libbpf.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index b59fede08ba7..ddad9eb2826a 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -265,6 +265,8 @@ enum sec_def_flags {
>  	SEC_SLEEPABLE = 8,
>  	/* allow non-strict prefix matching */
>  	SEC_SLOPPY_PFX = 16,
> +	/* BPF program support XDP multi-buff */
> +	SEC_XDP_MB = 32,
>  };
>  
>  struct bpf_sec_def {
> @@ -6505,6 +6507,9 @@ static int libbpf_preload_prog(struct bpf_program *prog,
>  	if (def & SEC_SLEEPABLE)
>  		opts->prog_flags |= BPF_F_SLEEPABLE;
>  
> +	if (prog->type == BPF_PROG_TYPE_XDP && (def & SEC_XDP_MB))
> +		opts->prog_flags |= BPF_F_XDP_MB;
> +
>  	if ((prog->type == BPF_PROG_TYPE_TRACING ||
>  	     prog->type == BPF_PROG_TYPE_LSM ||
>  	     prog->type == BPF_PROG_TYPE_EXT) && !prog->attach_btf_id) {
> @@ -8468,8 +8473,11 @@ static const struct bpf_sec_def section_defs[] = {
>  	SEC_DEF("lsm.s/",		LSM, BPF_LSM_MAC, SEC_ATTACH_BTF | SEC_SLEEPABLE, attach_lsm),
>  	SEC_DEF("iter/",		TRACING, BPF_TRACE_ITER, SEC_ATTACH_BTF, attach_iter),
>  	SEC_DEF("syscall",		SYSCALL, 0, SEC_SLEEPABLE),
> +	SEC_DEF("xdp_devmap_mb/",	XDP, BPF_XDP_DEVMAP, SEC_ATTACHABLE | SEC_XDP_MB),
>  	SEC_DEF("xdp_devmap/",		XDP, BPF_XDP_DEVMAP, SEC_ATTACHABLE),
> +	SEC_DEF("xdp_cpumap_mb/",	XDP, BPF_XDP_CPUMAP, SEC_ATTACHABLE | SEC_XDP_MB),
>  	SEC_DEF("xdp_cpumap/",		XDP, BPF_XDP_CPUMAP, SEC_ATTACHABLE),
> +	SEC_DEF("xdp_mb/",		XDP, BPF_XDP, SEC_ATTACHABLE_OPT | SEC_SLOPPY_PFX | SEC_XDP_MB),
>  	SEC_DEF("xdp",			XDP, BPF_XDP, SEC_ATTACHABLE_OPT | SEC_SLOPPY_PFX),
>  	SEC_DEF("perf_event",		PERF_EVENT, 0, SEC_NONE | SEC_SLOPPY_PFX),
>  	SEC_DEF("lwt_in",		LWT_IN, 0, SEC_NONE | SEC_SLOPPY_PFX),
> -- 
> 2.31.1
> 

LGTM. Nice to see this got to a good solution.

Acked-by: John Fastabend <john.fastabend@gmail.com>
