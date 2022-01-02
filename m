Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE8E482A0C
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 07:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbiABGQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 01:16:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231831AbiABGQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 01:16:29 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14630C06173F
        for <netdev@vger.kernel.org>; Sat,  1 Jan 2022 22:16:29 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id bp20so68546761lfb.6
        for <netdev@vger.kernel.org>; Sat, 01 Jan 2022 22:16:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7t9Pr6jwfjfvmwbkViT7Gt80229nnpeufsMcTvyLkrY=;
        b=aWAbDq6TLpg9UXuIW4IVMEOEiUE/GNhSVGWq8iSmXMoCyl3DzT1/olWwlxg6RvtrI/
         pBDTk6tbnc0wBFKnIgXkR80qRvTA4vqakhWSjl41C4uXBq5X2nXVr+F8ijaPujIs+Hxf
         RMvCLBXPb52TppBGSrxid7/Ih3B4ayfFWFcYpewZa9mIGtNs4QIbSMXRoGLmC3vcKVNv
         nZa631DV1Fv1erqUyWh6v/H7xKuwUCxc7E2YyQVWHqQvU+9BCW6DEtrP7W89lcZYzLmy
         ajDHWku7NI+5+E93ksyq4rFxRAZNKDzavkOdv1PVguAiIHI/UgF7QsjoBSETJlA2/eI/
         FmPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7t9Pr6jwfjfvmwbkViT7Gt80229nnpeufsMcTvyLkrY=;
        b=dqfRe/9Wznlstte7ykIpBpuTtUjjvCWAlm5hIMUCCUOM617Y7oc2GqrO1Cld0aXTt6
         L85P8oveb6NDhR9t8yH9dKvBvz0EZTG5qMdd50penGeWmINAI0xhR0Z1poz13TQX+W4+
         DBDpxvDpdZqYy7gqT+3Vgd/5AO5VZMVJ7ODw4BVNoBKKC3kbxX1AgiFtS/UO/Rz8zHDx
         XtvoTU92tHqVShDh1FgyLqLxNBSbQhTBr8LTScAIAvVsHrfMC+Vx0Tgz8byWPT+pOOZI
         8/it5F+7M39zQ7ynRFitbgh2DkZs2R8zp0yt9zFjsHDFGbmgTePlF1tAJTCup4sN6DrJ
         2wjw==
X-Gm-Message-State: AOAM5320ex6FdYRUoxdeh9C3016plxhdrPBp/CSEyolnHk+Cmbkvnz9o
        0Cpl5zRvSC6oX3yhYGfxDSli2PgxsRi/NSjckEoS8w==
X-Google-Smtp-Source: ABdhPJz85XNekAyAFF4FYXbkslm7+HKbOb+zFhAEQIZ1/ehXrpVVgLTiVY/EyCJ8+Q9r6SqZ2SrR0iVbAthi380khuE=
X-Received: by 2002:a05:6512:2303:: with SMTP id o3mr36815522lfu.362.1641104187407;
 Sat, 01 Jan 2022 22:16:27 -0800 (PST)
MIME-Version: 1.0
References: <20211226153624.162281-1-marcan@marcan.st> <20211226153624.162281-30-marcan@marcan.st>
In-Reply-To: <20211226153624.162281-30-marcan@marcan.st>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sun, 2 Jan 2022 07:16:15 +0100
Message-ID: <CACRpkdbSTN3u9=bCCCn0OYA9LtKLqbYUXjGDsoh-U=i7QBJfdA@mail.gmail.com>
Subject: Re: [PATCH 29/34] brcmfmac: pcie: Read the console on init and shutdown
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

> This allows us to get console messages if the firmware crashed during
> early init, or if an operation failed and we're about to shut down.
>
> Signed-off-by: Hector Martin <marcan@marcan.st>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
