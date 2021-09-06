Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1E424018EC
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 11:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241406AbhIFJf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 05:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241313AbhIFJfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 05:35:55 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 276FAC061575
        for <netdev@vger.kernel.org>; Mon,  6 Sep 2021 02:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=8q9MWlRvr6SEqGQrCCS/NOcI9yCW1ubL7+wy5Msz4e8=; b=ylimq8MikyKJ9Yh6XDkmFpB+Mo
        AoolMQ0RpEDR9PvnJ4aEEHuIVamhs2jj7ne6dRRsuMOQAmeQA6VOBGCsd3oki68lKg5r0seWQgMJR
        gptPoTQcwZgnWVqLGQRLE8HLTGQEUvdPY+4XGwsj5bscUX4DeOZNdvctx7LqEpkYvXfgCVOqyDvZR
        ofARGiS+Idd1pGmwAUYEs4kGR4PHuORpTugaWQ0yk/BV3Pi8WaLuRocjoTaAaIytgrkRWiEJleWCx
        8XdmooFVa4U6BWYvmjS5zcUTBMd/QZIlKgOdpAC7Jl6OJuwLwXkhor4HqE+aRqfJua2NlqhqHo8dY
        jjHLGOnw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44972)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mNB1R-0001WM-Vk; Mon, 06 Sep 2021 10:34:36 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mNB1M-0003AI-O1; Mon, 06 Sep 2021 10:34:32 +0100
Date:   Mon, 6 Sep 2021 10:34:32 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] net: stmmac: fix MAC not working when system resume back
 with WoL enabled
Message-ID: <YTXgqBRMRvYdPyJU@shell.armlinux.org.uk>
References: <DB8PR04MB6795C37D718096E7CA1AA72DE6CE9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YTDCZN/WKlv9BsNG@lunn.ch>
 <DB8PR04MB6795C36B8211EE1A1C0280D9E6CF9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210903080147.GS22278@shell.armlinux.org.uk>
 <DB8PR04MB679518228AB7B2C5CD47A1B3E6CF9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210903093246.GT22278@shell.armlinux.org.uk>
 <DB8PR04MB6795EE2FA03451AB5D73EFC3E6CF9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210903120127.GW22278@shell.armlinux.org.uk>
 <20210903201210.GF1350@shell.armlinux.org.uk>
 <DB8PR04MB6795FC58C1D0E2481E2BC35EE6D29@DB8PR04MB6795.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB8PR04MB6795FC58C1D0E2481E2BC35EE6D29@DB8PR04MB6795.eurprd04.prod.outlook.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Sep 06, 2021 at 02:29:30AM +0000, Joakim Zhang wrote:
> Hi Russell,
> 
> > -----Original Message-----
> > +		/* Re-apply the link parameters so that all the settings get
> > +		 * restored to the MAC.
> > +		 */
> > +		phylink_mac_initial_config(pl, true);
> > +		phylink_enable_and_run_resolve(pl, PHYLINK_DISABLE_MAC_WOL);
> 
> There is no "phylink_enable_and_run_resolve " sysbol, I guess you want do below operations in this function:
> 	clear_bit(PHYLINK_DISABLE_MAC_WOL, &pl->phylink_disable_state);
> 	phylink_run_resolve(pl);

Yes, that is correct.

Please let me know whether that works for you.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
