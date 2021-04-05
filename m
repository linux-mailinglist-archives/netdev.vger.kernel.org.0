Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 401B9354932
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 01:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237981AbhDEXQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 19:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234101AbhDEXQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 19:16:49 -0400
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA29C06174A
        for <netdev@vger.kernel.org>; Mon,  5 Apr 2021 16:16:43 -0700 (PDT)
Received: by mail-ua1-x933.google.com with SMTP id b7so4044113uam.10
        for <netdev@vger.kernel.org>; Mon, 05 Apr 2021 16:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TZ4SU456AZ0sRnkU59VN4dhYN/vEDkB4fkKtZPG7t/Q=;
        b=nSKbjaWWDIe11E8mPB0cgzonTrp6Ogy34Aja7sJfyo0Xea5LpnY5F9QETb9Hb/OLMz
         1+YuTGDD9T1RJ/qpoKxasnid5RD7ufvowKztCoEppdbi9NLleaMyCwCZf9qWmmEDBdFR
         mOFHZZdakb0rzMJPTPGzXjK6jX+xe9udqC5qU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TZ4SU456AZ0sRnkU59VN4dhYN/vEDkB4fkKtZPG7t/Q=;
        b=LTsRV/IflyZO3JKXNzsJvm7fBKfRtGhWAm2g2+Vx6gvknNupa66NQZ2zG9X2lijCzG
         SA7b1Fmuv2+XM99Mq/7kAY2mTHerkxMRO8qUm5XSJFJtfOL/gxnkhUPAPUSOWgPz21U1
         D+Oq+6CaG/dvAuvJBJIGXKvxPhi0wJzq6JVxxqq3sF2MbYDTcpQjawILpHc3DZutt8/6
         8Rl0G1QOLjCxrJ66681OKmlzTik0jvyoxgYoBhD0T8AU9AqO8dfBAhmIb40ieQPy/gIP
         257zDfmJMPAPeJ8PklJgHqSbu0lVT5jw0T0KYC1KEiU1fG1eIA7Z40QRY9oaFvrzCgVJ
         Q8lQ==
X-Gm-Message-State: AOAM533ZdXH9ylpM1ChbG5p5XJLyOlUIEm4viVDccJpwMRIb6J53fdFi
        bjn/tY0Mx+6I/8RKIFwp/mZ/phz6YDAtlyEOcDx0Og==
X-Google-Smtp-Source: ABdhPJyQq3SgV4qSnbayFQIlpdBCWilEk7BS8IW0MO1/2NE44Qyb+yLKCH2whfXSSwTqmUFFv8mDIBD7KUhnTMpVC0s=
X-Received: by 2002:ab0:395:: with SMTP id 21mr7986341uau.25.1617664601990;
 Mon, 05 Apr 2021 16:16:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210330021651.30906-1-grundler@chromium.org>
In-Reply-To: <20210330021651.30906-1-grundler@chromium.org>
From:   Grant Grundler <grundler@chromium.org>
Date:   Mon, 5 Apr 2021 23:16:30 +0000
Message-ID: <CANEJEGs0Tbo82g=hesm229WoHP+pC7YoXkAhH28jy9=EdA0xLw@mail.gmail.com>
Subject: Re: [PATCHv4 0/4] usbnet: speed reporting for devices without MDIO
To:     Grant Grundler <grundler@chromium.org>
Cc:     Oliver Neukum <oneukum@suse.com>, Jakub Kicinski <kuba@kernel.org>,
        Roland Dreier <roland@kernel.org>,
        nic_swsd <nic_swsd@realtek.com>, netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 30, 2021 at 2:17 AM Grant Grundler <grundler@chromium.org> wrote:
>
> This series introduces support for USB network devices that report
> speed as a part of their protocol, not emulating an MII to be accessed
> over MDIO.
>
> v2: rebased on recent upstream changes
> v3: incorporated hints on naming and comments
> v4: fix misplaced hunks; reword some commit messages;
>     add same change for cdc_ether


FTR I've reposted V4 with Andrew Lunn's Reviewed-by line and added
net-next to the subject line.
It will show up as a different thread and hopefully the automation can
pick this up now. :)

cheers,
grant

>
> I'm reposting Oliver Neukum's <oneukum@suse.com> patch series with
> fix ups for "misplaced hunks" (landed in the wrong patches).
> Please fixup the "author" if "git am" fails to attribute the
> patches 1-3 (of 4) to Oliver.
>
> I've tested v4 series with "5.12-rc3+" kernel on Intel NUC6i5SYB
> and + Sabrent NT-S25G. Google Pixelbook Go (chromeos-4.4 kernel)
> + Alpha Network AUE2500C were connected directly to the NT-S25G
> to get 2.5Gbps link rate:
> # ethtool enx002427880815
> Settings for enx002427880815:
>         Supported ports: [  ]
>         Supported link modes:   Not reported
>         Supported pause frame use: No
>         Supports auto-negotiation: No
>         Supported FEC modes: Not reported
>         Advertised link modes:  Not reported
>         Advertised pause frame use: No
>         Advertised auto-negotiation: No
>         Advertised FEC modes: Not reported
>         Speed: 2500Mb/s
>         Duplex: Half
>         Auto-negotiation: off
>         Port: Twisted Pair
>         PHYAD: 0
>         Transceiver: internal
>         MDI-X: Unknown
>         Current message level: 0x00000007 (7)
>                                drv probe link
>         Link detected: yes
>
>
> "Duplex" is a lie since we get no information about it.
>
> I expect "Auto-Negotiation" is always true for cdc_ncm and
> cdc_ether devices and perhaps someone knows offhand how
> to have ethtool report "true" instead.
>
> But this is good step in the right direction.
>
> base-commit: 1c273e10bc0cc7efb933e0ca10e260cdfc9f0b8c
