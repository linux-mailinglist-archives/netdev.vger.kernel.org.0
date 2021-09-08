Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 438DF4041E0
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 01:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244457AbhIHXoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 19:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbhIHXoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 19:44:02 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D321C061575
        for <netdev@vger.kernel.org>; Wed,  8 Sep 2021 16:42:53 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id a13so5545369iol.5
        for <netdev@vger.kernel.org>; Wed, 08 Sep 2021 16:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ojab.ru; s=ojab;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=up2XsrnvlIFzj8+jd7lbSzWI6A4vHwt4fG2fDS+P6QI=;
        b=HpWJLAYbhN3lnywIcBJmKBR2fyhxhEkc/yleJGUo6GUunFhNL8Oie2lyK3RWHm2fsB
         jbaApLygjDbQkzs3WZgYWLHj8JbHwvLhbY31V7B8uMm0hO6I4MVvkTZMiFr0y72iWCEQ
         bX1fSIDqrl2OBrWEiZ5qTknR1tf7YjWdvLPu2Y8AzE/5gwVdUUy8YwL+jI02oVf+HZJZ
         zl1zBBWecpp0lWZD/R8aiowpzqyEMk1mfdkmrEhtCTMLyu6SlosFobt5OYNrdZmhVrTQ
         xpccguLy6X+j8EP6nKO8d3xZ1pt0XxbdA2klEMhABQvtSw26+POjoiKUdGECeA2MRO8e
         yP8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=up2XsrnvlIFzj8+jd7lbSzWI6A4vHwt4fG2fDS+P6QI=;
        b=NBkPbOF4jfJka/H9NENXuqdAJRGT8qYaiH2j+I/iHdh1PnaCNJryNa7Il7sA1eXuEK
         fZA0pYFYs9KZnVPGGcKgTw0o2sfoszfGYw8p+KM6JNPkZOrfyFmfTyFTH+Indz9LGpMb
         RM6XaoWt/qT6WoNBGz9uUG4vz/XGLZs+o/E3qMg5HMUnMg/FKeMqBLbmFP3YE2OF3ipJ
         5Wc1K0lFnpjdPKvmS4D1phBqI6Y+IFoQRe/IZugFGOqhERuzfT8RiERUJcGRi74cK6EO
         FaoZQj/nE52X6IWVDS8BkGfJYGpFw8xG2MuUWYiN98KksyN9fPH2loGm+iZVVZ7ufw/A
         eFDg==
X-Gm-Message-State: AOAM531lrEDcoQdUMI7IDB9cKAww6vrf3/3xeUJqsg+oCTR7k41tUK8Q
        8JM+ZfADGGb9wxjkG+VLlFWWgCVvzvckjPrf0buB3z+hrT87AAQV
X-Google-Smtp-Source: ABdhPJyGEuoLSQC3YF3kxRyp4VjkbJsVtFOCMq06PZzRQb1nx4K/uFtuO/48yF5x8mjoPX1l1CEy+zh9Q/Dz0Y3oMmw=
X-Received: by 2002:a6b:f007:: with SMTP id w7mr106755ioc.112.1631144572943;
 Wed, 08 Sep 2021 16:42:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210722193459.7474-1-ojab@ojab.ru> <CAKzrAgRt0jRFyFNjF-uq=feG-9nhCx=tTztCgCEitj1cpMk_Xg@mail.gmail.com>
In-Reply-To: <CAKzrAgRt0jRFyFNjF-uq=feG-9nhCx=tTztCgCEitj1cpMk_Xg@mail.gmail.com>
From:   "ojab //" <ojab@ojab.ru>
Date:   Thu, 9 Sep 2021 02:42:42 +0300
Message-ID: <CAKzrAgQgsN6=Cu4SvjSSFoJOqAkU2t8cjt7sgEsJdNhvM8f7jg@mail.gmail.com>
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

Gentle ping.

//wbr ojab

On Wed, 25 Aug 2021 at 19:15, ojab // <ojab@ojab.ru> wrote:
>
> Can I haz it merged?
>
> //wbr ojab
>
> On Thu, 22 Jul 2021 at 22:36, ojab <ojab@ojab.ru> wrote:
> >
> > After reboot with kernel & firmware updates I found `failed to copy
> > target iram contents:` in dmesg and missing wlan interfaces for both
> > of my QCA9984 compex cards. Rolling back kernel/firmware didn't fixed
> > it, so while I have no idea what's actually happening, I don't see why
> > we should fail in this case, looks like some optional firmware ability
> > that could be skipped.
> >
> > Also with additional logging there is
> > ```
> > [    6.839858] ath10k_pci 0000:04:00.0: No hardware memory
> > [    6.841205] ath10k_pci 0000:04:00.0: failed to copy target iram contents: -12
> > [    6.873578] ath10k_pci 0000:07:00.0: No hardware memory
> > [    6.875052] ath10k_pci 0000:07:00.0: failed to copy target iram contents: -12
> > ```
> > so exact branch could be seen.
> >
> > Signed-off-by: Slava Kardakov <ojab@ojab.ru>
> > ---
> >  Of course I forgot to sing off, since I don't use it by default because I
> >  hate my real name and kernel requires it
> >
> >  drivers/net/wireless/ath/ath10k/core.c | 9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> > index 2f9be182fbfb..d9fd5294e142 100644
> > --- a/drivers/net/wireless/ath/ath10k/core.c
> > +++ b/drivers/net/wireless/ath/ath10k/core.c
> > @@ -2691,8 +2691,10 @@ static int ath10k_core_copy_target_iram(struct ath10k *ar)
> >         u32 len, remaining_len;
> >
> >         hw_mem = ath10k_coredump_get_mem_layout(ar);
> > -       if (!hw_mem)
> > +       if (!hw_mem) {
> > +               ath10k_warn(ar, "No hardware memory");
> >                 return -ENOMEM;
> > +       }
> >
> >         for (i = 0; i < hw_mem->region_table.size; i++) {
> >                 tmp = &hw_mem->region_table.regions[i];
> > @@ -2702,8 +2704,10 @@ static int ath10k_core_copy_target_iram(struct ath10k *ar)
> >                 }
> >         }
> >
> > -       if (!mem_region)
> > +       if (!mem_region) {
> > +               ath10k_warn(ar, "No memory region");
> >                 return -ENOMEM;
> > +       }
> >
> >         for (i = 0; i < ar->wmi.num_mem_chunks; i++) {
> >                 if (ar->wmi.mem_chunks[i].req_id ==
> > @@ -2917,7 +2921,6 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
> >                 if (status) {
> >                         ath10k_warn(ar, "failed to copy target iram contents: %d",
> >                                     status);
> > -                       goto err_hif_stop;
> >                 }
> >         }
> >
> > --
> > 2.32.0
