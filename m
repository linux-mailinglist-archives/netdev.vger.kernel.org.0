Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73F9453FD79
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 13:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242829AbiFGL21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 07:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241918AbiFGL20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 07:28:26 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D121027B0B
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 04:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=8dAkfil83FPC50WHNZyO/HwcGhweEQPOiBls/M++Gm4=; b=x4ek+V9xivnatV//JY2halNbQ9
        HgqtJk/9aO+gRWxTv31mEIdGZJa2WHmZ6EWzw3yGMXJo+YEbn7R9LfMRRgRryzen4mTEr3WDOQHp7
        xkJpTlPIB+f1zkn56Ahe2vllmaIigwXnlAzYDAGxCAne7LkVwCxlzYe1GCaU7lYRMFBF/ULchJNfY
        nFFmZrIhzLaIXLKGjYnVU715TMSZcOcolP5bMhjeXRPpzDZ1RWErMiR3csV2xfBlu3lsRfYFAt0Nw
        XZjDBiQdT+M+oK1DtkayaHXGXwOB5I1f0jL1q+g1Wzo2z13UIhDX+NXP8uUvaSEEg5TePvRBLNA8y
        YIxLhlaw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:60990)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nyXNg-0003Jm-U1; Tue, 07 Jun 2022 12:28:17 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nyXNf-0000kN-7e; Tue, 07 Jun 2022 12:28:15 +0100
Date:   Tue, 7 Jun 2022 12:28:15 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net 0/3] mv88e6xxx: fixes for reading serdes state
Message-ID: <Yp82TyoLon9jz6k3@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

These are some low-priority fixes to the mv88e6xxx serdes code.
Patch 1 fixes the reporting of an_complete, which is used in the
emulation of a conventional C22 PHY. Patch from Marek.

Patch 2 makes one of the error messages in patch 2 to be consistent
with the other error messages in this function.

Patch 3 ensures that we do not miss a link-failure event.

 drivers/net/dsa/mv88e6xxx/serdes.c | 35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
