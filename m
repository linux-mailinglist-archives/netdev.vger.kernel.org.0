Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 135C46C3780
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 17:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjCUQ6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 12:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjCUQ6k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 12:58:40 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 063DA28225
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 09:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=eUW5M0UdqFM6vJU8nSG5h+zk73VJs09CyqbfhLx2pus=; b=LfdqhENnjqhsouaC33yDEruTTl
        wjupj8XJLnMKSdroCAhPJyxiM0KbJUf2zHBQZFNWIqawpqsH2k9x48SdJaPUV2G6VXbVqZMFmsWmX
        2x12zf3Fu8R+Kn6en+VymNUvIa+xN/U/lup9Fn3pHKNcVhIqtXnljSoJDU0itRcpI+htoqjrj3Yub
        nPIMKwh09Et89N3MzlVnCP7gySL70HJGthOaFgwDxXMugoZyRg6TgEUyTi4H+BZczDakItyNj7jO0
        hQlJknMlWoHCo+4CIa7GHnuDAcV9z2TP7OXheF/Z6dj7v6ZzGPQjskchR5EhX5s7i0wTiWMdC+Yw1
        VtIr+ogA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59678)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pefJe-0001Zz-MB; Tue, 21 Mar 2023 16:58:30 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pefJa-0007uC-6H; Tue, 21 Mar 2023 16:58:26 +0000
Date:   Tue, 21 Mar 2023 16:58:26 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 0/2] Quirk for OEM SFP-2.5G-T copper module
Message-ID: <ZBniMlTDZJQ242DP@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Frank Wunderlich reports that this copper module requires a quirk in
order to function - in that the module needs to use 2500base-X.
Moreover, negotiation must be disabled.

An example of this device would be:

  https://www.optcore.net/product/sfp-2g-t-gen

 drivers/net/phy/sfp-bus.c |  8 ++++----
 drivers/net/phy/sfp.c     | 18 ++++++++++++++++++
 2 files changed, 22 insertions(+), 4 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
