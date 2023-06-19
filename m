Return-Path: <netdev+bounces-12028-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E345B735BD7
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 18:02:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73E00281174
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 16:02:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2D17134AF;
	Mon, 19 Jun 2023 16:02:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6BCD107A4
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 16:02:25 +0000 (UTC)
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7D11A6;
	Mon, 19 Jun 2023 09:02:24 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id ffacd0b85a97d-30fbf253dc7so2743781f8f.0;
        Mon, 19 Jun 2023 09:02:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687190543; x=1689782543;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QPYvtEbal0/0ATzmx2Jkvpt4Wfvv0Cqu85JCdehBcgU=;
        b=U9lp7PD9Mu4q85pcdWJO5V803YZkqlA0v869I7eVBXiqK5o5FtrfSZlk1MW+m7QGW1
         XMfQsbdn2moEmiY7vPQ/P1Oc5cwRuooO2zIsNw23h/vKf1FyfHL5p+0oGndYGBAIcMUn
         ycfZoVl9zZRp2sON1vWCBHdBivzCywKpL8XXihRdD8AZxWL7vcR81adpf9bJlDVrTgeL
         LDORyEYdVFjQCS0cZQkDPi+ZvFHwgACY1ks8KwFo+2+Mqd6m1QfYdQ26HwnobeRnT0Mp
         yzZsHT+1zqPFIn99SMasI2WCg9TbCVpV5ZJK3zDS3vckfdB1CEaicDr7+Ws3SYDhh3Ne
         lZRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687190543; x=1689782543;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QPYvtEbal0/0ATzmx2Jkvpt4Wfvv0Cqu85JCdehBcgU=;
        b=h4/hFmDcVMdI5L0TYy2OfxYbGJ7MpN37xe3YabWTcqWUoKK18fOTIQ7nyXM33juBhF
         ud6fzMz4NfXUM0XgbYIGv1pm6hF3NJ0Wnh91H/xVP7t9Iwc1YODN27QfslvcBFDpUC5Y
         +DYyuysNsXsHc+Y5J1VlMD9e38HLO4zVxWL1HzGVq7Oog7JHE9EYj6XVw1SOSC80fUuv
         G0pUrlUCvXx8W/fXny+Q+aPjSVwhK4XhHJv9YUEkF1PMwPkfq+eRkN4CIHkcyyNYuuwN
         oeP7ygqocNe7ctevyXx7pu/L581GiwyX31ZQSoJAlS50qxJQvQhw4iz6i48fQg6kciDA
         CyDg==
X-Gm-Message-State: AC+VfDzo9hxOfllr5aDpE/xdQhNBLD0fwFw8/oelTWUk5qE9MefM1n5u
	ItLIs0XhFc2ndeSBt/0XYNs=
X-Google-Smtp-Source: ACHHUZ7fdYBwU7OG+CUq0jam1eLepfBuXJpeRNQhTsxCU+YdgpmIJsEaQDd5b6MkQVOsBIKIO/z4sg==
X-Received: by 2002:a5d:5443:0:b0:30a:f60a:dc3c with SMTP id w3-20020a5d5443000000b0030af60adc3cmr13615098wrv.24.1687190542590;
        Mon, 19 Jun 2023 09:02:22 -0700 (PDT)
Received: from [10.178.67.29] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id l13-20020a1c790d000000b003f7ed463954sm80697wme.25.2023.06.19.09.02.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 09:02:21 -0700 (PDT)
Message-ID: <1073b497-4881-13f1-076c-57d7a63ddc0f@gmail.com>
Date: Mon, 19 Jun 2023 17:02:20 +0100
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH net v6 2/6] net: dsa: mt7530: fix trapping frames on
 non-MT7621 SoC MT7530 switch
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
Cc: Frank Wunderlich <frank-w@public-files.de>,
 Bartel Eerdekens <bartel.eerdekens@constell8.be>, mithat.guner@xeront.com,
 erkin.bozoglu@xeront.com, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org
References: <20230617062649.28444-1-arinc.unal@arinc9.com>
 <20230617062649.28444-3-arinc.unal@arinc9.com>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230617062649.28444-3-arinc.unal@arinc9.com>
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
> All MT7530 switch IP variants share the MT7530_MFC register, but the
> current driver only writes it for the switch variant that is integrated in
> the MT7621 SoC. Modify the code to include all MT7530 derivatives.
> 
> Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

