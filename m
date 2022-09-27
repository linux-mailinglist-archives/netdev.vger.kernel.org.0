Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14A3D5ECC7A
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 20:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbiI0S5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 14:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiI0S5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 14:57:02 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A18FA1D9803;
        Tue, 27 Sep 2022 11:56:59 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id rk17so9438061ejb.1;
        Tue, 27 Sep 2022 11:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=MyfOgzjgM4kQksNmvcWH+Y3ynMAV3S4ePc1g8EtpPzk=;
        b=jgaGkL0O6TJs5mz4p53zCwy7II4xlgqPqL0oSg3NDL9bB93YF/f6ofWG0ynC4VJ7mU
         U6g2TB/ukaDglcpG9+4uzuOR8lMidxKLBMHri4iuR/vOSbpreJeYXUKUFHv7PnB5olsi
         hGDI1Cgmgiwi1ys0/LXIEm9YD3STH5XpgJ/jkXgyirbcFMkhdqGZNW1f/0FhmgtQwAOE
         QweNBM/0eQJdFIDX1wPGwYP6aB3d369S7Lz1cPYm9iHdyZVxCbgI51gw0SuHle5Lj66A
         YU7dGrGycZ3sMYspjEpSz2Ufdsray2IRC7biIDA5nVfYrzNrUVasA9EWm3x+kBNrFxId
         2YYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=MyfOgzjgM4kQksNmvcWH+Y3ynMAV3S4ePc1g8EtpPzk=;
        b=KVGvoBI/KzjDygUc6eZXHJYS+rEjFn6Myyn4FeYrv1xK1yrC9F6mjTZm46gXamGkLQ
         CLimQfx2mPpD0QYChttBcS9GVCX9Q+FuC9UXRZFG+WG8FaG3g6THSYvxYktNbj6hpXgM
         jMaU7jGuOjDCYCpHh3oyYyqx0wClElOer2eBnHiKVUtM5o3NKs1B2GwKNsLeZiyROG/J
         A9RfAYWcX0TOGWIwuC66iC3X0R3Wv8L28Jsvp8TOtoWuhW0SoI9kJMmpiRWChN4kssnY
         G4xtnkQXP4htqPhM7gBxhjT2W/a1QG9waXndgWr91epECQ55a/cNVpW0w+63fa/NBWM0
         Vkhg==
X-Gm-Message-State: ACrzQf0Ika2cXCyBo0pk4stzZUawLo6ebwEwtCSsaeZfQo/sD4hr8xyT
        h2MN9j6dAqfPE7qIb8KfPy0=
X-Google-Smtp-Source: AMsMyM4u8OBnajYmKR0Q3bVtaQUbS+exmU25ba+M/soqk5CGXI9jX4eqfs2Y7js/hMWQBNtEN10Xtw==
X-Received: by 2002:a17:906:4fc3:b0:72e:eab4:d9d7 with SMTP id i3-20020a1709064fc300b0072eeab4d9d7mr24199414ejw.599.1664305018056;
        Tue, 27 Sep 2022 11:56:58 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id k20-20020aa7d8d4000000b00457d9c16fb2sm304254eds.23.2022.09.27.11.56.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 11:56:57 -0700 (PDT)
Date:   Tue, 27 Sep 2022 21:56:54 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v3 net-next 08/14] net: dsa: felix: update init_regmap to
 be string-based
Message-ID: <20220927185654.vcgilhapjhprmu67@skbuf>
References: <20220926002928.2744638-1-colin.foster@in-advantage.com>
 <20220926002928.2744638-9-colin.foster@in-advantage.com>
 <20220927175353.mn5lpxopp2n2yegr@skbuf>
 <YzNEYiXx6UoJLEdk@colin-ia-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzNEYiXx6UoJLEdk@colin-ia-desktop>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 27, 2022 at 11:43:46AM -0700, Colin Foster wrote:
> I see your point. The init_regmap(name) interface collides with the
> *_io_res arrays. Changing the init_regmap() interface doesn't really
> change the underlying issue - *_io_res[] is the thing that you're
> suggesting to go.
> 
> I'm interested to see where this is going. I feel like it might be a
> constant names[] array, then felix_vsc9959_init_regmap() where the
> specific name <> resource mapping happens. Maybe a common
> felix_match_resource_to_name(name, res, len)?
> 
> That would definitely remove the need for exporting the
> vsc7512_*_io_res[] arrays, which I didn't understand from your v1
> review.

Yes, having an array of strings, meaning which targets are required by
each driver, is what I wanted to see. Isn't that what I said in v1?

> vsc9959_init_regmap(name)
> {
>     /* more logic for port_io_res, but you get the point */
>     return felix_init_regmap(name, &vsc9959_target_io_res, TARGET_MAX);
> }

Yeah, wait a minute, you'll see.

> > I am also sorry for the mess that the felix driver currently is in, and
> > the fact that some things may have confused you.
> 
> Vladimir, you might be the last person on earth who owes me an apology.

I have some more comments on the other patches. This driver looks weird
not only because the hardware is complicated and all over the place, but
also because you're working on a driver (felix) which was designed
around NXP variations of Microchip hardware, and this really transpires
especially around the probing and dt-bindings. The goal, otherwise,
would be for you to have dt-bindings for vsc7512 that are identical to
what Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
provides. It doesn't matter how the driver probes, that is to some
extent independent from how the drivers look like. Anyway, I'm getting
ahead of myself.
