Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3C3D3226BB
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 09:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232072AbhBWIB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 03:01:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbhBWIBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 03:01:24 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE1AAC061574;
        Tue, 23 Feb 2021 00:00:43 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id q77so16185360iod.2;
        Tue, 23 Feb 2021 00:00:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oWGK+QA8n+yGZW2cAZQWBqhmuGInIOLJzVk3WD0N+uI=;
        b=WIbqzVKCTYEysN56w9VCUffa46GIWLUP7OZffCQmp3D364ArfCsbmSVZmsRl3OM5zE
         zo+h9X/N3DId8bo7ckUnemkeA/498/Ha9030FJqyzMsFtgl26zD5wBILglfVUimboKUo
         c/wEVqa+skGtYkxoQlUGcynoIGfLUlQwEx19mIWKcKvsL27Xy++PKUOp8cWsT3YPFN1y
         ZmUU3ya0/MYS5mFgMCFeiBgpukq+Cd3g2OEQ0tjQsF85+H3vRzHfjAoj7ZhLWIs9DvSN
         kS7xU58FbzB9TJN+YTF8N1GTBvZN3Krr8mSU3EYKTd4YPgRZb7E3Na3abXawzBUoYilh
         qviA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oWGK+QA8n+yGZW2cAZQWBqhmuGInIOLJzVk3WD0N+uI=;
        b=nunbAsJtoNpE2r+SzCFLkODlytj6mC5VuD86X87MXoZ3b64oIaNuWybqv3lQ7gjJcW
         acDeYuHCFj5JFHYZVJ/5Be7mNVkPslbKGixRn3J3TR3z7Wsq7i7R5BoUvpRdV0EIn9cg
         qVW1RUSZRNaeuCvA29EP5tpB67BvafR0a9euuUItlhu5nY7VL15m4sYMpUqP8A3OnK5g
         u/pcsIcKBHsn0AZAPu7boySMNSTriCmyOHLWGKYPJUBGmEODYWaGjgpWlWqt8K6DHMxh
         mOgXwm7mKFGEEouBzOsjDjUQxmHHAWnXxn4v/MMQKief4fE7CFV1fZHArxIdzg8LrvRP
         +C/A==
X-Gm-Message-State: AOAM531BcGGlqyN8UxqCZI71nzTD9WqNYxX5fRh6+FM6YkG/rfgqfy9s
        NyIAOtoadCAIpGDkaEkHL528ivRWsAJDRjpXLLc=
X-Google-Smtp-Source: ABdhPJzpnFJ0tx8KgcRDykb0IMj2bzFS2YxgdY17WcPDp8zBNDXIY2NkfzdwXmgW2RPoxPGfAk8TPE+nykcp+VvHEHA=
X-Received: by 2002:a02:5d03:: with SMTP id w3mr4332911jaa.67.1614067243444;
 Tue, 23 Feb 2021 00:00:43 -0800 (PST)
MIME-Version: 1.0
References: <20210220065654.25598-1-heiko.thiery@gmail.com> <20210222190051.40fdc3e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210222190051.40fdc3e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Heiko Thiery <heiko.thiery@gmail.com>
Date:   Tue, 23 Feb 2021 09:00:32 +0100
Message-ID: <CAEyMn7ZM7_pPor0S=dMGbmnp0hmZMrpquGqq4VNu-ixSPp+0UQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] net: fec: ptp: avoid register access when ipg clock
 is disabled
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Fugang Duan <fugang.duan@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

HI Jakub,

Am Di., 23. Feb. 2021 um 04:00 Uhr schrieb Jakub Kicinski <kuba@kernel.org>:
>
> On Sat, 20 Feb 2021 07:56:55 +0100 Heiko Thiery wrote:
> > When accessing the timecounter register on an i.MX8MQ the kernel hangs.
> > This is only the case when the interface is down. This can be reproduced
> > by reading with 'phc_ctrl eth0 get'.
> >
> > Like described in the change in 91c0d987a9788dcc5fe26baafd73bf9242b68900
> > the igp clock is disabled when the interface is down and leads to a
> > system hang.
> >
> > So we check if the ptp clock status before reading the timecounter
> > register.
> >
> > Signed-off-by: Heiko Thiery <heiko.thiery@gmail.com>
>
> Please widen the CC list, you should CC Richard on PTP patches.
>
> > diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
> > index 2e344aada4c6..c9882083da02 100644
> > --- a/drivers/net/ethernet/freescale/fec_ptp.c
> > +++ b/drivers/net/ethernet/freescale/fec_ptp.c
> > @@ -377,6 +377,9 @@ static int fec_ptp_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
> >       u64 ns;
> >       unsigned long flags;
> >
> > +     /* Check the ptp clock */
>
> Comment is rather redundant. Drop it or say _when_ ptp_clk_on may not
> be true.

I just used the same comment as the one in the fec_ptp_settime() function.

>
> > +     if (!adapter->ptp_clk_on)
> > +             return -EINVAL;
>
> Why is the PTP interface registered when it can't be accessed?
>
> Perhaps the driver should unregister the PTP clock when it's brought
> down?

Good question, but I do not know what happens e.g. with linuxptp when
the device that was opened before will be gone.

Maybe Richard can give a hint.

>
> >       spin_lock_irqsave(&adapter->tmreg_lock, flags);
> >       ns = timecounter_read(&adapter->tc);
> >       spin_unlock_irqrestore(&adapter->tmreg_lock, flags);

-- 
Heiko
