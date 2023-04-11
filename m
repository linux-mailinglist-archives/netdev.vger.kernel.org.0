Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09FE26DDC0B
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 15:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbjDKN0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 09:26:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjDKN0X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 09:26:23 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E2991BC
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 06:26:21 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id 4fb4d7f45d1cf-5047074939fso16400728a12.1
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 06:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681219580;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VSqFeVFlYcufPmqoSUF5Y8qqLeSYXqfvCcjRwFMVNis=;
        b=poExvxPleogrP3SNLR8gUnMLSNC1vNdi6AZSlGYuKELEDMPqgFL09JPdT0yKokhRkb
         iEXmXC+cI7pDt/+IOppfDfmryt/lUtybqmb+Q6gKCj+HRY1oGZwvzdIcTo8rlZHnUyTp
         Q//xcP+lrbC9zZLgL8cKb3pfQNXOkSS2fAdFByJUK8EhUy/PC2Ky7+6TvdjwZcIno+9Q
         dQO1/y11TF4QShEfynVI42A6egoCCHI7XkHPKOqcB6UAmLAZHrDOPip5jusMiNokA7yN
         G8Hmcv3U/f1LhV3hBcv4LB1qmD5BfF+nF5MeG542CnpIIEA27KxUlN7dGcbhd9MZ/7XN
         EfOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681219580;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VSqFeVFlYcufPmqoSUF5Y8qqLeSYXqfvCcjRwFMVNis=;
        b=JqwDPAxeLAzQnCWIJ+EN8ptLpFzGSOBoy/c75L1opJx+5vaN7shpLyjZSrgtbM0h2L
         lNjSg6MZA980d7Tr3+1f4Odw7Hg0QCeWElcFJ/Ny54IcZmCoDUBA5hDG1w5dMEBU/0lE
         UeSHVtBHWcnI6D1srrnU84oFgIzifQFuOCF6D4ScztWT/M4xWgWX4AkEB2j6q2p2HxZs
         Orkh/2XF8CQ9dbkpt0PPBQC3bXOPWcGGC3HbZwsStPeGM7fekPT4I1qkG3sZSTrSU7uw
         UJM0r69E8FuDeQxsFO+9gp3PL46vWPMwx21s7IMAoypBIurcS3McRblD1GaMDmXW6Er0
         wS6Q==
X-Gm-Message-State: AAQBX9f1uj4MRMp1pUO4q0fqAVxQ1iJcKcVZKx/xUND8M/PEzLtytV7c
        qXpqUBfAiM5pY1995eLjHiw=
X-Google-Smtp-Source: AKy350bEyK9AvY+9T7nPHibJJ+VdVzZFq0TEpPZM9r+N7uZltZ86u/eYBJrmOb9DzUP9Mj8Qh602OA==
X-Received: by 2002:aa7:d692:0:b0:504:b11e:8cfb with SMTP id d18-20020aa7d692000000b00504b11e8cfbmr5268889edr.13.1681219579669;
        Tue, 11 Apr 2023 06:26:19 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id s10-20020a508d0a000000b00501d5432f2fsm4335784eds.60.2023.04.11.06.26.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 06:26:19 -0700 (PDT)
Date:   Tue, 11 Apr 2023 16:26:17 +0300
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
Message-ID: <20230411132617.nonvvtll7xxvadhr@skbuf>
References: <7055f8c2-3dba-49cd-b639-b4b507bc1249@lunn.ch>
 <ZDBWdFGN7zmF2A3N@shell.armlinux.org.uk>
 <20230411085626.GA19711@pengutronix.de>
 <ZDUlu4JEQaNhKJDA@shell.armlinux.org.uk>
 <20230411111609.jhfcvvxbxbkl47ju@skbuf>
 <20230411113516.ez5cm4262ttec2z7@skbuf>
 <ZDVL6we7LN/ApgwG@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDVL6we7LN/ApgwG@shell.armlinux.org.uk>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 01:00:43PM +0100, Russell King (Oracle) wrote:
> 	ethtool --pause ... autoneg on
> 	ethtool --pause ... autoneg off rx off tx off
> 	ethtool --pause ... autoneg off rx on tx on
> 
> Anything else wouldn't give the result the user wants, because there's
> no way to independently force rx and tx flow control per port.

Right.

> That said, phylink doesn't give enough information to make the above
> possible since the force bit depends on (tx && rx &&!permit_pause_to_mac)

So, since the "permit_pause_to_mac" information is missing here, I guess
the next logical step based on what you're saying is that it's a matter
of not using the pcs_config() API, or am I misunderstanding again? :)

> So, because this hardware is that crazy, I suggest that it *doesn't*
> even attempt to support ethtool --pause, and either is programmed
> at setup time to use autonegotiated pause (with the negotiation state
> programmed via ethtool -s) or it's programmed to have pause globally
> disabled. Essentially, I'm saying the hardware is too broken in its
> design to be worth bothering trying to work around its weirdness.

Ok. How can this driver reject changes made through ethtool --pause?
