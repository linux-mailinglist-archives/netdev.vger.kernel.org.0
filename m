Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 283154958F8
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 05:38:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232466AbiAUEiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 23:38:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232128AbiAUEiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 23:38:00 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F120FC061574
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 20:37:59 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id x37so3839818pfh.8
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 20:37:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m2S9t3/W74El99gibnTaIpHzNd+m7H9ZoIs11LobqnI=;
        b=edksL+hEFUWH/dJ4Kq1pH79zo9zT+kXaNO04QVaRCGTd+/svK2g2vKGvyD+4JhukvE
         nuryS7aE0RLHy92FRtzY+nFjMrQmUizvaULON4ZRP6dgj/cLBJbL1EezpJe4CRtYFNd/
         FUNLpIhXDo8d92iFJ9FBW4QE++PY5oQHQYGi96RvphsKL77UU44/FBa3Iz704KrK/sD9
         uy2iRetVLTaKt268u3gEH7EgnjIPfQKKCJDcdHFugKyCw5NIv1bAuXLyGfLY6f60ODg/
         GudtnhCYDdqTstBgnz7BWeGAYEGSGUCbW5xRA3FN/WzADMNBhtEjm+yTjYcBGQgsGSty
         /5Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m2S9t3/W74El99gibnTaIpHzNd+m7H9ZoIs11LobqnI=;
        b=d6ld896RxtBjb80K32dsVkGWHFpzZhtdLU3rQJckz3MGswx1B1aOdsvGDLt6WpWnEP
         1MJwoCqqrZ+EpHhshe2RRp7WI0oJmU3icaDlpyFe55Vr0pTyIVLIhNBRqD8nkurJgZ+i
         6jYPJVkl67KKC9Sn6+wkxm9lnNj9pcI5huabT5MToV6gqmtG0hQA34d5YyvQ5xDu+whn
         ufXPoDEnuC4YWfzY2DnLhad5Fg5Gf7t04CPwKDiHZhqq7Uvei6xsn5eZp5rBn3MzoM8/
         dM/szT296gqk/G0tI9ap74MgOm8hgHKhn2OBbs5aDaluO3ZzTDWVFsqexIAvcJSKYqIV
         UxdA==
X-Gm-Message-State: AOAM532rEcIaqPUDDdNnp7zZIykJRwCjr9aDnfOBA6qN23+NnJU/IXHz
        YP+K2+ZIZjJX409JEFoxrswjudjxeFwMWvCfndY=
X-Google-Smtp-Source: ABdhPJyv5iSA2eZdZHZ9jb5OScX/AVYBy8oIlqjEXYIHYjIMqtvClK8zhilrn58wTwWDXknAgIqeFuMd64ueQqfdTHk=
X-Received: by 2002:a63:8a44:: with SMTP id y65mr1689226pgd.456.1642739879182;
 Thu, 20 Jan 2022 20:37:59 -0800 (PST)
MIME-Version: 1.0
References: <87ee5fd80m.fsf@bang-olufsen.dk> <trinity-ea8d98eb-9572-426a-a318-48406881dc7e-1641822815591@3c-app-gmx-bs62>
 <87r19e5e8w.fsf@bang-olufsen.dk> <trinity-4b35f0dc-6bc6-400a-8d4e-deb26e626391-1641926734521@3c-app-gmx-bap14>
 <87v8ynbylk.fsf@bang-olufsen.dk> <trinity-d858854a-ff84-4b28-81f4-f0becc878017-1642089370117@3c-app-gmx-bap49>
 <CAJq09z7jC8EpJRGF2NLsSLZpaPJMyc_TzuPK_BJ3ct7dtLu+hw@mail.gmail.com>
 <Yea+uTH+dh9/NMHn@lunn.ch> <20220120151222.dirhmsfyoumykalk@skbuf>
 <CAJq09z6UE72zSVZfUi6rk_nBKGOBC0zjeyowHgsHDHh7WyH0jA@mail.gmail.com>
 <20220121020627.spli3diixw7uxurr@skbuf> <CAJq09z5HbnNEcqN7LZs=TK4WR1RkjoefF_6ib-hFu2RLT54Nug@mail.gmail.com>
 <f85dcb52-1f66-f75a-d6de-83d238b5b69d@gmail.com> <CAJq09z5Pvo4tJNw0yKK2LYSNEdQTd4sXPpKFJbCNA-jUwmNctw@mail.gmail.com>
 <2091fa77-5578-c1bb-8457-3be4029b014d@gmail.com>
In-Reply-To: <2091fa77-5578-c1bb-8457-3be4029b014d@gmail.com>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Fri, 21 Jan 2022 01:37:48 -0300
Message-ID: <CAJq09z6U9UziSaMtmJ9D-SQFGMpK37jErxS82cpAZ876OCu_pQ@mail.gmail.com>
Subject: Re: [PATCH net-next v4 11/11] net: dsa: realtek: rtl8365mb: multiple
 cpu ports, non cpu extint
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Frank Wunderlich <frank-w@public-files.de>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> Are we talking about an in tree driver? If so which is it?
> >
> > Yes, the one the patch touches: rtl8365mb.
>
> I meant the DSA master network device, but you answered that, it uses a
> mt7260a SoC, but there is no Ethernet driver upstream for it yet?
>
> git grep ralink,mt7620-gsw *
> Documentation/devicetree/bindings/net/mediatek,mt7620-gsw.txt:
> compatible = "ralink,mt7620-gsw";
>
> >
> > My device uses a mt7620a SoC and traffic passes through its mt7530
> > switch with vlan disabled before reaching the realtek switch. It still
> > loads a swconfig driver but I think it might work without one.
>
> Ah so you have a cascade of switches here, that could confuse your
> Ethernet MAC. Do you have a knob to adjust where to calculate the
> checksum from, say a L2 or L3 offset for instance?

Not that I could find in any docs. I just found registers to set it on
and off. However, Realtek supports two locations for the CPU tag. I'll
try the RTL8365MB_CPU_POS_BEFORE_CRC and hope the checksum will work
as expected. But I might leave that test for a moment after this
series is solved.

> --
> Florian
