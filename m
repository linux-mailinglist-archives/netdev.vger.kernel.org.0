Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3058E18E3D6
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 19:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727790AbgCUS46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 14:56:58 -0400
Received: from smtprelay0239.hostedemail.com ([216.40.44.239]:36986 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727015AbgCUS46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 14:56:58 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 845AD52BB;
        Sat, 21 Mar 2020 18:56:57 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:1981:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3867:4321:5007:6117:6642:10004:10400:10848:11026:11232:11657:11658:11914:12043:12296:12297:12438:12740:12760:12895:13069:13311:13357:13439:14659:14721:21080:21627:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:3,LUA_SUMMARY:none
X-HE-Tag: smash47_26d656340c56
X-Filterd-Recvd-Size: 1657
Received: from XPS-9350.home (unknown [47.151.143.254])
        (Authenticated sender: joe@perches.com)
        by omf16.hostedemail.com (Postfix) with ESMTPA;
        Sat, 21 Mar 2020 18:56:56 +0000 (UTC)
Message-ID: <8906876a59cfd1db917953fbf49475c9efc67023.camel@perches.com>
Subject: Re: [PATCH net-next] r8169: add new helper rtl8168g_enable_gphy_10m
From:   Joe Perches <joe@perches.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date:   Sat, 21 Mar 2020 11:55:08 -0700
In-Reply-To: <743a1fd7-e1b2-d548-1c22-7c1a2e3b268e@gmail.com>
References: <743a1fd7-e1b2-d548-1c22-7c1a2e3b268e@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2020-03-21 at 19:08 +0100, Heiner Kallweit wrote:
> Factor out setting GPHY 10M to new helper rtl8168g_enable_gphy_10m.
[]
> diff --git a/drivers/net/ethernet/realtek/r8169_phy_config.c b/drivers/net/ethernet/realtek/r8169_phy_config.c
[]
> @@ -796,6 +796,11 @@ static void rtl8168g_disable_aldps(struct phy_device *phydev)
>  	phy_modify_paged(phydev, 0x0a43, 0x10, BIT(2), 0);
>  }
>  
> +static void rtl8168g_enable_gphy_10m(struct phy_device *phydev)
> +{
> +	phy_modify_paged(phydev, 0x0a44, 0x11, 0, BIT(11));
> +}

Perhaps this should be some generic to set characteristics like:

enum rtl8168g_char {
	...
}

static void rtl8168g_enable_char(struct phy_device *phydev,
				 enum rtl8168g_char type)
{
	switch (type) {
	case FOO:
		etc...
	}


