Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52C0940B729
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 20:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231933AbhINSuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 14:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbhINSuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 14:50:17 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D032AC061574;
        Tue, 14 Sep 2021 11:48:59 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id bt14so565733ejb.3;
        Tue, 14 Sep 2021 11:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Uq5oGERE4sjyCGkMKfN92xVkl++WG98sgSfL2ZwL0dQ=;
        b=d3tPoxIXu/+AVq+klsRAtphmLTStCE1UoHjVw/3bizO66RRUfiFcYmVwTy5YciWe/p
         M0N36tWwsNeOghDlxlm4DRAfNZDOzu7gmZKfNJoiPmWwCDj7N1Azlq4EjxUv7IrLqYBU
         lyvcjjJ/D8/h2KHFWIlPI9UMNhdJFXEKty8L8ZayDVLgVO8ErOgWNgwwm/g2/+/NRyTQ
         iYGxaggJOO3gvD3FcweHd2Gt70bq3RCGuDK2yVtfOOajTWTJ2lfPisA2AyiiCiq+APXO
         b41ed75isJqAgY+XWIu+JMAdHCRCxguNiLiDd3f/croZndvnQzV33FfbUTqMA6VCmExK
         NZDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Uq5oGERE4sjyCGkMKfN92xVkl++WG98sgSfL2ZwL0dQ=;
        b=OQM46eX267h2t1GCgiGxWxqOKNuk3Arv8HQw23GqbXC8pC+ON4DBajwIw6CUVT6p/d
         0+ApfIL7/ol/XMIkJdkHGIFHwomLJ4TjvrdEHuhIRD6521WilSRViGq1FEpVCnghmYzV
         6olSK+Q5DVthjagE5d8FN0tEHIdg4CAB61CIq0gQXgCxv9srU5pBL+ta4puWiMcOTyJb
         8nGO2uK2VgVdZsrjdyGntbjn1y/1/+Zb/VQ27gIVUODP7L07NX+Cw/V4JNLZ9WHSHGB5
         L37uJYGA+B54Ys+GsXreMCPe+t2RWMg9nyLs4q6jqJqmF4HI9hIRXNWeORPNTbmcOt8h
         gP8Q==
X-Gm-Message-State: AOAM530bG/n51admlJ+IJ5PJZ1ZdleyDoxgqmUee27tTPNZQFvrhPF74
        R4iwgIIQmPY2kD4qqNihe3I=
X-Google-Smtp-Source: ABdhPJwcOVAxMZFPVaeel37vg0iCpWqVtCX5vjSscVNCkrpNTVYaoo35xMvZ5Yv4xdGtX2ARW7o6Bw==
X-Received: by 2002:a17:906:1451:: with SMTP id q17mr20107899ejc.214.1631645338343;
        Tue, 14 Sep 2021 11:48:58 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id w8sm3972600ejq.72.2021.09.14.11.48.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 11:48:57 -0700 (PDT)
Date:   Tue, 14 Sep 2021 21:48:56 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Saravana Kannan <saravanak@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, p.rosenberger@kunbus.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Fix for KSZ DSA switch shutdown
Message-ID: <20210914184856.vmqv3je4oz5elxvp@skbuf>
References: <5b899bb3-ed37-19ae-8856-3dabce534cc6@gmx.de>
 <20210909225457.figd5e5o3yw76mcs@skbuf>
 <35466c02-16da-0305-6d53-1c3bbf326418@gmail.com>
 <YTtG3NbYjUbu4jJE@lunn.ch>
 <20210910145852.4te2zjkchnajb3qw@skbuf>
 <53f2509f-b648-b33d-1542-17a2c9d69966@gmx.de>
 <20210912202913.mu3o5u2l64j7mpwe@skbuf>
 <trinity-e5b95a34-015c-451d-bbfc-83bfb0bdecad-1631529134448@3c-app-gmx-bs55>
 <20210913104400.oyib42rfq5x2vc56@skbuf>
 <trinity-6fefc142-df4d-47af-b2bd-84c8212e5b1c-1631530880741@3c-app-gmx-bs55>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <trinity-6fefc142-df4d-47af-b2bd-84c8212e5b1c-1631530880741@3c-app-gmx-bs55>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 13, 2021 at 01:01:20PM +0200, Lino Sanfilippo wrote:
> > > > Could you post the full kernel output? The picture you've posted is
> > > > truncated and only shows a WARN_ON in rpi_firmware_transaction and is
> > > > probably a symptom and not the issue (which is above and not shown).
> > > >
> > >
> > > Unfortunately I dont see anything in the kernel log. The console output is all I get,
> > > thats why I made the photo.
> >
> > To clarify, are you saying nothing above this line gets printed? Because
> > the part of the log you've posted in the picture is pretty much
> > unworkable:
> >
> > [   99.375389] [<bf0dc56c>] (bcm2835_spi_shutdown [spi_bcm2835]) from [<c0863ca0>] (platform_drv_shutdown+0x2c/0x30)
> >
> > How do you access the device's serial console? Use a program with a
> > scrollback buffer like GNU screen or something.
> >
> 
> Ah no, this is not over a serial console. This is what I see via hdmi. I do not have a working serial connection yet.
> Sorry I know this trace part is not very useful, I will try to get a full dump.

Lino, are you going to provide a kernel output so I could look at your new breakage?
If you could set up a pstore logger with a ramoops region, you could
dump the log after the fact. Or if HDMI is all you have, you could use
an HDMI capture card to record it. Or just record the screen you're
looking at, as long as you don't have very shaky hands, whatever...
