Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 258AEADAC1
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 16:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405170AbfIIOI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 10:08:29 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:42210 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405006AbfIIOI3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 10:08:29 -0400
Received: by mail-ed1-f67.google.com with SMTP id y91so13063017ede.9;
        Mon, 09 Sep 2019 07:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=2FS58PggvyWLn/0tFyaU8y/bUOUccAIKQlhkdNJPkXA=;
        b=l2OZJDs0FLhUj51XKQxR3ruXa0dPYNcVgnUa5Dk2UeYkOv79M1yzY2YKIEuGzV1HaK
         NCuTprJlgQtYhFDoPNHiu71OZgX2OwOy2xqxvJLXOVF9ydf+oovwcQfAujAmHE66AxkJ
         oJh/dSsS7tOyQ1j6qZN7VwLtgpyh4UO3taYi5+JrrNmwnlUmIsJNpd+IibaNStJTeVF5
         +Z0CqsgSDlnQjIfUfQnhsBTMawuUN6NtNIFw5g3l91+JTwvslGsqOknuHLsg+5nthCCf
         9kLxUOTd9bZs4lav/YqTgmBExUD8+AXV+u0P2vVlDbGqTwfISzwWw7qf5pHlIkLaL2MS
         6ebA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=2FS58PggvyWLn/0tFyaU8y/bUOUccAIKQlhkdNJPkXA=;
        b=f1ZU2Bd6Csi6WHaVxnoaohRzIYDH+LfkswjKxZVYKo931IKXogG8MCp1zUcrPOxt2u
         6aZkfmkPHhh5HUUVnLkY6wXBhImNGhHwugDWqe+iwwBOdSgNoPhdZCyzHYA9kAzVqoGC
         ljaj45NL6f3+w7OyFXR5CspeXuc8wEO87Usz17PZNG9QKlJFcMM+uoIDM2l45cnRSnIk
         DHS0WbZ6pdF6JB6A03a9doj3gWhyeoqulMuf83ufC6mXyby374Kswl8TL1UxPbSAeXG1
         /R9AEkpolGAt2IXx+I66+a7ZWLPEXPemyQz7K8G5FltH2EDpW+B7P9b157JjGr/HB3l/
         E3hA==
X-Gm-Message-State: APjAAAW3SlA7efUn9RCPshjnfgzsHMxPiLU6tKSlz/8t1xHoVYdwO0Es
        XEaHFNzarn7pt7FgNr+v1Cu7x5L5+daRZfKhsRY=
X-Google-Smtp-Source: APXvYqxsZkWIQW3Up2QDz6jI4dzXNKTXwH/MXVGXYCojbmnkJNFZXebDuAKJNfe+K0+sIBcbwE8ataPCsmXmNdGz+Vk=
X-Received: by 2002:a17:906:4708:: with SMTP id y8mr19805010ejq.204.1568038107081;
 Mon, 09 Sep 2019 07:08:27 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:906:e258:0:0:0:0 with HTTP; Mon, 9 Sep 2019 07:08:26
 -0700 (PDT)
In-Reply-To: <20190909100618.GC2036@sirena.org.uk>
References: <20190905010114.26718-1-olteanv@gmail.com> <20190909100618.GC2036@sirena.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 9 Sep 2019 15:08:26 +0100
Message-ID: <CA+h21hocjvF_-cvGEgank3_tgVBfCQLtp2seLguOCp0S=cx9Jw@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] Deterministic SPI latency with NXP DSPI driver
To:     Mark Brown <broonie@kernel.org>
Cc:     h.feurstein@gmail.com, mlichvar@redhat.com,
        richardcochran@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        linux-spi@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mark,

On 09/09/2019, Mark Brown <broonie@kernel.org> wrote:
> On Thu, Sep 05, 2019 at 04:01:10AM +0300, Vladimir Oltean wrote:
>
>> This patchset proposes an interface from the SPI subsystem for
>> software timestamping SPI transfers. There is a default implementation
>> provided in the core, as well as a mechanism for SPI slave drivers to
>> check which byte was in fact timestamped post-facto. The patchset also
>> adds the first user of this interface (the NXP DSPI driver in TCFQ mode).
>
> I think this is about as good as we're going to get but we're
> very near the merge window now so I'll leave this until after the
> merge window is done in case there's more review comments before
> applying.  I need to reread the implementation code a bit as
> well, it looked fine on a first scan through but it's possible I
> might spot something later.
>

There's one thing I still don't like, and that is the fact that the
delay for sending one SPI word is so low, I can't actually capture it
precisely with a "pre" and a "post" system clock timestamp. What
actually happens is that I'm actually measuring the timing of the (too
loose) CPU loop. Normally that's not bad, because the guarantee that
the transfer happened between "pre" and "post" is still kept. But I'm
introducing a false jitter in the delays I'm reporting ("post" -
"pre") that does not actually depend upon the hardware phenomenon, but
on the CPU frequency :) At maximum CPU frequency (performance
governor) the reported latency is always constant, but still larger
than the SPI transfer time. In fact it's constant exactly _because_
the CPU frequency is constant. When the CPU goes at lower frequencies,
user space gets confused about the varying delay and my control loop
doesn't keep lock as well.
So in fact I wonder whether I'm using the PTP system timestamping API
properly. One idea I had was to just timestamp the write to the TX
FIFO, and add a constant delay based on bytes_per_word * (NSEC_PER_SEC
/ speed_hz). IMHO that correction should logically be applied to both
"pre" and "post". Then say that the "post" is equal to the "pre". But
that would mean I'm reporting a delay of zero, and losing the
guarantee that the transfer actually happens between the reported
"pre" and "post". On the other hand, introducing a static correction
option could potentially help with the drivers that just get notified
of a DMA completion.
The other idea was to just push the PTP system timestamping all the
way into regmap_write, and just minimize the governor effect by making
sure the timestamped area of code is really short. I don't really
know.
