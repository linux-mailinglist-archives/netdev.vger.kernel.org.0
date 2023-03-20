Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44B836C0D34
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 10:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbjCTJZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 05:25:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbjCTJZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 05:25:19 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CDFB234EE;
        Mon, 20 Mar 2023 02:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=V4Ic3CoIN3yLEDl4ZrFprKL8VDhfVNu/6xK0WkJsbGg=; b=oFFZpgYrVUmjwZ9Psb6fMcDoII
        PI37y50wljwMMECGXJBNlGVGnBH150XU3raIqtWeWfSHWTRUNDDV/xTBg8B+ieE/448kN7u4cGQP4
        GFWgPa65zXsK4aY32W2XigRxPBZQXm1KHfcSTXQBuLOQmzgUG2EKHrIR4Eatq3wRZw8no1FvuJFC6
        GVajieQ5ejInjjkF92+q/ARLpPWGxp4bUszPu+K3tOINhEXJs0ALVq2jjRHwupUJPoV+cn/60Gc+r
        n6oI+GnJSxAjpTJDt0+ybaGTrIaZrGc7Vv50y4hevmxuK/vqermAZmgo448gxAWl+mAuRtQ+1iNEQ
        nrNG4Qzw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34076)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1peBl4-00075E-Af; Mon, 20 Mar 2023 09:24:50 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1peBl0-0006P2-5A; Mon, 20 Mar 2023 09:24:46 +0000
Date:   Mon, 20 Mar 2023 09:24:46 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vinod Koul <vkoul@kernel.org>
Cc:     Colin Foster <colin.foster@in-advantage.com>,
        linux-phy@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee@kernel.org>
Subject: Re: [PATCH v2 net-next 1/9] phy: phy-ocelot-serdes: add ability to
 be used in a non-syscon configuration
Message-ID: <ZBgmXplfA/Q3/1dC@shell.armlinux.org.uk>
References: <20230317185415.2000564-1-colin.foster@in-advantage.com>
 <20230317185415.2000564-2-colin.foster@in-advantage.com>
 <ZBgeKM50e1vt+ho1@matsya>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBgeKM50e1vt+ho1@matsya>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 02:19:44PM +0530, Vinod Koul wrote:
> On 17-03-23, 11:54, Colin Foster wrote:
> > The phy-ocelot-serdes module has exclusively been used in a syscon setup,
> > from an internal CPU. The addition of external control of ocelot switches
> > via an existing MFD implementation means that syscon is no longer the only
> > interface that phy-ocelot-serdes will see.
> > 
> > In the MFD configuration, an IORESOURCE_REG resource will exist for the
> > device. Utilize this resource to be able to function in both syscon and
> > non-syscon configurations.
> 
> Applied to phy/next, thanks

Please read the netdev FAQ. Patches sent to netdev contain the tree that
the submitter wishes the patches to be applied to.

As a result, I see davem has just picked up the *entire* series which
means that all patches are in net-next now. net-next is immutable.

In any case, IMHO if this kind of fly-by cherry-picking from patch
series is intended, it should be mentioned during review to give a
chance for other maintainers to respond and give feedback. Not all
submitters will know how individual maintainers work. Not all
maintainers know how other maintainers work.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
