Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B27614C5921
	for <lists+netdev@lfdr.de>; Sun, 27 Feb 2022 04:27:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiB0D2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Feb 2022 22:28:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiB0D2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Feb 2022 22:28:17 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570CE3AA70;
        Sat, 26 Feb 2022 19:27:41 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id em10-20020a17090b014a00b001bc3071f921so11800570pjb.5;
        Sat, 26 Feb 2022 19:27:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FKNI+luVZFLm4IVWsZpPnDpCsgFIPr6zk+10yzzBlg0=;
        b=clmntm+JHN6QbH4VrAUPAPaZyxPWASA7Qt3Hy2GqwhK98IOSpKWP5s5O8ddBXD4vul
         uqZD2L4R2jJ3eR4iN1Rs+2U8AjfYXhd9zKOSPk1vFURif1qBIZnENsqVdpxZc3PmI0jR
         bKtEbE9/6z+SrOc7h/EM0bqGYoK+7rBtCHXQfLA+vLErQV2fhLF5A8kdIe8ubacBTqgy
         MpITH1La3CT/Jt9gdNSZzW55uHXjA9aTjIkxu5zSSlBKerPmWuVDcwGWR/0A/Mpxf3fG
         HkYXGBHIF1kAfnFF59YUCiiEMtULthEjVRgaljQgdHQ+vMOnylqwRhkwDCUo3mzgviX8
         Qh2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FKNI+luVZFLm4IVWsZpPnDpCsgFIPr6zk+10yzzBlg0=;
        b=CI/h+deqS3LLELMnBBGbn36BbOXjfGiZxoubSjf0QnSNdVNs2u/R6IErpNmb8gpWJA
         QfiscdjCW5OYxKOjWxQRZCY2pavMIdPlXjHlCKglGVyh41wpLEM+eOISZn6pPsKkw7Ox
         KCbMeCvqnR1WcLGvNG20vky6EgEJ6sQD53zXgx5PKAPlNnZ0mYGE91Yr3Ou3gmk034R9
         b89hVLrNTevvGV1xYnRm1fBHCMSSC35pMfUbFIvQuAvQECjYqWlqIC95hHPTB9k6eTCA
         EXxo+F0ZzwsUJ7xcFhCrXAzLJAOJjWwwlhIJBWM0/l0uf+rooFE3KfOlcDEdOnj+xKCd
         F5fQ==
X-Gm-Message-State: AOAM533E7h5RuRhrvwU634wL0zLUM3WoueIhyRfB066MQfZjDA+fdxK2
        nw1gIfDvRhqqmOoZISukYbA=
X-Google-Smtp-Source: ABdhPJwNhhdA157VdxKzxlG2ZmDTS0Izn/JqUe+JO3UrddXxe6VGR9jpLpeY1eNDr0TYdqUZtjxpyg==
X-Received: by 2002:a17:902:edcd:b0:14d:c114:b86b with SMTP id q13-20020a170902edcd00b0014dc114b86bmr14364844plk.166.1645932460823;
        Sat, 26 Feb 2022 19:27:40 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:6566])
        by smtp.gmail.com with ESMTPSA id c34-20020a630d22000000b0034cb89e4695sm6829830pgl.28.2022.02.26.19.27.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Feb 2022 19:27:40 -0800 (PST)
Date:   Sat, 26 Feb 2022 19:27:37 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Joe Stringer <joe@cilium.io>,
        Florent Revest <revest@chromium.org>,
        linux-kselftest@vger.kernel.org,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH bpf-next v3 5/5] bpf: Add selftests for raw syncookie
 helpers
Message-ID: <20220227032737.zrtgxkussxmeqezh@ast-mbp.dhcp.thefacebook.com>
References: <20220224151145.355355-1-maximmi@nvidia.com>
 <20220224151145.355355-6-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220224151145.355355-6-maximmi@nvidia.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FROM_FMBLA_NEWDOM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24, 2022 at 05:11:45PM +0200, Maxim Mikityanskiy wrote:
> This commit adds selftests for the new BPF helpers:
> bpf_tcp_raw_{gen,check}_syncookie_ipv{4,6}.
> 
> xdp_synproxy_kern.c is a BPF program that generates SYN cookies on
> allowed TCP ports and sends SYNACKs to clients, accelerating synproxy
> iptables module.
> 
> xdp_synproxy.c is a userspace control application that allows to
> configure the following options in runtime: list of allowed ports, MSS,
> window scale, TTL.
> 
> test_xdp_synproxy.sh is a script that demonstrates the setup of synproxy
> with XDP acceleration and serves as a selftest for the new feature.

Please convert the test into test_progs runner.
We don't accept standalone tests anymore.
