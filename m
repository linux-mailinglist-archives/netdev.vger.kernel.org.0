Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB064865F1
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 15:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240028AbiAFOUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 09:20:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239990AbiAFOUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 09:20:44 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F7CC061245;
        Thu,  6 Jan 2022 06:20:44 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id bm14so9994016edb.5;
        Thu, 06 Jan 2022 06:20:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RHiowUInnnx0H26/RXZyWD79AVSBptAd7GCtWrosRcw=;
        b=i+Il7uIAwS57J/WQVwj8yPstgKlCF8siSQ98tZahJdpu7uZLeqKpL88rjqm7t3W/bi
         xdrKOVzOMd2cv9o/N0ocdRwx9M2n5fBXHRA6hroezMSLI6XJuWBT+R9li4Lfv+zz43P2
         s+2hfOSSNS8gyHEq5uOdFDUyR+7pwIl7l08KXtnVsqZBDK86QOyFMuTnbGCGov4k5OLP
         RsG++K1CyzwJ9pG32qh4Sqpzx89LcC3u9Jum6SA19Jx5IAWBklGVc9FE0+bc8gpaE/KX
         gjCJ/szBpXK6R6MOucwBIov62kaHe/4955JWIO0ybz6jJedJdvbVjRb+EwwgakUFII/Q
         jZlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RHiowUInnnx0H26/RXZyWD79AVSBptAd7GCtWrosRcw=;
        b=E8LhU49Thm1dyceAz3I8w49dAXTq/tvslXYTXII2Bo9Fit9xwzRFyFwlZA8CmJftBA
         X7YBCVlfI7UVWYRtXxkqdz3Mrfamd3rOKxz0Bzy8vydQOuuUH4+/5cn6IWzeh9X1qLcW
         BDDnupd5GoXvXuriCSN8dnGHxjR1KjYhk5GzFImYh0nOmFqDOXiNY5myMCfD+eESdbAk
         M9kxuRcV7DPs9znMpopI5+enNfohtzG7D1Uq/4fua2w/Z1KgdbAGTIQfvaFAf3tlRjNt
         QF2l5MuA+j0w1R0ZO/s3eMQ+uNqCtLwBBpk6575Mf0BDXc542fmpXvZ9obtns0lq50Hd
         WDFw==
X-Gm-Message-State: AOAM530QntUGxFU6QFcSyx57uuDptVa2gXE5hGa8o/eJfyoN62db8OIQ
        khXg7Xc1veyLt/jSVFe14i8lBB9ulYwuZEbd7lc=
X-Google-Smtp-Source: ABdhPJyySld/ws4jSU/lnZk1P1wL08Oiw3ChicoBJkwdGmMZdfL2+4XatgScRCEss7yjBh/BtqU4GL3uVxy2Q+kbnYE=
X-Received: by 2002:a17:907:6d8d:: with SMTP id sb13mr47302126ejc.132.1641478842777;
 Thu, 06 Jan 2022 06:20:42 -0800 (PST)
MIME-Version: 1.0
References: <20220104072658.69756-1-marcan@marcan.st> <20220104072658.69756-11-marcan@marcan.st>
 <CAHp75VcU1vVSucvegmSiMLoKBoPoGW5XLmqVUG0vXGdeafm2Jw@mail.gmail.com> <b4f50489-fa4b-2c40-31ad-1b74e916cdb4@marcan.st>
In-Reply-To: <b4f50489-fa4b-2c40-31ad-1b74e916cdb4@marcan.st>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 6 Jan 2022 16:20:05 +0200
Message-ID: <CAHp75VdzQhkj3ovFSAG4g1tD1scBK7H0xFFot0rfz2u6i8a3FA@mail.gmail.com>
Subject: Re: [PATCH v2 10/35] brcmfmac: firmware: Allow platform to override macaddr
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

On Wed, Jan 5, 2022 at 3:26 PM Hector Martin <marcan@marcan.st> wrote:
> On 04/01/2022 23.23, Andy Shevchenko wrote:
> > On Tue, Jan 4, 2022 at 9:29 AM Hector Martin <marcan@marcan.st> wrote:

...

> >> +#define BRCMF_FW_MACADDR_FMT                   "macaddr=%pM"

> >> +       snprintf(&nvp->nvram[nvp->nvram_len], BRCMF_FW_MACADDR_LEN + 1,
> >> +                BRCMF_FW_MACADDR_FMT, mac);
> >
> > Please, avoid using implict format string, it's dangerous from security p.o.v.
>
> What do you mean by implicit format string?

When I read the above code I feel uncomfortable because no-one can see
(without additional action and more reading and checking) if it's
correct or not. This is potential to be error prone.

> The format string is at the
> top of the file and its length is right next to it, which makes it
> harder for them to accidentally fall out of sync.

It is not an argument. Just you may do the same in the code directly
and more explicitly:

Also you don't check the return code of snprintf which means that you
don't care about the result, which seems to me wrong approach. If you
don't care about the result, so it means it's not very important,
right?

> +#define BRCMF_FW_MACADDR_FMT                   "macaddr=%pM"
> +#define BRCMF_FW_MACADDR_LEN                   (7 + ETH_ALEN * 3)



-- 
With Best Regards,
Andy Shevchenko
