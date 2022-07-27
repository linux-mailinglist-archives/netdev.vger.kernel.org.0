Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0686582DE2
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 19:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbiG0REr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 13:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241309AbiG0REC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 13:04:02 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41A9E6E2DB;
        Wed, 27 Jul 2022 09:38:55 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id va17so32548539ejb.0;
        Wed, 27 Jul 2022 09:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ipHXah2drN1ztV/qFRrJg6iGYe+5yo1q7EilyB1MV54=;
        b=oscMZj9/5l585E43z0ceX2e56hA2FeFafLwYq+rT+Ga/38O31b7pw7AGdOgnlZCp3K
         KVeQTolwwmIlNdtz4GHcfpJjZKw/4iO5bdg5qeelrYcx/gMCt6iIxx8D1u0ero2+UL1t
         0tLlPdNQqlhzabFWy+a36q0lF5Dy0Kl2cmhyPwiB9ECqMitHRnP0/GaIF1DuOf17JhfP
         ddSeKX6lSCBtYqbW4BLqH714Ag6yJJ4h00CzNdX+MTtbHyQBHSW9kgiPLuWsh0L5ASre
         pdZkE1eiS6EZefEJsJDmVZ54HEB6Z6Qu21b0QFEGFuL7cltLcEtySNnQgTN7ik0XHurF
         OmZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ipHXah2drN1ztV/qFRrJg6iGYe+5yo1q7EilyB1MV54=;
        b=k4eZ3w8QbwZx0zTJrSFZ7VwCT/qSzO1+iYL1xH3hkopJ4zTE3zjatKAQcFvyUqscz+
         ux0N9Re626F2JnAQeLkqA88bF5/9Cy+4xWilWe6QJZUM/E+z/IDuaxjBIs5So29p3Wja
         r/FBlAUyMcqQIPIIGacrhy2qEutWe/uMFZ9jLJJLiANN45VWs9LGhPD9qiij+hz3wyLn
         olvs2RVzQ557j06+JTX6ojKecQfwVV655tOpbMQ7TERn/KPuIMPTRUOUS9q3/LjqlWzs
         MGtEc/73hA/G8PnP8il1mmbrjWruhaIq91yFCsuq1P6JpJpdELjkjZdH9lCLN+r/Uv+p
         MdlA==
X-Gm-Message-State: AJIora8CQl2Ds7umt5c5sC0hwz124Ee1xHs3Jkh34otMLDtzfxcMzGVs
        Xe8r9QMLPCrglQLPGoCmGd4=
X-Google-Smtp-Source: AGRyM1uDjvm2zAG/PSoErEmq90918CkkiQuU0zpUrVSOeP2VeZuH8ZgY0NMtTfmAPNs8g2BkXZVpyw==
X-Received: by 2002:a17:907:a40b:b0:72b:64e3:4c5e with SMTP id sg11-20020a170907a40b00b0072b64e34c5emr18516200ejc.612.1658939932706;
        Wed, 27 Jul 2022 09:38:52 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id fu3-20020a170907b00300b0072f47838640sm7803355ejc.71.2022.07.27.09.38.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 09:38:51 -0700 (PDT)
Date:   Wed, 27 Jul 2022 19:38:48 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Grzegorz Bernacki <gjb@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        upstream@semihalf.com
Subject: Re: [net-next: PATCH v3 6/8] net: core: switch to
 fwnode_find_net_device_by_node()
Message-ID: <20220727163848.f4e2b263zz3vl2hc@skbuf>
References: <20220727064321.2953971-1-mw@semihalf.com>
 <20220727064321.2953971-7-mw@semihalf.com>
 <20220727143147.u6yd6wqslilspyhw@skbuf>
 <CAPv3WKc88KQN=athEqBg=Z5Bd1SC3QSOPZpDH7dfuYGHhR+oVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPv3WKc88KQN=athEqBg=Z5Bd1SC3QSOPZpDH7dfuYGHhR+oVg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 05:18:16PM +0200, Marcin Wojtas wrote:
> Do you mean a situation analogous to what I addressed in:
> [net-next: PATCH v3 4/8] net: mvpp2: initialize port fwnode pointer
> ?

Not sure if "analogous" is the right word. My estimation is that the
overwhelmingly vast majority of DSA masters can be found by DSA simply
due to the SET_NETDEV_DEV() call that the Ethernet drivers need to make
anyway.  I see that mvpp2 also needed commit c4053ef32208 ("net: mvpp2:
initialize port of_node pointer"), but that isn't needed in general, and
I can't tell you exactly why it is needed there, I don't know enough
about the mvpp2 driver.

> I found indeed a couple of drivers that may require a similar change
> (e.g. dpaa2).

There I can tell you why the dpaa2-mac code mangles with net_dev->dev.of_node,
but I'd rather not go into an explanation that essentially doesn't matter.
The point is that you'd be mistaken to think that only the drivers which
touch the net device's ->dev->of_node are the ones that need updating
for your series to not cause regressions.

> IMO we have 2 options:
> - update these drivers
> - add some kind of fallback? If yes, I am wondering about an elegant
> solution - maybe add an extra check inside
> fwnode_find_parent_dev_match?
> 
> What would you suggest?

Fixing fwnode_find_parent_dev_match(), of course. This change broke DSA
on my LS1028A system (master in drivers/net/ethernet/freescale/enetc/)
and LS1021A (master in drivers/net/ethernet/freescale/gianfar.c).
