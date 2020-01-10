Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E54E0137471
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 18:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbgAJRIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 12:08:41 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:44772 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbgAJRIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 12:08:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=stvLoiYvkibWT2EGKNia6lubfLem4pZoHH11UsqgU4s=; b=ALANy2D/4A7f7CFgzysPgD7e+
        DDXSb7jxVoydDBsnmIKxv9dwkHkX8kNsUGDuuJtI3K5hHSGHeI9p9Ou79FwP/6IQNqWk/s6847iTV
        GKvkXlMJDljtfZzf7YFgF4w+G9Zaoc9zOeFs4U6QwWWbho6BrwVsNLW7LkpX9c1Cnp67kEWg9Fzat
        d6RfD1xGhH7fINeK7oF0qQ5yKAsZ82bomrH2ZxFA/J9mMf2WmB4VEj0q4E0folEczQflOHg9d6hdl
        3u/izX/CRG/j409rFmxmpEfpyAsWxBtp9MnlI/OA0jISC7Qxd0O1zZBXpRmWUmGmyUEgadpUN/tks
        qCnZi5g2Q==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:53176)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ipxm1-0004Or-8f; Fri, 10 Jan 2020 17:08:37 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ipxm0-0001fp-8v; Fri, 10 Jan 2020 17:08:36 +0000
Date:   Fri, 10 Jan 2020 17:08:36 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     =?utf-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: [drivers/net/phy/sfp] intermittent failure in state machine
 checks
Message-ID: <20200110170836.GI25745@shell.armlinux.org.uk>
References: <20200110092700.GX25745@shell.armlinux.org.uk>
 <18687669-e6f5-79f1-6cf9-d62d65f195db@gmx.net>
 <20200110114433.GZ25745@shell.armlinux.org.uk>
 <7b6f143a-7bdb-90be-00f6-9e81e21bde4e@gmx.net>
 <20200110125305.GB25745@shell.armlinux.org.uk>
 <b4b94498-5011-1e89-db54-04916f8ef846@gmx.net>
 <20200110150955.GE25745@shell.armlinux.org.uk>
 <e9a99276-c09d-fa8d-a280-fca2abac6602@gmx.net>
 <20200110163235.GG25745@shell.armlinux.org.uk>
 <717229a4-f7f6-837d-3d58-756b516a8605@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <717229a4-f7f6-837d-3d58-756b516a8605@gmx.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 10, 2020 at 04:53:06PM +0000, ѽ҉ᶬḳ℠ wrote:
> Seems that the debug avenue has been exhausted, short of running SFP.C in
> debug mode.

You're saying you never see TX_FAULT asserted other than when the
interface is down?

> There is still no explanation why the module passes the 300 ms deassert
> TX_FAULT test most of the time but fails intermittently at other times,
> being kind of incoherent. Maybe it is just wishful thinking but it seems a
> bit far-fetched that the module is really causing this, least the readings
> from GPIO do not provide any such indicator.
> 
> Could there be something choking / blocking the communication channel
> between the module and the kernel, some kernel code getting stuck / leaked
> in memory?

There is no "communication channel" involved here.  It is just those
GPIOs.

> Could the ipupdown routine, which has its own implementation in OpenWrt, be
> an interfering agent, e.g. the way it constructs or tears down the iif,
> though I do not see how?

Very unlikely.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
