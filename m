Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6711E636B25
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 21:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239068AbiKWUcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 15:32:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239683AbiKWUbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 15:31:14 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 488FB2AC66
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 12:27:50 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id o13so9034746ilc.7
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 12:27:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zjgLfIgymxMMYmWuqWPWGKjG2YLyiLx1k/rybg/+Fog=;
        b=emU5TDI2MbojzF3Rj6h9/mvm8hyJXNIpA51tkz1gHiTfQayAEsPBQ8c57EjdSVqccs
         Xpq979Mpem08d0+/EvxAUPsR+Td15FmnKynt9RhYPWjx0E7slJCcosYZi9ctJgx1ibhP
         +fMSCtofTjP2GUS0UXEl/zFIlGfM9kvYGhVlAgeRCcT6GbRqa94SKJY+IVClsHzo+JQk
         KcKif6hEWTbot7A42BaIG/7YCGRlXEulSixW6AIArWBoMfkUCAVTT2s0WHP6oYcLE1co
         Sx7qud7gmKaHb/Yo7syu7hcKZAeY1zbeghQZqWoP5OT3X6K7Y/N1m0yKn6JPrWrLUWe+
         M9Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zjgLfIgymxMMYmWuqWPWGKjG2YLyiLx1k/rybg/+Fog=;
        b=2M3mAB+yWRPTXQWCEgC3KcuQRLloep3mFV0LD7U+76I0eOEokUvSvzt3Zxq8QFmc/Q
         XiHuIQv5yT7j1JLH7JbPdsUKIKz1fKZ8DwB9Vf8E4mjzx4QDuCkiE2usBxpkkrUdCdSK
         KVVF36w//Zw2CISM+FQIN7u/DadOmTqveZxQDS2e/QNxDtmhRYh52edvwDBgsH58nW3y
         WBtEwl/LjfB+9H/O3TzKJKfDR34sM0ZnYc2RNyloIiiBeGRgfyMTVd2qqA5+wlAIQiUP
         FB6c7sohHHG5fvu8ErpFF6IlBt8LpbqytQQfYtqo4otmIZUsC8BpaL1xE2Ra3KynNcwF
         JsQA==
X-Gm-Message-State: ANoB5pkjJTYWrFso/z45MORX8X4iSDAwuiihEkqFOiDzqieiOoLF/X2S
        f9nd0GVfd0gV2kePlxBoHXgrIZL6LMEbDG0xdH4olA==
X-Google-Smtp-Source: AA0mqf59ynR8eDMr2FuXqeoM+2l8U8kyRTbLAClnQcYWMsZbsIH+WSZbh22svAe6rVnxi/kOupIIjWA5LwI+w3yB+ts=
X-Received: by 2002:a92:6e07:0:b0:300:1f82:73e5 with SMTP id
 j7-20020a926e07000000b003001f8273e5mr4494601ilc.85.1669235269478; Wed, 23 Nov
 2022 12:27:49 -0800 (PST)
MIME-Version: 1.0
References: <20221123124620.1387499-1-gregkh@linuxfoundation.org>
In-Reply-To: <20221123124620.1387499-1-gregkh@linuxfoundation.org>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Wed, 23 Nov 2022 12:27:37 -0800
Message-ID: <CANP3RGcno+UOsNTzqQ7XXjeOEQM+wseFramNNQyZ6U3bzc1yww@mail.gmail.com>
Subject: Re: [PATCH] USB: disable all RNDIS protocol drivers
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Kalle Valo <kvalo@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andrzej Pietrasiewicz <andrzejtp2010@gmail.com>,
        Jacopo Mondi <jacopo@jmondi.org>,
        =?UTF-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Ilja Van Sprundel <ivansprundel@ioactive.com>,
        Joseph Tartaro <joseph.tartaro@ioactive.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 4:46 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> The Microsoft RNDIS protocol is, as designed, insecure and vulnerable on
> any system that uses it with untrusted hosts or devices.  Because the
> protocol is impossible to make secure, just disable all rndis drivers to
> prevent anyone from using them again.
>
> Windows only needed this for XP and newer systems, Windows systems older
> than that can use the normal USB class protocols instead, which do not
> have these problems.
>
> Android has had this disabled for many years so there should not be any
> real systems that still need this.
>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Kalle Valo <kvalo@kernel.org>
> Cc: Oleksij Rempel <linux@rempel-privat.de>
> Cc: "Maciej =C5=BBenczykowski" <maze@google.com>
> Cc: Neil Armstrong <neil.armstrong@linaro.org>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Andrzej Pietrasiewicz <andrzejtp2010@gmail.com>
> Cc: Jacopo Mondi <jacopo@jmondi.org>
> Cc: "=C5=81ukasz Stelmach" <l.stelmach@samsung.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: linux-usb@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-wireless@vger.kernel.org
> Reported-by: Ilja Van Sprundel <ivansprundel@ioactive.com>
> Reported-by: Joseph Tartaro <joseph.tartaro@ioactive.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> Note, I'll submit patches removing the individual drivers for later, but
> that is more complex as unwinding the interaction between the CDC
> networking and RNDIS drivers is tricky.  For now, let's just disable all
> of this code as it is not secure.
>
> I can take this through the USB tree if the networking maintainers have
> no objection.  I thought I had done this months ago, when the last round
> of "there are bugs in the protocol!" reports happened at the end of
> 2021, but forgot to do so, my fault.
>
>  drivers/net/usb/Kconfig           | 1 +
>  drivers/net/wireless/Kconfig      | 1 +
>  drivers/usb/gadget/Kconfig        | 4 +---
>  drivers/usb/gadget/legacy/Kconfig | 3 +++
>  4 files changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
> index 4402eedb3d1a..83f9c0632642 100644
> --- a/drivers/net/usb/Kconfig
> +++ b/drivers/net/usb/Kconfig
> @@ -401,6 +401,7 @@ config USB_NET_MCS7830
>  config USB_NET_RNDIS_HOST
>         tristate "Host for RNDIS and ActiveSync devices"
>         depends on USB_USBNET
> +       depends on BROKEN
>         select USB_NET_CDCETHER
>         help
>           This option enables hosting "Remote NDIS" USB networking links,

NACK.

I'm perfectly okay with disabling the gadget (guest/client/device)
side rndis drivers.
New devices (ie. phones) moving to newer kernels should simply be
switching to the NCM gadget drivers.
Especially since AFAICT this won't land until 6.2 and thus will
presumably not be in the 6.1 LTS and thus won't even end up in next
year's Android 14/U,
and instead will only be present on the absolutely freshest Android
15/V devices launching near the end of 2024 (or really in early 2025).
Additionally the gadget side upstream RNDIS implementation simply
isn't used by some chipset vendors - like Qualcomm (which AFAIK uses
an out of tree driver to provide rndis gadget with IPA hardware
offload acceleration).

However, AFAICT this patch is also disabling *HOST* side RNDIS driver suppo=
rt.

ie. the RNDIS driver you'd use on a Linux laptop to usb tether off of
an Android phone.

AFAICT this will break usb tethering off of the *vast* majority of
Android phones - likely including most of those currently being
manufactured and sold.

The only Android phones I'm actually aware of that have switched to
NCM instead of RNDIS for usb tethering are Google Pixel 6+ (ie.
6/6pro/6a/7/7pro).
Though it's possible there might be some relatively new hardware from
other phone vendors that also uses NCM - I don't track this that
closely...
I do know Android 13/T doesn't require phones to use NCM for
tethering, and I've not heard of any plans to change that with Android
14/U either...

Note that NCM isn't natively supported by Windows <10 and it required
a fair bit of 'guts' on our side to drop support for usb tethering
Windows 8.1 devices prior to Win 8.1 EOL (which is only this coming
January).

Yes, AFAICT, this patch as currently written will break usb tethering
off of a Google Pixel ../3/4/5,
and I'd assume any and all qualcomm chipset derived devices, etc...

ie. most likely the first of these two and possibly the second are required=
:
CONFIG_USB_NET_RNDIS_HOST=3Dm
CONFIG_USB_NET_RNDIS_WLAN=3Dm

(AFAIK the rndis host side driver is also used by various cell dongles
and portable cell hotspots)

[I also don't understand the commit description where it talks about
Windows XP - how is XP relevant? AFAIK the issue is with Win<10 not
WinXP]

> diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
> index cb1c15012dd0..f162b25123d7 100644
> --- a/drivers/net/wireless/Kconfig
> +++ b/drivers/net/wireless/Kconfig
> @@ -81,6 +81,7 @@ config USB_NET_RNDIS_WLAN
>         tristate "Wireless RNDIS USB support"
>         depends on USB
>         depends on CFG80211
> +       depends on BROKEN
>         select USB_NET_DRIVERS
>         select USB_USBNET
>         select USB_NET_CDCETHER
> diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
> index 4fa2ddf322b4..2c99d4313064 100644
> --- a/drivers/usb/gadget/Kconfig
> +++ b/drivers/usb/gadget/Kconfig
> @@ -183,9 +183,6 @@ config USB_F_EEM
>  config USB_F_SUBSET
>         tristate
>
> -config USB_F_RNDIS
> -       tristate
> -
>  config USB_F_MASS_STORAGE
>         tristate
>
> @@ -297,6 +294,7 @@ config USB_CONFIGFS_RNDIS
>         bool "RNDIS"
>         depends on USB_CONFIGFS
>         depends on NET
> +       depends on BROKEN
>         select USB_U_ETHER
>         select USB_F_RNDIS
>         help
> diff --git a/drivers/usb/gadget/legacy/Kconfig b/drivers/usb/gadget/legac=
y/Kconfig
> index 0a7b382fbe27..03d6da63edf7 100644
> --- a/drivers/usb/gadget/legacy/Kconfig
> +++ b/drivers/usb/gadget/legacy/Kconfig
> @@ -153,6 +153,7 @@ config USB_ETH
>  config USB_ETH_RNDIS
>         bool "RNDIS support"
>         depends on USB_ETH
> +       depends on BROKEN
>         select USB_LIBCOMPOSITE
>         select USB_F_RNDIS
>         default y
> @@ -247,6 +248,7 @@ config USB_FUNCTIONFS_ETH
>  config USB_FUNCTIONFS_RNDIS
>         bool "Include configuration with RNDIS (Ethernet)"
>         depends on USB_FUNCTIONFS && NET
> +       depends on BROKEN
>         select USB_U_ETHER
>         select USB_F_RNDIS
>         help
> @@ -427,6 +429,7 @@ config USB_G_MULTI
>  config USB_G_MULTI_RNDIS
>         bool "RNDIS + CDC Serial + Storage configuration"
>         depends on USB_G_MULTI
> +       depends on BROKEN
>         select USB_F_RNDIS
>         default y
>         help
> --
> 2.38.1
>
Maciej =C5=BBenczykowski, Kernel Networking Developer @ Google
