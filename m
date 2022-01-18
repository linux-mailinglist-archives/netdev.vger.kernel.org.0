Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87E9F492F15
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 21:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245453AbiARUOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 15:14:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234274AbiARUOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 15:14:53 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C0AC061574;
        Tue, 18 Jan 2022 12:14:53 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id d15-20020a17090a110f00b001b4e7d27474so394151pja.2;
        Tue, 18 Jan 2022 12:14:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=puXMU5J0qX2c1G1ZYyRfcRbbPxhh45PagenGpQGdctg=;
        b=iurWTEjPALY3vQyjXL7Lu2KJ1GTdJzpNcqeIfYQuCbHqb4ykUqcVxMknKOl4V991KN
         To/Km87RuH8660bIT8yQ95fXd7B+uNvp/4gnR1VWSW2gttPXqH6r3ygi+4HhPfDEs0MA
         jPh/y874ktcLbFXuB7mi/RWRUfzF0VME5P8h9oqdijCuilomhAjHL/oMUomqTA1DzD96
         KEUSzIlTXPqHg7cdF03LgfnP60uixhn+3d4bvfF9lGVSsi5Itp+9elWbEidfLCAnh15c
         HoM4n7PSdmSISo9qzlbRAZ6r9kcIrhjppRZCi83pqQbOpu2cKr9QzWXMUlvaH1jNt8QJ
         jucQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=puXMU5J0qX2c1G1ZYyRfcRbbPxhh45PagenGpQGdctg=;
        b=M4T6f1bQiGs2QzPCb+IkkBiIONEeErM6QOflbTeoFd4z3f5UlqQ8P0NqN67sU7zLtF
         HEolyjD0AEqlGHhGz6+szGXWaSH1vaviTLCiaDIdbrY+jRmu8J/QrQdlJ31n0Ny/ZcsL
         6gWL9nTxxpYrnA4mbE0f5LjyYs0cIDZYq4xv8s6gWvRJmULyCJ6kLGlQlKBxHJVMycHR
         T1bjTNAyCnAkd1s7FAibYc/3IzWn/xEyBbtwKHVSmtHVYXqkmPdp/vgWqRZ8ZO0LnLcR
         +vT6pWfOdO5YGRkX06swG2FquO9WPUhVOMA9csfvgyBfQ9PvbT1MJTT+psMFJMshQs9r
         OTbA==
X-Gm-Message-State: AOAM5328uqKLuZ3y56LsKzOxA634coWM96OSHaBWpoWaBDJok8EKD2+2
        lbXJv5KEU69JvKU54EnXBGFqXBjgYvc=
X-Google-Smtp-Source: ABdhPJxhAXEbjl4b4yEPXz9r8Uotr+e3C40o9hsAyAyC/2uIblEF6A8NBS5ugJM97BVI1VzV40mPIQ==
X-Received: by 2002:a17:902:8693:b0:148:a2e7:fb5a with SMTP id g19-20020a170902869300b00148a2e7fb5amr28717066plo.155.1642536892833;
        Tue, 18 Jan 2022 12:14:52 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:f291])
        by smtp.gmail.com with ESMTPSA id a23sm3393753pjo.57.2022.01.18.12.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 12:14:52 -0800 (PST)
Date:   Tue, 18 Jan 2022 12:14:49 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v22 bpf-next 18/23] libbpf: Add SEC name for xdp
 multi-frags programs
Message-ID: <20220118201449.sjqzif5qkpbu5tqx@ast-mbp.dhcp.thefacebook.com>
References: <cover.1642439548.git.lorenzo@kernel.org>
 <c2bdc436abe8e27a46aa8ba13f75d24f119e18a4.1642439548.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2bdc436abe8e27a46aa8ba13f75d24f119e18a4.1642439548.git.lorenzo@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 17, 2022 at 06:28:30PM +0100, Lorenzo Bianconi wrote:
> Introduce support for the following SEC entries for XDP multi-frags
> property:
> - SEC("xdp.frags")
> - SEC("xdp.frags/devmap")
> - SEC("xdp.frags/cpumap")
> 
> Acked-by: Toke Hoiland-Jorgensen <toke@redhat.com>
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  tools/lib/bpf/libbpf.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index fdb3536afa7d..611e81357fb6 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -6562,6 +6562,9 @@ static int libbpf_preload_prog(struct bpf_program *prog,
>  	if (def & SEC_SLEEPABLE)
>  		opts->prog_flags |= BPF_F_SLEEPABLE;
>  
> +	if (prog->type == BPF_PROG_TYPE_XDP && strstr(prog->sec_name, ".frags"))
> +		opts->prog_flags |= BPF_F_XDP_HAS_FRAGS;

That's a bit sloppy.
Could you handle it similar to SEC_SLEEPABLE?

> +
>  	if ((prog->type == BPF_PROG_TYPE_TRACING ||
>  	     prog->type == BPF_PROG_TYPE_LSM ||
>  	     prog->type == BPF_PROG_TYPE_EXT) && !prog->attach_btf_id) {
> @@ -8600,8 +8603,11 @@ static const struct bpf_sec_def section_defs[] = {
>  	SEC_DEF("lsm.s/",		LSM, BPF_LSM_MAC, SEC_ATTACH_BTF | SEC_SLEEPABLE, attach_lsm),
>  	SEC_DEF("iter/",		TRACING, BPF_TRACE_ITER, SEC_ATTACH_BTF, attach_iter),
>  	SEC_DEF("syscall",		SYSCALL, 0, SEC_SLEEPABLE),
> +	SEC_DEF("xdp.frags/devmap",	XDP, BPF_XDP_DEVMAP, SEC_NONE),
>  	SEC_DEF("xdp_devmap/",		XDP, BPF_XDP_DEVMAP, SEC_ATTACHABLE),
> +	SEC_DEF("xdp.frags/cpumap",	XDP, BPF_XDP_CPUMAP, SEC_NONE),
>  	SEC_DEF("xdp_cpumap/",		XDP, BPF_XDP_CPUMAP, SEC_ATTACHABLE),
> +	SEC_DEF("xdp.frags",		XDP, BPF_XDP, SEC_NONE),

It would be SEC_FRAGS here instead of SEC_NONE.

>  	SEC_DEF("xdp",			XDP, BPF_XDP, SEC_ATTACHABLE_OPT | SEC_SLOPPY_PFX),
>  	SEC_DEF("perf_event",		PERF_EVENT, 0, SEC_NONE | SEC_SLOPPY_PFX),
>  	SEC_DEF("lwt_in",		LWT_IN, 0, SEC_NONE | SEC_SLOPPY_PFX),
> -- 
> 2.34.1
> 

-- 
