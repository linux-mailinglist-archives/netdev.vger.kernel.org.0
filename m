Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E07360B260
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 18:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234969AbiJXQqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 12:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234771AbiJXQos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 12:44:48 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD23D132241;
        Mon, 24 Oct 2022 08:30:55 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id 8so6277443qka.1;
        Mon, 24 Oct 2022 08:30:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cHT5Rt2YRD3TxMdqZcnrFfX+ch7zR8neoaazNIgvH4s=;
        b=o8UYQnYqagOJk7xHL7ioRItrsBk4Qv7WzL2+wKOHKL98J666DOd7Ceoqs44x6TqF+h
         4RBe8hHOwdDaRf4CZij0jLuG0ExctYqHhJBq+2AFPJucTPiOI60tSGlI6Smk3eIgJwMa
         p8lduArEWE4JPCaWcUoxSBY5DF6Jl7AQ8iUHI+d2TPTzASa50EXQyzk0kUxTDe/NYF0O
         ejhHvs1TZHgphuoE8EI9fqka1snqi76MZ3OcpcqFqCloivxTlFYI1UwCrUdVFM6p88x2
         gVAoTsi4sDb+Advoty8x2kvCV/WRPXYNPsTNyMtY2U+7K2086PF6gaC+fZoIswYvG9Hw
         2AKA==
X-Gm-Message-State: ACrzQf2pNrSLoSSBDKSahyLaSPk/ux+EZ3etTuPI1FGV+oZIYq2RrFJ9
        bfjNVsEZbxT86JEck6isCUTsw+iOp/RWhw==
X-Google-Smtp-Source: AMsMyM4Vkd7cp4pbO1rM/WpR2yqfdH7jEaPA2xKnICY7kI7XOc/KqJfpkN+1sY6S7VC0Kr3Hgqfa9g==
X-Received: by 2002:a05:620a:244e:b0:6c6:f3b8:9c3 with SMTP id h14-20020a05620a244e00b006c6f3b809c3mr23359764qkn.218.1666625281759;
        Mon, 24 Oct 2022 08:28:01 -0700 (PDT)
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com. [209.85.128.170])
        by smtp.gmail.com with ESMTPSA id d19-20020a05620a241300b006cfc01b4461sm103204qkn.118.2022.10.24.08.28.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 08:28:01 -0700 (PDT)
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-35befab86a4so88605387b3.8;
        Mon, 24 Oct 2022 08:28:00 -0700 (PDT)
X-Received: by 2002:a81:99d8:0:b0:368:909b:a111 with SMTP id
 q207-20020a8199d8000000b00368909ba111mr19866197ywg.502.1666625280651; Mon, 24
 Oct 2022 08:28:00 -0700 (PDT)
MIME-Version: 1.0
References: <20221019083518.933070-3-yoshihiro.shimoda.uh@renesas.com> <202210191806.RZK10y3x-lkp@intel.com>
In-Reply-To: <202210191806.RZK10y3x-lkp@intel.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 24 Oct 2022 17:27:49 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXBT2cEqfy00u+0VB=cRUAtrgH9LD26gXgavdvmQyN+pQ@mail.gmail.com>
Message-ID: <CAMuHMdXBT2cEqfy00u+0VB=cRUAtrgH9LD26gXgavdvmQyN+pQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] net: ethernet: renesas: Add Ethernet Switch driver
To:     kernel test robot <lkp@intel.com>
Cc:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, kbuild-all@lists.01.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 19, 2022 at 1:17 PM kernel test robot <lkp@intel.com> wrote:
> I love your patch! Perhaps something to improve:
>
> [auto build test WARNING on net-next/master]
> [also build test WARNING on net/master robh/for-next linus/master v6.1-rc1 next-20221019]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Yoshihiro-Shimoda/net-ethernet-renesas-Add-Ethernet-Switch-driver/20221019-163806
> patch link:    https://lore.kernel.org/r/20221019083518.933070-3-yoshihiro.shimoda.uh%40renesas.com
> patch subject: [PATCH v4 2/3] net: ethernet: renesas: Add Ethernet Switch driver
> config: m68k-allyesconfig
> compiler: m68k-linux-gcc (GCC) 12.1.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/intel-lab-lkp/linux/commit/f310f8cc37dfb090cfb06ae38530276327569464
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Yoshihiro-Shimoda/net-ethernet-renesas-Add-Ethernet-Switch-driver/20221019-163806
>         git checkout f310f8cc37dfb090cfb06ae38530276327569464
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash drivers/net/
>
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
>    drivers/net/ethernet/renesas/rswitch.c: In function 'rswitch_ext_desc_get_dptr':
> >> drivers/net/ethernet/renesas/rswitch.c:355:71: warning: left shift count >= width of type [-Wshift-count-overflow]
>      355 |         return __le32_to_cpu(desc->dptrl) | (dma_addr_t)(desc->dptrh) << 32;
>          |                                                                       ^~
>    drivers/net/ethernet/renesas/rswitch.c: In function 'rswitch_ext_ts_desc_get_dptr':
>    drivers/net/ethernet/renesas/rswitch.c:367:71: warning: left shift count >= width of type [-Wshift-count-overflow]
>      367 |         return __le32_to_cpu(desc->dptrl) | (dma_addr_t)(desc->dptrh) << 32;
>          |                                                                       ^~
>
>
> vim +355 drivers/net/ethernet/renesas/rswitch.c
>
>    352
>    353  static dma_addr_t rswitch_ext_desc_get_dptr(struct rswitch_ext_desc *desc)
>    354  {
>  > 355          return __le32_to_cpu(desc->dptrl) | (dma_addr_t)(desc->dptrh) << 32;

A simple fix would be to replace the cast to "dma_addr_t" by a cast to "u64".
A more convoluted fix would be:

    dma_addr_t dma;

    dma = __le32_to_cpu(desc->dptrl);
    if (IS_ENABLED(CONFIG_ARCH_DMA_ADDR_T_64BIT))
            dma |= (u64)desc->dptrh << 32;
    return dma;

Looking at the gcc compiler output, the both cases are optimized to the
exact same code, for both arm32 and arm64, so I'd go for the simple fix.

BTW, if struct rswitch_ext_desc would just extend struct rswitch_desc,
you could use rswitch_ext_desc_get_dptr() for both.

>    356  }
>    357

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
