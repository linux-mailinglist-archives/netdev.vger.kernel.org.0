Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71E6F33CC9D
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 05:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235051AbhCPEhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 00:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235030AbhCPEgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 00:36:35 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B877C06174A;
        Mon, 15 Mar 2021 21:36:35 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id n132so35817771iod.0;
        Mon, 15 Mar 2021 21:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xVtwrcyh2/TskgfBA/1goWIwsIJj+WbEku885ymod2c=;
        b=NjldcXh9x/r3ur8iRua7R1tmsWyqI+uS9FuYw2g607IHXNNT9sZyqn0qMegXJy4mFx
         NOxHoBoQ1HvvUXjQnYLOMjGKnkogx5eFrKC0QcMJLchcM5ferDu8N+sV1y/nz7+XVzUQ
         441yCVCcoc7fkCEWi5E3Vb+BgMYplW0e2mhddWqD94Rg3fjlxVCYI7vlnr8LyYW21LK7
         ME0IrkM/BbVoIeTrDVp6U1Z6JAONSbGAGe+dw57q5yDLQs1zQjQuDfYvp4kVSuQVZVRQ
         OPVtYNa5H9PdXHQFeX5s/qZP1eE4T0LHSETm3o+t+2uuACGU73HjOooAQ7Pax1SB7Bj9
         F5Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xVtwrcyh2/TskgfBA/1goWIwsIJj+WbEku885ymod2c=;
        b=Mcy34cTImSPWy3ODS5TBUW/GHSjPDaGvwrOkfb+dcUMq9P9Le0fslG7/zXeXZRT4Lq
         YidFITyqNc0DT+Ee2W5HiiHJRBCbvMkmaxNo1VdIAAfyOAUoB4WrCJXNEOp/0AgiknVh
         sVSS5yh5jriIgifCpxii+ogtO72xUXk8vIEZDmFEVV1ulneKY6/bXNGcN0FI5JGePcNY
         Tbr31biYBl/XhYIs5CrXbCMmxTvW+WWF7d6qcdBiNGGII01h+BfppHdYW6mqCUvcD+wF
         AF90seeOKDZgYuNJQZqsIWsM/rLfm0FZaUzMlJt0/do0AOP673es2UaiUDRFQ3g0cC4V
         AqJA==
X-Gm-Message-State: AOAM530jgucjwqpZ+LzCHzNrZmH1hpmcrYCQiLt6sOM3RbXuYmuSVG32
        VCAEXSrJNN1iJ03ZlT5Xk4DSnQeamYStKXSuJ1hxwl3kHzJd3A==
X-Google-Smtp-Source: ABdhPJzpAjz7V8myg0zt/fX5zYzoWdIz1jJdEhY/c/yCUNT7F5ybwl851XDZ/omqS/1k9sLgJHJ2J13dPWmdHrqoDbo=
X-Received: by 2002:a6b:7a4d:: with SMTP id k13mr2072399iop.39.1615869394773;
 Mon, 15 Mar 2021 21:36:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210315170940.2414854-1-dqfext@gmail.com> <892918f1-bee6-7603-b8e1-3efb93104f6f@gmail.com>
 <20210315200939.irwyiru6m62g4a7f@skbuf> <84bb93da-cc3b-d2a5-dda8-a8fb973c3bae@gmail.com>
 <20210315211541.pj5mpy2foi3wlhbe@skbuf>
In-Reply-To: <20210315211541.pj5mpy2foi3wlhbe@skbuf>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Tue, 16 Mar 2021 12:36:24 +0800
Message-ID: <CALW65jbZ1_A-HwzKwKfavQQUBfNZuBSdL8xTGuRrS5qDqi6j3A@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: mt7530: support MDB and bridge flag operations
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>, linux-kernel@vger.kernel.org,
        Frank Wunderlich <frank-w@public-files.de>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 5:15 AM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> Actually this is just how Qingfang explained it:
> https://patchwork.kernel.org/project/netdevbpf/patch/20210224081018.24719-1-dqfext@gmail.com/
>
> I just assume that MT7530/7531 switches don't need to enable flooding on
> user ports when the only possible traffic source is the CPU port - the
> CPU port can inject traffic into any port regardless of egress flooding
> setting. If that's not true, I don't see how traffic in standalone ports
> mode would work after this patch.

Correct. Don't forget the earlier version of this driver (before my
attempt to fix roaming) disabled unknown unicast flooding (trapped to
CPU) in the same way.
