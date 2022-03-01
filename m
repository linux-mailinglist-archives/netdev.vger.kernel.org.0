Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD44B4C7F0D
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 01:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbiCAAP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 19:15:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbiCAAP0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 19:15:26 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBFC513F2E;
        Mon, 28 Feb 2022 16:14:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=jHhhXdYvdwbERT2LG1xSfD5WhTW4Le242Y9B4XkNvMc=; b=xIYZtIP3LfKmvTwJ7lKDXdJQP+
        NYarX7erluU6lSzaEJcwjUB8EN7FPIof6PZMXiXJVMLFyhp0vAefyVs4PGTMrPdvdEfADEn8DUS0/
        H2/achkGrugQ5zEHuYtyHtOU2BirkHOeDeAb5/TiRlupuCZNqzCqWFTke/f5ThdxBvSY7Ft+cttGL
        WJvRt5U/IkfhtS2sYkiAbheh/I1IHI41vCWUtjSzMYHAqIsMSyKZXCDNxjEW4Y18myxSh6tuqvwJn
        13Wfi8YU6LSnM656UJ08SW2oW/VJyxI1bSOdx7Ccr5p64+etsBcJM3CGFJTYqmMmqI1fOKKIIrwzI
        rpHdhpLA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57568)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nOqA4-0000aE-Ev; Tue, 01 Mar 2022 00:14:40 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nOqA2-0006cU-H3; Tue, 01 Mar 2022 00:14:38 +0000
Date:   Tue, 1 Mar 2022 00:14:38 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Peter Geis <pgwipeout@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-rockchip@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] net: phy: fix motorcomm module automatic loading
Message-ID: <Yh1lboz7VDiuYuZV@shell.armlinux.org.uk>
References: <20220228233057.1140817-1-pgwipeout@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220228233057.1140817-1-pgwipeout@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 28, 2022 at 06:30:57PM -0500, Peter Geis wrote:
> The sentinel compatible entry whitespace causes automatic module loading
> to fail with certain userspace utilities. Fix this by removing the
> whitespace and sentinel comment, which is unnecessary.

Umm. How does it fail?

>  static const struct mdio_device_id __maybe_unused motorcomm_tbl[] = {
>  	{ PHY_ID_MATCH_EXACT(PHY_ID_YT8511) },
> -	{ /* sentinal */ }
> +	{}

These two should be 100% identical in terms of the object code produced,
and thus should have no bearing on the ability for the module to be
loaded.

Have you investigated the differences in the produced object code?
If not, please do so, and describe what they were. Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
