Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 575F4482A2D
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 07:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbiABGU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 01:20:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231924AbiABGU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 01:20:57 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A69DCC061401
        for <netdev@vger.kernel.org>; Sat,  1 Jan 2022 22:20:56 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id p13so32248466lfh.13
        for <netdev@vger.kernel.org>; Sat, 01 Jan 2022 22:20:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iZfVXMnlFKiRYFSBtV5QUvN00BNnqV5JOXQJdrR8Sew=;
        b=sdBIgE+VYwC06bsPhTHjM+UfcUy1tLJ2op+ZavumxCT6zdSzTUST7hlfJDtZPO5CGd
         0SABlupThnCzBE3gLGBg6MmuJGpi4Fx6BEmFGcdGN84KLvETqTDHpC4wWybZ3Xni3For
         21dPXKBxBAChu7D1owrHM8L94avJF8Mnn2PWLFeboCUo8vQutvpMX4YdNxr+qysJDwzE
         jtlgIcTmaCb7gs6Iyv4w6WxKaaB0w4vTv4EwYCJBNZYUVU7ederPyCSmSONF5DSYmgF/
         O1YZV0Hr5Dvyg5S+bzHkwtPlkuN0hFYS7bT7BlhztciDo1kH7leWW0vNZWNHZPNgzvIL
         e6hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iZfVXMnlFKiRYFSBtV5QUvN00BNnqV5JOXQJdrR8Sew=;
        b=NIzyUZmmASdlg+BsRClnf7BPgZVmMVdfQLzE+sqTA0GLWII19eRKDU9hXAPWWGMsrH
         k52esWK6HqNf7kvzolTKMRkLKEq2mdzNA/cWq2CLm+fcJt45Ge7W+PA7lfpWwbHXPBsm
         CGYejMYxoLW7xy2Vk6zKUUCvIn2OxQkR7mYz0EcWO6m6iR3nwJGiqSslifHrH0qPuz8x
         6KJu07XaZiOP+sHkqsmKeCbNB7O5rLFDmYuxQtiRY/X8DJmwqb3snFc8MirXKNXw9BCf
         dA5BrSDxfMqimGDARcNmrvwq7gqzuwL6LilPTUYcO6mSDsMN3Ads9I/1nUH80SaCxMVk
         Ti+g==
X-Gm-Message-State: AOAM53289hl47Aw5bNyrB+eIwXycTOvRMOcrSSrgZZclraOSl60kSzRh
        fDDAfrpQVM2u5d1AYBah2ECr7r7GZ2e2Xj24aTTT/w==
X-Google-Smtp-Source: ABdhPJwGf3GpaIdTpmfU98rgqH5l8olR5k/M9CUek/1KS0aQHfgaFJavl8RBOhO7emZSxB4N+8M/uzkY9ewCBSwILQg=
X-Received: by 2002:a05:6512:39ce:: with SMTP id k14mr19074277lfu.508.1641104454979;
 Sat, 01 Jan 2022 22:20:54 -0800 (PST)
MIME-Version: 1.0
References: <20211226153624.162281-1-marcan@marcan.st> <20211226153624.162281-16-marcan@marcan.st>
In-Reply-To: <20211226153624.162281-16-marcan@marcan.st>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sun, 2 Jan 2022 07:20:42 +0100
Message-ID: <CACRpkdYkRjzNnudcrroXxdkxEF-PvTgqgy25HidhY9KsFapJsg@mail.gmail.com>
Subject: Re: [PATCH 15/34] ACPI / property: Support strings in Apple _DSM props
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

> The Wi-Fi module in Apple machines has a "module-instance" device
> property that specifies the platform type and is used for firmware
> selection. Its value is a string, so add support for string values in
> acpi_extract_apple_properties().
>
> Signed-off-by: Hector Martin <marcan@marcan.st>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
