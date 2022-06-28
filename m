Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFD955CE46
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242333AbiF1HXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 03:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242305AbiF1HXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 03:23:15 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F24286D6;
        Tue, 28 Jun 2022 00:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ZN46xJfx0F1znhp+nDlAJ1g2eUoXZJqOv+162R9HeD8=; b=eG97E/B3oqw24lLG7tEOVBAvQS
        0SF9LGFggMqBD1Fky2NGz2LEo7LHR0UnEH6Mceh97lKOCQsX5TVQRfWAeWmMfPbAuYl7FFYb3/A+4
        5sPyrhZv6MV3v2cQejM/sUJqTXx83x9NOaSz2YQ9dCxikY6wHeWdOLWGnpf+Vx1QCYzE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o65Yj-008XL1-Il; Tue, 28 Jun 2022 09:22:53 +0200
Date:   Tue, 28 Jun 2022 09:22:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Lukas Wunner <lukas@wunner.de>, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v1 2/3] net: dsa: ar9331: add support for pause
 stats
Message-ID: <YrqsTY0uUy4AwKHN@lunn.ch>
References: <20220624125902.4068436-1-o.rempel@pengutronix.de>
 <20220624125902.4068436-2-o.rempel@pengutronix.de>
 <20220624220317.ckhx6z7cmzegvoqi@skbuf>
 <20220626171008.GA7581@pengutronix.de>
 <20220627091521.3b80a4e8@kernel.org>
 <20220627200238.en2b5zij4sakau2t@skbuf>
 <20220627200959.683de11b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627200959.683de11b@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Yeah, the corrections are always iffy. I understand the doubts, and we
> can probably leave things "under-specified" until someone with a strong
> preference comes along. But I hope that the virt example makes it clear
> that neither of the choices is better (SR-IOV NICs would have to start
> adding the pause if we declare rtnl stats as inclusive).
> 
> I can see advantages to both counting (they are packets) and not
> counting those frames (Linux doesn't see them, they get "invented" 
> by HW).
> 
> Stats are hard.

I doubt we can define it either way. I once submitted a patch for one
driver to make it ignore CRC bytes. It then gave the exact same counts
as another hardware i was using, making the testing i was doing
simpler.

The patch got rejected simply because we have both, with CRC and
without CRC, neither is correct, neither is wrong.

So i would keep it KISS, pause frames can be included, but i would not
go to extra effort to include them, or to exclude them.

   Andrew
