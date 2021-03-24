Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27DBC346EE7
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 02:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234690AbhCXBdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 21:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231634AbhCXBdU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 21:33:20 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DDD6C061763;
        Tue, 23 Mar 2021 18:33:20 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id x17so8549027iog.2;
        Tue, 23 Mar 2021 18:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gCd/lcF9fZe1u74op7ACEyE0msKcZYPEEA0XtYL+crQ=;
        b=W7EsSvfrCp9parhWmvlf44nTmJGzGuFl95x81clgZsZR8GIox8cX/pzNBjSzwXO1Gh
         uYt42RXXLlTtzVhSFJWMiVRgzjlChnWbuxvsKsuF9GH4YS+fUl2xTZUbCr8L/puH+EDO
         OfPpcdq02HNeroKt6vZwws/EpGoaGSQnKczrqE0tWsH7Fk6KMryq2IvFvu1PhACXUXaJ
         CmHycGgJjR/bBSUfm84pPKjW+rFYLBE57a5qi5+vJkbMUi9AywOvIqg7GW2N0Zt4nJqR
         7vHFPr/AefCHLu/o4RLzep1ahwaX6augClvkO0rxQWRAVeJ3241nry4Xk1FBZh7Qga3s
         BRhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gCd/lcF9fZe1u74op7ACEyE0msKcZYPEEA0XtYL+crQ=;
        b=pE2c+HCSuCVS2Q50N9ACFPQO7wbHvdk5fIrkiDavA6PDuy2ux4fv/5gKNQwnJEe6tM
         4zvrXsYHwD+uOQ+rNataCJR+V+HDa9V9WKF47VIJFbnQnKXO39El2VnsQeuB8RLCcAC2
         KvH1gEdlHYtl/KZPIk8s8RamO797D7cOcZpOY5rRTGGOE55hIaSfcOmPyi5Nb5TZE2rw
         VP8Lj1tHVpW4aocAaamZF4bilLljkSlMlBBtXDiwRW4s54am/0zhfM2oA+K+F/ShWAb8
         dJgeBRrNvzlMTvW+OzGktzwbVlXJXP2tyXXhOvBORM0mVcLOoO9KgdUFfg58X1UMX8yC
         ITrQ==
X-Gm-Message-State: AOAM530Nxz1GEZc7eoTPLjwkthaxw9WuleHtroF8kang9ufMU6M749Sv
        cS+S7Fd5avuO/V3uj6B1mMoFBcvnEuam3WYej/s=
X-Google-Smtp-Source: ABdhPJyrV/FaA9Vw9cRKxPcdE0YDPrCXuKhGjPjEQBHOt+PjJQND2ibEPWI1v2BtGHoPOvTMLg22btNz1rwQelOXLL0=
X-Received: by 2002:a02:9645:: with SMTP id c63mr735828jai.84.1616549599613;
 Tue, 23 Mar 2021 18:33:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210311020954.842341-1-ilya.lipnitskiy@gmail.com> <YEpWVAnYLkytpIWB@lunn.ch>
In-Reply-To: <YEpWVAnYLkytpIWB@lunn.ch>
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Date:   Tue, 23 Mar 2021 18:33:08 -0700
Message-ID: <CALCv0x02RQ=TQDjRNwAN1FJVFEwAbFYiif6JGtV=V4b2u0beKw@mail.gmail.com>
Subject: Re: [PATCH net-next,v2 1/3] net: dsa: mt7530: setup core clock even
 in TRGMII mode
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 9:41 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Wed, Mar 10, 2021 at 06:09:52PM -0800, Ilya Lipnitskiy wrote:
> > A recent change to MIPS ralink reset logic made it so mt7530 actually
> > resets the switch on platforms such as mt7621 (where bit 2 is the reset
> > line for the switch). That exposed an issue where the switch would not
> > function properly in TRGMII mode after a reset.
> >
> > Reconfigure core clock in TRGMII mode to fix the issue.
> >
> > Tested on Ubiquiti ER-X (MT7621) with TRGMII mode enabled.
>
> Please don't submit the same patch to net and net-next.  Anything
> which is accepted into net, will get merged into net-next about a week
> later. If your other two patches depend on this patch, you need to
> wait for the merge to happen, then submit them.
I don't mind waiting, but it's been more than a week now. When is the
next merge of net-next into net planned to happen?

Ilya
