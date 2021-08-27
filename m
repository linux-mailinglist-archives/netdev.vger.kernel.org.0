Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA1D93FA177
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 00:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232143AbhH0WZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 18:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232023AbhH0WZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 18:25:44 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D0DC0613D9
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 15:24:55 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id m28so17333802lfj.6
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 15:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FpMQnWS/Idb7V4cplerWRjPC6X8Jz7LmylkwVXp0j6I=;
        b=ZpHX8TeYsHErvM6bpNGzQ2sOfpkfHyZaLiKvIG/qqAcbwr8BkRIh5FMx0vfgBq77ba
         mYSFFH44ORsKFpst9S9OpHMEi+mfYaG30hA/NVavodJ1+IfgtNrKg/PeVoguTwWjUhOS
         s5yboYNlnIa+RopfDKFwAW+xvljhaQXXKNctpnDqrrcAdYH6HTgb/U5YqG1WgvaOVjp2
         kDaVirJj6fz6RzlbaT0pCOmDAi0S8NhXkZAMBjcd2LXFK+q/A15A43xCjB/XrEYnwKSF
         1nCRPXi14H3ajDpLEpCa1iyiDZjOq4QtQn+2nwLdAvtBphjQ4NAhM27IzT5IjMVUKt8f
         ZxSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FpMQnWS/Idb7V4cplerWRjPC6X8Jz7LmylkwVXp0j6I=;
        b=hP54ROuBYgKsr0geM3B8FCsPS1RZ2adqP4qH6Okgz0Hfp1jV3+JFAYBqZUrwv5Fi47
         1DJg03WAzThmQ16qV7+cZuB2cxoU9bIUZQUTk9FJJtZ6LA7h3upOBngpTNvILkxK/YNt
         GGsp2lusIndCNiBiJrfD2v8izNcnFg9DzLRR8wmc4xb/AXmdcYv/1STTUgUm2RvfcM1/
         RUzEdm6WVfxzUbs9zvadnKnmp2DXfWJRBgLsJ0P/Xngzt8YsMR2uTuGjduBJZHOYtY3f
         mp4hBXV4b5hbkb5WiAlXJqKypzCGJfxHrWGL8Qk9l4RppJl0f96Q+WfLWHvzVnwejksS
         X9Iw==
X-Gm-Message-State: AOAM5336tYxDga3qxmgC9tJsZWAJy5PIwZIjzKvETsrGBWbT04KVdYeg
        bbB/u4jUjmkreFusuaMIfjSMwe2te0CE/miWcxlIVg==
X-Google-Smtp-Source: ABdhPJzY2a0iBh2SUwgB961qSHcMc6KG1k/nbmyRlu/YhfENDRRGN3HSBgvzlDdumO1AGXZZQB9r80OhSTuE25v5UGo=
X-Received: by 2002:ac2:5d4a:: with SMTP id w10mr8503419lfd.529.1630103093434;
 Fri, 27 Aug 2021 15:24:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210822193145.1312668-1-alvin@pqrs.dk> <20210822193145.1312668-5-alvin@pqrs.dk>
 <20210822224805.p4ifpynog2jvx3il@skbuf> <dd2947d5-977d-b150-848e-fb9a20c16668@bang-olufsen.dk>
In-Reply-To: <dd2947d5-977d-b150-848e-fb9a20c16668@bang-olufsen.dk>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sat, 28 Aug 2021 00:24:42 +0200
Message-ID: <CACRpkdakr9pY0MmM7ZmFnqgHMr5o13kXGVtiBqCLB0aV+6Z=UA@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 4/5] net: dsa: realtek-smi: add rtl8365mb
 subdriver for RTL8365MB-VC
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alvin@pqrs.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Michael Rasmussen <MIR@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 23, 2021 at 1:56 AM Alvin =C5=A0ipraga <ALSI@bang-olufsen.dk> w=
rote:
> On 8/23/21 12:48 AM, Vladimir Oltean wrote:
> > On Sun, Aug 22, 2021 at 09:31:42PM +0200, Alvin =C5=A0ipraga wrote:

> >> +static int rtl8365mb_enable_vlan(struct realtek_smi *smi, bool enable=
)
> >> +{
> >> +    dev_dbg(smi->dev, "%s VLAN\n", enable ? "enable" : "disable");
> >> +    return regmap_update_bits(
> >> +            smi->map, RTL8365MB_VLAN_CTRL_REG, RTL8365MB_VLAN_CTRL_EN=
_MASK,
> >> +            FIELD_PREP(RTL8365MB_VLAN_CTRL_EN_MASK, enable ? 1 : 0));
> >> +}
> >> +
> >> +static int rtl8365mb_enable_vlan4k(struct realtek_smi *smi, bool enab=
le)
> >> +{
> >> +    return rtl8365mb_enable_vlan(smi, enable);
> >> +}
> >
> > I'm not going to lie, the realtek_smi_ops VLAN methods seem highly
> > cryptic to me. Why do you do the same thing from .enable_vlan4k as from
> > .enable_vlan? What are these supposed to do in the first place?
> > Or to quote from rtl8366_vlan_add: "what's with this 4k business?"
>
> I think realtek-smi was written with rtl8366rb.c in mind, which appears
> to have different control registers for VLAN and VLAN4k modes, whatever
> that's supposed to mean. Since the RTL8365MB doesn't distinguish between
> the two, I just route one to the other. The approach is one of caution,
> since I don't want to break the other driver (I don't have hardware to
> test for regressions). Maybe Linus can chime in?

Sigh, I have zero documentation, I just mimic what the code dump from
Realtek does.

But my interpretation is that the RTL8366RB can operate with either
16 or 4096 VLAN (VID) member entries. (Called "mc", member configs)
The support for 4096 "4k" entries need to be enabled explicitly,
in succession after enabling the 16 entries, and this is what the
code in rtl8366.c does, and we always enable all 4096 "mc:s"
of course.

I guess some older switch only supported 16 members and this
is a hardware compatibility mode.

Yours,
Linus Walleij
