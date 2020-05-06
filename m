Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF64E1C7A37
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 21:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728953AbgEFTYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 15:24:38 -0400
Received: from smtprelay0110.hostedemail.com ([216.40.44.110]:52916 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728770AbgEFTYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 15:24:38 -0400
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave05.hostedemail.com (Postfix) with ESMTP id E692F18289F65;
        Wed,  6 May 2020 19:24:36 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id D560118221882;
        Wed,  6 May 2020 19:24:35 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2194:2199:2393:2553:2559:2562:2828:2901:2902:3138:3139:3140:3141:3142:3353:3622:3865:3870:4250:4321:4605:5007:6119:6742:7576:7875:8957:9149:10004:10400:10848:11026:11232:11233:11473:11657:11658:11914:12043:12296:12297:12740:12760:12895:13069:13311:13357:13439:14096:14097:14181:14659:14721:21080:21451:21627:21740:21939:21990:30012:30054:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:3,LUA_SUMMARY:none
X-HE-Tag: group10_aa59a2ed6d34
X-Filterd-Recvd-Size: 3211
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf18.hostedemail.com (Postfix) with ESMTPA;
        Wed,  6 May 2020 19:24:33 +0000 (UTC)
Message-ID: <fd17302d94f6e2242d041268989e94a04df159de.camel@perches.com>
Subject: Re: [PATCH 06/11] net: ethernet: mtk-eth-mac: new driver
From:   Joe Perches <joe@perches.com>
To:     Leon Romanovsky <leon@leon.nu>, Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felix Fietkau <nbd@openwrt.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-netdev <netdev@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Date:   Wed, 06 May 2020 12:24:31 -0700
In-Reply-To: <CALq1K=Lu0hv9UCgxgrwCVoOe9L7A4sgBEM=RW2d9JkizHmdBPQ@mail.gmail.com>
References: <20200505140231.16600-1-brgl@bgdev.pl>
         <20200505140231.16600-7-brgl@bgdev.pl>
         <CALq1K=Lu0hv9UCgxgrwCVoOe9L7A4sgBEM=RW2d9JkizHmdBPQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-05-06 at 22:16 +0300, Leon Romanovsky wrote:
> On Tue, May 5, 2020 at 5:03 PM Bartosz Golaszewski <brgl@bgdev.pl> wrote:
> > From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> > 
> > This adds the driver for the MediaTek Ethernet MAC used on the MT8* SoC
> > family. For now we only support full-duplex.
[]
> > diff --git a/drivers/net/ethernet/mediatek/mtk_eth_mac.c b/drivers/net/ethernet/mediatek/mtk_eth_mac.c
[]
> > +struct mtk_mac_priv {
> > +       struct regmap *regs;
> > +       struct regmap *pericfg;
> > +
> > +       struct clk_bulk_data clks[MTK_MAC_NCLKS];
> > +
> > +       void *ring_base;
> > +       struct mtk_mac_ring_desc *descs_base;
> > +       dma_addr_t dma_addr;
> > +       struct mtk_mac_ring tx_ring;
> > +       struct mtk_mac_ring rx_ring;
> > +       struct work_struct tx_work;
> > +
> > +       struct mii_bus *mii;
> > +       struct napi_struct napi;
> > +
> > +       struct device_node *phy_node;
> > +       phy_interface_t phy_intf;
> > +       struct phy_device *phydev;
> > +       unsigned int link;
> > +       int speed;
> > +       int duplex;
> > +
> > +       /* Protects against concurrent descriptor access. */
> > +       spinlock_t lock;
> > +       unsigned long lock_flags;
> > +
> > +       struct rtnl_link_stats64 stats;
> > +};
> > +
> > +static struct net_device *mtk_mac_get_netdev(struct mtk_mac_priv *priv)
> > +{
> > +       char *ptr = (char *)priv;
> > +
> > +       return (struct net_device *)(ptr - ALIGN(sizeof(struct net_device),
> > +                                                NETDEV_ALIGN));
> > +}

This code looks ugly/fragile.
Why not store the struct net_device * in struct mtk_mac_priv ?


