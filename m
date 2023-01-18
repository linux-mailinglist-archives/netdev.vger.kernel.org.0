Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A047671A23
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 12:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbjARLMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 06:12:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjARLLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 06:11:35 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8417798D0
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 02:20:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=3XUOBNmcfLGOSQl2ZrUXPar8Z9PBMtD4WrICOV3j9rA=; b=TnykMYuoSXXUFmiMuL/DUa9Gdz
        UO4rhd9QbiB63AKRJZi2VSzpIv5HZwHNa5FPyeUcsRSj60Z+HQZ7wv1zHHZjouZ4WCpF1LFpVm2xZ
        A7WQnj9XBCdNCMiVuiD/yJA2yRyVuCIfOVBodX468RihgqC7K1LTcfwTQ8vGj+Zb6/gzKHabVcdKl
        vdUEQ+j7X/rEyZPaqEPkCqzo5GCwT9BVyA7hm95MnsjRf93pqLapT73Efx7ArqaEDEYG32evP6ixn
        ZrtnrvaO/zFtobm2i/J6qmFrZaZVjf2aHDFTu3qmMJjKODFLzr+iAAYU0lo9ilNlly68ONVTCMEIm
        uUvIVYMw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36174)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pI5Yi-0001P5-GF; Wed, 18 Jan 2023 10:20:44 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pI5Yf-0007r7-Mx; Wed, 18 Jan 2023 10:20:41 +0000
Date:   Wed, 18 Jan 2023 10:20:41 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 0/5] net: sfp: cleanup i2c / dt / acpi / fwnode /
 includes
Message-ID: <Y8fH+Vqx6huYQFDU@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series cleans up the DT/fwnode/ACPI code in the SFP cage driver:

1. Use the newly introduced i2c_get_adapter_by_fwnode(), which removes
the need to know about ACPI handles to find the I2C device.

2. Use device_get_match_data() to get the match data, rather than
having to look up the matching DT device_id to get at the data.

3. Rename gpio_of_names, as this is not DT specific.

4. Remove acpi.h include which is no longer necessary.

5. Remove ctype.h include which, as far as I can tell, was never
necessary.

 drivers/net/phy/sfp.c | 39 +++++++++------------------------------
 1 file changed, 9 insertions(+), 30 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
