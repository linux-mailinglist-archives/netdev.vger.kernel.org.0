Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32FBE64F038
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 18:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbiLPRRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 12:17:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbiLPRRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 12:17:18 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B42CF2A275;
        Fri, 16 Dec 2022 09:17:15 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id p13-20020a05600c468d00b003cf8859ed1bso2289305wmo.1;
        Fri, 16 Dec 2022 09:17:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Grq/lCv6X9zvhjrxtn3hukSNIqujUj2abduruIelS+M=;
        b=csfswnzvXRES6JVhxCweprsXbmn7xjoYqs+ltKvQBCzBf43+AVWxASz8MZ0TMedSNy
         cmfryseQBvFRK6oLPazykJ1COPo+z5MfAXRlIeTX899arFClrQg/GICGhiJWFH7lOM2N
         NBBZZJjGEorNNGtQ/mA1CXjz2ny/A8+YRYHUN51/0CsEOJQEgoXW+lV3ux8uOVlStkfn
         1tT8Jxu/7BIy22iFF4rgpl8EnGqfCrzS8KE1vmzc3btZDx2ESqzMmHToc1y0bngCI/pZ
         dXDLBTLsvBb4cO+MXd792JoTr5Oul1f4tSqixNXsfCtuwLsUMwIDKaKB4jEUTzo95OxA
         HvhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Grq/lCv6X9zvhjrxtn3hukSNIqujUj2abduruIelS+M=;
        b=vHta+VEdefDtumz9rC6M8E5/2GfbmH9VTtY924hftWqr9vDLbKJLjGxT9zfgqb6jzc
         JuHAWsHYpDLJkMHGC1AM6f7vuirwAlv/Ml3azKHWLCOupo/UH3J1WV39T6f9Rc5F47y6
         9vzzhdtSYtUVdh/MVLx/FBKwND9a2/xWUBmMUAR2RB53HSI+gZjT97i9YYlFSjw5zWgj
         IuK8aq5Q3NsPS+EGqCDA48sxIWMev1I0JQV5iKuqkLEzzHstLNbuVXxzh/pztEUtzVZk
         nY8ylCuGqNlzEW+enWc6VJahvO4hoYcICwX3kaWHML1ux1gyH3TjETGTUzfBJH208qtM
         LArg==
X-Gm-Message-State: ANoB5plripN2b/REigdD4f2j6HVAZqBp7sVybhbrBlF8r3kHfOE2V87z
        bO78HPMWSGT0EvL+3IwXdNA=
X-Google-Smtp-Source: AA0mqf4bczFAXhp8frgYXfTWDcx+1h47VoETJuXmG2+FOJRxH34v0Qw+cRKpdK1xm80neDn3BvMY6Q==
X-Received: by 2002:a05:600c:4fc8:b0:3cf:614e:b587 with SMTP id o8-20020a05600c4fc800b003cf614eb587mr26240906wmq.26.1671211034146;
        Fri, 16 Dec 2022 09:17:14 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-18.ip85.fastwebnet.it. [93.42.71.18])
        by smtp.gmail.com with ESMTPSA id q9-20020a7bce89000000b003d1e34bcbb2sm3083664wmj.13.2022.12.16.09.17.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 09:17:13 -0800 (PST)
Message-ID: <639ca819.7b0a0220.6b61a.9f2e@mx.google.com>
X-Google-Original-Message-ID: <Y5yoGnwCHRK5qtJY@Ansuel-xps.>
Date:   Fri, 16 Dec 2022 18:17:14 +0100
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        Tim Harvey <tharvey@gateworks.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: Re: [PATCH v7 09/11] leds: trigger: netdev: add additional hardware
 only triggers
References: <20221214235438.30271-1-ansuelsmth@gmail.com>
 <20221214235438.30271-10-ansuelsmth@gmail.com>
 <Y5ta87eCAQ8XsY8L@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5ta87eCAQ8XsY8L@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 15, 2022 at 05:35:47PM +0000, Russell King (Oracle) wrote:
> On Thu, Dec 15, 2022 at 12:54:36AM +0100, Christian Marangi wrote:
> > Add additional hardware only triggers commonly supported by switch LEDs.
> > 
> > Additional modes:
> > link_10: LED on with link up AND speed 10mbps
> > link_100: LED on with link up AND speed 100mbps
> > link_1000: LED on with link up AND speed 1000mbps
> > half_duplex: LED on with link up AND half_duplex mode
> > full_duplex: LED on with link up AND full duplex mode
> 
> Looking at Marvell 88e151x, I don't think this is usable there.
> We have the option of supporting link_1000 on one of the LEDs,
> link_100 on another, and link_10 on the other. It's rather rare
> for all three leds to be wired though.

On qca8k it's just anarchy. You can apply the same rule table to
whatever led you want. They are all the same... OEM decide what to do
(add white led, amber, green...)

Most common configuration is 2 leds, one react with port 1000 and the
other with port 100. But each led can be set to be powered on to any
speed by enabling 10 100 and 1000 rule.

Rejecting a configuration falls in the driver returning error on
configure.

> 
> This is also a PHY where "activity" mode is supported (illuminated
> or blinking if any traffic is transmitted or received) but may not
> support individual directional traffic in hardware. However, it
> does support forcing the LED on or off, so software mode can handle
> those until the user selects a combination of modes that are
> supported in the hardware.
> 
> > Additional blink interval modes:
> > blink_2hz: LED blink on any even at 2Hz (250ms)
> > blink_4hz: LED blink on any even at 4Hz (125ms)
> > blink_8hz: LED blink on any even at 8Hz (62ms)
> 
> This seems too restrictive. For example, Marvell 88e151x supports
> none of these, but does support 42, 84, 170, 340, 670ms.
> 

Eh this is really bad, it was an idea to support blink internal for each
event but I expected other switch had something different... But the
generic function is still there...

Wonder if we should consider adding generic naming like SLOW, NORMAL(?),
FAST. And just assign them from the driver side?

Permit to have some kind of configuration while also keeping it generic
enough? 

Just as reference... The blink mode already had a compromise since qca8k
can support a way to blink differently based on the link speed.

-- 
	Ansuel
