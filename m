Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F27F83E46BC
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 15:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233274AbhHINfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 09:35:50 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39978 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229474AbhHINfs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 09:35:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=4ANahQ2cqmBDHTiQEa5YLbEqQAFRzNMJ3iDCtBOXvgI=; b=ZBYHEpi+HbXPwkc/gBLFF8X5pf
        880QW5VjvwWasYI5PzgwK41YsF9fYzv0YeC7r6EwGDR7Au3ztt/yjWgGwM2pvhpBiDrpowKHpPptG
        OUqP2HB7ie0GOy8N5LlbFHRKbBZ63pc9lDK5Q+a6nscl9Vjemgdz3XQnB/GFs6V7icdE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mD5Qr-00Gi51-F9; Mon, 09 Aug 2021 15:35:09 +0200
Date:   Mon, 9 Aug 2021 15:35:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: pcs: xpcs: enable skip xPCS soft reset
Message-ID: <YREvDRkiuScyN8Ws@lunn.ch>
References: <20210809102229.933748-1-vee.khee.wong@linux.intel.com>
 <20210809102229.933748-2-vee.khee.wong@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809102229.933748-2-vee.khee.wong@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 09, 2021 at 06:22:28PM +0800, Wong Vee Khee wrote:
> From: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
> 
> Unlike any other platforms, Intel AlderLake-S uses Synopsys SerDes where
> all the SerDes PLL configurations are controlled by the xPCS at the BIOS
> level. If the driver perform a xPCS soft reset on initialization, these
> settings will be switched back to the power on reset values.
> 
> This changes the xpcs_create function to take in an additional argument
> to check if the platform request to skip xPCS soft reset during device
> initialization.

Why not just call into the BIOS and ask it to configure the SERDES?
Isn't that what ACPI is all about, hiding the details from the OS? Or
did the BIOS writers not add a control method to do this?

    Andrew
