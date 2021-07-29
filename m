Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90DB43DA3AE
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 15:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237320AbhG2NKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 09:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237236AbhG2NKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 09:10:00 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1370C061765
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 06:09:56 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id c7-20020a9d27870000b02904d360fbc71bso5759616otb.10
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 06:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8BcnspB4dsY5wztYlvLrEuB5FxazZYcfV0xPP7+wQPA=;
        b=Ctp8vwLXINNKeStSiKJG2IftGJ3guxr8skQLk4XEdKwiQ+kpN47PQ3SsRO62taaMee
         Gx0Vtra46GNAFOj1s7AwyjVP17rKunfEYDloFVtpE0lQPPRFR8zQRYEu5xJw5q/zKCA+
         TBaiOTy7s6e+2YkzGiyFBgPMnFOHlAf7pW59IG1HYllE64DeYDtQeaSA7+TTDsUvaiYx
         +ml+7PyAGmC/cfB9Vu5tUDOLwVFvFs1tSiZtXv6oX8b/pnoCO+uARcg2L2c44oxNTfd0
         SGoUatIYqJJ3h0hYlMWP3VUAp288gzNrnhU8kNMM6ixiUT/fQ7iX6owDZhD+tnVqClGU
         2xeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8BcnspB4dsY5wztYlvLrEuB5FxazZYcfV0xPP7+wQPA=;
        b=BOoWOELm/YmmVdGZYEpBZGSn4Xg4Roa3Kjh+3CqY74bgJnKGJhYSnYNGUJWxpzTHLv
         SFRQZkDeZBEnVrkSpdfBMYJxnM6Q1uOziiyGAgU2i1iDoOhyDutNWBWaqHbVJcTZV49s
         m4K9l2sGj+xZHfK9S/mcRs2P4L8CK4kDqWj0jzrJgfSdcB96p1SnC9G731ke7BV6JYnf
         UQ/oQaaUolyYTD+DBjoiB8OgbKeu6BCInzkQqQNKGaBt2C6yoCceW4SM2I9J8DaUrwUF
         /+6rWx4z2DC09VDqg+jAuztmZoz6JLlP1d1ORXsVSj64Z/N6oY+XhZX+vndbSpzp4rCi
         Svmg==
X-Gm-Message-State: AOAM532ewFdx7ySAaTCqAEOt/a1pT64hsRLjxR479pXGJ62djXW/Lj61
        MOemld4vkvg+TMRLscErzJi8zWdgQnx6Ob2T2jyW63wKP8nV
X-Google-Smtp-Source: ABdhPJyfFrkvU/6VeLsujO5Vbzsgeumyeuk3kv2TIGbFYfcwvtWPK+2/wTigbDxAuGvHNbMUWsjFaw/DUuYsEbIvKIw=
X-Received: by 2002:a9d:1ea5:: with SMTP id n34mr3346317otn.340.1627564196358;
 Thu, 29 Jul 2021 06:09:56 -0700 (PDT)
MIME-Version: 1.0
References: <CAFSKS=Pv4qjfikHcvyycneAkQWTXQkKS_0oEVQ3JyE5UL6H=MQ@mail.gmail.com>
 <YQHGe6Rv9T4+E3AG@lunn.ch>
In-Reply-To: <YQHGe6Rv9T4+E3AG@lunn.ch>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Thu, 29 Jul 2021 08:09:45 -0500
Message-ID: <CAFSKS=OX2ngU=sTYBi7x4ehOxOUb0ya5brr2U0Dy1ZqbdU-YTg@mail.gmail.com>
Subject: Re: net: dsa: mv88e6xxx: no multicasts rx'd after enabling hw time stamping
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ugh, I replied to this last night from gmail on my phone and it seems
to have sent it in HTML as well as plain text. Let's try this again...

On Wed, Jul 28, 2021 at 4:05 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Wed, Jul 28, 2021 at 03:44:24PM -0500, George McCollister wrote:
> > If I do the following on one of my mv88e6390 switch ports I stop
> > receiving multicast frames.
> > hwstamp_ctl -i lan0 -t 1 -r 12
> >
> > Has anyone seen anything like this or have any ideas what might be
> > going on? Does anyone have PTP working on the mv88e6390?
> >
> > I tried this but it doesn't help:
> > ip maddr add 01:xx:xx:xx:xx:xx dev lan0
> >
> > I've tried sending 01:1B:19:00:00:00, 01:80:C2:00:00:0E as well as
> > other random ll multicast addresses. Nothing gets through once
> > hardware timestamping is switched on. The switch counters indicate
> > they're making it into the outward facing switch port but are not
> > being sent out the CPU facing switch port. I ran into this while
> > trying to get ptp4l to work.
>
> Hi George
>
> All my testing was i think on 6352.
>
> I assume you get multicast before using hwstamp_ctl?

Yup.

>
> Maybe use:
>
> https://github.com/lunn/mv88e6xxx_dump
>
> and dump the ATU before and afterwards.

Ooh. Thanks, this will probably help!

>
> The 6390 family introduced a new way to configured which reserved
> management addresses get forwarded to the CPU. Maybe take a look at
> mv88e6390_g1_mgmt_rsvd2cpu() and see if you can spot anything odd
> going on.

Yes I looked at this and spent a lot of time reading the datasheet but
maybe I've still missed something.

>
> You might also want to check if mv88e6352_port_set_mcast_flood() is
> being called.

I'm pretty sure I did at one point but I'll double check, thanks.

>
>       Andrew
