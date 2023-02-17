Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2485F69ADC3
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 15:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbjBQOSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 09:18:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbjBQOSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 09:18:11 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74489227AC
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 06:17:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=aLJjd7E1tXLn9b9MK2QQfaPoO51k0N0PuY0bc0ibOso=; b=jiuyPHv3n7RZ7exjbiy8MV9I4N
        8w2xyUXsqR9KX4bQo/f+Ml26cpRU9ReyMs1/ajqWHKEqeIPprbUTnXNs7aCXgzU4ZI06Ft1VhVv9A
        H9v5VksMkW+n/CohlQq2jIIUSBVxvSgkByCQSkb6NOfOrtLZFnm5hzAJPiMgledp61lY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pT1YZ-005I8f-W7; Fri, 17 Feb 2023 15:17:47 +0100
Date:   Fri, 17 Feb 2023 15:17:47 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Doug Berger <opendmb@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        UNGLinuxDriver@microchip.com, Byungho An <bh74.an@samsung.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: [PATCH RFC 00/18] Rework MAC drivers EEE support
Message-ID: <Y++Mi4VG+m73V0QX@lunn.ch>
References: <20230217034230.1249661-1-andrew@lunn.ch>
 <Y+9oDrTXCX6xVKSl@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+9oDrTXCX6xVKSl@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This is a very nice cleanup, and removes a bunch of logic from MAC
> drivers into the phylib core code that should result in more
> uniform behaviour across MAC drivers for this feature. Great!
> 
> I'm left wondering about the phylink using drivers, whether we could
> go a little further, because there's also the tx_lpi_enabled flag
> which should also gate whether EEE is enabled at the MAC

tx_lpi_enabled is something which i think needs further cleanup. Most
MAC drivers ignore it. I added support to a couple of drivers, when it
was simple to do. But not all.

I'm actually thinking of moving it into phylib. The MAC driver really
does not need to care. All it needs is eee_active in the adjust_link
callback.

I'm currently undecided if to make such a change as part of this
patchset, or do it as a follow up.

	Andrew
