Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 006864829CA
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 06:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbiABF66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 00:58:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiABF65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 00:58:57 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB3AC061574
        for <netdev@vger.kernel.org>; Sat,  1 Jan 2022 21:58:56 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id i31so68408025lfv.10
        for <netdev@vger.kernel.org>; Sat, 01 Jan 2022 21:58:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bSBWxZAgSh0F54j/W0JNACuedJrvZPCXn3NUacLAWAs=;
        b=xfg8suVrm9P/SE7AdiXsHlWDQCgV9QerWMwbs5J0qaaL+q/cGzNmaNHkektSHPxENR
         tpVgAnxYTk9dDyswvuLhRGdUtI+FZS2VAKb6Rg7eo8lrin5WIIRobA58muB02Xa1PoY1
         c1iqEWaCH3ifdI3cESwDq05BrLIkNWWwFIfIj95iHy5Sq8pw0ygefiVkbwTehPbijY5k
         5f+NPB7kzk0BEN9dyY8B9x2Ef2SkVMMslQv03bQdhFg7ocJResUC0zlWkxcS91GukjN5
         cmfJwQlMIEbO1TQTm7JYSCqc4MBan5hzFYmhviEjeKPzf0jZ3N8quph+T9Yl4YfqJg4I
         xINw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bSBWxZAgSh0F54j/W0JNACuedJrvZPCXn3NUacLAWAs=;
        b=IL8YOqgSpCKZVIv94bXvNi24rP+v8csw8+pLGoSOj0Hu77X+ukPv8Qx1Z6u5UPEkWJ
         KDIwV7b02VgkR5u2cwJVxuZ1WaKYswBOguPnVrpuzkv2rV3fo8XrOicw/l5DbCVZauo4
         2MSJwomjm0nVx9fb5NhUAC3ZzT0yupxiRyCmmiuaaXBdaKmyKZtOUwE0YKdhU6yhMy43
         msmMSL/lmbn2cv26qQ6t1lqzOGmE3da+LusVbKYBUSM2wHlPPtvsofJkgQgwsLlLnCzu
         SHkoy6Phzy/JwgxVN54m33bDYGX9IRwSKxf8ZRrBdSX3YzaWlFVgPevmi+3VP4XU0x2O
         HhhQ==
X-Gm-Message-State: AOAM531ydHKvtvyJEYjMjiM7Wm7g0JjKfA8iB0u5545uFBYAZspY2Yof
        PnAg3oYeFolXzP6RQ2cIDlfRqUys2XhJB+AXs6m5PQ==
X-Google-Smtp-Source: ABdhPJynY3yVg7Hfnyy1ssZ5OlY8mA09ggXgxRHaHInLiaVgaTCb83EMZe0WSHeP+X1H4U22LXxCPkKiJpBEMn8zasg=
X-Received: by 2002:a05:6512:39ce:: with SMTP id k14mr19031566lfu.508.1641103135050;
 Sat, 01 Jan 2022 21:58:55 -0800 (PST)
MIME-Version: 1.0
References: <20211226153624.162281-1-marcan@marcan.st> <20211226153624.162281-17-marcan@marcan.st>
In-Reply-To: <20211226153624.162281-17-marcan@marcan.st>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sun, 2 Jan 2022 06:58:42 +0100
Message-ID: <CACRpkdbWs=5s-5qZXoDOf+f-y=c6XZOGZb7w0LL7bDEJpnnVpw@mail.gmail.com>
Subject: Re: [PATCH 16/34] brcmfmac: acpi: Add support for fetching Apple ACPI properties
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

> On DT platforms, the module-instance and antenna-sku-info properties
> are passed in the DT. On ACPI platforms, module-instance is passed via
> the analogous Apple device property mechanism, while the antenna SKU
> info is instead obtained via an ACPI method that grabs it from
> non-volatile storage.
>
> Add support for this, to allow proper firmware selection on Apple
> platforms.
>
> Signed-off-by: Hector Martin <marcan@marcan.st>

If the strings treated here are exactly the same as for the device tree,
you should be able to just use "devprops" (firmware node) to handle it
abstractly, and then the respective DT and ACPI backend will provide
the properties.

I don't know if this patch I made recently is enough of an examples:
https://lore.kernel.org/linux-hwmon/20211206020423.62402-2-linus.walleij@linaro.org/

If the ACPI and DT differs a lot in format and strings etc it may not
be worth it.

Yours,
Linus Walleij
