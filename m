Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAED02CEFC0
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 15:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729261AbgLDOft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 09:35:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726763AbgLDOft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 09:35:49 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09E98C0613D1
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 06:35:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=GD2AyiKTnwJzSydaVJCgJaLC5ezj5eDJBsMn7tub+lg=; b=lcjq4ybu1q1bpfO7/TuSZkzy3
        6TGEuyULwClFed1cEB3v+mTxE6XQMbYc3AAYH7MaNC/FYCgX2yZgNzcFb5opa0pF8sphj6utdDhVS
        rkG7Ds4xsPUw+jVz5wUQxVZfxiLv5w4A6VTCkVCqk0nZpZfwutbq3NiOYNUXBN/gOblRlE/Yz4nDj
        ETWh2AN+LBCLB+oUwaSfaUFIJL4Sxdkp1YGiJMkeHISVeubr8MkCTSOyHLUeL97YDrtYjGX/z2srv
        6q51KfBKghjoXbCbIW/BzIxDEVh8NXTOhPjQCX+MZevbn8G6dl/XU5UhuUc75hact4NsZYKU/FvnW
        uAhGYUGVA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:39702)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1klCAf-0004SU-CG; Fri, 04 Dec 2020 14:34:53 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1klCAe-0000jf-4k; Fri, 04 Dec 2020 14:34:52 +0000
Date:   Fri, 4 Dec 2020 14:34:52 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Subject: [PATCH net-next 0/2] Add support for VSOL V2801F/CarlitoxxPro
 CPGOS03 GPON module
Message-ID: <20201204143451.GL1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patch set adds support for the V2801F / CarlitoxxPro module. This
requires two changes:

1) the module only supports single byte reads to the ID EEPROM,
   while we need to still permit sequential reads to the diagnostics
   EEPROM for atomicity reasons.

2) we need to relax the encoding check when we have no reported
   capabilities to allow 1000base-X based on the module bitrate.

Thanks to Pali Rohár for responsive testing over the last two days.

 drivers/net/phy/sfp-bus.c | 11 ++++-----
 drivers/net/phy/sfp.c     | 63 +++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 63 insertions(+), 11 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
