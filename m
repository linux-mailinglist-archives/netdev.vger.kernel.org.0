Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63CDE1E646E
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 16:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391247AbgE1Os0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 10:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391239AbgE1OsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 10:48:19 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E35D2C08C5C6;
        Thu, 28 May 2020 07:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=J3qtwoPGVq2JnofuWBUzY3t5O++ntiuaSHaA9oo7zgE=; b=i6tISO3cy0Rn3AIZnYcCDlqr2
        NCV3DZV1tHZzrztGy8KpdbGlyyTGMPQfHuG4VjdJtPkLcbWYVklV333UL5/u8OagVtmC5BpegHIjh
        jEfjmy6SkJgf6P4q/LtHeNz0WiX8+Imv1CrbXYEofjaLFoarRo87EvstIEUi2gWg5zzw7fQfJhXI9
        q31nGg6eBCzcFJljEFCfMMXegiKgNip9Tz3DXTlKQT2POkPVKHlzZEu69vfwq2Nhsoc7aipnkSBdh
        P+aeNKMNoRcT3E0MDOuAEO0gDb7OHJ5qGQPRavseqRgovuGhA4ByFUihR4wNT9j+JApVYEyvKdR4j
        ULn5ZNVFA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:38164)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jeJpJ-0005dJ-Gk; Thu, 28 May 2020 15:48:09 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jeJpF-0007Z6-Qp; Thu, 28 May 2020 15:48:05 +0100
Date:   Thu, 28 May 2020 15:48:05 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: mvpp2: Enable autoneg bypass for
 1000BaseX/2500BaseX ports
Message-ID: <20200528144805.GW1551@shell.armlinux.org.uk>
References: <20200528121121.125189-1-tbogendoerfer@suse.de>
 <20200528130738.GT1551@shell.armlinux.org.uk>
 <20200528151733.f1bc2fcdcb312b19b2919be9@suse.de>
 <20200528135608.GU1551@shell.armlinux.org.uk>
 <20200528163335.8f730b5a3ddc8cd9beab367f@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200528163335.8f730b5a3ddc8cd9beab367f@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 28, 2020 at 04:33:35PM +0200, Thomas Bogendoerfer wrote:
> below is the dts part for the two network interfaces. The switch to
> the outside has two ports, which correlate to the two internal ports.
> And the switch propagates the link state of the external ports to
> the internal ports.

Okay, so this DTS hasn't been reviewed...

> &cp0_eth1 {
>         status = "okay";
>         phy-mode = "2500base-x";
>         mac-address = [00 00 00 00 00 01];
>         interrupts = <41 IRQ_TYPE_LEVEL_HIGH>,
>         <45 IRQ_TYPE_LEVEL_HIGH>,
>         <49 IRQ_TYPE_LEVEL_HIGH>,
>         <53 IRQ_TYPE_LEVEL_HIGH>,
>         <57 IRQ_TYPE_LEVEL_HIGH>,
>         <61 IRQ_TYPE_LEVEL_HIGH>,
>         <65 IRQ_TYPE_LEVEL_HIGH>,
>         <69 IRQ_TYPE_LEVEL_HIGH>,
>         <73 IRQ_TYPE_LEVEL_HIGH>,
>         <127 IRQ_TYPE_LEVEL_HIGH>;
>         interrupt-names = "hif0", "hif1", "hif2",
>         "hif3", "hif4", "hif5", "hif6", "hif7",
>         "hif8", "link";
>         port-id = <2>;
>         gop-port-id = <3>;

This seems to correlate with the eth2 node in armada-cp11x.dtsi -
you do not need to specify the interrupts, interrupt-names, port-id
and gop-port-id unless you need to change them just because you want
to add a few properties to this node - you can just list the new or
altered properties.  To delete a property, you need to prefix the
property name with /delete-property/.

>         managed = "in-band-status";

This isn't correct - you are requesting that in-band status is used
(i.o.w. the in-band control word, see commit 4cba5c210365), but your
bug report wants to enable AN bypass because there is no in-band
control word.  This seems to be rather contradictory.

May I suggest you use a fixed-link here, which will not have any
inband status, as there is no in-band control word being sent by
the switch?  That is also the conventional way of handling switch
links.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
