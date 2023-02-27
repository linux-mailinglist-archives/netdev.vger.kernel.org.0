Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA49F6A4CA3
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 22:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbjB0VAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 16:00:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjB0VAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 16:00:08 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AA0623C61;
        Mon, 27 Feb 2023 13:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=yxNQq6iAQdNqxHxg6xpTtkOHUc+Bubub8MOHjovJQps=; b=qyVfgukQMEl2DxmqtcwlmlPvAS
        zB0a5j0IaU+dxaa+FZ/IrkDC1aspPRZqLBVqU/IRHkrXqonSnmBFUMTmdh2tcYPrQSuypIAHnm0b1
        5nq6HJBj0bHs+FMmFAGL7rFgfDSjnVnNau1zD4uX6PoNp/gn/PZqO9OJ+Q+t9IOSEgdIzGVjlnExq
        ivSxHAYdsaCHjb7xSXNSR5lKVZta2YosZU6uAKuG9E5SaeJyLyY0zgYZqWg4R35ZetWFvFy6ffs/f
        fxJv1XsiUiYUHph/6lWq07apbkvD7+RNGehLp3qdjHr8/OXCMR2nnTUD4VA1sa5QNJq1aXf7S0Q6j
        qzusSVVg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:39650)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pWkbF-0003hx-So; Mon, 27 Feb 2023 20:59:57 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pWkbD-0001zh-G7; Mon, 27 Feb 2023 20:59:55 +0000
Date:   Mon, 27 Feb 2023 20:59:55 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Larry Finger <Larry.Finger@lwfinger.net>,
        Arnd Bergmann <arnd@kernel.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
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
        linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>
Subject: Re: [RFC 0/6] pcmcia: separate 16-bit support from cardbus
Message-ID: <Y/0Zy0nUmorvrp1u@shell.armlinux.org.uk>
References: <20230227133457.431729-1-arnd@kernel.org>
 <3d8f28d7-78df-5276-612c-85b5262a987a@lwfinger.net>
 <c17bff4e-031e-4101-8564-51f6298b1c68@app.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c17bff4e-031e-4101-8564-51f6298b1c68@app.fastmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 27, 2023 at 09:38:54PM +0100, Arnd Bergmann wrote:
> On Mon, Feb 27, 2023, at 21:23, Larry Finger wrote:
> > On 2/27/23 07:34, Arnd Bergmann wrote:
> 
> >
> > Your patch set also breaks my PowerBook G4. The output of 'lspci -nn | grep 
> > Network' shows the following before your patch is applied:
> >
> > 0001:10:12.0 Network controller [0280]: Broadcom Inc. and subsidiaries BCM4306 
> > 802.11b/g Wireless LAN Controller [14e4:4320] (rev 03)
> > 0001:11:00.0 Network controller [0280]: Broadcom Inc. and subsidiaries BCM4318 
> > [AirForce One 54g] 802.11g Wireless LAN Controller [14e4:4318] (rev 02)
> >
> > The first of these is broken and built into the laptop. The second is plugged 
> > into a PCMCIA slot, and uses yenta-socket as a driver.
> >
> > When your patches are applied, the second entry vanishes.
> >
> > Yes, this hardware is ancient, but I would prefer having this wifi interface 
> > work. I can provide any output you need.
> 
> Is this the Cardbus or the PCMCIA version of the BCM4306 device? As far
> as I understand this particular chip can be wired up either way inside
> of the card, and the PowerBook G4 supports both types of devices.
> 
> If it's the PCMCIA version, then dropping support for it was the idea
> of the patch series that we can debate, but if it was the Cardbus version
> that broke, then this was likely a bug I introduced by accident.

If it shows up as a PCI device, it will be cardbus, not 16-bit ISA.

PCMCIA cards don't show up in lspci.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
