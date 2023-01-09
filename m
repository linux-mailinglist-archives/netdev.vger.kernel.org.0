Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26565662F99
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 19:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237079AbjAIS4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 13:56:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236629AbjAIS4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 13:56:44 -0500
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D486514087
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 10:56:42 -0800 (PST)
Received: by mail-ua1-x92e.google.com with SMTP id s23so2247236uac.6
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 10:56:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7KwQUeeR5QSPgzpY6jiT6dAWtw1nRUiNx0AzC8NJLns=;
        b=jpXq/9h3Ga0caklXtJoVplkskXTJh73rgxwqq5X2p6FZjAG9agA4zZ8Ucn6PCCCkdC
         GrbJVup1FuPcHVkm886XjwBZTX3agjh6WpXyNMzEO/2+3sKQcXKtMjNcdGTpcpCr9agw
         PFn1Ai4J6TWY7SFq4kLVCbW3jM6wUBjz0pYHElFrS86eMrpZZrIITqLJGCbiFwYn0zF6
         7QDupBM93VJR05hX4q8w9peEFmUyT72EyYUy3zAGKxketpTlRK1K3d9Q2IRb2VrfSkZD
         nGRXoXw1YTbMzgtiU/T9xZC2eiphoROUCHh1+lW+k27HWLZsvqrztyTzF7F6RvxZrfom
         cEsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7KwQUeeR5QSPgzpY6jiT6dAWtw1nRUiNx0AzC8NJLns=;
        b=do4OmYpI6c7PqOnpJl1G/EbHpuh2ZaJB+wAG+OUFMZROj7yFq+eTP4/3u4tEPbiBJs
         7+H8VfDK7oJncW2K3J0GXkYm0RBTaHYQa32/9WpJBrBSqCLMZFRyV1KRYerI+Sjnip6x
         oHM3mKUoo8A7SNBkOUS5qH8+ZKdABvOOFxh2WZtvXKbOz+tbjApEvwTtVNOhuV0rEp+C
         nhH2FQZUFq0A1FV5ynhPmQvGqoDIjD2ibQXnJ3ZwtQPGstC0UgTm7QaORGobOtIyBQCz
         4j07W+byd6iFjeJ6AUquUbwm5XKMYpYMpd/ZEl5Y1xU/xbzz1ICbIg66tpaQ7/Abo5cu
         Wluw==
X-Gm-Message-State: AFqh2kqVN7dkyfeH170Pf2Bc8yusTYy++yvFokXkNQBTQQtEwJtKZTsx
        2LigSGR2xwEj8e2sUDcMOZ9/rhORMmZ7ZtFJXZPphQ==
X-Google-Smtp-Source: AMrXdXv48T/onznVoPdBpm6HtuX7vcEWrgZ75+JWcG1dDF0dw4USBUv18w1DxXp1hrGGy0u2Ulf2lM4omjV/XODJvaE=
X-Received: by 2002:ab0:7548:0:b0:419:912:55e with SMTP id k8-20020ab07548000000b004190912055emr7142150uaq.89.1673290601794;
 Mon, 09 Jan 2023 10:56:41 -0800 (PST)
MIME-Version: 1.0
References: <20230103220511.3378316-1-sean.anderson@seco.com>
 <20230103220511.3378316-5-sean.anderson@seco.com> <20230105140421.bqd2aed6du5mtxn4@skbuf>
 <6ffe6719-648c-36aa-74be-467c8db40531@seco.com> <20230105173445.72rvdt4etvteageq@skbuf>
 <Y7cNCK4h0do9pEPo@shell.armlinux.org.uk> <20230106230343.2noq2hxr4quqbtk4@skbuf>
 <3ede0be8-4da5-4f64-6c67-4c9e7853ea50@seco.com>
In-Reply-To: <3ede0be8-4da5-4f64-6c67-4c9e7853ea50@seco.com>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Mon, 9 Jan 2023 10:56:28 -0800
Message-ID: <CAJ+vNU2vGiDdAEddUqMvdTwXT+33iA=Un7rSfTJHZwpBAWKGvw@mail.gmail.com>
Subject: Re: [PATCH net-next v5 4/4] phy: aquantia: Determine rate adaptation
 support from registers
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 6, 2023 at 3:21 PM Sean Anderson <sean.anderson@seco.com> wrote:
>
> On 1/6/23 18:03, Vladimir Oltean wrote:
> > On Thu, Jan 05, 2023 at 05:46:48PM +0000, Russell King (Oracle) wrote:
> >> On Thu, Jan 05, 2023 at 07:34:45PM +0200, Vladimir Oltean wrote:
> >> > So we lose the advertisement of 5G and 2.5G, even if the firmware is
> >> > provisioned for them via 10GBASE-R rate adaptation, right? Because when
> >> > asked "What kind of rate matching is supported for 10GBASE-R?", the
> >> > Aquantia driver will respond "None".
> >>
> >> The code doesn't have the ability to do any better right now - since
> >> we don't know what sets of interface modes _could_ be used by the PHY
> >> and whether each interface mode may result in rate adaption.
> >>
> >> To achieve that would mean reworking yet again all the phylink
> >> validation from scratch, and probably reworking phylib and most of
> >> the PHY drivers too so that they provide a lot more information
> >> about their host interface behaviour.
> >>
> >> I don't think there is an easy way to have a "perfect" solution
> >> immediately - it's going to take a while to evolve - and probably
> >> painfully evolve due to the slowness involved in updating all the
> >> drivers that make use of phylink in some way.
> >
> > Serious question. What do we gain in practical terms with this patch set
> > applied? With certain firmware provisioning, some unsupported link modes
> > won't be advertised anymore. But also, with other firmware, some supported
> > link modes won't be advertised anymore.
>
> Well, before the rate adaptation series, none of this would be
> advertised. I would rather add advertisement only for what we can
> actually support. We can always come back later and add additional
> support.
>
> > IIUC, Tim Harvey's firmware ultimately had incorrect provisioning, it's
> > not like the existing code prevents his use case from working.

Correct - the firmware I was provided was mis-configured.

Tim

>
> The existing code isn't great as-is, since all the user sees is that we
> e.g. negotiated for 1G, but the link never came up.
>
> --Sean
