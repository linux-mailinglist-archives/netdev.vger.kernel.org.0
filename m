Return-Path: <netdev+bounces-944-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB74A6FB6D2
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 21:41:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 966B9280FDE
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 19:41:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBAE6111A3;
	Mon,  8 May 2023 19:41:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8D8AD43
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 19:41:11 +0000 (UTC)
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF59D59DD
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 12:41:09 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-966400ee79aso383787066b.0
        for <netdev@vger.kernel.org>; Mon, 08 May 2023 12:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683574868; x=1686166868;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u6BHb4xVvMEfgN+9lRCelTqOTmzUYyfbAtctnb7HRBw=;
        b=CfsYd66/CQThuWNpAvqHi/MJfVOwNKqnCWFXJeAFfvAiraDwp4Jt5CBun22SMkPabl
         9dRNgNtAykAZuiW4gwbmcz0e/3iJjD34SxhtPshsDAwcYo2rxXe+GO9jALW/IXMeZz+B
         V1AfCxlclLF2SoyC3fQhoHmw9Ec5a0eya/S4PsSIVCb/RT7/e3U7hmpT4F8TvcsHqO40
         AsN+FQg9ezOn1IuuyjmcIx4QvNomc33QMqJ4D/Ucu6d8vRpfLfeulS8ZhB/sbhAwuQLT
         ik2Pzqjuxk7wSTwjyd9TMfq2D/iIPV/kFTKBU0uixzx6PGM6trE/eWWYfdHTjnsqnfhl
         hEfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683574868; x=1686166868;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u6BHb4xVvMEfgN+9lRCelTqOTmzUYyfbAtctnb7HRBw=;
        b=ldNWSH0HawAfOeobYO/g0bjw6dXshpRfBQegixyb1oVHeYtAg7EsrjRv5IoYImns/9
         nXiUDEqV4Rfd/HRByuCN8dC6yf5wD5NXYGnSr9ABg88R50mZ+BIVHdDF5MXaslf0KMLk
         xjgwYmFBg7ySjBKZPaSFSITcoV7x3V/G/j8U2vTUUc0D3vitk8VcUeLL+CiPdZEKnKUO
         8EbbDtqEW6pR31XJA56ki+DazEAfdcxZsz0xGtgNyr7Dcnw3vrtIqIEp02b4aVp2aggs
         Td8Bb+kTtaWjG99EdsX7rEOdfix45LqzkOeVgfeRqD1rjYZDD6Y81gI20HBO3AlC1soD
         hv9A==
X-Gm-Message-State: AC+VfDxGv78wL9LPYwtxWzt4LuG7nFzPlZZk1eh9dMO+Fi3/QLMsWdUj
	CIX73TadcNsZ59eDeh6oXzmAWg==
X-Google-Smtp-Source: ACHHUZ4UJvRAHo3YeIqDhqkX6D0qV+reh/JVVWha2vJ3gODEWTvlXChgbwidS5lcWcdtIEGMboCujA==
X-Received: by 2002:a17:907:7b91:b0:969:bac4:8e22 with SMTP id ne17-20020a1709077b9100b00969bac48e22mr785771ejc.26.1683574868376;
        Mon, 08 May 2023 12:41:08 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:d19b:4e0f:cfe4:a1ac? ([2a02:810d:15c0:828:d19b:4e0f:cfe4:a1ac])
        by smtp.gmail.com with ESMTPSA id la26-20020a170906ad9a00b00967a18df1easm352509ejb.117.2023.05.08.12.41.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 May 2023 12:41:07 -0700 (PDT)
Message-ID: <5cf04ce7-c60a-51c8-c835-58f24e7c8759@linaro.org>
Date: Mon, 8 May 2023 21:41:06 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] dt-bindings: mt76: support pointing to EEPROM using NVMEM
 cell
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
 Felix Fietkau <nbd@nbd.name>, Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee
 <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>,
 Sean Wang <sean.wang@mediatek.com>, Kalle Valo <kvalo@kernel.org>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org,
 =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
 Christian Marangi <ansuelsmth@gmail.com>
References: <20230508155820.9963-1-zajec5@gmail.com>
Content-Language: en-US
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230508155820.9963-1-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 08/05/2023 17:58, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> All kind of calibration data should be described as NVMEM cells of NVMEM
> devices. That is more generic solution than "mediatek,mtd-eeprom" which
> is MTD specific.
> 
> Add support for EEPROM NVMEM cells and deprecate existing MTD-based
> property.
> 
> Cc: Christian Marangi <ansuelsmth@gmail.com>
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>


Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof


