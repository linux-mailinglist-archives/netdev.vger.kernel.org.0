Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8F1653124
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 13:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232976AbiLUM5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 07:57:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiLUM47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 07:56:59 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B0A22BEF;
        Wed, 21 Dec 2022 04:56:58 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id f13-20020a1cc90d000000b003d08c4cf679so1370352wmb.5;
        Wed, 21 Dec 2022 04:56:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Xv4cGbJ2lw4EoY2EPo5WFdBPvwJO/ifxc5USrYkH2UE=;
        b=DU6JbJKLHO037qvAgdXAWe8AeuTpBvvI4AmJwL1wvwR7aUdvTlouittVr6P/8wNN6M
         s2b/dnJDodrrsXjKOrMHahLjXLLMnPx2jvuCnCLjtJAO6wM6uG4Mbxgb0Elfw31E9OVw
         i2stTpATQdXqKn0wqGm5aHprxPmQFjnYfmyYdAPNM5WQVqptTTDixf4QumMz6JmFSQuE
         0s0+4DwrBFjyQv1uW0HRWh/QE0WL2LQI0DgTvL6SltUfXGBZMJxXX52dLb5i8G0VS6lz
         dgOp4UyRsF6PqfCEDqHsW8+4ta4n68rMWgpuAVaxnHycfpVOCPkHOJ5a0nddCKjVr081
         NLXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xv4cGbJ2lw4EoY2EPo5WFdBPvwJO/ifxc5USrYkH2UE=;
        b=HJwcelOJwixfK+mJtuTK4KsZTz8aUeTae14iBvDHA97E9mqmLJMtBHbgsq8SfpjuPa
         k2VuVMKGIj9AiJq2Z0pyCr3lc8jWR6v+mYwpSRayCvsuMjKyFwI7gh4N97GqRyHTKIuP
         8hmcAyHyhniJag7Q4THolCGtMv18je9S7xnyhgeH7jy8R4aF5OnB57qj8YgK81S3ftEE
         5q105lxyV0yujUsfvF4YJNUbQsOzX8b7m4RB9yymiwqESvOvvNuRSPMgkBrp6o9+k8MR
         te6QoGrydmGe3GpLQhgUJ/cll5pqeJ4e5Pq/ZB61EtpfvZ88piCpIybJzAiHVQJWG+6B
         cihw==
X-Gm-Message-State: AFqh2kqvxcIfLmDmrL+vNdcVBLpJaOSB57+mhOEIGMx5wafKJaM+BrvY
        FIIxzhnX/mvqjw9AVHh1r3U=
X-Google-Smtp-Source: AMrXdXtUtSzdur8o78D0ku8asI6PFaALZAbRSRmsrcimaXlb2rXlxYwSkedxV/V2GinwvHXRZD3dLg==
X-Received: by 2002:a7b:ca4f:0:b0:3c6:edc0:5170 with SMTP id m15-20020a7bca4f000000b003c6edc05170mr1580433wml.25.1671627416435;
        Wed, 21 Dec 2022 04:56:56 -0800 (PST)
Received: from Ansuel-xps. (host-82-55-238-56.retail.telecomitalia.it. [82.55.238.56])
        by smtp.gmail.com with ESMTPSA id v15-20020a05600c444f00b003cf54b77bfesm2484377wmn.28.2022.12.21.04.56.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Dec 2022 04:56:55 -0800 (PST)
Message-ID: <63a30297.050a0220.46b0f.7533@mx.google.com>
X-Google-Original-Message-ID: <Y6MClVcoFAJweGj0@Ansuel-xps.>
Date:   Wed, 21 Dec 2022 13:56:53 +0100
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
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
 <Y6JPYBQhtpZLadry@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6JPYBQhtpZLadry@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 21, 2022 at 01:12:16AM +0100, Andrew Lunn wrote:
> On Thu, Dec 15, 2022 at 05:35:47PM +0000, Russell King (Oracle) wrote:
> > On Thu, Dec 15, 2022 at 12:54:36AM +0100, Christian Marangi wrote:
> > > Add additional hardware only triggers commonly supported by switch LEDs.
> > > 
> > > Additional modes:
> > > link_10: LED on with link up AND speed 10mbps
> > > link_100: LED on with link up AND speed 100mbps
> > > link_1000: LED on with link up AND speed 1000mbps
> > > half_duplex: LED on with link up AND half_duplex mode
> > > full_duplex: LED on with link up AND full duplex mode
> > 
> > Looking at Marvell 88e151x, I don't think this is usable there.
> > We have the option of supporting link_1000 on one of the LEDs,
> > link_100 on another, and link_10 on the other. It's rather rare
> > for all three leds to be wired though.
> 
> The 88e151x will need to enumerate what it actually supports from the
> above list, per LED. I also think we can carefully expand the list
> above, adding a few more modes. We just need to ensure what is added
> is reasonably generic, modes we expect multiple PHY to support. What
> we need to avoid is adding every single mode a PHY supports, but no
> other PHY has.
> 
> > This is also a PHY where "activity" mode is supported (illuminated
> > or blinking if any traffic is transmitted or received) but may not
> > support individual directional traffic in hardware. However, it
> > does support forcing the LED on or off, so software mode can handle
> > those until the user selects a combination of modes that are
> > supported in the hardware.
> > 
> > > Additional blink interval modes:
> > > blink_2hz: LED blink on any even at 2Hz (250ms)
> > > blink_4hz: LED blink on any even at 4Hz (125ms)
> > > blink_8hz: LED blink on any even at 8Hz (62ms)
> > 
> > This seems too restrictive. For example, Marvell 88e151x supports
> > none of these, but does support 42, 84, 170, 340, 670ms.
> 
> I would actually drop this whole idea of being able to configure the
> blink period. It seems like it is going to cause problems. I expect
> most PHYs actual share the period across multiple LEDs, which you
> cannot easily model here.
> 
> So i would have the driver hard coded to pick a frequency at thats' it.
> 

Yes I think "for now" it's the only way and just drop blink
configuration support.

-- 
	Ansuel
