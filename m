Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7303B34A6
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 19:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbhFXRWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 13:22:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54224 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229573AbhFXRWC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 13:22:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=OEziKPZQGGWl0OVpnY1fJqH2ncXGVTBV096QkbU4Ni4=; b=AvdlOi+nCkrZzk0S02U7I2UmWv
        2g3AGkZbMiPK+bqp6xGrFLKabv5mgstnv3ttqJxDHFSECBGVKZGcpgsiFxH7Epe+qylbWkOjzmrX/
        p9PPpGZqUWMzwvloxfYNEZxJoqTUT4LAKicEYEZojIxvescPybnUpq90V8BV6z3Otw40=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lwT0u-00B0Ti-Kz; Thu, 24 Jun 2021 19:19:40 +0200
Date:   Thu, 24 Jun 2021 19:19:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     alexandru.tachici@analog.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH 2/4] net: phy: adin1100: Add ethtool get_stats support
Message-ID: <YNS+rEcYXlTqirwg@lunn.ch>
References: <20210624145353.6910-1-alexandru.tachici@analog.com>
 <20210624145353.6910-3-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210624145353.6910-3-alexandru.tachici@analog.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static u64 adin_get_stat(struct phy_device *phydev, int i)
> +{
> +	const struct adin_hw_stat *stat = &adin_hw_stats[i];
> +	struct adin_priv *priv = phydev->priv;
> +	u64 val;
> +	int ret;
> +
> +	ret = phy_read_mmd(phydev, MDIO_MMD_VEND2, stat->reg1);
> +	if (ret < 0)
> +		return (u64)(~0);

U64_MAX is more common.

	Andrew
