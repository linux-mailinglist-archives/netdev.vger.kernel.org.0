Return-Path: <netdev+bounces-6296-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF262715950
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 11:03:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8124E281024
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 09:03:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B18F612B9C;
	Tue, 30 May 2023 09:03:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A618E125BA
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 09:03:38 +0000 (UTC)
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD840CD;
	Tue, 30 May 2023 02:03:36 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-96f850b32caso816943066b.3;
        Tue, 30 May 2023 02:03:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685437415; x=1688029415;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=d5bTC9ePIjeDHAn1QNvw27hbRPZAZpSBv6bbVVhO9e4=;
        b=p4Y6Rqn1ty2pcP5fz7B/SLQTYhEeCBYts56LJfdu8UXM8utM7zp8/JJxcV+uyB/VGV
         xACPmpZz2saVNBaKuhtFnemTrhSn4l/ZlBdoZQmeV6ls6AD+WCFqvxuxyjO8YJXZAjrA
         1Dy5660ee57yQCxHkQfCkuyldbbb1kh7ZE+XYbU4JNsIbcXbOzXF7N0428PLdtgF/rsX
         0FLKYXM4GAAoYeoEg0Z1lGJuDY3T3HGoFm8FiXffiEKnyqo0iSPYRYUDEfZ+QxsYdSHd
         gZQciYn3VNlB7EoOYLnFtxZap0xZ9GCfMDgCZJR4AP02ZGS5NclU7mRzfo7HsUJPhmyC
         SPNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685437415; x=1688029415;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d5bTC9ePIjeDHAn1QNvw27hbRPZAZpSBv6bbVVhO9e4=;
        b=IUOpTQ+Eu9y/47Nmjk1RpkyU26RteVgv3jNb/+Qu/iCxaSY+czl0/bAuhH53Z1IM7t
         hP9cYXhYfzQ+CRKjEx3Tc0qpdXCq2vUPDW2bw3b9kjnm+gaG0t+fbNOCh9Ru5GzwHm9b
         ungXa4mwrA1dvFYgyN4F53ylUv2Id9/ocym96pDhBzPVyK1rLGVWicFTdO+pSKV48MLo
         6s4YtoLBWBAdlb4xHVmQ0Yum+FgYQcFTSQ/YNjUdfmufwfdX6sv2W8sJ9C6K+HBbZuYL
         3v4ic3ElXPwXajE+gjD9BKl0ooXMJmVNEybOEReZ0dQkfxqf59avefj8cBMSkqjKKqFv
         DeUg==
X-Gm-Message-State: AC+VfDyX63BAGi2x/6X6Cd7lWbuS6SFytamiJS1Zl2utKVFiEQuFnvIi
	HIXRfegf3HeG3UujJ/1RnOc=
X-Google-Smtp-Source: ACHHUZ5eM13bNkgtMyUQfh/v9JyV4swJCaRbl42880atAhDY6QtfXwE+ufkW4PdjMflunlaHENOI4A==
X-Received: by 2002:a17:907:971e:b0:96b:4ed5:a1d8 with SMTP id jg30-20020a170907971e00b0096b4ed5a1d8mr1751323ejc.36.1685437414798;
        Tue, 30 May 2023 02:03:34 -0700 (PDT)
Received: from ?IPV6:2a01:c22:6f01:a200:d5f5:8fd7:7c5e:94b2? (dynamic-2a01-0c22-6f01-a200-d5f5-8fd7-7c5e-94b2.c22.pool.telefonica.de. [2a01:c22:6f01:a200:d5f5:8fd7:7c5e:94b2])
        by smtp.googlemail.com with ESMTPSA id u5-20020a17090626c500b0096f641a4c01sm7109593ejc.179.2023.05.30.02.03.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 May 2023 02:03:34 -0700 (PDT)
Message-ID: <81b74ddc-58dc-78e7-e647-8f90933d6a88@gmail.com>
Date: Tue, 30 May 2023 11:03:31 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH] net: Replace the ternary conditional operator with min()
To: Lu Hongfei <luhongfei@vivo.com>, Andrew Lunn <andrew@lunn.ch>,
 Russell King <linux@armlinux.org.uk>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "open list:ETHERNET PHY LIBRARY" <netdev@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>
Cc: opensource.kernel@vivo.com
References: <20230530084531.7354-1-luhongfei@vivo.com>
Content-Language: en-US
From: Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <20230530084531.7354-1-luhongfei@vivo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 30.05.2023 10:45, Lu Hongfei wrote:
> It would be better to replace the traditional ternary conditional
> operator with min()
> 
No. If you say something is better you should explain the benefit.

> Signed-off-by: Lu Hongfei <luhongfei@vivo.com>
> ---
>  drivers/net/phy/phy.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>  mode change 100644 => 100755 drivers/net/phy/phy.c
> 
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index 0c0df38cd1ab..a8beb4ab8451
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -1002,7 +1002,7 @@ static int phy_poll_aneg_done(struct phy_device *phydev)
>  	if (!ret)
>  		return -ETIMEDOUT;
>  
> -	return ret < 0 ? ret : 0;
> +	return min(ret, 0);

ret < 0 stands for is_err(ret), therefore an arithmetic operator isn't
appropriate here.

>  }
>  
>  int phy_ethtool_ksettings_set(struct phy_device *phydev,
> @@ -1526,7 +1526,7 @@ int phy_init_eee(struct phy_device *phydev, bool clk_stop_enable)
>  		ret = phy_set_bits_mmd(phydev, MDIO_MMD_PCS, MDIO_CTRL1,
>  				       MDIO_PCS_CTRL1_CLKSTOP_EN);
>  
> -	return ret < 0 ? ret : 0;
> +	return min(ret, 0);
>  }
>  EXPORT_SYMBOL(phy_init_eee);
>  


