Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8A74D40D7
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 06:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239614AbiCJFl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 00:41:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234788AbiCJFl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 00:41:57 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D99125C9F
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 21:40:57 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id f38so8858331ybi.3
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 21:40:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rtLkO2GxyVd8sBrP8Fva7ZLa5SwwD14e6xCJdcvaeUY=;
        b=pZVRifOX4ASKO/ByPoTLKbuTiqMvJPp7Ybuwl9D0kAMfJF1alpC3KZxi7xPbqptIIs
         5eu3rDnXiqSk+57sWANLneZfuaj9PvYhpfpjkL3egUQI/bLQily/vVybNIV7j2sxZpI0
         oC2sh53fXBVNK7m5jKhFVkxmpQO1sKLwTiDUhqHIbkavkiLHojhJeyiKBCQGSV4jl0wA
         snymk4JuZEfAcDjMk8eJKQjfwl3aVB6me2lM+95NaKbfmfpLqn+bCd5xqrbN8YkE9LM/
         2UJoj6Z35ujiQYe5gG4ayYAbUfqB3MV2yzu3kERkV20Cb5pPVePfU3brM/1h3Vma8ij2
         OBiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rtLkO2GxyVd8sBrP8Fva7ZLa5SwwD14e6xCJdcvaeUY=;
        b=b8J10IC6ay3F//e1R0niJEVEX+1jd+hIbb+fURNnHpDCwnHplQwI9Lg94bdZD6ka0Z
         r4pOBJio+sQAr2LyfJP3YNrcFtXshDxdk8rB8LZyKJn/D3wtUGREiqkeqUkL1iG8YOEd
         cgyZWlH4jSHdmEMM0D51CaE/8ZTVNj51tT1S1KZr1j4g4cYPGxin0nr79ikjgchR0luN
         CqjG2jmAzjG3xg7vHZOw2bGpubx1nRh4F4wG9/O+Bm4QMvJOaZdleSlGPQ4OCcLdsDnV
         IMFw7GBtL9WACBKhsV0SZHu1MQw3W8SaqbLHKebfVeS1lc/BjuZuv6Va2dbbTKe9fka4
         cP2w==
X-Gm-Message-State: AOAM531QP/95qRctZq67aacFnSBO7gEhx6X7cpMrx9g+9D1yxccbE4Xr
        J15KjIWZ9jfZHEWFVcuvb5QNGMLoeAmL4omGiQM+qg==
X-Google-Smtp-Source: ABdhPJwpf3kHbqVgHUNrBewyFty47vrICZjWKeSJfGBgCaq9+C0FdgMuf1Kw1n0ibCpPvHZPgOlA6P6p0F9CcrS8xmg=
X-Received: by 2002:a25:8c86:0:b0:628:a042:9529 with SMTP id
 m6-20020a258c86000000b00628a0429529mr2653073ybl.231.1646890855961; Wed, 09
 Mar 2022 21:40:55 -0800 (PST)
MIME-Version: 1.0
References: <20220310002846.460907-1-eric.dumazet@gmail.com>
 <20220310002846.460907-15-eric.dumazet@gmail.com> <20220309204405.58079350@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220309204405.58079350@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 9 Mar 2022 21:40:44 -0800
Message-ID: <CANn89iJumPY4F5Gew1sP_monDqXR+KL0uk8vwV8N9ZXS7Yi=hw@mail.gmail.com>
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

On Wed, Mar 9, 2022 at 8:44 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed,  9 Mar 2022 16:28:46 -0800 Eric Dumazet wrote:
> > @@ -918,12 +953,27 @@ void mlx5i_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
> >       eseg->mss = attr.mss;
> >
> >       if (attr.ihs) {
> > -             memcpy(eseg->inline_hdr.start, skb->data, attr.ihs);
> > +             if (unlikely(attr.hopbyhop)) {
> > +                     /* remove the HBH header.
> > +                      * Layout: [Ethernet header][IPv6 header][HBH][TCP header]
> > +                      */
> > +                     memcpy(eseg->inline_hdr.start, skb->data, ETH_HLEN + sizeof(*h6));
> > +                     h6 = (struct ipv6hdr *)((char *)eseg->inline_hdr.start + ETH_HLEN);
> > +                     h6->nexthdr = IPPROTO_TCP;
> > +                     /* Copy the TCP header after the IPv6 one */
> > +                     memcpy(h6 + 1,
> > +                            skb->data + ETH_HLEN + sizeof(*h6) +
> > +                                     sizeof(struct hop_jumbo_hdr),
> > +                            tcp_hdrlen(skb));
> > +                     /* Leave ipv6 payload_len set to 0, as LSO v2 specs request. */
> > +             } else {
> > +                     memcpy(eseg->inline_hdr.start, skb->data, attr.ihs);
> > +             }
>
> Compiler says there's no h6 in mlx5i_sq_xmit().

Ah, we missed CONFIG_MLX5_CORE_IPOIB=y it seems.

Let me take a look before sending the fix.
