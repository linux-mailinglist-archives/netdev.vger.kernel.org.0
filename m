Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4E543580E
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 03:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhJUBI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 21:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbhJUBIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 21:08:25 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF652C06161C;
        Wed, 20 Oct 2021 18:06:09 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id gn3so3743531pjb.0;
        Wed, 20 Oct 2021 18:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=06BhUAAUORlPk7152bN5SJFZoUaSVjUcf1XHx3yIAJY=;
        b=lzebUHAxWOMc16YW1CkY8JPZUjMqG80Y5LNRBom+OtgF78yipOyJ8mGFoq2nCFpPEl
         9/73mcgIDUju95bEvYzF6iQUS380kOGu/iQMmNiBrH1MQaOV92iQAVvw2Vo5Q02NSXKl
         tkFazyDG5hgAb05OnW5XLD7u7RcgmNYwb+fnLUsj6CU1810JYdxsDt7TTGESXH1u3evB
         C1DlC+aYuUYU3sHBb67sQ6s2qxKIkayuArjt5P6Sc2WzXch0q87mT2/mkoKCwAotV7Sg
         ZSxEBlE8yfD/eZ7i31ehthUGqK8UnNV5qB2AyXkpthjHdbnWscMxew3sUYfyW127nmxF
         oirg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=06BhUAAUORlPk7152bN5SJFZoUaSVjUcf1XHx3yIAJY=;
        b=uoRxs3Visv2HD4K4p7FAMrbogooQD+1AV96GCefMtIR6dIHQLJXRpaHuMmpJf5kS1v
         CzzbihtHoD1QTdf3RordxLpxtKxMK6TLf5qi0+Uthi2x+2lNQE7iM2pV/cayOo/WkqKq
         o7x/NDhdNydgdBxhcmFLd2I+ThC7KpBeciLGErE3mE9duZffrCIicWsXcJ5DXEFY8ybn
         fE6NHg/iqCnlFTatRVTaAzEDnOvGcipWONNMdbqqG3qlWTRNveZVn67+m0f9McRnziDr
         bfHwFV9FIAvOs94RzFW8JAxJCCh1/x05SIYWBJwyXa0EoeZ5aRTqRmzskSkGoJUIVX9V
         s+rw==
X-Gm-Message-State: AOAM531IFj8X+oE87QZ6+513SWdp4NWCbTa0QPLUrbgdZl3LZonUbEsG
        pnUEZQBA4u5wVm8VjhGLbgw=
X-Google-Smtp-Source: ABdhPJyeI4TGuNQAQQamS/sZe2UiPyX+/0o+x6FjXIrnkqzN2uRSTDVsj+jRJ96na/Jneqx7ohtbDA==
X-Received: by 2002:a17:90a:c087:: with SMTP id o7mr2889434pjs.30.1634778369306;
        Wed, 20 Oct 2021 18:06:09 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:8c95])
        by smtp.gmail.com with ESMTPSA id g186sm3858699pfb.53.2021.10.20.18.06.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 18:06:08 -0700 (PDT)
Date:   Wed, 20 Oct 2021 18:06:05 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Brendan Jackman <jackmanb@google.com>,
        Florent Revest <revest@chromium.org>,
        Joe Stringer <joe@cilium.io>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Tariq Toukan <tariqt@nvidia.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH bpf-next 10/10] bpf: Add sample for raw syncookie helpers
Message-ID: <20211021010605.osyvspqie63asgn4@ast-mbp.dhcp.thefacebook.com>
References: <20211019144655.3483197-1-maximmi@nvidia.com>
 <20211019144655.3483197-11-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211019144655.3483197-11-maximmi@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 19, 2021 at 05:46:55PM +0300, Maxim Mikityanskiy wrote:
> This commit adds a sample for the new BPF helpers: bpf_ct_lookup_tcp,
> bpf_tcp_raw_gen_syncookie and bpf_tcp_raw_check_syncookie.
> 
> samples/bpf/syncookie_kern.c is a BPF program that generates SYN cookies
> on allowed TCP ports and sends SYNACKs to clients, accelerating synproxy
> iptables module.
> 
> samples/bpf/syncookie_user.c is a userspace control application that
> allows to configure the following options in runtime: list of allowed
> ports, MSS, window scale, TTL.
> 
> samples/bpf/syncookie_test.sh is a script that demonstrates the setup of
> synproxy with XDP acceleration.
> 
> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> ---
>  samples/bpf/.gitignore        |   1 +
>  samples/bpf/Makefile          |   3 +
>  samples/bpf/syncookie_kern.c  | 591 ++++++++++++++++++++++++++++++++++
>  samples/bpf/syncookie_test.sh |  55 ++++
>  samples/bpf/syncookie_user.c  | 388 ++++++++++++++++++++++
>  5 files changed, 1038 insertions(+)
>  create mode 100644 samples/bpf/syncookie_kern.c
>  create mode 100755 samples/bpf/syncookie_test.sh
>  create mode 100644 samples/bpf/syncookie_user.c

Tests should be in selftests/bpf.
Samples are for samples only.

> +// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB

Isn't it deprecated?
LICENSES/deprecated/Linux-OpenIB

> +	// Don't combine additions to avoid 32-bit overflow.

c++ style comment?
did you run checkpatch?
