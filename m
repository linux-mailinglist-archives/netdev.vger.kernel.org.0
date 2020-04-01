Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE6319AC58
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 15:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732166AbgDAND3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 09:03:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42922 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732252AbgDAND3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 09:03:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Z/JNN9vM8sF4KKrmVuUlEJ1vAbgLDA51EFwdX+f8al0=; b=SlosnrE3NMyvDUAatcrwmsKITZ
        LBHaBzg22lmqWMIo5T9+kqCOc9MgqaBdmR/WaLqCKK9SwAFbzK/NuFslIl9eXnv75FRaWVWIeWAh4
        yga5OcvnSQedgZj75O2CG62piaDwgtbD4I8uD8Vc07w8jXIYKhkZ1Vm5TEUyAfMMSOTw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jJd1d-000QAr-9i; Wed, 01 Apr 2020 15:03:21 +0200
Date:   Wed, 1 Apr 2020 15:03:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Baruch Siach <baruch@tkos.co.il>,
        Russell King <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Shmuel Hazan <sh@tkos.co.il>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] net: phy: marvell10g: add firmware load support
Message-ID: <20200401130321.GA71179@lunn.ch>
References: <16e4a15e359012fc485d22c7e413a129029fbd0f.1585676858.git.baruch@tkos.co.il>
 <DB8PR04MB6828927ED67036524362F369E0C90@DB8PR04MB6828.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB8PR04MB6828927ED67036524362F369E0C90@DB8PR04MB6828.eurprd04.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ioana

> This is typically the case for Aquantia PHYs.

The Aquantia is just odd. I would never use it as a generic example.
If i remember correctly, its 'firmware' is actually made up of
multiple parts, only part of which is actual firmware. It has
provisioning, which can be used to set register values. This
potentially invalidates the driver, which makes assumptions about
reset values of registers. And is contains board specific data, like
eye configuration.

As i understand it, Aquantia customises the firmware for the specific
PHY on each board design.

For a general purpose OS like Linux, this will have to change before
we support firmware upload. We need generic firmware, which is the
same everywhere, and then PHY specific blobs for things like the eye
configuration. This basic idea has been around a long time in the WiFi
world. The Atheros WiFi chipsets needed a board specific blod which
contains calibration data, path losses on the board, in order that the
transmit power could be tuned to prevent it sending too much power out
the aerial.

    Andrew
