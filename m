Return-Path: <netdev+bounces-10222-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FBDB72D07A
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 22:33:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF32728102C
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 20:33:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 151D4A949;
	Mon, 12 Jun 2023 20:33:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09861522C
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 20:33:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F024E56
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 13:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686601981;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=43J77l2MjvOeufIj2deKwRG8u6kAZJyfknPdAW9w59s=;
	b=eBMuakVeMcC3eJgG5Srv803mdjUq+MiQNbICVR9CFATsN7bs5PiH8N9HBpWsW5Ptfjk0kU
	diXw7VK5JvY3PSuNcv2DYlAeYvLsr1QleXvhcPPE1UwUnJ2bD90YJaXiNx7nYE8HpbVUJH
	UG+ptB9jN0lWuhlsMfebI61vZusdmpc=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-169-SZ0dqoRyPHm5Id_JRWzDCg-1; Mon, 12 Jun 2023 16:33:00 -0400
X-MC-Unique: SZ0dqoRyPHm5Id_JRWzDCg-1
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-55551dfd39fso2549521eaf.3
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 13:33:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686601979; x=1689193979;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=43J77l2MjvOeufIj2deKwRG8u6kAZJyfknPdAW9w59s=;
        b=V4VPgGT8NOJvbquYIqc4D/SyRDsvtiGPHaHV2FWSTsK0D+3RPq6k9n8Sh7C94u10fy
         rwYA1YWK5b5DZ2DQRwIw9mvKOAMmD1zV1xjRZxZNl7ah/Z1OR5pgOVQn4PH+8wGnDht/
         2U4DofOmAuPKmewejvhUHRdD/KT8hqVL2UvQe64Z9OOVHxOalDW3MPjfphb4+WxxZPjz
         i7tkVitxvl5lGYvx/e/dG7RkBA1GrCs3GDKYXlx3SL2XSMFGbtBHM2YEnw/+FKa+43Bc
         Zvmn3UWKmlwiE6/5SROPZsv7p36yLPvtnHLtr9S8/p7xybrRK/fTrdyi/qIePOuMVryJ
         rPfg==
X-Gm-Message-State: AC+VfDy7Maa4IBay56eNpxlP4gdsKVGOUA1eokaQDn0+qqff765qJ4DQ
	h/GkxExBby/bpbG2QbmEvi01A96f/V6kfQ9N4meVMzBqP5RJG63hc7ixATU7S7O8aFHfAcneGAN
	8XpFp2SIEe4q45C5m
X-Received: by 2002:a4a:eac3:0:b0:558:b3f1:1081 with SMTP id s3-20020a4aeac3000000b00558b3f11081mr5365958ooh.9.1686601979256;
        Mon, 12 Jun 2023 13:32:59 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4vKyZqmPyAlZrIvh+fzGMNtvVVMAbuUA5odR16L7SaZeByU3UDtpAZGSfSXxbwRc/TkU6rpw==
X-Received: by 2002:a4a:eac3:0:b0:558:b3f1:1081 with SMTP id s3-20020a4aeac3000000b00558b3f11081mr5365934ooh.9.1686601978975;
        Mon, 12 Jun 2023 13:32:58 -0700 (PDT)
Received: from halaney-x13s ([2600:1700:1ff0:d0e0::45])
        by smtp.gmail.com with ESMTPSA id o4-20020a4aa804000000b0055affd1ca3csm3556530oom.1.2023.06.12.13.32.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 13:32:58 -0700 (PDT)
Date: Mon, 12 Jun 2023 15:32:55 -0500
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
Subject: Re: [PATCH 12/26] net: stmmac: dwmac-qcom-ethqos: add support for
 the optional serdes phy
Message-ID: <20230612203255.72t52ucry7zzq3em@halaney-x13s>
References: <20230612092355.87937-1-brgl@bgdev.pl>
 <20230612092355.87937-13-brgl@bgdev.pl>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612092355.87937-13-brgl@bgdev.pl>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 11:23:41AM +0200, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> On sa8775p platforms, there's a SGMII SerDes PHY between the MAC and
> external PHY that we need to enable and configure.
> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> ---
>  .../stmicro/stmmac/dwmac-qcom-ethqos.c        | 37 +++++++++++++++++++
>  1 file changed, 37 insertions(+)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
> index 8ed05f29fe8b..3438b6229351 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
> @@ -6,6 +6,7 @@
>  #include <linux/of_device.h>
>  #include <linux/platform_device.h>
>  #include <linux/phy.h>
> +#include <linux/phy/phy.h>
>  #include <linux/property.h>
>  
>  #include "stmmac.h"
> @@ -93,6 +94,7 @@ struct qcom_ethqos {
>  
>  	unsigned int rgmii_clk_rate;
>  	struct clk *rgmii_clk;
> +	struct phy *serdes_phy;
>  	unsigned int speed;
>  
>  	const struct ethqos_emac_por *por;
> @@ -566,6 +568,30 @@ static void ethqos_fix_mac_speed(void *priv, unsigned int speed)
>  	ethqos_configure(ethqos);
>  }
>  
> +static int qcom_ethqos_serdes_powerup(struct net_device *ndev, void *priv)
> +{
> +	struct qcom_ethqos *ethqos = priv;
> +	int ret;
> +
> +	ret = phy_set_speed(ethqos->serdes_phy, ethqos->speed);
> +	if (ret)
> +		return ret;
> +
> +	ret = phy_init(ethqos->serdes_phy);
> +	if (ret)
> +		return ret;
> +
> +	return phy_power_on(ethqos->serdes_phy);

The docs say (phy.rst):

    The general order of calls should be::

        [devm_][of_]phy_get()
        phy_init()
        phy_power_on()
        [phy_set_mode[_ext]()]
        ...
        phy_power_off()
        phy_exit()
        [[of_]phy_put()]

    Some PHY drivers may not implement :c:func:`phy_init` or :c:func:`phy_power_on`,
    but controllers should always call these functions to be compatible with other
    PHYs. Some PHYs may require :c:func:`phy_set_mode <phy_set_mode_ext>`, while
    others may use a default mode (typically configured via devicetree or other
    firmware). For compatibility, you should always call this function if you know
    what mode you will be using. Generally, this function should be called after
    :c:func:`phy_power_on`, although some PHY drivers may allow it at any time.

Not really dictating you need to do that order, but if possible I think
calling phy_set_speed after init + power_on is more generic. Not sure if
that plays nice with the phy driver in this series or not.

Otherwise, I think this looks good.

> +}
> +
> +static void qcom_ethqos_serdes_powerdown(struct net_device *ndev, void *priv)
> +{
> +	struct qcom_ethqos *ethqos = priv;
> +
> +	phy_power_off(ethqos->serdes_phy);
> +	phy_exit(ethqos->serdes_phy);
> +}
> +
>  static int ethqos_clks_config(void *priv, bool enabled)
>  {
>  	struct qcom_ethqos *ethqos = priv;
> @@ -651,6 +677,12 @@ static int qcom_ethqos_probe(struct platform_device *pdev)
>  	if (ret)
>  		goto out_config_dt;
>  
> +	ethqos->serdes_phy = devm_phy_optional_get(dev, "serdes");
> +	if (IS_ERR(ethqos->serdes_phy)) {
> +		ret = PTR_ERR(ethqos->serdes_phy);
> +		goto out_config_dt;
> +	}
> +
>  	ethqos->speed = SPEED_1000;
>  	ethqos_update_rgmii_clk(ethqos, SPEED_1000);
>  	ethqos_set_func_clk_en(ethqos);
> @@ -666,6 +698,11 @@ static int qcom_ethqos_probe(struct platform_device *pdev)
>  	if (of_device_is_compatible(np, "qcom,qcs404-ethqos"))
>  		plat_dat->rx_clk_runs_in_lpi = 1;
>  
> +	if (ethqos->serdes_phy) {
> +		plat_dat->serdes_powerup = qcom_ethqos_serdes_powerup;
> +		plat_dat->serdes_powerdown  = qcom_ethqos_serdes_powerdown;
> +	}
> +
>  	ret = stmmac_dvr_probe(dev, plat_dat, &stmmac_res);
>  	if (ret)
>  		goto out_config_dt;
> -- 
> 2.39.2
> 


