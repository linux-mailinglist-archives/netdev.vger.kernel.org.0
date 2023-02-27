Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 004D06A3E61
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 10:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbjB0JcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 04:32:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjB0JcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 04:32:05 -0500
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C57E39EE2;
        Mon, 27 Feb 2023 01:32:04 -0800 (PST)
Received: by mail-vs1-xe34.google.com with SMTP id s1so9956941vsk.5;
        Mon, 27 Feb 2023 01:32:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jx8ppxvsllfoE8OaQDtiDMUsuJo7Lm5MwuLPe8/67Fo=;
        b=QF9updo/N1vMgQ/PwZMkHQobEY+culvS/JV/e1NrZiFROWYkgOfu3DlFCmV3SfR+P7
         40X5oqZjDzdDe9EhomhRX4VjgPpZyYOnJcdyhOKNlo9oOx40Wvt6sjwwi4eHu4RYjMqg
         xzuEimNYZew+vDo8ZgQFLhy9JH5HR0I4cT7pJrvrzEXNT3mGyjIMSCQr1qxkzrjn+b82
         AuwIIDtKXLU6RPihBshk/QJF9xYjuxunku9BbU3qh5WduTb6OCvzPFCJdFt5w4EZlbu1
         BsuJzaXxW4ahOTNmczq2630ZmN6Owfxd845fGvyMvhjFx8BH0Hp345golcv69iI+UMoP
         WbUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jx8ppxvsllfoE8OaQDtiDMUsuJo7Lm5MwuLPe8/67Fo=;
        b=tr5+ImU3qQ2QF7vlzqXz9hUCFLZodyKvc4dYE00yvFTz/UWt0DyX3E4dj2BbjuaxhG
         U4dz2FA9LhdRt2Lo52fFFr5jx9zV0LcB9rZUjdvIm4wR6UAUOCZX7pmBXZGM24+Jhqia
         yseToSeZ9IT3r3/gHX7cfWkJGgb7khivTixb6PV3K5z9DTUWRJU1u8CXdkp8GZF9UmXr
         OFszcfutNYscBtbIsSqyQrZs+w8DD7tbg8+bCtgRaD197Te+P4fnCbwf1IJMLiXUU2e0
         Rm+UW7loU4Gc8ynZ6OTiutKgYe8DbPiBJe+cKtY4g4TJ6E/qxnzFNSVYKWI2wgu8ptVn
         wSXw==
X-Gm-Message-State: AO0yUKU8/IEZwXaGRQPcl5PcoqKcTJZrASNbz6B6BMOTxcCmIIxHOv7q
        cJYf2otRmSrWI+dmaN5JvVvMqs2GT+S9+B1Bt5s=
X-Google-Smtp-Source: AK7set/8q3HifJOXHO3kWgxksBr8ggA4em390UtYQzEkPIL2rtmzYiY5KLjitHRZI6tYj9dWrBJYYuUuX9Vx7NgJZ2U=
X-Received: by 2002:a05:6102:30b3:b0:412:27f7:491b with SMTP id
 y19-20020a05610230b300b0041227f7491bmr6886274vsd.2.1677490323783; Mon, 27 Feb
 2023 01:32:03 -0800 (PST)
MIME-Version: 1.0
References: <20230227074104.42153-1-josef@miegl.cz> <20230227074104.42153-2-josef@miegl.cz>
In-Reply-To: <20230227074104.42153-2-josef@miegl.cz>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Mon, 27 Feb 2023 11:31:51 +0200
Message-ID: <CAHsH6GvCecnq6Cte=ktRB+BxdZMo4Mi0z-hBDD3kFkENeWUfdQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] net: geneve: accept every ethertype
To:     Josef Miegl <josef@miegl.cz>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 27, 2023 at 10:14=E2=80=AFAM Josef Miegl <josef@miegl.cz> wrote=
:
>
> This patch removes a restriction that prohibited receiving encapsulated
> ethertypes other than IPv4, IPv6 and Ethernet.
>
> With IFLA_GENEVE_INNER_PROTO_INHERIT flag set, GENEVE interface can now
> receive ethertypes such as MPLS.
>
> Signed-off-by: Josef Miegl <josef@miegl.cz>
> ---
>  drivers/net/geneve.c | 15 ++++-----------
>  1 file changed, 4 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
> index 89ff7f8e8c7e..7973659a891f 100644
> --- a/drivers/net/geneve.c
> +++ b/drivers/net/geneve.c
> @@ -353,7 +353,6 @@ static int geneve_udp_encap_recv(struct sock *sk, str=
uct sk_buff *skb)
>         struct genevehdr *geneveh;
>         struct geneve_dev *geneve;
>         struct geneve_sock *gs;
> -       __be16 inner_proto;

nit: why remove the variable? - it's still used in two places and this
change just makes the patch longer.

>         int opts_len;
>
>         /* Need UDP and Geneve header to be present */
> @@ -365,13 +364,6 @@ static int geneve_udp_encap_recv(struct sock *sk, st=
ruct sk_buff *skb)
>         if (unlikely(geneveh->ver !=3D GENEVE_VER))
>                 goto drop;
>
> -       inner_proto =3D geneveh->proto_type;
> -
> -       if (unlikely((inner_proto !=3D htons(ETH_P_TEB) &&
> -                     inner_proto !=3D htons(ETH_P_IP) &&
> -                     inner_proto !=3D htons(ETH_P_IPV6))))
> -               goto drop;
> -
>         gs =3D rcu_dereference_sk_user_data(sk);
>         if (!gs)
>                 goto drop;
> @@ -381,14 +373,15 @@ static int geneve_udp_encap_recv(struct sock *sk, s=
truct sk_buff *skb)
>                 goto drop;
>
>         if (unlikely((!geneve->cfg.inner_proto_inherit &&
> -                     inner_proto !=3D htons(ETH_P_TEB)))) {
> +                     geneveh->proto_type !=3D htons(ETH_P_TEB)))) {
>                 geneve->dev->stats.rx_dropped++;
>                 goto drop;
>         }
>
>         opts_len =3D geneveh->opt_len * 4;
> -       if (iptunnel_pull_header(skb, GENEVE_BASE_HLEN + opts_len, inner_=
proto,
> -                                !net_eq(geneve->net, dev_net(geneve->dev=
)))) {
> +       if (iptunnel_pull_header(skb, GENEVE_BASE_HLEN + opts_len,
> +                                geneveh->proto_type, !net_eq(geneve->net=
,
> +                                dev_net(geneve->dev)))) {
>                 geneve->dev->stats.rx_dropped++;
>                 goto drop;
>         }
> --
> 2.37.1
>
