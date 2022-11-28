Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58F4B63A33D
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 09:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbiK1IkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 03:40:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbiK1IkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 03:40:02 -0500
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [IPv6:2001:4b98:dc4:8::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D1317052;
        Mon, 28 Nov 2022 00:40:00 -0800 (PST)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id A8E04240015;
        Mon, 28 Nov 2022 08:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1669624799;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s1BQQ9G+xK7IXAGECc06dmEoJcmIhpgzMPmtbolzDto=;
        b=eNQbHacYgXkAjec52BZTg4E67IqRzzpnEGpGZ6N57ZgtjOGb4jKrcn1bFkqMroUAyouT13
        mjG+z325B0qRVkQMkwyP2ZfpJwXj7vHVZF0tCB527pT6I8x3FRjsrFTqG9q1aIQ0Sb74KP
        6hGTf5r368Cd8TJSKD1rfVDGHJJno+8f7NNiV/E8ojAWXzLX5UhkETw6AbvOona328IESj
        bj9XWeJDI5BIO1qKBZyzNanr9jSOVXcKwg6XM84GS0Qg2M7ujiHupcp9Mucvz9yHcLd3Gu
        ru0VVP0sLNdEdLFBsyXtKzwc3hx5QGHJwE4Vl/2YYbmqj/0DAkX7oLXXrDCmaQ==
Date:   Mon, 28 Nov 2022 09:39:56 +0100
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] net: pcs: altera-tse: simplify and
 clean-up the driver
Message-ID: <20221128093956.19067242@pc-8.home>
In-Reply-To: <Y4Ofvemx5AnWJHrp@shell.armlinux.org.uk>
References: <20221125131801.64234-1-maxime.chevallier@bootlin.com>
        <Y4Ofvemx5AnWJHrp@shell.armlinux.org.uk>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Russell,

On Sun, 27 Nov 2022 17:34:53 +0000
"Russell King (Oracle)" <linux@armlinux.org.uk> wrote:

> On Fri, Nov 25, 2022 at 02:17:58PM +0100, Maxime Chevallier wrote:
> > Hello everyone,
> > 
> > This small series does a bit of code cleanup in the altera TSE pcs
> > driver, removong unused register definitions, handling 1000BaseX
> > speed configuration correctly according to the datasheet, and
> > making use of proper poll_timeout helpers.
> > 
> > No functional change is introduced.
> > 
> > Best regards,
> > 
> > Maxime
> > 
> > Maxime Chevallier (3):
> >   net: pcs: altera-tse: use read_poll_timeout to wait for reset
> >   net: pcs: altera-tse: don't set the speed for 1000BaseX
> >   net: pcs: altera-tse: remove unnecessary register definitions  
> 
> Hi Maxime,
> 
> Please can you check the link timer settings:
> 
>         /* Set link timer to 1.6ms, as per the MegaCore Function User
> Guide */ tse_pcs_write(tse_pcs, SGMII_PCS_LINK_TIMER_0, 0x0D40);
>         tse_pcs_write(tse_pcs, SGMII_PCS_LINK_TIMER_1, 0x03);
> 
> This is true for Cisco SGMII mode - which is specified to use a 1.6ms
> link timer, but 1000baseX is specified by 802.3 to use a 10ms link
> timer interval, so this is technically incorrect for 1000base-X. So,
> if the MegaCore Function User Guide specifies 1.6ms for everything, it
> would appear to contradict 802.3.
> 
> From what I gather from the above, the link timer uses a value of
> 200000 for 1.6ms, which means it is using a 8ns clock period or
> 125MHz.
> 
> If you wish to correct the link timer, you can use this:
> 
> 	int link_timer;
> 
> 	link_timer = phylink_get_link_timer_ns(interface) / 8;
> 	if (link_timer > 0) {
> 		tse_pcs_write(tse_pcs, SGMII_PCS_LINK_TIMER_0,
> link_timer); tse_pcs_write(tse_pcs, SGMII_PCS_LINK_TIMER_1,
> link_timer >> 16); }
> 
> so that it gets set correctly depending on 'interface'.
> phylink_get_link_timer_ns() is an inline static function, so you
> should end up with the above fairly optimised, not that it really
> matters. Also worth documenting that the "8" there is 125MHz in
> nanoseconds - maybe in a similar way to pcs-lynx does.

Ouh that's perfect, thanks !

> It does look like this Altera TSE PCS is very similar to pcs-lynx,
> maybe there's a possibility of refactoring both drivers to share
> code?

Indeed, I've some patches I'm testing to port pcs-lynx to regmap then
do the merge. The one thing that would differ is the reset
handling in the TSE driver, since we need to perform it at every
configuration change basically. But that's not worth having duplicate
drivers just for that, I agree.

I'll post that merge when I'll have the chance to give it a more
thourough test.

Thanks,

Maxime

