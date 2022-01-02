Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E785D4829BB
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 06:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbiABFx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 00:53:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiABFx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 00:53:27 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B06CC06173F
        for <netdev@vger.kernel.org>; Sat,  1 Jan 2022 21:53:27 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id h7so23869315lfu.4
        for <netdev@vger.kernel.org>; Sat, 01 Jan 2022 21:53:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kN/N2rVxzZIMtOuMAHgQvn9VJQIKF/QJv0SmhaxabsE=;
        b=aAO3Nsb+2goe0QtK+PU3kzXBJ+vF7zKe/y1uxGrsZkEtSQavHFyz9DJ730ecAAEPiX
         0/9vG1Xj9qdCFJ7oyeTQ57wmKtRFtzc1kzecVEKn6A5+UhAGMB47NpBMK8jLCMv9Qwij
         gp4V64XiQCtCyfHmDkQRxv88odYg4jfcyzWnGfkr7yLqz+tW+dtQgrJbQF1a0o3SzF2t
         huMo+mJf0nWGzCrIBNTGUkQj7t3tttPK+jMDjPP6oubAXQM2lTYa2Y4Ut0On7Zj2ECvt
         GHm9SW7oQFKWEYn+eotYRh4e4o8T9Y79pp5x/Ups/NKOXRB0A6ifdFA18LalhZalUuBt
         kLAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kN/N2rVxzZIMtOuMAHgQvn9VJQIKF/QJv0SmhaxabsE=;
        b=K0Vllctgjd7EbAQ91vYlaPiNOtDr7Wqcp3u0hYUY6egr1XAXg8XM9hkMsBi/hL4vI1
         zOn2vme3pbitm2v+5zjoK3kufyXuiNlq8ugBsUlKSMO6XZogu+/ZPDZy9lyPAIqwGghm
         2aWre/DudCJbv5hZ0PXFXMhHbYLDAjpJ5xc2NqXLxdPhIU3SiR9FbzIEIO5Y4vHBMTG/
         u3dGwW+ef8Ur72uDlt+d00BZDaYdZSfFtATQrZko3f4es/hYp5+BY7jmfd2q40qDcV9O
         zHUajVok1SwZSj0nVCUuNwqnasO9UMCxUHyqnVkUEVnnFBPw3J0BcvnRj8IcfBCRFPSg
         hjQQ==
X-Gm-Message-State: AOAM5308PowAdrf75PDP8VHH7LJ/axKH3pPdy934CYfIgiXQtC25IY5v
        oJnH9uE7fq2bSFBLXgoemvmS5VNGjxmoZ++mrOeD1g==
X-Google-Smtp-Source: ABdhPJylWhyOHbTj5KdXcatouGqU6VlN+Ex8KSXONqXfEUf+0KJhJA5+rfp4hk+4n+4kIRy98MPV/jipmTrNjcARuIc=
X-Received: by 2002:a05:6512:2304:: with SMTP id o4mr35027621lfu.563.1641102805229;
 Sat, 01 Jan 2022 21:53:25 -0800 (PST)
MIME-Version: 1.0
References: <20211226153624.162281-1-marcan@marcan.st> <20211226153624.162281-14-marcan@marcan.st>
In-Reply-To: <20211226153624.162281-14-marcan@marcan.st>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sun, 2 Jan 2022 06:53:12 +0100
Message-ID: <CACRpkdYj1Fi5+jazp+MBsgSkHwq2CGcpBf86mYii7K5RzyO0pg@mail.gmail.com>
Subject: Re: [PATCH 13/34] brcmfmac: pcie: Support PCIe core revisions >= 64
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

> These newer PCIe core revisions include new sets of registers that must
> be used instead of the legacy ones. Introduce a brcmf_pcie_reginfo to
> hold the specific register offsets and values to use for a given
> platform, and change all the register accesses to indirect through it.
>
> Signed-off-by: Hector Martin <marcan@marcan.st>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
