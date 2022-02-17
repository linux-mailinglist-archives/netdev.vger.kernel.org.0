Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7284B9644
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 04:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232217AbiBQDCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 22:02:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232212AbiBQDCL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 22:02:11 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 988B6ECB08;
        Wed, 16 Feb 2022 19:01:57 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id g1so3829667pfv.1;
        Wed, 16 Feb 2022 19:01:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9TATMg5XNmyHj9/wum7kE/N0AnlYkACa1RnuF2XMN4M=;
        b=kEqcEz+MUy7+urrkcE2qCxwNWkajGExK8R2BRi5V9jWLLnWy+oEDn6XXMGVI3QCuPd
         cUJvxOnNGy4ohBvk+euFQLBbY1aXq+2PdsXcP84IjpnimIUlARhtGMXmFywGP3LRdY7F
         LElpR7I97USrY3Qkz4V8EXzwYAFamJYlOcX1Q5eLkNZuMyqItK7ZGsLhgMxfy66C4cDF
         G7FOqD3hP+AsP5TmL5KyrYjRAQY5qh4sic/EXM5emC6Fn70sC9CdM6h46myzlm2MoFAK
         sH3xNzq7mQWOWsLRKijzXYXhTjwpz3eELUCYN22RtxK0sX2/4oGPoo+PygpxOZV6bSo1
         R8xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9TATMg5XNmyHj9/wum7kE/N0AnlYkACa1RnuF2XMN4M=;
        b=CQtcX7tSTzxd+rNQZ/GiAJnVEx5zGBpmRpnbfD6kWagbfd7XoChmOX/9jecTPf80io
         PSUv4AKzoE6JZLUhVZbgg9f+M8GIY/qFoutQjpBLncoCCHhhSpl0wP5HKt8vXOLQu0hH
         +kSsxVM9lTmp/gE0OVDy3aStPtLJ8XqDUWHIltHJi1u/EHCvzqR3jaDDkXx6VwGAsLcL
         B+Fm4KtkJMrzgzcI2kD6wdJTxU431SqqVTG4jKBuVICOirR/9tSzwTC7+GVSH3QXV+Zf
         WZKs+h/carP89+TYWP8OLvg/hcq76wIbp6mSMvN/1uDfYZ02/68hRoLgj4zT/hPsOLCI
         w4aQ==
X-Gm-Message-State: AOAM533OiJs6nZ8+mxZ4xOn42gbNOPIt6TIHtAxT1yS33sqt5zqW9iZq
        Ckky4JIoKYG6BgyZp0dkclV2MM3SQ5umFmp6MDI=
X-Google-Smtp-Source: ABdhPJx4wTo4FHWG7+UM1wYSIq+HXOioKgmDaw1/TSTTMSrS7GZHt8Wg189OVUyWtSLXRgQh3qUOcTaJdbRu8NZUu7M=
X-Received: by 2002:a05:6a00:be5:b0:4e1:9050:1e16 with SMTP id
 x37-20020a056a000be500b004e190501e16mr892036pfu.78.1645066916960; Wed, 16 Feb
 2022 19:01:56 -0800 (PST)
MIME-Version: 1.0
References: <20220216160500.2341255-1-alvin@pqrs.dk> <20220216160500.2341255-3-alvin@pqrs.dk>
 <20220216233906.5dh67olhgfz7ji6o@skbuf>
In-Reply-To: <20220216233906.5dh67olhgfz7ji6o@skbuf>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Thu, 17 Feb 2022 00:01:45 -0300
Message-ID: <CAJq09z6XBQUTBZoQ81Vy3nUc_5QGTF0GH8V-S3bXOw=JpYODvA@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: dsa: realtek: rtl8365mb: serialize
 indirect PHY register access
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Michael Rasmussen <mir@bang-olufsen.dk>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

> This implementation where the indirect PHY access blocks out every other
> register read and write is only justified if you can prove that you can
> stuff just about any unrelated register read or write before
> RTL8365MB_INDIRECT_ACCESS_READ_DATA_REG, and this, in and of itself,
> will poison what gets read back from RTL8365MB_INDIRECT_ACCESS_READ_DATA_=
REG.

I was the first one trying to fix this issue reported by Arin=C3=A7 with
SMP devices. At first I thought it was caused by two parallel indirect
access reads polling the interface (it was not using interrupts). With
no lock, they will eventually collide and one reads the result of the
other one. However, a simple lock over the indirect access didn't
solve the issue. Alvin tested it much further to isolate that indirect
register access is messed up by any other register read. The fails
while polling the interface status or the other test Alvin created
only manifests in a device with multiple cores and mine is single
core. I do get something similar in a single core device by reading an
unused register address but it is hard to blame Realtek when we are
doing something we were not supposed to do. Anyway, that indicates
that "reading a register" is not an atomic operation inside the switch
asic.

> rtl8365mb_mib_counter_read() doesn't seem like a particularly good
> example to prove this, since it appears to be an indirect access
> procedure as well. Single register reads or writes would be ideal, like
> RTL8365MB_CPU_CTRL_REG, artificially inserted into strategic places.
> Ideally you wouldn't even have a DSA or MDIO or PHY driver running.
> Just a simple kernel module with access to the regmap, and try to read
> something known, like the PHY ID of one of the internal PHYs, via an
> open-coded function. Then add extra regmap accesses and see what
> corrupts the indirect PHY access procedure.

The MIB might be just another example where the issue happens. It was
first noticed with a SMP device without interruptions configured. I
believe it will always fail with that configuration.

> Are Realtek aware of this and do they confirm the issue? Sounds like
> erratum material to me, and a pretty severe one, at that. Alternatively,
> we may simply not be understanding the hardware architecture, like for
> example the fact that MIB indirect access and PHY indirect access may
> share some common bus and must be sequential w.r.t. each other.

The realtek "API/driver" does exactly how the driver was doing. They
do have a lock/unlock placeholder, but only in the equivalent
regmap_{read,write} functions. Indirect access does not use locks at
all (in fact, there is no other mention of "lock" elsewhere), even
being obvious that it is not thread-safe. It was just with a DSA
driver that we started to exercise register access for real, specially
without interruptions. And even in that case, we could only notice
this issue in multicore devices. I believe that, if they know about
this issue, they might not be worried because it has never affected a
real device. It would be very interesting to hear from Realtek but I
do not have the contacts.

Regards,

Luiz
