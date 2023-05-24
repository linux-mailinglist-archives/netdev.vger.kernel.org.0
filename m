Return-Path: <netdev+bounces-5162-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B9D7670FD97
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 20:15:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 02BAD1C20D52
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 18:15:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E6432260C;
	Wed, 24 May 2023 18:15:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5191FE575
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 18:15:20 +0000 (UTC)
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B681BB;
	Wed, 24 May 2023 11:15:17 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-3f608074b50so14426525e9.0;
        Wed, 24 May 2023 11:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684952115; x=1687544115;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=87ZCxQxTbVlKyzkUBnd4j43LV2JM7FHJHvdF0cKFlQQ=;
        b=VbBXmu69uh2gs0RMb+R7/foz1uQKVq/j6oHNX547qBl9t+AzBFUP1CF0w/YXiQHoJJ
         29rLQkeoO83pZRz0t4dESuYe2Thpebmo7IM4DjpLzyB5HPMz5AIxtPghdpemrkKWB2UL
         yX2Mm5a0sZUVvSba4Dw103/TcQ3LEAY4bDD948jAt22q/QcJGp6zMhwg4OzqINO2y8t7
         j8xydeHTuE8QCj8guqMq1hLPS0O0bJctnoyHum4EGVY9l2eakOh4l3j489OdjdklKa27
         XFWba9CqLUvxG/qwUyK74Vu5ETED/2EQRQXR6hnS8nDctCZ99sX5JXIRfbjrj9xrzfwo
         4QyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684952115; x=1687544115;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=87ZCxQxTbVlKyzkUBnd4j43LV2JM7FHJHvdF0cKFlQQ=;
        b=io3bUCvfc+LkuFARn6HrOs3NiSrXdNIurdTC/F6BHkpmQjQ/JWdlzmydT+OAUztSsD
         vkzoMtByfq2BbI3mQzq9fr3KtCjVwf3X0WEzYKe2nwBw5Lqwhx39tmTfH2yp7zCcSBYh
         mwBRVzcmvaM3YwtlUzb3aDyIk/vD3N+Gu71rhlvEJjUxUt5RQO6XA8hg6oEhs1hgAhDs
         fzXAyR3PkbQ6N+DgFY1uxT24fRvo18/WgMN6+F0G1XkjblVvMcWPXUTmnCfTG832osEE
         UbLfikv7c4gCA2/Sz1eXIDNMaXj7tCHBtyepu3Hnmo16LlCS+7sIcDKotztTtvgV0/nC
         XLxg==
X-Gm-Message-State: AC+VfDxyfGC3Y1U/oNM2bC7DszHDUDo4RMsS68c6+NkffUYSvfY5AZoj
	C33v5nWeMZjgxq6GDy0uNp0=
X-Google-Smtp-Source: ACHHUZ7FS9+AodX+nKeevqNznXZks1d6+Nsqsfu7Ns9jz1kUkH/m3dvKLOkzaIyMguQB4V8lerzsWA==
X-Received: by 2002:a7b:cd14:0:b0:3f5:fff8:d4f3 with SMTP id f20-20020a7bcd14000000b003f5fff8d4f3mr541358wmj.7.1684952115423;
        Wed, 24 May 2023 11:15:15 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id 10-20020a05600c228a00b003f42461ac75sm3107977wmf.12.2023.05.24.11.15.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 11:15:15 -0700 (PDT)
Date: Wed, 24 May 2023 21:15:12 +0300
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
Subject: Re: [PATCH net-next 12/30] net: dsa: mt7530: move XTAL check to
 mt7530_setup()
Message-ID: <20230524181512.tmll4ijpijmc5fea@skbuf>
References: <20230522121532.86610-1-arinc.unal@arinc9.com>
 <20230522121532.86610-13-arinc.unal@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230522121532.86610-13-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 03:15:14PM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> The crystal frequency concerns the switch core. The frequency should be
> checked when the switch is being set up so the driver can reject the
> unsupported hardware earlier and without requiring port 6 to be used.
> 
> Move it to mt7530_setup().
> 
> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---

Do you know why a crystal frequency of 20 MHz is not supported?

>  drivers/net/dsa/mt7530.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index 049f7be0d790..fa48273269c4 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -408,13 +408,6 @@ mt7530_setup_port6(struct dsa_switch *ds, phy_interface_t interface)
>  
>  	xtal = mt7530_read(priv, MT7530_HWTRAP) & HWTRAP_XTAL_MASK;
>  
> -	if (xtal == HWTRAP_XTAL_20MHZ) {
> -		dev_err(priv->dev,
> -			"%s: MT7530 with a 20MHz XTAL is not supported!\n",
> -			__func__);
> -		return -EINVAL;
> -	}
> -
>  	switch (interface) {
>  	case PHY_INTERFACE_MODE_RGMII:
>  		trgint = 0;
> @@ -2133,7 +2126,7 @@ mt7530_setup(struct dsa_switch *ds)
>  	struct mt7530_dummy_poll p;
>  	phy_interface_t interface;
>  	struct dsa_port *cpu_dp;
> -	u32 id, val;
> +	u32 id, val, xtal;
>  	int ret, i;
>  
>  	/* The parent node of master netdev which holds the common system
> @@ -2203,6 +2196,15 @@ mt7530_setup(struct dsa_switch *ds)
>  		return -ENODEV;
>  	}
>  
> +	xtal = mt7530_read(priv, MT7530_HWTRAP) & HWTRAP_XTAL_MASK;
> +
> +	if (xtal == HWTRAP_XTAL_20MHZ) {
> +		dev_err(priv->dev,
> +			"%s: MT7530 with a 20MHz XTAL is not supported!\n",
> +			__func__);

I don't think __func__ brings much value here, it could be dropped in
the process of moving the code.

Also, the HWTRAP register is already read once, here (stored in "val"):

	INIT_MT7530_DUMMY_POLL(&p, priv, MT7530_HWTRAP);
	ret = readx_poll_timeout(_mt7530_read, &p, val, val != 0,
				 20, 1000000);

I wonder if we really need to read it twice.

> +		return -EINVAL;
> +	}
> +
>  	/* Reset the switch through internal reset */
>  	mt7530_write(priv, MT7530_SYS_CTRL,
>  		     SYS_CTRL_PHY_RST | SYS_CTRL_SW_RST |
> -- 
> 2.39.2
> 

