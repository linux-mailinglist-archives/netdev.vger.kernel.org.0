Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1D990B12
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 00:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbfHPWjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 18:39:53 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:41326 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727682AbfHPWjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 18:39:53 -0400
Received: by mail-io1-f67.google.com with SMTP id j5so9341487ioj.8
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 15:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7AYryAhE2LlsWHQ/jxdY2zHrq5QbI00PkggsfBrjw/w=;
        b=TGE2YrBOJbtsmiKbt6Qt8mbYBl5nMfNsI+G4d0lgLuxwFTKvBOOuPmkq8goGGkN5vj
         1fX3B9YuTnzsCYQn419aVoTKy0xTevySjD21mH6xJF6L58tBBKI5sqVYBNiSehwmyTc/
         +F9thgcq67IRiLAUg+jysHIQjddTtHzDAat4A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7AYryAhE2LlsWHQ/jxdY2zHrq5QbI00PkggsfBrjw/w=;
        b=U25dvnBrUpDb9s8HfUnc6EvGhadmCRLT7JC+cgU5MJiJqU+QWdN4dnfZQFHmFqAZS0
         Hi2otYlAnsDo8ENA7eyE2xYttjAhfRXHDQdf33LXwK7pAyN1NrumVtOA1Pu7a5Dxqu3B
         LRnYiWj/EuMNnkG3sJ8dTM/qoiJZgKACDMKFgefZ23+tqzwgHlR1GAo5KwQa91aWM2sN
         7y0xgDdrOxKD20FJr4zYNdyikmRrgHoDLIR7ongUUqDcUOKX3sXRHmgFxSZaU+MMRwV0
         PjmxZAXNVRr5deZ/+H7oplQTmmGa9InTpK/vJJdcyrrR6wGNUnx6zvu/+ekXDAly25ap
         w6dA==
X-Gm-Message-State: APjAAAUGEswVDpLbdwJ8KK9oWbpGiODurd3JGXC0+kCHN8Ikqo/WrHWN
        8cWMHxPll+MJU/qeHTL9qaGtO3Ddpmw=
X-Google-Smtp-Source: APXvYqxFaQccp9kdYqbjfUUEq5ITv2t6hQFFNVKXiR0kPYnUdE1kt5VfM0DqP5XUKltGlzr9bv81kg==
X-Received: by 2002:a6b:ea02:: with SMTP id m2mr7275898ioc.155.1565995192006;
        Fri, 16 Aug 2019 15:39:52 -0700 (PDT)
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com. [209.85.166.50])
        by smtp.gmail.com with ESMTPSA id w5sm11023129iom.33.2019.08.16.15.39.51
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Aug 2019 15:39:51 -0700 (PDT)
Received: by mail-io1-f50.google.com with SMTP id j4so9327552iop.11
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 15:39:51 -0700 (PDT)
X-Received: by 2002:a5e:d717:: with SMTP id v23mr13764165iom.52.1565995190898;
 Fri, 16 Aug 2019 15:39:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190813191147.19936-1-mka@chromium.org> <20190813191147.19936-5-mka@chromium.org>
 <20190816201342.GB1646@bug> <20190816212728.GW250418@google.com> <31dc724d-77ba-3400-6abe-4cf2e3c2a20a@gmail.com>
In-Reply-To: <31dc724d-77ba-3400-6abe-4cf2e3c2a20a@gmail.com>
From:   Doug Anderson <dianders@chromium.org>
Date:   Fri, 16 Aug 2019 15:39:36 -0700
X-Gmail-Original-Message-ID: <CAD=FV=WvWjcVX1YNxKsi_TmJP6vdBZ==bYOVGs2VjUqVhEjpuA@mail.gmail.com>
Message-ID: <CAD=FV=WvWjcVX1YNxKsi_TmJP6vdBZ==bYOVGs2VjUqVhEjpuA@mail.gmail.com>
Subject: Re: [PATCH v6 4/4] net: phy: realtek: Add LED configuration support
 for RTL8211E
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Matthias Kaehlcke <mka@chromium.org>, Pavel Machek <pavel@ucw.cz>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Aug 16, 2019 at 3:12 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> On 8/16/19 2:27 PM, Matthias Kaehlcke wrote:
> > On Fri, Aug 16, 2019 at 10:13:42PM +0200, Pavel Machek wrote:
> >> On Tue 2019-08-13 12:11:47, Matthias Kaehlcke wrote:
> >>> Add a .config_led hook which is called by the PHY core when
> >>> configuration data for a PHY LED is available. Each LED can be
> >>> configured to be solid 'off, solid 'on' for certain (or all)
> >>> link speeds or to blink on RX/TX activity.
> >>>
> >>> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> >>
> >> THis really needs to go through the LED subsystem,
> >
> > Sorry, I used what get_maintainers.pl threw at me, I should have
> > manually cc-ed the LED list.
> >
> >> and use the same userland interfaces as the rest of the system.
> >
> > With the PHY maintainers we discussed to define a binding that is
> > compatible with that of the LED one, to have the option to integrate
> > it with the LED subsystem later. The integration itself is beyond the
> > scope of this patchset.
> >
> > The PHY LED configuration is a low priority for the project I'm
> > working on. I wanted to make an attempt to upstream it and spent
> > already significantly more time on it than planned, if integration
> > with the LED framework now is a requirement please consider this
> > series abandonded.
>
> While I have an appreciation for how hard it can be to work in a
> corporate environment while doing upstream first and working with
> virtually unbounded goals (in time or scope) due to maintainers and
> reviewers, that kind of statement can hinder your ability to establish
> trust with peers in the community as it can be read as take it or leave it.

You think so?  I feel like Matthias is simply expressing the reality
of the situation here and I'd rather see a statement like this posted
than the series just silently dropped.  Communication is good.

In general on Chrome OS we don't spent lots of time tweaking with
Ethernet and even less time tweaking with Ethernet on ARM boards where
you might need a binding like this, so it's pretty hard to justify up
the management chain spending massive amounts of resources on it.  In
this case we have two existing ARM boards which we're trying to uprev
from 3.14 to 4.19 which were tweaking the Ethernet driver in some
downstream code.  We thought it would be nice to try to come up with a
solution that could land upstream, which is usually what we try to do
in these cases.

Normally if there is some major architecture needed that can't fit in
the scope of a project, we would do a downstream solution for the
project and then fork off the task (maybe by a different Engineer or a
contractor) to get a solution that can land upstream.  ...but in this
case it seems hard to justify because it's unlikely we would need it
again anytime remotely soon.

So I guess the alternatives to what Matthias did would have been:

A) Don't even try to upstream.  Seems worse.  At least this way
there's something a future person can start from and the discussion is
rolling.

B) Keep spending tons of time on something even though management
doesn't want him to.  Seems worse.

C) Spend his nights and weekends working on this.  Seems worse.

D) Silently stop working on it without saying "I'm going to stop".  Seems worse.

...unless you have a brilliant "E)" I think what Matthias did here is
exactly right.

BTW: I'm giving a talk on this topic next week at ELC [1].  If you're
going to be there feel free to attend.  ...or just read the slides if
not.


> The LED subsystem integration can definitively come in later from my 2
> cents perspective and this patch series as it stands is valuable and
> avoids inventing new bindings.

If something like this series can land and someone can later try to
make the situation better then I think that would be awesome.  I don't
think Matthias is saying "I won't spin" or "I won't take feedback".
He's just expressing that he can't keep working on this indefinitely.



[1] https://ossna19.sched.com/event/PVSV/how-chrome-os-works-with-upstream-linux-douglas-anderson-google

-Doug
