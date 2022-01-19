Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91CAF494291
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 22:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357428AbiASVh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 16:37:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234306AbiASVh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 16:37:28 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 005FEC061574;
        Wed, 19 Jan 2022 13:37:27 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id p12so19472690edq.9;
        Wed, 19 Jan 2022 13:37:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g9zZAriOrb5Xr0Ri01rwPR9vgbSqidck2HSWzQmnp0c=;
        b=HnnBeMFGK0o7vxUSYMfOjy5xhxvtWG8mAcZGXgwnXIaYcKEYzKvqT7MylqeEdyxXOJ
         W+rWhtMWn+LsxZ4nejDGYP4tE53tDtg/dUhhVDgJ6S9gflQ0NHyqANHGs1X3aZ+c/tBQ
         8N4PO7OZTCeEon9rgR4wgCFA1NAvyCs3blKo4cFjme8gQf27qr0RlU29ht681vIHCRWb
         Brqk968peXD6zDdVgNz/dx0XjAaQfjIEIgz8LfLhiltxKhXBow9sWrRK7xz+8dPV9D0V
         TAqhwYzPdD3dAyQ5gRukN0E6pbbSUT9ByDuNffHUsrQ1TL9USBfc1sPDZV9EjStRG1Lj
         JBMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g9zZAriOrb5Xr0Ri01rwPR9vgbSqidck2HSWzQmnp0c=;
        b=WZIupJ5pGe7ByGFETQro4odk30YQ4CPD1erCpfobZQ0Vh1Dq4UTvTeGigVZkhlirDW
         jmwqUkkd9vaq9bjXC8yhjKV3ByrjsemcffsmYgT0ZlkejrKEiio7ruJtAD80ylbGOU5J
         z4JDPDIEGLy2xeAtZTpwo/LRbtQ6aLP7OINZhWL8w0/cfTMoqvokA9kD8KAqBtqQg24E
         XQhIvnVChPXmWZHpdoS6AYIGP8hOk7NNa2fwVnO7ZjhNhKQsxkLE7/HeIfgr1/uqmEMx
         uG+1ILONG2CoPWEC3+7bIU1w7t2WDSswciNkKgJmrcdRNDwkmSFgmgKYOQUIw8c841rO
         bMmw==
X-Gm-Message-State: AOAM533rXR7RR/nDKTHwluJS6GtVvhnwKJeCSTF0KrZGlXLY+BcpOq2u
        SXbWXQ9ALbtRZevxhgf7RJORgqCwB8bmcba6LGs=
X-Google-Smtp-Source: ABdhPJyjjgVpATxmVD1aV35Xo9jAj8pXAk6bx2y/zBQJw/wSro/1lxKqon8RXutyujoIdjaoYPJ+cbXx5hAM2h1/rK4=
X-Received: by 2002:a17:906:5d0f:: with SMTP id g15mr7687669ejt.44.1642628246319;
 Wed, 19 Jan 2022 13:37:26 -0800 (PST)
MIME-Version: 1.0
References: <20220117142919.207370-1-marcan@marcan.st> <20220117142919.207370-3-marcan@marcan.st>
In-Reply-To: <20220117142919.207370-3-marcan@marcan.st>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 19 Jan 2022 23:35:44 +0200
Message-ID: <CAHp75VdZG4n1QySXyM+w1gJOWzq5Ng-Ym8dL1sSC_MLP2hqxAw@mail.gmail.com>
Subject: Re: [PATCH v3 2/9] brcmfmac: firmware: Allocate space for default
 boardrev in nvram
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
        Dmitry Osipenko <digetx@gmail.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        SHA-cyfmac-dev-list@infineon.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 17, 2022 at 4:30 PM Hector Martin <marcan@marcan.st> wrote:
>
> If boardrev is missing from the NVRAM we add a default one, but this
> might need more space in the output buffer than was allocated. Ensure
> we have enough padding for this in the buffer.

Do you know this ahead (before allocation happens)?
If yes, the size change should happen conditionally.

Alternatively, krealloc() may be used.

-- 
With Best Regards,
Andy Shevchenko
