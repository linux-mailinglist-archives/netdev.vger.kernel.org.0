Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6C61D655A
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 04:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbgEQCh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 22:37:59 -0400
Received: from smtprelay0026.hostedemail.com ([216.40.44.26]:52030 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726919AbgEQCh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 22:37:59 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 9CB0B100E7B40;
        Sun, 17 May 2020 02:37:57 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 90,9,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:966:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1543:1593:1594:1711:1730:1747:1777:1792:1801:2194:2196:2198:2199:2200:2201:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3354:3622:3653:3865:3867:3868:3870:3871:3873:3874:4225:4250:4321:4385:4605:5007:6119:7875:7903:10004:10400:10450:10455:10848:11232:11233:11657:11658:11914:12043:12296:12297:12740:12760:12895:13095:13161:13229:13439:14659:14721:19904:19999:21080:21433:21451:21611:21627:21740:21741:30045:30046:30054:30070:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: lip88_b22d3cfaaa49
X-Filterd-Recvd-Size: 4718
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf01.hostedemail.com (Postfix) with ESMTPA;
        Sun, 17 May 2020 02:37:56 +0000 (UTC)
Message-ID: <a27c9079fb257b90382f3af7e071078ab5948eb2.camel@perches.com>
Subject: Re: [PATCH V6 20/20] net: ks8851: Drop define debug and pr_fmt()
From:   Joe Perches <joe@perches.com>
To:     Marek Vasut <marex@denx.de>, netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Date:   Sat, 16 May 2020 19:37:55 -0700
In-Reply-To: <7447d18e-cd81-b98e-a0d9-1059b60a3cf0@denx.de>
References: <20200517003354.233373-1-marex@denx.de>
         <20200517003354.233373-21-marex@denx.de>
         <bd3a3e31d17146965c5a0ff7228cb00ec46f4edb.camel@perches.com>
         <7447d18e-cd81-b98e-a0d9-1059b60a3cf0@denx.de>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2020-05-17 at 04:28 +0200, Marek Vasut wrote:
> On 5/17/20 4:01 AM, Joe Perches wrote:
> > On Sun, 2020-05-17 at 02:33 +0200, Marek Vasut wrote:
> > > Drop those debug statements from both drivers. They were there since
> > > at least 2011 and enabled by default, but that's likely wrong.
> > []
> > > diff --git a/drivers/net/ethernet/micrel/ks8851_par.c b/drivers/net/ethernet/micrel/ks8851_par.c
> > []
> > > -#define DEBUG
> > 
> > Dropping the #define DEBUG lines will cause a behavior
> > change for the netdev/netif_dbg uses as these messages
> > will no longer be output by default.
> 
> Is that a problem ?

Dunno.  I don't use nor debug these drivers.

You just say that's likely wrong, but I wonder if
that's really true.

You also don't mention in your patch commit message
that the output logging actually does change as if
the DEBUG define has no effect.

Prior to this change these were output at KERN_DEBUG

$ git grep -A1 _dbg drivers/net/ethernet/micrel/ks8851.c
drivers/net/ethernet/micrel/ks8851.c:   netif_dbg(ks, hw, ks->netdev, "setting power mode %d\n", pwrmode);
drivers/net/ethernet/micrel/ks8851.c-
--
drivers/net/ethernet/micrel/ks8851.c:   netif_dbg(ks, rx_status, ks->netdev,
drivers/net/ethernet/micrel/ks8851.c-             "%s: %d@%p\n", __func__, len, buff);
--
drivers/net/ethernet/micrel/ks8851.c: * ks8851_dbg_dumpkkt - dump initial packet contents to debug
drivers/net/ethernet/micrel/ks8851.c- * @ks: The device state
--
drivers/net/ethernet/micrel/ks8851.c: * Dump the initial data from the packet to dev_dbg().
drivers/net/ethernet/micrel/ks8851.c-*/
drivers/net/ethernet/micrel/ks8851.c:static void ks8851_dbg_dumpkkt(struct ks8851_net *ks, u8 *rxpkt)
drivers/net/ethernet/micrel/ks8851.c-{
drivers/net/ethernet/micrel/ks8851.c:   netdev_dbg(ks->netdev,
drivers/net/ethernet/micrel/ks8851.c-              "pkt %02x%02x%02x%02x %02x%02x%02x%02x %02x%02x%02x%02x\n",
--
drivers/net/ethernet/micrel/ks8851.c:   netif_dbg(ks, rx_status, ks->netdev,
drivers/net/ethernet/micrel/ks8851.c-             "%s: %d packets\n", __func__, rxfc);
--
drivers/net/ethernet/micrel/ks8851.c:           netif_dbg(ks, rx_status, ks->netdev,
drivers/net/ethernet/micrel/ks8851.c-                     "rx: stat 0x%04x, len 0x%04x\n", rxstat, rxlen);
--
drivers/net/ethernet/micrel/ks8851.c:                                   ks8851_dbg_dumpkkt(ks, rxpkt);
drivers/net/ethernet/micrel/ks8851.c-
--
drivers/net/ethernet/micrel/ks8851.c:   netif_dbg(ks, intr, ks->netdev,
drivers/net/ethernet/micrel/ks8851.c-             "%s: status 0x%04x\n", __func__, status);
--
drivers/net/ethernet/micrel/ks8851.c:           netif_dbg(ks, intr, ks->netdev,
drivers/net/ethernet/micrel/ks8851.c-                     "%s: txspace %d\n", __func__, ks->tx_space);
--
drivers/net/ethernet/micrel/ks8851.c:   netif_dbg(ks, tx_queued, ks->netdev, "%s: skb %p, %d@%p, irq %d\n",
drivers/net/ethernet/micrel/ks8851.c-             __func__, txp, txp->len, txp->data, irq);
--
drivers/net/ethernet/micrel/ks8851.c:   netif_dbg(ks, ifup, ks->netdev, "opening\n");
drivers/net/ethernet/micrel/ks8851.c-
--
drivers/net/ethernet/micrel/ks8851.c:   netif_dbg(ks, ifup, ks->netdev, "network device up\n");
drivers/net/ethernet/micrel/ks8851.c-
--
drivers/net/ethernet/micrel/ks8851.c:           netif_dbg(ks, ifdown, ks->netdev,
drivers/net/ethernet/micrel/ks8851.c-                     "%s: freeing txb %p\n", __func__, txb);
--
drivers/net/ethernet/micrel/ks8851.c:   netif_dbg(ks, tx_queued, ks->netdev,
drivers/net/ethernet/micrel/ks8851.c-             "%s: skb %p, %d@%p\n", __func__, skb, skb->len, skb->data);


