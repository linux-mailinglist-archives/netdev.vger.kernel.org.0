Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4E5A482A39
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 07:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231994AbiABGYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 01:24:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiABGYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 01:24:35 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB32DC061574
        for <netdev@vger.kernel.org>; Sat,  1 Jan 2022 22:24:34 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id x6so15736164lfa.5
        for <netdev@vger.kernel.org>; Sat, 01 Jan 2022 22:24:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MRIzYog0oG8YRBJV8uYe7Ak+u+xDADrXSEkgE2V9/cA=;
        b=Vv9nOjvk1PmOvu+nhkp0vkMMvNEObC3EdUeBHAokuzh0QsGErUT7xGI37XarqLfv8F
         VLPMk920zs4ek63TJn2NMktfyLT0Wi4YDFZ7Zd2VpzeZlRMit1KDDmoajQFDtnVnn9mT
         1ZFn0RNhUlHuDafCoIOygKq4ar+sxgXGAWUmU4jPGXUfjMJqgX78cqZo1hJzeMGQnkXT
         sCtCAas0c9d3L3MAeCGceGmZdwinw3rrjSnRCSbUaXncvpXIg7PFi5ZYToxhYh8l+22I
         mwkcjsJMhWYCx8czT7W9mgfRTNxE5JQbwuPnpXkWoiHvpLHZ8LMmFymMszo4D4EkwBEp
         PLIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MRIzYog0oG8YRBJV8uYe7Ak+u+xDADrXSEkgE2V9/cA=;
        b=lO+Wm8A39q1JH1Uj0PRb3wqWoyYvj+Fd5impagv3yFjh9OeaKbgYSoYL4jEB1suBBA
         z053TlQNKrI/jUyV8xttHXLJnZno7JxfPdEKO+4WQwppaNeK3NdOncG2gG05c8h5y9C8
         tqfHWHj2ig+Tdxb+7l/+5Gii4V3BEaQJ2eqHLEgcN+lnWq4GyG+ceJlFe0h5vqiMd7dL
         xQ1jDB6pMoOP0fNOL22DZHIP/PaF4xRT3LQC7laBKhCNMuP8tpFoZKTnLcKwpAOF6ofC
         JmhN+tEtoyR1dqAqmIwt++psTJamoDyejpRjb899iimSP+PegHrK9CETvgRQYdYLmXbc
         HqTQ==
X-Gm-Message-State: AOAM5302ykbKceG4EDkVV+aQL+fNt+ebOPxWvfHikW2Bv9aV6x2x8lyW
        cNXNGUt6FSjcAKmXB3SWlb5quZGOD6kNGyhyjLclew==
X-Google-Smtp-Source: ABdhPJzgcYPpsyuWAu1d8IqDIVcu9MuInByUpnzzNH4wf+Sm5vBNJ55cR8YJ26jVqSxrIb8utAPv1mkfQu8oqSQTWlY=
X-Received: by 2002:a05:6512:2304:: with SMTP id o4mr35088210lfu.563.1641104673024;
 Sat, 01 Jan 2022 22:24:33 -0800 (PST)
MIME-Version: 1.0
References: <20211226153624.162281-1-marcan@marcan.st> <20211226153624.162281-5-marcan@marcan.st>
In-Reply-To: <20211226153624.162281-5-marcan@marcan.st>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sun, 2 Jan 2022 07:21:32 +0100
Message-ID: <CACRpkdYHkX2Thi26sa-6rtzL9i-LU1X6GQNpGF7yqZmHNv6fzQ@mail.gmail.com>
Subject: Re: [PATCH 04/34] brcmfmac: firmware: Handle per-board clm_blob files
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

On Sun, Dec 26, 2021 at 4:37 PM Hector Martin <marcan@marcan.st> wrote:

> Teach brcm_alt_fw_paths to correctly split off variable length
> extensions, and enable alt firmware lookups for the CLM blob firmware
> requests.
>
> Apple platforms have per-board CLM blob files.
>
> Signed-off-by: Hector Martin <marcan@marcan.st>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
