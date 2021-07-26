Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC1D3D6918
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 23:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232306AbhGZVQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 17:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbhGZVQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 17:16:25 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7370C061757;
        Mon, 26 Jul 2021 14:56:53 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id k65so12644050yba.13;
        Mon, 26 Jul 2021 14:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sBI78aRCVQAvE8Z8PpiRODU8s6N59NkofucxXTLbXbM=;
        b=KNah28FQRrK6Hj97zy80gHnou4q0AK5xk/HbFUtvWGt9Fg+kXVaaZlYNPxxYSasyTb
         oNj4zqxAjaWT9qXUzFliwCU5XFZwsIOq+X5VuPtsYPqdoEOTJkFKcdQkp7tFObZpw5Ys
         B/lrPJPL4rv5vxFOKPPzjfpuT2L+jBiQYlvMEdTAfzy4DhWSqemVy1cWPknSHharDl46
         a9N9E/AOedHXmW1t9KdpdyG53aBYVdSk+5nCt48OL39MoDwn/sh4cyxq0WyKElfeG3x8
         QtZVDAoka8WXkcExWqorQ4sY2yMbjuBYciWX4BvffY0DvGfMtms7MlSsybEQCaZ0OE1P
         8fag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sBI78aRCVQAvE8Z8PpiRODU8s6N59NkofucxXTLbXbM=;
        b=eWgcNcNDScUOh0FeroaUE7I6hIwtenI+qHgJoLG4W/nGYqHzap3FTwDavfmtiD3NaL
         uyqj1k5uxPTMvmAfZsuHriB21YKHy8fYT+DyOVDMkmYg7lfoTYnlE79OyrB/oXxfQb4+
         EEmCiw91DI4q2wyKnr21SdbLjXmTprXZdkfyVovOyft95JaayrJftcYVOn4vWZRcwcwB
         MNdY2S4v/VQp2qAhizQ0vRkEN+VVLjrWyx050XnMDVWwPDN4mds9R7ZdE/KulOx/QVIp
         vtMmYLOYqOgRMgtMV/j7k0VFrJiA8yrSM8e+6Y7xVGrAgAHNosbrjLdXzUXUhXkBuQDz
         c6DA==
X-Gm-Message-State: AOAM533NutGgJIinLXtWBSPJvWr3hSquCHqdE9Etou+x2pVtC+wMUAlO
        3IjY0UPquQmu/W221Kd+JDzuvbZVHo2NUOPlw7A=
X-Google-Smtp-Source: ABdhPJzJ0Gn54eQ+Gmudy7C7TBsYRWR+aTc6h+4qjmgIBDhRDwBJAf2BE/25TgFpDB8tWqrIyGDUlhQ/o/aHjnFK2Pk=
X-Received: by 2002:a25:2449:: with SMTP id k70mr10224909ybk.156.1627336612855;
 Mon, 26 Jul 2021 14:56:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210721194951.30983-3-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <202107251336.iD47PRoA-lkp@intel.com> <20210725094605.gzhrbunkot7ytvel@pengutronix.de>
 <CAMuHMdUuFdc5JJfdsvFTfKPh1Z+o0iTabHLso4U6DUHRJowD6g@mail.gmail.com>
In-Reply-To: <CAMuHMdUuFdc5JJfdsvFTfKPh1Z+o0iTabHLso4U6DUHRJowD6g@mail.gmail.com>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Mon, 26 Jul 2021 22:56:26 +0100
Message-ID: <CA+V-a8s-DDsTqx6R4bqtA3ruWF=8E_==ao45+toYREDvWsrYZg@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] can: rcar_canfd: Add support for RZ/G2L family
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
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

Hi Geert, Marc,

On Mon, Jul 26, 2021 at 9:07 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> Hi Marc,
>
> On Sun, Jul 25, 2021 at 11:46 AM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> > On 25.07.2021 13:39:37, kernel test robot wrote:
> > > [auto build test WARNING on renesas-devel/next]
> > > [also build test WARNING on v5.14-rc2 next-20210723]
> > > [cannot apply to mkl-can-next/testing robh/for-next]
> > > [If your patch is applied to the wrong git tree, kindly drop us a note.
> > > And when submitting patch, we suggest to use '--base' as documented in
> > > https://git-scm.com/docs/git-format-patch]
> > >
> > > url:    https://github.com/0day-ci/linux/commits/Lad-Prabhakar/Renesas-RZ-G2L-CANFD-support/20210722-035332
> > > base:   https://git.kernel.org/pub/scm/linux/kernel/git/geert/renesas-devel.git next
> > > config: arm64-randconfig-r031-20210723 (attached as .config)
> > > compiler: clang version 13.0.0 (https://github.com/llvm/llvm-project 9625ca5b602616b2f5584e8a49ba93c52c141e40)
> > > reproduce (this is a W=1 build):
> > >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> > >         chmod +x ~/bin/make.cross
> > >         # install arm64 cross compiling tool for clang build
> > >         # apt-get install binutils-aarch64-linux-gnu
> > >         # https://github.com/0day-ci/linux/commit/082d605e73c5922419a736aa9ecd3a76c0241bf7
> > >         git remote add linux-review https://github.com/0day-ci/linux
> > >         git fetch --no-tags linux-review Lad-Prabhakar/Renesas-RZ-G2L-CANFD-support/20210722-035332
> > >         git checkout 082d605e73c5922419a736aa9ecd3a76c0241bf7
> > >         # save the attached .config to linux build tree
> > >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=arm64
> > >
> > > If you fix the issue, kindly add following tag as appropriate
> > > Reported-by: kernel test robot <lkp@intel.com>
> > >
> > > All warnings (new ones prefixed by >>):
> > >
> > > >> drivers/net/can/rcar/rcar_canfd.c:1699:12: warning: cast to smaller integer type 'enum rcanfd_chip_id' from 'const void *' [-Wvoid-pointer-to-enum-cast]
> > >            chip_id = (enum rcanfd_chip_id)of_device_get_match_data(&pdev->dev);
> > >                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > >    1 warning generated.
> >
> > Seems we need the cast (uintptr_t), that I asked you to remove. Can you
>
> Bummer, I had seen your comment while reading email on my phone,
> but forgot to reply when I got back to my computer...
>
> > test if
> >
> > | chip_id = (enum rcanfd_chip_id)(uintptr_t)of_device_get_match_data(&pdev->dev);
> >
> > works?
>
> Just
>
>     chip_id = (uintptr_t)of_device_get_match_data(&pdev->dev);
>
> should be fine.
>
Above works, cast is not required.

Cheers,
Prabhakar

> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
