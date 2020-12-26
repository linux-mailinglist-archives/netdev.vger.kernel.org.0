Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 217412E2F47
	for <lists+netdev@lfdr.de>; Sat, 26 Dec 2020 23:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbgLZW2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Dec 2020 17:28:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725986AbgLZW2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Dec 2020 17:28:38 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD23C0613C1
        for <netdev@vger.kernel.org>; Sat, 26 Dec 2020 14:27:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=t6QnT0fO9YPaSbnw8Fo1vB8CQDAjMp3+i2/ZDbmweNo=; b=yOPnEfyfkXe2dyyUyvuqFZ6tn
        qhzWIc6iN4LYzA52otj8XfbwbP2/6jDAuIn1o4ZGamejVWv8NVGxWt+KzqHnjMp7QfGRjeqXIT19I
        ZD9KlGms98JYr2rlVzK8IGnt72G7BFFvgoDmjZ6XO1H4fTRxr3utIumWH7V9so1vMkgDq7C97iMTK
        dsk5KwfTwLsUyWwTMMH5eT5dwgvsPr71PMI5+GHbpj9XJ4ehR6Lt4gt3uJDizTkn5x2p7CtK7ryMW
        JMcdqzQDatkUFOrM4TxOJ3Ss2gC95oG5xh/hjdL4oBasFGvlX2tgfrcxnVlTna6gQ4kvMVflgfyUL
        yQVCSpwhw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44550)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ktI2G-0003dm-Vt; Sat, 26 Dec 2020 22:27:41 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ktI2G-0007Av-HN; Sat, 26 Dec 2020 22:27:40 +0000
Date:   Sat, 26 Dec 2020 22:27:40 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Hamza Mahfooz <someguy@effective-light.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: Re: Fwd: Solidrun ClearFog Base and Huawei MA5671A SFP
Message-ID: <20201226222740.GE1551@shell.armlinux.org.uk>
References: <GXUYLQ.NU2JKDF3FRP51@effective-light.com>
 <8394f1c8-0b27-c1aa-37d4-77d65bdccade@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8394f1c8-0b27-c1aa-37d4-77d65bdccade@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry, this will not work. The MA5671A modules are configured to use
dying gasp on pin 7, and pin 7 is grounded on the Armada 388 Clearfog
platforms, resulting in the module not booting.

I'm sorry, I can't recommend a module; I don't use SFP GPON modules
myself.

On Sat, Dec 26, 2020 at 11:15:18PM +0100, Heiner Kallweit wrote:
> Sounds like something where you may be able to help.
> 
> Heiner
> 
> -------- Forwarded Message --------
> Subject: Solidrun ClearFog Base and Huawei MA5671A SFP
> Date: Sat, 26 Dec 2020 16:41:40 -0500
> From: Hamza Mahfooz <someguy@effective-light.com>
> To: netdev@vger.kernel.org
> 
> Hey, has anyone got the ClearFog (ARMADA 388 SoC) to work with the 
> MA5671A? I've to been trying to get the ClearFog to read the MA5671A's 
> EEPROM however it always throws the following error:
> 
> > # dmesg | grep sfp
> > [ 4.550651] sfp sfp: Host maximum power 2.0W
> > [ 5.875047] sfp sfp: please wait, module slow to respond
> > [ 61.295045] sfp sfp: failed to read EEPROM: -6
> 
> I've tried to increase the retry timeout in `/drivers/net/phy/sfp.c` 
> (i.e. T_PROBE_RETRY_SLOW) so far, any suggestions would be appreciated. 
> Also, I'm on kernel version 5.9.13.
> 
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
