Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3C4C48E05A
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 23:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238005AbiAMWgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 17:36:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235281AbiAMWgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 17:36:00 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B41C061574;
        Thu, 13 Jan 2022 14:36:00 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id j27so1151158pgj.3;
        Thu, 13 Jan 2022 14:36:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5wMgPxnCW3lehf/aD8F6oiMEHPNP42N5iWx4rfgZFL4=;
        b=PmgdI80v1X1TnsGb4hKz8oDwMz08xt8OgAYEs/BpfflSL+sMzlFggHCGI1TGMQg2qS
         6+/gli9MXi1Luueje4lazUFfiuadkeLW2L3PYt1oTyy2CAoilfw1euvaYt4lFmIyttaZ
         +4MLMcNT+vLTY0D2MTxfVZDlz9RCPKgioOweo/jaXFlnO5JXglg1hj9L1mDHKRTRY0B8
         gNi9NycvPGTuA7reXUCBePESYON6D1oU8srXTMdTx1d6Xy1eotSJeGerj18aMgdWbmMd
         av6t8Z59cppFbxjNB1HRaFS23zWAxJsB7RtOnwQSVcpXbShI3pack4sYfZiHX4jNUXZG
         QRvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5wMgPxnCW3lehf/aD8F6oiMEHPNP42N5iWx4rfgZFL4=;
        b=vJVZJ0WwHs2+c57zKk+6Zgvqi3v7LTbvoFLJBhXJ01rK+zj40KbRBl1yNbbK+kKL0s
         lYJcejbg9a/kwDi93kCkxmXj1HTfTD5DvJnLfS720v75mycJT6/nwS6gqZ2Ta7BhfuI0
         LxbF4dcIL8THkgWnvUkkU9/Dpkxz13mbF8Q2+/GE85vZVGVTkfr6TxJAXb0ESZ9Bc5r3
         /+HhMl2OdB/VC24GFx1GXt/7oDN0+aPnHFAyImBLg1hNWoIDBqcTR3MOPUVyhIcKGHzc
         Vi+nlWPlxUm/oXqqt+Bgp0UZAfvwTTQLElgx4Pfp5CIgjtYT40Cjh2inoW200j6mFXM4
         dUEw==
X-Gm-Message-State: AOAM5332B1AZoBkrwPyQauKe/xGUmC7km2JymSQz6OaMykevN3OxGlEI
        a6R2c1OWhkOh2iBzJwD4UUQ=
X-Google-Smtp-Source: ABdhPJy6lIyDsCCRGHC224n2GBJJt1B3S0cMAUxPsmE8tuwGvPhuVopd45aoClszjbW+yZiszJm6vg==
X-Received: by 2002:a63:91c4:: with SMTP id l187mr4989464pge.34.1642113359688;
        Thu, 13 Jan 2022 14:35:59 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:5547])
        by smtp.gmail.com with ESMTPSA id il18sm2029418pjb.45.2022.01.13.14.35.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 14:35:59 -0800 (PST)
Date:   Thu, 13 Jan 2022 14:35:57 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH bpf-next v7 07/10] selftests/bpf: Add test for unstable
 CT lookup API
Message-ID: <20220113223557.45d5czezncjwekge@ast-mbp.dhcp.thefacebook.com>
References: <20220111180428.931466-1-memxor@gmail.com>
 <20220111180428.931466-8-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220111180428.931466-8-memxor@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 11, 2022 at 11:34:25PM +0530, Kumar Kartikeya Dwivedi wrote:
> +
> +#define nf_ct_test(func, ctx)                                                  \
> +	({                                                                     \
> +		struct bpf_ct_opts opts_def = { .l4proto = IPPROTO_TCP,        \
> +						.netns_id = -1 };              \
> +		struct bpf_sock_tuple bpf_tuple;                               \
> +		struct nf_conn *ct;                                            \
> +		__builtin_memset(&bpf_tuple, 0, sizeof(bpf_tuple.ipv4));       \
> +		ct = func(ctx, NULL, 0, &opts_def, sizeof(opts_def));          \

Have you tried converting the macro to static always_inline
and passing func as a pointer to a function?
The first argument 'ctx' is different, but if you prototype it
in this static inline as (*fn)(void *ctx)
and type case it later in nf_skb/xdp_ct_test() that should still work?
