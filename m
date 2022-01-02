Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38E2B4829CF
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 07:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbiABGAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 01:00:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbiABGAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 01:00:07 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECC52C061574
        for <netdev@vger.kernel.org>; Sat,  1 Jan 2022 22:00:06 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id r22so50948718ljk.11
        for <netdev@vger.kernel.org>; Sat, 01 Jan 2022 22:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Rjti7d90WP8Xg6Hp0kYEpjGAZMuupp9s0gpIcrJvVXQ=;
        b=L1tmfP4ShxzOgVIz2PEl+IiE+pc1ShqKkzJJ3FuYtfcWHhlrJjkBbrlzQHfZfIdCUM
         PXAkJt+SUZEoMSaVFBM3Nq06zF4p2yiOFu7CRXwL5CtCCJa1tzVSU5SW2HmWTE4Y0Vom
         MGbq/EvQRtsdpZ8mkfr+feE+xoqZk4AVLIt9U2HW06NUr1jOQ82yEcjRbpe9tprarXF4
         BoDEEUZ/qPvEThxmwys0ZFwWAh4kYjvLJ43MsSpmPzAa+EoHrzVb7nspqlRkMVUpuW4d
         WSoB4RqbFdaXgtm3ufJy+Rjle+oc1q5LstR9kV6Jnr2vNbOE2iUpez/gxylWrX2HZOC0
         lqMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Rjti7d90WP8Xg6Hp0kYEpjGAZMuupp9s0gpIcrJvVXQ=;
        b=TPE+HShn1IelI3nWnSQpJbNMzZ+sGN8q5Ffhb8eT7hoXgV7aZR3MwH65eOza41xW7z
         dKpXrMGL6uuSuarXpmDVr25o/BPz5Yt8sNDrMwkNCaeMiCXnazo/TvGiXY1v/qpKMv5w
         0/T/dzXTyAvSu6K6P98UMQg1wutgIVyb18zu78d+X5Z/FHgcwNMUn45h7drPkwFeL52e
         K/xlV+MITOsY6SyfbrmCzde7Pj3hN01GScHRVluE8WnXW0hagWGqsQQZwnj/ry7zsZR8
         1wGqQGdsJ8Eh1Fj4cviRROotS1xBOIbyo0trWoRPOwXmTckAjd73C+W4GYs36dhOWJH7
         fR1A==
X-Gm-Message-State: AOAM531PtWrKDelCrihvIQ21BkrYqZckeB6w1hWz/51c/Shwg9Uxjtie
        2XtfmVTEF0hNLZTyJsdHEClmTy3bJFSMKBtAimbz2Q==
X-Google-Smtp-Source: ABdhPJyv1Mvd6Mp+D18WKgLy8no0MQSmte5uMFeAHGA5tMcWXaralMbmZV5qMWOi9pa6EMdURgIDyO+USZ9oJ0EGv5k=
X-Received: by 2002:a2e:b808:: with SMTP id u8mr24152647ljo.282.1641103205129;
 Sat, 01 Jan 2022 22:00:05 -0800 (PST)
MIME-Version: 1.0
References: <20211226153624.162281-1-marcan@marcan.st> <20211226153624.162281-18-marcan@marcan.st>
In-Reply-To: <20211226153624.162281-18-marcan@marcan.st>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sun, 2 Jan 2022 06:59:52 +0100
Message-ID: <CACRpkda=bD6BRVko5MZOnfLbKxLVbrwYmv4T4NSwY1vq9AGoTw@mail.gmail.com>
Subject: Re: [PATCH 17/34] brcmfmac: pcie: Provide a buffer of random bytes to
 the device
To:     Hector Martin <marcan@marcan.st>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Daniel (Deognyoun) Kim" <dekim@broadcom.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 26, 2021 at 4:38 PM Hector Martin <marcan@marcan.st> wrote:

> Newer Apple firmwares on chipsets without a hardware RNG require the
> host to provide a buffer of 256 random bytes to the device on
> initialization. This buffer is present immediately before NVRAM,
> suffixed by a footer containing a magic number and the buffer length.
>
> This won't affect chips/firmwares that do not use this feature, so do it
> unconditionally.
>
> Signed-off-by: Hector Martin <marcan@marcan.st>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
