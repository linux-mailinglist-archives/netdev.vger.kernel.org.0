Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F17742B0E2F
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbgKLTjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 14:39:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbgKLTjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 14:39:20 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C17C0613D1
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 11:39:19 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id c20so5488435pfr.8
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 11:39:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T6j1c8kOzPGeWxx6vJPWmOZFl41b2ThqYxcvjK4xAac=;
        b=Fx8cSFnHBy663HzzT+4EbK60Z1zIxfExPxbuyffECxS1nJ2peKId0Xl7Jka9RjFDLW
         pqGWOjBsda7vnfguZ0krPK64Pb64/SIc9qRjQ3ofoyaTiPWAsPJmGojlvnvf6g73LZfj
         IeX6l3sj+yuPTKJvkPspziXi8PWK0E4CBCGcWnMm8/BoyL64pXNw4gZOgmy52MvGGSVZ
         ABh8nOuLps7Jb4u0c9cNUTDCPeGd9AO9li02rW0Bg8w06DQpZeZW3GO80Djbp+YicSW+
         zK4a7zC/fSHXseTWFhH/MFOjuW/bzBMBvwflL+XIo0s01kJA88VwSZenDyQ79pvRNE2Y
         wyXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T6j1c8kOzPGeWxx6vJPWmOZFl41b2ThqYxcvjK4xAac=;
        b=X4Uda7fmyjmFFBxmgGQjusYYCgExjCNSIcJ3wMqRTrPZCUIh4NqO+Iu2u8zidAulCm
         fHnKUpfhCSDw/bAR+vGbZj6rcWLik4SHPfVz6dJjDYV1g7p4AM8NXwqWXwkatmX4La/b
         Fap6sJdOacKd4le6Zh6bVRvTzGPnjPazr5ny4OeO7q2qENd/XnmeqwSDUx2J1UyHiCvj
         jhExqu8vRoEqOz0mhs2idh9r2PpFcUr3xSmbHvATmtbtiQ1x3i2gaJCToWfuXyAgWqGk
         i0PEvlGZ3HqGaMtFbrCmUF70fnYVoKbBeqREo3FQSV4oqcLjapEIzoMhrZifBsvRO71v
         8aww==
X-Gm-Message-State: AOAM531VPZ9AZMOVcWjJg2Wp0oN0qMQ/EzVKL5qYrLP4iOV03fP0CzAu
        9+deH+tqbxT6SVMo0U8sR0zQT147ubewDBmCBMLnFA==
X-Google-Smtp-Source: ABdhPJy0m9wZj6JTK0++K2ehpXSSYpuGQtNCcLq4vr7EtJGn827RzTIHfEPzrDKycTjMVokHHBOCCUsx/iDmxKQ+6KI=
X-Received: by 2002:a63:b55e:: with SMTP id u30mr830468pgo.381.1605209958904;
 Thu, 12 Nov 2020 11:39:18 -0800 (PST)
MIME-Version: 1.0
References: <1605006094-31097-6-git-send-email-magnus.karlsson@gmail.com>
 <202011110934.GFwFDfqe-lkp@intel.com> <CAJ8uoz2aDjLPtcTgZ_pO-=S9TgXm3c57rN8TTPXdqT7HOOKrhA@mail.gmail.com>
 <CAKwvOd=Pws8npXdRuOVz+cgUYJ+nnztZCgMnZvP+Jr-dJ4z_Aw@mail.gmail.com> <CAJ8uoz2PxgZybUKDpe0Y4OJOHmK3gAxU7diTc1raPJoanze4sA@mail.gmail.com>
In-Reply-To: <CAJ8uoz2PxgZybUKDpe0Y4OJOHmK3gAxU7diTc1raPJoanze4sA@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 12 Nov 2020 11:39:07 -0800
Message-ID: <CAKwvOdnEfRFnO60mB9D7SAjCVijW5UBVYCGGXwhQ+EGw6c18BA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 5/5] i40e: use batched xsk Tx interfaces to
 increase performance
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     kernel test robot <lkp@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        kbuild-all@lists.01.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        bpf <bpf@vger.kernel.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 11:45 PM Magnus Karlsson
<magnus.karlsson@gmail.com> wrote:
>
> On Wed, Nov 11, 2020 at 8:16 PM Nick Desaulniers
> <ndesaulniers@google.com> wrote:
> >
> > On Wed, Nov 11, 2020 at 3:57 AM Magnus Karlsson
> > <magnus.karlsson@gmail.com> wrote:
> > >
> > > On Wed, Nov 11, 2020 at 2:38 AM kernel test robot <lkp@intel.com> wrote:
> > > >
> > > > Hi Magnus,
> > > >
> > > > I love your patch! Perhaps something to improve:
> > > >
> > > > [auto build test WARNING on bpf-next/master]
> > > >
> > > > url:    https://github.com/0day-ci/linux/commits/Magnus-Karlsson/xsk-i40e-Tx-performance-improvements/20201110-190310
> > > > base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
> > > > config: powerpc64-randconfig-r025-20201110 (attached as .config)
> > > > compiler: clang version 12.0.0 (https://github.com/llvm/llvm-project 4d81c8adb6ed9840257f6cb6b93f60856d422a15)
> >
> > ^ Note: clang
> >
> > > > reproduce (this is a W=1 build):
> > > >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> > > >         chmod +x ~/bin/make.cross
> > > >         # install powerpc64 cross compiling tool for clang build
> > > >         # apt-get install binutils-powerpc64-linux-gnu
> > > >         # https://github.com/0day-ci/linux/commit/b016bbeac6692a93e61b28efa430d64645032b5e
> > > >         git remote add linux-review https://github.com/0day-ci/linux
> > > >         git fetch --no-tags linux-review Magnus-Karlsson/xsk-i40e-Tx-performance-improvements/20201110-190310
> > > >         git checkout b016bbeac6692a93e61b28efa430d64645032b5e
> > > >         # save the attached .config to linux build tree
> > > >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=powerpc64
> > > >
> > > > If you fix the issue, kindly add following tag as appropriate
> > > > Reported-by: kernel test robot <lkp@intel.com>
> > > >
> > > > All warnings (new ones prefixed by >>):
> > > >
> > > > >> drivers/net/ethernet/intel/i40e/i40e_xsk.c:417:13: warning: unknown pragma ignored [-Wunknown-pragmas]
> > > >    #pragma GCC unroll 4
> > > >                ^
> > > >    1 warning generated.
> > >
> > > And I was hoping that unknown pragmas would be ignored, but that will
> > > obviously not be the case with -Wunknown-pragmas added. The unrolling
> > > of this inner loop where the code spends most of its time gives me
> > > nearly 1 Mpps extra in performance which is substantial, so I would
> > > like to get this unrolled in some way, but without the warning. Need
> > > some advice please. Here are some options that comes in mind:
> > >
> > > #1: Suppress unknown pragma warnings in this file only by adding
> > > CFLAGS_i40e_xsk.o += -Wno-unknown-pragmas (or whatever that option
> > > might be) in the Makefile
> > >
> > > #2: Force the compiler to loop-unroll the loop with for example a
> > > switch statement with four cases that all fall through. This will make
> > > the code less readable.
> > >
> > > #3: Manually loop-unroll the loop. This will make the code even less
> > > readable than #2.
> >
> > #4 support both compilers.  Note Clang's syntax is slightly different
> > here; it doesn't accept GCC specific pragmas, and uses a slightly
> > different form:
> > https://clang.llvm.org/docs/LanguageExtensions.html#loop-unrolling .
> > If you wrap that in a macro based on `#ifdef __clang__`, that should
> > do the trick.
>
> Yes, that did the trick. Tried it out with the compiler explorer at
> https://godbolt.org/ and it compiles nicely even for clang-powerpc64.
> Will spin a v3.
>
> Thank you: Magnus

Great job Magnus, I appreciate it!

>
> > >
> > > I prefer #1 as I like to keep the code readable, but you might have
> > > other better suggestions on how to tackle this.
> > >
> > > Thanks: Magnus
> > >
> > > > vim +417 drivers/net/ethernet/intel/i40e/i40e_xsk.c
> > > >
> > > >    408
> > > >    409  static void i40e_xmit_pkt_batch(struct i40e_ring *xdp_ring, struct xdp_desc *desc,
> > > >    410                                  unsigned int *total_bytes)
> > > >    411  {
> > > >    412          u16 ntu = xdp_ring->next_to_use;
> > > >    413          struct i40e_tx_desc *tx_desc;
> > > >    414          dma_addr_t dma;
> > > >    415          u32 i;
> > > >    416
> > > >  > 417  #pragma GCC unroll 4
> > > >    418          for (i = 0; i < PKTS_PER_BATCH; i++) {
> > > >    419                  dma = xsk_buff_raw_get_dma(xdp_ring->xsk_pool, desc[i].addr);
> > > >    420                  xsk_buff_raw_dma_sync_for_device(xdp_ring->xsk_pool, dma, desc[i].len);
> > > >    421
> > > >    422                  tx_desc = I40E_TX_DESC(xdp_ring, ntu++);
> > > >    423                  tx_desc->buffer_addr = cpu_to_le64(dma);
> > > >    424                  tx_desc->cmd_type_offset_bsz = build_ctob(I40E_TX_DESC_CMD_ICRC |
> > > >    425                                                            I40E_TX_DESC_CMD_EOP,
> > > >    426                                                            0, desc[i].len, 0);
> > > >    427
> > > >    428                  *total_bytes += desc[i].len;
> > > >    429          }
> > > >    430
> > > >    431          xdp_ring->next_to_use = ntu;
> > > >    432  }
> > > >    433
> > > >
> > > > ---
> > > > 0-DAY CI Kernel Test Service, Intel Corporation
> > > > https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
> > >
> > > --
> > > You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> > > To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> > > To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/CAJ8uoz2aDjLPtcTgZ_pO-%3DS9TgXm3c57rN8TTPXdqT7HOOKrhA%40mail.gmail.com.
> >
> >
> >
> > --
> > Thanks,
> > ~Nick Desaulniers



-- 
Thanks,
~Nick Desaulniers
