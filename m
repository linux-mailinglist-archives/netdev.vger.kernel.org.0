Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1106F66BFE6
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 14:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbjAPNg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 08:36:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230496AbjAPNg1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 08:36:27 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11EE414483;
        Mon, 16 Jan 2023 05:36:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=68rMq7lR6DYBUEMspuiiZmjssqJolmBilxN0dR3BVAw=; b=v0gen4kt3Eesrx6UQbktoZB1D/
        R0QDgmqZ8n9Y9IJaOYCgVXstA+ozhYZpJAVuNeABJci2bNBwAlKk94uy919M+4+Deb+ugJaClacc0
        lEBT5dolQVJQ4EZds3reT50dywJ8qYLyFgJD+tYkOvY6q0KlAjMg41L3IGrnHJSlcGQKstJxcnpXN
        Ziryixx+TU/lzif0TKvTHauXR4OBoQ2doiMavDTBLwBwAGFh/MWrU7WirHE2XMA9CKxSDLwTIgdH+
        2vqMvFJccXW4BB0MXjqXC7txOPES9UGi8rluljaa89RZH8Rh33pNzlVuXpNHggxyTTVNnHCVmBN8S
        kJdY1Dxw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36126)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pHPet-000504-Pm; Mon, 16 Jan 2023 13:36:19 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pHPer-00062x-9O; Mon, 16 Jan 2023 13:36:17 +0000
Date:   Mon, 16 Jan 2023 13:36:17 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Pierluigi Passaro <pierluigi.p@variscite.com>
Cc:     Simon Horman <simon.horman@corigine.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eran Matityahu <eran.m@variscite.com>,
        Nate Drude <Nate.D@variscite.com>,
        Francesco Ferraro <francesco.f@variscite.com>,
        "pierluigi.passaro@gmail.com" <pierluigi.passaro@gmail.com>
Subject: Re: [PATCH v2] net: mdio: force deassert MDIO reset signal
Message-ID: <Y8VS0Wlpg7TGXk2d@shell.armlinux.org.uk>
References: <20230115213746.26601-1-pierluigi.p@variscite.com>
 <Y8UwrzenvgGw8dns@corigine.com>
 <AM6PR08MB43764E8EB99B48897327CFCCFFC19@AM6PR08MB4376.eurprd08.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM6PR08MB43764E8EB99B48897327CFCCFFC19@AM6PR08MB4376.eurprd08.prod.outlook.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 01:13:49PM +0000, Pierluigi Passaro wrote:
> I'm worried I'm asking something stupid: what do you mean by
> "reverse xmas tree" ?> ...

Ordering them so that the longest is first, followed by the next longest
all the way down to the shortest.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
