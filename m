Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A13511982CC
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 19:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730348AbgC3RyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 13:54:08 -0400
Received: from smtprelay0250.hostedemail.com ([216.40.44.250]:47660 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726403AbgC3RyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 13:54:07 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id A38C018034F5F;
        Mon, 30 Mar 2020 17:54:05 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1540:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3867:3868:3870:3871:3872:4250:4321:5007:7576:10004:10400:10848:11026:11232:11657:11658:11914:12043:12048:12296:12297:12438:12740:12760:12895:13069:13095:13311:13357:13439:14181:14659:14721:21080:21433:21627:21990:30003:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:3,LUA_SUMMARY:none
X-HE-Tag: snail18_7ae2b0153554f
X-Filterd-Recvd-Size: 1863
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf15.hostedemail.com (Postfix) with ESMTPA;
        Mon, 30 Mar 2020 17:54:04 +0000 (UTC)
Message-ID: <bfc2cff78325ad2845ef0c7ec2d7ba719fd4f1a1.camel@perches.com>
Subject: Re: [PATCH][next] net: ethernet: ti: fix spelling mistake "rundom"
 -> "random"
From:   Joe Perches <joe@perches.com>
To:     Colin King <colin.king@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 30 Mar 2020 10:52:09 -0700
In-Reply-To: <20200330101639.161268-1-colin.king@canonical.com>
References: <20200330101639.161268-1-colin.king@canonical.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-03-30 at 11:16 +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a spelling mistake in a dev_err error message. Fix it.
[]
> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
[]
> @@ -1627,7 +1627,7 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
>  							   port->slave.mac_addr) ||
>  			   !is_valid_ether_addr(port->slave.mac_addr)) {
>  			random_ether_addr(port->slave.mac_addr);
> -			dev_err(dev, "Use rundom MAC address\n");
> +			dev_err(dev, "Use random MAC address\n");

This continues without returning an error value.
Is this actually an error?

It might be useful to describe the slave and
random ethernet address too.

Perhaps:

			dev_notice(dev, "%pOF slave[%d] using random MAC address %pM\n",
				   port_np, port_id, port->slave.mac_addr);

or maybe dev_info


