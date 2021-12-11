Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B963F471651
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 22:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbhLKVH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 16:07:57 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:51026 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230241AbhLKVH4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Dec 2021 16:07:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=rN+7kQ6ET02dOVW9ycChVGZ5yjD75s1hdHgxp9AAq9U=; b=tCAw5kF8Rkeo1Vr7uIIFnp2rZQ
        oXrCS2OcZ//cVPDZgxTFZ0EzDal/TieNYkMK7B37XTT79jOrq2BT8+a2Y2oXJBERTNew/5WCTh8iX
        8PlmiqsmQmBup3j4ffT5YnBsoMXcCKobglv1JgKTbFnhTii7RaltNSKihYQNHy/LLLUE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mw9av-00GHlK-Rr; Sat, 11 Dec 2021 22:07:49 +0100
Date:   Sat, 11 Dec 2021 22:07:49 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     alexandru.tachici@analog.com
Cc:     o.rempel@pengutronix.de, davem@davemloft.net,
        devicetree@vger.kernel.org, hkallweit1@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, robh+dt@kernel.org
Subject: Re: [PATCH v4 4/7] net: phy: Add 10BASE-T1L support in phy-c45
Message-ID: <YbUTJdKN9kQAJzqA@lunn.ch>
References: <20211210110509.20970-1-alexandru.tachici@analog.com>
 <20211210110509.20970-5-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211210110509.20970-5-alexandru.tachici@analog.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +		ret = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_EXTABLE);
> +		if (ret < 0)
> +			return ret;
> +
> +		if (ret & MDIO_PMA_EXTABLE_BT1)


This pattern of reading the MDIO_PMA_EXTABLE register and then looking
for bit MDIO_PMA_EXTABLE_BT1 happens a lot. It is not something which
is expected to change is it? So i wounder if it should be read once
and stored away?

    Andrew
