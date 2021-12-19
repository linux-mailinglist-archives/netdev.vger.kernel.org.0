Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B47AF479ECB
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 03:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234169AbhLSCT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 21:19:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234054AbhLSCTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 21:19:25 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B23C061574;
        Sat, 18 Dec 2021 18:19:25 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id c2so5551990pfc.1;
        Sat, 18 Dec 2021 18:19:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nQWfNIHGwQt0s1Y5/swRXr8R/cj7JUjpPyzsITAB31A=;
        b=WdcsXcamn4m1B04iFqjd+XH5MSpNoorobBJXHIKcHlQHsuIILut6mt2JCwBR4uLNNt
         PB//T+bPQ1JCNNYxRnYgHAPMM1igHEnSh51RwMknnxcY6MyC50YKLzXMAagDWO63RzpM
         jno52QiIYBGDN0FovAzezjHXm9Ybvh08oSvOtuD8Btx3rFE+4i10gK6iN4d9lACx29Vq
         1iJg+blPp8GV7sC3uEStW5b0RXzPUbbcdPEmPgJpW+0JVjpxYMLZJ3VmNeKJyL2/bVdT
         ZPzjbWnKQj8xAFBwo0FxzIo+IwyyuFgymgt3jr/Wzl2lYcR3CR9fXQVqEV2ttygtpMQy
         D1rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nQWfNIHGwQt0s1Y5/swRXr8R/cj7JUjpPyzsITAB31A=;
        b=FCf9tVPCecoerySUlV1N+OqzC7Ff++FWCxmuF1XDJwb3emkFD42TRL+vDqWzk141bo
         8AuXNrEGeIS+lCtcfTtDly8hB2Oi3BiLII19o/L7HloLhd14UFTO45uGsjH/vFkaz7u+
         2AoXmo0inuUzs5+JQ1hqYWB3usfOmyLxCdtFqazI/pICkmGyXiSa+noJSZGhuT9cENYQ
         jDXRtxVkmnex0gFkF0t841nLYWBtcPOknYyOCCUjEsecFsLEX71mVK0zcuD8yaQox4/9
         dZEIQ82BXFdXakBLQjh6O3NrZyVmVIEVnSzEaHjaGYkuwV9nifiOiY2oYgIiSzo/VGOR
         sTMg==
X-Gm-Message-State: AOAM5318Q8UNStFrb233K4wQ28cNUz0d/8iKLCGFZjJXKFbty7DmNQL3
        MkWGeCh9BYJjDbfIbiPopG8=
X-Google-Smtp-Source: ABdhPJzLAQaf/PImJXUe6Jh2K5EuNNhXfCh0UjUExJ7YckzKuUCI2ltgnqAHuOYUNQKSRzM0Mq8k0g==
X-Received: by 2002:a63:d005:: with SMTP id z5mr9180269pgf.516.1639880364749;
        Sat, 18 Dec 2021 18:19:24 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:e30])
        by smtp.gmail.com with ESMTPSA id 32sm12064643pgs.48.2021.12.18.18.19.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Dec 2021 18:19:24 -0800 (PST)
Date:   Sat, 18 Dec 2021 18:19:22 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH bpf-next v4 04/10] bpf: Introduce mem, size argument pair
 support for kfunc
Message-ID: <20211219021922.2jhnvuhcg4zzcp32@ast-mbp>
References: <20211217015031.1278167-1-memxor@gmail.com>
 <20211217015031.1278167-5-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211217015031.1278167-5-memxor@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 17, 2021 at 07:20:25AM +0530, Kumar Kartikeya Dwivedi wrote:
> +static bool is_kfunc_arg_mem_size(const struct btf *btf,
> +				  const struct btf_param *arg,
> +				  const struct bpf_reg_state *reg)
> +{
> +	const struct btf_type *t;
> +	const char *param_name;
> +
> +	t = btf_type_skip_modifiers(btf, arg->type, NULL);
> +	if (!btf_type_is_scalar(t) || reg->type != SCALAR_VALUE)
> +		return false;
> +
> +	/* In the future, this can be ported to use BTF tagging */
> +	param_name = btf_name_by_offset(btf, arg->name_off);
> +	if (strncmp(param_name, "len__", sizeof("len__") - 1))
> +		return false;

I like the feature and approach, but have a suggestion:
The "__sz" suffix would be shorter and more readable.
wdyt?
