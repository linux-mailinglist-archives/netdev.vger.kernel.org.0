Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4172460BD42
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 00:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231162AbiJXWTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 18:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232136AbiJXWTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 18:19:24 -0400
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D5C030F9DD;
        Mon, 24 Oct 2022 13:36:49 -0700 (PDT)
Received: by mail-qk1-f176.google.com with SMTP id a18so6872702qko.0;
        Mon, 24 Oct 2022 13:36:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yYxFT6Ykd1Wr0+ICysK5Xd7jISrpDQ+r635XImWlzf0=;
        b=QEjw10dykjyDM543pBxA1qhz9xttlulerWDCp4NT2P0O9Di4sspd5BAaBrMDAuxzr8
         OBlObuvcjC9B/A8Ht3XDnV3XrCIhHtoopyu7BxXAPeao59mX1Zol/NRXNiX/jDRg3spV
         qWtsjKSPMSRWX7QHLnMJfE9Zvs0zvfP+AyVVnqcMwIUVinofsz+2y12HvZlSziBRq3pT
         a//Kv+9kyZmUkL07tMI21f69PnyxomnKopoO8EjW8dsjiKgPbjhmvJsSMfbjmO79chYX
         L2q+JANHQfvqDPZzPVF7tIQxyeuytAmbFGs1VoKBFPcpAxWWjnBgnd3qKR7NS39fHkAN
         gDuQ==
X-Gm-Message-State: ACrzQf01FUQXkf3/snR5HI417+AxUBIY4AnU7XLP5Xe5u97zTE2UavDD
        QuqBCq2deGgYgYCx3UHii6vgIWiu8U2yJg==
X-Google-Smtp-Source: AMsMyM6BVlxBodu2isqZi/nHNp+DBjZA6YEAeJAuVLCM10/VOKf1TYiSs/Sa0Qvdk4qHUi5dS9qT3Q==
X-Received: by 2002:a05:620a:240f:b0:6ec:ffd0:22a4 with SMTP id d15-20020a05620a240f00b006ecffd022a4mr24568272qkn.523.1666643753277;
        Mon, 24 Oct 2022 13:35:53 -0700 (PDT)
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com. [209.85.219.172])
        by smtp.gmail.com with ESMTPSA id v14-20020a05622a188e00b0039a8b075248sm545400qtc.14.2022.10.24.13.35.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 13:35:52 -0700 (PDT)
Received: by mail-yb1-f172.google.com with SMTP id 187so3223130ybe.1;
        Mon, 24 Oct 2022 13:35:51 -0700 (PDT)
X-Received: by 2002:a25:d24a:0:b0:6ca:4a7a:75cd with SMTP id
 j71-20020a25d24a000000b006ca4a7a75cdmr20186708ybg.89.1666643750729; Mon, 24
 Oct 2022 13:35:50 -0700 (PDT)
MIME-Version: 1.0
References: <20221019083518.933070-3-yoshihiro.shimoda.uh@renesas.com>
 <202210191806.RZK10y3x-lkp@intel.com> <CAMuHMdXBT2cEqfy00u+0VB=cRUAtrgH9LD26gXgavdvmQyN+pQ@mail.gmail.com>
 <d7c9b9b4-4ee8-4754-b32f-e3205daf47b3@app.fastmail.com>
In-Reply-To: <d7c9b9b4-4ee8-4754-b32f-e3205daf47b3@app.fastmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 24 Oct 2022 22:35:39 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWbkro70fmyauUnEPyKZYytWD0o4a06=UzDTzCZ9-B6vw@mail.gmail.com>
Message-ID: <CAMuHMdWbkro70fmyauUnEPyKZYytWD0o4a06=UzDTzCZ9-B6vw@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] net: ethernet: renesas: Add Ethernet Switch driver
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     kernel test robot <lkp@intel.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        krzysztof.kozlowski+dt@linaro.org, kbuild-all@lists.01.org,
        Netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
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

Hi Arnd,

On Mon, Oct 24, 2022 at 9:55 PM Arnd Bergmann <arnd@arndb.de> wrote:
> On Mon, Oct 24, 2022, at 17:27, Geert Uytterhoeven wrote:
> > On Wed, Oct 19, 2022 at 1:17 PM kernel test robot <lkp@intel.com> wrote:
> >>    drivers/net/ethernet/renesas/rswitch.c: In function 'rswitch_ext_desc_get_dptr':
> >> >> drivers/net/ethernet/renesas/rswitch.c:355:71: warning: left shift count >= width of type [-Wshift-count-overflow]
> >>      355 |         return __le32_to_cpu(desc->dptrl) | (dma_addr_t)(desc->dptrh) << 32;
> >>          |                                                                       ^~
> >>    drivers/net/ethernet/renesas/rswitch.c: In function 'rswitch_ext_ts_desc_get_dptr':
> >>    drivers/net/ethernet/renesas/rswitch.c:367:71: warning: left shift count >= width of type [-Wshift-count-overflow]
> >>      367 |         return __le32_to_cpu(desc->dptrl) | (dma_addr_t)(desc->dptrh) << 32;
> >>          |                                                                       ^~
> >>
> >>
> >> vim +355 drivers/net/ethernet/renesas/rswitch.c
> >>
> >>    352
> >>    353  static dma_addr_t rswitch_ext_desc_get_dptr(struct rswitch_ext_desc *desc)
> >>    354  {
> >>  > 355          return __le32_to_cpu(desc->dptrl) | (dma_addr_t)(desc->dptrh) << 32;
> >
> > A simple fix would be to replace the cast to "dma_addr_t" by a cast to "u64".
> > A more convoluted fix would be:
> >
> >     dma_addr_t dma;
> >
> >     dma = __le32_to_cpu(desc->dptrl);
> >     if (IS_ENABLED(CONFIG_ARCH_DMA_ADDR_T_64BIT))
> >             dma |= (u64)desc->dptrh << 32;
> >     return dma;
> >
> > Looking at the gcc compiler output, the both cases are optimized to the
> > exact same code, for both arm32 and arm64, so I'd go for the simple fix.
> >
> > BTW, if struct rswitch_ext_desc would just extend struct rswitch_desc,
> > you could use rswitch_ext_desc_get_dptr() for both.
> >
>
> Regardless of which way this is expressed, it looked like there is
> a missing __le32_to_cpu() around the high word.

I think it's OK, because desc->dptrh is u8:

    struct rswitch_desc {
            __le16 info_ds; /* Descriptor size */
            u8 die_dt;      /* Descriptor interrupt enable and type */
            __u8  dptrh;    /* Descriptor pointer MSB */
            __le32 dptrl;   /* Descriptor pointer LSW */
    } __packed;

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
