Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 723FC63A98A
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 14:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231886AbiK1Nbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 08:31:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231438AbiK1Nbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 08:31:38 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 746701DDC2
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 05:31:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Ma/rL5PGzodMkRHRpl8RUmLbs2MEuPO7iCbDXsIs/3E=; b=Va6dBzL9dlhjha+zHpUgxiKaLj
        NG90SG3AUhqFx4mrDJAC9d6dgqFqIU1IdPGTICQ9Itf0u/Lzcb+XK1lknk/LH7phGJRGyDIe3Mpdc
        S6FXq7PUoiwsOQ9yO88kyiZ36+1Wtc2LZFTXwWjhcAdQUKAnnORR2bSU31vf3uNd2Ve4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ozeDp-003eg4-1e; Mon, 28 Nov 2022 14:30:57 +0100
Date:   Mon, 28 Nov 2022 14:30:57 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        netdev@vger.kernel.org, Xu Liang <lxu@maxlinear.com>
Subject: Re: GPY215 PHY interrupt issue
Message-ID: <Y4S4EfChuo0wmX2k@lunn.ch>
References: <fd1352e543c9d815a7a327653baacda7@walle.cc>
 <Y4DcoTmU3nWqMHIp@lunn.ch>
 <baa468f15c6e00c0f29a31253c54383c@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <baa468f15c6e00c0f29a31253c54383c@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 28, 2022 at 08:41:17AM +0100, Michael Walle wrote:
> Am 2022-11-25 16:17, schrieb Andrew Lunn:
> > Or even turn it into an input and see if you can read its
> > state and poll it until it clears?
> 
> Btw, I don't think that's possible for shared interrupts. In
> the worst case you'd poll while another device is asserting the
> interrupt line.

Yes, i thought about that afterwards. You need a timeout of 2ms for
your polling, and then assume its the other PHY. But it also seems
pretty unlikely that both PHYs go down within 2ms of each other. Maybe
if you are using a bond and the switch at the other end looses power,
but for normal use cases, it seems unlikely. It is also a question of
complexity vs gain. 802.3 says something like you have to wait 750ms
before declaring link down, so adding a 2ms sleep is just a bit more
noise.

    Andrew

