Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67C792F54AA
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 22:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729216AbhAMVuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 16:50:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729188AbhAMVtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 16:49:00 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48076C061575
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 13:48:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=WdECm1HwAJGSkg+7GeRyi2DuwW7u5IrUxg+EGmgyeBQ=; b=wWboeA9/MqVA6ajhecbsBi9nh
        YiIsybdUncZFRznEEfNFM/NBmf1Sb3NYRypHuugjwwwUNRdbii516roroxrewEMt+VgyCz0VlNNWQ
        O8o+Wco7AxrfyLPeMd2Nrx2VatjkpIzIywePc2ETDoSrQSnozgAgupFXQK+xMBfMe7OlrYnX+u8TK
        WLJuK2pXCYXYixDTjGJFOXs8Up/caQu86XRSu8DVr9+uvWU95wbR0qNY4cnw2VKdORUOeShOLsbgg
        qmN7YgC5VqfHLYMBUbB6LcX9qqmFXJjGi6wb6hIzfjNnxCrCO45BgEUPnUaDcAAMUcM8CUNrxu1tV
        D4NFpMkXg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47600)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kznzk-0001iJ-Ra; Wed, 13 Jan 2021 21:48:00 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kznzk-0007fD-CN; Wed, 13 Jan 2021 21:48:00 +0000
Date:   Wed, 13 Jan 2021 21:48:00 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, olteanv@gmail.com,
        pavana.sharma@digi.com
Subject: Re: mv88e6xxx: 2500base-x inband AN is broken on Amethyst? what to
 do?
Message-ID: <20210113214800.GM1551@shell.armlinux.org.uk>
References: <20210113011823.3e407b31@kernel.org>
 <20210113102849.GG1551@shell.armlinux.org.uk>
 <20210113210839.40bb9446@kernel.org>
 <20210113212125.GJ1551@shell.armlinux.org.uk>
 <20210113223729.33c8bb65@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210113223729.33c8bb65@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 10:37:29PM +0100, Marek Behún wrote:
> On Wed, 13 Jan 2021 21:21:25 +0000
> Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> > One thing that I don't know is whether the GPON SFP ONT modules that
> > use 2500base-x will still function with AN disabled - although I have
> > the modules, it appeared that they both needed a connection to the ONU
> > to switch from 1000base-x to 2500base-x on the host side - and as I
> > don't have an ONU I can test with, I have no way to check their
> > behaviour.
> 
> We have an ISP here in Prague who is willing to lend us some GPON
> ONU devices to get GPON SFP modules work on Turris. I will ask him if he
> has one capable of 2.5g and try to borrow it.

I know the Huawei MA5671A and the Nokia 3FE46541AA are - see the quirks
table in sfp-bus.c ! They come from an ISP on the American continent
who really really wanted these modules to link at 2.5Gbps.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
