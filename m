Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDA1F2E2130
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 21:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728732AbgLWUPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 15:15:04 -0500
Received: from smtprelay0221.hostedemail.com ([216.40.44.221]:48888 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727671AbgLWUPD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 15:15:03 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id B0E7F180A7FF4;
        Wed, 23 Dec 2020 20:14:22 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1434:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:1801:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:4250:4321:4605:5007:6119:6235:6609:7557:7576:7902:7903:10004:10400:10848:11026:11232:11657:11658:11914:12043:12048:12294:12296:12297:12438:12555:12740:12895:13439:13894:14181:14659:14721:21080:21433:21451:21627:21990:30003:30054:30070:30080:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: table59_3c14bbe2746b
X-Filterd-Recvd-Size: 3703
Received: from XPS-9350.home (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf01.hostedemail.com (Postfix) with ESMTPA;
        Wed, 23 Dec 2020 20:14:21 +0000 (UTC)
Message-ID: <46b3bba25d09e89471048ae119a2c3b460b6b7be.camel@perches.com>
Subject: Re: [PATCH] amd-xgbe: remove h from printk format specifier
From:   Joe Perches <joe@perches.com>
To:     trix@redhat.com, thomas.lendacky@amd.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 23 Dec 2020 12:14:20 -0800
In-Reply-To: <20201223194345.125205-1-trix@redhat.com>
References: <20201223194345.125205-1-trix@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-12-23 at 11:43 -0800, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> This change fixes the checkpatch warning described in this commit
> commit cbacb5ab0aa0 ("docs: printk-formats: Stop encouraging use of unnecessary %h[xudi] and %hh[xudi]")
> 
> Standard integer promotion is already done and %hx and %hhx is useless
> so do not encourage the use of %hh[xudi] or %h[xudi].

Why only xgbe-ethtool?

Perhaps your script only converts direct uses of functions
marked with __printf and not any uses of the same functions
via macros.

$ git grep -P '%[\w\d\.]*h\w' drivers/net/ethernet/amd/xgbe/
drivers/net/ethernet/amd/xgbe/xgbe-dcb.c:                         "TC%u: tx_bw=%hhu, rx_bw=%hhu, tsa=%hhu\n", i,
drivers/net/ethernet/amd/xgbe/xgbe-dcb.c:               netif_dbg(pdata, drv, netdev, "PRIO%u: TC=%hhu\n", i,
drivers/net/ethernet/amd/xgbe/xgbe-dcb.c:                                 "unsupported TSA algorithm (%hhu)\n",
drivers/net/ethernet/amd/xgbe/xgbe-dcb.c:                 "cap=%hhu, en=%#hhx, mbc=%hhu, delay=%hhu\n",
drivers/net/ethernet/amd/xgbe/xgbe-dev.c:       netif_dbg(pdata, drv, pdata->netdev, "VXLAN tunnel id set to %hx\n",
drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c:           netdev_err(netdev, "invalid phy address %hhu\n",
drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c:           netdev_err(netdev, "unsupported autoneg %hhu\n",
drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c:                   netdev_err(netdev, "unsupported duplex %hhu\n",

> 
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
>  drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c b/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
> index 61f39a0e04f9..3c18f26bf2a5 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
> @@ -339,14 +339,14 @@ static int xgbe_set_link_ksettings(struct net_device *netdev,
>  	speed = cmd->base.speed;
>  
> 
>  	if (cmd->base.phy_address != pdata->phy.address) {
> -		netdev_err(netdev, "invalid phy address %hhu\n",
> +		netdev_err(netdev, "invalid phy address %u\n",
>  			   cmd->base.phy_address);
>  		return -EINVAL;
>  	}
>  
> 
>  	if ((cmd->base.autoneg != AUTONEG_ENABLE) &&
>  	    (cmd->base.autoneg != AUTONEG_DISABLE)) {
> -		netdev_err(netdev, "unsupported autoneg %hhu\n",
> +		netdev_err(netdev, "unsupported autoneg %u\n",
>  			   cmd->base.autoneg);
>  		return -EINVAL;
>  	}
> @@ -358,7 +358,7 @@ static int xgbe_set_link_ksettings(struct net_device *netdev,
>  		}
>  
> 
>  		if (cmd->base.duplex != DUPLEX_FULL) {
> -			netdev_err(netdev, "unsupported duplex %hhu\n",
> +			netdev_err(netdev, "unsupported duplex %u\n",
>  				   cmd->base.duplex);
>  			return -EINVAL;
>  		}


