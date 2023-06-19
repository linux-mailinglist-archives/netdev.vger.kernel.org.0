Return-Path: <netdev+bounces-12027-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A96F9735BD5
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 18:01:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DAB811C209D0
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 16:01:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0F64134A4;
	Mon, 19 Jun 2023 16:01:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A494112B72
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 16:01:52 +0000 (UTC)
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 277091AB;
	Mon, 19 Jun 2023 09:01:51 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id ffacd0b85a97d-3112902f785so1959253f8f.0;
        Mon, 19 Jun 2023 09:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687190509; x=1689782509;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uJD2EOs6exRs0m2a44H2R0B97MWXn1m7YKJ0Z9sBgNM=;
        b=WQuCoocugx3fmp0Ea/4wX5LMW4NZ+C+1ppaJMUkHQq7IfkpLbQqnm0ubrSwgNr2Ptq
         /VH4Amg5/IvfvGbu/3lL1mQ3EG7HsZlQ3WGNNnsQcgHobwnJcnTVHn+lm12SjIAz0GtQ
         ZJXhwhx+UMZxUnPziIsRHknqqRVHYCXuwgZ324obPv+EERDyaY21LrX2Y1VPENyQqEAd
         sX9Lq1C9dhWa49E5lVPHwUDlvmikYWwphZ/hyadg3iyiLWly62YtmVHJ1jmgaM7Jpzc7
         ZGK0bzTkFXY16Cev55Ls+qmrgZq+hP84qkq16v9vw5FBx7XxMXq5sDn9gVTcvoTZNu0X
         LoIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687190509; x=1689782509;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uJD2EOs6exRs0m2a44H2R0B97MWXn1m7YKJ0Z9sBgNM=;
        b=Ba4x/gEm7MyAUVgySOY8Q8m8mCRg2cdZfUZFhXFGEIS0wtUtG4jXgSVvYtcXP1it30
         P3mWp8W9cfqWCL+lHmfIrl2D2WwSslKwDwPB3YJXitW/ohPRFbdDFiAzQXb08XXpMH0M
         jW30r0Cy8GPrzXg5qOa3G7D1OhIjO8/wf2FWOmJgT3bJnhy/06HC8fhjzhrT7I0lSG3O
         Rhf9z9qbvOgQRKng2WnRNlDlVceVBIfpcq6cdPb+uXc7U5iDh1PP3CYWNcawnSz6Ivpg
         6kRyAxO/rMi3Uc1ein40sOa9pM3mtf+mlqzBiGJEu6ZI1OcQr7//yS9RPnLWWWzrxisv
         TDJw==
X-Gm-Message-State: AC+VfDyHxYOCqyJ9SDVNPEFJAGr79nlqfUxccugoGPAKQs395kksaI4p
	JJl48fvOjk0DXniKeOnydAI=
X-Google-Smtp-Source: ACHHUZ6OwyeVd69BCRRWfW/lXxmw/UkeSoauK5rK2fQUo2Fhs9icgnc6kme44IJsMR1KWkPv0PZZvA==
X-Received: by 2002:a5d:50cb:0:b0:30f:d07f:5a3b with SMTP id f11-20020a5d50cb000000b0030fd07f5a3bmr13643796wrt.9.1687190509183;
        Mon, 19 Jun 2023 09:01:49 -0700 (PDT)
Received: from [10.178.67.29] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id o7-20020a5d6847000000b003113bd9ecaesm4227474wrw.116.2023.06.19.09.01.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 09:01:48 -0700 (PDT)
Message-ID: <09b8b985-7f52-86a6-6015-f522b80e2e4e@gmail.com>
Date: Mon, 19 Jun 2023 17:01:47 +0100
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH net v6 1/6] net: dsa: mt7530: set all CPU ports in
 MT7531_CPU_PMAP
Content-Language: en-US
To: arinc9.unal@gmail.com, =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?=
 <arinc.unal@arinc9.com>, Daniel Golle <daniel@makrotopia.org>,
 Landen Chao <Landen.Chao@mediatek.com>, DENG Qingfang <dqfext@gmail.com>,
 Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
 Vladimir Oltean <olteanv@gmail.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Russell King <linux@armlinux.org.uk>
Cc: Russell King <rmk+kernel@armlinux.org.uk>,
 Frank Wunderlich <frank-w@public-files.de>,
 Bartel Eerdekens <bartel.eerdekens@constell8.be>, mithat.guner@xeront.com,
 erkin.bozoglu@xeront.com, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org
References: <20230617062649.28444-1-arinc.unal@arinc9.com>
 <20230617062649.28444-2-arinc.unal@arinc9.com>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230617062649.28444-2-arinc.unal@arinc9.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 6/17/2023 7:26 AM, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> MT7531_CPU_PMAP represents the destination port mask for trapped-to-CPU
> frames (further restricted by PCR_MATRIX).
> 
> Currently the driver sets the first CPU port as the single port in this bit
> mask, which works fine regardless of whether the device tree defines port
> 5, 6 or 5+6 as CPU ports. This is because the logic coincides with DSA's
> logic of picking the first CPU port as the CPU port that all user ports are
> affine to, by default.
> 
> An upcoming change would like to influence DSA's selection of the default
> CPU port to no longer be the first one, and in that case, this logic needs
> adaptation.
> 
> Since there is no observed leakage or duplication of frames if all CPU
> ports are defined in this bit mask, simply include them all.
> 
> Suggested-by: Russell King (Oracle) <linux@armlinux.org.uk>
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
> Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

