Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50EAD40FFE1
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 21:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343833AbhIQTbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 15:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343785AbhIQTbn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 15:31:43 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F685C061764
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 12:30:21 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id b15so11396476ils.10
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 12:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ojab.ru; s=ojab;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ojecROmdoKkDHQugVR33EyjeLmCBRcyr3oOr5dKqIQg=;
        b=Ep0ZieCcO4BsRRbYVJprHD1D0tCQbXTeINo5K+rm/qMUe5lOMFaqTIx5rLAbUK3MZ0
         iU2JgBpLlUxdCT9DhLA8cvosIVBG7Fyjz4cZ9HLY48P5FGCV2UgWZRTVuMIdBE0GX8ti
         7coXIdlvUVOHrZ+ClGUILKUxAj0c5kbBFTiGEJtQPf+NkVrZijx4GqSF3O67JGs4GWVg
         bmIk6weEl1jaxtmRgq/wlX8dMuxRcgHhMoKCZUd+RSJNEsaLtfSt0MX6Sqo4aWrVfTEF
         /h0nUj+npLuTlV4j0AVc/PyneJXT1JaXpPxQ8Xycxrcxmsfi5XmsLZ212M+v5pMtFIG6
         VhDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ojecROmdoKkDHQugVR33EyjeLmCBRcyr3oOr5dKqIQg=;
        b=v9E4/2ltxQdecfSOH0c4LXmvi+Jvs9Qo7DHp5FKPLGISBUp5lSOOVFGVPDB2p2ufLO
         1qQTcrvQYhbAbAVVzl/NpNC2DhWQ90u8jTnKrMgdKZuBswuXpetqy9Qmv6zKirK0p3w7
         yWWAdB7KlQbPBAv1lVbaRH+WGENRKEjal27Yu+S97qQAVuAO7Dmvjoh/oTnFMGG+bVCw
         zlBzhwcyvMUFe6UxPb0MKQPudYQOIJG4pCj9Lkkt1vh6I3rZeR87aagmO+EjEyig+1is
         x63I5J35eayZD7Ylmd24Pbm+NL61NtL+xgIWB9d96jK+jnjIIIE7DzwXD5uYNLOo2+bh
         Rcxg==
X-Gm-Message-State: AOAM532C2NNoieJU1LmLBJxal7Xmb1j94A7HNZycX1VXK8y6lKNcgTPL
        PuxB3May4mgfvi8cUGNl6iEcHjhYMsc6f/0d9hS9IA==
X-Google-Smtp-Source: ABdhPJzNhc+5vT8caUkTVnUoJ+e8ww4JroaL2iushz0B5BOIkm3zxnf+CYp3OJLGCdj3n2OSueskKdNmYpHTP0qsN6g=
X-Received: by 2002:a05:6e02:1bc3:: with SMTP id x3mr9490382ilv.113.1631907020457;
 Fri, 17 Sep 2021 12:30:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210722193459.7474-1-ojab@ojab.ru> <CAKzrAgRt0jRFyFNjF-uq=feG-9nhCx=tTztCgCEitj1cpMk_Xg@mail.gmail.com>
 <CAKzrAgQgsN6=Cu4SvjSSFoJOqAkU2t8cjt7sgEsJdNhvM8f7jg@mail.gmail.com>
In-Reply-To: <CAKzrAgQgsN6=Cu4SvjSSFoJOqAkU2t8cjt7sgEsJdNhvM8f7jg@mail.gmail.com>
From:   "ojab //" <ojab@ojab.ru>
Date:   Fri, 17 Sep 2021 22:30:09 +0300
Message-ID: <CAKzrAgSEiq-qOgetzryaE3JyBUe3URYjr=Fn0kz9sF7ZryQ5pA@mail.gmail.com>
Subject: Re: [PATCH V2] ath10k: don't fail if IRAM write fails
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     ath10k@lists.infradead.org,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

._.

//wbr ojab

On Thu, 9 Sept 2021 at 02:42, ojab // <ojab@ojab.ru> wrote:
>
> Gentle ping.
>
> //wbr ojab
>
> On Wed, 25 Aug 2021 at 19:15, ojab // <ojab@ojab.ru> wrote:
> >
> > Can I haz it merged?
> >
> > //wbr ojab
> >
> > On Thu, 22 Jul 2021 at 22:36, ojab <ojab@ojab.ru> wrote:
> > >
> > > After reboot with kernel & firmware updates I found `failed to copy
> > > target iram contents:` in dmesg and missing wlan interfaces for both
> > > of my QCA9984 compex cards. Rolling back kernel/firmware didn't fixed
> > > it, so while I have no idea what's actually happening, I don't see why
> > > we should fail in this case, looks like some optional firmware ability
> > > that could be skipped.
> > >
> > > Also with additional logging there is
> > > ```
> > > [    6.839858] ath10k_pci 0000:04:00.0: No hardware memory
> > > [    6.841205] ath10k_pci 0000:04:00.0: failed to copy target iram contents: -12
> > > [    6.873578] ath10k_pci 0000:07:00.0: No hardware memory
> > > [    6.875052] ath10k_pci 0000:07:00.0: failed to copy target iram contents: -12
> > > ```
> > > so exact branch could be seen.
> > >
> > > Signed-off-by: Slava Kardakov <ojab@ojab.ru>
> > > ---
> > >  Of course I forgot to sing off, since I don't use it by default because I
> > >  hate my real name and kernel requires it
> > >
> > >  drivers/net/wireless/ath/ath10k/core.c | 9 ++++++---
> > >  1 file changed, 6 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> > > index 2f9be182fbfb..d9fd5294e142 100644
> > > --- a/drivers/net/wireless/ath/ath10k/core.c
> > > +++ b/drivers/net/wireless/ath/ath10k/core.c
> > > @@ -2691,8 +2691,10 @@ static int ath10k_core_copy_target_iram(struct ath10k *ar)
> > >         u32 len, remaining_len;
> > >
> > >         hw_mem = ath10k_coredump_get_mem_layout(ar);
> > > -       if (!hw_mem)
> > > +       if (!hw_mem) {
> > > +               ath10k_warn(ar, "No hardware memory");
> > >                 return -ENOMEM;
> > > +       }
> > >
> > >         for (i = 0; i < hw_mem->region_table.size; i++) {
> > >                 tmp = &hw_mem->region_table.regions[i];
> > > @@ -2702,8 +2704,10 @@ static int ath10k_core_copy_target_iram(struct ath10k *ar)
> > >                 }
> > >         }
> > >
> > > -       if (!mem_region)
> > > +       if (!mem_region) {
> > > +               ath10k_warn(ar, "No memory region");
> > >                 return -ENOMEM;
> > > +       }
> > >
> > >         for (i = 0; i < ar->wmi.num_mem_chunks; i++) {
> > >                 if (ar->wmi.mem_chunks[i].req_id ==
> > > @@ -2917,7 +2921,6 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
> > >                 if (status) {
> > >                         ath10k_warn(ar, "failed to copy target iram contents: %d",
> > >                                     status);
> > > -                       goto err_hif_stop;
> > >                 }
> > >         }
> > >
> > > --
> > > 2.32.0
