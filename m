Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 091F62793B2
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 23:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728710AbgIYVlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 17:41:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:40566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726849AbgIYVlP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 17:41:15 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 301AC20659;
        Fri, 25 Sep 2020 21:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601070075;
        bh=NQjy9sPSZLab1IrZwEwF1xrxJ77o+41JH+NICSkVe4s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xoLL8qY09p36erTfZuQj1hH7OJewdK5YtsoY0tLM/pT1UCFFtOo27/WxP30rBXj55
         VXfzonjexiP7h0FDQm1es6cV0E4To6348JRUkFEeyjY1Givojg9cldAWD6Hx3Qq1NT
         vgPFN5WwnFANC6cxEYHZWNXBd1NkpSqHOkSHbiVQ=
Date:   Fri, 25 Sep 2020 14:41:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Willy Liu <willy.liu@realtek.com>
Cc:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <fancer.lancer@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ryankao@realtek.com>, <kevans@FreeBSD.org>
Subject: Re: [PATCH net] net: phy: realtek: fix rtl8211e rx/tx delay config
Message-ID: <20200925144113.54be6e1b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1601018715-952-1-git-send-email-willy.liu@realtek.com>
References: <1601018715-952-1-git-send-email-willy.liu@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Sep 2020 15:25:15 +0800 Willy Liu wrote:
> There are two chip pins named TXDLY and RXDLY which actually adds the 2ns
> delays to TXC and RXC for TXD/RXD latching. These two pins can config via
> 4.7k-ohm resistor to 3.3V hw setting, but also config via software setting
> (extension page 0xa4 register 0x1c bit13 12 and 11).
> 
> The configuration register definitions from table 13 official PHY datasheet:
> PHYAD[2:0] = PHY Address
> AN[1:0] = Auto-Negotiation
> Mode = Interface Mode Select
> RX Delay = RX Delay
> TX Delay = TX Delay
> SELRGV = RGMII/GMII Selection

Checkpatch says:

ERROR: do not set execute permissions for source files
#48: FILE: drivers/net/phy/realtek.c

ERROR: trailing whitespace
#91: FILE: drivers/net/phy/realtek.c:266:
+^I * the RX/TX delays otherwise controlled by RXDLY/TXDLY pins. $

total: 2 errors, 0 warnings, 0 checks, 54 lines checked
