Return-Path: <netdev+bounces-7628-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 45FA4720E1D
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 08:31:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C20021C212BE
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 06:31:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF388156F1;
	Sat,  3 Jun 2023 06:31:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A452A24E97
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 06:31:08 +0000 (UTC)
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A25E5A;
	Fri,  2 Jun 2023 23:31:03 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
	by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 3536UZFb041869;
	Sat, 3 Jun 2023 01:30:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1685773835;
	bh=ISHvgcwYKUrLcIU7PQXGJdRhfqIZfS1CSg2P3P+bGN4=;
	h=Date:CC:Subject:To:References:From:In-Reply-To;
	b=fQ82EM8ePo5cOzLzMPXzXxWPxRzb6TxB//IF0o14hkChrkJ9Helt4K4M9DI/7mxQj
	 nBrkjrRM+mMcUOrGT/RRZKuPa0V1HGPny64R3ePa9nDgQGyHBUomgOGU8h1ryzk9tC
	 USHDWsH9F16jHDr3G4ZTMvLHAuFhzqarifVbRkIg=
Received: from DFLE101.ent.ti.com (dfle101.ent.ti.com [10.64.6.22])
	by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 3536UZ9U017373
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sat, 3 Jun 2023 01:30:35 -0500
Received: from DFLE106.ent.ti.com (10.64.6.27) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Sat, 3
 Jun 2023 01:30:34 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Sat, 3 Jun 2023 01:30:35 -0500
Received: from [10.249.131.186] (ileaxei01-snat.itg.ti.com [10.180.69.5])
	by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 3536UJu4023813;
	Sat, 3 Jun 2023 01:30:19 -0500
Message-ID: <5fef1d49-19f7-884d-68dd-668bd23251e6@ti.com>
Date: Sat, 3 Jun 2023 12:00:17 +0530
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
CC: <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        <s-vadapalli@ti.com>
Subject: Re: [PATCH net] net: stmmac: dwmac-qcom-ethqos: fix a regression on
 EMAC < 3
Content-Language: en-US
To: Bartosz Golaszewski <brgl@bgdev.pl>, Vinod Koul <vkoul@kernel.org>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        Giuseppe Cavallaro
	<peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo
 Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Andrew Halaney <ahalaney@redhat.com>,
        Jesse Brandeburg
	<jesse.brandeburg@intel.com>
References: <20230602190455.3123018-1-brgl@bgdev.pl>
From: Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <20230602190455.3123018-1-brgl@bgdev.pl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 03-06-2023 00:34, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> We must not assign plat_dat->dwmac4_addrs unconditionally as for
> structures which don't set them, this will result in the core driver
> using zeroes everywhere and breaking the driver for older HW. On EMAC < 2
> the address should remain NULL.
> 
> Fixes: b68376191c69 ("net: stmmac: dwmac-qcom-ethqos: Add EMAC3 support")
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

Reviewed-by: Siddharth Vadapalli <s-vadapalli@ti.com>

> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
> index 16a8c361283b..f07905f00f98 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
> @@ -644,7 +644,8 @@ static int qcom_ethqos_probe(struct platform_device *pdev)
>  	plat_dat->fix_mac_speed = ethqos_fix_mac_speed;
>  	plat_dat->dump_debug_regs = rgmii_dump;
>  	plat_dat->has_gmac4 = 1;
> -	plat_dat->dwmac4_addrs = &data->dwmac4_addrs;
> +	if (ethqos->has_emac3)
> +		plat_dat->dwmac4_addrs = &data->dwmac4_addrs;
>  	plat_dat->pmt = 1;
>  	plat_dat->tso_en = of_property_read_bool(np, "snps,tso");
>  	if (of_device_is_compatible(np, "qcom,qcs404-ethqos"))

-- 
Regards,
Siddharth.

