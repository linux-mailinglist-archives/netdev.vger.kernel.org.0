Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 230EC6DF74F
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 15:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbjDLNfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 09:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbjDLNfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 09:35:34 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3550B83E8;
        Wed, 12 Apr 2023 06:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=95c8hqCUy1osdLkjPROBeoXrOcZ+996LAq0uwKDBgcY=; b=J0beavLQOXA6yYaoa144vCrYYN
        WuiZH7ZcdY74NmFrQCNwZ1UkCa9KV+DTmh7wXXUeCcsiCU7Jh+AlooZeWYdEm3SymxlYLs2vIsq1z
        Jj0Q4OFfsa0yv7dc9cUQgeDDCRrX9V5pRM5jFxqsMPZrHSrpWwHhm3ioLk2g6tMz+xbo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pmacL-00A5zh-4Z; Wed, 12 Apr 2023 15:34:33 +0200
Date:   Wed, 12 Apr 2023 15:34:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     Simon Horman <simon.horman@corigine.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] phy: smsc: Implement .aneg_done callback for LAN8720Ai
Message-ID: <7330ff6d-665f-4c79-975d-6e023c781237@lunn.ch>
References: <20230406131127.383006-1-lukma@denx.de>
 <ZC7Nu5Qzs8DyOfQY@corigine.com>
 <aa6415be-e99b-46df-bb3b-d2c732a33f31@lunn.ch>
 <20230412132540.5a45564d@wsk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412132540.5a45564d@wsk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > This actually seems like a fix. So it should probably be based on net,
> > and have a Fixes: tag.
> 
> I've rebased it on the newest vanila kernel.

Please see the netdev FAQ. It talks about the two git trees used for
networking.

> It turned out that this IC has a dedicated bit (in vendor specific
> register) to show explicitly if auto neg is done.
> 
> > 
> > Lukasz, how does this bit differ to the one in BMSR? 
> 
> In the BMSR - bit 5 (Auto Negotiate Complete) - shows the same kind of
> information.
> 
> The only difference is that this bit is described as "Auto
> Negotiate Complete" and the bit in this patch indicates "Auto
> Negotiation Done".
> 
> > Is the BMSR bit
> > broken? 
> 
> This bit works as expected.

I would avoid the vendor bit, if it has no benefit. A lot of
developers understand the BMSR bit, where as very few know this vendor
bit. BMSR can probably be handled with generic code, where as the
vendor bit requires vendor specific code etc.

    Andrew
