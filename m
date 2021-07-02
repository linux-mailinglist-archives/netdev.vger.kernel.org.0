Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 363BA3BA403
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 20:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbhGBSlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 14:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbhGBSlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 14:41:15 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2557CC061764
        for <netdev@vger.kernel.org>; Fri,  2 Jul 2021 11:38:42 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id 7-20020a9d0d070000b0290439abcef697so10991389oti.2
        for <netdev@vger.kernel.org>; Fri, 02 Jul 2021 11:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Iu+qqLrqRpxvz0+ejMvPXYfvSa6juYhqjnO3Y59upp8=;
        b=dPSxlOshgs9PM1BdVpHwPeBUb6bz0Asg2yzOnbUJBFpKWwUVA59ABKEaJUvQxfSsDW
         66ogSXf5lnkDP4SWK55ppl1wLOgj9Yoc46R7o2MShSoYEtfWTa2a0AukcljcQw2O3lm6
         cpCOwEafbeTcEMPWMi+wL0javoeIqYKbezzNc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Iu+qqLrqRpxvz0+ejMvPXYfvSa6juYhqjnO3Y59upp8=;
        b=L/yPuFPc4nBBzcTh/Sql0E8K001OcRDbleSgP5WZwWAoVTt2ZvGj0OlwwuIGyZjs6T
         wVr2JJ0afOqF1aIX/IfcauHtqqoot4NRIc3rHnd3iCTeFJTkMsetqj6TVwO6qzffJBCx
         Xdb/4pXk9aDP7J4KZL8I97HqfWL9AooRBy/IUMbzg9/HCXs7tHSQvd+K8WXU1Dh0Cp4l
         Q5qBThqJZScDMmAfsBVkUhX9e44ZBFs5NgcLqSev2DLUDCvCToMpZmmfDsACFyiUFySf
         E7tSF9PtjDY6kV/PtctrPrzDfSnCuo4ueHYVVLzF4RWdp2hQoRY6ErsSmBQH9saFCZ2u
         /eUg==
X-Gm-Message-State: AOAM5304hTilWYUyDQG0Cwe4qTSsWZ2K+78Oswa2vQHxgLjrm/YR73EF
        f0aA5IIBRUBGPCY58ggmi5HxGy6mo78PKQ==
X-Google-Smtp-Source: ABdhPJxSnDthSrLnq1B43tuhwwmB803zrJ/VlS5N0SX2IoPd7kiRiuRMlrGPIlExpROK5SD2JDZEGw==
X-Received: by 2002:a05:6830:22c3:: with SMTP id q3mr519551otc.361.1625251120852;
        Fri, 02 Jul 2021 11:38:40 -0700 (PDT)
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com. [209.85.210.42])
        by smtp.gmail.com with ESMTPSA id o26sm769419otk.77.2021.07.02.11.38.39
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jul 2021 11:38:39 -0700 (PDT)
Received: by mail-ot1-f42.google.com with SMTP id x22-20020a9d6d960000b0290474a76f8bd4so9348732otp.5
        for <netdev@vger.kernel.org>; Fri, 02 Jul 2021 11:38:39 -0700 (PDT)
X-Received: by 2002:a05:6830:23a2:: with SMTP id m2mr553125ots.203.1625251118941;
 Fri, 02 Jul 2021 11:38:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210618064625.14131-1-pkshih@realtek.com> <20210618064625.14131-5-pkshih@realtek.com>
 <20210702072308.GA4184@pengutronix.de> <CA+ASDXNjHJoXgRAM4E7TcLuz9zBmQkaBMuhK2DEVy3dnE-3XcA@mail.gmail.com>
 <20210702175740.5cdhmfp4ldiv6tn7@pengutronix.de>
In-Reply-To: <20210702175740.5cdhmfp4ldiv6tn7@pengutronix.de>
From:   Brian Norris <briannorris@chromium.org>
Date:   Fri, 2 Jul 2021 11:38:26 -0700
X-Gmail-Original-Message-ID: <CA+ASDXP0_Y1x_1OixJFWDCeZX3txV+xbwXcXfTbw1ZiGjSFiCQ@mail.gmail.com>
Message-ID: <CA+ASDXP0_Y1x_1OixJFWDCeZX3txV+xbwXcXfTbw1ZiGjSFiCQ@mail.gmail.com>
Subject: Re: [PATCH 04/24] rtw89: add debug files
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 2, 2021 at 10:57 AM Oleksij Rempel <o.rempel@pengutronix.de> wrote:
> On Fri, Jul 02, 2021 at 10:08:53AM -0700, Brian Norris wrote:
> > On Fri, Jul 2, 2021 at 12:23 AM Oleksij Rempel <o.rempel@pengutronix.de> wrote:
> > > For dynamic debugging we usually use ethtool msglvl.
> > > Please, convert all dev_err/warn/inf.... to netif_ counterparts
> >
> > Have you ever looked at a WiFi driver?
>
> Yes. You can parse the kernel log for my commits.

OK! So I see you've touched a lot of ath9k, >3 years ago. You might
notice that it is one such example -- it supports exactly the same
kind of debugfs file, with a set of ath_dbg() log types. Why doesn't
it use this netif debug logging?

> > I haven't seen a single one that uses netif_*() for logging.
> > On the other hand, almost every
> > single one has a similar module parameter or debugfs knob for enabling
> > different types of debug messages.
> >
> > As it stands, the NETIF_* categories don't really align at all with
> > the kinds of message categories most WiFi drivers support. Do you
> > propose adding a bunch of new options to the netif debug feature?
>
> Why not? It make no sense or it is just "it is tradition, we never do
> it!" ?

Well mainly, I don't really like people dreaming up arbitrary rules
and enforcing them only on new submissions. If such a change was
Recommended, it seems like a better first step would be to prove that
existing drivers (where there are numerous examples) can be converted
nicely, instead of pushing the work to new contributors arbitrarily.
Otherwise, the bar for new contributions gets exceedingly high -- this
one has already sat for more than 6 months with depressingly little
useful feedback.

I also know very little about this netif log level feature, but if it
really depends on ethtool (seems like it does?) -- I don't even bother
installing ethtool on most of my systems. It's much easier to poke at
debugfs, sysfs, etc., than to construct the relevant ethtool ioctl()s
or netlink messages. It also seems that these debug knobs can't be set
before the driver finishes coming up, so one would still need a module
parameter to mirror some of the same features. Additionally, a WiFi
driver doesn't even have a netdev to speak of until after a lot of the
interesting stuff comes up (much of the mac80211 framework focuses on
a |struct ieee80211_hw| and a |struct wiphy|), so I'm not sure your
suggestion really fits these sorts of drivers (and the things they
might like to support debug-logging for) at all.

Anyway, if Ping-Ke wants to paint this bikeshed for you, I won't stop him.

> Even dynamic printk provide even more granularity. So module parameter looks
> like stone age against all existing possibilities.

Dynamic printk seems a bit beside the point (it's pretty different
than either of the methods we're talking about), but I'll bite: many
distributors disable it. It's easier to get targeted debugging for a
few modules you care about, than the entire dynamic debug feature for
~every print in the kernel.

Brian
