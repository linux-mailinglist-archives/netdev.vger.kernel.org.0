Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EAEC6DDDEE
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 16:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbjDKO3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 10:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjDKO3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 10:29:20 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C64240F6
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 07:28:57 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-504ae0a68e5so1136488a12.3
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 07:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681223332;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=x2I3p44zg3oTxliWG1Rp898p9mUZBl6PbVWGBK3NoWY=;
        b=F6qymaFCgAVHEmPIf+UEDS5YS1ysj7QszdTwOqrHmN3dccrZk59MyPkyF58ZeuIgsL
         jBszC4vmJeptS24ui5WaOQhFB5Foh5qIMX+dEO8lrLYgrpaUw0DhxeYoVLdNfgCesoUB
         DEVAvAT5D9UDk1rOINswpjFe26LZq57mIkG3a5bboHK/FZ9oHFO1StEud3FYlABK7gKZ
         8trPL73c0Sy3VLIZcP1ijfmL7J/d73Ya90RFaj085Loxe0Mw78MYpo0S35RR9XceajYz
         Gmj8LbyWanHJ6D247BC39T3uDKNIYHINxolyCrhUlV4LAuuLRdJK7NQ6k1zpJ4wngxdB
         p66w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681223332;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x2I3p44zg3oTxliWG1Rp898p9mUZBl6PbVWGBK3NoWY=;
        b=ksKWwO+o5BWJRt1Z7ZzqYKAf89DUGs0V8bCF77GCcLdqGQPUa8jYlV0DMDgPwT+XHv
         6ik+aL8Hy0Xzpstj+y6Ac0+dyj3F1N/TPnEmBt6MLowQoXlFlG2d+5LS1pd5WXdzlPnT
         P5Y7P3Ujio0felRLfLLfsoZbb215zkM2r+I+CKhCYhXvCDAYj3Uc8lLJPZ78KPky6NPm
         XxBag9PbJd89w02KJ0n2/kNDqXxFINxb3QL+yqnFqTk8TvDsii6gBHsM5r+nBNlHtY2Y
         oE1KxxiMa7552MoA205r8HgYmkr8OzT0fgeRP96U5tGSM2gldx7TMuWPWvnt8SyyUCB+
         ABSQ==
X-Gm-Message-State: AAQBX9dJ2Tdyf5jy/yxFpZBjbzmE6o/qYpYxnfm9VlNlMft1K1XJiv13
        3I8Ep+r81a1RaQvQsg38za8=
X-Google-Smtp-Source: AKy350ZOJRLlBbKpFB4LRXzXmdHWVZ2iNmltLRylI/c8xsud9tlJ31VBLDQX0P5ABrfNMSEVJqyrkA==
X-Received: by 2002:aa7:df04:0:b0:4fb:aa0a:5b72 with SMTP id c4-20020aa7df04000000b004fbaa0a5b72mr2363906edy.5.1681223332251;
        Tue, 11 Apr 2023 07:28:52 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id j14-20020a508a8e000000b005029c47f814sm5903887edj.49.2023.04.11.07.28.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 07:28:52 -0700 (PDT)
Date:   Tue, 11 Apr 2023 17:28:49 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Woojung Huh <woojung.huh@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Eric Dumazet <edumazet@google.com>, kernel@pengutronix.de,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: FWD: Re: [PATCH net-next v1 1/1] net: dsa: microchip: ksz8: Make
 flow control, speed, and duplex on CPU port configurable
Message-ID: <20230411142849.isudbumnxes4jwba@skbuf>
References: <7055f8c2-3dba-49cd-b639-b4b507bc1249@lunn.ch>
 <ZDBWdFGN7zmF2A3N@shell.armlinux.org.uk>
 <20230411085626.GA19711@pengutronix.de>
 <ZDUlu4JEQaNhKJDA@shell.armlinux.org.uk>
 <20230411111609.jhfcvvxbxbkl47ju@skbuf>
 <20230411113516.ez5cm4262ttec2z7@skbuf>
 <ZDVL6we7LN/ApgwG@shell.armlinux.org.uk>
 <20230411132617.nonvvtll7xxvadhr@skbuf>
 <ZDVhjJgEUz7XCdBC@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDVhjJgEUz7XCdBC@shell.armlinux.org.uk>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 02:33:00PM +0100, Russell King (Oracle) wrote:
> On Tue, Apr 11, 2023 at 04:26:17PM +0300, Vladimir Oltean wrote:
> > On Tue, Apr 11, 2023 at 01:00:43PM +0100, Russell King (Oracle) wrote:
> > > 	ethtool --pause ... autoneg on
> > > 	ethtool --pause ... autoneg off rx off tx off
> > > 	ethtool --pause ... autoneg off rx on tx on
> > > 
> > > Anything else wouldn't give the result the user wants, because there's
> > > no way to independently force rx and tx flow control per port.
> > 
> > Right.
> > 
> > > That said, phylink doesn't give enough information to make the above
> > > possible since the force bit depends on (tx && rx &&!permit_pause_to_mac)
> > 
> > So, since the "permit_pause_to_mac" information is missing here, I guess
> > the next logical step based on what you're saying is that it's a matter
> > of not using the pcs_config() API, or am I misunderstanding again? :)
> 
> pcs_config() doesn't get the "tx" and "rx" above. mac_link_up() does,
> but doesn't get the "permit_pause_to_mac" (since that's supposed to
> be a "configuration" thing.)

Ah, ok. So it would be more complicated to plumb all information through
in a reliable way.

> Anyway, I think this is now moot since I think we've agreed on a way
> forward for this hardware.

I would say we've agreed on something that does not impose practical
limitations for internal PHY ports.

The xMII port (usually fixed-link) has its own flow control
configuration, through Register 6 (0x06): Global Control 4, and that
seems to not distinguish between TX and RX either. We're okay with
setting that single bit based on "rx_pause || tx_pause", right?

> > > So, because this hardware is that crazy, I suggest that it *doesn't*
> > > even attempt to support ethtool --pause, and either is programmed
> > > at setup time to use autonegotiated pause (with the negotiation state
> > > programmed via ethtool -s) or it's programmed to have pause globally
> > > disabled. Essentially, I'm saying the hardware is too broken in its
> > > design to be worth bothering trying to work around its weirdness.
> > 
> > Ok. How can this driver reject changes made through ethtool --pause?
> 
> We would need either something in DSA (dsa_slave_set_pauseparam()) to
> prevent success, or something in phylink_ethtool_set_pauseparam() to
> do the same.
> 
> At the phylink level, that could be a boolean in struct phylink_config.
> Something like "disable_ethtool_set_pauseparam" (I'd prefer something
> a tad shorter) which if set would make phylink_ethtool_set_pauseparam()
> return -EOPNOTSUPP.

Since the configuration "ethtool --pause swp0 autoneg on" should be
trivially accepted, then I suggest a "bool no_forced_pause" based on
which struct ethtool_pauseparam :: autoneg gets restricted?
This could live either in phylink_config or in struct dsa_port,
depending on what you believe to be the most appropriate scope for this
workaround. I would slightly prefer it to live in phylink, since that's
the entity who keeps track of MLO_PAUSE_AN in general.
