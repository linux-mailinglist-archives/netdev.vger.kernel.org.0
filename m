Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44A3666411E
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 14:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238475AbjAJNC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 08:02:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238560AbjAJNCv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 08:02:51 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FAE1517FD;
        Tue, 10 Jan 2023 05:02:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7ngEhhirOfjyfMGAj9SQ4AJKD7e1pf8Qix91Trpp+M8=; b=fkMbI38a1MwWJWeVotlhK/AsbV
        TTZLsKbdHWq6RlX43v2MFIVnNSOkzHYFpt2rIQ5XpMUM260wwls8KfRSo3WJy/969bXSyfSKYcCdo
        JrSSKr6mtKY2gpsj+0CbS6q1heP5oX5E3zPY/cjARULUzLJwu5/W6mo8udtdRGWaAJU5I6BgzuvNI
        XYmc8H1mhwHvgPgCSE3JCwVDwnPpq5DknWjcjRFylG46wQc2eari5xDgCcpLDBI9PfY4zcJ+NB98W
        XuPST6UktxAVqs7/N8lyKntcxcrxoeB9ep9wJ8r6mpb8kQ7Ir9SAXvwlgfniOx9N/BcAMwN3mZiUC
        wuGguA1g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36036)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pFEH1-0003y3-TK; Tue, 10 Jan 2023 13:02:40 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pFEGy-0000Jz-K4; Tue, 10 Jan 2023 13:02:36 +0000
Date:   Tue, 10 Jan 2023 13:02:36 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Wolfram Sang <wsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-acpi@vger.kernel.org, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH RFC v2 0/2] Add I2C fwnode lookup/get interfaces
Message-ID: <Y71h7OF6ydo2A0dw@shell.armlinux.org.uk>
References: <Y6Az235wsnRWFYWA@shell.armlinux.org.uk>
 <Y7v/FWpjt1MFLafG@ninjato>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7v/FWpjt1MFLafG@ninjato>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 09, 2023 at 12:48:37PM +0100, Wolfram Sang wrote:
> > This RFC series is intended for the next merge window, but we will need
> > to decide how to merge it as it is split across two subsystems. These
> > patches have been generated against the net-next, since patch 2 depends
> > on a recently merged patch in that tree (which is now in mainline.)
> 
> I'd prefer to apply it all to my I2C tree then. I can also provide an
> immutable branch for net if that is helpful.

If we go for the immutable branch, then patch 2 might as well be
merged via the net tree, if net-next is willing to pull your
immutable branch.

Dave? Jakub? Paolo? Do you have any preferences how you'd like to
handle this?

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
