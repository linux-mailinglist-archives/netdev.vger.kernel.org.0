Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0516C9D97
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 10:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232759AbjC0IWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 04:22:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232388AbjC0IWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 04:22:34 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D86A1FC2
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 01:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Q4BAetJ4z5ZMgiUsic01Mx8xbfb8mUgxzin8jXm+HXs=; b=Xeg1VdOhzJKLOnk8nF4PtqnkCM
        lFuS1dnrO4iuxWW3ftiFA7YA3NHbofzaYxXmgdl8eqRWYbNdhoJHjuCM6Nz/j+n6cTOmLAmU2Nc7J
        uXqsrdB98OP0AtbT4ZZrodUuPvHy/bbug7EoAQCB2q9tjgh8xgl75AucgLwotlk975G+Y8mhtYCAY
        8aVkT2Uk+xKFgfXwoEUzWkqQEOMVcNSjlvAFuTlwdJ1mpAloUvFCI6lut+UhQy+9y3VUNLiZFJHXj
        /RcJnGrA3QOuHksEwL42ZpAQDY3M6L13DhBAuntbJUvX/HsgcI2kd+2S0IXkiPehSZpInvm7yvY5s
        YqXq5JEw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54322)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pgi7Y-0003F7-71; Mon, 27 Mar 2023 09:22:28 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pgi7W-0005G3-39; Mon, 27 Mar 2023 09:22:26 +0100
Date:   Mon, 27 Mar 2023 09:22:26 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     davem@davemloft.net
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, edumazet@google.com,
        kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PATCH RESEND net-next 0/3] Constify a few sfp/phy fwnodes
Message-ID: <ZCFSQlt4tbT2aYT4@shell.armlinux.org.uk>
References: <ZB1sBYQnqWbGoasq@shell.armlinux.org.uk>
 <167990161807.4487.6574989274256507257.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167990161807.4487.6574989274256507257.git-patchwork-notify@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

I notice you merged this to the net tree rather than the net-next tree
which was in the subject tag. Was there a reason for applying it to
the net tree?

Thanks.

On Mon, Mar 27, 2023 at 07:20:18AM +0000, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This series was applied to netdev/net.git (main)
> by David S. Miller <davem@davemloft.net>:
> 
> On Fri, 24 Mar 2023 09:23:17 +0000 you wrote:
> > Hi,
> > 
> > This series constifies a bunch of fwnode_handle pointers that are only
> > used to refer to but not modify the contents of the fwnode structures.
> > 
> >  drivers/net/phy/phy_device.c | 2 +-
> >  drivers/net/phy/sfp-bus.c    | 6 +++---
> >  include/linux/phy.h          | 2 +-
> >  include/linux/sfp.h          | 5 +++--
> >  4 files changed, 8 insertions(+), 7 deletions(-)
> 
> Here is the summary with links:
>   - [net-next,1/3] net: sfp: make sfp_bus_find_fwnode() take a const fwnode
>     https://git.kernel.org/netdev/net/c/a90ac762d345
>   - [net-next,2/3] net: sfp: constify sfp-bus internal fwnode uses
>     https://git.kernel.org/netdev/net/c/850a8d2dc712
>   - [net-next,3/3] net: phy: constify fwnode_get_phy_node() fwnode argument
>     https://git.kernel.org/netdev/net/c/4a0faa02d419
> 
> You are awesome, thank you!
> -- 
> Deet-doot-dot, I am a bot.
> https://korg.docs.kernel.org/patchwork/pwbot.html
> 
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
