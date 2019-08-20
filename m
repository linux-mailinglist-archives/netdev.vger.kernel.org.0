Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C153D96193
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 15:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730363AbfHTNsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 09:48:52 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:34523 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729833AbfHTNsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 09:48:52 -0400
Received: by mail-ed1-f67.google.com with SMTP id s49so6417742edb.1;
        Tue, 20 Aug 2019 06:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m+JdZSXD0D2c02Imv40GB5KWh8cWJNBa36c7pON1v6s=;
        b=hqY92RF0L3162rzl/kU0ZJ+pZpjLuw8SBGXb0Z3uxTPvLjmtNi34GyPjhNAdbElXuu
         ppp1IZKQ2QMWwgeEJ08aTY+0bWJqKkolN25kwPTgVKRgbcDQ5/+UXM++2O5iAiMcy+Ht
         4VPlGY0LiK/INND7svw/fKBgPCOc6nzIYA9qE87kCV6t+pipJyYl9ZC+eAAr5LR05YwT
         9OLVrR7b75OTiEwgJHtUQGEXMxIPlJC+t3+2uvdlcm0eYOmfVAYCsF2saV056s8ZRD/z
         2Ik9318u9FYKcaRBddGyq8e+ErrezwjNV7Zn8CVCuBexa74W8f5acKZ10YOosPI6+2kt
         12gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m+JdZSXD0D2c02Imv40GB5KWh8cWJNBa36c7pON1v6s=;
        b=SfGUZR+oFesUXqVg9WGHkn1oXM1lN8qSlhuPo7E/bcgjBSeJO2kAtx6EJ+PrDmUK0X
         jNpMZUqVSnsCT6hMCGkuNhoMYmOVc//qlKRwoFLi7GCCpiDjvRlBkgUBcT6Gn8bhRJB/
         cGbLY9jZL5L1j7rCOKytPnoDV1n9LdqjiMjvVDfeFmXgst8opqW8iiWj8rOvpzJDzcUC
         uz9x6cKfrLRUuxIpf15lQFoehOkoan01VaBGwFA79vHATCi7kyDZmHAdPo8f/VJ7HMAQ
         WA50rELQgHsAgnv9FP43CXrpb+qgCAa8nGVqAvhF7d8Y07Wnw9u5tLhWEIOpeGR3J/+l
         55GA==
X-Gm-Message-State: APjAAAX6boJAQtKXnv+CT4vs9xcoKkToUO8mI+SJLjvNvx2cZzkxXW1k
        HAJRgUqYxY6ZmwuTMOwPFcqTUy8kIRa0vgGqbqw=
X-Google-Smtp-Source: APXvYqzUZIKwnbDgamVnX9gB78XfXRD3TsYr5rvVNhkOU18V0B78GCOJnJ6SGd5MKO0bVNaUzRkH38cnHCbn0lSZaig=
X-Received: by 2002:a17:906:4683:: with SMTP id a3mr25606222ejr.47.1566308930492;
 Tue, 20 Aug 2019 06:48:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190816004449.10100-1-olteanv@gmail.com> <20190816004449.10100-4-olteanv@gmail.com>
 <20190816121837.GD4039@sirena.co.uk> <CA+h21hqatTeS2shV9QSiPzkjSeNj2Z4SOTrycffDjRHj=9s=nQ@mail.gmail.com>
 <20190816125820.GF4039@sirena.co.uk> <CA+h21hrZbun_j+oABJFP+P+V3zHP2x0mAhv-1ocF38miCvZHew@mail.gmail.com>
 <20190820125557.GB4738@sirena.co.uk>
In-Reply-To: <20190820125557.GB4738@sirena.co.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 20 Aug 2019 16:48:39 +0300
Message-ID: <CA+h21hr653oqOPxoJKWkP9ZhTywNR8EBjWV7U9LHwPRz=PJXsw@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 03/11] spi: Add a PTP system timestamp to the
 transfer structure
To:     Mark Brown <broonie@kernel.org>
Cc:     Hubert Feurstein <h.feurstein@gmail.com>, mlichvar@redhat.com,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-spi@vger.kernel.org, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mark,

On Tue, 20 Aug 2019 at 15:55, Mark Brown <broonie@kernel.org> wrote:
>
> On Fri, Aug 16, 2019 at 05:05:53PM +0300, Vladimir Oltean wrote:
>
> > I'm not sure how to respond to this, because I don't know anything
> > about the timing of DMA transfers.
> > Maybe snapshotting DMA transfers the same way is not possible (if at
> > all). Maybe they are not exactly adequate for this sort of application
> > anyway. Maybe it depends.
>
> DMA transfers generally proceed without any involvement from the CPU,
> this is broadly the point of DMA.  You *may* be able to split into
> multiple transactions but it's not reliable that you'd be able to do so
> on byte boundaries and there will be latency getting notified of
> completions.
>
> > In other words, from a purely performance perspective, I am against
> > limiting the API to just snapshotting the first and last byte. At this
> > level of "zoom", if I change the offset of the byte to anything other
> > than 3, the synchronization offset refuses to converge towards zero,
> > because the snapshot is incurring a constant offset that the servo
> > loop from userspace (phc2sys) can't compensate for.
>
> > Maybe the SPI master driver should just report what sort of
> > snapshotting capability it can offer, ranging from none (default
> > unless otherwise specified), to transfer-level (DMA style) or
> > byte-level.
>
> That does then have the consequence that the majority of controllers
> aren't going to be usable with the API which isn't great.
>

Can we continue this discussion on this thread:
https://www.spinics.net/lists/netdev/msg593772.html
The whole point there is that if there's nothing that the driver can
do, the SPI core will take the timestamps and record their (bad)
precision.

> > I'm afraid more actual experimentation is needed with DMA-based
> > controllers to understand what can be expected from them, and as a
> > result, how the API should map around them.
> > MDIO bus controllers are in a similar situation (with Hubert's patch)
> > but at least there the frame size is fixed and I haven't heard of an
> > MDIO controller to use DMA.
>
> I'm not 100% clear what the problem you're trying to solve is, or if
> it's a sensible problem to try to solve for that matter.

The problem can simply be summarized as: you're trying to read a clock
over SPI, but there's so much timing jitter in you doing that, that
you have a high degree of uncertainty in the actual precision of the
readout you took.
The solution has two parts:
- Make the SPI access itself more predictable in terms of latency.
This is always going to have to be dealt with on a driver-by-driver,
hardware-by-hardware basis.
- Provide a way of taking a software timestamp in the time interval
when the latency is predictable, and as close as possible to the
moment when the SPI slave will receive the request. Disabling
interrupts and preemption always helps to snapshot that critical
section. Again, the SPI core can't do that. And finding the correct
"pre" and "post" hooks that surround the hardware transfer in a
deterministic fashion is crucial. If you read the cover letter, I used
a GPIO pin to make sure the timestamps are where they should be, and
that they don't vary in width (post - pre) - there are also some
screenshots on Gdrive. Maybe something similar is not impossible for a
DMA transfer, although the problem formulation so far is too vague to
emit a more clear statement.
If you know when the SPI slave's clock was actually read, you have a
better idea of what time it was.

Regards,
-Vladimir
