Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83A853E0FBE
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 09:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239062AbhHEH5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 03:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbhHEH5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 03:57:31 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 886C0C0613C1
        for <netdev@vger.kernel.org>; Thu,  5 Aug 2021 00:57:17 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id i10-20020a05600c354ab029025a0f317abfso5582684wmq.3
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 00:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=8f5irXTOZ+x1gqeO+/tRlTIZs9mBkkMUf4VKbD7vsag=;
        b=Cjclz8AMLNKZ/ixpsGLo+HKLOR46pfRb386vdXb2uBUOFefb6AEr/JxCkmjY/3ja44
         E4vQHrVP0gOphI/lf35gPhbAlms+8PIy8RPMX0zrs35OfswTfsfJh1gCVqNxAsLp+r3f
         CEcIT/9vNxJSIU30ExwwJELU6CIhKMQLpuOOUhKrCrkH8zcm6+vJkBEg05IHQLXoxpNr
         zVpETORHtLOpC5Q9VkIaj/MQ9SmzWBi/i60zfJg0ENdfCoIhwQIoM2FjFB12nRThk+Ek
         qJevUFuVOyOxBgJIIp36POaxE0lSD6uaiQHR6YH9+M4CB6OHUiGgjb/oalS7dnpDhLJd
         skXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=8f5irXTOZ+x1gqeO+/tRlTIZs9mBkkMUf4VKbD7vsag=;
        b=UGkTRHfol0/tzXy6rYpk9bjQGj75WPJBnCmOcFlB+UfPlkITZNcgNYGyXcd60uko2r
         OQvtBtVtoZCD5OkWfQP4gqN7J7/l1qtHXwFDc7bT6U008/g4HTbSk8QxEBiIef4TD850
         1lrQsMZa0m6Sg33fpMQiOCPgCEremmSKUjSnAFDFb5n5NxQk7imd34GsdlSFzVuwJpa1
         7Gu2AZllNdBNccRJjUUGUWAK/vUBThApYy8dSpAntBjFWCIkjV+GAAkjpG+frwwJ6E6m
         q0kR71LU2qvcy2n0887belREbMi7pzmpyTYvhhSY7wablBZrOEAf6XAGD/jHkzrmn91o
         NCtg==
X-Gm-Message-State: AOAM532PU41LIplHoizKqXJzmkXhJQEvyYLYmaCTnM6AqN4wdLWB8NmQ
        zSYafqO4z3bbhevhCxhtnbrWAA==
X-Google-Smtp-Source: ABdhPJwhLLopAA/dTEvx/HThhsTVbzLYE3o0/re8+AVTzlEJn7scdP89e0g2se26WnCV5dLwJZ3FQg==
X-Received: by 2002:a05:600c:4101:: with SMTP id j1mr3576009wmi.110.1628150236118;
        Thu, 05 Aug 2021 00:57:16 -0700 (PDT)
Received: from google.com ([109.180.115.228])
        by smtp.gmail.com with ESMTPSA id f26sm5233182wrd.41.2021.08.05.00.57.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 00:57:15 -0700 (PDT)
Date:   Thu, 5 Aug 2021 08:57:13 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        linux-amlogic@lists.infradead.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH 1/2] irqchip: irq-meson-gpio: make it possible to build
 as a module
Message-ID: <YQuZ2cKVE+3Os25Z@google.com>
References: <20201020072532.949137-2-narmstrong@baylibre.com>
 <7hsga8kb8z.fsf@baylibre.com>
 <CAF2Aj3g6c8FEZb3e1by6sd8LpKLaeN5hsKrrQkZUvh8hosiW9A@mail.gmail.com>
 <87r1hwwier.wl-maz@kernel.org>
 <7h7diwgjup.fsf@baylibre.com>
 <87im0m277h.wl-maz@kernel.org>
 <CAGETcx9OukoWM_qprMse9aXdzCE=GFUgFEkfhhNjg44YYsOQLw@mail.gmail.com>
 <87sfzpwq4f.wl-maz@kernel.org>
 <CAGETcx95kHrv8wA-O+-JtfH7H9biJEGJtijuPVN0V5dUKUAB3A@mail.gmail.com>
 <CAGETcx8bpWQEnkpJ0YW9GqX8WE0ewT45zqkbWWdZ0ktJBhG4yQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGETcx8bpWQEnkpJ0YW9GqX8WE0ewT45zqkbWWdZ0ktJBhG4yQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 04 Aug 2021, Saravana Kannan wrote:

> On Wed, Aug 4, 2021 at 11:20 AM Saravana Kannan <saravanak@google.com> wrote:
> >
> > On Wed, Aug 4, 2021 at 1:50 AM Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > On Wed, 04 Aug 2021 02:36:45 +0100,
> > > Saravana Kannan <saravanak@google.com> wrote:
> > >
> > > Hi Saravana,
> > >
> > > Thanks for looking into this.
> >
> > You are welcome. I just don't want people to think fw_devlink is broken :)
> >
> > >
> > > [...]
> > >
> > > > > Saravana, could you please have a look from a fw_devlink perspective?
> > > >
> > > > Sigh... I spent several hours looking at this and wrote up an analysis
> > > > and then realized I might be looking at the wrong DT files.
> > > >
> > > > Marc, can you point me to the board file in upstream that corresponds
> > > > to the platform in which you see this issue? I'm not asking for [1],
> > > > but the actual final .dts (not .dtsi) file that corresponds to the
> > > > platform/board/system.
> > >
> > > The platform I can reproduce this on is described in
> > > arch/arm64/boot/dts/amlogic/meson-sm1-khadas-vim3l.dts. It is an
> > > intricate maze of inclusion, node merge and other DT subtleties. I
> > > suggest you look at the decompiled version to get a view of the
> > > result.
> >
> > Thanks. After decompiling it, it looks something like (stripped a
> > bunch of reg and address properties and added the labels back):
> >
> > eth_phy: mdio-multiplexer@4c000 {
> >         compatible = "amlogic,g12a-mdio-mux";
> >         clocks = <0x02 0x13 0x1e 0x02 0xb1>;
> >         clock-names = "pclk\0clkin0\0clkin1";
> >         mdio-parent-bus = <0x22>;
> >
> >         ext_mdio: mdio@0 {
> >                 reg = <0x00>;
> >
> >                 ethernet-phy@0 {
> >                         max-speed = <0x3e8>;
> >                         interrupt-parent = <0x23>;
> >                         interrupts = <0x1a 0x08>;
> >                         phandle = <0x16>;
> >                 };
> >         };
> >
> >         int_mdio: mdio@1 {
> >                 ...
> >         }
> > }
> >
> > And phandle 0x23 refers to the gpio_intc interrupt controller with the
> > modular driver.
> >
> > > > Based on your error messages, it's failing for mdio@0 which
> > > > corresponds to ext_mdio. But none of the board dts files in upstream
> > > > have a compatible property for "ext_mdio". Which means fw_devlink
> > > > _should_ propagate the gpio_intc IRQ dependency all the way up to
> > > > eth_phy.
> > > >
> > > > Also, in the failing case, can you run:
> > > > ls -ld supplier:*
> > > >
> > > > in the /sys/devices/....<something>/ folder that corresponds to the
> > > > "eth_phy: mdio-multiplexer@4c000" DT node and tell me what it shows?
> > >
> > > Here you go:
> > >
> > > root@tiger-roach:~# find /sys/devices/ -name 'supplier*'|grep -i mdio | xargs ls -ld
> > > lrwxrwxrwx 1 root root 0 Aug  4 09:47 /sys/devices/platform/soc/ff600000.bus/ff64c000.mdio-multiplexer/supplier:platform:ff63c000.system-controller:clock-controller -> ../../../../virtual/devlink/platform:ff63c000.system-controller:clock-controller--platform:ff64c000.mdio-multiplexer
> >
> > As we discussed over chat, this was taken after the mdio-multiplexer
> > driver "successfully" probes this device. This will cause
> > SYNC_STATE_ONLY device links created by fw_devlink to be deleted
> > (because they are useless after a device probes). So, this doesn't
> > show the info I was hoping to demonstrate.
> >
> > In any case, one can see that fw_devlink properly created the device
> > link for the clocks dependency. So fw_devlink is parsing this node
> > properly. But it doesn't create a similar probe order enforcing device
> > link between the mdio-multiplexer and the gpio_intc because the
> > dependency is only present in a grand child DT node (ethernet-phy@0
> > under ext_mdio). So fw_devlink is working as intended.
> >
> > I spent several hours squinting at the code/DT yesterday. Here's what
> > is going on and causing the problem:
> >
> > The failing driver in this case is
> > drivers/net/mdio/mdio-mux-meson-g12a.c. And the only DT node it's
> > handling is what I pasted above in this email. In the failure case,
> > the call flow is something like this:
> >
> > g12a_mdio_mux_probe()
> > -> mdio_mux_init()
> > -> of_mdiobus_register(ext_mdio DT node)
> > -> of_mdiobus_register_phy(ext_mdio DT node)
> > -> several calls deep fwnode_mdiobus_phy_device_register(ethernet_phy DT node)
> > -> Tried to get the IRQ listed in ethernet_phy and fails with
> > -EPROBE_DEFER because the IRQ driver isn't loaded yet.
> >
> > The error is propagated correctly all the way up to of_mdiobus_register(), but
> > mdio_mux_init() ignores the -EPROBE_DEFER from of_mdiobus_register() and just
> > continues on with the rest of the stuff and returns success as long as
> > one of the child nodes (in this case int_mdio) succeeds.
> >
> > Since the probe returns 0 without really succeeding, networking stuff
> > just fails badly after this. So, IMO, the real problem is with
> > mdio_mux_init() not propagating up the -EPROBE_DEFER. I gave Marc a
> > quick hack (pasted at the end of this email) to test my theory and he
> > confirmed that it fixes the issue (a few deferred probes later, things
> > work properly).
> >
> > Andrew, I don't see any good reason for mdio_mux_init() not
> > propagating the errors up correctly (at least for EPROBE_DEFER). I'll
> > send a patch to fix this. Please let me know if there's a reason it
> > has to stay as-is.
> 
> I sent out the proper fix as a series:
> https://lore.kernel.org/lkml/20210804214333.927985-1-saravanak@google.com/T/#t
> 
> Marc, can you give it a shot please?
> 
> -Saravana

Superstar!  Thanks for taking the time to rectify this for all of us.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
