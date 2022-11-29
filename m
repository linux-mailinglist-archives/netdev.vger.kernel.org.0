Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 495D363C169
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 14:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233410AbiK2Nqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 08:46:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232290AbiK2Nqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 08:46:35 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB941D323;
        Tue, 29 Nov 2022 05:46:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=saaWpGLYU8xiJ3I0G6KU/+DLub8YoICcLaj63am14tE=; b=qzBAol75w7QuGpPfsILLYl/mkx
        xykuV1WD5YnzuJYDm7A57iAoUbyuXU2+dmM7oRTqkKcpfKJg7j6Qzx9Ntgc7Hy8mgNi39C06ji5d6
        2HUbURHg70zHjdRRpD4PYarzejUzuiR7ceC138atayIgrCCXkgsHq7KjSwH/nPB6snz9meyDQaHwB
        LnBbNG707I6eqEjy00tO57xDyfAo/LTX9DxhKaYlcoTpsPhfbI2asV78sG+CrQSV37IwAzrYZQSnq
        0eoUHBbeqdsuzEhidcGHmDX/yyOvc6pAi0n1tlnCUbNQ3PVZtpk6yq3nkd49oiyvywktlW+1d5pW3
        a2A+HUww==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35478)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p00wR-0000kQ-5W; Tue, 29 Nov 2022 13:46:31 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p00wP-0001b0-Kj; Tue, 29 Nov 2022 13:46:29 +0000
Date:   Tue, 29 Nov 2022 13:46:29 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Sean Anderson <sean.anderson@seco.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Tim Harvey <tharvey@gateworks.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net v2 2/2] phy: aquantia: Determine rate adaptation
 support from registers
Message-ID: <Y4YNNb+05iEZhZfp@shell.armlinux.org.uk>
References: <20221128195409.100873-1-sean.anderson@seco.com>
 <20221128195409.100873-2-sean.anderson@seco.com>
 <Y4VCz2i+kkK0z+XY@shell.armlinux.org.uk>
 <b25b1d9b-35dd-a645-a5f4-05eb0dbc6039@seco.com>
 <Y4YLryZE6TXCCTbH@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4YLryZE6TXCCTbH@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 29, 2022 at 02:39:59PM +0100, Andrew Lunn wrote:
> > >> This commit should not get backported until it soaks in master for a
> > >> while.
> > > 
> > > You will have to monitor the emails from stable to achieve that - as you
> > > have a Fixes tag, that will trigger it to be picked up fairly quicky.
> > 
> > I know; this is a rather vain attempt :)
> > 
> > If I had not added the fixes tag, someone would have asked me to add it.
> 
> Hi Sean
> 
> If you had put a comment under the --- that you deliberately did not
> add a Fixes tag because you wanted it to soak for a while, you
> probably would not be asked.
> 
> I think the bot also looks at the subject to decide if it is a fix. So
> you need to word the subject so it sounds like continuing development,
> not a fix.

Sasha makes use of Google's AI. I believe it looks at the entire patch
and commit message, and can make some really strange decisions.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
