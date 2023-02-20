Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD9469D0E6
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 16:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbjBTPsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 10:48:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbjBTPse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 10:48:34 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04BBF9777;
        Mon, 20 Feb 2023 07:48:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=j979/jnqOKJv/aCxvtQ0oIXMpVKFVWTUMZr7MywJfdc=; b=hXFIGo01c8wJzdIjNfUWB0tv74
        PN6IUwJ/k7VNtHrZNhs3lE7iJpyI1QwuODey0+42krY9ypoSp8fMDXu6I9ZjEfSqG8aWrx4hnU0oG
        L6VuGGMezQEOfgKPgFcPO+F4zprE+yH0GhgA0alYWQ7GrQBTotOGIm59Kl8zndCQJ/J0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pU8Ow-005WO6-NA; Mon, 20 Feb 2023 16:48:26 +0100
Date:   Mon, 20 Feb 2023 16:48:26 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 3/4] net: phy: do not force EEE support
Message-ID: <Y/OWSjQ0m65fF5dk@lunn.ch>
References: <20230220135605.1136137-1-o.rempel@pengutronix.de>
 <20230220135605.1136137-4-o.rempel@pengutronix.de>
 <Y/OB9oeEn98y0u4o@shell.armlinux.org.uk>
 <20230220150720.GA19238@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220150720.GA19238@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hm.. ethtool do not provide enough information about expected behavior.
> Here is my expectation:
> - "ethtool --set-eee lan1 eee on" should enable EEE if it is disabled.
> - "ethtool --set-eee lan1 advertise 0x10" should change set of
>   advertised modes.
> - a sequence of "..advertise 0x10", "..eee on", "eee off" should restore
>   preconfigured advertise modes. advertising_eee instead of
>   supported_eee.

I agree ethtool is not very well documented. However, i would follow
what -s does. You can pass link modes you want to advertise, and you
can turn auto-neg on and off. Does turning auto-neg off and on again
reset the links modes which are advertised? I don't actually know, but
i think the behaviour should be consistent for link modes and EEE
modes.

	Andrew
