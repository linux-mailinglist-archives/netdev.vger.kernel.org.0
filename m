Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA7554829DF
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 07:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231687AbiABGC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 01:02:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbiABGCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 01:02:25 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15AF4C061746
        for <netdev@vger.kernel.org>; Sat,  1 Jan 2022 22:02:25 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id h21so39116189ljh.3
        for <netdev@vger.kernel.org>; Sat, 01 Jan 2022 22:02:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Iv0K/OnJ4x9KfFHJ0rMuNgjAIOFFIZXtmp5GzA9pOGE=;
        b=kbXmk9tr198z8pao9hHrPKf2/6KoiMTCjBYI5UoO7DR6FwK3vS+Y+F9/3Ze+BxLQvp
         IfXT/GtwJfVx2IdtpbYiUqh460czkPgKS7BR+FuMiIZ0GHazwnFhrNzn6s71X0HRG0YS
         YD0Cu0h0orwxGR5rbhIMnXonf/VBgml/3NcgoalHGzb23VlOsrUO0MNKCwpAyxAr0btU
         SQhmKxoqUUVf252ZCFucZE1RDIFYSpqTAixbrZlc5Cy/Fl3bp5zJXlyHNj1u7DXAaH3w
         VSH6H6Yl/P90PN2I/McvkhjudFH7wiLqxwV80iEyjv2SjFFj2ThhJ6DmPAOccSyu4Z7t
         W6HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Iv0K/OnJ4x9KfFHJ0rMuNgjAIOFFIZXtmp5GzA9pOGE=;
        b=WD/6JKLAjo0nHKKRccUww8BdyYPMkt+3QKT+1hzhoqKZ3adLKx6lljX8Atrf/qSh+t
         2m2xARIzebraMBTSOWcttTOb/KeLCoaLZQJba+1x0oKzDc95/WkR6vKqms7378FNOxy3
         WT5KPjsdt07XAtBCzplAsz2IFGo2MUgITc2fhWasLeT6HQez7W7uHQL8Vz5i1vwL+YDA
         qFR+7EFPQmegTfokbLw3h9zGlXGenavCDF3b/1sjMHjvAG6mZRSkwP4IA+eEyGKTYiNu
         YJP0i8+1x1cvjsWM24cUTxuRd+7dbeE22sFZxVePmCxd553r4cYaN8PROrwrBlw36lXz
         +oSQ==
X-Gm-Message-State: AOAM531Bcukl+IH4fVymgzsKJdcyAgwGPKIhI9uNbTs5nXt6qyHlCRk4
        lG7jgx6CBqIUxPOux2peo+BsLsKKChlcapO5jaSsNA==
X-Google-Smtp-Source: ABdhPJxvaWFPeqjDxRtZ5GOTtcaUxjX5EavoTj/qbHCqCtmPBlJ1yLcjqFSF/5y/WvhdRwObdm85gUse1YdzqzD+y7I=
X-Received: by 2002:a05:651c:623:: with SMTP id k35mr35551617lje.133.1641103343390;
 Sat, 01 Jan 2022 22:02:23 -0800 (PST)
MIME-Version: 1.0
References: <20211226153624.162281-1-marcan@marcan.st> <20211226153624.162281-21-marcan@marcan.st>
In-Reply-To: <20211226153624.162281-21-marcan@marcan.st>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sun, 2 Jan 2022 07:02:11 +0100
Message-ID: <CACRpkdY97WMk6KbQDT-_2=M7H7HrF5JDp3rPruc9oCXwm71k8w@mail.gmail.com>
Subject: Re: [PATCH 20/34] brcmfmac: pcie: Perform correct BCM4364 firmware selection
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

On Sun, Dec 26, 2021 at 4:39 PM Hector Martin <marcan@marcan.st> wrote:

> This chip exists in two revisions (B2=r3 and B3=r4) on different
> platforms, and was added without regard to doing proper firmware
> selection or differentiating between them. Fix this to have proper
> per-revision firmwares and support Apple NVRAM selection.
>
> Revision B2 is present on at least these Apple T2 Macs:
>
> kauai:    MacBook Pro 15" (Touch/2018-2019)
> maui:     MacBook Pro 13" (Touch/2018-2019)
> lanai:    Mac mini (Late 2018)
> ekans:    iMac Pro 27" (5K, Late 2017)
>
> And these non-T2 Macs:
>
> nihau:    iMac 27" (5K, 2019)
>
> Revision B3 is present on at least these Apple T2 Macs:
>
> bali:     MacBook Pro 16" (2019)
> trinidad: MacBook Pro 13" (2020, 4 TB3)
> borneo:   MacBook Pro 16" (2019, 5600M)
> kahana:   Mac Pro (2019)
> kahana:   Mac Pro (2019, Rack)
> hanauma:  iMac 27" (5K, 2020)
> kure:     iMac 27" (5K, 2020, 5700/XT)
>
> Fixes: 24f0bd136264 ("brcmfmac: add the BRCM 4364 found in MacBook Pro 15,2")
> Signed-off-by: Hector Martin <marcan@marcan.st>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
