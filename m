Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC1E29FB88
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 03:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725909AbgJ3CoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 22:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgJ3CoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 22:44:03 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A42C0C0613CF
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 19:44:03 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id k21so6011034ioa.9
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 19:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FL/Cy8ut4OmkPPb5f8+ZgGjMSZ1pKrG6xY+Ok4+PFPo=;
        b=d3g3u5smUiy7WXP7RRcYhNon4D08AxxROQFfOv6fo0obC6XFr+v00SZVVAP/lEOMU/
         AXPSlufn+CdL6wdwuVeLu3uwAQsQKLqBR+f+peXlA1Lhjvs04Rh84tFany/y7ERNxR53
         uGS0SaCylf/snjj6N+ci0J9sHWvfErWGCXSAwnlk2tCnIp93Fm9+UOjOtJ5zFd3mcB69
         1xmBPBHIH8xs9j+D8bRoMNJ9SOImuRW+pom2pfV4PkxAIU55uP6oJQIkuGnhffgEXz3p
         9jWKz+dbxvF2BvOffjxWMKI7tzAMt0ZoNVOfYnBRB8yP/qlV9+btPRP+xy0EUsNJ2i1D
         /11w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FL/Cy8ut4OmkPPb5f8+ZgGjMSZ1pKrG6xY+Ok4+PFPo=;
        b=GQwuLoI7/1cO0X2JU+u/87/iZGQEBT1HWBmtprlYRaSkuEjdxlhPOdFLKxUa949UQG
         ocy5qnb4iuxvx6Wt8nDHdAiH8vy7vsZKpvEgDBvwtL6badDCHQEQRYTJktMK7ywWnKMA
         BkM3MiY9ObcO4Q70/9Wp78v3l3uD7IlhkgikNmhLNwyeA8TInl/hT1XOJW1UlOI0qzpg
         MQC4PdFCnp8SBKvIohhcGJh4fwvGCIyWlJ8qGcbKbfVbPXYT3rOwuIBiPnGrdb6kMUYp
         XPyKRiu69ESqEhKI+UqmGY4g7v8QNV3BKMJiVVcbDNty+64+NG/mDQ+NBKfODtSNG7ok
         t5bw==
X-Gm-Message-State: AOAM533bKafGlvMBcqpUiVT05FkVhxI7szX8ofjVVD6Jp5ohWI4iBJIr
        hN8kraI44ZHRWiEgnNX2ktpWYdC1wJr264JhTDg=
X-Google-Smtp-Source: ABdhPJxKAl9ZW4kiCHP2RRyBtjJEm8e0+BNopyOxk5QLCQ+Dk0ei5MgcasRjeHvQhrW6LxM12SK7l9Rtl+3xGBmaA5s=
X-Received: by 2002:a05:6638:97:: with SMTP id v23mr315405jao.7.1604025842967;
 Thu, 29 Oct 2020 19:44:02 -0700 (PDT)
MIME-Version: 1.0
References: <20201029063915.4287-1-dqfext@gmail.com> <20201029130147.GL933237@lunn.ch>
In-Reply-To: <20201029130147.GL933237@lunn.ch>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Fri, 30 Oct 2020 10:43:51 +0800
Message-ID: <CALW65jaPV7sH8v3-K4X8gnzKTymxF=5dnatuKEuesDf64YKa=A@mail.gmail.com>
Subject: Re: [RFC PATCH net-next] net: ethernet: mediatek: support setting MTU
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Landen Chao <landen.chao@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Frank Wunderlich <frank-w@public-files.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 9:02 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Thu, Oct 29, 2020 at 02:39:15PM +0800, DENG Qingfang wrote:
> > MT762x HW supports frame length up to 2048 (maximum length on GDM),
> > so allow setting MTU up to 2030.
> >
> > Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> > ---
> >
> > I only tested this on MT7621, no sure if it is applicable for other SoCs
> > especially MT7628, which has an old IP.
> >
> > ---
> >  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 31 ++++++++++++++++++++-
> >  drivers/net/ethernet/mediatek/mtk_eth_soc.h | 11 ++++++--
> >  2 files changed, 38 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > index 6d2d60675ffd..a0c56d9be1d5 100644
> > --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > @@ -353,7 +353,7 @@ static void mtk_mac_config(struct phylink_config *config, unsigned int mode,
> >       /* Setup gmac */
> >       mcr_cur = mtk_r32(mac->hw, MTK_MAC_MCR(mac->id));
> >       mcr_new = mcr_cur;
> > -     mcr_new |= MAC_MCR_MAX_RX_1536 | MAC_MCR_IPG_CFG | MAC_MCR_FORCE_MODE |
> > +     mcr_new |= MAC_MCR_IPG_CFG | MAC_MCR_FORCE_MODE |
> >                  MAC_MCR_BACKOFF_EN | MAC_MCR_BACKPR_EN | MAC_MCR_FORCE_LINK;
>
> Since you no longer set MAC_MCR_MAX_RX_1536, what does the hardware
> default to?

2'b00, i.e. 1518 bytes.

>
> >       /* Only update control register when needed! */
> > @@ -2499,6 +2499,34 @@ static void mtk_uninit(struct net_device *dev)
> >       mtk_rx_irq_disable(eth, ~0);
> >  }
> >
> > +static int mtk_change_mtu(struct net_device *dev, int new_mtu)
> > +{
> > +     struct mtk_mac *mac = netdev_priv(dev);
> > +     u32 mcr_cur, mcr_new;
> > +     int length;
> > +
> > +     mcr_cur = mtk_r32(mac->hw, MTK_MAC_MCR(mac->id));
> > +     mcr_new = mcr_cur & ~MAC_MCR_MAX_RX_LEN_MASK;
> > +     length = new_mtu + MTK_RX_ETH_HLEN;
> > +
> > +     if (length <= 1518)
> > +             mcr_new |= MAC_MCR_MAX_RX_LEN(MAC_MCR_MAX_RX_LEN_1518);
> > +     else if (length <= 1536)
> > +             mcr_new |= MAC_MCR_MAX_RX_LEN(MAC_MCR_MAX_RX_LEN_1536);
> > +     else if (length <= 1552)
> > +             mcr_new |= MAC_MCR_MAX_RX_LEN(MAC_MCR_MAX_RX_LEN_1552);
> > +     else
> > +             mcr_new |= MAC_MCR_MAX_RX_LEN(MAC_MCR_MAX_RX_LEN_2048);
>
> You should have another if here, and return -EIVAL is the user asked
> for an MTU of 2049 of greater.

It is handled in net_device->max_mtu:
> eth->netdev[id]->max_mtu = MTK_MAX_RX_LENGTH - MTK_RX_ETH_HLEN;

As I tested:

> # ip link set eth0 mtu 2031
> RTNETLINK answers: Invalid argument

>
>     Andrew
