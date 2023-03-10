Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1315A6B3F1F
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 13:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbjCJM0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 07:26:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjCJM0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 07:26:13 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BECE77E03;
        Fri, 10 Mar 2023 04:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=fQbnxGWIn7ewdJdpt4RNhPAsOmwBkoOJSG1XRnEXKRI=; b=RuqTzG9KdOS2vfZfAG6lwaJrBX
        YPHZFs3t6frx5tV7NFLUj/vqeexDNyTUquvui2zQKfnJ7rKpDb92DsmkqGaqJqAVM2DNuGLyZ2T/i
        uJhTe7RKhqXB94xojv2KHCscJmURv44XLaOAMKKH9ks/SYR4bGHRFbXbFpyaHQQ9qIajoH5XIGkcD
        EgXeJRal/OI8lxa8NPK5w+MiOupN0Z4xvGhuoJy+hgK1xvpl6HuVMa6luC9gHDgbnQOemU4ZHVbyC
        szC/Rbh4yQENbIHM0vJDdlWTZ/Me0HH3ePqEYVQwpXlD9Lo5NAkolM2t90tA4uRv3ldnAsgNR8PcE
        vfZyQmPA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52538)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pabov-0006ej-5B; Fri, 10 Mar 2023 12:26:01 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pabot-0004gP-Qy; Fri, 10 Mar 2023 12:25:59 +0000
Date:   Fri, 10 Mar 2023 12:25:59 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Lukasz Majewski <lukma@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] dsa: marvell: Provide per device information about
 max frame size
Message-ID: <ZAsh12DdwDfKUW8F@shell.armlinux.org.uk>
References: <20230309125421.3900962-1-lukma@denx.de>
 <20230309125421.3900962-2-lukma@denx.de>
 <20230310120235.2cjxauvqxyei45li@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310120235.2cjxauvqxyei45li@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 02:02:35PM +0200, Vladimir Oltean wrote:
> By ops:
> 
> port_set_jumbo_size:
> static const struct mv88e6xxx_ops mv88e6131_ops = {
> static const struct mv88e6xxx_ops mv88e6141_ops = {
> static const struct mv88e6xxx_ops mv88e6171_ops = {
> static const struct mv88e6xxx_ops mv88e6172_ops = {
> static const struct mv88e6xxx_ops mv88e6175_ops = {
> static const struct mv88e6xxx_ops mv88e6176_ops = {
> static const struct mv88e6xxx_ops mv88e6190_ops = {
> static const struct mv88e6xxx_ops mv88e6190x_ops = {
> static const struct mv88e6xxx_ops mv88e6240_ops = {
> static const struct mv88e6xxx_ops mv88e6320_ops = {
> static const struct mv88e6xxx_ops mv88e6321_ops = {
> static const struct mv88e6xxx_ops mv88e6341_ops = {
> static const struct mv88e6xxx_ops mv88e6350_ops = {
> static const struct mv88e6xxx_ops mv88e6351_ops = {
> static const struct mv88e6xxx_ops mv88e6352_ops = {
> static const struct mv88e6xxx_ops mv88e6390_ops = {
> static const struct mv88e6xxx_ops mv88e6390x_ops = {
> static const struct mv88e6xxx_ops mv88e6393x_ops = {
> 
> set_max_frame_size:
> static const struct mv88e6xxx_ops mv88e6085_ops = {
> static const struct mv88e6xxx_ops mv88e6095_ops = {
> static const struct mv88e6xxx_ops mv88e6097_ops = {
> static const struct mv88e6xxx_ops mv88e6123_ops = {
> static const struct mv88e6xxx_ops mv88e6161_ops = {
> static const struct mv88e6xxx_ops mv88e6185_ops = {
> 
> none of the above:
> static const struct mv88e6xxx_ops mv88e6165_ops = {
> static const struct mv88e6xxx_ops mv88e6191_ops = {
> static const struct mv88e6xxx_ops mv88e6250_ops = {
> static const struct mv88e6xxx_ops mv88e6290_ops = {
> 
> 
> By info:
> 
> port_set_jumbo_size (10240):
> 	[MV88E6131] = {
> 	[MV88E6141] = {
> 	[MV88E6171] = {
> 	[MV88E6172] = {
> 	[MV88E6175] = {
> 	[MV88E6176] = {
> 	[MV88E6190] = {
> 	[MV88E6190X] = {
> 	[MV88E6240] = {
> 	[MV88E6320] = {
> 	[MV88E6321] = {
> 	[MV88E6341] = {
> 	[MV88E6350] = {
> 	[MV88E6351] = {
> 	[MV88E6352] = {
> 	[MV88E6390] = {
> 	[MV88E6390X] = {
> 	[MV88E6191X] = {
> 	[MV88E6193X] = {
> 	[MV88E6393X] = {
> 
> set_max_frame_size (1632):
> 	[MV88E6085] = {
> 	[MV88E6095] = {
> 	[MV88E6097] = {
> 	[MV88E6123] = {
> 	[MV88E6161] = {
> 	[MV88E6185] = {
> 
> none of the above (1522):
> 	[MV88E6165] = {
> 	[MV88E6191] = {
> 	[MV88E6220] = {
> 	[MV88E6250] = {
> 	[MV88E6290] = {
> 
> 
> Whereas your analysis seems to have determined this:
> 
> port_set_jumbo_size (10240):
> 	[MV88E6131] = {
> 	[MV88E6141] = {
> 	[MV88E6171] = {
> 	[MV88E6172] = {
> 	[MV88E6175] = {
> 	[MV88E6176] = {
> 	[MV88E6190] = {
> 	[MV88E6240] = {
> 	[MV88E6320] = {
> 	[MV88E6321] = {
> 	[MV88E6341] = {
> 	[MV88E6350] = {
> 	[MV88E6351] = {
> 	[MV88E6352] = {
> 	[MV88E6390] = {
> 	[MV88E6390X] = {
> 	[MV88E6393X] = {
> 
> set_max_frame_size (1632):
> 	[MV88E6095] = {
> 	[MV88E6097] = {
> 	[MV88E6123] = {
> 	[MV88E6161] = {
> 	[MV88E6165] = {
> 	[MV88E6185] = {
> 
> none of the above (1522):
> 	[MV88E6085] = {
> 	[MV88E6190X] = {
> 	[MV88E6191] = {
> 	[MV88E6191X] = {
> 	[MV88E6193X] = {
> 	[MV88E6290] = {
> 
> what's up with these?! (no max_frame_size)
> 	[MV88E6220] = {
> 	[MV88E6250] = {
> 
> 
> So our analysis differs for:
> 
> MV88E6190X (I say 10240, you say 1522)
> MV88E6191X (I say 10240, you say 1522)
> MV88E6193X (I say 10240, you say 1522)
> MV88E6085 (I say 1632, you say 1522)
> MV88E6165 (I say 1522, you say 1632)
> MV88E6220 (I say 1522, not clear what you say)
> MV88E6250 (I say 1522, not clear what you say)
> 
> Double-checking with the code, I believe my analysis to be the correct one...

This is similar analysis to what I did for a previous patch set, and
came to the conclusion that we need code in the driver to validate
that the addition of these values is in fact correct. See my previous
reviews and my recommendations on how to structure these patch sets,
so we as reviewers don't _have_ to go to this level of verification.

> I have also noticed that you have not acted upon my previous review comment:
> https://patchwork.kernel.org/project/netdevbpf/patch/20230106101651.1137755-1-lukma@denx.de/
> 
> | 1522 - 30 = 1492.
> | 
> | I don't believe that there are switches which don't support the standard
> | MTU of 1500 ?!
> | 
> | >  		.port_base_addr = 0x10,
> | >  		.phy_base_addr = 0x0,
> | >  		.global1_addr = 0x1b,
> | 
> | Note that I see this behavior isn't new. But I've simulated it, and it
> | will produce the following messages on probe:
> | 
> | [    7.425752] mscc_felix 0000:00:00.5 swp0 (uninitialized): PHY [0000:00:00.3:10] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
> | [    7.437516] mscc_felix 0000:00:00.5: nonfatal error -34 setting MTU to 1500 on port 0
> | [    7.588585] mscc_felix 0000:00:00.5 swp1 (uninitialized): PHY [0000:00:00.3:11] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
> | [    7.600433] mscc_felix 0000:00:00.5: nonfatal error -34 setting MTU to 1500 on port 1
> | [    7.752613] mscc_felix 0000:00:00.5 swp2 (uninitialized): PHY [0000:00:00.3:12] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
> | [    7.764457] mscc_felix 0000:00:00.5: nonfatal error -34 setting MTU to 1500 on port 2
> | [    7.900771] mscc_felix 0000:00:00.5 swp3 (uninitialized): PHY [0000:00:00.3:13] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
> | [    7.912501] mscc_felix 0000:00:00.5: nonfatal error -34 setting MTU to 1500 on port 3
> | 
> | I wonder, shouldn't we first fix that, and apply this patch set afterwards?
> 
> I guess I will have to fix this now, since you haven't done it.

I'm sorry, but why is this Lukasz's problem to fix? If it's broken today
when using mv88e6xxx with this PHY, and Lukasz doesn't have this PHY,
why does Lukasz have to solve this?

> > +
> > +	/* Max Frame Size.
> > +	 * This value corresponds to the memory allocated in switch internal
> > +	 * memory to store single frame.
> > +	 */
> 
> What is the source of this definition?
> 
> I'm asking because I know of other switches where the internal memory
> allocation scheme has nothing to do with the frame size. Instead, there
> are SRAM cells of fixed and small size (say 60 octets) chained together.

The switch documentation only really talks about maximum frame sizes
that the switch can handle, with a few bits that configure what the
maximum frame size is. We also know how large the SRAM is, but how
the SRAM is allocated to packets is for Marvell engineers to know
and not us mere mortals.

So, the base definition for this is the information provided in the
switch documentation.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
