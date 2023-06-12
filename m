Return-Path: <netdev+bounces-10224-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CADC172D0DD
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 22:45:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 936191C20B95
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 20:45:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B54BC8D5;
	Mon, 12 Jun 2023 20:45:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDC4538C
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 20:45:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36A9310DC
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 13:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686602576;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=a+9OvtK97veHl6+HegxVNiurUYmzQbeChvO9xmQ5r5g=;
	b=I0R+X/uZrLtGtzAyQYDm9VNqRRCGuGZZ6pawqilQTJyOrTv/2dbXcM8eBri/7jGELwHtkw
	ZKFJ72U/FaKu6P+VGZuRhrez1f22al6IBxVTPqgfV5l0nExYXCpoQSMpt2FBLfSt9ZVWxA
	lfqHIjRPiDtj6KEtI0fioEnWwlKRoI4=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-604-zXnjc-buMc6Cb2ozuWEsSA-1; Mon, 12 Jun 2023 16:42:55 -0400
X-MC-Unique: zXnjc-buMc6Cb2ozuWEsSA-1
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-568ae92e492so69644777b3.3
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 13:42:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686602575; x=1689194575;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a+9OvtK97veHl6+HegxVNiurUYmzQbeChvO9xmQ5r5g=;
        b=KV8jfegj6MYa9/I24vTQJmhW7S0oSdcj567lGm4SHju73D8ychSqPkeAiddy+xTxAI
         IcQcKMtE7SGvCGo9nwAkrmHvHF9/M28kMAiePIugrtLEz4k3avpZ1AWLCKUN3OSwu3E9
         /OJFkH4hNBIsYdnypg8T4malLlPrinYHhhFXAInHorGuiaX187fdFl+kpNicWx/tuvMc
         WO0R8jj0flzd23x3Le7fFZ5n/rvI+P8AH++ra6gd/o9ArRBNwi+M4qagS6KOHQ+O/W56
         2Kg2n6DfOwg/gSuIOX6D+ZXFMSCt9XanP6MppQbwDvS2g6VpuuId5TSw2OoY+sMu/hjV
         YNPg==
X-Gm-Message-State: AC+VfDxV8PVpRSnWBvOuryaDqjBQTxCAQSWQ/3tm9lVDowNooPKk0kRd
	qxSfn1YHhr9lD9+KVfwMSEhtNFTxHpXj3BDeCGpPKuR82O1o6YDMo1+pYYC0+k+pT+WnZH16gB1
	iVayek3NBL0/Yo4Bh
X-Received: by 2002:a81:7bc6:0:b0:56d:3372:71c7 with SMTP id w189-20020a817bc6000000b0056d337271c7mr2596018ywc.23.1686602575040;
        Mon, 12 Jun 2023 13:42:55 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5xUUOwVWCsyVOTXZeMW6GB/UM/A5jZuRMVvmYBzle/O+VHgBsWxsSIEBgDZ0wTd7/cMwI9Mg==
X-Received: by 2002:a81:7bc6:0:b0:56d:3372:71c7 with SMTP id w189-20020a817bc6000000b0056d337271c7mr2596001ywc.23.1686602574825;
        Mon, 12 Jun 2023 13:42:54 -0700 (PDT)
Received: from halaney-x13s ([2600:1700:1ff0:d0e0::45])
        by smtp.gmail.com with ESMTPSA id x186-20020a817cc3000000b00568cbb028c6sm2769484ywc.85.2023.06.12.13.42.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 13:42:54 -0700 (PDT)
Date: Mon, 12 Jun 2023 15:42:52 -0500
From: Andrew Halaney <ahalaney@redhat.com>
To: Bartosz Golaszewski <brgl@bgdev.pl>
Cc: Vinod Koul <vkoul@kernel.org>,
	Bhupesh Sharma <bhupesh.sharma@linaro.org>,
	Andy Gross <agross@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Kishon Vijay Abraham I <kishon@kernel.org>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-phy@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-stm32@st-md-mailman.stormreply.com,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: Re: [PATCH 14/26] net: stmmac: dwmac-qcom-ethqos: add optional
 phyaux clock
Message-ID: <20230612204252.kb57m72ehazt4bco@halaney-x13s>
References: <20230612092355.87937-1-brgl@bgdev.pl>
 <20230612092355.87937-15-brgl@bgdev.pl>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612092355.87937-15-brgl@bgdev.pl>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 11:23:43AM +0200, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> On sa8775p we don't use the RGMII clock but have an additional PHYAUX
> clock so add support for it to the driver.
> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> ---
>  .../ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c   | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
> index 252dca400071..2f6b9b419601 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
> @@ -94,6 +94,7 @@ struct qcom_ethqos {
>  
>  	unsigned int rgmii_clk_rate;
>  	struct clk *rgmii_clk;
> +	struct clk *phyaux_clk;
>  	struct phy *serdes_phy;
>  	unsigned int speed;
>  
> @@ -604,6 +605,13 @@ static int ethqos_clks_config(void *priv, bool enabled)
>  			return ret;
>  		}
>  
> +		ret = clk_prepare_enable(ethqos->phyaux_clk);
> +		if (ret) {
> +			clk_disable_unprepare(ethqos->rgmii_clk);
> +			dev_err(&ethqos->pdev->dev, "phyaux enable failed\n");
> +			return ret;
> +		}
> +
>  		/* Enable functional clock to prevent DMA reset to timeout due
>  		 * to lacking PHY clock after the hardware block has been power
>  		 * cycled. The actual configuration will be adjusted once
> @@ -611,6 +619,7 @@ static int ethqos_clks_config(void *priv, bool enabled)
>  		 */
>  		ethqos_set_func_clk_en(ethqos);
>  	} else {
> +		clk_disable_unprepare(ethqos->phyaux_clk);
>  		clk_disable_unprepare(ethqos->rgmii_clk);
>  	}
>  
> @@ -669,6 +678,12 @@ static int qcom_ethqos_probe(struct platform_device *pdev)
>  		goto out_config_dt;
>  	}
>  
> +	ethqos->phyaux_clk = devm_clk_get_optional(dev, "phyaux");
> +	if (IS_ERR(ethqos->phyaux_clk)) {
> +		ret = PTR_ERR(ethqos->phyaux_clk);
> +		goto out_config_dt;
> +	}
> +

Similar comment to the prior patch about whether or not this should be
optional (or selected via platform compatible and required),
otherwise looks good.

>  	ret = ethqos_clks_config(ethqos, true);
>  	if (ret)
>  		goto out_config_dt;
> -- 
> 2.39.2
> 


