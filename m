Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0966D3E3537
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 14:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232182AbhHGMAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 08:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbhHGMAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Aug 2021 08:00:45 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 708D6C0613CF;
        Sat,  7 Aug 2021 05:00:27 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id w17so20187347ybl.11;
        Sat, 07 Aug 2021 05:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WyWRBH02aF7TMZK2H9iKEqjuVSj2aT5mi1GkBNRCyKg=;
        b=QOdR5x9JTDfThKVhuyhEYPReV0+hyqKytp6bhrDU9jtJxybQG/OIAaA3oWXzAmhUeI
         OpdNdHL2cTWOdcoGJdjl6SMiapPShk5dqCtzePXNHkSDDTyDYEUVEMRWoeWDVMRgEvWT
         F3WsjtH95W2GEqcxmYbu5Nki6iHjaP/wAYl8B41Jx1LBzEzxM7r/El9yGNDidzRbvvqa
         Kmis+CIiKYZTjEfn/MyNVZZE/sJlnMzcMNu5e2sZtEh+M3pQUSfAAN/s+5gpulRT28gX
         WpDFxD9aYBck7JqESW1IHpFohPSZLTlNkFRqH4KUtyrj9Pxrh4lb4vBKQjKvBi3tS5E+
         KYxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WyWRBH02aF7TMZK2H9iKEqjuVSj2aT5mi1GkBNRCyKg=;
        b=FENVn+x4TjHqCmYz0t/+7EfVYf1QGqh+zYpVEYmMGPTqnHOOisyXnxzs+6hlVBhG+N
         QQph2pPY6TkLAa3m8sU5mMDcy4AbNmu15kNxTPMh6DRzmYDaBbUc85RmuCV1GgVPqryW
         EgWH6cNXsXTLSpg6B9wVdvY2oBP9UeTHGYzrneA/3AB/2K+eaIJpiLLBRcK3tG7HJVWy
         PmCOFC3lrqXyvRa0Wpq4I6Uqs1KnDmVexInUNu2TpoP7L058z7s7FQ5UCxjlV4esc5Xh
         WYznK39bNlKg0rsWYXzKfSaqIiE+k6l8K5fA5SOb3CL1CbUEZEhfI1nTa5rZz4m7xdaV
         hF5g==
X-Gm-Message-State: AOAM532Vo5TEnmV+KE0rkq3yYrSNcJSnBO2C/YT8KQjFaTRcaDHjTde0
        nUc2OVB7nPEWNSFFrrQgxPso62OY9pkddZvu+yA=
X-Google-Smtp-Source: ABdhPJxo9qHswzoJFxioC74Rd4uuv/McBZ+hRPGpGsGEvfuOE6rZWY4LuFWwzY6Vg59fOtg8kqf5oNFF1j4ZtwtEzDU=
X-Received: by 2002:a25:1546:: with SMTP id 67mr19373700ybv.331.1628337626600;
 Sat, 07 Aug 2021 05:00:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210807091927.1974404-1-u.kleine-koenig@pengutronix.de>
In-Reply-To: <20210807091927.1974404-1-u.kleine-koenig@pengutronix.de>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Sat, 7 Aug 2021 12:59:50 +0100
Message-ID: <CADVatmO7Wtc8+4mzorrmcwKv2QXg579avynK==9D1Dqz9PHaJw@mail.gmail.com>
Subject: Re: [PATCH v2] parisc: Make struct parisc_driver::remove() return void
To:     =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        Sascha Hauer <kernel@pengutronix.de>,
        alsa-devel@alsa-project.org, Corey Minyard <minyard@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Takashi Iwai <tiwai@suse.com>, linux-scsi@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        linux-parisc <linux-parisc@vger.kernel.org>,
        linux-serial@vger.kernel.org, linux-input@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        openipmi-developer@lists.sourceforge.net,
        Jaroslav Kysela <perex@perex.cz>,
        Jiri Slaby <jirislaby@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 7, 2021 at 10:19 AM Uwe Kleine-K=C3=B6nig
<u.kleine-koenig@pengutronix.de> wrote:
>
> The caller of this function (parisc_driver_remove() in
> arch/parisc/kernel/drivers.c) ignores the return value, so better don't
> return any value at all to not wake wrong expectations in driver authors.
>
> The only function that could return a non-zero value before was
> ipmi_parisc_remove() which returns the return value of
> ipmi_si_remove_by_dev(). Make this function return void, too, as for all
> other callers the value is ignored, too.
>
> Also fold in a small checkpatch fix for:
>
> WARNING: Unnecessary space before function pointer arguments
> +       void (*remove) (struct parisc_device *dev);
>
> Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com> (for drivers/input)
> Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
> ---
> changes since v1 sent with Message-Id:
> 20210806093938.1950990-1-u.kleine-koenig@pengutronix.de:
>
>  - Fix a compiler error noticed by the kernel test robot
>  - Add Ack for Dmitry
>
>  arch/parisc/include/asm/parisc-device.h  | 4 ++--
>  drivers/char/ipmi/ipmi_si.h              | 2 +-
>  drivers/char/ipmi/ipmi_si_intf.c         | 6 +-----
>  drivers/char/ipmi/ipmi_si_parisc.c       | 4 ++--
>  drivers/char/ipmi/ipmi_si_platform.c     | 4 +++-
>  drivers/input/keyboard/hilkbd.c          | 4 +---
>  drivers/input/serio/gscps2.c             | 3 +--
>  drivers/net/ethernet/i825xx/lasi_82596.c | 3 +--
>  drivers/parport/parport_gsc.c            | 3 +--

Acked-by:  Sudip Mukherjee <sudipm.mukherjee@gmail.com>


--=20
Regards
Sudip
