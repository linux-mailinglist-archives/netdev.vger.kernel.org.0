Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58C0351F80E
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 11:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236817AbiEIJ1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 05:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235704AbiEIJY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 05:24:57 -0400
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD2EB131F22;
        Mon,  9 May 2022 02:21:01 -0700 (PDT)
Received: by mail-qk1-f173.google.com with SMTP id z126so10302506qkb.2;
        Mon, 09 May 2022 02:21:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gMtmW3ArowZdX4IsaNSLBpR+NhLcfUq95yoUD9gi7Sw=;
        b=RPbtzqE7rsbQATU6SraHZ5WF8sqL/dJMsdRf3VxMG2l0nyGHyJnVeR1CbqgVgiZwk7
         K1cckVRnICC1Ttt/J+vIz1+8hg5h+QsziFaqrJmHfKRWUYjfvSxW0IPzoW30Ycvtfqbr
         LoWndeocqBDIPgtNck0MoZHx4HjJ0lqEFa0hLFNYy4smuKdUmcfolZ1j+xDxBptDU/Xg
         32atW/LVRs28O66Vheo+fJqFaeGiyCyp/erqy7i0uKWGKDfXR0fipzGqm+mFGBNfGzJD
         hMAubUMZzWeB9o0I2WBUBPUPnayKzdFJJ8kjdqSbhguMF4rsQXGHwusQpvWIqaCFzdkt
         vCZg==
X-Gm-Message-State: AOAM532LFEsIpxM5WTRCEERrNv9b5cC8eNYIx8Qt41ds9PoaToFJYDW8
        +Oj2xyFjFF6gi2GNnMbfvOT+878GxtTFoA==
X-Google-Smtp-Source: ABdhPJxnCxGOKIp1bvvTmGtnVq0s0cmUaxXisxLRgd67SYcfs1XylGWC/N82+lVAr1wxirT3+vyUEA==
X-Received: by 2002:a05:620a:4488:b0:6a0:2aab:a736 with SMTP id x8-20020a05620a448800b006a02aaba736mr11287091qkp.717.1652088060478;
        Mon, 09 May 2022 02:21:00 -0700 (PDT)
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com. [209.85.219.177])
        by smtp.gmail.com with ESMTPSA id w24-20020ac87198000000b002f39b99f697sm7235538qto.49.2022.05.09.02.20.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 May 2022 02:20:59 -0700 (PDT)
Received: by mail-yb1-f177.google.com with SMTP id g28so23731968ybj.10;
        Mon, 09 May 2022 02:20:59 -0700 (PDT)
X-Received: by 2002:a25:4506:0:b0:648:cfc2:301d with SMTP id
 s6-20020a254506000000b00648cfc2301dmr12295875yba.380.1652088059134; Mon, 09
 May 2022 02:20:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220507125443.2766939-1-daniel.lezcano@linexp.org> <20220507125443.2766939-2-daniel.lezcano@linexp.org>
In-Reply-To: <20220507125443.2766939-2-daniel.lezcano@linexp.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 9 May 2022 11:20:47 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXXMzR+ukK9Bm+eWhLuWOozU6n96hTcGV5xf9omQvoHCA@mail.gmail.com>
Message-ID: <CAMuHMdXXMzR+ukK9Bm+eWhLuWOozU6n96hTcGV5xf9omQvoHCA@mail.gmail.com>
Subject: Re: [PATCH v2 01/14] thermal/core: Change thermal_zone_ops to thermal_sensor_ops
To:     daniel.lezcano@linexp.org
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Alexandre Bailon <abailon@baylibre.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Jonathan Corbet <corbet@lwn.net>, Len Brown <lenb@kernel.org>,
        Raju Rangoju <rajur@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@kernel.org>, Peter Kaestle <peter@piie.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Support Opensource <support.opensource@diasemi.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Miri Korenblit <miriam.rachel.korenblit@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Chuansheng Liu <chuansheng.liu@intel.com>,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Antoine Tenart <atenart@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "open list:ACPI THERMAL DRIVER" <linux-acpi@vger.kernel.org>,
        "open list:CXGB4 ETHERNET DRIVER (CXGB4)" <netdev@vger.kernel.org>,
        "open list:INTEL WIRELESS WIFI LINK (iwlwifi)" 
        <linux-wireless@vger.kernel.org>,
        "open list:ACER ASPIRE ONE TEMPERATURE AND FAN DRIVER" 
        <platform-driver-x86@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:RENESAS R-CAR THERMAL DRIVERS" 
        <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

Thanks for your patch!

On Sat, May 7, 2022 at 3:03 PM Daniel Lezcano <daniel.lezcano@linexp.org> wrote:
> A thermal zone is software abstraction of a sensor associated with
> properties and cooling devices if any.
>
> The fact that we have thermal_zone and thermal_zone_ops mixed is
> confusing and does not clearly identify the different components
> entering in the thermal management process. A thermal zone appears to
> be a sensor while it is not.
>
> In order to set the scene for multiple thermal sensors aggregated into
> a single thermal zone. Rename the thermal_zone_ops to
> thermal_sensor_ops, that will appear clearyl the thermal zone is not a

to make it clear

> sensor but an abstraction of one [or multiple] sensor(s).
>
> Cc: Alexandre Bailon <abailon@baylibre.com>
> Cc: Kevin Hilman <khilman@baylibre.com>
> Cc; Eduardo Valentin <eduval@amazon.com>
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linexp.org>

>  drivers/thermal/rcar_thermal.c                            | 4 ++--

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
