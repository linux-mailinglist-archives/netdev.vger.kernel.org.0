Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4AE65B8C8B
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 18:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbiINQJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 12:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiINQJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 12:09:41 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62439B1EE;
        Wed, 14 Sep 2022 09:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=QVO1O0z/BVH8CRjnCLTwDu7rIPy+uXeBW2E/ilPBWno=; b=B2/82eOjpp5kGPJ3gicZLvcslo
        QBukfSq7IeJwyf5AQjq/KaReUSxCdVPyl/RSVR7iMZyvhR7Tx5uiB5ylx3fiNB/l7zuHdSklwMXPN
        otNS4cXf1oDLYjcUWh/KTjWmdjBSqv+nkJ1Qw+zuOyByIU6RXsh/CyOggBTGFD64ybklslqYt0CBZ
        EsJmnaHsbi0YtwnmOf4Ak7ypuBaL0M0rH3dzUaebwIXtSB36UIb78RnQV+5kuzXACBChmp4Mv5Ndj
        qofeUadkOAfR8SR5navbrKqDJFymrRWB72YfRhY1Sgm7vhdzf5V+fTG5Kam9kr1TYVI3b3wjccpxJ
        xr7CAeLw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34332)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oYUxA-0004b6-4h; Wed, 14 Sep 2022 17:09:32 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oYUx8-0001nP-JK; Wed, 14 Sep 2022 17:09:30 +0100
Date:   Wed, 14 Sep 2022 17:09:30 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski@linaro.org, krzysztof.kozlowski+dt@linaro.org,
        vladimir.oltean@nxp.com, grygorii.strashko@ti.com, vigneshr@ti.com,
        nsekhar@ti.com, netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kishon@ti.com
Subject: Re: [PATCH 5/8] net: ethernet: ti: am65-cpsw: Add support for
 fixed-link configuration
Message-ID: <YyH8us424n3dyLYT@shell.armlinux.org.uk>
References: <20220914095053.189851-1-s-vadapalli@ti.com>
 <20220914095053.189851-6-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220914095053.189851-6-s-vadapalli@ti.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 14, 2022 at 03:20:50PM +0530, Siddharth Vadapalli wrote:
> Check for fixed-link in am65_cpsw_nuss_mac_config() using struct
> am65_cpsw_slave_data's phy_node property to obtain fwnode. Since
> am65_cpsw_nuss_mac_link_up() is not invoked in fixed-link mode, perform
> the relevant operations in am65_cpsw_nuss_mac_config() itself.

Further to my other comments, you also fail to explain that, when in
fixed-link SGMII mode, you _emulate_ being a PHY - which I deduce
since you are sending the duplex setting and speed settings via the
SGMII control word. Also, as SGMII was invented for a PHY to be able
to communicate the media negotiation resolution to the MAC, SGMII
defines that the PHY fills in the speed and duplex information in
the control word to pass it to the MAC, and the MAC acknowledges this
information. There is no need (and SGMII doesn't permit) the MAC to
advertise what it's doing.

Maybe this needs to be explained in the commit message?

This doesn't have any bearing on the other comments I've made.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
