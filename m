Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 377CA3F9229
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 04:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243929AbhH0B7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 21:59:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44150 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231588AbhH0B7N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 21:59:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=4lIne5FHlydWaN5UNR7D7DuxGZeLkCmilmM1YEyzkHc=; b=ezyVcrjDrkRWKg0PX0HxoXV32g
        gTFQuWv1ugtYv7/sjr58dmaWOnmyEwhLd45JnHjyyUoOLB58EMlhmW8f1rKg+cjwDIktoL/MhqhyP
        HeoMFd1WK4fmu8iHF+/l8+Bq9zaa7bJCD92s6DvF5Wg8Tta14kyPPm3LIaGeTodrP/kw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mJR86-0042Z5-Sq; Fri, 27 Aug 2021 03:58:02 +0200
Date:   Fri, 27 Aug 2021 03:58:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Subject: Re: [PATCH net-next v2 1/2] net: pcs: xpcs: enable skip xPCS soft
 reset
Message-ID: <YShGqldtThS2z0eI@lunn.ch>
References: <20210826235134.4051310-1-vee.khee.wong@linux.intel.com>
 <20210826235134.4051310-2-vee.khee.wong@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210826235134.4051310-2-vee.khee.wong@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 27, 2021 at 07:51:33AM +0800, Wong Vee Khee wrote:
> Unlike any other platforms, Intel AlderLake-S uses Synopsys SerDes where
> all the SerDes PLL configurations are controlled by the xPCS at the BIOS
> level. If the driver perform a xPCS soft reset on initialization, these
> settings will be switched back to the power on reset values.
> 
> This patch introduced a new xpcs_reset() function for drivers such as
> sja1105 and stmmac to decide whether or not to perform a xPCS soft
> reset.
> 
> +	/* If Device ID are all ones, there is no device found */
> +	if (xpcs_id == 0xffffffff)
> +		goto out;
> +

This does not look like plain refactoring. It is not code moved from
somewhere else. At minimum, it needs explaining in the commit message,
but it probably should be a commit of its own.

    Andrew
