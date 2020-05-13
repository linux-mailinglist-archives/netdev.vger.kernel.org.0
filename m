Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBE0D1D2068
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 22:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbgEMUw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 16:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725982AbgEMUw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 16:52:28 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA814C061A0C;
        Wed, 13 May 2020 13:52:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E521C12807D28;
        Wed, 13 May 2020 13:52:25 -0700 (PDT)
Date:   Wed, 13 May 2020 13:52:20 -0700 (PDT)
Message-Id: <20200513.135220.1111423306139710996.davem@davemloft.net>
To:     michael@walle.cc
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, o.rempel@pengutronix.de
Subject: Re: [PATCH net-next v3] net: phy: at803x: add cable diagnostics
 support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200513203807.366-1-michael@walle.cc>
References: <20200513203807.366-1-michael@walle.cc>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 13 May 2020 13:52:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Walle <michael@walle.cc>
Date: Wed, 13 May 2020 22:38:07 +0200

> The AR8031/AR8033 and the AR8035 support cable diagnostics. Adding
> driver support is straightforward, so lets add it.
> 
> The PHY just do one pair at a time, so we have to start the test four
> times. The cable_test_get_status() can block and therefore we can just
> busy poll the test completion and continue with the next pair until we
> are done.
> The time delta counter seems to run at 125MHz which just gives us a
> resolution of about 82.4cm per tick.
> 
> 100m cable, A/B/C/D open:
>   Cable test started for device eth0.
>   Cable test completed for device eth0.
>   Pair: Pair A, result: Open Circuit
>   Pair: Pair A, fault length: 107.94m
>   Pair: Pair B, result: Open Circuit
>   Pair: Pair B, fault length: 104.64m
>   Pair: Pair C, result: Open Circuit
>   Pair: Pair C, fault length: 105.47m
>   Pair: Pair D, result: Open Circuit
>   Pair: Pair D, fault length: 107.94m
> 
> 1m cable, A/B connected, C shorted, D open:
>   Cable test started for device eth0.
>   Cable test completed for device eth0.
>   Pair: Pair A, result: OK
>   Pair: Pair B, result: OK
>   Pair: Pair C, result: Short within Pair
>   Pair: Pair C, fault length: 0.82m
>   Pair: Pair D, result: Open Circuit
>   Pair: Pair D, fault length: 0.82m
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks.
