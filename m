Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE4D1B7762
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 15:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728260AbgDXNrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 09:47:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60888 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727950AbgDXNrh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 09:47:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=u/aH99iW2COqVXOfn1R99fZmE2Jmf4kXRPLMJLjKuk8=; b=2LYDgwQ+LWiklz7ulF+m38Tpb1
        /kOFFLZOuXbMOgNar7wcBbibtFKUJlIJhf/kqISuTb9qf/TSsEMUKhuNLgc7QkKdRP48bb+f4NHmJ
        k0lpybcseCObwzsFagA54IJj+dC0PnVHC1ufFOD+L8VGbR2cxjEangyxdKd4SCRjas3Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jRyfx-004Z0x-Ot; Fri, 24 Apr 2020 15:47:29 +0200
Date:   Fri, 24 Apr 2020 15:47:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florinel Iordache <florinel.iordache@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 6/9] net: phy: add backplane kr driver support
Message-ID: <20200424134729.GC1087366@lunn.ch>
References: <1587732391-3374-1-git-send-email-florinel.iordache@nxp.com>
 <1587732391-3374-7-git-send-email-florinel.iordache@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1587732391-3374-7-git-send-email-florinel.iordache@nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/* Backplane custom logging */
> +#define bpdev_fn(fn)							\
> +void bpdev_##fn(struct phy_device *phydev, char *fmt, ...)		\
> +{									\
> +	struct va_format vaf = {					\
> +		.fmt = fmt,						\
> +	};								\
> +	va_list args;							\
> +	va_start(args, fmt);						\
> +	vaf.va = &args;							\
> +	if (!phydev->attached_dev)					\
> +		dev_##fn(&phydev->mdio.dev, "%pV", &vaf);		\
> +	else								\
> +		dev_##fn(&phydev->mdio.dev, "%s: %pV",			\
> +			netdev_name(phydev->attached_dev), &vaf);	\
> +	va_end(args);							\
> +}
> +
> +bpdev_fn(err)
> +EXPORT_SYMBOL(bpdev_err);
> +
> +bpdev_fn(warn)
> +EXPORT_SYMBOL(bpdev_warn);
> +
> +bpdev_fn(info)
> +EXPORT_SYMBOL(bpdev_info);
> +
> +bpdev_fn(dbg)
> +EXPORT_SYMBOL(bpdev_dbg);

Didn't i say something about just using phydev_{err|warn|info|dbg}?

       Andrew
