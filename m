Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9877B4F821A
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 16:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344227AbiDGOvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 10:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238003AbiDGOvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 10:51:01 -0400
Received: from pandora.armlinux.org.uk (unknown [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 492F7C4E14
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 07:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=r0zup9NDI7jXFxp/JVXxLT/8LZu/OSf3lefpjk6QeR8=; b=Bv9WkOnL24l9G6v1zJ169lwqO6
        WVocmiELgUDsBaGf5HPVkVyGoCjF7GOKlXZqaj0lxr0smNeoFjMgSKLnO+SO8KVWioliSfbrGwcQy
        0MPzjJ3+mYRg5Fep2GV0FnOhWUDqQOIfk9rugOFJ41aDN/x/NCKoPqh9RBxhbZ0cPuciBkdVCrYZj
        SMc6AkWgg3aU6DXx1xu24kEi6rvEi0YAfXbAJSTrlT/K9bBPs0M0umjwBV6Wm9qMl5Qb9F4ZJ3ZnN
        aU67xsFoUjbpAcg7gL1oQbeOQiul4MTu8Ekq5WdMlHvw+BhbVc4Uk0aye8VJBWheR8A29SEnJJcZz
        XiW2jTEw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58160)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ncTPn-0004jh-Uu; Thu, 07 Apr 2022 15:47:15 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ncTPi-0006An-DY; Thu, 07 Apr 2022 15:47:10 +0100
Date:   Thu, 7 Apr 2022 15:47:10 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net-next 5/9] net: dsa: mt7530: only indicate linkmodes
 that can be supported
Message-ID: <Yk75boz1dIWy5jhn@shell.armlinux.org.uk>
References: <Yk1iHCy4fqvxsvu0@shell.armlinux.org.uk>
 <E1nc3Dd-004hq7-Co@rmk-PC.armlinux.org.uk>
 <20220406115250.047570c1@kernel.org>
 <20220406223443.193b0ce1@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220406223443.193b0ce1@thinkpad>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RDNS_NONE,SPF_HELO_NONE,
        T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 06, 2022 at 10:34:43PM +0200, Marek Behún wrote:
> On Wed, 6 Apr 2022 11:52:50 -0700
> Jakub Kicinski <kuba@kernel.org> wrote:
> 
> > On Wed, 06 Apr 2022 11:48:57 +0100 Russell King (Oracle) wrote:
> > > -	if (state->interface != PHY_INTERFACE_MODE_MII) {
> > > +	if (state->interface != PHY_INTERFACE_MODE_MII &&
> > > +	    state->interface != PHY_INTERFACE_MODE_2500BASEX)
> > >  		phylink_set(mask, 1000baseT_Full);
> > >  		phylink_set(mask, 1000baseX_Full);
> > >  	}  
> > 
> > Missing { here. Dunno if kbuild bot told you already.
> 
> Probably not, because next patch removes this code entirely :)

kbuild bot normally does catch these if I've missed them locally, but
I find the bot is very very sporadic. Thanks for spotting it.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
