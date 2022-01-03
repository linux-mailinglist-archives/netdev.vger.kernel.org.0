Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68C9E483054
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 12:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232919AbiACLOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 06:14:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbiACLOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 06:14:10 -0500
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20131C061784
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 03:14:10 -0800 (PST)
Received: by mail-oo1-xc2e.google.com with SMTP id y13-20020a4a624d000000b002daae38b0b5so10530278oog.9
        for <netdev@vger.kernel.org>; Mon, 03 Jan 2022 03:14:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7rQyh8qoFCVkTYCJoBUAa1eDCuPTeVpt8hM9QR+kGFw=;
        b=lKp35sPLwfzzeo99ncy7I6kAbhlSDACT627ryf53mi4HRHQzMsBGXTG9q7DgSIQ5dd
         du+t0EgHMYNnZCwdGxmiioX7UQGukUUf2MZlOixbz8H7j9AnAMXlY3CsU7D9T3fGCPOe
         urPnWA2dDAB5GbwXvo+pGBEXUXwigVxVQwGRjwWv0stsQSVtWm/6oROJiOYvMyVegSP1
         q27lKF6e8DxfUnf2oVRK1FAXd0QsxsOE/XJ12oQ6APghvll7UkPqeOAviQsq37DxeA/2
         ZvVI3wGDXw7g5BPCP3FTKxrfr54jzIVKXSbV0GG+++jj+QHjVJ5m4aaz4ZmjYmFLlSej
         cscg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7rQyh8qoFCVkTYCJoBUAa1eDCuPTeVpt8hM9QR+kGFw=;
        b=oCPLIZL59q2C+0zQhYfm3hJw9nbvJF57AXuXRXZYqWkPdIBPevE11DA8tsV2pnu9TA
         SuO+le5PQuwi79i3Ox4swz+gxDuOn4k4tQ0ruH2YF4SIwVk2hikS31cF+DMYrSPx1Kvv
         8A0ZpKjTKNUO7orK3RfWFTQptvbrSckBz+UJVNUHzxcxn1lUq8kTgkfRAv8GIyqL2gwj
         k1SGQHlCmUvia5g7UiJ95piuWOn2zOqTwlgSEdIBdg6qvGJJiHpLJwgOETm66tBRZHp1
         9lOqxNHRGiAibR2mz5/t9nLujznumar+2jG+bhSXVhIiAP4wD1w7GKSOqaPlHwJzis38
         ri0Q==
X-Gm-Message-State: AOAM533WI7YN8G4Vpm0xGHxLOOS5GMbjghj4ErfP6/mITciSLxc/T+Di
        ornP9QsRvc11WVdZ5koDNeBpcW9OhKdEXzKFR87nng==
X-Google-Smtp-Source: ABdhPJxdQREDfbU4atMQgwtR/EJliSw5ut9txpzh8stIkU2N5ZJ8E4DugcU627Y8rFUiy4W9qw5htr1PorlsLDd/rLk=
X-Received: by 2002:a4a:e155:: with SMTP id p21mr28047376oot.84.1641208449094;
 Mon, 03 Jan 2022 03:14:09 -0800 (PST)
MIME-Version: 1.0
References: <20211226153624.162281-1-marcan@marcan.st> <20211226153624.162281-8-marcan@marcan.st>
 <CACRpkdbyFr-ZQuKOtx4+RRRBddmPGGUTY0j2VvT_7KxRBEQzNQ@mail.gmail.com> <46c09b62-d50f-fd2e-3eb4-ed4b643eef4a@marcan.st>
In-Reply-To: <46c09b62-d50f-fd2e-3eb4-ed4b643eef4a@marcan.st>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 3 Jan 2022 12:13:56 +0100
Message-ID: <CACRpkdZZSEfjSKR3QnfeUjRNyzgd3_3f8opvnpONMTfs0JLXJA@mail.gmail.com>
Subject: Re: [PATCH 07/34] brcmfmac: pcie: Read Apple OTP information
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
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 3, 2022 at 6:52 AM Hector Martin <marcan@marcan.st> wrote:
> On 2022/01/02 14:38, Linus Walleij wrote:
> > On Sun, Dec 26, 2021 at 4:37 PM Hector Martin <marcan@marcan.st> wrote:
> >
> >> On Apple platforms, the One Time Programmable ROM in the Broadcom chips
> >> contains information about the specific board design (module, vendor,
> >> version) that is required to select the correct NVRAM file. Parse this
> >> OTP ROM and extract the required strings.
> >>
> >> Note that the user OTP offset/size is per-chip. This patch does not add
> >> any chips yet.
> >>
> >> Signed-off-by: Hector Martin <marcan@marcan.st>
> >
> > Overall looks fine!
> >
> >> +       const char *chip_params;
> >> +       const char *module_params;
> >
> > This variable name "module_params" is a bit confusing since loadable
> > kernel modules have params...
> >
> > Can we think of another name and just put a comment that this
> > refers to the WiFi module building block?
> >
> > Sometimes people talk about SoM:s (system-on-modules), so
> > maybe som_params or brcm_som_params?
> >
> > Yours,
> > Linus Walleij
> >
>
> How about board_params, since we're already calling those things boards
> elsewhere in the driver? That could refer to the board of a standalone
> module, or an integrated board, which should cover all cases.

Fair enough, go for board_params!

Yours,
Linus Walleij
