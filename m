Return-Path: <netdev+bounces-5690-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22DBC71275A
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 15:17:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D24621C21059
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 13:17:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F7F818B14;
	Fri, 26 May 2023 13:17:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4434018B13
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 13:17:46 +0000 (UTC)
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 770EAB2;
	Fri, 26 May 2023 06:17:44 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-96f7bf3cf9eso138697766b.0;
        Fri, 26 May 2023 06:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685107063; x=1687699063;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sGqkPEwwAUavSeei9EN10EkpOiDwc0KPU98JvOkeGrg=;
        b=oRZs12wPYDV4ZHJF/NGbRuAA3DQsHTN2rPOmwlG1CakdIAm4fFKv1vDezhcIABhLEM
         ohp/IF6ZT7wftcQIwjZOdByfp84lhpPq+uQi6kEqGeIr1BMmfimLmQr1lFL6PR/YuFRF
         NuksyP51Yr6YDpLOGPyarUIQvMJhFFY5wJ88JSbLd8C6UnlQQFtLktAncD5vfWllTUXZ
         +t88BERHCrIa/t7QxHQgUvXT+31b9vG3K4HKKnPtEe00tJlFIe9rlBikFC0t2ysxB7as
         PTxRbahr9QfrisjHshRtTsooX8IH9+5Qcw37OX4CEgXSqf5KfIIN1a/4jfWxwQo8/V/b
         356w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685107063; x=1687699063;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sGqkPEwwAUavSeei9EN10EkpOiDwc0KPU98JvOkeGrg=;
        b=fw9J9tjRy0njJjPPzF+t78Uyyv4/Yw5Jn0u4tXu8q2+65B0XK0cD5SQQFxpojgRvLl
         PiG9N1QKMdsnutN3G6/pb3d5wGihHJ2va2Bc5szWnYbapVhEnEe9PX8x3q2YWTHAJBvS
         biFa2Bet92c+A2axt0jqkycnhrbVL0PBNxMgF06VRzYp/CuyA8hYU6yVyiiSgD9hdB/J
         BHWs0oq40gM1lqcWF24BppJFOgVSNoeZPNe9ithZKCuNfeFb34hCY9G3WXowSLn9x1VS
         DmohV4MxOV3PI+szdunS60nucObkXzEIsDbg4OFr4wZPTL0ELjZzU9h26B/UzNv2jb6+
         642Q==
X-Gm-Message-State: AC+VfDwJ8Ug9WFpDGnbOWyjlSeEU72RK/sGuAZxyJF7Fzr6afF7/0KO0
	Q6FAg5/tAa3V6fnrE5NQlds=
X-Google-Smtp-Source: ACHHUZ5L3LKf81sPQ1sp+T5rJCope7U7Ww9lPpw+UoLYYUsQolbeSqhC96HmdLhWRoMRFVYTrfanPA==
X-Received: by 2002:a17:907:9345:b0:956:fbd7:bc5e with SMTP id bv5-20020a170907934500b00956fbd7bc5emr2084037ejc.64.1685107062608;
        Fri, 26 May 2023 06:17:42 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id l13-20020a170906078d00b00968a2286749sm2168353ejc.77.2023.05.26.06.17.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 06:17:42 -0700 (PDT)
Date: Fri, 26 May 2023 16:17:39 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: arinc9.unal@gmail.com
Cc: Sean Wang <sean.wang@mediatek.com>,
	Landen Chao <Landen.Chao@mediatek.com>,
	DENG Qingfang <dqfext@gmail.com>,
	Daniel Golle <daniel@makrotopia.org>, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Russell King <linux@armlinux.org.uk>,
	=?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
	Richard van Schagen <richard@routerhints.com>,
	Richard van Schagen <vschagen@cs.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	erkin.bozoglu@xeront.com, mithat.guner@xeront.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net-next 16/30] net: dsa: mt7530: move lowering port 5
 RGMII driving to mt7530_setup()
Message-ID: <20230526131739.5mso5y2d3ieelasf@skbuf>
References: <20230522121532.86610-1-arinc.unal@arinc9.com>
 <20230522121532.86610-1-arinc.unal@arinc9.com>
 <20230522121532.86610-17-arinc.unal@arinc9.com>
 <20230522121532.86610-17-arinc.unal@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230522121532.86610-17-arinc.unal@arinc9.com>
 <20230522121532.86610-17-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 03:15:18PM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> Move lowering Tx driving of rgmii on port 5 to right before lowering of Tx
> driving of trgmii on port 6 on mt7530_setup().
> 
> This way, the switch should consume less power regardless of port 5 being
> used.
> 
> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---

This patch assumes that the MAC has its TXC ticking even when PMCR_TX_EN
is unset. Why would it do that?

>  drivers/net/dsa/mt7530.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index f2c1aa9cf7f7..514e82299537 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -933,10 +933,6 @@ static void mt7530_setup_port5(struct dsa_switch *ds, phy_interface_t interface)
>  		/* P5 RGMII TX Clock Control: delay x */
>  		mt7530_write(priv, MT7530_P5RGMIITXCR,
>  			     CSR_RGMII_TXC_CFG(0x10 + tx_delay));
> -
> -		/* reduce P5 RGMII Tx driving, 8mA */
> -		mt7530_write(priv, MT7530_IO_DRV_CR,
> -			     P5_IO_CLK_DRV(1) | P5_IO_DATA_DRV(1));
>  	}
>  
>  	mt7530_write(priv, MT7530_MHWTRAP, val);
> @@ -2209,6 +2205,10 @@ mt7530_setup(struct dsa_switch *ds)
>  
>  	mt7530_pll_setup(priv);
>  
> +	/* Lower P5 RGMII Tx driving, 8mA */
> +	mt7530_write(priv, MT7530_IO_DRV_CR,
> +			P5_IO_CLK_DRV(1) | P5_IO_DATA_DRV(1));

If you move code then preserve its alignment to the open parenthesis.

> +
>  	/* Lower Tx driving for TRGMII path */
>  	for (i = 0; i < NUM_TRGMII_CTRL; i++)
>  		mt7530_write(priv, MT7530_TRGMII_TD_ODT(i),
> -- 
> 2.39.2
> 


