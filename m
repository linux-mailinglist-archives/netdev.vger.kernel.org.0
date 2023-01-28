Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D90A67F8F3
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 16:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbjA1PGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 10:06:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjA1PGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 10:06:07 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2726D24C90;
        Sat, 28 Jan 2023 07:06:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=sFu5IhldlzBO/Zxb1wwiz5c//n6RxEL6ZjAT6h6jDtU=; b=zzY3CH3jRhIN/eJjC7jSLhzeNY
        OeUPMNBItrUZ0spheY3QeMLVu+8xyXVHsvQKJHtBjaXttfLIgFUcg2yV5K6QBON/un6PKlhs3sDGb
        1gT+yxzGeOlT5i5j8zJZ7iIPZ9S49/3aTmwXpeBGmEvvJYLGku9N875+zAKjJyC+6Q4Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pLmmB-003SDp-Uf; Sat, 28 Jan 2023 16:05:55 +0100
Date:   Sat, 28 Jan 2023 16:05:55 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Frank Sae <Frank.Sae@motor-comm.com>
Cc:     Peter Geis <pgwipeout@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, xiaogang.fan@motor-comm.com,
        fei.zhang@motor-comm.com, hua.sun@motor-comm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/5] dt-bindings: net: Add Motorcomm yt8xxx
 ethernet phy
Message-ID: <Y9U5074l5esHT9Jg@lunn.ch>
References: <20230128031314.19752-1-Frank.Sae@motor-comm.com>
 <20230128031314.19752-2-Frank.Sae@motor-comm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230128031314.19752-2-Frank.Sae@motor-comm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +properties:
> +  rx-internal-delay-ps:
> +    description: |
> +      RGMII RX Clock Delay used only when PHY operates in RGMII mode with
> +      internal delay (phy-mode is 'rgmii-id' or 'rgmii-rxid') in pico-seconds.
> +    enum: [ 0, 150, 300, 450, 600, 750, 900, 1050, 1200, 1350, 1500, 1650,
> +            1800, 1900, 1950, 2050, 2100, 2200, 2250, 2350, 2500, 2650, 2800,
> +            2950, 3100, 3250, 3400, 3550, 3700, 3850, 4000, 4150 ]
> +    default: 1900
> +
> +  tx-internal-delay-ps:
> +    description: |
> +      RGMII TX Clock Delay used only when PHY operates in RGMII mode with
> +      internal delay (phy-mode is 'rgmii-id' or 'rgmii-txid') in pico-seconds.
> +    enum: [ 0, 150, 300, 450, 600, 750, 900, 1050, 1200, 1350, 1500, 1650, 1800,
> +            1950, 2100, 2250 ]
> +    default: 150

That is an odd default to choose. rgmii-id or rgmii-txid means the PHY
should be added around 2ns of delay. So a default of 1950 makes more
sense.

	Andrew
