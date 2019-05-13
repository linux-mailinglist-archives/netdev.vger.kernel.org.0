Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 275581B0A3
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 09:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727710AbfEMHB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 03:01:28 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:39924 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbfEMHB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 03:01:28 -0400
Received: by mail-vs1-f67.google.com with SMTP id m1so184649vsr.6;
        Mon, 13 May 2019 00:01:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KZeUlM9HFwsoPba3BedCeGi13MK+EsvDzCuCOHnSeSU=;
        b=tglJ4xUOY7AZqgm0J8qMlTgm8HcXbatXI4c0qw4kxx2eIKQaxlfamPWrr06J46KUnC
         qbOK5/l66Y4TcNMDhVeOHjm/Wb0cQwFSLnKm7F4iARBf4Bppwx4RZm6cCtIlSa34TReW
         kVIuxnm3ez2Xa/nOtwRbm4IyBdFLCDn9NMl7iT5cDE0vRwKR17KTeaHQSop/azJh+kpa
         hJ2OwH3DEy01tDeqMRKI6DqnWwFObs1DqMpnaU/5SUkUjjf3P5WeNCaSA/6mlh9IHVT2
         uS9KpxvpuV5TcbVJSiiawVoOVDTztxxNg9gJZUPFJKPMSu+SwW3FSaAyWaibGXrgMXxs
         dgpA==
X-Gm-Message-State: APjAAAXw3ro/WseG2ulbzPbD6Ov146oenYie8FJUch304PR/260M9twJ
        Mw1YLLu6yPRLU/0021rH+LzC4Yy1cgcwT8jtA48=
X-Google-Smtp-Source: APXvYqxs4U9cC6qSMiyVDwFNxNbvddkvfAvZ+WOBelGbmcS7WwGSJect4/Alo1+2rHfzk8JgMisDv2BcZmORdVLPpig=
X-Received: by 2002:a67:770f:: with SMTP id s15mr4419527vsc.11.1557730886319;
 Mon, 13 May 2019 00:01:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190508070148.23130-1-alastair@au1.ibm.com> <20190508070148.23130-4-alastair@au1.ibm.com>
In-Reply-To: <20190508070148.23130-4-alastair@au1.ibm.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 13 May 2019 09:01:14 +0200
Message-ID: <CAMuHMdVefYTgHzGKBc0ebku1z8V3wsM0ydN+6-S2nFKaB8eH_Q@mail.gmail.com>
Subject: Re: [PATCH v2 3/7] lib/hexdump.c: Optionally suppress lines of
 repeated bytes
To:     "Alastair D'Silva" <alastair@au1.ibm.com>
Cc:     alastair@d-silva.org, Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Karsten Keil <isdn@linux-pingi.de>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Benson Leung <bleung@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Laight <David.Laight@aculab.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, ath10k@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        scsi <linux-scsi@vger.kernel.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alastair,

Thanks for your patch!

On Wed, May 8, 2019 at 9:04 AM Alastair D'Silva <alastair@au1.ibm.com> wrote:
> From: Alastair D'Silva <alastair@d-silva.org>
>
> Some buffers may only be partially filled with useful data, while the rest
> is padded (typically with 0x00 or 0xff).
>
> This patch introduces a flag to allow the supression of lines of repeated
> bytes,

Given print_hex_dump() operates on entities of groupsize (1, 2, 4, or 8)
bytes, wouldn't it make more sense to consider repeated groups instead
of repeated bytes?

> which are replaced with '** Skipped %u bytes of value 0x%x **'

Using a custom message instead of just "*", like "hexdump" uses, will
require preprocessing the output when recovering the original binary
data by feeding it to e.g. "xxd".
This may sound worse than it is, though, as I never got "xxd" to work
without preprocessing anyway ;-)

    $ cat $(type -p unhexdump)
    #!/bin/sh
    sed 's/^[0-9a-f]*//' $1 | xxd -r -p | dd conv=swab

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
