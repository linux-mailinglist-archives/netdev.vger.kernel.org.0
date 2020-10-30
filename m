Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE9DC2A0586
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 13:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbgJ3Mgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 08:36:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54488 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725891AbgJ3Mgy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 08:36:54 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kYTeC-004M8B-BO; Fri, 30 Oct 2020 13:36:48 +0100
Date:   Fri, 30 Oct 2020 13:36:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Landen Chao <landen.chao@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Frank Wunderlich <frank-w@public-files.de>
Subject: Re: [RFC PATCH net-next] net: ethernet: mediatek: support setting MTU
Message-ID: <20201030123648.GA1017106@lunn.ch>
References: <20201029063915.4287-1-dqfext@gmail.com>
 <20201029130147.GL933237@lunn.ch>
 <CALW65jaPV7sH8v3-K4X8gnzKTymxF=5dnatuKEuesDf64YKa=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALW65jaPV7sH8v3-K4X8gnzKTymxF=5dnatuKEuesDf64YKa=A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 10:43:51AM +0800, DENG Qingfang wrote:
> On Thu, Oct 29, 2020 at 9:02 PM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > On Thu, Oct 29, 2020 at 02:39:15PM +0800, DENG Qingfang wrote:
> > > MT762x HW supports frame length up to 2048 (maximum length on GDM),
> > > so allow setting MTU up to 2030.
> > >
> > > Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> > > ---
> > >
> > > I only tested this on MT7621, no sure if it is applicable for other SoCs
> > > especially MT7628, which has an old IP.
> > >
> > > ---
> > >  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 31 ++++++++++++++++++++-
> > >  drivers/net/ethernet/mediatek/mtk_eth_soc.h | 11 ++++++--
> > >  2 files changed, 38 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > > index 6d2d60675ffd..a0c56d9be1d5 100644
> > > --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > > +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > > @@ -353,7 +353,7 @@ static void mtk_mac_config(struct phylink_config *config, unsigned int mode,
> > >       /* Setup gmac */
> > >       mcr_cur = mtk_r32(mac->hw, MTK_MAC_MCR(mac->id));
> > >       mcr_new = mcr_cur;
> > > -     mcr_new |= MAC_MCR_MAX_RX_1536 | MAC_MCR_IPG_CFG | MAC_MCR_FORCE_MODE |
> > > +     mcr_new |= MAC_MCR_IPG_CFG | MAC_MCR_FORCE_MODE |
> > >                  MAC_MCR_BACKOFF_EN | MAC_MCR_BACKPR_EN | MAC_MCR_FORCE_LINK;
> >
> > Since you no longer set MAC_MCR_MAX_RX_1536, what does the hardware
> > default to?
> 
> 2'b00, i.e. 1518 bytes.

O.K, that fits the default for a netdev.

> It is handled in net_device->max_mtu:
> > eth->netdev[id]->max_mtu = MTK_MAX_RX_LENGTH - MTK_RX_ETH_HLEN;

Cool.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
