Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D03CA523099
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 12:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233233AbiEKKVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 06:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235216AbiEKKVk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 06:21:40 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEDE92E9E5
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 03:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=toEksGmfGu2Y9e3vzMFfVA0akhWI6x/DiX7UrNN2Y4o=; b=PeeYbWPvqbmxH37eB2BBpKqe3b
        2wMX8L5UIH5RDzyT3o82E1GOQjEm2ha/gfAcQrSQK3ZH8oIVglzYNDrcugSywdg5SoRG8DjtD1XOh
        kTU8ikQZDVW7G09SSow+7JDqCxXHvIZ5JpClnN6yoEkBYAhzz97bbKuWPYsPJcZlOst7Sk0cWQzoD
        t/SNQJm2SW9Vd2NstnD1sJieOCvACGnZCy9ZVnERQOMYyixUuVs4Qo+TnTLqkhKNkJNtkAPhf5alF
        6CBFJP5RdcmoJJMKnFmJaGt4x8xGl8oxz+6KDK3BFqo3qkQhDNZfztFSnmaU/MlBcnY+eYdqmxKaO
        87OnMrVg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:60676)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nojTK-0006cV-PF; Wed, 11 May 2022 11:21:35 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nojTJ-00070U-UX; Wed, 11 May 2022 11:21:33 +0100
Date:   Wed, 11 May 2022 11:21:33 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Josua Mayer <josua@solid-run.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH RFC] net: sfp: support assigning status LEDs to SFP
 connectors
Message-ID: <YnuOLelD/mh5GT/T@shell.armlinux.org.uk>
References: <20220509122938.14651-1-josua@solid-run.com>
 <Ynk5UPWkuoXeqfJj@shell.armlinux.org.uk>
 <bc461bd4-e123-212d-42a5-2da2efb7235a@solid-run.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc461bd4-e123-212d-42a5-2da2efb7235a@solid-run.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 12:44:41PM +0300, Josua Mayer wrote:
> Hi Russell,
> 
> Am 09.05.22 um 18:54 schrieb Russell King (Oracle):
> > On Mon, May 09, 2022 at 03:29:38PM +0300, Josua Mayer wrote:
> > I do this on the SolidSense platform with the two LEDs when using it as
> > my internet gateway on the boat - one LED gives wlan status, the other
> > LED gives wwan status, both of them green for link and red for tx/rx
> > activity.
> Ah. And do you put the assignment of the LEDs into an init script?

Yes, I do it from a systemd unit that runs a "platform-leds-init"
script as the easiest way on the SolidSense - since I want one for
wwan0 and the other for wlan0, there is no chance of the names
being swapped.

However, I'm quite sure it's possible to have udev and systemd scripts
that do what is necessary, or poke in sysfs.

I can't remotely power up my Clearfog-CX to see exactly how to do it,
but I am quite sure one can have a script in udev that notices a new
netdev coming along, works out which it is (by looking at
/sys/class/net/$name/device, or more probably some udev variable
that gives you that) and decides which LED should be configured.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
