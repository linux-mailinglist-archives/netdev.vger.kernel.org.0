Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09A70412BD5
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 04:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347846AbhIUCif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 22:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349307AbhIUCZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 22:25:47 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00CA0C0A88E0;
        Mon, 20 Sep 2021 11:59:19 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id eg28so42503949edb.1;
        Mon, 20 Sep 2021 11:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KgXM9Th44hJC0qez5EJQ9s1ObnIV+weJgRGKAcr82g8=;
        b=quPDK389xaGRi271X34gczU43zPLPDabIu81jvCHn/M5IHU2FTJUIT64jiAqLjhQHn
         83m4r4jEF8AHte22C7CtxKUBlHOHFoXZdz5gyD+rK1kw+1b+DvyS/tjnfMwOKMqRPUoh
         sbxYmElfUJnDILvPNJa1ST03mAZz7IVC7FiSJJVIFOZIDqNVZ0MSJnrQj7y3K6VGWotd
         625IA7oKNQEs77/DPghUg+CVwpf9DcB2nfT/0oOXC+zFEBpwgS8b5nVeEZVt/Za9NEFt
         jvFpxVV/08Zz/C9bCmxJ8iS84h8RVamEZSYwjwvoCTVBNGZsgv8+IoUvT3PTuQWQ7KFC
         Nhmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KgXM9Th44hJC0qez5EJQ9s1ObnIV+weJgRGKAcr82g8=;
        b=ZdOztD5oeN4VcUSvdUlXAa8Yx607HWeN+o6fL/ntPue0lL3VMbNuC5JtZe7XXAYKlF
         9Y5W1idnBQP1AjQMF+ApysKqPSVXxAVCHEiiqaaQSEHOif1p8M6ILZfvauvH1elpd0Ve
         rGiuSehlzxJOlqeEwg9mfNlDmtQ8h+Lfb1o8/wmLTkZM6hhRZ9ZfBWNkyDlqoORvyhxg
         GjZuC/UgWbJFdjvolrVqj5tpONyTWsycgaEkS+or31RcPdH7oLo5iOcQRyrkDqVcVRKb
         clW07tRYPsCbppqnPxWX+jWoXvW5lOqgN6PVtN+LW0dzMPwsgTN8pCtJhQIL1l4uNjOa
         ohqQ==
X-Gm-Message-State: AOAM530XgBrpFQlF6z3yjuufZgp46oXOZES4vAfq12Gud7eS02if6e9F
        ceY7HOqbcI2hOF/a0kWRuYyrM+nUBVlqUSad7JA=
X-Google-Smtp-Source: ABdhPJw70KtDAp1z7hhGqFMPHNlalXDeT7HMcvVLZgJ0yKkl3ivDBmuevxvoLjYSp6M2ugvuD1fqDP1tuO0DvvRf7V4=
X-Received: by 2002:a17:906:a08d:: with SMTP id q13mr29946771ejy.465.1632164357541;
 Mon, 20 Sep 2021 11:59:17 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wh-=tMO9iCA4v+WgPSd+Gbowe5kptwo+okahihnO2fAOA@mail.gmail.com>
 <202109201825.18KIPsV4026066@valdese.nms.ulrich-teichert.org> <CAHk-=wibRWoy4-ZkSVXUoGsUw5wKovPvRhS7r6VM+_GeBYZw1A@mail.gmail.com>
In-Reply-To: <CAHk-=wibRWoy4-ZkSVXUoGsUw5wKovPvRhS7r6VM+_GeBYZw1A@mail.gmail.com>
From:   Matt Turner <mattst88@gmail.com>
Date:   Mon, 20 Sep 2021 11:59:05 -0700
Message-ID: <CAEdQ38HeUPDyiZhhriHqdA+Qeyrb3M=FoKWKgs0dZaEjbcpVUQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] Introduce and use absolute_pointer macro
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Ulrich Teichert <krypton@ulrich-teichert.org>,
        Michael Cree <mcree@orcon.net.nz>,
        Guenter Roeck <linux@roeck-us.net>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        alpha <linux-alpha@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-parisc <linux-parisc@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Sparse Mailing-list <linux-sparse@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20, 2021 at 11:46 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Mon, Sep 20, 2021 at 11:26 AM Ulrich Teichert
> <krypton@ulrich-teichert.org> wrote:
> >
> > The main trouble is that my system has only 64MB of memory and the smallest
> > kernel image with all drivers I need was about 105MB big.
>
> Are you sure you aren't looking at some debug image?
>
> I just tried building something based on your Jensen config (lots of
> new questions, you sent your old config from 4.18.0-rc5 time), and I
> get
>
>   [torvalds@ryzen linux]$ ll -h arch/alpha/boot/vmlinux*
>   -rwxr-xr-x. 1 torvalds torvalds 5.4M Sep 20 11:32 arch/alpha/boot/vmlinux
>   -rw-r--r--. 1 torvalds torvalds 2.3M Sep 20 11:32 arch/alpha/boot/vmlinux.gz
>
> so yeah, it's not exactly tiny, but at 5.4MB it's certainly not 105MB.
>
> The "vmlinux" file itself is huge, but that's due to CONFIG_DEBUG_INFO=y.
>
> You can easily disable DEBUG_INFO entirely (or at least do
> DEBUG_INFO_REDUCED), and get much smaller files.
>
> With the attached config, the vmlinux file is just 7MB (but the actual
> one you boot is that same 5.4M file because it's been stripped).
>
> NOTE! The attached config is basically just the one you sent me, with
> "make defconfig" done and DEBUG_INFO removed. It might have drivers
> missing, or extraneous code that you don't need because of all the
> changes in config variables since that very old one.
>
> It would be very interesting to hear whether this all still boots. I
> do think people still occasionally boot-test some other alpha
> configurations, but maybe not.

I test on a couple of alpha configurations with some regularity:
Marvel (AlphaServer ES47) and Nautilus (UP1500). I have more systems I
could test but I'd need to get a lot more organized to make space.

In the decade plus I've been around Linux on alpha I've don't actually
recall hearing of anyone using Linux on a Jensen system before :)
