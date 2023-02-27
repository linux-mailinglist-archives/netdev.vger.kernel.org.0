Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A52A6A3F11
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 11:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbjB0KCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 05:02:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbjB0KC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 05:02:27 -0500
Received: from ocelot.miegl.cz (ocelot.miegl.cz [195.201.216.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0EE81F487;
        Mon, 27 Feb 2023 02:02:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=miegl.cz; s=dkim;
        t=1677492143;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BfRBS7YggZB0NOcMmXuVi9vO2zadv+Ccq7H9EPZFHXA=;
        b=Qj1XePcxCyZ490KrojW9DPHDz8I2VdVD5DE+YTiGXBp9OZ3KfaCJx1OoJ7fo1SpuXn2LJ2
        WdvdvOBrWaHNHwGSOGW+bzpBFJGR4JDdS23kmfoNlIFOuF9dPQ+AdvXZqiaAvg7PYk5VNq
        J3+3PCdLulnjTLJBsegkGaG6vHDTJlbVHmrmMhxl7h5Y9Sh3zgG7gMVL6BPvb8d8J5zs95
        +IUJ4Za89A3gxG2IumiC+X0qcX1D30D/CmvSJEZW62zYoypuZtxmBUPxlhc1HbnXyBAHs+
        /St0UBAER9XLo3FLO4O4zb8AtbUGpcBpeyPn9kEGiNvJbCdkqMpa7Ut6HxdaYQ==
MIME-Version: 1.0
Date:   Mon, 27 Feb 2023 10:02:23 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: RainLoop/1.16.0
From:   "Josef Miegl" <josef@miegl.cz>
Message-ID: <0abab84afdaa4817522b7ee2bd2879f9@miegl.cz>
Subject: Re: [PATCH v2 1/1] net: geneve: accept every ethertype
To:     "Eyal Birger" <eyal.birger@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <CAHsH6GvCecnq6Cte=ktRB+BxdZMo4Mi0z-hBDD3kFkENeWUfdQ@mail.gmail.com>
References: <CAHsH6GvCecnq6Cte=ktRB+BxdZMo4Mi0z-hBDD3kFkENeWUfdQ@mail.gmail.com>
 <20230227074104.42153-1-josef@miegl.cz>
 <20230227074104.42153-2-josef@miegl.cz>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

February 27, 2023 10:31 AM, "Eyal Birger" <eyal.birger@gmail.com> wrote:

> On Mon, Feb 27, 2023 at 10:14 AM Josef Miegl <josef@miegl.cz> wrote:
>=20
>>=20This patch removes a restriction that prohibited receiving encapsula=
ted
>> ethertypes other than IPv4, IPv6 and Ethernet.
>>=20
>>=20With IFLA_GENEVE_INNER_PROTO_INHERIT flag set, GENEVE interface can =
now
>> receive ethertypes such as MPLS.
>>=20
>>=20Signed-off-by: Josef Miegl <josef@miegl.cz>
>> ---
>> drivers/net/geneve.c | 15 ++++-----------
>> 1 file changed, 4 insertions(+), 11 deletions(-)
>>=20
>>=20diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
>> index 89ff7f8e8c7e..7973659a891f 100644
>> --- a/drivers/net/geneve.c
>> +++ b/drivers/net/geneve.c
>> @@ -353,7 +353,6 @@ static int geneve_udp_encap_recv(struct sock *sk, =
struct sk_buff *skb)
>> struct genevehdr *geneveh;
>> struct geneve_dev *geneve;
>> struct geneve_sock *gs;
>> - __be16 inner_proto;
>=20
>=20nit: why remove the variable? - it's still used in two places and thi=
s
> change just makes the patch longer.

I thought making the code shorter would be a better option, usage in two
places doesn't justify a dedicated variable in my mind.

>> int opts_len;
>>=20
>>=20/* Need UDP and Geneve header to be present */
>> @@ -365,13 +364,6 @@ static int geneve_udp_encap_recv(struct sock *sk,=
 struct sk_buff *skb)
>> if (unlikely(geneveh->ver !=3D GENEVE_VER))
>> goto drop;
>>=20
>>=20- inner_proto =3D geneveh->proto_type;
>> -
>> - if (unlikely((inner_proto !=3D htons(ETH_P_TEB) &&
>> - inner_proto !=3D htons(ETH_P_IP) &&
>> - inner_proto !=3D htons(ETH_P_IPV6))))
>> - goto drop;
>> -
>> gs =3D rcu_dereference_sk_user_data(sk);
>> if (!gs)
>> goto drop;
>> @@ -381,14 +373,15 @@ static int geneve_udp_encap_recv(struct sock *sk=
, struct sk_buff *skb)
>> goto drop;
>>=20
>>=20if (unlikely((!geneve->cfg.inner_proto_inherit &&
>> - inner_proto !=3D htons(ETH_P_TEB)))) {
>> + geneveh->proto_type !=3D htons(ETH_P_TEB)))) {
>> geneve->dev->stats.rx_dropped++;
>> goto drop;
>> }
>>=20
>>=20opts_len =3D geneveh->opt_len * 4;
>> - if (iptunnel_pull_header(skb, GENEVE_BASE_HLEN + opts_len, inner_pro=
to,
>> - !net_eq(geneve->net, dev_net(geneve->dev)))) {
>> + if (iptunnel_pull_header(skb, GENEVE_BASE_HLEN + opts_len,
>> + geneveh->proto_type, !net_eq(geneve->net,
>> + dev_net(geneve->dev)))) {
>> geneve->dev->stats.rx_dropped++;
>> goto drop;
>> }
>> --
>> 2.37.1
