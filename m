Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76CE865E032
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 23:45:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240608AbjADWpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 17:45:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235227AbjADWp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 17:45:29 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C36A742E11;
        Wed,  4 Jan 2023 14:45:28 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id h185so8202682oif.5;
        Wed, 04 Jan 2023 14:45:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=n0P1Cn3HY9tpg3++h0RgufbLi9nhgqUDgcarrxGrEhc=;
        b=CTW47R0r4NmIs6nU+t9MKUeCBx6pEjcnIVkPO0q//i1TLZZf6BtV5PJGbQMXosd++o
         uSd088mijuoe1rTdoK5ci2YBpW6svSFp89RAkA5F2k4JwTO5NNpS/M0bij6it42iyt82
         DBrlEb7nHLtbz9YgXUyZ/naOrgjCZVin0M+hgg1Uv6W+FAuWSpIVsXX/QDJdF+GYQqKO
         H0CVgU0hVh0iBCwn66cSmS2FIMujHwg09VbWzUzC/bz5u8rf6skGiYgxdO4OqBxPsytl
         P4VUsp35wsnosc94bjTDu3Od7My9UoGXvMCQTuEtMsZWbGdxGnlOKGjTYZ4yZSbuwSSK
         wHJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n0P1Cn3HY9tpg3++h0RgufbLi9nhgqUDgcarrxGrEhc=;
        b=Co2bM3jh7Rm9fq4t4xkjT0gX8pFxztVBYh0VeCZjy7oxIQVWZhXo2c66lZOAsI9zeU
         xiNGbdfAwpVcRAUGpQ/7fQQ8/H2YTn8GLXwvOutj5UfXBuS8J/B+gF34HB5lPBEJXYwW
         1mLTCbJrqfwjbvKnLkfgn66O880JiPUnde2E0yZVpZ5odMNPY7iJaKhWDNNs6GSMbl+K
         Id8WV5CCVfZu7//pphJFbsHmY+jYKCukzEpqbfETGnhA9NZI0zO853ssQYTaaChw99RJ
         YNZbk0sFLjonOeB63tPCArtkdQbOUBY5fqx9flOyPgh8BKhvbcm62tsXkHP6B5TDMd0l
         oczA==
X-Gm-Message-State: AFqh2ko+/gd2Jyi0rzisRBcNuRaDC579b+2sWellR8k2NXVkJpKjnXMY
        z4yVX9hoe3/sfrXvDJ1nJ66QRjw+8Ho=
X-Google-Smtp-Source: AMrXdXs2r16GJCTizyevH27pi+20ETe7z/MiQjxbt7H7twer0U6M2TcXHj+kjrH1sRwEQ4dCYqNl4w==
X-Received: by 2002:a05:6808:2898:b0:35e:13d2:ac2f with SMTP id eu24-20020a056808289800b0035e13d2ac2fmr20625764oib.8.1672872328058;
        Wed, 04 Jan 2023 14:45:28 -0800 (PST)
Received: from neuromancer. (76-244-6-13.lightspeed.rcsntx.sbcglobal.net. [76.244.6.13])
        by smtp.gmail.com with ESMTPSA id o189-20020aca41c6000000b00360e46a1edasm14594612oia.22.2023.01.04.14.45.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 14:45:27 -0800 (PST)
Message-ID: <63b60187.ca0a0220.a832f.5d69@mx.google.com>
X-Google-Original-Message-ID: <Y7YBhOuq6jNaT99m@neuromancer.>
Date:   Wed, 4 Jan 2023 16:45:24 -0600
From:   Chris Morgan <macroalpha82@gmail.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mmc@vger.kernel.org, Nitin Gupta <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>, Pkshih <pkshih@realtek.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Subject: Re: [RFC PATCH v1 19/19] rtw88: Add support for the SDIO based
 RTL8821CS chipset
References: <20221227233020.284266-1-martin.blumenstingl@googlemail.com>
 <20221227233020.284266-20-martin.blumenstingl@googlemail.com>
 <63b4b3e1.050a0220.791fb.767c@mx.google.com>
 <CAFBinCDpMjHPZ4CA-YdyAu=k1F_7DxxYEMSjnBEX2aMWfSCCeA@mail.gmail.com>
 <63b5b1c0.050a0220.a0efc.de06@mx.google.com>
 <CAFBinCCvf8E6jwjtoSgATnBxULgytFsUnphzUuaVPygsO3Prwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFBinCCvf8E6jwjtoSgATnBxULgytFsUnphzUuaVPygsO3Prwg@mail.gmail.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 04, 2023 at 06:23:24PM +0100, Martin Blumenstingl wrote:
> On Wed, Jan 4, 2023 at 6:05 PM Chris Morgan <macroalpha82@gmail.com> wrote:
> [...]
> > > > [    0.989545] mmc2: new high speed SDIO card at address 0001
> > > > [    0.989993] rtw_8821cs mmc2:0001:1: Firmware version 24.8.0, H2C version 12
> > > > [    1.005684] rtw_8821cs mmc2:0001:1: sdio write32 failed (0x14): -110
> > > > [    1.005737] rtw_8821cs mmc2:0001:1: sdio read32 failed (0x1080): -110
> > > > [    1.005789] rtw_8821cs mmc2:0001:1: sdio write32 failed (0x11080): -110
> > > > [    1.005840] rtw_8821cs mmc2:0001:1: sdio read8 failed (0x3): -110
> > > > [    1.005920] rtw_8821cs mmc2:0001:1: sdio read8 failed (0x1103): -110
> > > > [    1.005998] rtw_8821cs mmc2:0001:1: sdio read32 failed (0x80): -110
> > > > [    1.006078] rtw_8821cs mmc2:0001:1: sdio read32 failed (0x1700): -110
> > > The error starts with a write to register 0x14 (REG_SDIO_HIMR), which
> > > happens right after configuring RX aggregation.
> > > Can you please try two modifications inside
> > > drivers/net/wireless/realtek/rtw88/sdio.c:
> > > 1. inside the rtw_sdio_start() function: change
> > > "rtw_sdio_rx_aggregation(rtwdev, false);" to
> > > "rtw_sdio_rx_aggregation(rtwdev, true);"
> >
> > No change, still receive identical issue.
> >
> > > 2. if 1) does not work: remove the call to rtw_sdio_rx_aggregation()
> > > from rtw_sdio_start()
> > >
> >
> > Same here, still receive identical issue.
> Thanks for testing and for reporting back!
> 
> Looking back at it again: I think I mis-interpreted your error output.
> I think it's actually failing in __rtw_mac_init_system_cfg()
> 
> Can you please try the latest code from [0] (ignoring any changes I
> recommended previously)?
> There's two bug fixes in there (compared to this series) which may
> solve the issue that you are seeing:
> - fix typos to use "if (!*err_ret ..." (to read the error code)
> instead of "if (!err_ret ..." (which just checks if a non-null pointer
> was passed) in rtw_sdio_read_indirect{8,32}
> - change buf[0] to buf[i] in rtw_sdio_read_indirect_bytes
> 
> These fixes will be part of v2 of this series anyways.

That still doesn't fix it, I receive the same error. I'm using an older
patch series of yours (that I can't seem to find on github anymore),
so I'll see if I can compare the older series that works with this one
and find out the root cause.

Thank you.

> 
> 
> Best regards,
> Martin
> 
> 
> [0] https://github.com/xdarklight/linux/tree/d115a8631d208996510822f0805df5dfc8dfb548
