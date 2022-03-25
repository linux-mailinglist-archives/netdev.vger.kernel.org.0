Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67BDA4E6BA9
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 01:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357087AbiCYA6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 20:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347038AbiCYA6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 20:58:39 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B811BBE13
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 17:57:06 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id qa43so12426362ejc.12
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 17:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CL9uou3lkrqbW4YoL0O0/8wdOlfOEFyPtVeXs0XPAOI=;
        b=foq21jzEdCCDbrb5ekY0B7d2BxLE4gqMsw2sROF8RSw7/KMkn2oI8N7pjiCvMa7UfP
         BYBy2aUtW7o9h8O7gV56u1lxpv5Q04vlNAcNUpimC2Wn3GdSczuY0POHYXThUW1X00ZR
         gwedGRm7heJ83P+dJShzIP/6/ZSo07ksp8Hd+7UdLBxVwok9BXksptA9YMDWLdCWOUae
         opYF71HWwTl8j7uaYjtqUqOhCd6qLEUr2JbifIrL63oHLUlMTVVTcM2XGiLRkk1VrHzN
         yczigsU60q4GDwc9n2R8u7RoXDGMf4gyjOrkBhq80/JRmFE9MgX5/7NYCEn2ACFH9Tmy
         wQhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CL9uou3lkrqbW4YoL0O0/8wdOlfOEFyPtVeXs0XPAOI=;
        b=kJR3OybR22eItPU3sT6wny8qiCVbHxE8QfanWWMffCb/62tdYSmd+bpPGEDFklhU0V
         2BShhpOVfdzv4OQ+d2YO+ucPd7BpvGLk19s8hV6end5Z0EgVX7OYD3/+DBvxO6orfVDD
         qvIavu93T2d+kfei0xLgr4gCQFRzVP012ZwwfoCvfwbtQe8McuYV5nEPYCxIH3h2poLX
         ElJRwQujlbDKQUPMR+iALly08zw1mqWT+1PpSQBoNX4qAr/v1LxYq35wSmxCWcohbFKd
         cl4vQaKLwmLyhi19R4+zv2NLR6MtIqcfFyFMc+ZXBJu/zfoPD9lQyiMrAFONEcRHVVxx
         4HUg==
X-Gm-Message-State: AOAM531ZbvNRMbQA4xzhZLn10cdUJjskRAAfCfS7MCOBw/qhLqtDASOb
        NuX4KoabGe/IXytiiS4FY5OdzOp+AkEnEe9v0kA=
X-Google-Smtp-Source: ABdhPJzc/G8olc8MFmY6MsMI3RNI9osHgJeifVxQwEz55vWbVXmP/8jVGMDUvxgh7VOf1+W+QVevMiOpk75vR4OEXtQ=
X-Received: by 2002:a17:906:1e94:b0:6b9:6fcc:53fd with SMTP id
 e20-20020a1709061e9400b006b96fcc53fdmr8768632ejj.450.1648169824643; Thu, 24
 Mar 2022 17:57:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220324135653.2189-1-xiangxia.m.yue@gmail.com>
 <20220324135653.2189-2-xiangxia.m.yue@gmail.com> <CAADnVQJmwCKUKbVpqa7SX8QiU1UTZVqgGAMBA4WnKKerBgPiUg@mail.gmail.com>
In-Reply-To: <CAADnVQJmwCKUKbVpqa7SX8QiU1UTZVqgGAMBA4WnKKerBgPiUg@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Fri, 25 Mar 2022 08:56:28 +0800
Message-ID: <CAMDZJNVK3xpCmg6eCan74prqNBG33USVgqrLE96kkEDhcDrdBQ@mail.gmail.com>
Subject: Re: [net v6 1/2] net: core: set skb useful vars in __bpf_tx_skb
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
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

On Thu, Mar 24, 2022 at 11:16 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Mar 24, 2022 at 6:57 AM <xiangxia.m.yue@gmail.com> wrote:
> >
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > We may use bpf_redirect to redirect the packets to other
> > netdevice (e.g. ifb) in ingress or egress path.
> >
> > The target netdevice may check the *skb_iif, *redirected
> > and *from_ingress. For example, if skb_iif or redirected
> > is 0, ifb will drop the packets.
> >
> > Fixes: a70b506efe89 ("bpf: enforce recursion limit on redirects")
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Alexei Starovoitov <ast@kernel.org>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Andrii Nakryiko <andrii@kernel.org>
> > Cc: Martin KaFai Lau <kafai@fb.com>
> > Cc: Song Liu <songliubraving@fb.com>
> > Cc: Yonghong Song <yhs@fb.com>
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: KP Singh <kpsingh@kernel.org>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: Antoine Tenart <atenart@kernel.org>
> > Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> > Cc: Wei Wang <weiwan@google.com>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > ---
> >  net/core/filter.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index a7044e98765e..c1f45d2e6b0a 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -2107,7 +2107,15 @@ static inline int __bpf_tx_skb(struct net_device *dev, struct sk_buff *skb)
> >         }
> >
> >         skb->dev = dev;
> > +       /* The target netdevice (e.g. ifb) may use the:
> > +        * - redirected
> > +        * - from_ingress
> > +        */
> > +#ifdef CONFIG_NET_CLS_ACT
> > +       skb_set_redirected(skb, skb->tc_at_ingress);
> > +#else
> >         skb_clear_tstamp(skb);
> > +#endif
>
> I thought Daniel Nacked it a couple times already.
> Please stop this spam.
Hi
Daniel rejected the 2/3 patch,
https://patchwork.kernel.org/project/netdevbpf/patch/20211208145459.9590-3-xiangxia.m.yue@gmail.com/
The reasons are as follows.
* 2/3 patch adds a check in fastpath.
* on egress, redirect skb to ifb is not useful.
but this patch fixes  redirect skb to ifb on ingress. I think it is
useful for us.

Hi
Daniel, can you review this patch ?

-- 
Best regards, Tonghao
