Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75C61634407
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 19:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234535AbiKVSyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 13:54:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbiKVSyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 13:54:14 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B34F46037F;
        Tue, 22 Nov 2022 10:54:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=b/1Ak3iyuhV5gOFgiGiOz207h7TByUFgfDFxK3JwYHA=; b=WXFFaIBfa4zWFQfoeG9X9PfCFq
        lMz1/cLnBHmLlCgoibrl+VHswJOcfUTqv4dh81ic5Ekyo6WFwLttkkMr42xcZ0m/rvkhlYjqTKz4k
        6Nnfvbs0UfmudMUxR0KYIwsmMCrC5zFyOkAydgTPM7V45M9vUQ9cDJl8AVJ36O4Wceh9bKIkuXq33
        iTQOxkCQhBbW6tzYREWJ7BSE5iJCxYS3+QaP4b3wvkMBTc+50sqDJ4bTfHlcELfW8KWdl5DEDauXj
        VkbuUjuSySS2mvh8J+kDScAcaaDZbk5o3fDzHIaPZ7izoQgTuwy1iVO/fg+BaWa8Pz4AAbdsS7PGc
        EQCNlUkw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35392)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oxYPD-0001vN-At; Tue, 22 Nov 2022 18:54:03 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oxYPA-0003X1-8T; Tue, 22 Nov 2022 18:54:00 +0000
Date:   Tue, 22 Nov 2022 18:54:00 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     "Goh, Wei Sheng" <wei.sheng.goh@intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Wei Feng <weifeng.voon@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        Ahmad Tarmizi Noor Azura <noor.azura.ahmad.tarmizi@intel.com>,
        Looi Hong Aun <hong.aun.looi@intel.com>
Subject: Re: [PATCH net v2] net: stmmac: Set MAC's flow control register to
 reflect current settings
Message-ID: <Y30ayCTyVpjjyEzh@shell.armlinux.org.uk>
References: <20221122063935.6741-1-wei.sheng.goh@intel.com>
 <Y30XoUHXscGSMHaL@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y30XoUHXscGSMHaL@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 06:40:33PM +0000, Russell King (Oracle) wrote:
> On Tue, Nov 22, 2022 at 02:39:35PM +0800, Goh, Wei Sheng wrote:
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
> > index c25bfecb4a2d..369db308b1dd 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
> > @@ -748,6 +748,9 @@ static void dwmac4_flow_ctrl(struct mac_device_info *hw, unsigned int duplex,
> >  	if (fc & FLOW_RX) {
> >  		pr_debug("\tReceive Flow-Control ON\n");
> >  		flow |= GMAC_RX_FLOW_CTRL_RFE;
> > +	} else {
> > +		pr_debug("\tReceive Flow-Control OFF\n");
> > +		flow &= ~GMAC_RX_FLOW_CTRL_RFE;
> >  	}
> >  	writel(flow, ioaddr + GMAC_RX_FLOW_CTRL);
> 
> This doesn't look correct to me. The function starts off:
> 
>         unsigned int flow = 0;
> 
> flow is not written to before the context above. So, the code you've
> added effectively does:
> 
> 	flow = 0 & ~GMAC_RX_FLOW_CTRL_RFE;
> 
> which is still zero. So, I don't think this hunk is meaningful apart
> from adding the pr_debug().

It also should be noted that it looks like:

dwxgmac2_core.c::dwxgmac2_flow_ctrl() is definitely buggy - it will
only set flow control, never clearing it.

dwmac100_core.c::dwmac100_flow_ctrl() looks potentially buggy - always
enabling flow control irrespective of anything.

The other two implmentations look sane to me.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
