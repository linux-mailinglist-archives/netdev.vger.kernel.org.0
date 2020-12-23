Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D42972E21BF
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 21:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728727AbgLWUyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 15:54:32 -0500
Received: from smtprelay0229.hostedemail.com ([216.40.44.229]:47208 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726650AbgLWUyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 15:54:32 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id EC02F18015400;
        Wed, 23 Dec 2020 20:53:50 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1434:1437:1515:1516:1518:1534:1544:1593:1594:1711:1730:1747:1777:1792:1801:2194:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3354:3622:3653:3865:3866:3867:3868:3870:3871:3872:4321:4605:5007:6119:6235:7557:7576:7902:7903:10004:10848:11026:11232:11657:11658:11914:12043:12048:12294:12296:12297:12438:12555:12740:12760:12895:12986:13439:14181:14659:14721:21080:21433:21451:21627:30003:30054:30070:30080:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: toys42_2915b912746b
X-Filterd-Recvd-Size: 4983
Received: from XPS-9350.home (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf03.hostedemail.com (Postfix) with ESMTPA;
        Wed, 23 Dec 2020 20:53:49 +0000 (UTC)
Message-ID: <46c0d5336f079e9f889af711a478d189313d278d.camel@perches.com>
Subject: Re: [PATCH] amd-xgbe: remove h from printk format specifier
From:   Joe Perches <joe@perches.com>
To:     Tom Rix <trix@redhat.com>, thomas.lendacky@amd.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 23 Dec 2020 12:53:48 -0800
In-Reply-To: <d1257604-c462-8fbc-612e-41ec2f552ff8@redhat.com>
References: <20201223194345.125205-1-trix@redhat.com>
         <46b3bba25d09e89471048ae119a2c3b460b6b7be.camel@perches.com>
         <d1257604-c462-8fbc-612e-41ec2f552ff8@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-12-23 at 12:33 -0800, Tom Rix wrote:
> On 12/23/20 12:14 PM, Joe Perches wrote:
> > On Wed, 2020-12-23 at 11:43 -0800, trix@redhat.com wrote:
> > > From: Tom Rix <trix@redhat.com>
> > > 
> > > This change fixes the checkpatch warning described in this commit
> > > commit cbacb5ab0aa0 ("docs: printk-formats: Stop encouraging use of unnecessary %h[xudi] and %hh[xudi]")
> > > 
> > > Standard integer promotion is already done and %hx and %hhx is useless
> > > so do not encourage the use of %hh[xudi] or %h[xudi].
> > Why only xgbe-ethtool?
> > 
> > Perhaps your script only converts direct uses of functions
> > marked with __printf and not any uses of the same functions
> > via macros.
> 
> The fixer may have issues.

Perhaps until the fixer is fixed, it'd be more
complete coverage to use checkpatch like:

$ git ls-files <path> | \
  xargs ./scripts/checkpatch.pl -f --fix-inplace --types=unnecessary_modifier

e.g.:

$ git ls-files drivers/net/ethernet/amd/xgbe | \
  xargs ./scripts/checkpatch.pl -f --fix-inplace --types=unnecessary_modifier

$ git diff -U0 drivers/net/ethernet/amd/xgbe/
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-dcb.c b/drivers/net/ethernet/amd/xgbe/xgbe-dcb.c
index 895d35639129..dcd2a181d43a 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-dcb.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-dcb.c
@@ -155 +155 @@ static int xgbe_dcb_ieee_setets(struct net_device *netdev,
-                         "TC%u: tx_bw=%hhu, rx_bw=%hhu, tsa=%hhu\n", i,
+                         "TC%u: tx_bw=%u, rx_bw=%u, tsa=%u\n", i,
@@ -158 +158 @@ static int xgbe_dcb_ieee_setets(struct net_device *netdev,
-               netif_dbg(pdata, drv, netdev, "PRIO%u: TC=%hhu\n", i,
+               netif_dbg(pdata, drv, netdev, "PRIO%u: TC=%u\n", i,
@@ -233 +233 @@ static int xgbe_dcb_ieee_setpfc(struct net_device *netdev,
-                 "cap=%hhu, en=%#hhx, mbc=%hhu, delay=%hhu\n",
+                 "cap=%u, en=%#x, mbc=%u, delay=%u\n",
@@ -267 +267 @@ static u8 xgbe_dcb_setdcbx(struct net_device *netdev, u8 dcbx)
-       netif_dbg(pdata, drv, netdev, "DCBX=%#hhx\n", dcbx);
+       netif_dbg(pdata, drv, netdev, "DCBX=%#x\n", dcbx);
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-dev.c b/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
index d5fd49dd25f3..ff0cd94bb91a 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
@@ -488 +488 @@ static void xgbe_set_vxlan_id(struct xgbe_prv_data *pdata)
-       netif_dbg(pdata, drv, pdata->netdev, "VXLAN tunnel id set to %hx\n",
+       netif_dbg(pdata, drv, pdata->netdev, "VXLAN tunnel id set to %x\n",
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index 2709a2db5657..0ae16bc87833 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -2781 +2781 @@ void xgbe_print_pkt(struct net_device *netdev, struct sk_buff *skb, bool tx_rx)
-       netdev_dbg(netdev, "Protocol: %#06hx\n", ntohs(eth->h_proto));
+       netdev_dbg(netdev, "Protocol: %#06x\n", ntohs(eth->h_proto));
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c b/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
index 61f39a0e04f9..3c18f26bf2a5 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
@@ -342 +342 @@ static int xgbe_set_link_ksettings(struct net_device *netdev,
-               netdev_err(netdev, "invalid phy address %hhu\n",
+               netdev_err(netdev, "invalid phy address %u\n",
@@ -349 +349 @@ static int xgbe_set_link_ksettings(struct net_device *netdev,
-               netdev_err(netdev, "unsupported autoneg %hhu\n",
+               netdev_err(netdev, "unsupported autoneg %u\n",
@@ -361 +361 @@ static int xgbe_set_link_ksettings(struct net_device *netdev,
-                       netdev_err(netdev, "unsupported duplex %hhu\n",
+                       netdev_err(netdev, "unsupported duplex %u\n",


