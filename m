Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 761E45B5D39
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 17:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbiILPdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 11:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiILPdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 11:33:08 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A167829C81;
        Mon, 12 Sep 2022 08:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=5vF4nOR7okjhrE/WI9Z86whidSR0qc+yOoCcLcC0enw=; b=diSA+9u3Z1hJnF3PkEmLt1Z+Dw
        VULXwWOrkOZhK5gjSrwU0PpzhoDXP4X6wI9cUJ2RZYz2Vn7tESFZkaU5DK2/mHagnUzWQZcrlJP7d
        n/TtjxjLZNoApHSZvkzyXA3cNsoTFSzZC/yknWZpYJ3Cg4LUj/ZqEnd+aRomup6okV1sxxIceIcKd
        ZqHlqpEiZNMounKMwSNU/8tXymmB6hc14gO6RDDu4iBqLCd9LKLvUZUtkKiO1UjtfbcUM6Fn1rc8K
        S4H5uxnIazS9KGT2+TQnM0KDWSHWV2lzmidwF/1eR0w62j7cBD2nhpT+6YAeNsPbtKWbl040vl1Hv
        epiBwP4g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34268)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oXlQl-0001rB-Ts; Mon, 12 Sep 2022 16:33:03 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oXlQh-0008Dq-Pi; Mon, 12 Sep 2022 16:32:59 +0100
Date:   Mon, 12 Sep 2022 16:32:59 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Colin Foster <colin.foster@in-advantage.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>
Subject: Re: [RFC v1 net-next 6/8] net: dsa: felix: populate mac_capabilities
 for all ports
Message-ID: <Yx9RK0bDba4s02qn@shell.armlinux.org.uk>
References: <20220911200244.549029-1-colin.foster@in-advantage.com>
 <20220911200244.549029-7-colin.foster@in-advantage.com>
 <Yx7yZESuK6Jh0Q8X@shell.armlinux.org.uk>
 <20220912101621.ttnsxmjmaor2cd7d@skbuf>
 <20220912114117.l2ufqv5forkpehif@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220912114117.l2ufqv5forkpehif@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 12, 2022 at 11:41:18AM +0000, Vladimir Oltean wrote:
> On Mon, Sep 12, 2022 at 01:16:21PM +0300, Vladimir Oltean wrote:
> > > Therefore, I think you can drop this patch from your series and
> > > you won't see any functional change.
> > 
> > This is true. I am also a bit surprised at Colin's choices to
> > (b) split the work he submitted such that he populates mac_capabilities
> >     but does not make any use of it (not call phylink_generic_validate
> >     from anywhere). We try as much as possible to not leave dead code
> >     behind in the mainline tree, even if future work is intended to
> >     bring it to life. I do understand that this is an RFC so the patches
> >     weren't intended to be applied as is, but it is still confusing to
> >     review a change which, as you've correctly pointed out, has no
> >     effect to the git tree as it stands.
> 
> Ah, I retract this comment; after actually looking at all the patches, I
> do see that in patch 8/8, Colin does call phylink_generic_validate().

Good point, I obviously missed that in the series.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
