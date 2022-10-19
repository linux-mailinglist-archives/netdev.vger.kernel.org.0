Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D42D604544
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 14:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbiJSM3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 08:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232885AbiJSM2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 08:28:54 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC1511A975;
        Wed, 19 Oct 2022 05:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=vGBsCUqFwWa+5hhW0zeEah/ZUEjsYfdXFEhqLjTbsNA=; b=BlLx6D56pzr5wjMcKu3HON//TV
        vfdQxAJ+JZLnPNKTt4sAUEBpDVQw8rOxaANkDlyM4m1EijklbdUR06/pBCX3I9sRhwfabIsHiTbzN
        VMstuVifqL7rbwnMC83dtXsjDpK+JAy6gINl6Fmn7oHFZ55vLg1kdEv/eYC4FZQrcYbGWmNFW2GlM
        J41OsYnW4a3NBRCJIIHPvtX/Uh29mi28rgUgtUL3drKaxIcCuZXNjujJNbQmMYChTR05drz1raQYu
        GS8YQvLkf/3iCSc97x6KWQeBz2RSpIEqV5ihrJP684qIKyx3BNRM5/G3gzPjq+FNk/aqqjPnLd+vv
        CEr+xVCw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34800)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ol7lX-0005cV-UB; Wed, 19 Oct 2022 13:01:43 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ol7lX-00028O-Aq; Wed, 19 Oct 2022 13:01:43 +0100
Date:   Wed, 19 Oct 2022 13:01:43 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sergiu Moga <sergiu.moga@microchip.com>
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: macb: Specify PHY PM management done by MAC
Message-ID: <Y0/nJ+gtYoPQ5WNH@shell.armlinux.org.uk>
References: <20221019095548.57650-1-sergiu.moga@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019095548.57650-1-sergiu.moga@microchip.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 19, 2022 at 12:55:50PM +0300, Sergiu Moga wrote:
> The `macb_resume`/`macb_suspend` methods already call the
> `phylink_start`/`phylink_stop` methods during their execution so
> explicitly say that the PM of the PHY is done by MAC by using the
> `mac_managed_pm` flag of the `struct phylink_config`.
> 
> This also fixes the warning message issued during resume:
> WARNING: CPU: 0 PID: 237 at drivers/net/phy/phy_device.c:323 mdio_bus_phy_resume+0x144/0x148
> 
> Fixes: 744d23c71af3 ("net: phy: Warn about incorrect mdio_bus_phy_resume() state")

Hi,

You also need to mention that this commit depends on 96de900ae78e
in the net tree, which introduced the mac_managed_pm member to
phylink_config.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
