Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54F62690EB5
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 17:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbjBIQ5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 11:57:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbjBIQ5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 11:57:53 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 548C464653;
        Thu,  9 Feb 2023 08:57:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Fa/1qusEzE09K3FBJWdI+gcUoNQkNsyNDFJ4M5uwCu8=; b=Gly0qg4M2rlT6xOGDNEegpA8+J
        91TImRIsmqOgvCwT82k5vh1TUtqa9AB+MixFphLnLa8Op6OjcE9G0HDRt7ySCeEu4oJxt3Xml+kK4
        nSBhEjXpu47Fv83yd1+XXxEsr5CFau31oGXsVqHNW7/bsi+YE45uSNSlhkTL4bLsTMaC3J5E4Es6I
        dzNoDMcUffyzOkowkh8BB0s/ViyBF2jBADzt2tagVdK/j+ksn6ODUTSiMd0t1TsIOZg4tauBQ4SoO
        WExO1wud1oDwRy9dqcFkcR8GBBmpYPAvaQF6mW+DyoraYwgE2r7RKM5EJ55D/sAjsMdty56PEeaBN
        THMzcJww==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36486)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pQAEv-0008AW-LC; Thu, 09 Feb 2023 16:57:42 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pQAEs-0004kk-RU; Thu, 09 Feb 2023 16:57:38 +0000
Date:   Thu, 9 Feb 2023 16:57:38 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Clark Wang <xiaoning.wang@nxp.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        andrew@lunn.ch, hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com
Subject: Re: [PATCH V3 1/2] net: phylink: add a function to resume phy alone
 to fix resume issue with WoL enabled
Message-ID: <Y+UmAuVZCoRS5u/s@shell.armlinux.org.uk>
References: <20230202081559.3553637-1-xiaoning.wang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202081559.3553637-1-xiaoning.wang@nxp.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Clark,

Please address Jakub's points and resend with patch 2, thanks. Also,
the subject line should indicate which tree this patch series is
targetting - e.g.

[PATCH net-next v4 1/2] net: phylink: ...

> +/**
> + * phylink_phy_resume() - resume phy alone
> + * @pl: a pointer to a &struct phylink returned from phylink_create()
> + *
> + * In the MAC driver using phylink, if the MAC needs the clock of the phy
> + * when it resumes, can call this function to resume the phy separately.
> + * Then proceed to MAC resume operations.

Please also state that it must only be called prior to calling
phylink_start() in the driver's resume function.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
