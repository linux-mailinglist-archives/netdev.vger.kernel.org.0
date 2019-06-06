Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0126937569
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 15:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbfFFNkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 09:40:33 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:45949 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbfFFNkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 09:40:33 -0400
Received: by mail-ed1-f66.google.com with SMTP id f20so3358428edt.12;
        Thu, 06 Jun 2019 06:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XyKZGOkEQou4KU15s0eM7/xmgrMQTeq0y8ic/YS1EeQ=;
        b=QBs3cUKnpiJC4y3wMddJofgMuyHPH2GDt+RhtXW58W1gQcV2qnFaEtZZQ8zpLvIl0/
         tqYsAd+TV1QFLCB+1fjvKP7ABtLJ0WQ9YpDgWfXCIU9ashmoDLg+xKRsJU6uAGaUvknf
         D7kAok7H+f3MrvSzhbUUHjcp3wxKVnIpbNgZoV8+ARHeYITBg8EP5Tni0WpYy0gugYDg
         kS0G6DpuLDwzn3KwodScqNt1xS22Qgzv5WR+WClvio9XUVaUjfg5nzwu0RKqE8RyoI6W
         96Qrwm2w3SblHzUm+UmfYrBoLrvWjGh/PHiurHTAEqyITZA9f3QxnhSqvBho1n0RcEgA
         4jXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XyKZGOkEQou4KU15s0eM7/xmgrMQTeq0y8ic/YS1EeQ=;
        b=aSiXS/NDKkHScjC5LFSLWQZg6EUuc6AKVIg1eq6Rp+IgBIwrAvhSIEMddFg4m+VFMj
         jieNqI5jVdBfUdd42J8POKc8JL/4tAiSmqL1PozMQgtwxNJ1Laom99ixwid2BBT842hl
         xnJoXI4NllSxmR2Q3hfof9LaYMdZaYYrYV0fpGG7BOnIY4YdPdk9/jGK7RL/Dg9r6UOK
         offD+jPndloHk8Oyd43y13uExyqz5/LC1xDwH8my4RBPs9wnWWpkCFnKuAHh+ZWdGol4
         gNDEoSJugbErkzhHjfH4rR5pZcwyW98ScpyYyxYYmF0JOEHJNG+R+VrAEab2gngRbJNS
         0bng==
X-Gm-Message-State: APjAAAUJvwN/UL96Ok9fXn0EXIdba/NMF6sXcSUb2PNJbj4Ggr179390
        PCi06Q10pT8Y1W2TPk1z5m4GDKZ4IxqtSo0QhUI=
X-Google-Smtp-Source: APXvYqxMXYTkYCX8BJaN0HvZO0Qr0xwE4zY1ECtgA13OXsV02zMUavYzUodtZwcUXZjy3z4bSbz10O2E/5JM8qqzAbU=
X-Received: by 2002:aa7:c402:: with SMTP id j2mr43772531edq.165.1559828431164;
 Thu, 06 Jun 2019 06:40:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190604170756.14338-1-olteanv@gmail.com> <20190604.202258.1443410652869724565.davem@davemloft.net>
 <CA+h21hq1_wcB6_ffYdtOEyz8-aE=c7MiZP4en_VKOBodo=3VSQ@mail.gmail.com>
 <CA+h21hrJYm4GLn+LpJ623_dpgxE2z-k3xTMD=z1QQ9WqXg7zrQ@mail.gmail.com>
 <20190605174547.b4rwbfrzjqzujxno@localhost> <CA+h21hqdmu3+YQVMXyvckrUjXW7mstjG1MDafWGy4qFHB9zdtg@mail.gmail.com>
 <20190606031135.6lyydjb6hqfeuzt3@localhost>
In-Reply-To: <20190606031135.6lyydjb6hqfeuzt3@localhost>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 6 Jun 2019 16:40:19 +0300
Message-ID: <CA+h21hosUmUu98QdzKTJPUd2PEwa+sUg1SNY1ti95kD6kOqE6A@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 00/17] PTP support for the SJA1105 DSA driver
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 6 Jun 2019 at 06:11, Richard Cochran <richardcochran@gmail.com> wrote:
>
> On Wed, Jun 05, 2019 at 09:08:54PM +0300, Vladimir Oltean wrote:
> > Currently I'm using a cyclecounter, but I *will* need actual PHC
> > manipulations for the time-based shaping and policing features that
> > the switch has in hardware.
>
> Okay.
>
> > On the other hand I get much tighter sync
> > offset using the free-running counter than with hardware-corrected
> > timestamps.
>
> Why?  The time stamps come from the very same counter, don't they?
>

Plain and simply because it doesn't work very well.
Even phc2sys from the system clock to the hardware (no timestamps
involved) has trouble staying put (under 1000 ns offset).
And using the hardware-corrected timestamps triggers a lot of clockchecks.

> > So as far as I see it, I'll need to have two sets of
> > operations.
>
> I doubt very much that this will work well.
>
> > How should I design such a dual-PHC device driver? Just register two
> > separate clocks, one for the timestamping counter, the other for the
> > scheduling/policing PTP clock, and have phc2sys keep them in sync
> > externally to the driver?
>
> But how would phc2sys do this?  By comparing clock_gettime() values?
> That would surely introduce unnecessary time error.
>
> > Or implement the hardware corrections
> > alongside the timecounter ones, and expose a single PHC (and for
> > clock_gettime, just pick one of the time sources)?
>
> I would implement the hardware clock and drop the timecounter
> altogether.
>
> HTH,
> Richard
