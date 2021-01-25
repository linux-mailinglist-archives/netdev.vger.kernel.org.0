Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7150F303418
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 06:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730330AbhAZFPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:15:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:57582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729708AbhAYOmU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 09:42:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EF632151B;
        Mon, 25 Jan 2021 14:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611585504;
        bh=dKASY5gYt7wu7ypbIVbzvYFsutHeIkgRRS4d6AHPgZM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ctMiaYdPSdQST1yuDBkNjUZzTN5ZXtpU+jPNgU7RNQUN5qPU7PvKyQ3hsJz9ybFSn
         7zjXEXhcMgH+mK3cimXX+jJMtoMqveFvUE8KY0uRCxr3e3k+MkRmyXBTFZa4Qhr+H7
         Ljot7n5VNTSDsB1yai7R2z4IytFw2zo+1C71EEG9TbovblsRjDfblpuEjAPkHVT86R
         OMq8yE+F0bZX6idrQPoqH4QKTS58q64a1MK6mS6qPxAYexFJ8f3Jaum+wZSzB9WuMy
         uR5fT6HKNFAVP+b6G2Upl3llnEo8fbtGDR4MpAwxLcJYsLr5ge+rKr/Q9Nm/BE3SPX
         UBfmPuR0yVdjw==
Received: by mail-ot1-f48.google.com with SMTP id f6so12895141ots.9;
        Mon, 25 Jan 2021 06:38:24 -0800 (PST)
X-Gm-Message-State: AOAM530+3LAuqZaqHE3sEGhDpSkh6L2yq+nt0UTCSS+d//jWT7IwHwUO
        5dV4Qcy0rhf5iSSlyvVTP5vgq+sjAcwri/Gzlao=
X-Google-Smtp-Source: ABdhPJy3yKLSrYt9jUlyr1APJcIFI+0p/ceH9eu86GDAWpte4vsT+j8IcsxYMvm2Rk6P2vnIXbCwiICnO/24bPPgePk=
X-Received: by 2002:a9d:741a:: with SMTP id n26mr662146otk.210.1611585503621;
 Mon, 25 Jan 2021 06:38:23 -0800 (PST)
MIME-Version: 1.0
References: <20210125113654.2408057-1-arnd@kernel.org> <CAJKOXPfteJ3Jia4Qd9DabjxcOtax3uDgi1fSbz4_+cHsJ1prQQ@mail.gmail.com>
 <CAK8P3a0apBUbck9Z3UMKfwSJw8a-UbbXLTLUvSyOKEwTgPLjqg@mail.gmail.com> <CAJKOXPc6LWnqiyO9WgxUZPo-vitNcQQr2oDoyD44P2YTSJ7j=g@mail.gmail.com>
In-Reply-To: <CAJKOXPc6LWnqiyO9WgxUZPo-vitNcQQr2oDoyD44P2YTSJ7j=g@mail.gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Mon, 25 Jan 2021 15:38:07 +0100
X-Gmail-Original-Message-ID: <CAK8P3a1NEbZtXVA0Z4P3K97L9waBp7nkCWOkdYjR3+7FUF0P0Q@mail.gmail.com>
Message-ID: <CAK8P3a1NEbZtXVA0Z4P3K97L9waBp7nkCWOkdYjR3+7FUF0P0Q@mail.gmail.com>
Subject: Re: [PATCH] ath9k: fix build error with LEDS_CLASS=m
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Flavio Suligoi <f.suligoi@asem.it>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 2:27 PM Krzysztof Kozlowski <krzk@kernel.org> wrote:
> On Mon, 25 Jan 2021 at 14:09, Arnd Bergmann <arnd@kernel.org> wrote:
> > On Mon, Jan 25, 2021 at 12:40 PM Krzysztof Kozlowski <krzk@kernel.org> wrote:
> > > On Mon, 25 Jan 2021 at 12:36, Arnd Bergmann <arnd@kernel.org> wrote:
> > > But we do not want to have this dependency (selecting MAC80211_LEDS).
> > > I fixed this problem here:
> > > https://lore.kernel.org/lkml/20201227143034.1134829-1-krzk@kernel.org/
> > > Maybe let's take this approach?
> >
> > Generally speaking, I don't like to have a device driver specific Kconfig
> > setting 'select' a subsystem', for two reasons:
> >
> > - you suddenly get asked for tons of new LED specific options when
> >   enabling seemingly benign options
> >
> > - Mixing 'depends on' and 'select' leads to bugs with circular
> >   dependencies that usually require turning some other 'select'
> >   into 'depends on'.
> >
> > The problem with LEDS_CLASS in particular is that there is a mix of drivers
> > using one vs the other roughly 50:50.
>
> Yes, you are right, I also don't like it. However it was like this
> before my commit so I am not introducing a new issue. The point is
> that in your choice the MAC80211_LEDS will be selected if LEDS_CLASS
> is present, which is exactly what I was trying to fix/remove. My WiFi
> dongle does not have a LED and it causes a periodic (every second)
> event. However I still have LEDS_CLASS for other LEDS in the system.

What is the effect of this lost event every second? If it causes some
runtime warning or other problem, then neither of our fixes would
solve it completely, because someone with a distro kernel would
see the same issue when they have the symbol enabled but no
physical LED in the device.

      Arnd
