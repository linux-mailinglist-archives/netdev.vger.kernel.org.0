Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 427503DCEA9
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 04:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbhHBCYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 22:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbhHBCX7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Aug 2021 22:23:59 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00A9BC06175F;
        Sun,  1 Aug 2021 19:23:50 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id nd39so28402405ejc.5;
        Sun, 01 Aug 2021 19:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kcU9zh0OTfEVkVwBtfOEs7GMplFE2emjbqTkOWvTJmY=;
        b=MH4e5RPIr6Gd5OKpKwYKjBLLrC1KcSfy3ETOyVLpDkTMrd1BirTdjNvMLKblpkeCOy
         RXNWkBcZqxsIZWBC5WYhTz1EnDPGVInOJVRBpoMn0V+9mQsoL56ll0eHjb0nReKOOB4i
         2JH1KRuhIVtUptWWd3PwdksBdx/muzswJCPECQPhhscy14K9Yb8qtJ4ZaKaf+ehBo0/8
         BJPCCR6QeKJTFgH/Y6SHFNHhn4h2fj9NUBgo7NunQIF3vVthZz9vXMvbu4HWKkvbWgVT
         5r3gUiSvlpxehbCbsd30ac2XgMQoEeUneSDLdPdUxJsn5e0AM3UU57JPcQ2+RdjhIWby
         pQzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kcU9zh0OTfEVkVwBtfOEs7GMplFE2emjbqTkOWvTJmY=;
        b=imzqmWYPugY4xsjgB7tp4Pb5W/oAOycHSbOq7QVhNHJIhTRlb7pvS2yLz7tqeAJ9vk
         qCdyrQS+uiIjSkAmE7N6Rbgtk0VxdX69qOx2O5BiqQqAy9dCvbCMTReAjVZeS0MdSPsE
         B34Rv1ChJgCZgdTsY0aBe1tz66jiV15Dx9j/w2QhPpZZ8zRhM5/IQD0rXJrnnt9K0dNF
         Ohgbz9PhGjkxdIk0ngvgHOdW5THTi0ij6DXH/jZpNu+5nvRYV0fYyjbV5iD7ZWuGWl+H
         NU9wImjXvkOzYEniS4IygWx5o2rnzrdEd9ZLMVF1V/1vlbi8ozUYfKc0AtujGA2P31zP
         TnQA==
X-Gm-Message-State: AOAM531SlyQHwyufAD7mQq286/qXPkKEdTW9KMqEgArH3Ysfu315714y
        PkIXG1/A2RiOEzbQdFlbFjZQTRbQCR0+Yq62oWE=
X-Google-Smtp-Source: ABdhPJyWpcBYilhB5rRxMRSa3CCrCFIFRFqvnlP2Suej+HlvvmvJHn6xR3qCJEWmVySTguagDCpasNmcewlLedTS7Ag=
X-Received: by 2002:a17:907:987c:: with SMTP id ko28mr13480958ejc.200.1627871028530;
 Sun, 01 Aug 2021 19:23:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210722193459.7474-1-ojab@ojab.ru> <CAKzrAgRvOLX6rcKKz=8ghD+QLyMu-1KEPm5HkkLEAzuE1MQpDA@mail.gmail.com>
In-Reply-To: <CAKzrAgRvOLX6rcKKz=8ghD+QLyMu-1KEPm5HkkLEAzuE1MQpDA@mail.gmail.com>
From:   Axel Rasmussen <axel.rasmussen1@gmail.com>
Date:   Sun, 1 Aug 2021 19:23:37 -0700
Message-ID: <CACC2YF1j45r0chib-HC463FVO_a1Um1f+7PvuRBYVLC7WbgGnQ@mail.gmail.com>
Subject: Re: [PATCH V2] ath10k: don't fail if IRAM write fails
To:     "ojab //" <ojab@ojab.ru>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath10k@lists.infradead.org,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 22, 2021 at 12:42 PM ojab // <ojab@ojab.ru> wrote:
>
> See also: https://lists.infradead.org/pipermail/ath10k/2021-May/012626.html
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

Thanks for working on this! And sorry for the slow response. I've been
unexpectedly very busy lately, but I plan to test out this patch next
week.

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
