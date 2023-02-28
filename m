Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB91A6A5EEA
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 19:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbjB1SnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 13:43:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjB1SnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 13:43:15 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A5923102;
        Tue, 28 Feb 2023 10:43:06 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id i12so6893174ila.5;
        Tue, 28 Feb 2023 10:43:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qjpz6w1wU5Ahvn+ZiAXXT7LUF2diV3nFILzNkAj96SY=;
        b=nkgj59ZCKiK1D88RTqrIIcfHr0fWsaoTuy5xVm3ADPBIAetdxbSxDJESBM2+Fz4qc7
         ko0ehsCR3mNWQ3/MT+ClSqo1xlZ4pS38Kr1PpU1O7oEqclR5/T+gHG2u4mL93r73orcV
         P0kTTxbCjpVYiU/nI+Evm0Y+O9z9nymjAr3biZVUQZAu99DTTC6qa5B9flHhLHmHu+91
         1NR5NSqFLv9d0xURv1FZfMxhJ68hU23v3Can1pPmfYT8eO1k22xS6jJvOqU+AjGzr5+v
         3wfd8g2dqB68aHELwUnWNN6LGld+JnTUP45MWD8dUEu2/J7ps4OZW2JwOWa1iGFJEaRj
         Spyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qjpz6w1wU5Ahvn+ZiAXXT7LUF2diV3nFILzNkAj96SY=;
        b=5kJiBMKG5I2qhA3NyMqEcsgaoBMR/CQutEsaezjPOQC+wE2/QS4x+xRqBQycj8STxi
         qYbpEQcAugVVPutzdgmEU+ffdJHxIl0JSIQ/Bek37+UQ37SnwQg+N0x0HxzVnNVCnvKu
         dmCTQOsXxc7KKXnOw3tzBQUlXpIyrIO8l0mOMHr/ZSRQk1rX7GzZtOVUuZqGXRNXg7lF
         WVYyoLKxEjUssr21a03r7Bgo0I9J6GzijjTuy5fLTTyNklVX/1tUlnvJwz+FOXJDZ4wv
         eGlf1QY1b1COoY8QI0/bcGT7PEl3DAET2kQ9iOv0Ztp5PTLM1KQ9yI3J8Vvc/hQysyX3
         4poA==
X-Gm-Message-State: AO0yUKUsLzKHH9I3nOP4VjIoka6iPjtvUu83YpjM2Z8NCukqPTu+H24A
        FpujSraX6sTaaY1xVJi+b4I=
X-Google-Smtp-Source: AK7set+3SB0xC45QlRlJGTf+BbZNkGs7ZRfuNGqxezNLWWwtxXvPDuKgP46T2mHtv/3U+N83n2USvw==
X-Received: by 2002:a05:6e02:1a24:b0:314:fa6:323c with SMTP id g4-20020a056e021a2400b003140fa6323cmr4151260ile.12.1677609785974;
        Tue, 28 Feb 2023 10:43:05 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c14-20020a92cf4e000000b00316e39f1285sm2842875ilr.82.2023.02.28.10.43.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 10:43:05 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 28 Feb 2023 10:43:03 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Wei Fang <wei.fang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com, intel-wired-lan@lists.osuosl.org,
        regressions@lists.linux.dev
Subject: Re: [PATCH net-next v8 6/9] net: phy: c22: migrate to
 genphy_c45_write_eee_adv()
Message-ID: <20230228184303.GA4098978@roeck-us.net>
References: <20230211074113.2782508-1-o.rempel@pengutronix.de>
 <20230211074113.2782508-7-o.rempel@pengutronix.de>
 <20230224035553.GA1089605@roeck-us.net>
 <20230224041604.GA1353778@roeck-us.net>
 <20230224172004.GA1224760@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224172004.GA1224760@roeck-us.net>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Letting regzbot know about the fix:

#regzbot fixed-by: 972074ea8840

On Fri, Feb 24, 2023 at 09:20:04AM -0800, Guenter Roeck wrote:
> Copying regzbot.
>   
> #regzbot ^introduced 9b01c885be36
> #regzbot title Network interface initialization failures on xtensa, arm:cubieboard
> #regzbot ignore-activity
> 
> On Thu, Feb 23, 2023 at 08:16:06PM -0800, Guenter Roeck wrote:
> > On Thu, Feb 23, 2023 at 07:55:55PM -0800, Guenter Roeck wrote:
> > > On Sat, Feb 11, 2023 at 08:41:10AM +0100, Oleksij Rempel wrote:
> > > > Migrate from genphy_config_eee_advert() to genphy_c45_write_eee_adv().
> > > > 
> > > > It should work as before except write operation to the EEE adv registers
> > > > will be done only if some EEE abilities was detected.
> > > > 
> > > > If some driver will have a regression, related driver should provide own
> > > > .get_features callback. See micrel.c:ksz9477_get_features() as example.
> > > > 
> > > > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > > > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> > > 
> > > This patch causes network interface failures with all my xtensa qemu
> > > emulations. Reverting it fixes the problem. Bisect log is attached
> > > for reference.
> > > 
> > 
> > Also affected are arm:cubieboard emulations, with same symptom.
> > arm:bletchley-bmc emulations crash. In both cases, reverting this patch
> > fixes the problem.
> > 
> > Guenter
