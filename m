Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B57963883B2
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 02:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352854AbhESAVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 20:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234706AbhESAVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 20:21:35 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 512B3C06175F;
        Tue, 18 May 2021 17:20:16 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id f9so15717262ybo.6;
        Tue, 18 May 2021 17:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kxPHY1jKkNoFSE2/0Ap7oT96GoALXMLtmUjeD9d402Y=;
        b=pcujdQn0GkUvHU3HRvBUcPknxMr6Waw8TGBbT4w0CfAdY3QX8u9AwnasK31Kz10Pjh
         muM/wnK4ZLv93pcf/zfmpB8fKD0J7LoaLHu18mVfzJ8a5jcEW+lF8EqEH1vCOULLON8B
         w9Y2d2hAEqBdiuglcRNAYhK9nJ3fXHe8fNABx3iuD19HAN4vUDjL44nzX1F4Tc0mg6Dl
         7azsVzLN63Z0fkOvm2XAKduq5YR5ye8Au098+SjwBjNGyDI+G6ABO+uNX7ohSKtm1mIg
         XZ7XHyiYDNRaBvWSPSsx1op2cBdnB6dg4RMplhHD2F7lO64zLUpyeslssCmpa8a2KyiT
         QXng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kxPHY1jKkNoFSE2/0Ap7oT96GoALXMLtmUjeD9d402Y=;
        b=Itt3AzUJpdvJw7ESXE/hnUTdZSmv4sid566YtT578rnEJBEZVtJOx5B1fpd4Uf1gP7
         cn8rCxEr+C0FfK9lhpsHNN4jxQvj0n6w5kSGU7XsLQFQkJV0PAwlNkSQFCD7KVK5Ded0
         vobdqae6rd4UYpJCLebKuc8z2lT1iRKvbC443BFxIC38SWoVPFFAWtWz5BDe5NpD0dDq
         USy+3mwe9hq7UtajkJ0lTQNNMuAVLhECr6PMYzrMT9JxGQF4DNQVVxjG1NVhhHH6rnWJ
         85DmEk5S0SLgatzGS9mYLIfMHc4B2jTVp7My39i5e40syyzLYmfzcQ464aGXeSpXoKRj
         Qswg==
X-Gm-Message-State: AOAM532bsD55qX7FkH+kw97pNJqpFzi6mQIdCyoG8a5syMT1Cf9vm1yl
        UP6DmvMWpwEjlLyz4JJKnKS5nnKe9vMkrAsoWqw=
X-Google-Smtp-Source: ABdhPJy7qDS9Phf5sCsWbwzXWHVEZgp9RY7GKxW3h6Xj8Lx1i3KOzjRPqY8QyuWuweU5snOP5Gj/c25OKITphKXsc/0=
X-Received: by 2002:a25:4d56:: with SMTP id a83mr10341612ybb.437.1621383615506;
 Tue, 18 May 2021 17:20:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210511214605.2937099-1-pgwipeout@gmail.com> <YKOB7y/9IptUvo4k@unreal>
In-Reply-To: <YKOB7y/9IptUvo4k@unreal>
From:   Peter Geis <pgwipeout@gmail.com>
Date:   Tue, 18 May 2021 20:20:03 -0400
Message-ID: <CAMdYzYrV0T9H1soxSVpQv=jLCR9k9tuJddo1Kw-c3O5GJvg92A@mail.gmail.com>
Subject: Re: [PATCH] net: phy: add driver for Motorcomm yt8511 phy
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 18, 2021 at 4:59 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Tue, May 11, 2021 at 05:46:06PM -0400, Peter Geis wrote:
> > Add a driver for the Motorcomm yt8511 phy that will be used in the
> > production Pine64 rk3566-quartz64 development board.
> > It supports gigabit transfer speeds, rgmii, and 125mhz clk output.
> >
> > Signed-off-by: Peter Geis <pgwipeout@gmail.com>
> > ---
> >  MAINTAINERS                 |  6 +++
> >  drivers/net/phy/Kconfig     |  6 +++
> >  drivers/net/phy/Makefile    |  1 +
> >  drivers/net/phy/motorcomm.c | 85 +++++++++++++++++++++++++++++++++++++
> >  4 files changed, 98 insertions(+)
> >  create mode 100644 drivers/net/phy/motorcomm.c
>
> <...>
>
> > +static const struct mdio_device_id __maybe_unused motorcomm_tbl[] = {
> > +     { PHY_ID_MATCH_EXACT(PHY_ID_YT8511) },
> > +     { /* sentinal */ }
> > +}
>
> Why is this "__maybe_unused"? This *.c file doesn't have any compilation option
> to compile part of it.
>
> The "__maybe_unused" is not needed in this case.

I was simply following convention, for example the realtek.c,
micrel.c, and smsc.c drivers all have this as well.

>
> Thanks
