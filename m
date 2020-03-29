Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D02F5196E15
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 17:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728282AbgC2PJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 11:09:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37476 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727729AbgC2PJB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Mar 2020 11:09:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5k91iJvz4PccPOFEwloR/4H/cQNQeGa+coxrPB2qksw=; b=Zv03jrAbvyZvIP06Bvblmgrp7j
        rFjCPmTRKfXrIKGuFAPmy1CBKTUn/TAswsiP440JH+ZU1JmygnPjq4BHg/yR2/8td0//lNdJ/sxXV
        BXB2Gu78RT3E4lAWACrxXJx2zIlf7fkR4BpcVOMirmZkaC/JPwkKIzpwso3WZH4vSrGw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jIZYU-0004NO-DC; Sun, 29 Mar 2020 17:08:54 +0200
Date:   Sun, 29 Mar 2020 17:08:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com,
        Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v2] ARM: imx: allow to disable board specific PHY fixups
Message-ID: <20200329150854.GA31812@lunn.ch>
References: <20200329110457.4113-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200329110457.4113-1-o.rempel@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 29, 2020 at 01:04:57PM +0200, Oleksij Rempel wrote:

Hi Oleksij

> +config DEPRECATED_PHY_FIXUPS
> +	bool "Enable deprecated PHY fixups"
> +	default y
> +	---help---
> +	  In the early days it was common practice to configure PHYs by adding a
> +	  phy_register_fixup*() in the machine code. This practice turned out to
> +	  be potentially dangerous, because:
> +	  - it affects all PHYs in the system
> +	  - these register changes are usually not preserved during PHY reset
> +	    or suspend/resume cycle.
> +	  - it complicates debugging, since these configuration changes were not
> +	    done by the actual PHY driver.
> +	  This option allows to disable all fixups which are identified as
> +	  potentially harmful and give the developers a chance to implement the
> +	  proper configuration via the device tree (e.g.: phy-mode) and/or the
> +	  related PHY drivers.

This appears to be an IMX only problem. Everybody else seems to of got
this right. There is no need to bother everybody with this new
option. Please put this in arch/arm/mach-mxs/Kconfig and have IMX in
the name.

Having said that, i'm not sure this is the best solution. You cannot
build one kernel which runs on all machines. Did you consider some
sort of DT property to disable these fixup? What other ideas did you
have before deciding on this solution?

     Andrew
