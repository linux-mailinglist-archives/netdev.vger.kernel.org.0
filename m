Return-Path: <netdev+bounces-1662-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD30F6FEB2D
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 07:29:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6149A2810EE
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 05:29:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75E1B1F187;
	Thu, 11 May 2023 05:29:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6131E1773B
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 05:29:28 +0000 (UTC)
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F0C5E42;
	Wed, 10 May 2023 22:29:26 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-96652cb7673so784018666b.0;
        Wed, 10 May 2023 22:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683782965; x=1686374965;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=y4x62um4Cta2MQq5bfpbv18O8tiAYzIjxL+XVu9krq4=;
        b=BqiVoaul5DML2AqPp+E7WU7ceWXoBHlpyTtNNIMKY0tZejHwgMHdmHVlp18lYeBX51
         KBZe5HxHrPy9UKGdt4UWv+n2tne9YlLrDJ5C6p95YeUtbLvugYgkp40MY+0s+JDC3wE/
         OvdwXJXCdPW9gwlBDIZ3TVVT8uCjLFaNLCzTtloaMWliMO9hACDK++fZU3+5zpVlfjwm
         QjZJtM3YPmpfMooM/Vu0VGelf9K6FaGDUvH/FFLodarhpj2TnnapceAplCOv0F2SpmE5
         GPz2i+zVGpP1mX4JJkZCQb2cFA0G22BhmFrbYijzyxVy9IOnoR7kQxHYrmJBo1z6pLEq
         QYqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683782965; x=1686374965;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y4x62um4Cta2MQq5bfpbv18O8tiAYzIjxL+XVu9krq4=;
        b=gDLAXHFwXllDHK5NBh0tDgd3FsS4BVc4DRnmH29sB1ANsPnB54svYHEPfGs30G/TGC
         aqpJfOxioVe9tigq2ydfQ+XdhTdvHZIiNmHJ9YQCBbNgz9AqYN8SEgnaByRSBW+mN/Gw
         r90fxe7YN1c264fcfeVchmWf5PSFbiUEMlptP5xt3VbVjyifRbJOle7bYAvAgjan4cp4
         QHZrVOf7s8hQcNXSK9JDvGErHXGklRnH1g7mBVnxcjuz3PRb+FKWsuhZGH4sJbtCXhQA
         /6iubpWSUCJeDml8QxU1FMDD1DNqyRnlFkBTmH8ATaWpNpVChy1VOlDydLHIGE7UYn3u
         IH0Q==
X-Gm-Message-State: AC+VfDwuyacd+TlCyU7HLgZONFYD7sKP2dRYKj6SpvvyfLb5drrGm9kW
	R1ljioDK3MoaWIFhloO3VG0=
X-Google-Smtp-Source: ACHHUZ7vvF+qW3TK0cuJqLdLw9Uk4jrATGpY2Ush2Z+Cvi9O0kUzQSGq/YHYtzqKPLGW6ubNDQbOlA==
X-Received: by 2002:a17:907:2684:b0:94e:75f8:668 with SMTP id bn4-20020a170907268400b0094e75f80668mr16593122ejc.56.1683782964468;
        Wed, 10 May 2023 22:29:24 -0700 (PDT)
Received: from ?IPV6:2a01:c23:c58e:b900:6079:61ec:4537:dead? (dynamic-2a01-0c23-c58e-b900-6079-61ec-4537-dead.c23.pool.telefonica.de. [2a01:c23:c58e:b900:6079:61ec:4537:dead])
        by smtp.googlemail.com with ESMTPSA id 13-20020a170906328d00b00969f44bbef1sm2875122ejw.89.2023.05.10.22.29.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 May 2023 22:29:24 -0700 (PDT)
Message-ID: <018df89a-c3d2-1bda-9966-7f06b24f87f2@gmail.com>
Date: Thu, 11 May 2023 07:29:21 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 0/8] Improvements for RealTek 2.5G Ethernet PHYs
To: Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
 linux-mediatek@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
 Russell King <linux@armlinux.org.uk>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
References: <cover.1683756691.git.daniel@makrotopia.org>
Content-Language: en-US
From: Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <cover.1683756691.git.daniel@makrotopia.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 11.05.2023 00:53, Daniel Golle wrote:
> Improve support for RealTek 2.5G Ethernet PHYs (RTL822x series).
> The PHYs can operate with Clause-22 and Clause-45 MDIO.
> 
> When using Clause-45 it is desireable to avoid rate-adapter mode and
> rather have the MAC interface mode follow the PHY speed. The PHYs
> support 2500Base-X for 2500M, and Cisco SGMII for 1000M/100M/10M.
> 
> Also prepare support for proprietary RealTek HiSGMII mode which will
> be needed for situations when used with RealTek switch or router SoCs
> such as RTL839x or RTL93xx.
> 
> Add support for Link Down Power Saving Mode (ALDPS) which is already
> supported for older RTL821x series 1GbE PHYs.
> 
> Make sure that link-partner advertised modes are only used if the
> advertisement can be considered valid. Otherwise we are seeing
> false-positives warning about downscaling eventhough higher speeds
> are not actually advertised by the link partner.
> 
> While at it, use helper function for paged operation and make sure
> to use use locking for that as well.
> 
> Changes since RFC:
>  * Turns out paged read used to identify the PHY needs to be hardcoded
>    for the simple reason that the function pointers for paged operations
>    have not yet been populated at this point. Hence keep open-coding it,
>    but use helper function and make sure it happening while the MDIO bus
>    mutex is locked.
> 
> Alexander Couzens (1):
>   net: phy: realtek: rtl8221: allow to configure SERDES mode
> 
> Chukun Pan (1):
>   net: phy: realtek: switch interface mode for RTL822x series
> 
> Daniel Golle (6):
>   net: phy: realtek: use genphy_soft_reset for 2.5G PHYs
>   net: phy: realtek: disable SGMII in-band AN for 2.5G PHYs
>   net: phy: realtek: make sure paged read is protected by mutex
>   net: phy: realtek: use inline functions for 10GbE advertisement
>   net: phy: realtek: check validity of 10GbE link-partner advertisement
>   net: phy: realtek: setup ALDPS on RTL8221B
> 
>  drivers/net/phy/realtek.c | 161 ++++++++++++++++++++++++++++++++------
>  1 file changed, 138 insertions(+), 23 deletions(-)
> 

Has this series been tested with RTL8125A/B to ensure that the internal
PHY use case still works?


