Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 656CA4EF645
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 17:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348662AbiDAPcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 11:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349377AbiDAOzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:55:23 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0308E25E9E;
        Fri,  1 Apr 2022 07:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=b2CiO4L5LMsTPjyVGlh+eoZTqAHsqAzbmA0VJTGYz9o=; b=o6BUqL3qcos1U48U8sIZkxD6OH
        YW8IGXnQorGS207zezKy4MeXATgJB4mmk/Z2/4hON2iGNgaBvIQqnMXHOp5QWoaI6LY8FMnh9fnYk
        UrCSXHdy7RFQ1wxLt9GGZRWC0vKxHO/5LFF6DsGHA4uAI6pEOZkj4Wf/DDXdFu+JAwbq3GIqpKQIl
        ul9BhwQ7ZuYl1fYhKTqHQKd9NApdCXPq+HwZU/uL8QdWrt1PImgbni7qrmxbrhdjcp4GuKniKZUnB
        kAZ2Xb12OAQsWelmi73rYWpDAobSOHKhLItkhIxrRseDl3ygyokyVxhGXuT9nwWKU5db1gm9HjvgE
        Avu36DhA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58082)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1naIUs-0006GG-6f; Fri, 01 Apr 2022 15:43:29 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1naIUo-0000H1-0J; Fri, 01 Apr 2022 15:43:26 +0100
Date:   Fri, 1 Apr 2022 15:43:25 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, hkallweit1@gmail.com,
        Divya.Koppera@microchip.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net v2 0/3] net: phy: micrel: Remove latencies support
 lan8814
Message-ID: <YkcPja9WxzJ6eU5d@shell.armlinux.org.uk>
References: <20220401110522.3418258-1-horatiu.vultur@microchip.com>
 <Ykb2yoXHib6l9gkT@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ykb2yoXHib6l9gkT@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 01, 2022 at 02:57:46PM +0200, Andrew Lunn wrote:
> On Fri, Apr 01, 2022 at 01:05:19PM +0200, Horatiu Vultur wrote:
> > Remove the latencies support both from the PHY driver and from the DT.
> > The IP already has some default latencies values which can be used to get
> > decent results. It has the following values(defined in ns):
> > rx-1000mbit: 429
> > tx-1000mbit: 201
> > rx-100mbit:  2346
> > tx-100mbit:  705
> 
> So one alternative option here is that ptp4l looks at
> 
> /sys/class/net/<ifname>/phydev/phy_id

That doesn't work for Clause 45 PHYs, only Clause 22 PHYs. If we want
userspace to know which PHY it is, we need a proper interface that
exports all the 31 Clause 45 IDs (each mmd's registers 2/3) as well, as
well as the Clause 45 package ID (registers 14/15).

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
