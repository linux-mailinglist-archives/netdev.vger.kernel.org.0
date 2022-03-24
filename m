Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C64D14E65E4
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 16:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232090AbiCXPRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 11:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiCXPRh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 11:17:37 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E19554B7
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 08:16:05 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id o13so4061994pgc.12
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 08:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+wukXRKjyJBjqG29yuncrVDt3ISBskW6fLs7aNYlmW4=;
        b=dqpFpJ7befPPLIh36LPsxisM77f9+JIuAwSmAnw/ZWqTYwUOHNJW8CSprrzTi0lWpJ
         +ct9M/PwcbDJy2SOPcex+BV43cPN8PJx7ks6XNqRA6t14ptHZH+L2CsAgje4ftS5Ez3o
         z8pNdvBhPGF+28r7tBmLGQsOTIF8adierfn6fjjNag4K5N7mTw1dXt+wFhxsIw4TBt/G
         KViQJaRFcFrwOgskX8+6zW2yrYqJVlaHkMMp71T1at4qPbqFDWnE+SkQP9fOvk1/JPAi
         ZkMfFpUTScwZ8a51gRLByLGSPYiNkvoiogga/uQ58mAUOzlFdlMiClQ7HR46HJ75ksia
         3fXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+wukXRKjyJBjqG29yuncrVDt3ISBskW6fLs7aNYlmW4=;
        b=jcUePFzyY4OzewoVgS3gqaW9EeNe5IEhfibXuBinjrHyO4wuCV9FYdaQy7cFEDfjtJ
         v5xN0eJv8RqP3tTnq/yy/j85nCscwjYTScuX4hE0YRaYuQLG75nl0MKhCDu25tU6H8Kr
         P0a69KF7qvPpXL+Y0p1LNsV4L1WwBjsbyD6yfZrnXEcGDVRGVTlfw5Bibxr/qqiWv6iO
         3HcxMnJsmE3oUXfC+XoeDXdjTLxLUzevDXoGUfLjJVuHBbviCMUSmpDOgA0Fwu2c94VW
         eHI0gphKVEyUATBcOAMGJsw443lk+BSszVsD/c0XXuQgcELucZoVNGheUB9vGfR7TA3t
         7FiA==
X-Gm-Message-State: AOAM5311m5jDVyZVLIRkzTLUOmXZzGP8U/C3s51WhFvFXKJxl7nMziu1
        rzFTErpDRLVC2sl6SHBW60Rd+zldmsKgRkBAD6o=
X-Google-Smtp-Source: ABdhPJxnw+z/ddIwNdwzG66DLRyFWpzY28p0sdiPiXUCN27mSQ3Dr4wXbIl+CXgvetSueAQafyMZhfRIQfAm6O9s364=
X-Received: by 2002:a65:5b4c:0:b0:384:65b3:408f with SMTP id
 y12-20020a655b4c000000b0038465b3408fmr4391717pgr.543.1648134964628; Thu, 24
 Mar 2022 08:16:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220324135653.2189-1-xiangxia.m.yue@gmail.com> <20220324135653.2189-2-xiangxia.m.yue@gmail.com>
In-Reply-To: <20220324135653.2189-2-xiangxia.m.yue@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 24 Mar 2022 08:15:53 -0700
Message-ID: <CAADnVQJmwCKUKbVpqa7SX8QiU1UTZVqgGAMBA4WnKKerBgPiUg@mail.gmail.com>
Subject: Re: [net v6 1/2] net: core: set skb useful vars in __bpf_tx_skb
To:     xiangxia.m.yue@gmail.com
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 24, 2022 at 6:57 AM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> We may use bpf_redirect to redirect the packets to other
> netdevice (e.g. ifb) in ingress or egress path.
>
> The target netdevice may check the *skb_iif, *redirected
> and *from_ingress. For example, if skb_iif or redirected
> is 0, ifb will drop the packets.
>
> Fixes: a70b506efe89 ("bpf: enforce recursion limit on redirects")
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Andrii Nakryiko <andrii@kernel.org>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Cc: Song Liu <songliubraving@fb.com>
> Cc: Yonghong Song <yhs@fb.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: KP Singh <kpsingh@kernel.org>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Antoine Tenart <atenart@kernel.org>
> Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> Cc: Wei Wang <weiwan@google.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> ---
>  net/core/filter.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/net/core/filter.c b/net/core/filter.c
> index a7044e98765e..c1f45d2e6b0a 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -2107,7 +2107,15 @@ static inline int __bpf_tx_skb(struct net_device *dev, struct sk_buff *skb)
>         }
>
>         skb->dev = dev;
> +       /* The target netdevice (e.g. ifb) may use the:
> +        * - redirected
> +        * - from_ingress
> +        */
> +#ifdef CONFIG_NET_CLS_ACT
> +       skb_set_redirected(skb, skb->tc_at_ingress);
> +#else
>         skb_clear_tstamp(skb);
> +#endif

I thought Daniel Nacked it a couple times already.
Please stop this spam.
