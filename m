Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95CF5EDAE6
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 09:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbfKDI55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 03:57:57 -0500
Received: from ns.iliad.fr ([212.27.33.1]:35578 "EHLO ns.iliad.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726100AbfKDI54 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Nov 2019 03:57:56 -0500
Received: from ns.iliad.fr (localhost [127.0.0.1])
        by ns.iliad.fr (Postfix) with ESMTP id CD2471FFB8;
        Mon,  4 Nov 2019 09:57:54 +0100 (CET)
Received: from [192.168.108.51] (freebox.vlq16.iliad.fr [213.36.7.13])
        by ns.iliad.fr (Postfix) with ESMTP id B16231FF3E;
        Mon,  4 Nov 2019 09:57:54 +0100 (CET)
Subject: Re: [PATCH 1/1] net: ethernet: stmmac: fix warning when w=1 option is
 used during build
To:     Christophe Roullier <christophe.roullier@st.com>,
        netdev <netdev@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, alexandre.torgue@st.com,
        peppe.cavallaro@st.com, Andrew Lunn <andrew@lunn.ch>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
References: <20191104083438.8288-1-christophe.roullier@st.com>
From:   Marc Gonzalez <marc.w.gonzalez@free.fr>
Message-ID: <78d0c14a-fde0-72ca-e3bb-844b3a8ecac6@free.fr>
Date:   Mon, 4 Nov 2019 09:57:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191104083438.8288-1-christophe.roullier@st.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP ; ns.iliad.fr ; Mon Nov  4 09:57:54 2019 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/11/2019 09:34, Christophe Roullier wrote:

> This patch fix the following warning:
> 
> warning: variable ‘ret’ set but not used [-Wunused-but-set-variable]
>   int val, ret;

FWIW, I believe the commit summary (i.e. the subject) should be as specific
as possible in the few characters allowed. In particular, it should mention
/what/ was changed.

Then the commit message would provide more information about /why/ it was
changed, and perhaps how it came to be discovered.

For example:

net: ethernet: stmmac: drop unused variable in stm32mp1_set_mode()

Building with W=1 (cf. scripts/Makefile.extrawarn) outputs:
warning: variable 'ret' set but not used [-Wunused-but-set-variable]

Drop the unused 'ret' variable.


>  drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
> index 4ef041bdf6a1..595af2ec89fb 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
> @@ -175,7 +175,7 @@ static int stm32mp1_set_mode(struct plat_stmmacenet_data *plat_dat)
>  {
>  	struct stm32_dwmac *dwmac = plat_dat->bsp_priv;
>  	u32 reg = dwmac->mode_reg;
> -	int val, ret;
> +	int val;
>  
>  	switch (plat_dat->interface) {
>  	case PHY_INTERFACE_MODE_MII:
> @@ -211,8 +211,8 @@ static int stm32mp1_set_mode(struct plat_stmmacenet_data *plat_dat)
>  	}
>  
>  	/* Need to update PMCCLRR (clear register) */
> -	ret = regmap_write(dwmac->regmap, reg + SYSCFG_PMCCLRR_OFFSET,
> -			   dwmac->ops->syscfg_eth_mask);
> +	regmap_write(dwmac->regmap, reg + SYSCFG_PMCCLRR_OFFSET,
> +		     dwmac->ops->syscfg_eth_mask);
>  
>  	/* Update PMCSETR (set register) */
>  	return regmap_update_bits(dwmac->regmap, reg,
