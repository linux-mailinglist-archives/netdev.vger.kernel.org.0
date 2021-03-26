Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEAD34A5E7
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 11:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbhCZKzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 06:55:38 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:28806 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbhCZKzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 06:55:18 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20210326105517euoutp01acf77f9891c11b4b55f046e17d7fff4d~v3x9fnanh2866728667euoutp01G
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 10:55:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20210326105517euoutp01acf77f9891c11b4b55f046e17d7fff4d~v3x9fnanh2866728667euoutp01G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1616756117;
        bh=Xtwf49mqaqF0GQyI7kUgfs9/22bvHQyxUcCKXilKpw8=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=JRKW5fr56Q9eRhTsK3nzwBnlMAWkHHOUr/AWRhm82WJi3vSZhaB7QCBSZrAKTSJAE
         uLggpG1PQf6b06v4OIhp5aBNiT9MdaYhLXSNEROObK5yRI7u9SD8HmxflWXAeJmRX1
         AtHnt5NuTYrV2f2A1YO0pli2q6tpeZkNKRxd2/zI=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210326105516eucas1p222e957e784ec9b47d4c38d49ec5664a8~v3x85wt5p1157711577eucas1p2X;
        Fri, 26 Mar 2021 10:55:16 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id E7.9F.09444.49DBD506; Fri, 26
        Mar 2021 10:55:16 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210326105515eucas1p1e23f34db376a7b5c05d8b182c3372425~v3x8YcbKF2563525635eucas1p1I;
        Fri, 26 Mar 2021 10:55:15 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210326105515eusmtrp2b32f54896f16b44e5970d9bf1144d4d2~v3x8XTAPd2103221032eusmtrp2L;
        Fri, 26 Mar 2021 10:55:15 +0000 (GMT)
X-AuditID: cbfec7f4-dbdff700000024e4-8b-605dbd94c01e
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 62.E7.08696.39DBD506; Fri, 26
        Mar 2021 10:55:15 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210326105514eusmtip2335fd8fb6526977a24d2efac57bad1f4~v3x7cLnMp1960419604eusmtip2f;
        Fri, 26 Mar 2021 10:55:14 +0000 (GMT)
Subject: Re: [PATCH net-next] net: stmmac: Fix kernel panic due to NULL
 pointer dereference of fpe_cfg
To:     mohammad.athari.ismail@intel.com,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>, vee.khee.wong@intel.com,
        Tan Tee Min <tee.min.tan@intel.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <31b97d50-d187-c3a8-59bf-140d8c7990e5@samsung.com>
Date:   Fri, 26 Mar 2021 11:55:14 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0)
        Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210326091046.26391-1-mohammad.athari.ismail@intel.com>
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sa0xTZxjOdy49h5Kyj0LXL2VsSRemU0Fq9uMkMtRsbIfsBv7Y5gWh6BEI
        UFkrw+0PnXVEzxSJsFArOCJDkdkJtRQQilIVYslQYHJp6gpbxwSpSHB42UbH4cjGv+ea932T
        l8blv5IqOke3n9PrtHlqiZRwdD+9FVvhTMuIrw8omCZ/L2D8F89ImKpbhwjmlzMPSOa2o5Rk
        bL8Nkczg5SoJww/5Scb1rRMwp/+xLiLXDMZ017zIBO83AyZ4yEgwp8acEqbuupnaDNnBoX6c
        tZ8fxdg2y12Kre2YxFhbwxEJe+n7YrarU8P+/sS5GLgyB9g528sp0u3ShD1cXs7nnH59YoY0
        2+1qlhTUrjsw036PMgJrDA9CaATfQN2dQZwHUloO6wF6MlZJiOQRQO7W66RI5gB62uQjlyv+
        8seYaJwDaNLkfV6ZBahjuAkIqQiYjZyP54FgRMIeDDVP+JYqOKzBEN/wNSakJFCD+AAv4QFN
        y2AiGi3bLcgEjEEnZisoQVbATNToShNkGQxHN0/6CQGHwHfQpXtzuIBx+ApqCVQ9x0rk8X+3
        NArB9hD0rKmdENd+G7V0H8ZEHIGmeuyUiF9Cwbblggmg8T4rJZKjAA0eNAMxtRF5+54tLYrD
        19HFy+tFeQu6Vm8lBRnBMDQSCBeXCEMnHJW4KMvQ4RK5mH4NWXp+/G9s1+0BvAyoLStOs6w4
        x7LiHMv/c2sA0QCUXKEhP4szbNBxRXEGbb6hUJcVt3tfvg0svmHvQs+jVnBuajbOBTAauACi
        cXWkLPODnRly2R7tF19y+n3p+sI8zuACUTShVsoy7RfS5TBLu5/L5bgCTr/sYnSIyoilEpO5
        ORHv4cNvSjXO0rNHjlU79BXKG811UcZNCemqbdUPfrafcpseRm38y+gNTCYv/NFfUuRO/fO4
        2zbmGcB3dCbZdxUvBFtM/Pl3379T56J80+beG6+mX+gf/Xt6XqvyxU+E7Z0vKNeNX/3B9uHq
        6Nw70d5QtWNqbWUkm+oZO9j6U9I1RUdRubnVW518/5OicdN2D/nZw/CjUfU7zqbl8yPJH8k0
        XdZt0zu18b6rby0cmGg5vXai1j+zqm3L/KcJnRu+UWymS8q+mjKWDW8i2l/ISukjvVe2HktS
        fnzSljxOHaeiQ1UjiTF3PatnB4pNobHhitjGysa2UjOdsiZlpkFNGLK1mjW43qD9F6Sudf71
        AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t/xe7qT98YmGCxZaGix8clpRosn6xex
        Wcw538JicW/RO1aLC9v6WC02Pb7GanF51xw2i65rT1gtDk3dy2gx7+9aIOvQeyaLYwvELP6/
        3spo8b+lgcVi9oO9bBZLj8xgdxDwuHztIrPHlpU3mTx2zrrL7rF4z0smj02rOtk8Ni+p9zi4
        z9Dj6Y+9QAX7PzN6fN4kF8AVpWdTlF9akqqQkV9cYqsUbWhhpGdoaaFnZGKpZ2hsHmtlZKqk
        b2eTkpqTWZZapG+XoJdx6tBWtoLFOhXvd79gb2Bcq9rFyMkhIWAi8WTyd6YuRi4OIYGljBIP
        pqxnhEjISJyc1sAKYQtL/LnWxQZR9J5RYlXnSbAiYYEMib3fvzGCJEQETjJJrJ2xhR0kwSyw
        gEmit8kFomMmo8SeJVfAEmwChhJdb0FGcXDwCthJ3JyQDBJmEVCVmPRxCliJqECSxOUlE8E2
        8woISpyc+YQFxOYUcJPY/OIzM8R8M4l5mx9C2fIS29/OgbLFJW49mc80gVFoFpL2WUhaZiFp
        mYWkZQEjyypGkdTS4tz03GIjveLE3OLSvHS95PzcTYzA6N927OeWHYwrX33UO8TIxMF4iFGC
        g1lJhDfJNyZBiDclsbIqtSg/vqg0J7X4EKMp0D8TmaVEk/OB6SevJN7QzMDU0MTM0sDU0sxY
        SZzX5MiaeCGB9MSS1OzU1ILUIpg+Jg5OqQYmzmDXG+KLT5UY2j41CPCtOXpg6oaSxP8qT9Z/
        3b62rCXu/ppE1tZHORta/5v0RZWwGD5Ytf/Vv9h3T08tiJl8/nn9Fv/sr4xzvTokI5iz0tfm
        ljv4NP55uOqdDcvZ718VODbd2BbSYsd56vWFpI76u2kZu4861bXNO/St36np6JujHL0eX409
        VlScl3U1DhJynH7x+p6nS42519mp2tnqWJSuTuF1f5H0W84/6qjmRfuCHrec1bsMdy3e9EZ5
        guzpUM8P63Yvk/v0T/xg+cbwHbKis/YfdN44083i7TG1l8f7skwcphVazA/sNT3xc6Jb3ZRi
        vTb/gIC3josPfFzOp8htf/Ngy7mVtkHXPjgaKbEUZyQaajEXFScCAF5we2qHAwAA
X-CMS-MailID: 20210326105515eucas1p1e23f34db376a7b5c05d8b182c3372425
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20210326091110eucas1p1626ecb9b89c282bdbc6fe9b6ed966932
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210326091110eucas1p1626ecb9b89c282bdbc6fe9b6ed966932
References: <CGME20210326091110eucas1p1626ecb9b89c282bdbc6fe9b6ed966932@eucas1p1.samsung.com>
        <20210326091046.26391-1-mohammad.athari.ismail@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.03.2021 10:10, mohammad.athari.ismail@intel.com wrote:
> From: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
>
> In this patch, "net: stmmac: support FPE link partner hand-shaking
> procedure", priv->plat->fpe_cfg wouldn`t be "devm_kzalloc"ed if
> dma_cap->frpsel is 0 (Flexible Rx Parser is not supported in SoC) in
> tc_init(). So, fpe_cfg will be remain as NULL and accessing it will cause
> kernel panic.
>
> To fix this, move the "devm_kzalloc"ing of priv->plat->fpe_cfg before
> dma_cap->frpsel checking in tc_init(). Additionally, checking of
> priv->dma_cap.fpesel is added before calling stmmac_fpe_link_state_handle()
> as only FPE supported SoC is allowed to call the function.
>
> Below is the kernel panic dump reported by Marek Szyprowski
> <m.szyprowski@samsung.com>:
>
> meson8b-dwmac ff3f0000.ethernet eth0: PHY [0.0:00] driver [RTL8211F Gigabit Ethernet] (irq=35)
> meson8b-dwmac ff3f0000.ethernet eth0: No Safety Features support found
> meson8b-dwmac ff3f0000.ethernet eth0: PTP not supported by HW
> meson8b-dwmac ff3f0000.ethernet eth0: configuring for phy/rgmii link mode
> Unable to handle kernel NULL pointer dereference at virtual address 0000000000000001
> Mem abort info:
> ...
> user pgtable: 4k pages, 48-bit VAs, pgdp=00000000044eb000
> [0000000000000001] pgd=0000000000000000, p4d=0000000000000000
> Internal error: Oops: 96000004 [#1] PREEMPT SMP
> Modules linked in: dw_hdmi_i2s_audio dw_hdmi_cec meson_gxl realtek meson_gxbb_wdt snd_soc_meson_axg_sound_card dwmac_generic axg_audio meson_dw_hdmi crct10dif_ce snd_soc_meson_card_utils snd_soc_meson_axg_tdmout panfrost rc_odroid gpu_sched reset_meson_audio_arb meson_ir snd_soc_meson_g12a_tohdmitx snd_soc_meson_axg_frddr sclk_div clk_phase snd_soc_meson_codec_glue dwmac_meson8b snd_soc_meson_axg_fifo stmmac_platform meson_rng meson_drm stmmac rtc_meson_vrtc rng_core meson_canvas pwm_meson dw_hdmi mdio_mux_meson_g12a pcs_xpcs snd_soc_meson_axg_tdm_interface snd_soc_meson_axg_tdm_formatter nvmem_meson_efuse display_connector
> CPU: 1 PID: 7 Comm: kworker/u8:0 Not tainted 5.12.0-rc4-next-20210325+
> Hardware name: Hardkernel ODROID-C4 (DT)
> Workqueue: events_power_efficient phylink_resolve
> pstate: 20400009 (nzCv daif +PAN -UAO -TCO BTYPE=--)
> pc : stmmac_mac_link_up+0x14c/0x348 [stmmac]
> lr : stmmac_mac_link_up+0x284/0x348 [stmmac] ...
> Call trace:
>   stmmac_mac_link_up+0x14c/0x348 [stmmac]
>   phylink_resolve+0x104/0x420
>   process_one_work+0x2a8/0x718
>   worker_thread+0x48/0x460
>   kthread+0x134/0x160
>   ret_from_fork+0x10/0x18
> Code: b971ba60 350007c0 f958c260 f9402000 (39400401)
> ---[ end trace 0c9deb6c510228aa ]---
>
> Fixes: 5a5586112b92 ("net: stmmac: support FPE link partner hand-shaking
> procedure")
> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>

This fixes my issue. Thanks!

Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   .../net/ethernet/stmicro/stmmac/stmmac_main.c |  6 ++++--
>   .../net/ethernet/stmicro/stmmac/stmmac_tc.c   | 20 +++++++++----------
>   2 files changed, 14 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index 170296820af0..27faf5e49360 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -997,7 +997,8 @@ static void stmmac_mac_link_down(struct phylink_config *config,
>   	stmmac_eee_init(priv);
>   	stmmac_set_eee_pls(priv, priv->hw, false);
>   
> -	stmmac_fpe_link_state_handle(priv, false);
> +	if (priv->dma_cap.fpesel)
> +		stmmac_fpe_link_state_handle(priv, false);
>   }
>   
>   static void stmmac_mac_link_up(struct phylink_config *config,
> @@ -1097,7 +1098,8 @@ static void stmmac_mac_link_up(struct phylink_config *config,
>   		stmmac_set_eee_pls(priv, priv->hw, true);
>   	}
>   
> -	stmmac_fpe_link_state_handle(priv, true);
> +	if (priv->dma_cap.fpesel)
> +		stmmac_fpe_link_state_handle(priv, true);
>   }
>   
>   static const struct phylink_mac_ops stmmac_phylink_mac_ops = {
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
> index 1d84ee359808..4e70efc45458 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
> @@ -254,6 +254,16 @@ static int tc_init(struct stmmac_priv *priv)
>   			 priv->flow_entries_max);
>   	}
>   
> +	if (!priv->plat->fpe_cfg) {
> +		priv->plat->fpe_cfg = devm_kzalloc(priv->device,
> +						   sizeof(*priv->plat->fpe_cfg),
> +						   GFP_KERNEL);
> +		if (!priv->plat->fpe_cfg)
> +			return -ENOMEM;
> +	} else {
> +		memset(priv->plat->fpe_cfg, 0, sizeof(*priv->plat->fpe_cfg));
> +	}
> +
>   	/* Fail silently as we can still use remaining features, e.g. CBS */
>   	if (!dma_cap->frpsel)
>   		return 0;
> @@ -298,16 +308,6 @@ static int tc_init(struct stmmac_priv *priv)
>   	dev_info(priv->device, "Enabling HW TC (entries=%d, max_off=%d)\n",
>   			priv->tc_entries_max, priv->tc_off_max);
>   
> -	if (!priv->plat->fpe_cfg) {
> -		priv->plat->fpe_cfg = devm_kzalloc(priv->device,
> -						   sizeof(*priv->plat->fpe_cfg),
> -						   GFP_KERNEL);
> -		if (!priv->plat->fpe_cfg)
> -			return -ENOMEM;
> -	} else {
> -		memset(priv->plat->fpe_cfg, 0, sizeof(*priv->plat->fpe_cfg));
> -	}
> -
>   	return 0;
>   }
>   

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

