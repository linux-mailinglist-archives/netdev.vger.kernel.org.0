Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 590DE44765F
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 23:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236653AbhKGWrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 17:47:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236644AbhKGWrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 17:47:19 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DDC2C061570;
        Sun,  7 Nov 2021 14:44:35 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id z21so9691530edb.5;
        Sun, 07 Nov 2021 14:44:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=+HZjTmLEtuVS6kd0CxojI9stZ8Z3WvyonVBEkSZ936I=;
        b=lKd1Pb3FZ/NKDVGX4723aHS/Bm+1bMK8qyC6U8X5tLFBOCwNOs/Lsh7vWMUIzf834R
         GSrQt6WAKD+8tkV5bcHvHGUGL/BZZCijnFHxhztsODmFVDBd0CZsUMpcgYEkCmgKxYN1
         ikXp3E8izoFfKzisOSNZys39uO3jDGKRX/MdU5OmmHrQfuwmaUlhJAz/G7SnsGwpdb+U
         9a/NzS3GCb7ntTIF+ROmjI338PBbpZOZzfyZDagxKmT1wW6MtKRvQFa0rmtJd0u6/ggH
         bY+gbKo06GO2c+JDLdUdYHuW55jBsp8ax9TOY9ZIJpPr8XuRKl8H3zbb4R/fnwN/g3PK
         jC1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=+HZjTmLEtuVS6kd0CxojI9stZ8Z3WvyonVBEkSZ936I=;
        b=eLpaVDyNU83w/12WXHTRuPj+q2uFPmO067RTQos//JIPFa+/kRlEaE51lGXjE/Tcdz
         DnsjSuvlsiGCPzJtQwKu8EXP5oRBkB0RC+8c6P6+ZTJwnF6A3TOXp8inUfu0nahXGTpd
         Z/aylZtP2opVaSL22oabYYl+Zzu1VjtlYdWPtUcbfI2ZeXFmtgp336DHqr/E9Jm34eu3
         mHu5mQ7nL+BruJDhwbZ6bjdlHxeWoue6oiXi1HxG6rjpad98Ieclc1vmNivJ1T61/kOj
         i0VgCAedlVy3KQEzf9ilzG+8lZUpCVPjMa8LHyt8AsVZ/iWiZYXfDgW9mgZUg0kd90WT
         D0ZA==
X-Gm-Message-State: AOAM532Z3KZLOCpn28UW5hjX9Ww0gaRCl1bT9b4riLltCfHEmPnvuDwo
        jNtmlWy2ZLyqT55yMmpr7w4=
X-Google-Smtp-Source: ABdhPJxHdP/Lm14fwOeKhcryQJIOKbN4rKlzV/dFy3yB8kFV8mLsYwvkMpbFEMAZTM/J2BCYyBV8TQ==
X-Received: by 2002:a17:907:97d4:: with SMTP id js20mr10335289ejc.416.1636325073879;
        Sun, 07 Nov 2021 14:44:33 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id h10sm8559773edb.59.2021.11.07.14.44.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Nov 2021 14:44:33 -0800 (PST)
Date:   Sun, 7 Nov 2021 23:43:37 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [RFC PATCH 4/6] leds: trigger: add offload-phy-activity trigger
Message-ID: <YYhWmUd5FdTYwPvn@Ansuel-xps.localdomain>
References: <20211107175718.9151-1-ansuelsmth@gmail.com>
 <20211107175718.9151-5-ansuelsmth@gmail.com>
 <20211107231009.7674734b@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211107231009.7674734b@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 07, 2021 at 11:10:09PM +0100, Marek Behún wrote:
> On Sun,  7 Nov 2021 18:57:16 +0100
> Ansuel Smith <ansuelsmth@gmail.com> wrote:
> 
> > Add Offload Trigger for PHY Activity. This special trigger is used to
> > configure and expose the different HW trigger that are provided by the
> > PHY. Each offload trigger can be configured by sysfs and on trigger
> > activation the offload mode is enabled.
> > 
> > This currently implement these hw triggers:
> >   - blink_tx: Blink LED on tx packet receive
> >   - blink_rx: Blink LED on rx packet receive
> >   - blink_collision: Blink LED on collision detection
> >   - link_10m: Keep LED on with 10m link speed
> >   - link_100m: Keep LED on with 100m link speed
> >   - link_1000m: Keep LED on with 1000m link speed
> >   - half_duplex: Keep LED on with half duplex link
> >   - full_duplex: Keep LED on with full duplex link
> >   - linkup_over: Keep LED on with link speed and blink on rx/tx traffic
> >   - power_on_reset: Keep LED on with switch reset
> >   - blink_2hz: Set blink speed at 2hz for every blink event
> >   - blink_4hz: Set blink speed at 4hz for every blink event
> >   - blink_8hz: Set blink speed at 8hz for every blink event
> >   - blink_auto: Set blink speed at 2hz for 10m link speed,
> >       4hz for 100m and 8hz for 1000m
> > 
> > The trigger will read the supported offload trigger in the led cdev and
> > will expose the offload triggers in sysfs and then activate the offload
> > mode for the led in offload mode has it configured by default. A flag is
> > passed to configure_offload with the related rule from this trigger to
> > active or disable.
> > It's in the led driver interest the detection and knowing how to
> > elaborate the passed flags.
> > 
> > The different hw triggers are exposed in the led sysfs dir under the
> > offload-phy-activity subdir.
> 
> NAK. The current plan is to use netdev trigger, and if it can
> transparently offload the settings to HW, it will.
> 
> Yes, netdev trigger currently does not support all these settings.
> But it supports indicating link and blinking on activity.
> 
> So the plan is to start with offloading the blinking on activity, i.e.
> I the user does
>   $ cd /sys/class/leds/<LED>
>   $ echo netdev >trigger
>   $ echo 1 >rx
>   $ echo eth0 >device_name
> 
> this would, instead of doing blinking in software, do it in HW instead.
> 
> After this is implemented, we can start working on extending netdev
> trigger to support more complicated features.
> 
> Marek

Using the netdev trigger would cause some problem. Most of the switch
can run in SW mode (with blink controlled by software of always on) or
be put in HW mode and they will autonomously control blinking and how
the LED will operate. So we just need to provide a way to trigger this
mode and configure it. Why having something that gets triggered and then
does nothing as it's offloaded?

The current way to configure this is very similar... Set the offload
trigger and use the deidcated subdir to set how the led will
blink/behave based on the supported trigger reported by the driver.

There is no reason to set a device_name as that would be hardcoded to
the phy (and it should not change... again in HW we can't control that
part, we can just tell the switch to blink on packet tx on that port)

So really the command is:
  $ cd /sys/class/leds/<LED>
  $ echo netdev > offload-phy-activity
  $ cd offload-phy-activity
  $ echo 1 > tx-blink

And the PHY will blink on tx packet.

I understand this should be an extension of netdev as they would do
similar task but honestly polluting the netdev trigger of if and else to
disable part of it if an offload mode can be supported seems bad and
confusionary. At this point introduce a dedicated trigger so an user can
switch between them. That way we can keep the flexibility of netdev
trigger that will always work but also permit to support the HW mode
with no load on the system.

-- 
	Ansuel
