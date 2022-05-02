Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0CD6517239
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 17:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385654AbiEBPJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 11:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385660AbiEBPIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 11:08:41 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88A0C10E6;
        Mon,  2 May 2022 08:05:11 -0700 (PDT)
Received: from mail-yw1-f179.google.com ([209.85.128.179]) by
 mrelayeu.kundenserver.de (mreue108 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1MryOx-1oEmLg2M1l-00nxkF; Mon, 02 May 2022 17:05:09 +0200
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-2ec42eae76bso150714817b3.10;
        Mon, 02 May 2022 08:05:09 -0700 (PDT)
X-Gm-Message-State: AOAM531qJEsIAio7JduzkVdmX1EK2TQP8rIcNodqd4lUARfvitrqpSKk
        C+aOAOuNwdLew/HhVVjv5rK9mC79+fAiLxh5nUI=
X-Google-Smtp-Source: ABdhPJxAfT0mtI2mFGcDcjtQzedzMQz8eYf0Fg1hWBegKvQSKsyfxj/GbmFIqytbHgyFBYqHFBk+z8YEmiN6Z7/aQXY=
X-Received: by 2002:a81:ad7:0:b0:2e6:84de:3223 with SMTP id
 206-20020a810ad7000000b002e684de3223mr11916494ywk.209.1651503907978; Mon, 02
 May 2022 08:05:07 -0700 (PDT)
MIME-Version: 1.0
References: <1676021ae8b6d7aada0b1806fed99b1b8359bdc4.1651495112.git.hns@goldelico.com>
 <CAK8P3a3OiFJiR40FXmCZTc1fMZBteGjXqipDcvZqoO85QBxYow@mail.gmail.com> <123640FA-6AF2-4C0E-A7CC-31DCC4CEA15B@goldelico.com>
In-Reply-To: <123640FA-6AF2-4C0E-A7CC-31DCC4CEA15B@goldelico.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 2 May 2022 17:04:51 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0owDwLYJ1nk6HciV=15wecC6QHPY-QiseRmeRnahcXXQ@mail.gmail.com>
Message-ID: <CAK8P3a0owDwLYJ1nk6HciV=15wecC6QHPY-QiseRmeRnahcXXQ@mail.gmail.com>
Subject: Re: [PATCH] wl1251: dynamically allocate memory used for DMA
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Discussions about the Letux Kernel 
        <letux-kernel@openphoenux.org>, kernel@pyra-handheld.com,
        linux-omap <linux-omap@vger.kernel.org>,
        Luca Coelho <luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:zjQz1dRpin9BiZg3s4VBfMuW9U+tlPf2caryZKIggkYhZ9Cjemd
 ow0D5GPGmRyloMl0oFDiGVSTOcj+6eu1WRzK2U5RioJjJ6icxlipq0t8eyFQLRz3yIcnXd9
 qoGiYQfXLpaXpfG+iBH0QqAGH9UcOaqPsszZbfbCGBlMNMuD6O15gsi8OkdBu2K2yGf6D7Z
 agURek6T9zdUGkRBpxD+g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:+cN6JuZ3Xro=:DVKj7YeXKBDE0Q9n6DEm06
 zXsZXZaulGdxTb7bhZwiH5xbP8lT2A4gv8QuMqzIevINKjnFi5uAqEYgJETFmRed1uTeZHwfc
 XQwq9QD+UN97jr+gRsqi2kekTgPzMKR6Q+xkzTKHxZKuB3j3Bd8+/ld/kODfmm976DJTJx2Cw
 ZVE0RG5aPH61joAXXYLeotKSMLraYmqxbkGoWrGtY1Za0+EQw/yXuuXVCvjpaBJ2bmYqBicOM
 /uQ6ZIpDCkgdmWlSmvnXlSLOOMVhKbmj/ynGyo749ZIlnb5MAtSo+CYF6BweAUrtOkAu3YhaZ
 uSXurW96e9Sd2gOxWTgBgD2+JF1nYZJwy+SoHWiwv3SFjhxVfkWP0Dexq2qObQHXFDujyzMJf
 k/yssEMaWTepybDzutgQae46ge30N4fUhv/vuxsb9hVK3YknAYo0h3SapvpBJ5H/xd/T8/5uM
 9OFMS8Yl+zLcrqK+Ui0Wpn0tICLFQZMzvydVPyjBnb0s5JFQzF6sWhHG1g8wGbMNRKneubUh2
 vW2FNcfrcbY9V2HuAODHrl4NSir3iyuvtc4iRDRFomWpyZ3MtUemFORxXr1mQ9thsnklvyi26
 eFVX8zIXBe5zcmrJ4XvrikG9DtMPJlcZVrh8km8+L285dI260csYPNL3Qi0TZYDMsWOBVYjFw
 hcWNfxKQEX+1jFi3gp9jOc763x4HK3krfb5klOa7NpXJAVPR5WlZ8DlSiDZHWlps5JJqPdhWG
 VXdiRJSuX/OedDmfr6K3X8ERvvegTf5BhpvMHiWk8fCIlxmZ6K0lTmwTqk1vZ0tBOVdoyY9gq
 xGIlNpmiaTKh18E7cNZDi7H0RUBDH/76AMh40HIwrx79ta9NXs=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 2, 2022 at 4:47 PM H. Nikolaus Schaller <hns@goldelico.com> wrote:
> > Am 02.05.2022 um 16:06 schrieb Arnd Bergmann <arnd@arndb.de>:
> > On Mon, May 2, 2022 at 2:38 PM H. Nikolaus Schaller <hns@goldelico.com> wrote:
> >
> > The approach in the wlcore driver appears to be simpler because it
> > avoids dynamic memory allocation and the associated error handling.
>
> It looks as if it just avoids kmalloc/free sequences in event handling
> by allocating a big enough buffer once.
>
> wl1271_cmd_wait_for_event_or_timeout() allocates it like we do now.

Ah right, I missed that one.

> > However, it probably makes another problem worse that also exists
> > here:
> >
> > static inline u32 wl1251_read32(struct wl1251 *wl, int addr)
> > {
> >       u32 response;
> >       wl->if_ops->read(wl, addr, &wl->buffer_32, sizeof(wl->buffer_32));
> >       return le32_to_cpu(wl->buffer_32);
> > }
> >
> > I think the 'buffer_32' member of 'struct wl1251' needs an explicit
> > '__cacheline_aligned' attribute to avoid potentially clobbering
> > some of the structure during a DMA write.
> >
> > I don't know if anyone cares enough about the two drivers to
> > have an opinion. I've added Luca to Cc, but he hasn't maintained
> > the driver since 2013 and probably doesn't.
>
> Well, there seems to be quite some common code but indeed devices
> using these older chips are getting rare so it is probably not worth
> combining code. And testing needs someone who owns boards
> with both chips...

No, I wasn't even thinking of combining code, just whether there
is value in keeping the similar bits in sync to ensure we have the
same set of bugs on both ;-)

I think the best fix for both drivers would be to keep the DMA
members (partition and buffer_32) in the respective device
structures, but mark each one as aligned.

> > My first guess would be that the driver never worked correctly on big-endian
> > machines, and that the change is indeed correct, but on the other hand
> > the conversion was added in commit ac9e2d9afa90 ("wl1251: convert
> > 32-bit values to le32 before writing to the chip") in a way that suggests it
> > was meant to work on both.
>
> wl1251_event_wait() seems to work with the masks provided by code.
> So I guess the conversion to le32 is harmless on the OpenPandora.
> Most likely it should be done on big endian devices. I.e. we might have
> done the right thing.
>
> Let's see if someone compains or knows more. Otherwise we should
> fix it just for the Pandora and N900 (both omap3 based) as the only
> upstream users.

Ok. In general I like ensure we keep things working for big-endian
kernels, which are meant to work on any ARMv6+ or newer machine.
Most of the time it's just a couple of drivers (like this one) that get
in the way of actually doing it, but then again very few people ever
care about big-endian ARMv6/v7.

If we don't have a reason to believe this one is actually wrong, I think
fixing the endian issue silently is fine, as is ignoring the potential
other endian issues in the same driver that nobody complained about
in the past decade ;-)

       Arnd
