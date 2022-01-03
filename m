Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE5048305B
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 12:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbiACLPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 06:15:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbiACLPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 06:15:04 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC66C061799
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 03:15:04 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id a26-20020a9d6e9a000000b0058f37eeb861so40773178otr.9
        for <netdev@vger.kernel.org>; Mon, 03 Jan 2022 03:15:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fAa5qBTWMNqav9vIr3Fk0gv7glNbc0fpvfZZDW8y3qw=;
        b=DPhbxHZXVLBQgvjBjVMRRm/S3fMu9gJX9VFXmPACLHk6waVE+XwwvGDZQ0FxhgUr5X
         H+djmebIMwj1mEe+RHWCO6RRhiF4n/4KwUv8ywEhQ9N+3nq837hnEmvthI8Zzi8WxKoy
         Hes4o6db7tUV8pkguW9spmpFQzZLkiXNsDj+H5NdqNtU4irvyc2s+kkIRr83PaxhFspB
         nMgSGDbmP634hPtb8jNaGeFSAVgJe9C/4diGS/qXrX9FLjy2x8qTyFfWGl/LqjsFfGXg
         HOLE1ZrMevIKm0dq1MKEXjjb2TOaSU85zaio6JvssKYy8B5DPH0lQEaGWl3//6tNyCY9
         wGfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fAa5qBTWMNqav9vIr3Fk0gv7glNbc0fpvfZZDW8y3qw=;
        b=ltcDxpoNn4ZZ+GbXCPHfeKcoXu0XzV8GN5BxexfTvFatJ6F7yPLjDOVE2qqFRZk6Qu
         ydE7V/+NoxkBSYT37SQ4vFkTLy1eCTKrOvtRsb36HFq1axJJBmZZcMubCQXgca2tbH7E
         58D6IlYe50FbXb5DiNRU33bi/joxaXpUlCkMCbP6732G9STZTEB+zw1W3Yl0gELcTljX
         tLdYzdtc+FZ5ThKxXSRDxH+yOTgHEOHFcKYOLymoSPmaS6gCvnLIbUr9NytJzwB1cG47
         IyqSY5o8/4NDlYUWTRWMNds05j4PNU743kc5iATofhgm+pm4RRN8hwvoNoTQR0p6ytxr
         VzOA==
X-Gm-Message-State: AOAM531HtBIOILilg+tIhlwoSBIlRD+32+maDCGTHkCeRZr+/AARnC7c
        mIW0NDJ3zAQ+xZE4J21h5mwCjAE2VSAxJ+/9zDsHHA==
X-Google-Smtp-Source: ABdhPJyor5Hr2xHJLuBQnoyHYYNhaI9p6OwuLVzxn7Bt5ylBXiYFPnwEejhIeedKe/iPMvzJplplZYEek0Jh+LMI0qY=
X-Received: by 2002:a9d:a42:: with SMTP id 60mr33720842otg.179.1641208503260;
 Mon, 03 Jan 2022 03:15:03 -0800 (PST)
MIME-Version: 1.0
References: <20211226153624.162281-1-marcan@marcan.st> <20211226153624.162281-17-marcan@marcan.st>
 <CACRpkdbWs=5s-5qZXoDOf+f-y=c6XZOGZb7w0LL7bDEJpnnVpw@mail.gmail.com> <fa19a8d2-f65d-c998-4c84-ae4d7736a681@marcan.st>
In-Reply-To: <fa19a8d2-f65d-c998-4c84-ae4d7736a681@marcan.st>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 3 Jan 2022 12:14:51 +0100
Message-ID: <CACRpkdaQGwO-YbQS2VM6FPoxV4eiJ+Beod+A1N8VTHGr_4JyQQ@mail.gmail.com>
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

On Mon, Jan 3, 2022 at 7:03 AM Hector Martin <marcan@marcan.st> wrote:
> On 2022/01/02 14:58, Linus Walleij wrote:
> > On Sun, Dec 26, 2021 at 4:38 PM Hector Martin <marcan@marcan.st> wrote:
> >
> >> On DT platforms, the module-instance and antenna-sku-info properties
> >> are passed in the DT. On ACPI platforms, module-instance is passed via
> >> the analogous Apple device property mechanism, while the antenna SKU
> >> info is instead obtained via an ACPI method that grabs it from
> >> non-volatile storage.
> >>
> >> Add support for this, to allow proper firmware selection on Apple
> >> platforms.
> >>
> >> Signed-off-by: Hector Martin <marcan@marcan.st>
> >
> > If the strings treated here are exactly the same as for the device tree,
> > you should be able to just use "devprops" (firmware node) to handle it
> > abstractly, and then the respective DT and ACPI backend will provide
> > the properties.
> >
> > I don't know if this patch I made recently is enough of an examples:
> > https://lore.kernel.org/linux-hwmon/20211206020423.62402-2-linus.walleij@linaro.org/
> >
> > If the ACPI and DT differs a lot in format and strings etc it may not
> > be worth it.
>
> It's not quite the same; module-instance is the same from macOS'
> perspective, but we don't use Apple's device tree directly but rather
> roll our own DT which uses a different property name in this case.
> antenna-sku-info uses an ACPI method on x86, so that one is completely
> different. So in the end nothing is actually shared.

OK then!
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
