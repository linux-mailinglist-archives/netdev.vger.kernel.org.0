Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF1D131B55A
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 07:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbhBOGII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 01:08:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:60382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229591AbhBOGIG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 01:08:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C814600EF;
        Mon, 15 Feb 2021 06:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613369245;
        bh=CVEnXyLzFoecXT0I4kiqQUOnpqR8iRGl2uwpQ7E675E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d5+bDjC3P3EGQ13F5uheGen04hti1B0Kh6rM3RUu2pXmAOPKZcEjAyCJX7SoaeCaY
         YPJYYeASF6FOerTiOE8hAzC5ona5+A7brJTI3rBqP6wVxZtRg1b7C0VFkQRYKHUPAc
         ycLGtBXzARi0bhdgqGUR4onPekPYhY7wJYhYh82WRyx0UfC5DVAnwqWfR+eSX3Py3o
         EYS1VRhC3DASjKAN1fIk3K3W3iU7/8ZNWg38a3rbv5QHInPb5N/eRdIMpzSl9SxD+1
         49tKg7ojMujHafBBvsUL+JbqpiFm2Z0z9acglFuzR7mDobuFfqpnOslK1e6ts5jocZ
         iYYdfnKnhNO7A==
Date:   Mon, 15 Feb 2021 08:07:21 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>, arnd@kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        punit1.agrawal@toshiba.co.jp, yuji2.ishikawa@toshiba.co.jp,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] net: stmmac: Add Toshiba Visconti SoCs glue driver
Message-ID: <YCoPmfunGmu0E8IT@unreal>
References: <20210215050655.2532-1-nobuhiro1.iwamatsu@toshiba.co.jp>
 <20210215050655.2532-3-nobuhiro1.iwamatsu@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210215050655.2532-3-nobuhiro1.iwamatsu@toshiba.co.jp>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 15, 2021 at 02:06:53PM +0900, Nobuhiro Iwamatsu wrote:
> Add dwmac-visconti to the stmmac driver in Toshiba Visconti ARM SoCs.
> This patch contains only the basic function of the device. There is no
> clock control, PM, etc. yet. These will be added in the future.
>
> Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
> ---
>  drivers/net/ethernet/stmicro/stmmac/Kconfig   |   8 +
>  drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
>  .../ethernet/stmicro/stmmac/dwmac-visconti.c  | 285 ++++++++++++++++++
>  3 files changed, 294 insertions(+)
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

I asked it before, but never received an answer.
Why did you use "def_bool y" and not "default y"? Isn't it supposed to be
"depends on STMMAC_ETH"? And probably it shouldn't be set as a default as "y".

Thanks
