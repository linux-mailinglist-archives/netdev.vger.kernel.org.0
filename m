Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52B9B60C3FC
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 08:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbiJYGsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 02:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiJYGsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 02:48:23 -0400
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5109B3B30;
        Mon, 24 Oct 2022 23:48:22 -0700 (PDT)
Received: by mail-qk1-f169.google.com with SMTP id o2so7479368qkk.10;
        Mon, 24 Oct 2022 23:48:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RCdxzpG/IM7eM2oVhWiHkGzrr4g33IhjuElBadOIVHg=;
        b=iPQ/Fj+CBe47YoxxJrIYyvuBrYIEf2RnWwcE2yhJDLH68rM2Dl/qOdd8PeTkzwmeXi
         wPcPVtupx4wIUuiWL2fSMKGc4Z1e2Mu9vGYXq3ok9wJYKtu52i2jzKzbus7AM708PIuz
         msSihi6Ah2Ztwbzd5yEyFDW7NnxfjGACoK1Bo6MCyxEOP4SGAPxVyrXOUj6qF850wUxU
         B6iaIaq++fgtUo1qXgw11pEdBW9sar7V+sRDTMSjzi9RVrtU7fJqtc37e1kBJ0+sH+rH
         O2WVGhgtfVrVDluRsnXLFGvvAATklDJLA8cb2YAGYzHqFqr8Ti30oyJ7PmWam2vqOCI1
         Tz6A==
X-Gm-Message-State: ACrzQf3frRCmKnzY4+/Po1B2k0lb/wxznjcqOqA8zonfdfPq9ctpUpB6
        3weDWUbdo3ZMiG5yAuCE2ml0LV6kGBMuRg==
X-Google-Smtp-Source: AMsMyM6fULg5S51WHVlufUBgyUhFv9akx58tcgDKNBiRvRrypSWcAc/HbzpJbxczi46eQexMqIidjQ==
X-Received: by 2002:a05:620a:14b2:b0:6ea:1443:8c0a with SMTP id x18-20020a05620a14b200b006ea14438c0amr19731658qkj.302.1666680501350;
        Mon, 24 Oct 2022 23:48:21 -0700 (PDT)
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com. [209.85.219.180])
        by smtp.gmail.com with ESMTPSA id f14-20020a05620a280e00b006eec09eed39sm1549652qkp.40.2022.10.24.23.48.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 23:48:20 -0700 (PDT)
Received: by mail-yb1-f180.google.com with SMTP id r3so13490971yba.5;
        Mon, 24 Oct 2022 23:48:19 -0700 (PDT)
X-Received: by 2002:a25:cd01:0:b0:6c2:6f0d:f4ce with SMTP id
 d1-20020a25cd01000000b006c26f0df4cemr30518508ybf.365.1666680499617; Mon, 24
 Oct 2022 23:48:19 -0700 (PDT)
MIME-Version: 1.0
References: <20221019083518.933070-3-yoshihiro.shimoda.uh@renesas.com>
 <202210191806.RZK10y3x-lkp@intel.com> <CAMuHMdXBT2cEqfy00u+0VB=cRUAtrgH9LD26gXgavdvmQyN+pQ@mail.gmail.com>
 <TYBPR01MB5341E2B5F143F178F0AFD1CBD8319@TYBPR01MB5341.jpnprd01.prod.outlook.com>
In-Reply-To: <TYBPR01MB5341E2B5F143F178F0AFD1CBD8319@TYBPR01MB5341.jpnprd01.prod.outlook.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 25 Oct 2022 08:48:07 +0200
X-Gmail-Original-Message-ID: <CAMuHMdU+O+hz9ja18cFkmwtz+AfEXJHz7N5Hx0S9aw+zD9wkEQ@mail.gmail.com>
Message-ID: <CAMuHMdU+O+hz9ja18cFkmwtz+AfEXJHz7N5Hx0S9aw+zD9wkEQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] net: ethernet: renesas: Add Ethernet Switch driver
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     kernel test robot <lkp@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Shimoda-san,

On Tue, Oct 25, 2022 at 6:39 AM Yoshihiro Shimoda
<yoshihiro.shimoda.uh@renesas.com> wrote:
> > From: Geert Uytterhoeven, Sent: Tuesday, October 25, 2022 12:28 AM
> > To: kernel test robot <lkp@intel.com>
> > Cc: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>; davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> > pabeni@redhat.com; robh+dt@kernel.org; krzysztof.kozlowski+dt@linaro.org; kbuild-all@lists.01.org;
> > netdev@vger.kernel.org; devicetree@vger.kernel.org; linux-renesas-soc@vger.kernel.org
> > Subject: Re: [PATCH v4 2/3] net: ethernet: renesas: Add Ethernet Switch driver
> >
> > On Wed, Oct 19, 2022 at 1:17 PM kernel test robot <lkp@intel.com> wrote:
> > > I love your patch! Perhaps something to improve:
> > >
> > > [auto build test WARNING on net-next/master]
> > > [also build test WARNING on net/master robh/for-next linus/master v6.1-rc1 next-20221019]
> > > [If your patch is applied to the wrong git tree, kindly drop us a note.
> > > And when submitting patch, we suggest to use '--base' as documented in
> > >
> <snip>
> > >         git checkout f310f8cc37dfb090cfb06ae38530276327569464
> > >         # save the config file
> > >         mkdir build_dir && cp config build_dir/.config
> > >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash
> > drivers/net/
> > >
> > > If you fix the issue, kindly add following tag where applicable
> > > | Reported-by: kernel test robot <lkp@intel.com>
> > >
> > > All warnings (new ones prefixed by >>):
> > >
> > >    drivers/net/ethernet/renesas/rswitch.c: In function 'rswitch_ext_desc_get_dptr':
> > > >> drivers/net/ethernet/renesas/rswitch.c:355:71: warning: left shift count >= width of type [-Wshift-count-overflow]
> > >      355 |         return __le32_to_cpu(desc->dptrl) | (dma_addr_t)(desc->dptrh) << 32;
> > >          |                                                                       ^~
> > >    drivers/net/ethernet/renesas/rswitch.c: In function 'rswitch_ext_ts_desc_get_dptr':
> > >    drivers/net/ethernet/renesas/rswitch.c:367:71: warning: left shift count >= width of type [-Wshift-count-overflow]
> > >      367 |         return __le32_to_cpu(desc->dptrl) | (dma_addr_t)(desc->dptrh) << 32;
> > >          |                                                                       ^~
> > >
> > >
> > > vim +355 drivers/net/ethernet/renesas/rswitch.c
> > >
> > >    352
> > >    353  static dma_addr_t rswitch_ext_desc_get_dptr(struct rswitch_ext_desc *desc)
> > >    354  {
> > >  > 355          return __le32_to_cpu(desc->dptrl) | (dma_addr_t)(desc->dptrh) << 32;
> >
> > A simple fix would be to replace the cast to "dma_addr_t" by a cast to "u64".

> I got it. I'll fix this by a cast to "u64".
>
> > BTW, if struct rswitch_ext_desc would just extend struct rswitch_desc,
> > you could use rswitch_ext_desc_get_dptr() for both.
>
> Yes, all rswitch_xxx_desc just extend struct rswitch_desc.
> So, I'll modify this function like below:
> ---
> /* All struct rswitch_xxx_desc just extend struct rswitch_desc, so that
>  * we can use rswitch_desc_get_dptr() for them.
>  */
> static dma_addr_t rswitch_desc_get_dptr(void *_desc)
> {
>         struct rswitch_desc *desc = _desc;
>
>         return __le32_to_cpu(desc->dptrl) | (u64)(desc->dptrh) << 32;
> }

While the above would work, the void * parameter inhibits compiler checks.

Hence I suggest defining struct rswitch_ext_desc like:

    struct rswitch_ext_desc {
            struct rswitch_desc desc;
            __le64 info1;
    };

Then you can just pass &ext->desc to a function that takes a
(const) struct rswitch_desc *.


Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
