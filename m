Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36DF14ADE5D
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 17:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351979AbiBHQaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 11:30:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234343AbiBHQaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 11:30:16 -0500
Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A7CDC061578;
        Tue,  8 Feb 2022 08:30:14 -0800 (PST)
Received: by mail-vs1-f48.google.com with SMTP id v6so4015935vsp.11;
        Tue, 08 Feb 2022 08:30:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HfkDQIcOW766T4TrWBz7uBQ1GzwJ+9jOSYZqbnZjKbo=;
        b=YLCoH3+zNRJIUhvGyXurh4eMmQK2iElVZTvaHeQFWqRcze4TbfCHVDu1a/DiKEeai8
         HKeoYkgchk27ajMVGO3sKGMzSn4nq2+IBEcuRzP/11Rhx254fFIKh7zewV0NvOjxqHPK
         o//lKG8NqyViSYtG8e6Ajd0H0h+jw7kcPlm/6YeBpCNrc8MMS8tQsRNTupSB4SkILeOH
         2uQj1mHTfdnWbm+zV9mnPGUKLCg1+2IAk2gp48rJA0wGIZQ7vk8dPw6E/psZPdBdn0Ts
         3VhEIAizBySXHC62WDYt3XkFd4AvB6QqQPXHKbiGH3QR6Y4LDghE2/UvDTUpl16V09Ok
         uT3A==
X-Gm-Message-State: AOAM531T6ZF4+7dM93FJxTcbC+LvbSDoW5NT2QyjwiBfsRK9gTT4Z11W
        RI2MqiTWB8GaFDPJbaNhYPunb9aViCSfLQ==
X-Google-Smtp-Source: ABdhPJwlshI41cGpICCooLiwPeuraEzncc+PYXOpQqloZNRbeayCp96rTilTAh8P9FttI5LoA8wJWw==
X-Received: by 2002:a05:6102:2837:: with SMTP id ba23mr1670680vsb.48.1644337813217;
        Tue, 08 Feb 2022 08:30:13 -0800 (PST)
Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com. [209.85.217.47])
        by smtp.gmail.com with ESMTPSA id d202sm2897203vkd.38.2022.02.08.08.30.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Feb 2022 08:30:13 -0800 (PST)
Received: by mail-vs1-f47.google.com with SMTP id t22so3414577vsa.4;
        Tue, 08 Feb 2022 08:30:12 -0800 (PST)
X-Received: by 2002:a05:6102:34d9:: with SMTP id a25mr449611vst.68.1644337812410;
 Tue, 08 Feb 2022 08:30:12 -0800 (PST)
MIME-Version: 1.0
References: <20210331141755.126178-1-danilokrummrich@dk-develop.de>
 <20210331141755.126178-3-danilokrummrich@dk-develop.de> <YGSi+b/r4zlq9rm8@lunn.ch>
 <6f1dfc28368d098ace9564e53ed92041@dk-develop.de> <20210331183524.GV1463@shell.armlinux.org.uk>
 <2f0ea3c3076466e197ca2977753b07f3@dk-develop.de> <20210401084857.GW1463@shell.armlinux.org.uk>
 <YGZvGfNSBBq/92D+@arch-linux> <YGcOBkr2V1onxWDt@lunn.ch> <YGoEo3s/AxrjowLH@arch-linux>
In-Reply-To: <YGoEo3s/AxrjowLH@arch-linux>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 8 Feb 2022 17:30:01 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUCDYvjZCrybxSF5rLGM81Ujkg=CSp-ymFWV+E8S5Wq6A@mail.gmail.com>
Message-ID: <CAMuHMdUCDYvjZCrybxSF5rLGM81Ujkg=CSp-ymFWV+E8S5Wq6A@mail.gmail.com>
Subject: Re: [PATCH 2/2] net: mdio: support c45 peripherals on c22 busses
To:     Danilo Krummrich <danilokrummrich@dk-develop.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Danilo,

On Sun, Apr 4, 2021 at 8:26 PM Danilo Krummrich
<danilokrummrich@dk-develop.de> wrote:
> On Fri, Apr 02, 2021 at 02:28:54PM +0200, Andrew Lunn wrote:
> > > > Do you actually have a requirement for this?
> > > >
> > > Yes, the Marvell 88Q2112 1000Base-T1 PHY. But actually, I just recognize that it
> > > should be possible to just register it with the compatible string
> > > "ethernet-phy-ieee802.3-c22" instead of "ethernet-phy-ieee802.3-c45", this
> > > should result in probing it as c22 PHY and doing indirect accesses through
> > > phy_*_mmd().
> >
> > Hi Danilo
> >
> > Do you plan to submit a driver for this?
>
> Yes, I'll get it ready once I got some spare time.

Did this ever happen? I cannot find such a patch.

> > Does this device have an ID in register 2 and 3 in C22 space?
> >
> Currently, I don't have access to the datasheet and I don't remember.
> In a couple of days I should have access to the HW again and I will try.

I'm asking because I have access to a board with Marvell 88Q2110 PHYs
(ID 0x002b0983).

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
