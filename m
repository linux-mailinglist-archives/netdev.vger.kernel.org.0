Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE8A75F6E27
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 21:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbiJFTYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 15:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbiJFTYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 15:24:33 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76013FF224
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 12:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=y6tf/FtjgfbCe9jqIXN3yx9CuCEhSGqRMK4/HanfozY=; b=lqxq1Z9Zy6D93E27E2fIh6BGPl
        MX2TbVZsdokgzOvfxSadudG5S9ON8nTlFszf4P4Az/eNfDAl3eJqcwB/Mvkg5Q0QE7PL33TACcGO+
        8Ta51IiaFIZ1JYaqR+pC+KEZYC3wk47LuQX7aJwC3rKhIDtJXAKByNAtZDN16/vWEt+82CLidZUeW
        HNjn+VczAgLPUfa6RoTqUpm6Y0Y5bBb/cC3k25NLtLod7+2v7NrpITdbcxoO0+kVsSlmEHQjoLG9D
        EJlD3D8u/oZ/Wu0R961wijh4sOQQNb1uhtCmkS6Waglkc+5g5CPAl/B6JtuaLKcaDMSVdSffkKCCW
        X9TQlidQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34612)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ogWTe-0001sV-3e; Thu, 06 Oct 2022 20:24:14 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ogWTa-0006YI-Fv; Thu, 06 Oct 2022 20:24:10 +0100
Date:   Thu, 6 Oct 2022 20:24:10 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Shenwei Wang <shenwei.wang@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        imx@lists.linux.dev
Subject: Re: [PATCH 1/1] net: phylink: add phylink_set_mac_pm() helper
Message-ID: <Yz8rWoYlF8sjbkBz@shell.armlinux.org.uk>
References: <20221006170237.784639-1-shenwei.wang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221006170237.784639-1-shenwei.wang@nxp.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 06, 2022 at 12:02:37PM -0500, Shenwei Wang wrote:
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index e9d62f9598f9..a741c4bb5dd5 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -1722,6 +1722,15 @@ void phylink_stop(struct phylink *pl)
>  }
>  EXPORT_SYMBOL_GPL(phylink_stop);
>  
> +void phylink_set_mac_pm(struct phylink *pl)

This needs documenting. The documentation for the function needs to
mention when this should be called - so users are guided towards
calling it at the right place in their drivers, rather than leaving
them trying to figure it out and possibly get it wrong.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
