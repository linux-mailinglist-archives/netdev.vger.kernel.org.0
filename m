Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD60449C36
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 20:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236694AbhKHTLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 14:11:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236666AbhKHTLn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 14:11:43 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DBDCC061570;
        Mon,  8 Nov 2021 11:08:58 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id o8so66603312edc.3;
        Mon, 08 Nov 2021 11:08:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=5BlVIudKDsjBXmEfeAzic983XTcXGaBukuqDNHjo4TM=;
        b=qE0pQR5zB920csJ351IAUW7201eKn63N8kQcApEzYbtjSOZ89W5ZXTpq0mkek1ku5r
         /bDK86pF/pQijglFrnT6P/FV+GWxGSjVe5WYHr+EIaKYqMdqqaiwhMXMJrfOq3m2+6RN
         PtmXwbDMbMmMLssQpxOI+CAWjrZ/bpmHWdfhQUHWlvksSuKwhW/JpFdlNJRnckB0XfG1
         GcWnNZWl1XYgZEHXkZuvsz2w2TwVzS9A4pfICIMQHiJi7VkxUCtn90dxmiUpJBjGcIMt
         EDIS42z/7tEk8ZD/3Z0fPQxJ1jmn2Er2XgFolO+yDqmvhau9EwISLTbcfnBMLOcesyyD
         1okA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=5BlVIudKDsjBXmEfeAzic983XTcXGaBukuqDNHjo4TM=;
        b=l/1mC6qPC8Zc2uMF/xzD5zxNNdCV+wz3AI+8hHyq35SROiGpbe24jDnzxn5pI7+TkQ
         APOt548uHB3Hzou4NlnjnjG21bmpwrqeTj+ypMUDVdnxDHKIyQjoqpPwmVCuzYBBftpa
         YwiyiG4nTe9oPpUEBDahkMJwXgxejnT7MnvFDfFwkwYocI76ZHqjcEWd0KaOzEPNu1QN
         1xzV+9HeTm1gx5LUllz/MmNdjfB/P65MPsStmhi90wWBS54bDP9vVY1cRi1bSkB7StSk
         nmF3fR0xxBMR23GdXMw9OfcnJ8zRLEJBnVRJPcJ7KK5+Ke4w4HIb7Y8N+WxGP0626QaI
         ojgQ==
X-Gm-Message-State: AOAM531Tz0Q+zBGp2zGP2Q1zPiUAtFnDtFYpfGhKMZqrm4QO/Cwu0/ZR
        OUW++S4H2NGQJvUEL/DNQrE=
X-Google-Smtp-Source: ABdhPJyKoqVhJK5MeuK4FsEiGxNzxqhdI9qzpBWBjOZKCsihq9hPEPoVBmFgMoXktSrj3TWxVkBi7A==
X-Received: by 2002:a17:906:4791:: with SMTP id cw17mr1831807ejc.493.1636398536742;
        Mon, 08 Nov 2021 11:08:56 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id bx27sm9967545edb.7.2021.11.08.11.08.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 11:08:56 -0800 (PST)
Date:   Mon, 8 Nov 2021 20:08:53 +0100
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
Subject: Re: [RFC PATCH v2 1/5] leds: trigger: add API for HW offloading of
 triggers
Message-ID: <YYl1xSKg4vrsbTdw@Ansuel-xps.localdomain>
References: <20211108002500.19115-1-ansuelsmth@gmail.com>
 <20211108002500.19115-2-ansuelsmth@gmail.com>
 <YYkuZwQi66slgfTZ@lunn.ch>
 <YYk/Pbm9ZZ/Ikckg@Ansuel-xps.localdomain>
 <20211108171312.0318b960@thinkpad>
 <YYlUSr586WiZxMn6@Ansuel-xps.localdomain>
 <20211108183537.134ee04c@thinkpad>
 <YYllTn9W5tZLmVN8@Ansuel-xps.localdomain>
 <20211108194142.58630e60@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211108194142.58630e60@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 08, 2021 at 07:41:42PM +0100, Marek Behún wrote:
> On Mon, 8 Nov 2021 18:58:38 +0100
> Ansuel Smith <ansuelsmth@gmail.com> wrote:
> 
> > Are you aware of any device that can have some trigger offloaded and
> > still have the led triggered manually?
> 
> I don't understand why we would need such a thing.
> 
> Look, just to make it clear via an example: I have a device with a
> Marvell PHY chip inside. There is a LED connected to one of the PHY LED
> pins.
> 
> Marvell PHY has LED[0] control register, which supports the following
> modes:
>   LED is OFF
>   LED is ON
>   LED is ON when Link is up
>   LED blinks on RX activity
>   LED blinks on TX activity
>   LED blinks on RX/TX activity
>   LED is ON and blinks on RX/TX activity
>   ...
> 
> I have code that exports this LED as a LED classdev
> 
> When I activate netdev trigger on this LED, the netdev trigger currently
> just blinks the LED in software, by calling the .brightness_set()
> method, which configures LED[0] control register to one of the first
> two modes above (LED is OFF, LED is ON).
> 
> But I have also another patch that adds support to offloading netdev
> trigger upon offloadable settings. The netdev trigger code calls the
> .trigger_offload() method, which is implemented in PHY driver. This
> method checks whether it is a netdev trigger that is to be offloaded,
> and whether device_name is the name of the device attached to the PHY,
> and then chooses one of the modes above, according to netdev trigger
> settings.
> 
> So when I request netdev trigger for eth0, to indicate link and blink
> on activity, the netdev trigger doesn't do anything in software. It
> just calls the offload method ONCE (at the moment I am changing netdev
> trigger settings). The blinking is then done by the PHY chip. Netdev
> trigger doesn't do anything, at least not until I change the settings
> again.
> 
> > Talking about mixed mode, so HW and SW.
> 
> What exactly do you mean by mixed mode? There is no mixed mode.
>

Ok.

> > Asking to understand as currently the only way to impement all
> > of this in netdev trigger is that:
> > IF any hw offload trigger is supported (and enabled) then the entire
> > netdev trigger can't work as it won't be able to simulate missing
> > trigger in SW. And that would leave some flexibility.
> 
> What do you mean by missing trigger here? I think we need to clarify
> what we mean by the word "trigger". Are you talking about the various
> blinking modes that the PHY supports? If so, please let's call them HW
> control modes, and not triggers. By "triggers" I understand triggers
> that can be enabled on a LED via /sys/class/leds/<LED>/trigger.
> 

offload triggers = blinking modes supported

> > We need to understand how to operate in this condition. Should netdev
> > detect that and ""hide"" the sysfs triggers? Should we report error?
> 
> So if I understand you correctly, you are asking about what should we
> do if user asked for netdev trigger settings (currently only link, rx,
> tx, interval) that can't be offloaded to the PHY chip.
> 
> Well, if the PHY allows to manipulate the LEDs ON/OFF state (in other
> words "full control by SW", or ability to implement brightness_set()
> method), then netdev trigger should blink the LED in SW via this
> mechanism (which is something it would do now). A new sysfs file,
> "offloaded", can indicate whether the trigger is offloaded to HW or not.
> 

Are all these sysfs entry OK? I mean if we want to add support for he
main blinking modes, the number will increase to at least 10 additional
entry. 

> If, on the other hand, the LED cannot be controlled by SW, and it only
> support some HW control modes, then there are multiple ways how to
> implement what should be done, and we need to discuss this.
> 
> For example suppose that the PHY LED pin supports indicating LINK,
> blinking on activity, or both, but it doesn't support blinking on rx
> only, or tx only.
> 
> Since the LED is always indicating something about one network device,
> the netdev trigger should be always activated for this LED and it
> should be impossible to deactivate it. Also, it should be impossible to
> change device_name.
> 
>   $ cd /sys/class/leds/<LED>
>   $ cat device_name
>   eth0
>   $ echo eth1 >device_name
>   Operation not supported.
>   $ echo none >trigger
>   Operation not supported.
> 
> Now suppose that the driver by default enabled link indication, so we
> have:
>   $ cat link
>   1
>   $ cat rx
>   0
>   $ cat tx
>   0
> 
> We want to enable blink on activity, but the LED supports only blinking
> on both rx/tx activity, rx only or tx only is not supported.
> 
> Currently the only way to enable this is to do
>   $ echo 1 >rx
>   $ echo 1 >tx
> but the first call asks for (link=1, rx=1, tx=0), which is impossible.
> 
> There are multiple things which can be done:
> - "echo 1 >rx" indicates error, but remembers the setting
> - "echo 1 >rx" quietly fails, without error indication. Something can
>   be written to dmesg about nonsupported mode
> - "echo 1 >rx" succeeds, but also sets tx=1
> - rx and tx are non-writable, writing always fails. Another sysfs file
>   is created, which lists modes that are actually supported, and allows
>   to select between them. When a mode is selected, link,rx,tx are
>   filled automatically, so that user may read them to know what the LED
>   is actually doing
> - something different?
> 

Expose only the supported blinking modes? (in conjunciong with a generic
traffic blinking mode)

The initial question was Should we support a mixed mode offloaed
blinking modes and blinking modes simulated by sw? I assume no as i
don't think a device that supports that exist.

> Marek

-- 
	Ansuel
