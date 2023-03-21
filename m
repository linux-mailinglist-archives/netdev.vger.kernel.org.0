Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9E4E6C2E53
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 10:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbjCUJ7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 05:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjCUJ7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 05:59:16 -0400
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C072C65C;
        Tue, 21 Mar 2023 02:59:12 -0700 (PDT)
Received: by mail-ua1-x935.google.com with SMTP id e12so4897215uaa.3;
        Tue, 21 Mar 2023 02:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679392752;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IPuslHTHhonWmdHSTgUAo7eAqVJ1W+zam5YTxhxnKl4=;
        b=O7t2odPsttXz1oUu1wNJs8rBI+hTQd3CFJF3C5Ar9RVbPaUWnnBZHd4F0bYirKbAjT
         GhPLNwDX2rxietGtp16uFwCQDiWxzq840bfbeLzuU1cLs9AUVsbyVtUIPGi5ZlZN21vv
         YH+n1O8HgVo8jytAwEcab5PcbR7jBN5uRLAvQ2XwPu3AKW6fpuJ2mSHtI8qnHpq2K6hz
         ibwrcgLEAp+CMY0n4eljmj4eKtFC6vgc4jJ1vHkTQZb8ZId2QhOPJyl9+Fq3iY8f96Po
         uwJXWN9aDVFiv59YzeFo+paO49GB+5lfjc8r9upEOW2qRFK5qdeSouI3T1IO76BazyuM
         Db8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679392752;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IPuslHTHhonWmdHSTgUAo7eAqVJ1W+zam5YTxhxnKl4=;
        b=D3QdcwvyLpCGzP4VtI8t4bHczV+hdayLKxdnDMMRk6tiKj8/qshH/C8kXiJbNtSxye
         ZzXe1HhBB6Gp323aow315pVXdJ5TWMqFeLElbS3CiJIQMLjBbxe1CH8PcAdnZteKb89O
         W20RzSVM8JtDjJKEs3D1SD0OPHrdl0gHkyiYfh2RYdi7zUxub7jgtgkuue9E//foMn7U
         MG8FAXQN2eASnHNRVcYvxtPpPLOf+6Adou1WkbYrK7dbAHXcEBUmb6sSBDVrgP5jmJhW
         iZxRgBrPsPJiuW2rZ5cXijXS6MGJfU4G6AqBI7w2LEAR/jeQUMCjl7xbcjydz6G5+uDW
         R5og==
X-Gm-Message-State: AO0yUKXUjnH3vLANFbF2WJFil70vsG/p9LMyRqGs4JqTuY3pURmK6dh5
        GvOp5SgI40q6rPkfvEQALTU2k42DZFMX732q7yo=
X-Google-Smtp-Source: AK7set+jZ0QLYbX9/BXSR03NLbt8dAz/wisZU69DFinUNL00prHkakgjJ69ebxImcp2dHOLJHmLG08yabdj4PabN+Ng=
X-Received: by 2002:ab0:378c:0:b0:68a:5bba:ba40 with SMTP id
 d12-20020ab0378c000000b0068a5bbaba40mr990824uav.1.1679392751854; Tue, 21 Mar
 2023 02:59:11 -0700 (PDT)
MIME-Version: 1.0
References: <20230319220954.21834-1-josef@miegl.cz>
In-Reply-To: <20230319220954.21834-1-josef@miegl.cz>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Tue, 21 Mar 2023 11:59:02 +0200
Message-ID: <CAHsH6GugMRzxJRpwK6F6hWXRJ3-o3kqXrnvjXSWZqSLBGv9_VA@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: geneve: accept every ethertype
To:     Josef Miegl <josef@miegl.cz>
Cc:     Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
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

On Mon, Mar 20, 2023 at 12:10=E2=80=AFAM Josef Miegl <josef@miegl.cz> wrote=
:
>
> The Geneve encapsulation, as defined in RFC 8926, has a Protocol Type
> field, which states the Ethertype of the payload appearing after the
> Geneve header.
>
> Commit 435fe1c0c1f7 ("net: geneve: support IPv4/IPv6 as inner protocol")
> introduced a new IFLA_GENEVE_INNER_PROTO_INHERIT flag that allowed the
> use of other Ethertypes than Ethernet. However, it did not get rid of a
> restriction that prohibits receiving payloads other than Ethernet,
> instead the commit white-listed additional Ethertypes, IPv4 and IPv6.
>
> This patch removes this restriction, making it possible to receive any
> Ethertype as a payload, if the IFLA_GENEVE_INNER_PROTO_INHERIT flag is
> set.
>
> The restriction was set in place back in commit 0b5e8b8eeae4
> ("net: Add Geneve tunneling protocol driver"), which implemented a
> protocol layer driver for Geneve to be used with Open vSwitch. The
> relevant discussion about introducing the Ethertype white-list can be
> found here:
> https://lore.kernel.org/netdev/CAEP_g=3D_1q3ACX5NTHxLDnysL+dTMUVzdLpgw1ap=
LKEdDSWPztw@mail.gmail.com/
>
> <quote>
> >> +       if (unlikely(geneveh->proto_type !=3D htons(ETH_P_TEB)))
> >
> > Why? I thought the point of geneve carrying protocol field was to
> > allow protocols other than Ethernet... is this temporary maybe?
>
> Yes, it is temporary. Currently OVS only handles Ethernet packets but
> this restriction can be lifted once we have a consumer that is capable
> of handling other protocols.
> </quote>
>
> This white-list was then ported to a generic Geneve netdevice in commit
> 371bd1061d29 ("geneve: Consolidate Geneve functionality in single
> module."). Preserving the Ethertype white-list at this point made sense,
> as the Geneve device could send out only Ethernet payloads anyways.
>
> However, now that the Geneve netdevice supports encapsulating other
> payloads with IFLA_GENEVE_INNER_PROTO_INHERIT and we have a consumer
> capable of other protocols, it seems appropriate to lift the restriction
> and allow any Geneve payload to be received.
>
> Signed-off-by: Josef Miegl <josef@miegl.cz>
> ---
>  drivers/net/geneve.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
> index 89ff7f8e8c7e..32684e94eb4f 100644
> --- a/drivers/net/geneve.c
> +++ b/drivers/net/geneve.c
> @@ -365,13 +365,6 @@ static int geneve_udp_encap_recv(struct sock *sk, st=
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
> @@ -380,6 +373,8 @@ static int geneve_udp_encap_recv(struct sock *sk, str=
uct sk_buff *skb)
>         if (!geneve)
>                 goto drop;
>
> +       inner_proto =3D geneveh->proto_type;
> +
>         if (unlikely((!geneve->cfg.inner_proto_inherit &&
>                       inner_proto !=3D htons(ETH_P_TEB)))) {
>                 geneve->dev->stats.rx_dropped++;
> --
> 2.37.1
>

Reviewed-by: Eyal Birger <eyal.birger@gmail.com>
