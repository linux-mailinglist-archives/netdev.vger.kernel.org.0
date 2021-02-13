Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 440DC31AD50
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 18:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbhBMRJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 12:09:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbhBMRJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 12:09:56 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12485C061574
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 09:09:16 -0800 (PST)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id E846223E55;
        Sat, 13 Feb 2021 18:09:13 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1613236154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ruLsXruq+1n54dxiJkFH0gu4KJF0IzAd7heuiQT1iwM=;
        b=E5GwWbv1ArisVJfIgD+o0rVaSabICYavLHrWA1Rfj/iqqaT3/ZZt7W0uJ2K7np6TjXJ2y4
        /vC8ENp9EoB9jtXgsALk47Vw5OXhaBr0jeTOFJI9YdLRoIM93hZLaAlk0kvamThhkKMcxa
        i7RcohrdPJLGgqn1/rEFSJBZa/Ud7Zg=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sat, 13 Feb 2021 18:09:13 +0100
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Quentin Schulz <quentin.schulz@bootlin.com>,
        netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 1/2] net: phylink: explicitly configure in-band
 autoneg for PHYs that support it
In-Reply-To: <46c9b91b8f99605a26fbd7f26d5947b6@walle.cc>
References: <20210212172341.3489046-1-olteanv@gmail.com>
 <20210212172341.3489046-2-olteanv@gmail.com>
 <eb7b911f4fe008e1412058f219623ee2@walle.cc>
 <20210213003641.gybb6gstjpkcwr6z@skbuf>
 <46c9b91b8f99605a26fbd7f26d5947b6@walle.cc>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <1d90da5ef82f27942c7f5a5d844fc29a@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2021-02-13 17:53, schrieb Michael Walle:
> Am 2021-02-13 01:36, schrieb Vladimir Oltean:
> But the Atheros PHY seems to have a problem with the SGMII link
> if there is no autoneg.
> No matter what I do, I can't get any traffic though if its not
> gigabit on the copper side. Unfortunately, I don't have access
> to an oscilloscope right now to see whats going on on the SGMII
> link.

Scrap that. It will work if I set the speed/duplex mode in BMCR
correctly. (I tried that before, but I shifted one bit. doh).

So that will work, but when will it be done? There is no
callback to configure the PCS side of the PHY if a link up is
detected.

-michael
