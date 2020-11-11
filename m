Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3E1C2AF029
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 12:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbgKKL5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 06:57:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726036AbgKKL5r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 06:57:47 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB0B0C0613D1;
        Wed, 11 Nov 2020 03:57:45 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id w4so1279718pgg.13;
        Wed, 11 Nov 2020 03:57:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dZ66NkK4JlOTGKRXsVDZQA1P1CV0kN8ceHgbcIIfYbY=;
        b=UyeuFb7T2ztfOrS9TwjIknlH4XH8EBY27dCjWQK32pkrotI4tuBTBw4ZkPJS/v1OkG
         eU38qi40GiFsR6izfN6qfTGC2SKc+mcZt57eFJ1Wx/rXNmPd+B6KsoIfrEj3S01TUjhR
         9KRzQbE/Vlg3P3msWCSnR2Wqp0V1uFTjSgz+GzOfONHfr9sDi1EMIew4Z2gs7yYunRmR
         8gCfSjVVKqj/SRhvDyvA0U3JGQj3Um/7/RhqXejGrgCFI7q1eQaACwRzM9stP83ZRFnA
         464eXrjI2FearEUoRfPvb0vcsMLuLu+x5QhjyylzyFbfHnORuKl008edfVfr8ggyzK2p
         aOFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dZ66NkK4JlOTGKRXsVDZQA1P1CV0kN8ceHgbcIIfYbY=;
        b=WMiz4thFcvbmgdbjNcGPELDA84vxuwuYc9rxyBLcjLeJNBirYAoypKx1IExmIKOoR2
         T9PMETW0ekwEnjLnALJHpodXyJmhOTSnaNkNWxtx3i/lTPM54+s3vMVDV8S/2ULA1AqR
         E+ed1rQKvnGzIKUnablI8y5yDCiLdFXFGVwPlXbH7LTMiLi50e16NQ7u6OBkpGpjNR4R
         zGWG/9MkBzQ4uUIkGSqREmxOg1VAdcphSA63IVu6QYUQLLGeBIIvj7nGRZEFGRhHukgv
         h/UnXZ0cr73KYKjP7OK54QfJxA1oINDrehLO65NPRmw6ldqKaVqafRASSZ8/LmUsos/0
         gs3A==
X-Gm-Message-State: AOAM53048SzO+Zl3xcsky3v8S+3vhJwzLpvfP0HCmIkt1dNYhTLGi66f
        dDVdrCCVFE++HOjGnwlLiDaR2+mX5L3McCKqlf0=
X-Google-Smtp-Source: ABdhPJxgb2Db8f1spw0DwGNBUQ7MN5ZZzD2WGy/bih6dqiJRtP2Wqtj9LhgWaDg/tBXLfS0rQNZPRxsxE6z3ln5DzPU=
X-Received: by 2002:a63:e74a:: with SMTP id j10mr22153791pgk.208.1605095865157;
 Wed, 11 Nov 2020 03:57:45 -0800 (PST)
MIME-Version: 1.0
References: <1605006094-31097-6-git-send-email-magnus.karlsson@gmail.com> <202011110934.GFwFDfqe-lkp@intel.com>
In-Reply-To: <202011110934.GFwFDfqe-lkp@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 11 Nov 2020 12:57:34 +0100
Message-ID: <CAJ8uoz2aDjLPtcTgZ_pO-=S9TgXm3c57rN8TTPXdqT7HOOKrhA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 5/5] i40e: use batched xsk Tx interfaces to
 increase performance
To:     kernel test robot <lkp@intel.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        kbuild-all@lists.01.org, clang-built-linux@googlegroups.com,
        bpf <bpf@vger.kernel.org>, jeffrey.t.kirsher@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 2:38 AM kernel test robot <lkp@intel.com> wrote:
>
> Hi Magnus,
>
> I love your patch! Perhaps something to improve:
>
> [auto build test WARNING on bpf-next/master]
>
> url:    https://github.com/0day-ci/linux/commits/Magnus-Karlsson/xsk-i40e-Tx-performance-improvements/20201110-190310
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
> config: powerpc64-randconfig-r025-20201110 (attached as .config)
> compiler: clang version 12.0.0 (https://github.com/llvm/llvm-project 4d81c8adb6ed9840257f6cb6b93f60856d422a15)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # install powerpc64 cross compiling tool for clang build
>         # apt-get install binutils-powerpc64-linux-gnu
>         # https://github.com/0day-ci/linux/commit/b016bbeac6692a93e61b28efa430d64645032b5e
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Magnus-Karlsson/xsk-i40e-Tx-performance-improvements/20201110-190310
>         git checkout b016bbeac6692a93e61b28efa430d64645032b5e
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=powerpc64
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
> >> drivers/net/ethernet/intel/i40e/i40e_xsk.c:417:13: warning: unknown pragma ignored [-Wunknown-pragmas]
>    #pragma GCC unroll 4
>                ^
>    1 warning generated.

And I was hoping that unknown pragmas would be ignored, but that will
obviously not be the case with -Wunknown-pragmas added. The unrolling
of this inner loop where the code spends most of its time gives me
nearly 1 Mpps extra in performance which is substantial, so I would
like to get this unrolled in some way, but without the warning. Need
some advice please. Here are some options that comes in mind:

#1: Suppress unknown pragma warnings in this file only by adding
CFLAGS_i40e_xsk.o += -Wno-unknown-pragmas (or whatever that option
might be) in the Makefile

#2: Force the compiler to loop-unroll the loop with for example a
switch statement with four cases that all fall through. This will make
the code less readable.

#3: Manually loop-unroll the loop. This will make the code even less
readable than #2.

I prefer #1 as I like to keep the code readable, but you might have
other better suggestions on how to tackle this.

Thanks: Magnus

> vim +417 drivers/net/ethernet/intel/i40e/i40e_xsk.c
>
>    408
>    409  static void i40e_xmit_pkt_batch(struct i40e_ring *xdp_ring, struct xdp_desc *desc,
>    410                                  unsigned int *total_bytes)
>    411  {
>    412          u16 ntu = xdp_ring->next_to_use;
>    413          struct i40e_tx_desc *tx_desc;
>    414          dma_addr_t dma;
>    415          u32 i;
>    416
>  > 417  #pragma GCC unroll 4
>    418          for (i = 0; i < PKTS_PER_BATCH; i++) {
>    419                  dma = xsk_buff_raw_get_dma(xdp_ring->xsk_pool, desc[i].addr);
>    420                  xsk_buff_raw_dma_sync_for_device(xdp_ring->xsk_pool, dma, desc[i].len);
>    421
>    422                  tx_desc = I40E_TX_DESC(xdp_ring, ntu++);
>    423                  tx_desc->buffer_addr = cpu_to_le64(dma);
>    424                  tx_desc->cmd_type_offset_bsz = build_ctob(I40E_TX_DESC_CMD_ICRC |
>    425                                                            I40E_TX_DESC_CMD_EOP,
>    426                                                            0, desc[i].len, 0);
>    427
>    428                  *total_bytes += desc[i].len;
>    429          }
>    430
>    431          xdp_ring->next_to_use = ntu;
>    432  }
>    433
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
