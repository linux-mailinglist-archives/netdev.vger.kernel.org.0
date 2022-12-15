Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84AB064DDE1
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 16:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbiLOPeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 10:34:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbiLOPef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 10:34:35 -0500
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A64F227DD0;
        Thu, 15 Dec 2022 07:34:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1671118473; x=1702654473;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=Pbv+9uskzHcZxO+SbrV0Ayv08NAC2/6QX40jMpNz+ec=;
  b=iDngaLkLdUadayjQuoS6OgbWNyXU+NwKkpckDLc/WZfCrqII92N/5nek
   X59uHkMArlbTIu7K90Hf9D8weYdbT1snFIr7gSgrEYvLBtpOqZhoRnooI
   hcgAA8tPQtjvJcrfMrBzwxphmrXlHP3v6CZ4KRSa57AEmAR32+hyUrHQR
   Y+pe7LLFEyBu2JN5jkyrLlMpNZsro50w61THYTegbwgF4Wvjagp423s30
   l0MovMpZpWUNGwYxCs7nPzIn8gTBJYFYYO5/LLprzt1seZhAUIPZTid11
   2Nbfo2brszjWDavl1MSLrZGqHQVXEw78302/zLJBLFtn3bVXmftNFBh2G
   w==;
X-IronPort-AV: E=Sophos;i="5.96,247,1665439200"; 
   d="scan'208";a="27979871"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 15 Dec 2022 16:34:31 +0100
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Thu, 15 Dec 2022 16:34:31 +0100
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Thu, 15 Dec 2022 16:34:31 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1671118471; x=1702654471;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=Pbv+9uskzHcZxO+SbrV0Ayv08NAC2/6QX40jMpNz+ec=;
  b=M4S91W/h+ejIrLfU6Ue1puG4c+60xSJGg6ZTF9jDtf9xJTinCZ2mnKhn
   NMdANXj7C2U/UH8bnCh53dLkhM9CFpE4DhEqBd2WKG3XwRbJtitziUjJn
   mffeisT7krO2qzC7BT12s1tYvxvmuA2nn/b4xwz/MZo8gZABvXHiuwysC
   Ek/MEFu0C+SNo8GvVCtEumHHGPLctRcUMpTLEgSICYeI8BnPB1bRfyXmz
   z3hEwcLucmOpJSU8swB36fVaTwD22vjtunOVVdlWCv5gq3YLj0rZFqdaW
   NAcLVdgjao1SEQZnFg7rcvjiBiMVORR3kbSDrov9N1/j0wvOygdxHeTSV
   A==;
X-IronPort-AV: E=Sophos;i="5.96,247,1665439200"; 
   d="scan'208";a="27979870"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 15 Dec 2022 16:34:30 +0100
Received: from steina-w.localnet (unknown [10.123.53.21])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by vtuxmail01.tq-net.de (Postfix) with ESMTPSA id 9F3C0280071;
        Thu, 15 Dec 2022 16:34:30 +0100 (CET)
From:   Alexander Stein <alexander.stein@ew.tq-group.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        Christian Marangi <ansuelsmth@gmail.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        Tim Harvey <tharvey@gateworks.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Christian Marangi <ansuelsmth@gmail.com>
Subject: Re: [PATCH v7 00/11] Adds support for PHY LEDs with offload triggers
Date:   Thu, 15 Dec 2022 16:34:30 +0100
Message-ID: <2379211.Icojqenx9y@steina-w>
Organization: TQ-Systems GmbH
In-Reply-To: <20221214235438.30271-1-ansuelsmth@gmail.com>
References: <20221214235438.30271-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

thanks for the new series.

Am Donnerstag, 15. Dezember 2022, 00:54:27 CET schrieb Christian Marangi:
> This is another attempt on adding this feature on LEDs, hoping this is
> the right time and someone finally notice this.

Unfortunately I'm out of office from next week on, so there is only limited 
feedback from my side.

> Most of the times Switch/PHY have connected multiple LEDs that are
> controlled by HW based on some rules/event. Currently we lack any
> support for a generic way to control the HW part and normally we
> either never implement the feature or only add control for brightness
> or hw blink.
> 
> This is based on Marek idea of providing some API to cled but use a
> different implementation that in theory should be more generilized.
> 
> The current idea is:
> - LED driver implement 3 API (hw_control_status/start/stop).
>   They are used to put the LED in hardware mode and to configure the
>   various trigger.
> - We have hardware triggers that are used to expose to userspace the
>   supported hardware mode and set the hardware mode on trigger
>   activation.
> - We can also have triggers that both support hardware and software mode.
> - The LED driver will declare each supported hardware blink mode and
>   communicate with the trigger all the supported blink modes that will
>   be available by sysfs.
> - A trigger will use blink_set to configure the blink mode to active
>   in hardware mode.
> - On hardware trigger activation, only the hardware mode is enabled but
>   the blink modes are not configured. The LED driver should reset any
>   link mode active by default.

I'm a bit confused about that blink mode is supposed to mean. I don't know 
what to implement for blink_set. Reading qca8k_cled_blink_set it seems to just 
configure the blink interval for the corresponding LED.
Unfortunately that's not possible for all PHYs. In my case, DP83867, I can 
configure the blink interval only globally. I'm not sure how this will fit 
into this LED trigger.

> Each LED driver will have to declare explicit support for the offload
> trigger (or return not supported error code) as we the trigger_data that
> the LED driver will elaborate and understand what is referring to (based
> on the current active trigger).
> 
> I posted a user for this new implementation that will benefit from this
> and will add a big feature to it. Currently qca8k can have up to 3 LEDs
> connected to each PHY port and we have some device that have only one of
> them connected and the default configuration won't work for that.

My DP83867 proof of concept implementation also supports several LEDs, but my 
actual hardware also only has 2 of them attached (LED0 and LED2).

Best regards,
Alexander

> The netdev trigger is expanded and it does now support hardware only
> triggers.
> The idea is to use hardware mode when a device_name is not defined.
> An additional sysfs entry is added to give some info about the available
> trigger modes supported in the current configuration.
> 
> 
> It was reported that at least 3 other switch family would benefits by
> this as they all lack support for a generic way to setup their leds and
> netdev team NACK each try to add special code to support LEDs present
> on switch in favor of a generic solution.
> 
> v7:
> - Rebase on top of net-next (for qca8k changes)
> - Fix some typo in commit description
> - Fix qca8k leds documentation warning
> - Remove RFC tag
> v6:
> - Back to RFC.
> - Drop additional trigger
> - Rework netdev trigger to support common modes used by switch and
>   hardware only triggers
> - Refresh qca8k leds logic and driver
> v5:
> - Move out of RFC. (no comments from Andrew this is the right path?)
> - Fix more spelling mistake (thx Randy)
> - Fix error reported by kernel test bot
> - Drop the additional HW_CONTROL flag. It does simplify CONFIG
>   handling and hw control should be available anyway to support
>   triggers as module.
> v4:
> - Rework implementation and drop hw_configure logic.
>   We now expand blink_set.
> - Address even more spelling mistake. (thx a lot Randy)
> - Drop blink option and use blink_set delay.
> - Rework phy-activity trigger to actually make the groups dynamic.
> v3:
> - Rework start/stop as Andrew asked.
> - Introduce more logic to permit a trigger to run in hardware mode.
> - Add additional patch with netdev hardware support.
> - Use test_bit API to check flag passed to hw_control_configure.
> - Added a new cmd to hw_control_configure to reset any active blink_mode.
> - Refactor all the patches to follow this new implementation.
> v2:
> - Fix spelling mistake (sorry)
> - Drop patch 02 "permit to declare supported offload triggers".
>   Change the logic, now the LED driver declare support for them
>   using the configure_offload with the cmd TRIGGER_SUPPORTED.
> - Rework code to follow this new implementation.
> - Update Documentation to better describe how this offload
>   implementation work.
> 
> Christian Marangi (11):
>   leds: add support for hardware driven LEDs
>   leds: add function to configure hardware controlled LED
>   leds: trigger: netdev: drop NETDEV_LED_MODE_LINKUP from mode
>   leds: trigger: netdev: rename and expose NETDEV trigger enum modes
>   leds: trigger: netdev: convert device attr to macro
>   leds: trigger: netdev: add hardware control support
>   leds: trigger: netdev: use mutex instead of spinlocks
>   leds: trigger: netdev: add available mode sysfs attr
>   leds: trigger: netdev: add additional hardware only triggers
>   net: dsa: qca8k: add LEDs support
>   dt-bindings: net: dsa: qca8k: add LEDs definition example
> 
>  .../devicetree/bindings/net/dsa/qca8k.yaml    |  24 ++
>  Documentation/leds/leds-class.rst             |  53 +++
>  drivers/leds/Kconfig                          |  11 +
>  drivers/leds/led-class.c                      |  27 ++
>  drivers/leds/led-triggers.c                   |  29 ++
>  drivers/leds/trigger/ledtrig-netdev.c         | 385 ++++++++++++-----
>  drivers/net/dsa/qca/Kconfig                   |   9 +
>  drivers/net/dsa/qca/Makefile                  |   1 +
>  drivers/net/dsa/qca/qca8k-8xxx.c              |   4 +
>  drivers/net/dsa/qca/qca8k-leds.c              | 406 ++++++++++++++++++
>  drivers/net/dsa/qca/qca8k.h                   |  62 +++
>  include/linux/leds.h                          | 103 ++++-
>  12 files changed, 1015 insertions(+), 99 deletions(-)
>  create mode 100644 drivers/net/dsa/qca/qca8k-leds.c




