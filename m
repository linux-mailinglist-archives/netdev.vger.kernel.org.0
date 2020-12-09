Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 917BA2D4101
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 12:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730743AbgLILWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 06:22:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730740AbgLILWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 06:22:49 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CBE0C0613CF
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 03:21:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=vcZoHQZwkI8790BaVQGXK1VeMOyjSzYlEMXOj0qjMBA=; b=MZBlBpRG8ea5tyBl1gMFmjv1w
        ELQGb1G4gIOdV7FX468uLMfOYCujFBH0yVeW3GTGnyOXG8xQF5kWQTSkyGNzbnMSS3yz5HdrkPJdl
        xn3MiRevanZ034ayMzPualOaPWnARlKKyMfIyN+DZceUu1jdDtw5Q7zEueEiQOYXjijNzcQBsKmQI
        bpqiw8PdEpWqGuw+LIM7m+ebODtmHrZ4wtBdgQ7xQ5rYuaFlYiyCbuEf296M/L0bxZRUfX66I6ph2
        hj5HPewxPIqikOgkmYBFNF408hL7UUpT41/7TUp/n/51ttxefbvpBdMBcM7mFAeoj0Kwk8dOBRfwV
        XrqacZFTQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:41732)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kmxXc-0002J5-Iq; Wed, 09 Dec 2020 11:21:52 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kmxXc-0006z0-At; Wed, 09 Dec 2020 11:21:52 +0000
Date:   Wed, 9 Dec 2020 11:21:52 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Subject: [PATCH RESEND net-next 0/2] Add support for VSOL V2801F/CarlitoxxPro
 CPGOS03 GPON module
Message-ID: <20201209112152.GT1551@shell.armlinux.org.uk>
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

(Resending, dropping the utf-8 characters in Pali's name so the patches
 get through vger. Added Andrew's r-b tags.)

 drivers/net/phy/sfp-bus.c | 11 ++++-----
 drivers/net/phy/sfp.c     | 63 +++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 63 insertions(+), 11 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
