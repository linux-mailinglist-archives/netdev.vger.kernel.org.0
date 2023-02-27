Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7936A4862
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 18:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbjB0Rny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 12:43:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjB0Rnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 12:43:53 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0FB023C7E
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 09:43:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=9eFoOKfsx+kTr/KIEl73PWNXgzkaSAVw1B9A+htcQQo=; b=b64PqcveTkDQqPEZRFvIhHO2RH
        TIuDTsnOLVFLlH/C+xc8cFEp4Gssj2W4NGjTNqBzsrDE47swCLdixeZYdSiYrMgpi7yojosYlOzUh
        ToKe/hl59dlVALON4ekDOoOLZv5sxt0sLzPIFas4KGwuSZ2aNFWz94hD0Dq8mMozvNP5BBiIjnmmI
        YEYpdccDumw9a7Ija7Pzl6LtShMjP5IGIbJ1hp/IDFdinxqegH6bjXWd+UTonsaVK5mRR7oP5qZKJ
        aZnFK3VZ7OV4GVzBQCTF5eIbkaSHcjqpea7VLKvWAG3+Ndf0QIaL5NUw6xRR4s7hHsv/0y/4aKCom
        uzmog5AA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:42068)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pWhWN-0003PB-2L; Mon, 27 Feb 2023 17:42:43 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pWhWK-0001qy-E1; Mon, 27 Feb 2023 17:42:40 +0000
Date:   Mon, 27 Feb 2023 17:42:40 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     =?iso-8859-1?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>
Cc:     andrew@lunn.ch, davem@davemloft.net, f.fainelli@gmail.com,
        hkallweit1@gmail.com, kuba@kernel.org, netdev@vger.kernel.org,
        richardcochran@gmail.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
 [multicast/DSA issues]
Message-ID: <Y/zrkOumKQ5DVY8L@shell.armlinux.org.uk>
References: <20200730124730.GY1605@shell.armlinux.org.uk>
 <20230227154037.7c775d4c@kmaincent-XPS-13-7390>
 <Y/zKJUHUhEgXjKFG@shell.armlinux.org.uk>
 <20230227183013.177b10e5@kmaincent-XPS-13-7390>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230227183013.177b10e5@kmaincent-XPS-13-7390>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 27, 2023 at 06:30:13PM +0100, Köry Maincent wrote:
> On Mon, 27 Feb 2023 15:20:05 +0000
> "Russell King (Oracle)" <linux@armlinux.org.uk> wrote:
> 
> > > I see this patch has been abandoned.
> > > I am testing it with a ZynqMP board (macb ethernet) and it seems to more or
> > > less work. It got tx timestamp timeout at initialization but after some
> > > times (~20 seconds) ptp4l manages to set it working. Also the IEEE 802.3
> > > network PTP mode is not working, it constantly throw rx timestamp overrun
> > > errors.
> > > I will aim at fixing these issues and adding support to interrupts. It
> > > would be good to have it accepted mainline. What do you think is missing
> > > for that?  
> > 
> > It isn't formally abandoned, but is permanently on-hold as merging
> > Marvell PHY PTP support into mainline _will_ regress the superior PTP
> > support on the Macchiatobin platform for the reasons outlined in:
> > 
> > https://lore.kernel.org/netdev/20200729220748.GW1605@shell.armlinux.org.uk/
> > 
> > Attempting to fix this problem was basically rejected by the PTP
> > maintainer, and thus we're at a deadlock over the issue, and Marvell
> > PHY PTP support can never be merged into mainline.
> 
> As I understand, if the PHY support PTP, it is prioritize to the PTP of the MAC.
> As quote in the mail thread it seems there was discussion in netdev about
> moving phy_has_hwtstamp to core and allowing ethtool to choose which one to
> use. I don't know if the decision have been made about it since, but it seems
> nothing has been sent to mainline. Meanwhile, why do we not move forward on
> this patch with the current PTP behavior and updates it when new core PTP change
> will be sent mailine?

Clearly, we have an issue with communication. Let me repeat:

Merging support for Marvell PHY PTP *will* *regress* the Macchiatobin
platform, making PTP *unusable* because *some* API calls will go to
the *PHY* PTP instance while *other* API calls go to the *MAC* PTP
instance.

Since merging Marvell PHY PTP support will cause a regression, the only
way to fix that regression at the moment is by reverting the merge of
Marvell PHY PTP support as there is no acceptable solution to the above
problem - I've attempted to fix it and the patch was rejected.

Sorry, but no, mainline does not get Marvell PHY PTP support before
the generic code is fixed for this blocking issue.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
