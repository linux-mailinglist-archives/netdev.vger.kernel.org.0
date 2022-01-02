Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22938482A00
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 07:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbiABGN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 01:13:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231761AbiABGN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 01:13:28 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 348EBC061746
        for <netdev@vger.kernel.org>; Sat,  1 Jan 2022 22:13:28 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id x4so33506913ljc.6
        for <netdev@vger.kernel.org>; Sat, 01 Jan 2022 22:13:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PQZLwT+w1+Y2g2ul+2mg6iUoYfiNjzZt86lCdfnWPtA=;
        b=AW/ZNbPSLW468zW/twl9o/cgXt0oE2gt8F4kyzPQGwiulKCrpOaWwAM0cyUJ1FPKJk
         A6QNbIDZTy9H6jycg5ZpeCoAvVEmfyIIjdo3JyNI2Bhc+9jijMoFpYbDWad9ao1nxGzv
         l2D6ltASDWxaZJpXCGXEYIRszLKvpLrBVLODpBTSIWex436szk5LoV/gKPejKrDnng1z
         4BI5m2do8sdvrhOCT7NxgfYh1xc9b0e0LKCI6S7MtVpl6KHt977Da09LB2yfTeDOrSL6
         UEMNeDcgaXkmkUG3wWnTXp3OHn23qojCG9T0srXLdJc4wmrqdKZafnFL67r2CQFmmMiN
         BtLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PQZLwT+w1+Y2g2ul+2mg6iUoYfiNjzZt86lCdfnWPtA=;
        b=X3+6ylx0F/Eti5BLKvSW1K6g98C7njjFypBQjojpHqKYPRiSerwyQka2CjTZu+6dCm
         Gohw88JvxlV8gSzxtIp735GS+Hu9oc2KmU6faj+trDomArILtlvOfmceXpd4Tbqqfz9Z
         dgaMHw9h6LQoEU3Dg5AvPMgUghGLT2v3X9s5hCtThgUY5J0Y7bIZpwIO08j0eZeG3k5c
         QzsPMqv5pjw7/+bohpA6F65hIPacDGKpUa+LmlSGukLSzkDMOzSRW6rACnhTjwm5p2gw
         zD0Yg9O8EMzu715LFtX8gliE+W5N3UbWgzMtqrx2/T9vjQaV73BnTTTGJhXbt67JzIvj
         5c+w==
X-Gm-Message-State: AOAM531cszlKWo0KsyxBx3XIZPEpG5SXOjli7/mCjQEwr8plSqH6bS56
        k4VmpVMYj8vJYbpku5d+RpLBEptfg6Zgp1J8US3arA==
X-Google-Smtp-Source: ABdhPJxM2f7u0RlwdZkYufWQhioNOnTnjJqHgjzjatwX6cpu+GxEYVnS/6kGtZs3QlqQ09MrlhCLnoOvUxy7A8YmozA=
X-Received: by 2002:a05:651c:623:: with SMTP id k35mr35568925lje.133.1641104006495;
 Sat, 01 Jan 2022 22:13:26 -0800 (PST)
MIME-Version: 1.0
References: <20211226153624.162281-1-marcan@marcan.st> <20211226153624.162281-27-marcan@marcan.st>
In-Reply-To: <20211226153624.162281-27-marcan@marcan.st>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sun, 2 Jan 2022 07:13:13 +0100
Message-ID: <CACRpkdZ4w1Ftq+UcpmYVzcESG-2tJTkUs8RViqRPv9EKmL4NLg@mail.gmail.com>
Subject: Re: [PATCH 26/34] brcmfmac: cfg80211: Pass the PMK in binary instead
 of hex
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

On Sun, Dec 26, 2021 at 4:40 PM Hector Martin <marcan@marcan.st> wrote:

> Apparently the hex passphrase mechanism does not work on newer
> chips/firmware (e.g. BCM4387). It seems there was a simple way of
> passing it in binary all along, so use that and avoid the hexification.
>
> OpenBSD has been doing it like this from the beginning, so this should
> work on all chips.
>
> Also clear the structure before setting the PMK. This was leaking
> uninitialized stack contents to the device.
>
> Signed-off-by: Hector Martin <marcan@marcan.st>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
