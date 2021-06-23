Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 924663B2295
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 23:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbhFWVlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 17:41:16 -0400
Received: from mail.nic.cz ([217.31.204.67]:55790 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229796AbhFWVlP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 17:41:15 -0400
Received: from thinkpad (unknown [172.20.6.87])
        by mail.nic.cz (Postfix) with ESMTPSA id 6E2B4140B53;
        Wed, 23 Jun 2021 23:38:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1624484336; bh=IbpJn7feV38gl8Ic2De823HwB1rhd+wrPh4JbEInURQ=;
        h=Date:From:To;
        b=tuOZlPT2WiNA0NCMPqCozcxRpR8LcgdUbhFSQWJASs+wAHBXQENZ0DEbPDLp4Vh+j
         6ZTvqsg0MrconVh8US0kifvAj/jzObwIkmSLcDVW9r/BktHSo6GD2ByEFBjZPyZpx9
         zJcwG5UyWHy/KOKrWmGMe6Vv30v8hwLQdEzsYf5o=
Date:   Wed, 23 Jun 2021 23:38:54 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Ling Pei Lee <pei.lee.ling@intel.com>
Cc:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, weifeng.voon@intel.com,
        vee.khee.wong@linux.intel.com, vee.khee.wong@intel.com
Subject: Re: [PATCH net-next] net: phy: marvell10g: enable WoL for mv2110
Message-ID: <20210623233854.03ed9240@thinkpad>
In-Reply-To: <20210623130929.805559-1-pei.lee.ling@intel.com>
References: <20210623130929.805559-1-pei.lee.ling@intel.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Jun 2021 21:09:29 +0800
Ling Pei Lee <pei.lee.ling@intel.com> wrote:

> +		/* Enable the WOL interrupt */
> +		ret = phy_set_bits_mmd(phydev, MDIO_MMD_VEND2,
> +				       MV_V2_PORT_INTR_MASK,
> +				       MV_V2_WOL_INTR_EN);
> +
> +		if (ret < 0)
> +			return ret;

Hi, in addition to what Russell said, please remove the extra newline
between function call and return value check, i.e. instead of
  ret = phy_xyz(...);

  if (ret)
     return ret;

  ret = phy_xyz(...);

  if (ret)
     return ret;

do
  ret = phy_xyz(...);
  if (ret)
     return ret;

  ret = phy_xyz(...);
  if (ret)
     return ret;

This is how this driver does this everywhere else.

Do you have a device that uses this WoL feature?

Marek
