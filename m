Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EDA9682CFE
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 13:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231992AbjAaMvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 07:51:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231932AbjAaMvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 07:51:40 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75AD5392A8
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 04:51:38 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id bg13-20020a05600c3c8d00b003d9712b29d2so12377559wmb.2
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 04:51:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=n65vnVKUKNt8sq6OAnE9DvWi7qEHkIEJrwEj31voYJc=;
        b=UdiQFxg8bARvB8WUDhiJW5v0fhBx6P/SghoR4ExMXmol8S8ZOSR2N+/MLh2zBciUZj
         y/ARlUt9g/Eo8QFMkaHr297lO1wN1/szlws64TROBwrW1M3qohGMzBShVdhFPSKwMot5
         dAMJuflQqocRWPrl+nJaNGjXrg5eTobBJw9IkHFx4shQAS24q9KAO6jz47iep36vd/AT
         PnfhRqaJTR0CL9bC2FZ/p38o7vdBNXwdHYa00u9flA0Bvyn5XSimcKzw1r5+eKytmgg4
         oCgFwreYrfJjIJgNve1LoGUeRBnipbP+zHhF/XkBARDFwbwigPdtzVUStnFph+UPvis6
         MQLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n65vnVKUKNt8sq6OAnE9DvWi7qEHkIEJrwEj31voYJc=;
        b=W0iMP5iBqNhyoAurliM34dSjAh0giT0OusoKRRAuPvMGjiY9+UJMbVE4uJpNNK0WB5
         BQ4VX8GAPBVgcoKlom/QBGagwGcbrQbiJzYLOUJbdOKpIlzZkrGu6HSTA4zUFlq626cD
         1L/QPMkEXd9NPnLbpg2rqpWf6/HRS7kaUZOLoN+RgmhsgGliw6Ofu3aGpoBKEKcOwd3V
         GukygKPcefMrG9SMisV6umm8XGV7bt7i0H2nyglKQAGRk/9VY13QYlb5d5ASx2s9SFE8
         m8bXMjeTFx3OAKr+zsxsHH/RQfmJbB+3xAHwwN31stgBBLj0TT3GAb3iSDGfZPL8U9zX
         fdRg==
X-Gm-Message-State: AO0yUKVE9ZbILU24DGb+aQ/ClAVUs1PbdZeSYjr/2pqTk9LuHqF1Gk01
        35EKi51/NcJGED6NDPWYpzS9JA==
X-Google-Smtp-Source: AK7set87qQhpYFQ5Ln/lqHrC79343lQuL5eRVq9AVr7ltHrMJ+M2G75KQraxNDzZODnnDlOY3iQPVw==
X-Received: by 2002:a05:600c:500d:b0:3dd:97d6:8f2e with SMTP id n13-20020a05600c500d00b003dd97d68f2emr1559900wmr.17.1675169496919;
        Tue, 31 Jan 2023 04:51:36 -0800 (PST)
Received: from linaro.org ([94.52.112.99])
        by smtp.gmail.com with ESMTPSA id l16-20020a7bc350000000b003d9aa76dc6asm22318343wmj.0.2023.01.31.04.51.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 04:51:36 -0800 (PST)
Date:   Tue, 31 Jan 2023 14:51:34 +0200
From:   Abel Vesa <abel.vesa@linaro.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Abel Vesa <abelvesa@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        kernel@pengutronix.de, Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Russell King <linux@armlinux.org.uk>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 00/19] ARM: imx: make Ethernet refclock configurable
Message-ID: <Y9kO1rGH5hDWky//@linaro.org>
References: <20230131084642.709385-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131084642.709385-1-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23-01-31 09:46:23, Oleksij Rempel wrote:
> changes v3:
> - add Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
> - rebase on top of abelvesa/for-next

Applied all clk/imx ones. Thanks!

> 
> changes v2:
> - remove "ARM: imx6q: use of_clk_get_by_name() instead of_clk_get() to
>   get ptp clock" patch
> - fix build warnings
> - add "Acked-by: Lee Jones <lee@kernel.org>"
> - reword some commits as suggested by Fabio
> 
> Most of i.MX SoC variants have configurable FEC/Ethernet reference
> lock
> used by RMII specification. This functionality is located in the
> general purpose registers (GRPx) and till now was not implemented as
> part of SoC clock tree.
> 
> With this patch set, we move forward and add this missing functionality
> to some of i.MX clk drivers. So, we will be able to configure clock
> opology
> by using devicetree and be able to troubleshoot clock dependencies
> by using clk_summary etc.
> 
> Currently implemented and tested i.MX6Q, i.MX6DL and i.MX6UL variants.
> 
> 
> Oleksij Rempel (19):
>   clk: imx: add clk-gpr-mux driver
>   clk: imx6q: add ethernet refclock mux support
>   ARM: imx6q: skip ethernet refclock reconfiguration if enet_clk_ref is
>     present
>   ARM: dts: imx6qdl: use enet_clk_ref instead of enet_out for the FEC
>     node
>   ARM: dts: imx6dl-lanmcu: configure ethernet reference clock parent
>   ARM: dts: imx6dl-alti6p: configure ethernet reference clock parent
>   ARM: dts: imx6dl-plybas: configure ethernet reference clock parent
>   ARM: dts: imx6dl-plym2m: configure ethernet reference clock parent
>   ARM: dts: imx6dl-prtmvt: configure ethernet reference clock parent
>   ARM: dts: imx6dl-victgo: configure ethernet reference clock parent
>   ARM: dts: imx6q-prtwd2: configure ethernet reference clock parent
>   ARM: dts: imx6qdl-skov-cpu: configure ethernet reference clock parent
>   ARM: dts: imx6dl-eckelmann-ci4x10: configure ethernet reference clock
>     parent
>   clk: imx: add imx_obtain_fixed_of_clock()
>   clk: imx6ul: fix enet1 gate configuration
>   clk: imx6ul: add ethernet refclock mux support
>   ARM: dts: imx6ul: set enet_clk_ref to CLK_ENETx_REF_SEL
>   ARM: mach-imx: imx6ul: remove not optional ethernet refclock overwrite
>   ARM: dts: imx6ul-prti6g: configure ethernet reference clock parent
> 
>  arch/arm/boot/dts/imx6dl-alti6p.dts           |  12 +-
>  arch/arm/boot/dts/imx6dl-eckelmann-ci4x10.dts |  13 +-
>  arch/arm/boot/dts/imx6dl-lanmcu.dts           |  12 +-
>  arch/arm/boot/dts/imx6dl-plybas.dts           |  12 +-
>  arch/arm/boot/dts/imx6dl-plym2m.dts           |  12 +-
>  arch/arm/boot/dts/imx6dl-prtmvt.dts           |  11 +-
>  arch/arm/boot/dts/imx6dl-victgo.dts           |  12 +-
>  arch/arm/boot/dts/imx6q-prtwd2.dts            |  17 ++-
>  arch/arm/boot/dts/imx6qdl-skov-cpu.dtsi       |  12 +-
>  arch/arm/boot/dts/imx6qdl.dtsi                |   4 +-
>  arch/arm/boot/dts/imx6ul-prti6g.dts           |  14 ++-
>  arch/arm/boot/dts/imx6ul.dtsi                 |  10 +-
>  arch/arm/mach-imx/mach-imx6q.c                |  10 +-
>  arch/arm/mach-imx/mach-imx6ul.c               |  20 ---
>  drivers/clk/imx/Makefile                      |   1 +
>  drivers/clk/imx/clk-gpr-mux.c                 | 119 ++++++++++++++++++
>  drivers/clk/imx/clk-imx6q.c                   |  13 ++
>  drivers/clk/imx/clk-imx6ul.c                  |  33 ++++-
>  drivers/clk/imx/clk.c                         |  14 +++
>  drivers/clk/imx/clk.h                         |   8 ++
>  include/dt-bindings/clock/imx6qdl-clock.h     |   4 +-
>  include/dt-bindings/clock/imx6ul-clock.h      |   7 +-
>  include/linux/mfd/syscon/imx6q-iomuxc-gpr.h   |   6 +-
>  23 files changed, 296 insertions(+), 80 deletions(-)
>  create mode 100644 drivers/clk/imx/clk-gpr-mux.c
> 
> -- 
> 2.30.2
> 
