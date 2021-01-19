Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1462FC521
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 00:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729580AbhASXwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 18:52:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406445AbhASN7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 08:59:25 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 135CBC061575
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 05:58:42 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id n2so22493390iom.7
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 05:58:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xAxdGfckt4rYjWXGb6o1vtrZ6BjnVv6VsFXomnGCqwo=;
        b=OPJ0ThvGqzUjwo4kAKnbHM2oI9ZcMsTuRXgS6RajeobeupJb9szRpo0JnS1PH85Bpa
         Mv9542254HLljeJh1EvTtFfqZerZuqtii/jRbbbvQ4tGRPEedAU7+agmRdJvLK/17fXA
         KX5hemWKfeqScu6bdNKMFchtiyM7m0LcrCacGUOi76bzTesWKE9EQo5V2SoVSe9/5eZ4
         wLr+7FjmGPJ4bJFXj8Xt3+cWc48xqLpodXqeOybEh9XJtI0NZgt92LUL7gyRvRFzl6Qk
         FARNUka+VTDpNiG6SbIi0h9MbJ3O3duV56II6/4BmeLZY0cc1f7kgXi1BSkx+DmZstsC
         wGzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xAxdGfckt4rYjWXGb6o1vtrZ6BjnVv6VsFXomnGCqwo=;
        b=gIs2kJcxijXSaIYC+z79ENUD0fd4+wkxSCxmD2UQrFw4Ee0xoY5ADpsuK1Sd379div
         tLs7WuP+WiM3FlOwKLQyylBxjU+NKEq8GGTShaaOqLWkeKWBSKFTnFo++jfxJz3v2qu5
         BWokqzEx5Y3JzrADtRdl0Un7O8sKfbfT1VMMJDw9SPuDTdHJYRfXT89UTmpXHlzPpPLw
         j8c4hUKdtxteGbV7dO8awsDfNI7FCfBogLL4SGpptCp2ABcdGNOnFAUGA+6ZJhvFOcKb
         IzJHKx0chXFRzQ7482XKfu6uOPviZEcO13mey3z5wtwi08WTEWfEsLvY8sVa11BoMuSh
         h8iQ==
X-Gm-Message-State: AOAM5305Hh7+LVz/LmcERBw2XkQpjRr1BTBLWxZVb4BHItPdzqbxMCgS
        EVj7zjKDWaVe0MBkR3u88aS2fljjgwP+95qgxlYFHg==
X-Google-Smtp-Source: ABdhPJyBFEJgYRbHqE3+yoh6FhrZrhWmLIgoltDv9p/JsCI+EMyqHa+0eakFKQMQKp1se8wjeUZAyYwRzoXpk7ZOim0=
X-Received: by 2002:a05:6e02:13ea:: with SMTP id w10mr3602760ilj.68.1611064721362;
 Tue, 19 Jan 2021 05:58:41 -0800 (PST)
MIME-Version: 1.0
References: <bug-209423-201211-atteo0d1ZY@https.bugzilla.kernel.org/>
 <80adc922-f667-a1ab-35a6-02bf1acfd5a1@gmail.com> <CANn89i+ZC5y_n_kQTm4WCWZsYaph4E2vtC9k_caE6dkuQrXdPQ@mail.gmail.com>
 <733a6e54-f03c-0076-1bdc-9b0d4ec1038c@gmail.com> <CANn89iJ2zqH=_fvJQ8dhG4nBVnKNB7SjHnHDLv+0iR7UwgxTsw@mail.gmail.com>
 <b6ff841a-320c-5592-1c2b-650e18dfe3e0@gmail.com> <CANn89iJ2KxQKZmT2ShVZRTjdgyYkF_2ZWBraTZE4TJVtUKh--Q@mail.gmail.com>
 <9e4b2b1f-c2d9-dbd0-c7ce-49007ddd7af2@gmail.com> <CANn89iJwwDCkdmFFAkXav+HNJQEEKZsp8PKvEuHc4gNJ=4iCoQ@mail.gmail.com>
 <77541223-8eaf-512c-1930-558e8d23eb33@gmail.com> <CANn89i+dtetSScxtSRWX8BEgcW_uJ7vzvb+8sW57b7DJ3r=fXQ@mail.gmail.com>
 <20210119134023.082577ca@gollum> <9c235aa3-c827-e0dc-67ae-5c163962d624@gmail.com>
In-Reply-To: <9c235aa3-c827-e0dc-67ae-5c163962d624@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 19 Jan 2021 14:58:29 +0100
Message-ID: <CANn89iK1pFsa76PCB2Bu0ZtJNuAG9mwhVtQUKeQByCuURFac_w@mail.gmail.com>
Subject: Re: [Bug 209423] WARN_ON_ONCE() at rtl8169_tso_csum_v2()
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Juerg Haefliger <juerg.haefliger@canonical.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 19, 2021 at 2:47 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
>
> In tcp_add_backlog() we have the following that looks like it could
> be related to the problem. gso_type doesn't get set, not sure however
> whether this is a bug or intentional (because we expect gso_type
> to be set already or because it's supposed to be set somewhere else).
> Meybe Eric can comment on this.
>
>
>         if (!shinfo->gso_size)
>                 shinfo->gso_size = skb->len - hdrlen;
>
>         if (!shinfo->gso_segs)
>                 shinfo->gso_segs = 1;
>

Yes, at this point TCP is supposed to own the skb, which is partially true.

Check for skb_cloned() in places like skb_try_coalesce()

I think that calling skb_unclone() would be terribly expensive for all
these USB drivers having fake skb
(all clones from a giant one), and thus very big headroom that would
be copied from generic expand head.
