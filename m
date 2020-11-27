Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E14912C60F7
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 09:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728839AbgK0Ifw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 27 Nov 2020 03:35:52 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:37585 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728017AbgK0Ifv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 03:35:51 -0500
Received: by mail-ot1-f66.google.com with SMTP id l36so4045127ota.4;
        Fri, 27 Nov 2020 00:35:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xh1hHzZVurhLLa9A5bjYyJ5OP5iFGRKbQx8AzvX3xN4=;
        b=TrbmmJKaYiHM47lTPaVZ/ifjGAlxFFdjyozKu13tvPrqyATJDuVBo+QeeExGVx+2qL
         U2pUW6r4wk1GpyzRDF91JSkT+Ty7mNFx0za9PXM4rnaa2JsyATNY0bm3bVgN1L/jAajd
         Pkp4OYnY/oAIE+Ozy0Q5Q+EhQC7Grt6kmo8AxfaxddRgd+gOitHnXQLup79bnDBPjazC
         4NYwNffpJLf3YrzJukKq5+vwgV1BM+ikrlG1bg09jz8nJC1yjMeTG+KW3rETQKDDhBC5
         BsJlnfcCwPRmzFe2HfswIVEwJdhyUDHcmaydnlfzPCnyNfS38lTeBRFJU58p7Igw29iR
         yMjw==
X-Gm-Message-State: AOAM5323sr9QAacPDNVaHzmhsCT4u7AAj+hSEX26s7UFEomEHSW3XmAy
        w1QsRDy9uo8Xz+LqGey41Du9n5/yWv19tQzw9cc=
X-Google-Smtp-Source: ABdhPJxi+ycxEsm5KsGHfXpYVjf0qoqXVdSm5mG1czf/VSu3Ar1g/6kPH+lbgaSp8/Ea4xlpW0yThv8dOVha3z28GvM=
X-Received: by 2002:a05:6830:210a:: with SMTP id i10mr4949297otc.145.1606466150802;
 Fri, 27 Nov 2020 00:35:50 -0800 (PST)
MIME-Version: 1.0
References: <20201126165950.2554997-1-u.kleine-koenig@pengutronix.de>
In-Reply-To: <20201126165950.2554997-1-u.kleine-koenig@pengutronix.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 27 Nov 2020 09:35:39 +0100
Message-ID: <CAMuHMdUbfT7ax4BhjMT_DBweab8TDm5e=xMv5f61t9QpQJt1mw@mail.gmail.com>
Subject: Re: [PATCH 1/2] ALSA: ppc: drop if block with always false condition
To:     =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Geoff Levand <geoff@infradead.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Jens Axboe <axboe@kernel.dk>, Jim Paris <jim@jtan.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        linux-block@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        scsi <linux-scsi@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Uwe,

On Thu, Nov 26, 2020 at 6:03 PM Uwe Kleine-König
<u.kleine-koenig@pengutronix.de> wrote:
> The remove callback is only called for devices that were probed
> successfully before. As the matching probe function cannot complete
> without error if dev->match_id != PS3_MATCH_ID_SOUND, we don't have to
> check this here.
>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Thanks for your patch!

Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>

Note that there are similar checks in snd_ps3_driver_probe(), which
can be removed, too:

        if (WARN_ON(!firmware_has_feature(FW_FEATURE_PS3_LV1)))
                return -ENODEV;
        if (WARN_ON(dev->match_id != PS3_MATCH_ID_SOUND))
                return -ENODEV;

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
