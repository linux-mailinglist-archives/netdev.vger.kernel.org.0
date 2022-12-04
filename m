Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B335A641E40
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 18:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbiLDRgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 12:36:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbiLDRgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 12:36:23 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D84A514098;
        Sun,  4 Dec 2022 09:36:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=goCKq7mAuByd5SSoRQGXzt0RnvurUSfN5w+L4Gwa7R4=; b=BTDGf0ap+wRBoIiQRHnNB6t325
        BH7iuUtPxiJjY4Q6rgoiPEEvX7Pfw0U6k+eQzNz1/qCabG+di2a16fp/nOGb/FpNGd5wR3nTYa7XL
        FTyIcnTisvIBOPJSJjjwk5MWNYHSb/cfS2UX5myzFYExc/X/uMSOd8cltbJEwoMg6EJM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p1suL-004Kfz-2v; Sun, 04 Dec 2022 18:36:05 +0100
Date:   Sun, 4 Dec 2022 18:36:05 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH net-next 4/4] driver/ncn26000: add PLCA support
Message-ID: <Y4zahWebzRhun2IP@lunn.ch>
References: <cover.1670119328.git.piergiorgio.beruto@gmail.com>
 <38623984f6235a1521e6b0ad2ea958abc84ad708.1670119328.git.piergiorgio.beruto@gmail.com>
 <Y4zTqvSxLJG+G8V+@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4zTqvSxLJG+G8V+@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> It also seems odd to have this "positive numbers mean update" thing
> when every other ethtool API just programs whatever is passed. It seems
> to be a different API theory to the rest of the ethtool established
> principle that if one wishes to modify, one calls the _GET followed
> by a _SET. This applies throughout this function.

Hi Russell

That was my idea. This is a netlink only API, which gives some
flexibility which the old ioctl interface did not. With netlink
attributes, we can pass only the attributes we want to change.

The question then is, what is the interface between the netlink code
and the PHY driver. How do you express what attributes were in the
request? I suggested -1 for not present.

We could keep with the old read/modify/write model, but then we are
not making use of what netlink actually offers.

    Andrew
