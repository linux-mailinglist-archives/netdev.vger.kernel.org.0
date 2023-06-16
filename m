Return-Path: <netdev+bounces-11392-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4844D732E2E
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 12:30:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0460A28173E
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:30:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A3EE79D4;
	Fri, 16 Jun 2023 10:30:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E39D19916
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 10:30:18 +0000 (UTC)
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF866A48;
	Fri, 16 Jun 2023 03:29:58 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-970028cfb6cso80162466b.1;
        Fri, 16 Jun 2023 03:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686911355; x=1689503355;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JWoW5IL6r7jB721BuhFKxOW5Wap3W5wMhPHSM+uYSlI=;
        b=NkC/a6D+pzeIeQuTBTiX5xSElWEB8z2ovO+3YuyHCVT5teyTCpxx0pkFKeFCbLIiRR
         BVfuiAmZcooipvYO5H1LGB7QH2Aqnh43eeihivIkkVtYSr2mtmFmxsPprSEBDKcflbvX
         4QIzuCuPibmBAflnx8nerreiQMDow0MQEcBAcanloz9R61w0buRJvmt0YRlI/oz86kdz
         FLxtRlwRPpnwm89ZUNzwEyQ/WRMh7AG+Fqf4QZB1MraPbqYhf4BTin4Hrq1OH2sD2cmU
         Bfskg9TdvtnFbb3hZlF1pbTZuDA40xQbPIsMmLZKOUnXwE73e2r9qNkH9bSybCbgAarA
         RyoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686911355; x=1689503355;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JWoW5IL6r7jB721BuhFKxOW5Wap3W5wMhPHSM+uYSlI=;
        b=K8q0Yb4WQ1T0nGECp7tbkRLyT9ZTLHcHLixlQ5iuJQ0fiScaXpt8ZY39MS+RL77kpN
         uWrEipAZesQjSpKN0URpqDjZBeJUYk/HXQLJtXvQMgLHUrZ/0hjMB7+AS53F7QEK6EJo
         x4YQc+ibF83qTZs5YRcBxyTZdNbYwroCtV/gTtzbrsoYHilyk/bgDL3wggXEsboA3N/I
         ehsKW3RD5ECV+s2nx6obrJkEAKv5SRVoMsvUaqcdRsDyvJ5f+iP2Bofxofr/2IenEoG/
         bniv/GOTzKvP+ddo2ZzFSILjuUozbNc352kz8EAiHahbEix0Dk36ERzlMprQHWe4h5l+
         Isbw==
X-Gm-Message-State: AC+VfDyCWQnmIwpoenrM2CH6Y6lsfJK7BlLhh+HAOT0mWOpzgGxCOnY8
	5j8iMs7YlbcfbRNuhK9oIc+JQgdUIKdPaA==
X-Google-Smtp-Source: ACHHUZ7LGMhNvs63U9q0fGjlYOh+z8qasLJTG9D1GGTYftcX+jNyAYAGEizUJzekzjsEmixfjv79tw==
X-Received: by 2002:a17:907:7e99:b0:978:930e:2279 with SMTP id qb25-20020a1709077e9900b00978930e2279mr1356987ejc.52.1686911354816;
        Fri, 16 Jun 2023 03:29:14 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id lc20-20020a170906dff400b00970f0e2dab2sm10525868ejc.112.2023.06.16.03.29.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 03:29:14 -0700 (PDT)
Date: Fri, 16 Jun 2023 13:29:11 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: arinc9.unal@gmail.com
Cc: =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Landen Chao <Landen.Chao@mediatek.com>,
	DENG Qingfang <dqfext@gmail.com>,
	Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Russell King <linux@armlinux.org.uk>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	mithat.guner@xeront.com, erkin.bozoglu@xeront.com,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net v5 2/6] net: dsa: mt7530: fix trapping frames on
 non-MT7621 SoC MT7530 switch
Message-ID: <20230616102911.yqwjjs6gezmhq72l@skbuf>
References: <20230616025327.12652-1-arinc.unal@arinc9.com>
 <20230616025327.12652-3-arinc.unal@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230616025327.12652-3-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 05:53:23AM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> The check for setting the CPU_PORT bits must include the non-MT7621 SoC
> MT7530 switch variants to trap frames.

I would add a simple "(identified by ID_MT7530)" to the commit message here.

> Expand the check to include them.
> 
> Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

>  drivers/net/dsa/mt7530.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index 0a5237793209..e9fbe7ae6c2c 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -1007,7 +1007,7 @@ mt753x_cpu_port_enable(struct dsa_switch *ds, int port)
>  		   UNU_FFP(BIT(port)));
>  
>  	/* Set CPU port number */
> -	if (priv->id == ID_MT7621)
> +	if (priv->id == ID_MT7530 || priv->id == ID_MT7621)
>  		mt7530_rmw(priv, MT7530_MFC, CPU_MASK, CPU_EN | CPU_PORT(port));
>  
>  	/* Add the CPU port to the CPU port bitmap for MT7531 and the switch on
> -- 
> 2.39.2
> 

