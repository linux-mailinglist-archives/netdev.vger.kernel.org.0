Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 027489856C
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 22:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730411AbfHUURg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 16:17:36 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:42120 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730394AbfHUURg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 16:17:36 -0400
Received: by mail-ed1-f66.google.com with SMTP id m44so4417502edd.9;
        Wed, 21 Aug 2019 13:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ruBGqBHEZj6R/n/UictnSOt4uBIxPDwxz3lLXAx5KwQ=;
        b=TjtYqJXGB/ykDyoql5KzZMYJtSqAkzKLEoLN0oIw+TDOyLXtUwISXHkbgAE6kSaB0O
         BD/OqrB+EkVTCs5dStJPFud36VrgCh6S0cCSVIewHN6bWX9FJoRfNS9w3iqMpyZM7+fE
         vNHTf+6giCBptFtOyyugGBc4oNrzzVxptwRFR7Q+4Y6lp7NJ3T5LSjeGRz/VAJ8cbkRJ
         GfAo27UhPUUBTA1MXHtc45G3AE1K9XusnvJpWvYu1jRf6ZRw8HcvZRyUkrxYlMBNdMIr
         32KNZraY7X68nEwxm8V5rpp1gS79Fi6rKWpTR7zW6shhi+D62tqAlBeFXgEL/48c1XhH
         PX2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ruBGqBHEZj6R/n/UictnSOt4uBIxPDwxz3lLXAx5KwQ=;
        b=tLT26rqPJ07R0CkGfl9BI1L/CT2BYjs7VwdELHBwcuGGA2K2peenWMRZK24vImOhpP
         bk3E04YGUXle3T9F+xeDG9SCMURIxTf8/9Xflvzwh2TNFFSV/co8VXTucW9baTnvveK8
         vcwFeBr9ZXT9dv9HelhXUx5X7bql+gZwwEN7XhNxhsPHXst5u/JNdliRNWkygkj2gIxI
         YZpJRmOuoy4dYjcNVhCo7F6xUSsQJW4rKyKmaQaBP+tGQmNv/4QCFdScLgr+cee9lz1k
         U5gO8EoLBkW436mx3khNcBHyEF0kdvojjrzYjrZLW6dssypVtz6xO+Juqfqt85k8Xb4d
         5cDQ==
X-Gm-Message-State: APjAAAV4Lt8QB4uOJlI2NA6QhlP7+YNodQ4bfvGOpYd554jRwG8+ubJi
        XxjITO3vwNGCZhsgSBWjloOVs1D7mtBbPIW2QKytVWWraoOovg==
X-Google-Smtp-Source: APXvYqwrP74wLb8m1ilmOXBfMt5Dg1EAdXEgveAHXhEDWzyQtEPWsxKC1sjKAnqCQRyTeXPVKbPDcO8XqmsG9w7J0xY=
X-Received: by 2002:a17:906:c445:: with SMTP id ck5mr23858690ejb.15.1566418654176;
 Wed, 21 Aug 2019 13:17:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190818182600.3047-1-olteanv@gmail.com> <CA+h21hr4UcoJK7upNJjG0ibtX7CkF=akxVdrb--1AJn6-z=sUQ@mail.gmail.com>
 <20190821043845.GB1332@localhost> <20190821140815.GA1447@localhost>
In-Reply-To: <20190821140815.GA1447@localhost>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 21 Aug 2019 23:17:23 +0300
Message-ID: <CA+h21hrtzU1XL-0m+BG5TYZvVh8WN6hgcM7CV5taHyq2MsR5dw@mail.gmail.com>
Subject: Re: [PATCH spi for-5.4 0/5] Deterministic SPI latency with NXP DSPI driver
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Mark Brown <broonie@kernel.org>,
        Hubert Feurstein <h.feurstein@gmail.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-spi@vger.kernel.org, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Richard,

On Wed, 21 Aug 2019 at 17:08, Richard Cochran <richardcochran@gmail.com> wrote:
>
> On Tue, Aug 20, 2019 at 09:38:45PM -0700, Richard Cochran wrote:
> > Overall, the PTP switch use case is well supported by Linux.  The
> > synchronization of the management CPU to the PTP, while nice to have,
> > is not required to implement a Transparent Clock.  Your specific
> > application might require it, but honestly, if the management CPU
> > needs good synchronization, then you really aught to feed a PPS from
> > the switch into a gpio (for example) on the CPU.
>
> Another way to achieve this is to have a second MAC interface on the
> management CPU connected to a spare port on the switch.  Then time
> stamping, PHC, ptp4l, and phc2sys work as expected.
>
> Thanks,
> Richard

Of course PPS with a dedicated hardware receiver that can take input
compare timestamps is always preferable. However non-Ethernet
synchronization in the field looks to me like "make do with whatever
you can". I'm not sure a plain GPIO that raises an interrupt is better
than an interrupt-driven serial protocol controller - it's (mostly)
the interrupts that throw off the precision of the software timestamp.
And use Miroslav's pps-gpio-poll module and you're back from where you
started (try to make a sw timestamp as precise as possible).
As for dedicating a second interface pair in (basically) loopback just
for sync, that's how I'm testing PTP when I don't have a second board
and hence how the idea occurred to me. I can imagine this even getting
deployed and I can also probably name an example, but it certainly
wouldn't be my first choice. But DSA could have that built-in, and
with the added latency benefit of a MAC-to-MAC connection.
Too bad the mv88e6xxx driver can't do loopback timestamping, that's
already 50% of the DSA drivers that support PTP at all. An embedded
solution for this is less compelling now.

Regards,
-Vladimir
