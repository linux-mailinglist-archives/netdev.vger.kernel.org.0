Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14DDD6E319F
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 15:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjDONjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 09:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbjDONjV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 09:39:21 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 340553A9C;
        Sat, 15 Apr 2023 06:39:20 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id l17so481709qvq.10;
        Sat, 15 Apr 2023 06:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681565959; x=1684157959;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BXtrf0VPaIG4HOcZDvx75sg1pGi/WlAdPaCmHPn9u3M=;
        b=K9OM5RIVh46zeS5Uv01xbtezDZV5i9Ac0OS5rZk/9dNDphOyIYAX813S2yAz6NjPMC
         93fnB+5M0HfQoaVOq8jhT6mf1WcQ8MaTNUhZNvyvNzABcVQEzIOeCBUX7PxeJJX/qX7D
         4kCmemFlzfa3QlZXCXDPEno+OgrEyQ/n2LjutPhrWJ74SUMyutiw56hVdg4KEwdDPdTl
         lcKLCwbnolPPn0vQ9De7fX8QJloF7OXHvFaWanFw1wnwYpc8Z6pjIVDHV4h04zc0+eA0
         v/fm/hU04vCrm4+SeZN6cp/Xnc2/Xzsw6ISUbpza1I4SsdKCzmnWeqDHVEZf2QhP7zvG
         BVTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681565959; x=1684157959;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BXtrf0VPaIG4HOcZDvx75sg1pGi/WlAdPaCmHPn9u3M=;
        b=lZYcuLGGvfsKn98OhOX4l87HL05QQfZXVssnVq6A1mA7CfP6h13F0UtaSpI16139hI
         kAn4+MnamgoZ25upTLVFE/+OSmC6oUoKd9Wsdiu1u1j+e0EIh7bD9ExQuP4BI/O9hoYJ
         ay5DtsDnJy/VGuiR03iVjwwAvvWOcZdyDEE2kyZ/jgGirOBNj6AI5PxuQIHbxiWrV5cY
         ErXHCeBiY2zZziMCUTnMAfbjA+g09N7AXIIqn1JVriLHTF4zYv7HWz+0atVKeOpyYmHz
         qI38lR+pEIrW/F50zMxkQ0FNmoesA23PnOjxjJSJvckNMARdUSEFJvDxtChOGgfXVKv+
         kDcg==
X-Gm-Message-State: AAQBX9fsaLMj3IAcbjcqWfZaEIWQzZFudFVEjGuoJZgEIauiAITl0tlg
        gelUhwh4mxP6S26Hf4BzBZX+bjadqnmzhyP1qog=
X-Google-Smtp-Source: AKy350aNxS7bZdoY8oELBKAr5Z8bZEjBnnPmrE1yflfSlrGFHXK/FheiqIGAPHG5syZ1IbcBPdOUyM1Y19b00xLbxf4=
X-Received: by 2002:a05:6214:29c5:b0:5ef:5e1b:a369 with SMTP id
 gh5-20020a05621429c500b005ef5e1ba369mr6692937qvb.13.1681565959314; Sat, 15
 Apr 2023 06:39:19 -0700 (PDT)
MIME-Version: 1.0
References: <20230413025350.79809-1-laoar.shao@gmail.com> <968ea56a-301a-45c5-3946-497401eb95b5@iogearbox.net>
 <874jpj2682.fsf@toke.dk> <ee52c2e4-4199-da40-8e86-57ef4085c968@iogearbox.net>
 <875y9yzbuy.fsf@toke.dk> <c68bf723-3406-d177-49b4-6d5b485048de@iogearbox.net>
In-Reply-To: <c68bf723-3406-d177-49b4-6d5b485048de@iogearbox.net>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Sat, 15 Apr 2023 21:38:42 +0800
Message-ID: <CALOAHbCvJ5Vqyqx5Ujs1hx_1MH7vBuGH-h3oPqsEm3-oYAu1gQ@mail.gmail.com>
Subject: Re: [PATCH net-next] bpf, net: Support redirecting to ifb with bpf
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ast@kernel.org, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>, martin.lau@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 15, 2023 at 6:57=E2=80=AFAM Daniel Borkmann <daniel@iogearbox.n=
et> wrote:
>
> On 4/14/23 6:07 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > Daniel Borkmann <daniel@iogearbox.net> writes:
> [...]
> > https://git.openwrt.org/?p=3Dproject/qosify.git;a=3Dblob;f=3DREADME
>
> Thanks for the explanation, that sounds reasonable and this should ideall=
y
> be part of the commit msg! Yafang, Toke, how about we craft it the follow=
ing
> way then to support this case:
>

LGTM. With the issue reported by kernel test robot [1] fixed,

Acked-by: Yafang Shao <laoar.shao@gmail.com>

[1]. https://lore.kernel.org/bpf/202304150811.bzx9niRq-lkp@intel.com/

>  From f6c83e5e55c5eb9da8acd19369c688acf53951db Mon Sep 17 00:00:00 2001
> Message-Id: <f6c83e5e55c5eb9da8acd19369c688acf53951db.1681512637.git.dani=
el@iogearbox.net>
> From: Daniel Borkmann <daniel@iogearbox.net>
> Date: Sat, 15 Apr 2023 00:30:27 +0200
> Subject: [PATCH bpf-next] bpf: Set skb redirect and from_ingress info in =
__bpf_tx_skb
> MIME-Version: 1.0
> Content-Type: text/plain; charset=3DUTF-8
> Content-Transfer-Encoding: 8bit
>
> There are some use-cases where it is desirable to use bpf_redirect()
> in combination with ifb device, which currently is not supported, for
> example, around filtering inbound traffic with BPF to then push it to
> ifb which holds the qdisc for shaping in contrast to doing that on the
> egress device.
>
> Toke mentions the following case related to OpenWrt:
>
>    Because there's not always a single egress on the other side. These ar=
e
>    mainly home routers, which tend to have one or more WiFi devices bridg=
ed
>    to one or more ethernet ports on the LAN side, and a single upstream W=
AN
>    port. And the objective is to control the total amount of traffic goin=
g
>    over the WAN link (in both directions), to deal with bufferbloat in th=
e
>    ISP network (which is sadly still all too prevalent).
>
>    In this setup, the traffic can be split arbitrarily between the links
>    on the LAN side, and the only "single bottleneck" is the WAN link. So =
we
>    install both egress and ingress shapers on this, configured to somethi=
ng
>    like 95-98% of the true link bandwidth, thus moving the queues into th=
e
>    qdisc layer in the router. It's usually necessary to set the ingress
>    bandwidth shaper a bit lower than the egress due to being "downstream"
>    of the bottleneck link, but it does work surprisingly well.
>
>    We usually use something like a matchall filter to put all ingress
>    traffic on the ifb, so doing the redirect from BPF has not been an
>    immediate requirement thus far. However, it does seem a bit odd that t=
his
>    is not possible, and we do have a BPF-based filter that layers on top =
of
>    this kind of setup, which currently uses u32 as the ingress filter and
>    so it could presumably be improved to use BPF instead if that was
>    available.
>
> Reported-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Reported-by: Yafang Shao <laoar.shao@gmail.com>
> Reported-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Link: https://git.openwrt.org/?p=3Dproject/qosify.git;a=3Dblob;f=3DREADME
> Link: https://lore.kernel.org/bpf/875y9yzbuy.fsf@toke.dk
> ---
>   include/linux/skbuff.h | 9 +++++++++
>   net/core/filter.c      | 1 +
>   2 files changed, 10 insertions(+)
>
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index ff7ad331fb82..2bbf9245640a 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -5049,6 +5049,15 @@ static inline void skb_reset_redirect(struct sk_bu=
ff *skb)
>         skb->redirected =3D 0;
>   }
>
> +static inline void skb_set_redirected_noclear(struct sk_buff *skb,
> +                                             bool from_ingress)
> +{
> +       skb->redirected =3D 1;
> +#ifdef CONFIG_NET_REDIRECT
> +       skb->from_ingress =3D from_ingress;
> +#endif
> +}
> +
>   static inline bool skb_csum_is_sctp(struct sk_buff *skb)
>   {
>         return skb->csum_not_inet;
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 1d6f165923bf..27ba616aaa1a 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -2111,6 +2111,7 @@ static inline int __bpf_tx_skb(struct net_device *d=
ev, struct sk_buff *skb)
>         }
>
>         skb->dev =3D dev;
> +       skb_set_redirected_noclear(skb, skb->tc_at_ingress);
>         skb_clear_tstamp(skb);
>
>         dev_xmit_recursion_inc();
> --
> 2.21.0



--=20
Regards
Yafang
