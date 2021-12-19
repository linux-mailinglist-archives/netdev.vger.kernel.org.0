Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9D647A299
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 23:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233706AbhLSWTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 17:19:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbhLSWTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Dec 2021 17:19:17 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24561C061574
        for <netdev@vger.kernel.org>; Sun, 19 Dec 2021 14:19:17 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id o19-20020a1c7513000000b0033a93202467so5480694wmc.2
        for <netdev@vger.kernel.org>; Sun, 19 Dec 2021 14:19:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=OfetaN1oK4DB/U6HvzgzORVqzNPE13qAR+Su9v4yLIA=;
        b=Rtyma0xXzw+apQ+qL0LfpwAyB6aMcWbVQ7UCE4YSmGyF5xhvd2m6R+r9pO8ucuZpZf
         CF0BG4991DLQ7T90r38ZWVr5BhHbYYlZFkZ58XdDqZswWRoBeWAyaHXVaHYPBIHwDRXD
         axZXJT3NKdItJwRNc8ZIjzNn4lQXdWj6UDQGUx4hThQ5gg85gRhY5ozFIfb4VRk+HcOt
         nd/VFI3g/MVwGiqDY7D1/5CMV8tXHDNjYKdHaeJp7DEYkbkWoJdfQnSz+4Moc62BtzDl
         hU5OZJFqah2RHBlUv3fnQbXlOXEgRHRAHYsBfNVD9iSSHb6sWpaJwBHhedZEegt4k4Um
         F/lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=OfetaN1oK4DB/U6HvzgzORVqzNPE13qAR+Su9v4yLIA=;
        b=LtPdu1wpS7T/GKgtu3DVxo4xhjtvHpm5N9XE4w+BBEh1LwfngFYGHvEqrjsydcKXCU
         0oZWTexTcX4gMg2Bxnj+7bA7sGkJgIwCCIao0Ql7GmIK6JNvFadzjHQg/Rh79UpdKKpi
         ZOeus39+c1UyVN2Sk983g/8yPjPhwgtYAtz50CdS2dtRdfqu0bUOStq+a4Ybwrp6Xppj
         G82f/VsBI0lWrgPKukVOYyZa7etJDJB0mtTNmkT26edPjUBi+7AtKb3xDtAIqy8RaiPS
         XXuH7DASiyvM5sdz0VRH9v5gm671SBNFIbGaplFrbrnXFwmMtcZqMxF32JqgpmspwZm2
         72Iw==
X-Gm-Message-State: AOAM5332CO7bgN+6Rto7lIJ0yenVqA/QdRJafmXA1YMXJjAWpw74gJ/x
        mH5nG65is4l85N/GAMQ2EWg=
X-Google-Smtp-Source: ABdhPJyI7tW2Mjs4oY2MDLQd1g31tkJgD98TZ/v2xwC3lM+DncQ+gtSqRZCGGrcB5gZ8IR+K+3Iffg==
X-Received: by 2002:a7b:c758:: with SMTP id w24mr11709643wmk.30.1639952355540;
        Sun, 19 Dec 2021 14:19:15 -0800 (PST)
Received: from skbuf ([188.26.56.205])
        by smtp.gmail.com with ESMTPSA id s22sm16912114wmc.1.2021.12.19.14.19.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Dec 2021 14:19:15 -0800 (PST)
Date:   Mon, 20 Dec 2021 00:19:13 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, linus.walleij@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        alsi@bang-olufsen.dk, arinc.unal@arinc9.com
Subject: Re: [PATCH net-next v2 11/13] net: dsa: realtek: rtl8365mb: use DSA
 CPU port
Message-ID: <20211219221913.c7hxslrvkj6cyrle@skbuf>
References: <20211216201342.25587-1-luizluca@gmail.com>
 <20211218081425.18722-1-luizluca@gmail.com>
 <20211218081425.18722-12-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211218081425.18722-12-luizluca@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 18, 2021 at 05:14:23AM -0300, Luiz Angelo Daros de Luca wrote:
> Instead of a fixed CPU port, assume that DSA is correct.
> 
> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> ---

I don't necessarily see the value added by this change. Since (I think)
only a single port can be a CPU port, a sanity check seems to be missing
that the CPU port in the device tree is the expected one. This seems to
be missing with or without your patch. You are unnaturally splitting the
initialization of a data structure between rtl8365mb_setup() and
rtl8365mb_detect(). Maybe what you should do is keep everything in
rtl8365mb_detect() where it is right now, and check in rtl8365mb_setup
that the cpu_dp->index is equal to priv->cpu_port?

>  drivers/net/dsa/realtek/rtl8365mb.c | 23 ++++++++++++++---------
>  1 file changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
> index a8f44538a87a..b79a4639b283 100644
> --- a/drivers/net/dsa/realtek/rtl8365mb.c
> +++ b/drivers/net/dsa/realtek/rtl8365mb.c
> @@ -103,14 +103,13 @@
>  
>  /* Chip-specific data and limits */
>  #define RTL8365MB_CHIP_ID_8365MB_VC		0x6367
> -#define RTL8365MB_CPU_PORT_NUM_8365MB_VC	6
>  #define RTL8365MB_LEARN_LIMIT_MAX_8365MB_VC	2112
>  
>  /* Family-specific data and limits */
>  #define RTL8365MB_PHYADDRMAX	7
>  #define RTL8365MB_NUM_PHYREGS	32
>  #define RTL8365MB_PHYREGMAX	(RTL8365MB_NUM_PHYREGS - 1)
> -#define RTL8365MB_MAX_NUM_PORTS	(RTL8365MB_CPU_PORT_NUM_8365MB_VC + 1)
> +#define RTL8365MB_MAX_NUM_PORTS  7
>  
>  /* Chip identification registers */
>  #define RTL8365MB_CHIP_ID_REG		0x1300
> @@ -1827,9 +1826,18 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
>  		dev_info(priv->dev, "no interrupt support\n");
>  
>  	/* Configure CPU tagging */
> -	ret = rtl8365mb_cpu_config(priv);
> -	if (ret)
> -		goto out_teardown_irq;
> +	for (i = 0; i < priv->num_ports; i++) {
> +		if (!(dsa_is_cpu_port(priv->ds, i)))
> +			continue;

dsa_switch_for_each_cpu_port(cpu_dp, ds)

> +		priv->cpu_port = i;
> +		mb->cpu.mask = BIT(priv->cpu_port);
> +		mb->cpu.trap_port = priv->cpu_port;
> +		ret = rtl8365mb_cpu_config(priv);
> +		if (ret)
> +			goto out_teardown_irq;
> +
> +		break;
> +	}
>  
>  	/* Configure ports */
>  	for (i = 0; i < priv->num_ports; i++) {
> @@ -1960,8 +1968,7 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
>  			 "found an RTL8365MB-VC switch (ver=0x%04x)\n",
>  			 chip_ver);
>  
> -		priv->cpu_port = RTL8365MB_CPU_PORT_NUM_8365MB_VC;
> -		priv->num_ports = priv->cpu_port + 1;
> +		priv->num_ports = RTL8365MB_MAX_NUM_PORTS;
>  
>  		mb->priv = priv;
>  		mb->chip_id = chip_id;
> @@ -1972,8 +1979,6 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
>  		mb->jam_size = ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc);
>  
>  		mb->cpu.enable = 1;
> -		mb->cpu.mask = BIT(priv->cpu_port);
> -		mb->cpu.trap_port = priv->cpu_port;
>  		mb->cpu.insert = RTL8365MB_CPU_INSERT_TO_ALL;
>  		mb->cpu.position = RTL8365MB_CPU_POS_AFTER_SA;
>  		mb->cpu.rx_length = RTL8365MB_CPU_RXLEN_64BYTES;
> -- 
> 2.34.0
> 
