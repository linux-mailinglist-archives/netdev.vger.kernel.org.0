Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 326A76D43F3
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 14:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbjDCMAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 08:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjDCMAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 08:00:49 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC8B93F9;
        Mon,  3 Apr 2023 05:00:48 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id cn12so24661274qtb.8;
        Mon, 03 Apr 2023 05:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680523247;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e3E29/lGJ5oGdt1PKR3P2u809XT+MuEe6o1e+uZYO14=;
        b=jrc4eAXWad67bBL1FYsNO1KtpfjnvokZuzz5IYkHqYYa4JBVmfuYVums138qdWXflI
         tFpGqRVrHTc6T4Y7u4TxXzPFiqeg9MXy8us3/R/H8DZ17qZxq25JT5uuUJi0wfZh8VtQ
         uGVmZ5pqE/uwji5DBQcWW9S0c7yLMGAE9sA+M244ANv8A7AwUUR5YY/n46+Myw+GKvLv
         J23d9a5j5zM96d7mu395fnGOwwNmGSihThVWCCDUGCJBtrrmsro0h08Mogec/ItvOeG3
         iW0W85ISJx2CvyXfyqKZjlRbde6l2Rj4freU2pln0yrHbopbOMK2rcKbAYhPx1cS6tsA
         gJ/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680523247;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e3E29/lGJ5oGdt1PKR3P2u809XT+MuEe6o1e+uZYO14=;
        b=2ubpqTEzyj+XPQ9+1FKz+FPtws2Y0qNHPrx8C5RaXfV+TDuT+q+a8H74Uf52Zx8pB0
         N/LD36BAMCB+4OkuPjmHPBonha49kQ3Sr3hxb45MmMHPS03foDNy01XnnpqF+IutWnhg
         YZkVfbIdzIS8PQpZfflnjD9osJ+5tWRBqDWMexIbUcZ6NXeFWkKttpHbxB97LAMU83Ov
         Sf0pjqCSkvHWUplrnEH8qrK0wJQgBxYx3P61LJBGrBeotlD+wjGvgZj2QgNdctyMMQrP
         mHa2xo87fi2Y1qbGUH1+lrGW++eqwGXh3Ghmz/h3AtGMWF44UL+RPQqPnMdM8lM7lKEr
         0SRA==
X-Gm-Message-State: AAQBX9eSxgmJT2wT1h+9ytulmu+s4S5KzOAZRe/h06bFvtqKFz5tJe3V
        KcNGgGnGcPwxms2W8OG0h0CrOtl4cV8rsvcCZo4=
X-Google-Smtp-Source: AKy350YouQaHSJvnBvRoDpTbPZBjT9UuJaQ5eKiwFLOCZY2UqQrgl4uC5Uo6NVQ2eVOk1uPw+GPH4BIxloD0KGEJZ3s=
X-Received: by 2002:a05:622a:18a1:b0:3e6:5ca6:e9ea with SMTP id
 v33-20020a05622a18a100b003e65ca6e9eamr31412qtc.5.1680523247556; Mon, 03 Apr
 2023 05:00:47 -0700 (PDT)
MIME-Version: 1.0
References: <20230328115105.13553-1-laoar.shao@gmail.com>
In-Reply-To: <20230328115105.13553-1-laoar.shao@gmail.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Mon, 3 Apr 2023 20:00:11 +0800
Message-ID: <CALOAHbBb8hm=KfDP9nC-Z6sP+V-Exse9a1outAtHb5idqkYDyw@mail.gmail.com>
Subject: Re: [RFC PATCH net-next] bpf, net: support redirecting to ifb with bpf
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 7:51=E2=80=AFPM Yafang Shao <laoar.shao@gmail.com> =
wrote:
>
> In our container environment, we are using EDT-bpf to limit the egress
> bandwidth. EDT-bpf can be used to limit egress only, but can't be used
> to limit ingress. Some of our users also want to limit the ingress
> bandwidth. But after applying EDT-bpf, which is based on clsact qdisc,
> it is impossible to limit the ingress bandwidth currently, due to some
> reasons,
> 1). We can't add ingress qdisc
> The ingress qdisc can't coexist with clsact qdisc as clsact has both
> ingress and egress handler. So our traditional method to limit ingress
> bandwidth can't work any more.
> 2). We can't redirect ingress packet to ifb with bpf
> By trying to analyze if it is possible to redirect the ingress packet to
> ifb with a bpf program, we find that the ifb device is not supported by
> bpf redirect yet.
>
> This patch tries to resolve it by supporting redirecting to ifb with bpf
> program.
>
> There're some other users who want to resolve this issue as well. By
> searching it in the lore, it shows that Jesper[1] and Tonghao[2] used to
> propose similar solution. This proposal is almost the same with Jesper's
> proposal, so I add Jesper's Co-developed-by here.
>
> [1]. https://lore.kernel.org/bpf/160650040800.2890576.9811290366501747109=
.stgit@firesoul/
> [2]. https://lore.kernel.org/netdev/20220324135653.2189-1-xiangxia.m.yue@=
gmail.com/
>
> Co-developed-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> Cc: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> ---
>  net/core/dev.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 18dc8d7..3e63f6b 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -3956,6 +3956,7 @@ int dev_loopback_xmit(struct net *net, struct sock =
*sk, struct sk_buff *skb)
>                 return NULL;
>         case TC_ACT_REDIRECT:
>                 /* No need to push/pop skb's mac_header here on egress! *=
/
> +               skb_set_redirected(skb, skb->tc_at_ingress);
>                 skb_do_redirect(skb);
>                 *ret =3D NET_XMIT_SUCCESS;
>                 return NULL;
> @@ -5138,6 +5139,7 @@ static __latent_entropy void net_tx_action(struct s=
oftirq_action *h)
>                  * redirecting to another netdev
>                  */
>                 __skb_push(skb, skb->mac_len);
> +               skb_set_redirected(skb, skb->tc_at_ingress);
>                 if (skb_do_redirect(skb) =3D=3D -EAGAIN) {
>                         __skb_pull(skb, skb->mac_len);
>                         *another =3D true;
> --
> 1.8.3.1
>

Daniel, Alexei,

Any comments on this solution?
I noticed that you have rejected the other two proposals which are
listed in the commit log, one reason is that ifb is not recommended.
But it seems we have to use ifb if we want to limit ingress bandwidth.
Or do you have any better suggestions on the ingress bandwidth limit?
Ingress bandwidth is useful in some scenarios, for example, for the
TCP-based service, there may be lots of clients connecting it, so it
is not wise to limit the peers' egress. After limiting the ingress of
the server side, it will lower the send rate of the client by lowering
the TCP cwnd if the ingress bandwidth limit is reached. If we don't
limit it, the clients will continue sending requests at a high rate.

--=20
Regards
Yafang
