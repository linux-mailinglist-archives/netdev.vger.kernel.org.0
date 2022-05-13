Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E07EE526291
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 15:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380569AbiEMNGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 09:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240402AbiEMNFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 09:05:53 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7776E65A0
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 06:05:49 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id y76so15252479ybe.1
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 06:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ISpUb3cunM0e3poMu4A6eqmiuSNDRqXYc5HDsENLeWA=;
        b=S7Npmq6lwHK1l28Gpl/6C63/Uc2V3AU2l7jDTxLDC+prXNzsMkcyMM2hIB7xDWQ9wT
         KcHR+I2VFdxPUQQI60F5pHFNE/0e018BRZFfOxLLhMhDZXgeGes0IIsWHwi3cyLvalK6
         40IB0jzfeGzxthEWbgU0At5aoHbSRfszsWobbWVLKwTlH2Vy5H8eLYNdcLFxyIQ6+jKR
         Wx6S5Yj0y1TIBF+bdgJdPQ5Kc0XKq947cID1R+naU6guMb/xWIwK2FsBVEowg6sks/3m
         vUixcPAb/GgYJVjAn1qTMJjSbQJ1RYoMrpsVxBYN/1jZPgrHQPhdTvbmx2IgeqajEXqK
         RLkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ISpUb3cunM0e3poMu4A6eqmiuSNDRqXYc5HDsENLeWA=;
        b=agu97Pc5OhSHKS7IErnefj3OeIa5wQUMRpIKVIojd5xt/k9E2E1w05h+lllLJARXhc
         i4sfzJfOHjDeCqSUtIQAQ8Xua9ad1z5j1GUOz+E+HVFpegiPto7JmpZJIguORhP97MWX
         OZ+XXz0ZC2lc5wbHqUllzfw71amglaLEA9sFhe1GFZNZR5oAdQSSIR6RXCQxdnmQGOs8
         qUuq5zcc0ezz7MHFaZS03MSLdCGAuWWSloKTvBZCu3UkhcoK12IF39ppw/JcpyZdObnf
         7cdvLl+EoONHV50sdfeluHkoVL5lmb+ynP1z5t84ETEA4sIRQlitOmPHKIKE6OGt2mZL
         hePw==
X-Gm-Message-State: AOAM5302Fvzxa4wYEwVkZ7CmD+WbEV7WHKjIdOf5XCqTcHX0dz0PIbwe
        TeEoLddKwF5eZZO56AF4DriQeNzBTLClkByHoMfoKQ==
X-Google-Smtp-Source: ABdhPJyOaqxU21eTwqfZecEw7zEuf6oyI2xo+GMG6A4yNtulHaxq/fhdQe4RMVtWqtbDM1n9wRMMNvUJa/iE90VZgUc=
X-Received: by 2002:a25:3157:0:b0:649:b216:bb4e with SMTP id
 x84-20020a253157000000b00649b216bb4emr4847319ybx.387.1652447148279; Fri, 13
 May 2022 06:05:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220510033219.2639364-1-eric.dumazet@gmail.com>
 <20220510033219.2639364-14-eric.dumazet@gmail.com> <20220512084023.tgjcecnu6vfuh7ry@LT-SAEEDM-5760.attlocal.net>
 <51bc118ff452c42fef489818422f278ab79e6dd4.camel@redhat.com>
 <20220513042955.rnid4776hwp556vr@fedora> <CANn89iKSs3bwUBho_XEuSBRB+v+iR98OZTrhaSS88D4ZYwCwSA@mail.gmail.com>
 <20220513054945.6zpaegnsgtued4up@fedora>
In-Reply-To: <20220513054945.6zpaegnsgtued4up@fedora>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 13 May 2022 06:05:36 -0700
Message-ID: <CANn89i+Y8XO9b2LSLorER2-NEPzfcAo3uG+VDxrTcimyS-kdTg@mail.gmail.com>
Subject: Re: [PATCH v6 net-next 13/13] mlx5: support BIG TCP packets
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Tariq Toukan <tariqt@nvidia.com>,
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

On Thu, May 12, 2022 at 10:49 PM Saeed Mahameed <saeedm@nvidia.com> wrote:
>
> On 12 May 21:34, Eric Dumazet wrote:
> >On Thu, May 12, 2022 at 9:29 PM Saeed Mahameed <saeedm@nvidia.com> wrote:
> >>
> >> On 12 May 11:02, Paolo Abeni wrote:
> >> >On Thu, 2022-05-12 at 01:40 -0700, Saeed Mahameed wrote:
> >> >> On 09 May 20:32, Eric Dumazet wrote:
> >> >> > From: Coco Li <lixiaoyan@google.com>
> >> >> >
> >> >> > mlx5 supports LSOv2.
> >> >> >
> >> >> > IPv6 gro/tcp stacks insert a temporary Hop-by-Hop header
> >> >> > with JUMBO TLV for big packets.
> >> >> >
> >> >> > We need to ignore/skip this HBH header when populating TX descriptor.
> >> >> >
> >> >>
> >> >> Sorry i didn't go through all the documentations or previous discussions,
> >> >> please bare with me, so why not clear HBH just before calling the
> >> >> driver xmit ndo ?
> >> >
> >> >I guess this way is more efficient: the driver copies IP hdr and TCP
> >> >hdr directly in the correct/final location into the tx descriptor,
> >> >otherwise the caller would have to memmove L2/L3 just before the driver
> >> >copies them again.
> >> >>
> >>
> >> memmove(sizeof(L2/L3)) is not that bad when done only every 64KB+.
> >> it's going to be hard to repeat this and maintain this across all drivers
> >> only to get this micro optimization that I doubt it will be even measurable.
> >
> >We prefer not changing skb->head, this would break tcpdump.
> >
>
> in that case we can provide a helper to the drivers to call, just before
> they start processing the skb.
>
> >Surely calling skb_cow_head() would incur a cost.
> >
>
> Sure, but the benefit of this patch outweighs this cost by orders of
> magnitude, you pay an extra 0.1$ for a cleaner code, and you still
> get your 64K$ BIG TCP cash.
>
> >As I suggested, we can respin the series without the mlx5 patch, this
> >is totally fine for us, if we can avoid missing 5.19 train.
>
> To be clear, I am not nacking, Tariq already reviewed and gave his blessing,
> and i won't resist this patch on v6. I am Just suggesting an improvement
> to code readability and scalability to other drivers.

The problem is that  skb_cow_head() can fail.

Really we have thought about this already.

A common helper for drivers is mostly unusable, you would have to
pre-allocate a per TX-ring slot to store the headers.
We would end up with adding complexity at queue creation/dismantle.

We could do that later, because some NICs do not inline the headers in
TX descriptor, but instead request
one mapped buffer for the headers part only.

BTW, I know Tariq already reviewed, the issue at hand is about
CONFIG_FORTIFY which is blocking us.

This is why I was considering not submitting mlx5 change until Kees
Cook and others come up with a solution.
