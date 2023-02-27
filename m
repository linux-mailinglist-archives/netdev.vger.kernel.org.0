Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE0696A4C1E
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 21:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbjB0UQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 15:16:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbjB0UQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 15:16:06 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F9A28D1E;
        Mon, 27 Feb 2023 12:16:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=hWL1M0Jzw9do8OjJOXHOqwxReYbuOYyPL+eIYgRm+hw=; b=UqQ2mb88TtjE2EkIJtOLCaJ02a
        iiQ8yjglSR9DB/Qlcw9ARSwV7hkgMnjLgLkEEQPrNekYBc/6mxckQiZH1K5y0/iw7isk9SuW24MB5
        yrOTL69+tUEEA7Nm48wzgeXW/LaH5poMmth0u6F1sMwEpfDjyPdAtI1XEw6nnvjyS0xLIQoPo7oQQ
        p7ZsFZIAvbb7/06u+7SS/BxToo6oW4fW6TXJYwlBUBkrV1ESePR/5kPraHG6rPAXRDCC4yd2im/34
        5wPNlPhJaDfnrrKvO7xOtF0QIPr32AF/wVhTVfUAoiL7jzMs0dJHXUAuxyLkKdegfAxltF03EkrSA
        IlZ1OQYA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59768)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pWjuU-0003dr-R2; Mon, 27 Feb 2023 20:15:46 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pWjuO-0001yK-2j; Mon, 27 Feb 2023 20:15:40 +0000
Date:   Mon, 27 Feb 2023 20:15:40 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Kevin Cernekee <cernekee@gmail.com>,
        Lukas Wunner <lukas@wunner.de>,
        Manuel Lauss <manuel.lauss@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Olof Johansson <olof@lixom.net>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-can@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC 0/6] pcmcia: separate 16-bit support from cardbus
Message-ID: <Y/0PbJzvrzpvLbcW@shell.armlinux.org.uk>
References: <20230227133457.431729-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230227133457.431729-1-arnd@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 27, 2023 at 02:34:51PM +0100, Arnd Bergmann wrote:
> I don't expect this to be a problem normal laptop support, as the last
> PC models that predate Cardbus support (e.g. 1997 ThinkPad 380ED) are
> all limited to i586MMX CPUs and 80MB of RAM. This is barely enough to
> boot Tiny Core Linux but not a regular distro.

Am I understanding that the argument you're putting forward here is
"cardbus started in year X, so from year X we can ignore 16-bit
PCMCIA support" ?

Given that PCMCIA support has been present in x86 hardware at least
up to 2010, I don't see how that is any basis for making a decision
about 16-bit PCMCIA support.

Isn't the relevant factor here whether 16-bit PCMCIA cards are still
in use on hardware that can run a modern distro? (And yes, x86
machines that have 16-bit PCMCIA can still run Debian Stable today.)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
