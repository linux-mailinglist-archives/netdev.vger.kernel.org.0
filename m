Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 645AC4A4D84
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 18:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381138AbiAaRvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 12:51:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381117AbiAaRuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 12:50:50 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E7FAC061758;
        Mon, 31 Jan 2022 09:50:38 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id d10so45396765eje.10;
        Mon, 31 Jan 2022 09:50:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8GVlcbMKWd6sknSwsJTkH3UkvUcDFFWA5/+PxWk1FBQ=;
        b=qs/2h+iV23o0KF6R03dAhdmE/axbeR2qE3rbz2GJhNRV8SEeiSPsrQvFC/thNvlcq3
         tTd4TlCTVFHUDFxii5lU12QyqpTgkiRelenS4rYVY0Sfee7VxRLN0+8GR9UuI7veR/iA
         +YkLnJki9Cx2spbdIizoVgoLPnWBKCN/5S7KIOrRI64Pk7y13ep90GrkWV2rHSVtnbkB
         vAM3w5yjo3enrcXZLSVsERNyQVsgoDnssO0Icrxlvhiof74tIw9lz6oJ2341W2TnbIJW
         rcHcO6r177JPjXbSgyEFt59HgZcDPB3p5dXLBD+1L/F/G1qppe/y/FbWQiVi2csNbac1
         yAbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8GVlcbMKWd6sknSwsJTkH3UkvUcDFFWA5/+PxWk1FBQ=;
        b=FGxIua/McK9OFm9d56Ta9BY1ZCWQGA3aYXJTxf1J1djaGs8xgzc69hW75Dwm+JXpeO
         Cc6qpdCLWuBw7g6DhSv++3ctQJPuXgpZs9A2VElDgOWkMzUs9ErRs0HRqVAERFJEouVY
         UZT+KPlT70y6jjvDZ9sK85W8vJ9Z0DRj9dAcO2xpSbbx3SEf+vYhMlRoodePoTUvjwYI
         Ixi7ypce8bqtXBwz5Cyier+L7SPbdaEfPaU0ztApa9ixcwprFD5qb1kkMaZo5UE5cjg5
         IIH+gSUYAh5GPARmlgXv0hdQHHNKcvlbtCxoT11w4nR1hq/MiRAMBbPA65M4OxmTscX2
         WXGw==
X-Gm-Message-State: AOAM530itlxnCLONZYEVz60EjY10pZWbvIyvnMU1E1A6fi6B8CkLADoZ
        RO44EtzH3jhtSShlxiakz3uSsfJpt/R80ocElrc=
X-Google-Smtp-Source: ABdhPJySPMLXG826MvbuUjwZ2lW9naA71Uho8Hz9ED+TkkBh3xJuWPCfQq50w2zCupQdwrxSAXqrKp3+CE1fa/VpIeM=
X-Received: by 2002:a17:907:2d92:: with SMTP id gt18mr17433897ejc.579.1643651436652;
 Mon, 31 Jan 2022 09:50:36 -0800 (PST)
MIME-Version: 1.0
References: <20220131160713.245637-1-marcan@marcan.st> <20220131160713.245637-4-marcan@marcan.st>
 <CAHp75VdgXdYXio8pTDdxsYy-iCXMvVpZM1T6gNmcxo3c1V+uJA@mail.gmail.com> <878ruvetpy.fsf@kernel.org>
In-Reply-To: <878ruvetpy.fsf@kernel.org>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 31 Jan 2022 19:49:00 +0200
Message-ID: <CAHp75Vc+HS0ytF3fuyEiwaG_-tLQMQriz48HLdPVyYn==jr7aA@mail.gmail.com>
Subject: Re: [PATCH v4 3/9] brcmfmac: firmware: Do not crash on a NULL board_type
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Hector Martin <marcan@marcan.st>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
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
        SHA-cyfmac-dev-list@infineon.com,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 31, 2022 at 6:49 PM Kalle Valo <kvalo@kernel.org> wrote:
> Andy Shevchenko <andy.shevchenko@gmail.com> writes:
> > On Mon, Jan 31, 2022 at 6:07 PM Hector Martin <marcan@marcan.st> wrote:

...

> >> +       if (!board_type)
> >> +               return NULL;
> >
> > I still think it's better to have both callers do the same thing.
> >
> > Now it will be the double check in one case,
>
> I already applied a similar patch:
>
> https://git.kernel.org/wireless/wireless/c/665408f4c3a5

"Similar" means that it took into account the concern I expressed here :-)
I would have done slightly differently, but the main idea is the same.
Thank you!

-- 
With Best Regards,
Andy Shevchenko
