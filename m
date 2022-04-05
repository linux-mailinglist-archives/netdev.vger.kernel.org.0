Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF1F04F43C7
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 00:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348411AbiDEUBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457788AbiDEQt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 12:49:59 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07206F3FA2
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 09:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=KwJe7koI5POQVlpJBL90lMmatqhkFD7sMDvSsn+JomQ=; b=oRpaLodPM74A5Jz3ctKqslLx1O
        2enEb3o2oK4zDDOdezUeDVQzEm0YD5KxiEkooiWs9Iz5EetVtcfP9KuXAExejDW5DK3kPxHBZudSO
        dHiwEL/kl/m0BIHSpIeIzcI7bvF1PPwjH+IsL7S4mL4AukNGnskyW9dbKUD+F0CO0HNzIefgczbAn
        oaXLLhpncdEXZ3leBtyCSIf96X0J66Y6Mwht1cQHwiQKSV1neoXLP64haYJaKobPX+Rq0+imP+c/B
        sajFy8wAGPjnnMbpBwyJ6z8Bfk6oX+Fn7kkDYS5pAtlmqIrj24X5H5cUB4rlwL/u3ZF+4pnkWPRky
        7ksrmaxg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58132)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nbmLV-0001iY-Kl; Tue, 05 Apr 2022 17:47:57 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nbmLS-0004Lf-MF; Tue, 05 Apr 2022 17:47:54 +0100
Date:   Tue, 5 Apr 2022 17:47:54 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
Cc:     Prasanna VengateshanVaradharajan 
        <Prasanna.VengateshanVaradharajan@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        hkallweit1 <hkallweit1@gmail.com>, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v2 1/2] net: phy: micrel: add Microchip KSZ 9897 Switch
 PHY support
Message-ID: <YkxyurTmhHseYEcK@shell.armlinux.org.uk>
References: <20220207174532.362781-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
 <20220207174532.362781-2-enguerrand.de-ribaucourt@savoirfairelinux.com>
 <YgGrNWeq6A7Rw3zG@lunn.ch>
 <2044096516.560385.1644309521228.JavaMail.zimbra@savoirfairelinux.com>
 <YgJshWvkCQLoGuNX@lunn.ch>
 <42ea108673200b3076d1b4f8d1fcb221b42d8e32.camel@microchip.com>
 <5a13e486f5eb8c15ae536bde714be873aa22aeb9.camel@microchip.com>
 <899950262.754511.1649170437739.JavaMail.zimbra@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <899950262.754511.1649170437739.JavaMail.zimbra@savoirfairelinux.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 05, 2022 at 10:53:57AM -0400, Enguerrand de Ribaucourt wrote:
> Hello Prasanna,
> 
> Have you had any luck contacting the people working on the KSZ9897
> PHY? As stated with more details in my previous emails, the RMII phy interface of
> the KSZ9897 seems to share the same phy_id as the KSZ8081. However, a different
> ksphy_driver struct must be used for the KSZ9897 PHY to work.

If there is some other way of detecting the phy device, the drivers can
implement the "match_phy_device" method to do whatever it needs to
differentiate between the two.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
