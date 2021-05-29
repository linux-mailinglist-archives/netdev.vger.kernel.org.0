Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D38A639497B
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 02:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbhE2AXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 20:23:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34786 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229528AbhE2AXu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 20:23:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=AGrOMjrB8PkVi7aeI+ZHwE/D7dNsrdCe0Y1qW9/Xf7Q=; b=JAwkfKa4b+R4z95o8Ts4NGypQO
        AvwczwZLoGwthlbDygq5400ysjb2ALDcpHJasO047RoPE67Ke4AGE2LpMIiEn7qCTBYYotxb+0Xzg
        Q8tc1kkgZpFm28ymvZ2nvdYt8F0XSIPeJzdCW1WKbx/61iNRh/d0qTAKFuBaj3Gb9aoo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lmmju-006ouE-Cx; Sat, 29 May 2021 02:22:06 +0200
Date:   Sat, 29 May 2021 02:22:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Thompson <davthompson@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        limings@nvidia.com, Asmaa Mnebhi <asmaa@nvidia.com>
Subject: Re: [PATCH net-next v5] Add Mellanox BlueField Gigabit Ethernet
 driver
Message-ID: <YLGJLv7y0NLPFR28@lunn.ch>
References: <20210528193719.6132-1-davthompson@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210528193719.6132-1-davthompson@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static void mlxbf_gige_adjust_link(struct net_device *netdev)
> +{
> +	struct mlxbf_gige *priv = netdev_priv(netdev);
> +	struct phy_device *phydev = netdev->phydev;
> +
> +	if (phydev->link) {
> +		priv->rx_pause = phydev->pause;
> +		priv->tx_pause = phydev->pause;
> +	}

...

> +	/* MAC supports symmetric flow control */
> +	phy_support_sym_pause(phydev);

What i don't see anywhere is you acting on the results of the pause
negotiation. It could be, mlxbf_gige_adjust_link() tells you the peer
does not support pause, and you need to disable it in this MAC as
well. It is a negotiation, after all.

	Andrew
