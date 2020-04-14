Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17ECA1A8348
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 17:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440577AbgDNPik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 11:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2440500AbgDNPhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 11:37:32 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAC90C061A10
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 08:37:31 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id 8so531171oiy.6
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 08:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=spgEKsLHuoSv2vMq2/Lj/d/1/1xxZuCoTVcXDlhH9Ok=;
        b=QCa+HQiqSjjGQWMb/RlUNGNvWzhKgNJFUp8IYc5gSGyoBrGoNluUOC/wFoexVZ7Fi+
         +um4IaVWkfPhcQ8/g8hj7XRfww+n/f7r0rYzT2wXnDuXuIpqdfTFqTO9iq6N6T9a8GrQ
         GQ9eePSdjlTs3z7WBwR4w/0viLaAziacG3g8g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=spgEKsLHuoSv2vMq2/Lj/d/1/1xxZuCoTVcXDlhH9Ok=;
        b=VAn8LFl1uDpqT5C8xCeABYljDSvIjiXhi3kgocqshHwUWB6+rAHwmHfTSdM+KNEfhT
         988OPCeQu1ZaWMwxhqDsgGeynM4GVb1ID6t2Y2Ial5JL6cxUQygPxZDB49ZreMc9HGMx
         kQuaHKZtmlK8eRke0WoCFA/kWImXXT2nWJ3rWYNRojGez0tGS6UBmxJ/bc3CLCx09jX9
         mZV3HZRNMlW880CYkpxRl3g/38kVU+uBu5iZRuprof7dK9vZQ4grthJGKvWBi8Yjv7M5
         9HRYqOhxavEYXL2ADP5JQdaJXpXM5zjxUyKJOY4Wnyjso3eExSYqbK4M2EEaV80AFULM
         9T4Q==
X-Gm-Message-State: AGi0PubyqfHE1GfQXIo2qA825f71up92YXfBPBDKcE3kpzeCUBXRrIgW
        smkOVCaRwVUK8qgTVQrkxhB4pX6JIt5zLNSTKkRIYw==
X-Google-Smtp-Source: APiQypLsvLDVhQlSCSYfwXakR2y/dcpDVgVfmQK0C2JClQk86N/kbNsZ8j+53xoehuEj3kRAtjmVc4hh5VckYQcEdUg=
X-Received: by 2002:aca:2113:: with SMTP id 19mr10130356oiz.128.1586878650635;
 Tue, 14 Apr 2020 08:37:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200408202711.1198966-1-arnd@arndb.de> <CGME20200408202802eucas1p13a369a5c584245a1affee35d2c8cad32@eucas1p1.samsung.com>
 <20200408202711.1198966-5-arnd@arndb.de> <ff7809b6-f566-9c93-1838-610be5d22431@samsung.com>
 <CAK8P3a2BXZAiHh83RZJ-v9HvoE1gSED59j8k0ydJKCnHzwYz=w@mail.gmail.com>
In-Reply-To: <CAK8P3a2BXZAiHh83RZJ-v9HvoE1gSED59j8k0ydJKCnHzwYz=w@mail.gmail.com>
From:   Daniel Vetter <daniel@ffwll.ch>
Date:   Tue, 14 Apr 2020 17:37:18 +0200
Message-ID: <CAKMK7uGpRkPsNqFR=taD68dT8T2tnEhias380ayGnjMH1b09xg@mail.gmail.com>
Subject: Re: [RFC 4/6] drm/bridge/sii8620: fix extcon dependency
To:     Arnd Bergmann <arnd@arndb.de>,
        "Nikula, Jani" <jani.nikula@linux.intel.com>
Cc:     Andrzej Hajda <a.hajda@samsung.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Leon Romanovsky <leon@kernel.org>,
        Jonas Karlman <jonas@kwiboo.se>,
        David Airlie <airlied@linux.ie>,
        Networking <netdev@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-rdma <linux-rdma@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 5:05 PM Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Fri, Apr 10, 2020 at 8:56 AM Andrzej Hajda <a.hajda@samsung.com> wrote:
> >
> >
> > On 08.04.2020 22:27, Arnd Bergmann wrote:
> > > Using 'imply' does not work here, it still cause the same build
> > > failure:
> > >
> > > arm-linux-gnueabi-ld: drivers/gpu/drm/bridge/sil-sii8620.o: in function `sii8620_remove':
> > > sil-sii8620.c:(.text+0x1b8): undefined reference to `extcon_unregister_notifier'
> > > arm-linux-gnueabi-ld: drivers/gpu/drm/bridge/sil-sii8620.o: in function `sii8620_probe':
> > > sil-sii8620.c:(.text+0x27e8): undefined reference to `extcon_find_edev_by_node'
> > > arm-linux-gnueabi-ld: sil-sii8620.c:(.text+0x2870): undefined reference to `extcon_register_notifier'
> > > arm-linux-gnueabi-ld: drivers/gpu/drm/bridge/sil-sii8620.o: in function `sii8620_extcon_work':
> > > sil-sii8620.c:(.text+0x2908): undefined reference to `extcon_get_state'
> > >
> > > I tried the usual 'depends on EXTCON || !EXTCON' logic, but that caused
> > > a circular Kconfig dependency. Using IS_REACHABLE() is ugly but works.
> >
> > 'depends on EXTCON || !EXTCON' seems to be proper solution, maybe would be better to try to solve circular dependencies issue.
>
> I agree that would be nice, but I failed to come to a proper solution
> here. FWIW, there
> is one circular dependency that I managed to avoid by changing all
> drivers that select FB_DDC
> to depend on I2C rather than selecting it:
>
> drivers/i2c/Kconfig:8:error: recursive dependency detected!
> drivers/i2c/Kconfig:8: symbol I2C is selected by FB_DDC
> drivers/video/fbdev/Kconfig:63: symbol FB_DDC depends on FB
> drivers/video/fbdev/Kconfig:12: symbol FB is selected by DRM_KMS_FB_HELPER
> drivers/gpu/drm/Kconfig:80: symbol DRM_KMS_FB_HELPER depends on DRM_KMS_HELPER
> drivers/gpu/drm/Kconfig:74: symbol DRM_KMS_HELPER is selected by DRM_SIL_SII8620
> drivers/gpu/drm/bridge/Kconfig:89: symbol DRM_SIL_SII8620 depends on EXTCON
> drivers/extcon/Kconfig:2: symbol EXTCON is selected by CHARGER_MANAGER
> drivers/power/supply/Kconfig:482: symbol CHARGER_MANAGER depends on POWER_SUPPLY
> drivers/power/supply/Kconfig:2: symbol POWER_SUPPLY is selected by
> HID_BATTERY_STRENGTH
> drivers/hid/Kconfig:29: symbol HID_BATTERY_STRENGTH depends on HID
> drivers/hid/Kconfig:8: symbol HID is selected by I2C_HID
> drivers/hid/i2c-hid/Kconfig:5: symbol I2C_HID depends on I2C
>
> After that, Kconfig crashes with a segfault:
>
> drivers/video/fbdev/Kconfig:12:error: recursive dependency detected!
> drivers/video/fbdev/Kconfig:12: symbol FB is selected by DRM_KMS_FB_HELPER
> drivers/gpu/drm/Kconfig:80: symbol DRM_KMS_FB_HELPER depends on DRM_KMS_HELPER
> drivers/gpu/drm/Kconfig:74: symbol DRM_KMS_HELPER is selected by DRM_SIL_SII8620
> drivers/gpu/drm/bridge/Kconfig:89: symbol DRM_SIL_SII8620 depends on EXTCON
> drivers/extcon/Kconfig:2: symbol EXTCON is selected by CHARGER_MANAGER
> drivers/power/supply/Kconfig:482: symbol CHARGER_MANAGER depends on POWER_SUPPLY
> drivers/power/supply/Kconfig:2: symbol POWER_SUPPLY is selected by HID_ASUS
> drivers/hid/Kconfig:150: symbol HID_ASUS depends on LEDS_CLASS
> drivers/leds/Kconfig:17: symbol LEDS_CLASS depends on NEW_LEDS
> drivers/leds/Kconfig:9: symbol NEW_LEDS is selected by SENSORS_APPLESMC
> drivers/hwmon/Kconfig:327: symbol SENSORS_APPLESMC depends on HWMON
> drivers/hwmon/Kconfig:6: symbol HWMON is selected by EEEPC_LAPTOP
> drivers/platform/x86/Kconfig:260: symbol EEEPC_LAPTOP depends on ACPI_VIDEO
> make[3]: *** [/git/arm-soc/scripts/kconfig/Makefile:71: randconfig]
> Segmentation fault (core dumped)
>
> After changing EEEPC_LAPTOP and THINKPAD_ACPI to 'depends on HWMON' instead of
> 'select HWMON', I get this one:
>
> drivers/video/fbdev/Kconfig:12:error: recursive dependency detected!
> drivers/video/fbdev/Kconfig:12: symbol FB is selected by DRM_KMS_FB_HELPER
> drivers/gpu/drm/Kconfig:80: symbol DRM_KMS_FB_HELPER depends on DRM_KMS_HELPER
> drivers/gpu/drm/Kconfig:74: symbol DRM_KMS_HELPER is selected by DRM_SIL_SII8620
> drivers/gpu/drm/bridge/Kconfig:89: symbol DRM_SIL_SII8620 depends on EXTCON
> drivers/extcon/Kconfig:2: symbol EXTCON is selected by CHARGER_MANAGER
> drivers/power/supply/Kconfig:482: symbol CHARGER_MANAGER depends on POWER_SUPPLY
> drivers/power/supply/Kconfig:2: symbol POWER_SUPPLY is selected by HID_ASUS
> drivers/hid/Kconfig:150: symbol HID_ASUS depends on LEDS_CLASS
> drivers/leds/Kconfig:17: symbol LEDS_CLASS depends on NEW_LEDS
> drivers/leds/Kconfig:9: symbol NEW_LEDS is selected by BACKLIGHT_ADP8860
> drivers/video/backlight/Kconfig:316: symbol BACKLIGHT_ADP8860 depends
> on BACKLIGHT_CLASS_DEVICE
> drivers/video/backlight/Kconfig:143: symbol BACKLIGHT_CLASS_DEVICE is
> selected by FB_BACKLIGHT
> drivers/video/fbdev/Kconfig:187: symbol FB_BACKLIGHT depends on FB
>
> Changing all drivers that select 'FB_BACKLIGHT' or 'BACKLIGHT_CLASS_DEVICE' to
> 'depends on BACKLIGHT_CLASS_DEVICE' gets it to build.
>
> The steps each seem reasonable, in particular since they mostly clean
> up the legacy
> fbdev drivers to what they should have done anyway, but it is quite
> invasive in the end.
> Any other ideas?

Adding Jani, since iirc he looked at the entire backlight Kconfig
story before. I think there's some nonsense going on where in some
cases you don't get reasonable dummy functions where it just doesn't
make sense. Or something like that.

At least the entire select vs depends on backlight sounds eerily familiar.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
