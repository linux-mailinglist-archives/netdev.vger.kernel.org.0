Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC2D6A0704
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 12:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233934AbjBWLG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 06:06:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233883AbjBWLG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 06:06:26 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B95253EC7;
        Thu, 23 Feb 2023 03:06:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=UrlychQoRbSfgh80gi+2XZK8/268XFVHwKj39NwBSs8=; b=xUa9rmvZLYJ2m3P6qnhKpcwW2L
        6pE/p2VJDZW6BPcpyR8NPTO0wmUSIn5YbLDMPxJyzxyRO9zjIPipXyq+Z/3QrRUXJ0+Ae1jaylVrE
        mr/d/pwzRleSFeSq31MvfYGSQH+WtM1SpxCgxHXRTPm2T6lpxnGQBFPaoW8Id/0fUZsu32dMETN1O
        aWHSqvnh6KuveNx54cZMYS+0AwTylcOt6Gb/rlVcqaDOJFUygwR9ur+kOIS4Ozi0t/BHq7jU7PTjP
        pAMqVb747gtccCfKrhftWyYu3qVNTzJXBh8Y2v4dchdG6SIODvLYrwJidZraOhfFpiR/n/cOBWNvq
        7OxI7dhg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45996)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pV9QT-0007wk-5f; Thu, 23 Feb 2023 11:06:13 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pV9QO-00047N-G4; Thu, 23 Feb 2023 11:06:08 +0000
Date:   Thu, 23 Feb 2023 11:06:08 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Clark Wang <xiaoning.wang@nxp.com>,
        =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH V3 1/2] net: phylink: add a function to resume phy alone
 to fix resume issue with WoL enabled
Message-ID: <Y/dIoAqWfazh9k6F@shell.armlinux.org.uk>
References: <20230202081559.3553637-1-xiaoning.wang@nxp.com>
 <83a8fb89ac7a69d08c9ea1422dade301dcc87297.camel@redhat.com>
 <Y/c+MQtgtKFDjEZF@shell.armlinux.org.uk>
 <HE1PR0402MB2939A09FD54E72C80C19A467F3AB9@HE1PR0402MB2939.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <HE1PR0402MB2939A09FD54E72C80C19A467F3AB9@HE1PR0402MB2939.eurprd04.prod.outlook.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 23, 2023 at 10:27:06AM +0000, Clark Wang wrote:
> Hi Russel,
> 
> I have sent the V4 patch set yesterday.
> You can check it from: https://lore.kernel.org/linux-arm-kernel/20230222092636.1984847-2-xiaoning.wang@nxp.com/T/
> 

Ah yes, sent while net-next is closed.

Have you had any contact with Clément Léger ? If not, please can you
reach out to Clément, because he has virtually the same problem. I
don't want to end up with a load of different fixes in the mainline
kernel for the same "we need the PHY clock enabled on stmmac" problem
from different people.

Please try to come up with one patch set between you both to fix this.

(effectively, that's a temporary NAK on your series.)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
