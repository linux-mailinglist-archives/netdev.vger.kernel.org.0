Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69AF23D5500
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 10:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232779AbhGZH0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 03:26:01 -0400
Received: from mail-vs1-f48.google.com ([209.85.217.48]:37412 "EHLO
        mail-vs1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231778AbhGZH0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 03:26:00 -0400
Received: by mail-vs1-f48.google.com with SMTP id o8so4780526vss.4;
        Mon, 26 Jul 2021 01:06:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gp9OmnOPDAt4fp1/ogFdO2jZWIyyUuaqMagtlSZFSwY=;
        b=qfP9gAWTdhUL/pcHPJ8RgxiZOfwFG+KaIBRwXUQOBYMgY1Exa1y21xorXik3/hsYFI
         LCbveT+AxM8yejr1teDzL6cvO1nPmFqvw+zwUmz3exHB13WUgZYXkQed8rnLr3jCSiEn
         OuLbWS5ZaE1WdD+JN6CAW9F8GkKU5/QPnY/E3j95L0Nig+UhONFAE7C3Ws9NxqZS3rd/
         ytlM+1KOaJkQzxAJreIUl+bZYVLTFVLx5s11s7T07fsbOgh9QDUjCgU0OobVwWH1eiUR
         FbrJb8DvGrNFETlfgP1/T7b9jZ6/lncu677BiJIfEtAXulrP9TzDaTakzCtOfhrdqJB3
         mWBw==
X-Gm-Message-State: AOAM532ubxCrApLvTVzfqpTCIArDxDZGaO5/HpQdM2hlytWofSIcYpOF
        mPJASFA2LptGzjezfBb1gTFPsj1M7xbQC9g3mXk=
X-Google-Smtp-Source: ABdhPJwcpq4P0Ht4+tBFeDdI9JCqtFlxr0nD+WvWY/9MTNCBx1ktzOvRWPWJ+n5Ag1Z1ukKgM6WEoOw1u+zfe66J9Po=
X-Received: by 2002:a67:3c2:: with SMTP id 185mr11218083vsd.42.1627286789226;
 Mon, 26 Jul 2021 01:06:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210721194951.30983-3-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <202107251336.iD47PRoA-lkp@intel.com> <20210725094605.gzhrbunkot7ytvel@pengutronix.de>
In-Reply-To: <20210725094605.gzhrbunkot7ytvel@pengutronix.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 26 Jul 2021 10:06:18 +0200
Message-ID: <CAMuHMdUuFdc5JJfdsvFTfKPh1Z+o0iTabHLso4U6DUHRJowD6g@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] can: rcar_canfd: Add support for RZ/G2L family
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     kernel test robot <lkp@intel.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Rob Herring <robh+dt@kernel.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-can@vger.kernel.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        kbuild-all@lists.01.org, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

On Sun, Jul 25, 2021 at 11:46 AM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 25.07.2021 13:39:37, kernel test robot wrote:
> > [auto build test WARNING on renesas-devel/next]
> > [also build test WARNING on v5.14-rc2 next-20210723]
> > [cannot apply to mkl-can-next/testing robh/for-next]
> > [If your patch is applied to the wrong git tree, kindly drop us a note.
> > And when submitting patch, we suggest to use '--base' as documented in
> > https://git-scm.com/docs/git-format-patch]
> >
> > url:    https://github.com/0day-ci/linux/commits/Lad-Prabhakar/Renesas-RZ-G2L-CANFD-support/20210722-035332
> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/geert/renesas-devel.git next
> > config: arm64-randconfig-r031-20210723 (attached as .config)
> > compiler: clang version 13.0.0 (https://github.com/llvm/llvm-project 9625ca5b602616b2f5584e8a49ba93c52c141e40)
> > reproduce (this is a W=1 build):
> >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> >         chmod +x ~/bin/make.cross
> >         # install arm64 cross compiling tool for clang build
> >         # apt-get install binutils-aarch64-linux-gnu
> >         # https://github.com/0day-ci/linux/commit/082d605e73c5922419a736aa9ecd3a76c0241bf7
> >         git remote add linux-review https://github.com/0day-ci/linux
> >         git fetch --no-tags linux-review Lad-Prabhakar/Renesas-RZ-G2L-CANFD-support/20210722-035332
> >         git checkout 082d605e73c5922419a736aa9ecd3a76c0241bf7
> >         # save the attached .config to linux build tree
> >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=arm64
> >
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kernel test robot <lkp@intel.com>
> >
> > All warnings (new ones prefixed by >>):
> >
> > >> drivers/net/can/rcar/rcar_canfd.c:1699:12: warning: cast to smaller integer type 'enum rcanfd_chip_id' from 'const void *' [-Wvoid-pointer-to-enum-cast]
> >            chip_id = (enum rcanfd_chip_id)of_device_get_match_data(&pdev->dev);
> >                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >    1 warning generated.
>
> Seems we need the cast (uintptr_t), that I asked you to remove. Can you

Bummer, I had seen your comment while reading email on my phone,
but forgot to reply when I got back to my computer...

> test if
>
> | chip_id = (enum rcanfd_chip_id)(uintptr_t)of_device_get_match_data(&pdev->dev);
>
> works?

Just

    chip_id = (uintptr_t)of_device_get_match_data(&pdev->dev);

should be fine.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
