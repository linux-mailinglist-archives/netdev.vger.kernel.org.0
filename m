Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26D3C4C3E31
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 07:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237702AbiBYGFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 01:05:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237651AbiBYGFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 01:05:53 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91F8224FA2C;
        Thu, 24 Feb 2022 22:05:21 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id r13so8812625ejd.5;
        Thu, 24 Feb 2022 22:05:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oXWkRTH/S0n4yzQtzyj8DOVzWRs6ONy1MikkvzPJ61k=;
        b=JCSCeDhyy+unmhevm5c+BdXQmKQXZzPH8lowwsN7FP82ZKYdP2nIvNEzsBfC+n5lyG
         N7V2y8nb7uEO93xZkNVKO7cgClR9SVf0pNDIzb+l1MjaWfS6SksMRBbF1ou3AFrXbMyi
         RcVeKu3wIMPNOeOcKh10V4zPhtGJh2MPNT9BNdQ7zBKT3DzQRXcLUj3G78aZjV3FECCj
         qMLrfwT3Pno+Rh3iOAvwFO+/XK7fMsbFOMHTYV5VclfgCUnl6WGnCx9lm5fTdt3NoyLc
         JC0v47oFnk2+u7//+7pFs0GzMP9ofcgJBIA46h/kxaCf0kHd4kw4rU4LYVfVxCJPa5/1
         fzRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oXWkRTH/S0n4yzQtzyj8DOVzWRs6ONy1MikkvzPJ61k=;
        b=bEXjFaMsYcrZop+JoSb2ujAwLPShPnOWFEilAfuvWIU+Cg6MSleHXvjSoHQaUpRlF5
         wDe/NeXnHE6GPX70p17BjXCCYWZks8EG7nrZXgifkzKZADvLgbNq1PvPvsL0/tUk5L3Q
         XSt+SlDxsvIUCpV2WsC/nSi2hCoY+NQUotd5Q7wPHr6G3OZZ3GGTviEVkBlGkYiSzKeU
         pUD8rC8/SZR2K7THet55+Szt0N/SOE7Lt8pPnPfMl1wxBkxUcbrLdnHHdY9+9cdJ5YyL
         HYlbuNirbdlg/lNXZ8hkgZKo9aeVlkRYyKhYtSmOPImmF2TR0u05DEJP4weNnEpePzlK
         ZtNQ==
X-Gm-Message-State: AOAM530eGS+AhvnONn2gyVWQeHDRu6rkPUyiNR7HzFoGLFmGptoY1NiD
        aj0gCQv6Wld+Z2j4Lp9JWEiMCrFaSZYwrbC/aME=
X-Google-Smtp-Source: ABdhPJzQM5e3OoytER/prKMjdamihMc4hFps6IQX4XVbY11ni3qxhE2suRMEMoLqRdhpnE4jiRvtvZEPIC18T0RENpM=
X-Received: by 2002:a17:906:3144:b0:6ce:de5d:5e3b with SMTP id
 e4-20020a170906314400b006cede5d5e3bmr4826339eje.689.1645769120059; Thu, 24
 Feb 2022 22:05:20 -0800 (PST)
MIME-Version: 1.0
References: <20220220155705.194266-1-imagedong@tencent.com>
 <20220220155705.194266-2-imagedong@tencent.com> <3183c3c9-6644-b2de-885e-9e3699138102@kernel.org>
In-Reply-To: <3183c3c9-6644-b2de-885e-9e3699138102@kernel.org>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Fri, 25 Feb 2022 14:05:08 +0800
Message-ID: <CADxym3apww2XEeTX=kU7gW5mbQ9STwVyQypK4Xbsmgid9s+2og@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] net: ip: add skb drop reasons for ip egress path
To:     David Ahern <dsahern@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Menglong Dong <imagedong@tencent.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Cong Wang <cong.wang@bytedance.com>, paulb@nvidia.com,
        Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        flyingpeng@tencent.com, Mengen Sun <mengensun@tencent.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yajun Deng <yajun.deng@linux.dev>,
        Roopa Prabhu <roopa@nvidia.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
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

On Tue, Feb 22, 2022 at 11:13 AM David Ahern <dsahern@kernel.org> wrote:
>
> On 2/20/22 8:57 AM, menglong8.dong@gmail.com wrote:
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > Replace kfree_skb() with kfree_skb_reason() in the packet egress path of
> > IP layer (both IPv4 and IPv6 are considered).
> >
> > Following functions are involved:
> >
> > __ip_queue_xmit()
> > ip_finish_output()
> > ip_mc_finish_output()
> > ip6_output()
> > ip6_finish_output()
> > ip6_finish_output2()
> >
> > Following new drop reasons are introduced:
> >
> > SKB_DROP_REASON_IP_OUTNOROUTES
> > SKB_DROP_REASON_BPF_CGROUP_EGRESS
> > SKB_DROP_REASON_IPV6DSIABLED
> >
> > Reviewed-by: Mengen Sun <mengensun@tencent.com>
> > Reviewed-by: Hao Peng <flyingpeng@tencent.com>
> > Signed-off-by: Menglong Dong <imagedong@tencent.com>
> > ---
> >  include/linux/skbuff.h     | 13 +++++++++++++
> >  include/trace/events/skb.h |  4 ++++
> >  net/ipv4/ip_output.c       |  6 +++---
> >  net/ipv6/ip6_output.c      |  6 +++---
> >  4 files changed, 23 insertions(+), 6 deletions(-)
> >
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index a3e90efe6586..c310a4a8fc86 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -380,6 +380,19 @@ enum skb_drop_reason {
> >                                        * the ofo queue, corresponding to
> >                                        * LINUX_MIB_TCPOFOMERGE
> >                                        */
> > +     SKB_DROP_REASON_IP_OUTNOROUTES, /* route lookup failed during
> > +                                      * packet outputting
> > +                                      */
>
> This should be good enough since the name contains OUT.
>
> /* route lookup failed */
>
> > +     SKB_DROP_REASON_BPF_CGROUP_EGRESS,      /* dropped by eBPF program
> > +                                              * with type of BPF_PROG_TYPE_CGROUP_SKB
> > +                                              * and attach type of
> > +                                              * BPF_CGROUP_INET_EGRESS
> > +                                              * during packet sending
> > +                                              */
>
> /* dropped by BPF_CGROUP_INET_EGRESS eBPF program */
>
> > +     SKB_DROP_REASON_IPV6DSIABLED,   /* IPv6 is disabled on the device,
> > +                                      * see the doc for disable_ipv6
> > +                                      * in ip-sysctl.rst for detail
> > +                                      */
>
> Just /* IPv6 is disabled on the device */
>
>
> >       SKB_DROP_REASON_MAX,
> >  };
> >
>
> > diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> > index 0c0574eb5f5b..df549b7415fb 100644
> > --- a/net/ipv4/ip_output.c
> > +++ b/net/ipv4/ip_output.c
>
> This file has other relevant drops. e.g., ip_finish_output2 when a neigh
> entry can not be created and after skb_gso_segment. The other set for
> tun/tap devices has SKB_DROP_REASON_SKB_GSO_SEG which can be used for
> the latter. That set also adds kfree_skb_list_reason for the frag drops.
>
>
> > diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
> > index 0c6c971ce0a5..4cd9e5fd25e4 100644
> > --- a/net/ipv6/ip6_output.c
> > +++ b/net/ipv6/ip6_output.c
>
> Similarly here. The other set should land in the next few days, so you
> cna put this set on top of it.

Do I need to wait for that set to be ready and use something in it?
Seems they are not ready yet, and I think maybe I can send a v2
now without it?

>
