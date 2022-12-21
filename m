Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 313816530B3
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 13:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbiLUMVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 07:21:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiLUMVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 07:21:00 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA1F2A3
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 04:20:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6PlkvH/CRzBNLPL0LQFiLXXLBym4MHvTaB9y8F8HcR0=; b=hEv23qw5mz+cYnduCjNeL59l2K
        HZk666CPlpvUl3g02a+cxXrfIa3OM5xm1XV8jyXW2/6Oij1AjxS0RHJ9dAFSrXiW6h1JJ0hzZIiZA
        4wmww3OTd+yP+T96CHlwpMRHPCPfWQgO0Ix8Epg3NL8L8aLd01jBO/GkoSrPSprFW8M5kLNtzD6kF
        hpBFJ5DV2oAaoZyfF/op1wgNJS+YrxQ12jMX08HOXR4ToS0Ad3FIIAV7SJx0B8C90TrsFTdP9Y7qr
        Zp+7To5dlNkxD1j90bHltWobLP7zg0STjuotiKRtcd49MuogX1uymyGMTQw+hqLOWMZ+4Vk8UsuEq
        HApxZ7eQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35802)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p7y5W-0000aj-J0; Wed, 21 Dec 2022 12:20:46 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p7y5T-0006XK-M5; Wed, 21 Dec 2022 12:20:43 +0000
Date:   Wed, 21 Dec 2022 12:20:43 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Liang Xu <lxu@maxlinear.com>
Cc:     Michael Walle <michael@walle.cc>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        Hauke Mehrtens <hmehrtens@maxlinear.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Thomas Mohren <tmohren@maxlinear.com>
Subject: Re: [PATCH] net: phy: enhance Maxlinear GPY loopback disable function
Message-ID: <Y6L6G3bPVony+B5X@shell.armlinux.org.uk>
References: <20221214082924.54990-1-lxu@maxlinear.com>
 <20221214090037.383118-1-michael@walle.cc>
 <PH7PR19MB56130FA71635455AE9DB8524BDE09@PH7PR19MB5613.namprd19.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH7PR19MB56130FA71635455AE9DB8524BDE09@PH7PR19MB5613.namprd19.prod.outlook.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Dec 14, 2022 at 09:16:46AM +0000, Liang Xu wrote:
> From: Michael Walle <michael@walle.cc>
> Sent: Wednesday, December 14, 2022 5:00 PM
> Subject: Re: [PATCH] net: phy: enhance Maxlinear GPY loopback disable function
> 
> This email was sent from outside of MaxLinear.
> 
> 
> Subject is missing the correct target, "net" in this case.
> 
> > GPY need 3 seconds to switch out of loopback mode.
> 
> What does that mean, what goes wrong with the current 100ms?
> Could you elaborate a bit more and update the commit message
> and the comment? Is this true for any GPY PHY supported by
> this driver?
> 
> The internal state machine need almost 3s to fully restore to original state when leaving the loopback mode.
> This is true for all models supported by this driver.
> I will update the commit message and fix the target.
> Thank you.

When you state that it takes almost 3 seconds to fully restore the
state, what are you basing that upon - what are you using to determine
that the state has been fully restored?

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
