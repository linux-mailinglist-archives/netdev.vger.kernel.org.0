Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72737332B4C
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 16:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232075AbhCIP57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 10:57:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231904AbhCIP5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 10:57:55 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B57ABC06174A;
        Tue,  9 Mar 2021 07:57:55 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id 30so2225679ple.4;
        Tue, 09 Mar 2021 07:57:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hQMLQ9SEOoole7AWz8G4z2dp4fKanmmXjhQAyTfvjdw=;
        b=j35lO7LaYNs5Bb4TvE1oev9hV7hTuv7/yM+AxZlU0IlXrSnTACeeUQ1sO/GUxahFX3
         jjS6i12KSnPnvx7IAD7VhRSSKr3Jnv5c6gVFNSRlgfXUNc1mllh/YqN4dDHRUDBCCJbD
         aYrgZVOLWKQ2Ep65FqDNfALsSwcmH+ZgWtXoENvOqW49S3TI+aGpxD4kIpkuEYLhJIbe
         97iVTRMRxNkIF5okBPxicPZ0NHudbb1SGlgxEHq9fNQi+LsVaJWiGG6mUsWfJLEOuZ29
         VZMN3N8S7bnrV7Uo4aX3mGM39kPAnJ3nOH0NHDfhB61zMC23is8wMMCzb5XZfvLoihqm
         E5wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hQMLQ9SEOoole7AWz8G4z2dp4fKanmmXjhQAyTfvjdw=;
        b=kdxlfs/YRLcpC7U9RVO+eZh7PEyIFeuzFNmv1ay3gCgRtUf50oHNto6EnOGpAwqhyP
         lEnyyhjWPI+1MDRG5lj1pRD32RFG0Vofbq1j7/mEEo7Rr9WdIfBa+v7x7v8ky3ToXNRg
         S+pSsj1HoGjEuhOU0+1MdoFkoSBMgxoelO3/EwzGGRME1IH5g9gMBnjUhPxvSCrGVM/Y
         kMWa4PMmLKyJ0/zVPh3ntJIlRvKoL+ZujC9u2qFK0q15PQTEiNwSJuDTESOchuekZf2v
         HHKJGuKEzsSGvy4ZrreRvWBkyT97aU1JpexzIUzzpKA2kuWNLn7A95Jr3pln9c2h2v9g
         nspw==
X-Gm-Message-State: AOAM530KeZ+PiOP99qjdFxbWqlZbKTXB1P24/3FqbaPdsrn2a8iWuWVS
        MiSLw8WWTrxfAM0+k5Dg+8jnEaPddFrR9yu0roztnGnd/1UfPw==
X-Google-Smtp-Source: ABdhPJw4YGEaOK4SERDX2nutzu+m9aosVZNT3/A6P27opnHTSTEJVu0NkXAZ9QIYiYlb8XfuYETpYRsW4tFqG3TPsXI=
X-Received: by 2002:a17:902:c808:b029:e6:4204:f62f with SMTP id
 u8-20020a170902c808b02900e64204f62fmr4505011plx.0.1615305475277; Tue, 09 Mar
 2021 07:57:55 -0800 (PST)
MIME-Version: 1.0
References: <20210217065427.122943-1-dong.menglong@zte.com.cn>
 <20210223123052.1b27aad1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <CADxym3Zcxf05w2a0jis2ZyGewwmXpLzS4u54+GRwf_n2Ky7u0A@mail.gmail.com>
In-Reply-To: <CADxym3Zcxf05w2a0jis2ZyGewwmXpLzS4u54+GRwf_n2Ky7u0A@mail.gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 9 Mar 2021 17:57:39 +0200
Message-ID: <CAHp75VdnF=vnGXv3Hc5+2ueu6r2yViHJfZ6JcJuC6YDS_Y9LnA@mail.gmail.com>
Subject: Re: [PATCH v4 net-next] net: socket: use BIT() for MSG_*
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jens Axboe <axboe@kernel.dk>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 9, 2021 at 5:29 PM Menglong Dong <menglong8.dong@gmail.com> wrote:
> On Wed, Feb 24, 2021 at 4:30 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> ...
> > Please repost when net-next reopens after 5.12-rc1 is cut.
> >
> > Look out for the announcement on the mailing list or check:
> > http://vger.kernel.org/~davem/net-next.html
> >
> > RFC patches sent for review only are obviously welcome at any time.
>
> Is 'net-next' open? Can I resend this patch now? It seems that a long
> time has passed.

Should be. Usually the merge window takes from the last release
(v5.11) till the first rc of the new cycle (v5.12-rc1).
Now we are more than a week after v5.12-rc1.

-- 
With Best Regards,
Andy Shevchenko
