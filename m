Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 443EC3E9976
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 22:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232027AbhHKUOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 16:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231983AbhHKUOn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 16:14:43 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 163DDC0613D3;
        Wed, 11 Aug 2021 13:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=DxXYmFyCedGjNLebnBkN8LwcOkYVcNvOV6z+Sc6qpk4=; b=WsC2HfFE29tY6CIwnLVvhoDay
        sCJQ3Kn52B8XpXqa/B56Hp2OC+c4q1bJUr1wK9xpFp41mbmdoOtJmX+LPJxlWlTnYhztsWls147RE
        KhyYmBfEHy1j40+28t3XUfqRGAIomA1RcfETieCCHSMr2dGVByKTPBRW5c5H4RK5b2ZPTHxmqv2tu
        km3hEck2cWj/4ztQfXywxjTwFWM5ZWROsAPArv0RBN5IT1PK99P/bxIZHe7QoJ+FNNJjF0g7pJ8bd
        T4w0TTVcY4VLp3EUUJ+vcWraZAZHiFxJr4SI8Oiw9VjbKj8udShRLVpIPjRhqKQTbnsVbDp03ZTEl
        s4LD4IBhw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47196)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mDucC-00016i-30; Wed, 11 Aug 2021 21:14:16 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mDucA-0003S4-Gm; Wed, 11 Aug 2021 21:14:14 +0100
Date:   Wed, 11 Aug 2021 21:14:14 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        robh+dt@kernel.org, UNGLinuxDriver@microchip.com,
        Woojung.Huh@microchip.com, hkallweit1@gmail.com,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v3 net-next 05/10] net: dsa: microchip: add DSA support
 for microchip lan937x
Message-ID: <20210811201414.GX22278@shell.armlinux.org.uk>
References: <20210802121550.gqgbipqdvp5x76ii@skbuf>
 <YQfvXTEbyYFMLH5u@lunn.ch>
 <20210802135911.inpu6khavvwsfjsp@skbuf>
 <50eb24a1e407b651eda7aeeff26d82d3805a6a41.camel@microchip.com>
 <20210803235401.rctfylazg47cjah5@skbuf>
 <20210804095954.GN22278@shell.armlinux.org.uk>
 <20210804104625.d2qw3gr7algzppz5@skbuf>
 <YQ6pc6EZRLftmRh3@lunn.ch>
 <20191b895a56e2a29f7fee8063d9cc0900f55bfe.camel@microchip.com>
 <YRQViFYGsoG3OUCc@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRQViFYGsoG3OUCc@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 11, 2021 at 08:23:04PM +0200, Andrew Lunn wrote:
> > I hope that using "*-internal-delay-ps" for Mac would be the right option.
> > Shall i include these changes as we discussed in next revision of the patch? 
> 
> Yes, that seems sensible. But please limit them to the CPU port. Maybe
> return -EINVAL for other ports.

Hmm. Don't we want ports that are "MAC like" to behave "MAC like" ?
In other words, shouldn't a DSA port that can be connected to an
external PHY should accept the same properties as a conventional
Ethernet MAC e.g. in a SoC device?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
