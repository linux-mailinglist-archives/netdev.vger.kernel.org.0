Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 251995FA215
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 18:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiJJQn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 12:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiJJQn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 12:43:27 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A2CE6DFA2;
        Mon, 10 Oct 2022 09:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=cGEQmAa8ji6opcjFIYfT1uk+V/cyOC7gsmXvKvJSS/E=; b=Ms2m7gABBRShFZYFT08LjwGRcb
        wz48iA3GsfiiooqEY5jwTxP1Na/X+8/4xw8EkoRm8Sjfnq6cob4RqCk80weLS3AOy/wnqOxgPg7lf
        AaRb20y0HKFivWHXH4gO+uDAvCnDec/7P1DNb4P8Eje1k12u66QUnqG+0ivzFk6bFJnlK4sqET34b
        mxIctOB52ruTkbsoezvOVMx2sO8Wl5kiSDOz1g/T1wK0xYd9jfdTZZcqbZiMNNPSIgrEVkENzKjz5
        XC2mxihjuJ5cdeKfvTHVuUJ1TIbootCoRfo/8oD7p3A7FDiESvml4IHxET9W0GBZAPvtQHzd+rn9k
        lPklXtvA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34674)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ohvs0-0004u8-UT; Mon, 10 Oct 2022 17:43:12 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ohvrv-00020K-HH; Mon, 10 Oct 2022 17:43:07 +0100
Date:   Mon, 10 Oct 2022 17:43:07 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Soha Jin <soha@lohu.info>, Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mdiobus: add fwnode_phy_is_fixed_link()
Message-ID: <Y0RLm0qU8MwGt40d@shell.armlinux.org.uk>
References: <20221009162006.1289-1-soha@lohu.info>
 <Y0Q0P4MlTXmzkJSG@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0Q0P4MlTXmzkJSG@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 10, 2022 at 05:03:27PM +0200, Andrew Lunn wrote:
> On Mon, Oct 10, 2022 at 12:20:06AM +0800, Soha Jin wrote:
> > A helper function to check if PHY is fixed link with fwnode properties.
> > This is similar to of_phy_is_fixed_link.
> 
> You need to include a user of this new function.
> 
> Also, not that ACPI only defines the 'new binding' for fixed-link.  If
> this is being called on a device which is ACPI underneath, it should
> only return true for the 'new binding', not the old binding.

Do we want to support the "managed" property in the fwnode variant,
or persuade people to switch to phylink if they want that?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
