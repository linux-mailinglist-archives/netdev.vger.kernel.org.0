Return-Path: <netdev+bounces-7565-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 908067209CD
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 21:30:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1D48A1C21233
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 19:30:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFC681E526;
	Fri,  2 Jun 2023 19:30:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A057D17759
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 19:30:52 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA2BA18D
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 12:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685734241;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OwNNGdYDZf92GvG8rg3zuoha9IBbY1PdYh3TMHXOPzE=;
	b=d7NOB9CQkpiynioMUKrOn83Q8zOd7WEoqGTbYLydCEOwa9hHQiSnW9vCQULakoMsMX2HZU
	T0AKcZAwq+8hiazExC/mCp/XBVqK//AGl9LMhsIyiaLPw7MkTY/FXGYUljT0QyjWKT0PA4
	DuFUji5hmVfMVAjX+9aZXVyW/19nnSA=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-673-F9r3OA81POu_Cg31iPDFug-1; Fri, 02 Jun 2023 15:30:40 -0400
X-MC-Unique: F9r3OA81POu_Cg31iPDFug-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6287c8192a3so16784656d6.3
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 12:30:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685734240; x=1688326240;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OwNNGdYDZf92GvG8rg3zuoha9IBbY1PdYh3TMHXOPzE=;
        b=S/hwBN4rGggVSflW8O2lVXnUSDKrEbIZaHi4RQdvePE2beIXwRYNoops5UCbfAjoQh
         LRDa83ou05zpU4CpSo3Aw9Aho7zOIJO02MElFT/af9eFukcw5VDEgzM5LBY3YneDa7+Z
         AMPIJzjAMBzfJQXNfxPRADJevIcEJ7h98VeQ1peR1dT5zi9B1oPHrlkjgqCkka53kbCo
         kLALSb+YRDiMWPKB/EkfSh5gIF3ArxARahYfoln9ruy5CYy/7Qbw1nwXneHX4GxV1hSs
         CmscdWh8DCayQXp8yeg2+EfivRlk3PQkFrJvagHY5pIXJYrpnGT5cN3l8VNtf5BYe3at
         dpaA==
X-Gm-Message-State: AC+VfDz/ZOut7NCHwpiav+986G/UP1GWrjl2X59ElwcnCOJGbAZqL+5r
	rTjoO23B7jPVu+SLtAH3nlNCG69gsCa4Z4O5fmp+7sK4LGAYWJxIgvu9QmKJRbm/6Hw8TBPyEtq
	zlZmN+7j+uSOoIjmJ
X-Received: by 2002:ad4:5dcb:0:b0:628:27e7:4b79 with SMTP id m11-20020ad45dcb000000b0062827e74b79mr10273186qvh.53.1685734240015;
        Fri, 02 Jun 2023 12:30:40 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7Sr1+6gRslmMppKGQB5JsMabr1hATI2A1kYnsC6FNyaT/CHbjgvLHB0iUsF4aDN4N317Kc6A==
X-Received: by 2002:ad4:5dcb:0:b0:628:27e7:4b79 with SMTP id m11-20020ad45dcb000000b0062827e74b79mr10273165qvh.53.1685734239754;
        Fri, 02 Jun 2023 12:30:39 -0700 (PDT)
Received: from fedora ([2600:1700:1ff0:d0e0::c])
        by smtp.gmail.com with ESMTPSA id jh20-20020a0562141fd400b0062613dd9a00sm1197177qvb.52.2023.06.02.12.30.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jun 2023 12:30:39 -0700 (PDT)
Date: Fri, 2 Jun 2023 14:30:37 -0500
From: Andrew Halaney <ahalaney@redhat.com>
To: Bartosz Golaszewski <brgl@bgdev.pl>
Cc: Vinod Koul <vkoul@kernel.org>, 
	Bhupesh Sharma <bhupesh.sharma@linaro.org>, Giuseppe Cavallaro <peppe.cavallaro@st.com>, 
	Alexandre Torgue <alexandre.torgue@foss.st.com>, Jose Abreu <joabreu@synopsys.com>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, Jesse Brandeburg <jesse.brandeburg@intel.com>, 
	netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: Re: [PATCH net] net: stmmac: dwmac-qcom-ethqos: fix a regression on
 EMAC < 3
Message-ID: <ceg2ztzk3lzowssoydxwdq5pe3w7bgfbdpgalds3gwn5r2l5xb@bqufsqrqwlid>
References: <20230602190455.3123018-1-brgl@bgdev.pl>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602190455.3123018-1-brgl@bgdev.pl>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 02, 2023 at 09:04:55PM +0200, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> We must not assign plat_dat->dwmac4_addrs unconditionally as for
> structures which don't set them, this will result in the core driver
> using zeroes everywhere and breaking the driver for older HW. On EMAC < 2
> the address should remain NULL.
> 
> Fixes: b68376191c69 ("net: stmmac: dwmac-qcom-ethqos: Add EMAC3 support")
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

Reviewed-by: Andrew Halaney <ahalaney@redhat.com>

Thanks for the fix, sorry about that!

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
> -- 
> 2.39.2
> 


