Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3926222E6B
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 00:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726337AbgGPWJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 18:09:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:54036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726007AbgGPWJV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 18:09:21 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34279207CB;
        Thu, 16 Jul 2020 22:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594937361;
        bh=ozWnyPq7Ypaqxjd2YOpSvdhU336Z196r9xpYYwHOCKI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IAA8Oq8jOnQqf+WZ34v/KyOhgc95aznMfcAsz2ya5um49qLNjolsHIxOlH4OFRtwa
         iT55Eukho1Ak/lAKDObxR17ZV2I6E/n+uCEDywxHaPDieR+nEJsPrq6LOvpG787Umr
         xZx7q6lnJ1Kl1Qxhl9qV9Pww4w1CSFbBX/G7sIes=
Date:   Thu, 16 Jul 2020 15:09:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matthew Hagan <mnhagan88@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Crispin <john@phrozen.org>,
        Jonathan McDowell <noodles@earth.li>
Subject: Re: [PATCH 1/2] net: dsa: qca8k: Add additional PORT0_PAD_CTRL
 options
Message-ID: <20200716150918.6c287f7a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <2e1776f997441792a44cd35a16f1e69f848816ce.1594668793.git.mnhagan88@gmail.com>
References: <2e1776f997441792a44cd35a16f1e69f848816ce.1594668793.git.mnhagan88@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jul 2020 21:50:25 +0100 Matthew Hagan wrote:
> +	u32 val = qca8k_read(priv, QCA8K_REG_PORT0_PAD_CTRL);

> +		val |= QCA8K_PORT0_PAD_CTRL_MAC06_EXCHG;

> +		val |= QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE;

> +		val |= QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE;

> +	qca8k_write(priv, QCA8K_REG_PORT0_PAD_CTRL, val);

> +	val = qca8k_read(priv, reg);

> +		val |= QCA8K_PORT_PAD_RGMII_EN;
> +		qca8k_write(priv, reg, val);

> +		val |= QCA8K_PORT_PAD_RGMII_EN |
> +		       QCA8K_PORT_PAD_RGMII_TX_DELAY(QCA8K_MAX_DELAY) |
> +		       QCA8K_PORT_PAD_RGMII_RX_DELAY(QCA8K_MAX_DELAY);
> +		qca8k_write(priv, reg, val);


> +		val |= QCA8K_PORT_PAD_SGMII_EN;
> +		qca8k_write(priv, reg, val);

Since throughout the patch you're only setting bits perhaps
qca8k_reg_set() would be a better choice than manually reading 
and then writing?
