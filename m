Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D87A3D72E5
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 12:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236131AbhG0KPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 06:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236152AbhG0KPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 06:15:37 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2E66C061757
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 03:15:34 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id nb11so21239133ejc.4
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 03:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+T75AOpYGFSLU6IJVWaPfqwjxNQcCkDp5FDRrgqc0bI=;
        b=fd9CpsCidwELp1+59OJTFmrRkgfvzWD03utI/qdSFQW8uOUkThfVKCUTdDgconS9yh
         jrRNMDI/24sbw3LuqQEaJQUcfMS6zfpJVaaZbCqlrty0L/woVGRvBdxt1HOFJm5OngPO
         eTJteNbN7Zq+hn95zWX9dNAAOkwmawaaN8CPLFc9nZlWFdQMImmFfxdKaCjWcv/k/AeY
         abaaWev6uP6Ir24dX4fnGJUFqFVoEColBK7zhNnETazlFJpPRc/cyA2ssllrlcDdw99+
         sZbUyqJ8tmi98FDNL2Z2lly5lc005+xTkZWGCxIH9KHO85eHsojEb6RrqfCb081+c3J+
         AZIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+T75AOpYGFSLU6IJVWaPfqwjxNQcCkDp5FDRrgqc0bI=;
        b=fq+eKpRkMUWl5Db2violLTJAbBkMIJORx/YEqmHZ53HWeuF0cgdk4pfnfDaTQXUP6c
         29Pzrog9at+hpSjJVvGuElSljsYu3IZYHWesPFLYUgYCe4TUiK9ZUgxnNol0TqnqlwcA
         F675sP9fqDElWDNU8OBQ+5sQ2owEv6wNRuRqMI777lux4Y1UCjAQJmizZNAp85DUpSh2
         fxgTko9x7IVVxQpCrLWtaIrV/lFA+cMLsRqHt91otA2XvmaMY2mzKNPNOd1NwMjH0Gw6
         3tL7pgQEukgmq2AyIJNiQul0SIjEBGwBp+yU3Bc0pHjRf2gI5jUt/k8jMGMVJrxdc/cy
         xZ7w==
X-Gm-Message-State: AOAM5314SXikmV+fbL9irrXuFi7YFTtw/gLPKsop4R49Bsu5qI5xQGIU
        EuI+XBSxR32cRfL0kiCCKxwDmlSOWOjV5VayMemg/Q==
X-Google-Smtp-Source: ABdhPJxUv93YK+lIQMKEKDcRDn0oD9+Y3wwskgSl8RXlNP5GrAmpmwFI/oTLyIa917oKTDcXm0zXDfDQVDubXQ64jiU=
X-Received: by 2002:a17:906:c107:: with SMTP id do7mr21170421ejc.469.1627380933430;
 Tue, 27 Jul 2021 03:15:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210726142536.1223744-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210726142536.1223744-1-vladimir.oltean@nxp.com>
From:   Anders Roxell <anders.roxell@linaro.org>
Date:   Tue, 27 Jul 2021 12:15:22 +0200
Message-ID: <CADYN=9JvXL-Fc23Rs_4SW2c65YBqSVQptmRCcXA7zp7CbR7pJg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: build all switchdev drivers as modules when
 the bridge is a module
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Linux Kernel Functional Testing <lkft@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Jul 2021 at 16:26, Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>
> Currently, all drivers depend on the bool CONFIG_NET_SWITCHDEV, but only
> the drivers that call some sort of function exported by the bridge, like
> br_vlan_enabled() or whatever, have an extra dependency on CONFIG_BRIDGE.
>
> Since the blamed commit, all switchdev drivers have a functional
> dependency upon switchdev_bridge_port_{,un}offload(), which is a pair of
> functions exported by the bridge module and not by the bridge-independent
> part of CONFIG_NET_SWITCHDEV.
>
> Problems appear when we have:
>
> CONFIG_BRIDGE=m
> CONFIG_NET_SWITCHDEV=y
> CONFIG_TI_CPSW_SWITCHDEV=y
>
> because cpsw, am65_cpsw and sparx5 will then be built-in but they will
> call a symbol exported by a loadable module. This is not possible and
> will result in the following build error:
>
> drivers/net/ethernet/ti/cpsw_new.o: in function `cpsw_netdevice_event':
> drivers/net/ethernet/ti/cpsw_new.c:1520: undefined reference to
>                                         `switchdev_bridge_port_offload'
> drivers/net/ethernet/ti/cpsw_new.c:1537: undefined reference to
>                                         `switchdev_bridge_port_unoffload'
>
> As mentioned, the other switchdev drivers don't suffer from this because
> switchdev_bridge_port_offload() is not the first symbol exported by the
> bridge that they are calling, so they already needed to deal with this
> in the same way.
>
> Fixes: 2f5dc00f7a3e ("net: bridge: switchdev: let drivers inform which bridge ports are offloaded")
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Thank you for providing this fix.

Tested building omap2plus_defconfig.

Tested-by: Anders Roxell <anders.roxell@linaro.org>

Cheers,
Anders

> ---
>  drivers/net/ethernet/microchip/sparx5/Kconfig | 1 +
>  drivers/net/ethernet/ti/Kconfig               | 2 ++
>  2 files changed, 3 insertions(+)
>
> diff --git a/drivers/net/ethernet/microchip/sparx5/Kconfig b/drivers/net/ethernet/microchip/sparx5/Kconfig
> index 7bdbb2d09a14..d39ae2a6fb49 100644
> --- a/drivers/net/ethernet/microchip/sparx5/Kconfig
> +++ b/drivers/net/ethernet/microchip/sparx5/Kconfig
> @@ -1,5 +1,6 @@
>  config SPARX5_SWITCH
>         tristate "Sparx5 switch driver"
> +       depends on BRIDGE || BRIDGE=n
>         depends on NET_SWITCHDEV
>         depends on HAS_IOMEM
>         depends on OF
> diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
> index affcf92cd3aa..7ac8e5ecbe97 100644
> --- a/drivers/net/ethernet/ti/Kconfig
> +++ b/drivers/net/ethernet/ti/Kconfig
> @@ -64,6 +64,7 @@ config TI_CPSW
>  config TI_CPSW_SWITCHDEV
>         tristate "TI CPSW Switch Support with switchdev"
>         depends on ARCH_DAVINCI || ARCH_OMAP2PLUS || COMPILE_TEST
> +       depends on BRIDGE || BRIDGE=n
>         depends on NET_SWITCHDEV
>         depends on TI_CPTS || !TI_CPTS
>         select PAGE_POOL
> @@ -109,6 +110,7 @@ config TI_K3_AM65_CPSW_NUSS
>  config TI_K3_AM65_CPSW_SWITCHDEV
>         bool "TI K3 AM654x/J721E CPSW Switch mode support"
>         depends on TI_K3_AM65_CPSW_NUSS
> +       depends on BRIDGE || BRIDGE=n
>         depends on NET_SWITCHDEV
>         help
>          This enables switchdev support for TI K3 CPSWxG Ethernet
> --
> 2.25.1
>
