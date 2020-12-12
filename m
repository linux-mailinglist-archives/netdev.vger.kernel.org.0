Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 840B22D8893
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 18:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406294AbgLLRXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 12:23:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:57248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725973AbgLLRXt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 12:23:49 -0500
Date:   Sat, 12 Dec 2020 09:23:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607793789;
        bh=KLzfLogU8smjui1QkSTd7mCDMIb6vE33sJHs60dMwaI=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=sD97ELHDoax78A3q2vJF2Vw8FxKFF3PLQhSbQTAm2o0MrpfeyVcqfE08fv1IYMlgR
         3R31QxG7TTGE/bhDAJnjC4AeXE2W4xHQ8L214eoM08hpdPJlVoTSpWbfJTR0Yk1SKb
         oZLmOlb8BV4uUcK0U8RQ3L/x2QRhjIAZAoYbk8KwlK5brYKMFoYnKch8W8tDNRZjkt
         iASIrLS0WJ5B0bxk9NUVf1tNN1SvcM/toNio7uTOie8SP0w/AtuUs3iR7INMaak7wp
         dTnMlQSUxhe0vrYiAMebqTpcDFlHn2DuiqxZWIi/A6vY/rdCCC4+Ch7Ty7cY7ZRQ8i
         GRnQkfkMC0/eQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH v5 1/2] net: dsa: add optional stats64 support
Message-ID: <20201212092308.71023109@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201211105322.7818-2-o.rempel@pengutronix.de>
References: <20201211105322.7818-1-o.rempel@pengutronix.de>
        <20201211105322.7818-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Dec 2020 11:53:21 +0100 Oleksij Rempel wrote:
> +static void dsa_slave_get_stats64(struct net_device *dev,
> +				  struct rtnl_link_stats64 *s)
> +{
> +	struct dsa_port *dp = dsa_slave_to_port(dev);
> +	struct dsa_switch *ds = dp->ds;
> +
> +	if (!ds->ops->get_stats64)
> +		return dev_get_tstats64(dev, s);
> +
> +	return ds->ops->get_stats64(ds, dp->index, s);

nit: please don't return void, "else" will do just fine here
