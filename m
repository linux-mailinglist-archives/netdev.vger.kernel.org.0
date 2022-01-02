Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6454829F5
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 07:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbiABGLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 01:11:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231698AbiABGLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 01:11:49 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79151C06173F
        for <netdev@vger.kernel.org>; Sat,  1 Jan 2022 22:11:48 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id x4so33502994ljc.6
        for <netdev@vger.kernel.org>; Sat, 01 Jan 2022 22:11:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CLYs6RPdlYoNdW+4UL3boVj/wZ9DVO7dQZSS21vPQg8=;
        b=k1AOt9g7ctt0LaNkr2kqTxIjq3+DWOMbt5ZOTBEJA6LntouCvz3cYAhESGIrt+jF0n
         ThCPNtuYU7nqQ93Bv0wFNIvD4gbfeV0LShkAxf5Pr0L5cPrKs2+YInUWDDQu7k7SJ5p6
         dW8xprCt6mIhj1AUY+0jhZHcBb5vkt7Q955Netg7siEtQuDgaeEx8X8gGl62VSvtVW2N
         gBkrprBk9ggy11Y8xjCLCx2NbSC3yW+m+PUtZyybJOs9RAu1Jw0ErbEyapVGNta+aa2K
         zhHVlyN89pAO2JUBqUUrUym51c9J7skKnHoo0d0iNNhQOeAFJzN5W29j3j0hQ7FocYqU
         wI5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CLYs6RPdlYoNdW+4UL3boVj/wZ9DVO7dQZSS21vPQg8=;
        b=UbszGV9qIR6Ed0KzKRStyxZpfu2C8AyxEAJyVla+nYee0Fe9ZEDfkbf/c5rK/sIc/L
         m5BPGTJu9O04hGGJ/bRfrr9JbBXXYuWKo39kZLyZKWZy/r5XqKLH6bOHtGkB0eegcqmG
         2h0ijnf4G+g3ev9VP+XIUM6WOf/KfkthUbwLpM1J2vp4wRwUIkbdni8fDrPJ+GDk9Asx
         XbLYhjd5CH8k8Tb78qMbA+4iITzT2FDnncuUXPnk/Uw8i1gcv2zZ+An/Wq6pw0RZUwK1
         L8rxCPjFDU/oyu8/je8XF3OJPEkJw5E2w2tRY4reH0sPklOalRa/45/AtRsN1DQiu2l2
         aj+g==
X-Gm-Message-State: AOAM5316Tb+kvHdaE+zss4CalkIPAEB2RXPbIgaeqsdFeLM+s/i8Gk/q
        JC87nNm2LVz8VWj1/4difSb8zr31nsrUDzTJuN3tEA==
X-Google-Smtp-Source: ABdhPJwgIObPmwk+diSjYih9QUhroCYQGoR5YghpXUjDlvzhjBXtDoMBCB6FepG9wKcYRFCuczmvG4SeU5CjPd2DRiI=
X-Received: by 2002:a2e:7c01:: with SMTP id x1mr33723616ljc.145.1641103906802;
 Sat, 01 Jan 2022 22:11:46 -0800 (PST)
MIME-Version: 1.0
References: <20211226153624.162281-1-marcan@marcan.st> <20211226153624.162281-25-marcan@marcan.st>
In-Reply-To: <20211226153624.162281-25-marcan@marcan.st>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sun, 2 Jan 2022 07:11:34 +0100
Message-ID: <CACRpkdZJnXhzDRhZt97Svf5pU5T_Xc2mfxFFnibNda7JJ8fiFQ@mail.gmail.com>
Subject: Re: [PATCH 24/34] brcmfmac: feature: Add support for setting feats
 based on WLC version
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

> The "wlc_ver" iovar returns information on the WLC and EPI versions.
> This can be used to determine whether the PMKID_V2 and _V3 features are
> supported.
>
> Signed-off-by: Hector Martin <marcan@marcan.st>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
