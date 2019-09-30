Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41D65C285D
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 23:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732127AbfI3VNG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 30 Sep 2019 17:13:06 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:36585 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731802AbfI3VNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 17:13:06 -0400
Received: by mail-ot1-f66.google.com with SMTP id 67so9662793oto.3;
        Mon, 30 Sep 2019 14:13:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AoDopCjUGYoxKnmro43LDdxYLNX5XQXycxp12mlQvm8=;
        b=RAgU5KS+qnfNa6MiDEgMKiI3z+FJ7OQKerzTkkUQxOw7rU1DdMb28kCDqli+TyIrPw
         jP39sQTTDS8SKHh1dKMxTdvM1l0cdprIjz3fcLruXw01i1qTR5wznlMmH0cV4hwV0BoV
         ftn2+sSzFBrxhbltxwWT93SrcNLKThzQ3E801JxpOy8JNvfop5Mh/dj4WYOcyLK73f/A
         KMdnfrwf8z4Z112cc3C1PdZwrJeRpxMNxNFppiaC1DQqSoM8pPOJDDPUNf4hPmmgeKxQ
         hSFkRXnPCf/Ba2qZaaaS1oGkggRtNTaOMpjkKCg87KnNMhuGyHZLEZ3gO5T9F8Ecd2zl
         va5g==
X-Gm-Message-State: APjAAAUZiUr2S2ThXB7D51Fl3dJ1weNvZ+89pBmtXQO8IozOif2FU3Dd
        mSyvaHQmHBZjg8fqxxJJwqTAhAcxKlqp4PcjPecrXQ==
X-Google-Smtp-Source: APXvYqzPkYu2PrL3iMwwL+6tej+XjS4dGWNxGQXzn+bCU2kTSqKXYzVqy+EN/9Az+2EqdSLOyjgt2nDIKfgxYblqp4g=
X-Received: by 2002:a9d:17e6:: with SMTP id j93mr15612333otj.297.1569872057032;
 Mon, 30 Sep 2019 12:34:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190920133115.12802-1-uwe@kleine-koenig.org>
In-Reply-To: <20190920133115.12802-1-uwe@kleine-koenig.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 30 Sep 2019 21:34:05 +0200
Message-ID: <CAMuHMdUs8oqDgYpQdu_bJ1Hvz+Lq_qPXLvuKj7=H=6818OM9=A@mail.gmail.com>
Subject: Re: [PATCH] dimlib: make DIMLIB a hidden symbol
To:     =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <uwe@kleine-koenig.org>,
        Tal Gilboa <talgi@mellanox.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Uwe, Tal,

On Sat, Sep 21, 2019 at 7:50 PM Uwe Kleine-König <uwe@kleine-koenig.org> wrote:
> According to Tal Gilboa the only benefit from DIM comes from a driver
> that uses it. So it doesn't make sense to make this symbol user visible,
> instead all drivers that use it should select it (as is already the case
> AFAICT).
>
> Signed-off-by: Uwe Kleine-König <uwe@kleine-koenig.org>

Thanks for your patch!

> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -555,8 +555,7 @@ config SIGNATURE
>           Implementation is done using GnuPG MPI library
>
>  config DIMLIB
> -       bool "DIM library"
> -       default y
> +       bool
>         help
>           Dynamic Interrupt Moderation library.
>           Implements an algorithm for dynamically change CQ moderation values

Thanks for fixing the first issue!

The second issue is still present: NET_VENDOR_BROADCOM (which defaults
to y, as all other NET_VENDOR_* symbols) should only be a gatekeeper for
the various Broadcom network driver config options, and should not select
DIMLIB.

Cfr. my earlier complaint in
https://lore.kernel.org/linux-rdma/alpine.DEB.2.21.1907021810220.13058@ramsan.of.borg/

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
