Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1F6B4D40D8
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 06:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239615AbiCJFoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 00:44:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234788AbiCJFo3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 00:44:29 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64027A1442
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 21:43:28 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id j2so8962301ybu.0
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 21:43:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ebLxDB1oRSFY8FkeMu3wExBSOSYf7IEqqmSE20RsQ2E=;
        b=j88cou5ODN/X00pzQWVadfnN4o4WQnZa4nW9Yc/JptHSk45oG/CfXRFUn1c/P5G/SK
         sla1gFKPxHcr3nvhYuwxNYHiw+sMiFFiy3h0cTrKhZRD0UrcfU4KA3QzOgUDnnnvGH5M
         O3jxB/70FEsSRaccMcKQd+B5tirdt37m0N4pLlTvNLWolb7xCmLI9bFwyyPUZZ0ZQ9zZ
         /WVhMvNWTjWeEDN3Gd7pkEiwfKs3gV60+H1kE8OxsSWPFR5Q1qVagVEMtiK6y2XP+1BE
         oI69mzU6AVrDinaki49o/wKVikF4fOOqiG1cgijUDVrBOjoN3Dwv3FkCQ8GjDwIhqGCq
         XSsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ebLxDB1oRSFY8FkeMu3wExBSOSYf7IEqqmSE20RsQ2E=;
        b=xEYQMhLhcqIHN7vH0i5SgOMyY3q8fuDGvHRZGBCQzhL/WeAaglrLhg2Z9UutxBEd9p
         vmSXCEFiuq2Qfx8sdGFeeE1FTLl1Y3et8NzN7lqP3FBwWLvtLD7FZQULPtjbZk+0Dm8N
         PmFo/moY/WYOr6l15uqL7Vx82rq6BwQciIFL+keYaEUnfCJKnkxtZ1PTTNAceIWfESdk
         7IHgHHtF85rGIKE1KRVewwLsQlWCONudlWZX1i4sP3ZAfWjmv+MkR3NmQszNgs3mdDo6
         5xhCJ+fIiEx9/dBb7CNhh95wXMX6d8WwdCFDOwF1IJOvOFHHHvR2qSo+gXxy4iUJft+E
         Zogw==
X-Gm-Message-State: AOAM531Wcvvj4zztDEqgCtGfvi08GWOP/5N+7ZwSQfRfXKQh+OeC38YB
        Dm5gSvuUloy3uasUY+RnWm0QG4Q5q2cxoiNFPp+J/w==
X-Google-Smtp-Source: ABdhPJxUjpeOSnUCK8a/ZoEAAZbhqQ+l0V8Pe2llStxX/3UNuTp+MihdNpMEhJLzxk/KPRWRjtdU+NZyvoTvsJ+XR8o=
X-Received: by 2002:a25:f441:0:b0:611:4f60:aab1 with SMTP id
 p1-20020a25f441000000b006114f60aab1mr2795903ybe.598.1646891007293; Wed, 09
 Mar 2022 21:43:27 -0800 (PST)
MIME-Version: 1.0
References: <20220310002846.460907-1-eric.dumazet@gmail.com>
 <20220310002846.460907-15-eric.dumazet@gmail.com> <20220309204405.58079350@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89iJumPY4F5Gew1sP_monDqXR+KL0uk8vwV8N9ZXS7Yi=hw@mail.gmail.com>
In-Reply-To: <CANn89iJumPY4F5Gew1sP_monDqXR+KL0uk8vwV8N9ZXS7Yi=hw@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 9 Mar 2022 21:43:16 -0800
Message-ID: <CANn89iJwWQ30u3DGawRWGaQHAGjh2r=X-5wbF44m=wAyf0a0PA@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 14/14] mlx5: support BIG TCP packets
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 9, 2022 at 9:40 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Wed, Mar 9, 2022 at 8:44 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Wed,  9 Mar 2022 16:28:46 -0800 Eric Dumazet wrote:
> > > @@ -918,12 +953,27 @@ void mlx5i_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
> > >       eseg->mss = attr.mss;
> > >
> > >       if (attr.ihs) {
> > > -             memcpy(eseg->inline_hdr.start, skb->data, attr.ihs);
> > > +             if (unlikely(attr.hopbyhop)) {
> > > +                     /* remove the HBH header.
> > > +                      * Layout: [Ethernet header][IPv6 header][HBH][TCP header]
> > > +                      */
> > > +                     memcpy(eseg->inline_hdr.start, skb->data, ETH_HLEN + sizeof(*h6));
> > > +                     h6 = (struct ipv6hdr *)((char *)eseg->inline_hdr.start + ETH_HLEN);
> > > +                     h6->nexthdr = IPPROTO_TCP;
> > > +                     /* Copy the TCP header after the IPv6 one */
> > > +                     memcpy(h6 + 1,
> > > +                            skb->data + ETH_HLEN + sizeof(*h6) +
> > > +                                     sizeof(struct hop_jumbo_hdr),
> > > +                            tcp_hdrlen(skb));
> > > +                     /* Leave ipv6 payload_len set to 0, as LSO v2 specs request. */
> > > +             } else {
> > > +                     memcpy(eseg->inline_hdr.start, skb->data, attr.ihs);
> > > +             }
> >
> > Compiler says there's no h6 in mlx5i_sq_xmit().
>
> Ah, we missed CONFIG_MLX5_CORE_IPOIB=y it seems.
>
> Let me take a look before sending the fix.

I will squash this:

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index c6f6ca2d216692e1d3fd99e540198b11145788cd..b4fc45ba1b347fb9ad0f46b9c091cc45e4d3d84f
100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -954,6 +954,8 @@ void mlx5i_sq_xmit(struct mlx5e_txqsq *sq, struct
sk_buff *skb,

        if (attr.ihs) {
                if (unlikely(attr.hopbyhop)) {
+                       struct ipv6hdr *h6;
+
                        /* remove the HBH header.
                         * Layout: [Ethernet header][IPv6
header][HBH][TCP header]
                         */
