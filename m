Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A510B22E35D
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 01:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbgGZXtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 19:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726730AbgGZXtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 19:49:06 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E3F8C0619D2
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 16:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=V+ni9toS0qtTzpjW+RmVhfIZ1PFpI327luJuFq60QM8=; b=KhpW88tpIHMuMZLKOR+Zf+3uz
        ycVyothCkP7eu+nkRDOi6aanbvoKg2Ib8B0EZimJQC5zByQemECAKYseigLL01WeuRoIEkamOxEID
        fdIt6qDupItET1GhyJEuL8NkTTfxKf2j3iQPdcLAGVKVVJ7wi2fqLcoa+k7MYlbT4KL0rZtbjjIL1
        LFm/Y80rkIrBQRotAKWieobVFZmQWaaHJ+YSkjWLQ6HpTkPH+cmF0tgkWZtFrAOV3Bnm91BNULA7Q
        3TnAlH+ej+cgREeWJgBFC+0PAJuuNxosYPeDca4EsQI1RvCmYoJsnwKYzk2K/EiEqNdaZ3MP9p9DK
        NzQpl/bfQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44576)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jzqO3-00023B-Hu; Mon, 27 Jul 2020 00:48:59 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jzqO0-00035C-VV; Mon, 27 Jul 2020 00:48:56 +0100
Date:   Mon, 27 Jul 2020 00:48:56 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
Message-ID: <20200726234856.GG1551@shell.armlinux.org.uk>
References: <E1jvNlE-0001Y0-47@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1jvNlE-0001Y0-47@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 14, 2020 at 05:26:28PM +0100, Russell King wrote:
> The driver takes inspiration from the Marvell 88E6xxx DSA and DP83640
> drivers.  The hardware is very similar to the implementation found in
> the 88E6xxx DSA driver, but the access methods are very different,
> although it may be possible to create a library that both can use
> along with accessor functions.

I think this definitely needs to become a library - I've just been
looking at mvneta in Armada 388.  One of the three interfaces has
PTP support, and it looks like the register set is again very
similar to the 88E151x and 88E6xxx PTP/TAI register layouts, but
has yet another different access method.

We certainly don't want three copies of almost identical code...

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
