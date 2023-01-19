Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6C89673AD6
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 14:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbjASN5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 08:57:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjASN5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 08:57:16 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B5771F2E;
        Thu, 19 Jan 2023 05:57:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=dmvJQOFCtwzkGLAsjBFRopwTcLwjcypkP+CxqSCWQoQ=; b=ou6xeig5IJ07UdXh7mO+3cSoBq
        BT/Zx+41kyeJ9YwdJC9wWCO0PYDH7D9LtZp/XNd6QkcrKLVxCQ57S8NTJ4ASeJpOyn65Fv9e7N0ap
        WQf++nsEnyJUtyRMyIDwNld8vCWf08/TgENyh+KOCQLCuKNSlRsgaitnaTxpe2G78794=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pIVPQ-002Yqq-6i; Thu, 19 Jan 2023 14:56:52 +0100
Date:   Thu, 19 Jan 2023 14:56:52 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        kernel@pengutronix.de, Oleksij Rempel <ore@pengutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: microchip: fix probe of I2C-connected
 KSZ8563
Message-ID: <Y8lMJI+SnnfxVMVe@lunn.ch>
References: <20230119131014.1228773-1-a.fatoum@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119131014.1228773-1-a.fatoum@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 19, 2023 at 02:10:15PM +0100, Ahmad Fatoum wrote:
> Starting with commit eee16b147121 ("net: dsa: microchip: perform the
> compatibility check for dev probed"), the KSZ switch driver now bails
> out if it thinks the DT compatible doesn't match the actual chip:
> 
>   ksz9477-switch 1-005f: Device tree specifies chip KSZ9893 but found
>   KSZ8563, please fix it!
> 
> Problem is that the "microchip,ksz8563" compatible is associated
> with ksz_switch_chips[KSZ9893]. Same issue also affected the SPI driver
> for the same switch chip and was fixed in commit b44908095612
> ("net: dsa: microchip: add separate struct ksz_chip_data for KSZ8563 chip").
> 
> Reuse ksz_switch_chips[KSZ8563] introduced in aforementioned commit
> to get I2C-connected KSZ8563 probing again.
> 
> Fixes: eee16b147121 ("net: dsa: microchip: perform the compatibility check for dev probed")
> Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
