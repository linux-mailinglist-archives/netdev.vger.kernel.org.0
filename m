Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73D1E3BF387
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 03:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbhGHB0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 21:26:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45540 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230106AbhGHB0b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Jul 2021 21:26:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ovUhsJzbNbZZdnPqx60FWO8v2ARmfuy/fc9baIQeuvQ=; b=FK5R+d8/0Kzl4UC+pa0aQzgHP1
        w3ygLiLtAUth8bAwswh0DnmdwIqLeGsyfKNN6nPe9ciJGcP63IeyK40hR4cOi4o2AO9z5Hvk28eCW
        QEMCF55lZ0fdlonx+iZmuAwaCPGRcVDAvkIcAkSLknV4E8nssj09HZjX1kxTVIAl+OZI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m1IlN-00CaFe-P7; Thu, 08 Jul 2021 03:23:37 +0200
Date:   Thu, 8 Jul 2021 03:23:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     mohammad.athari.ismail@intel.com
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: phy: reconfigure PHY WOL in resume if WOL
 option still enabled
Message-ID: <YOZTmfvVTj9eo+to@lunn.ch>
References: <20210708004253.6863-1-mohammad.athari.ismail@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210708004253.6863-1-mohammad.athari.ismail@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 08, 2021 at 08:42:53AM +0800, mohammad.athari.ismail@intel.com wrote:
> From: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
> 
> When the PHY wakes up from suspend through WOL event, there is a need to
> reconfigure the WOL if the WOL option still enabled. The main operation
> is to clear the WOL event status. So that, subsequent WOL event can be
> triggered properly.
> 
> This fix is needed especially for the PHY that operates in PHY_POLL mode
> where there is no handler (such as interrupt handler) available to clear
> the WOL event status.

I still think this architecture is wrong.

The interrupt pin is wired to the PMIC. Can the PMIC be modelled as an
interrupt controller? That would allow the interrupt to be handled as
normal, and would mean you don't need polling, and you don't need this
hack.

	Andrew
