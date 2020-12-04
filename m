Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6A242CF264
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 17:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388228AbgLDQwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 11:52:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:58330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729906AbgLDQwc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 11:52:32 -0500
Date:   Fri, 4 Dec 2020 08:51:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607100712;
        bh=KJqNaqHbmtc9D1ZmzcLY1TWjh+0ckI5vvJziXj0vsOQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=r5AaJiRvo6hKeFR0RTaceQ9a5ah8jt/TGmIYbY2rD+g8lvownJ9Vaf5oCI5HmptVD
         OSE2yd7YQq3mQ8gVf8UxFCK3F1QdTrxf5dRNnJDadEaUK+NPimXyl3OsygXoXDiQjz
         GCNSPZYv/WtS8qOWpV52VXoS1yqbTLE5DJ9i+XuRDcqhivSc1sodQJZCqtEAroIlxy
         GAZB5ikGk9aRxBD9oD36lTs1vlliE2L8lgwOIiZc+XXEzx8bzGJTJ9Ldnhw2bJdV94
         Jl+IuQtIeBgmP/OunulvlaJmj2PrThcJB7qOpjCn5p9becxVoZKVKKx6wi/vpFPkOX
         q0L8xhAJGpOqA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.cionei@nxp.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Michael Walle <michael@walle.cc>, Po Liu <po.liu@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] enetc: fix build warning
Message-ID: <20201204085150.42f6409b@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <DB8PR04MB67644946C4F1DAF8F8F38A4196F10@DB8PR04MB6764.eurprd04.prod.outlook.com>
References: <20201203223747.1337389-1-arnd@kernel.org>
        <DB8PR04MB67644946C4F1DAF8F8F38A4196F10@DB8PR04MB6764.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Dec 2020 12:18:16 +0000 Claudiu Manoil wrote:
> >-----Original Message-----
> >From: Arnd Bergmann <arnd@kernel.org>
> >Sent: Friday, December 4, 2020 12:37 AM  
> [...]
> >Subject: [PATCH] enetc: fix build warning
> >
> >From: Arnd Bergmann <arnd@arndb.de>
> >
> >When CONFIG_OF is disabled, there is a harmless warning about
> >an unused variable:
> >
> >enetc_pf.c: In function 'enetc_phylink_create':
> >enetc_pf.c:981:17: error: unused variable 'dev' [-Werror=unused-variable]
> >
> >Slightly rearrange the code to pass around the of_node as a
> >function argument, which avoids the problem without hurting
> >readability.
> >
> >Fixes: 71b77a7a27a3 ("enetc: Migrate to PHYLINK and PCS_LYNX")
> >Signed-off-by: Arnd Bergmann <arnd@arndb.de>  
> 
> Very nice cleanup, the code looks much better like this.
> For some reason this patch is marked as "Not applicable" in patchwork.
> So I took the patch, made a small cosmetic change (see nit below), added a more
> verbose subject line, tested and resent it, patchwork link here:
> https://patchwork.ozlabs.org/project/netdev/patch/20201204120800.17193-1-claudiu.manoil@nxp.com/

We switched to a different PW instance:

https://patchwork.kernel.org/project/netdevbpf/patch/20201203223747.1337389-1-arnd@kernel.org/

> >---
> > .../net/ethernet/freescale/enetc/enetc_pf.c   | 21 +++++++++----------
> >@@ -1005,9 +1003,10 @@ static int enetc_pf_probe(struct pci_dev *pdev,
> > 	struct net_device *ndev;
> > 	struct enetc_si *si;
> > 	struct enetc_pf *pf;
> >+	struct device_node *node = pdev->dev.of_node;  
> 
> Nit: move this long line to the top (reverse tree)

Now it's gonna get marked as changes requested ;)
