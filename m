Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B27C5F9A0A
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 09:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232476AbiJJHee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 03:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232266AbiJJHeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 03:34:03 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8942A6B65E;
        Mon, 10 Oct 2022 00:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=WwgOMWAzXD/YI4ziLOVuq4l+Sn17hFLD5aAJ2dPvhaM=; b=T3yOx5I5Zyd2h/FoYKrYMtDFZZ
        j8TTRxnAPVnHD6GNg1yXSZ0llSeBrb3mdrvkGBtG03DGnV7AXzOdm6dUdicQt38Bmy+94Wuf+t4xX
        PU8XrTa8z97do4HIvmGgK9HE0rvluLF2GsW72fXR6GfJmR+q6KLBKwhF5MDo1KzbTftOH9Nq5BeKj
        S/ypBWCs4wDdIgdNUm4oMTA2sPs5sLsVjsvqJzndb3jBL0tp8LNyacAj8ILuJdiNtht6iJnMIElzJ
        GLn0nfR3Z4nG6dpcbtrG30DFYVK2mzckQboP+o/YFR2GUrQXOt33sU7xUsgtzFx0xkqTawpA6ybUu
        KVVRaBug==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34656)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ohn67-0004Mb-5j; Mon, 10 Oct 2022 08:21:11 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ohn66-0001gA-0V; Mon, 10 Oct 2022 08:21:10 +0100
Date:   Mon, 10 Oct 2022 08:21:09 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, andrew@lunn.ch,
        hkallweit1@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.0 52/77] net: sfp: re-implement soft state
 polling setup
Message-ID: <Y0PH5fFyViE2qrrG@shell.armlinux.org.uk>
References: <20221009220754.1214186-1-sashal@kernel.org>
 <20221009220754.1214186-52-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221009220754.1214186-52-sashal@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 09, 2022 at 06:07:29PM -0400, Sasha Levin wrote:
> From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
> 
> [ Upstream commit 8475c4b70b040f9d8cbc308100f2c4d865f810b3 ]
> 
> Re-implement the decision making for soft state polling. Instead of
> generating the soft state mask in sfp_soft_start_poll() by looking at
> which GPIOs are available, record their availability in
> sfp_sm_mod_probe() in sfp->state_hw_mask.
> 
> This will then allow us to clear bits in sfp->state_hw_mask in module
> specific quirks when the hardware signals should not be used, thereby
> allowing us to switch to using the software state polling.

NAK.

There is absolutely no point in stable picking up this commit. On its
own, it doesn't do anything beneficial. It isn't a fix for anything.
It isn't stable material.

If you picked up the next two patches in the series, there would be a
point to it - introducing support for the HALNy GPON SFP module, but
as you didn't these three patches on their own are entirely pointless.

I don't see why "net: sfp: move Alcatel Lucent 3FE46541AA fixup" was
selected but not "net: sfp: move Huawei MA5671A fixup". I'm guessing
this is just another illustration why the "AI" you use to select
patches doesn't warrant "inteligence".

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
