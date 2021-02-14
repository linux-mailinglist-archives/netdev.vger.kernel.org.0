Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8659C31AF70
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 07:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbhBNGYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 01:24:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:51556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229563AbhBNGYJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Feb 2021 01:24:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FF1461493;
        Sun, 14 Feb 2021 06:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613283808;
        bh=gyHaPIi6u1QJKRyZ21cjlD4KDij/CAQi3EWyEj06O3k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Tid3QJWctVhVG3ueveOYBmMGlxNf1bz8ZDnmZZ4X9Rl5OoD7og1WLKr50HUa5G6Wd
         ++bx7h+pgaXU4GT9UbcXW7QLfEN/zAFDsGt3btMHZiWa8xHgGQKZKbrTqCvJ6GVFas
         8FQSzXSJK8Utv3pWuKgJWQREeJ8NkMmivgsM/wc2mVMbR/4rG2kxIYmhyZARzFKUdm
         mhkuYIXAjZ8Nf1z7xxgiY8D3JDB27ahQUp1V4xgtaWuYJi2TGnpb4XVzA15J2gkFVI
         46blooD1EgPg7L8zuxqirJJHFRNqx3FgQC2FmOjqFxUET+tGCZHP1daZDFdHC/Qf6x
         wDYlwyoAVe4hQ==
Date:   Sun, 14 Feb 2021 08:23:25 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, punit1.agrawal@toshiba.co.jp,
        yuji2.ishikawa@toshiba.co.jp, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] net: stmmac: Add Toshiba Visconti SoCs glue driver
Message-ID: <YCjB3btP5+h4pISJ@unreal>
References: <20210212025806.556217-1-nobuhiro1.iwamatsu@toshiba.co.jp>
 <20210212025806.556217-3-nobuhiro1.iwamatsu@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210212025806.556217-3-nobuhiro1.iwamatsu@toshiba.co.jp>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 11:58:04AM +0900, Nobuhiro Iwamatsu wrote:
> Add dwmac-visconti to the stmmac driver in Toshiba Visconti ARM SoCs.
> This patch contains only the basic function of the device. There is no
> clock control, PM, etc. yet. These will be added in the future.
>
> Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
> ---
>  drivers/net/ethernet/stmicro/stmmac/Kconfig   |   8 +
>  drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
>  .../ethernet/stmicro/stmmac/dwmac-visconti.c  | 288 ++++++++++++++++++
>  3 files changed, 297 insertions(+)
>  create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
>
> diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
> index 53f14c5a9e02..55ba67a550b9 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
> +++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
> @@ -219,6 +219,14 @@ config DWMAC_INTEL_PLAT
>  	  This selects the Intel platform specific glue layer support for
>  	  the stmmac device driver. This driver is used for the Intel Keem Bay
>  	  SoC.
> +
> +config DWMAC_VISCONTI
> +	bool "Toshiba Visconti DWMAC support"
> +	def_bool y

Doesn't it need to be "default y"?

Thanks

> +	depends on OF && COMMON_CLK && (ARCH_VISCONTI || COMPILE_TEST)
> +	help
> +	  Support for ethernet controller on Visconti SoCs.
> +
>  endif
