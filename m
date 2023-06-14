Return-Path: <netdev+bounces-10856-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E02027308FE
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 22:13:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1D36E1C209FD
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 20:13:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B662E125A7;
	Wed, 14 Jun 2023 20:13:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46EE2EC11
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 20:13:43 +0000 (UTC)
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A67DC;
	Wed, 14 Jun 2023 13:13:42 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-977e0fbd742so152684866b.2;
        Wed, 14 Jun 2023 13:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686773620; x=1689365620;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EXEmZeBPCZiFdr9YxZXRhaXtEfM1eBOUuJMpyu8UykQ=;
        b=UUQ+phIuaAAFmruO880pSg7Uy3wykpgG+Cwi2IzwBlpp2WHme3PRHlEipKM7kGNYa8
         S8upIJAPvUAKbIlATfx3Ze6F+jAKxJxMAYDPKfiumQx1fMiWFRHg412REF67LnKRVgCu
         o8XE2u2WMI2aN8NIuKO+CcwFW5ihFWI3nPRvwLWJGbf18pCBB/sXVa//d4O133PPW1fl
         HGgCTAvFe6j4MbqhsYMHfIubHBlZ9tfHHsN1W3RQQTu04u+hlh8ig+OblzJeCSfmXqf2
         kxr9nERBrUEitjaws4ckCyRa+gXxQL2WgS8wMvCniff6RpWZonb71w66wUyODvaev1T4
         BiZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686773620; x=1689365620;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EXEmZeBPCZiFdr9YxZXRhaXtEfM1eBOUuJMpyu8UykQ=;
        b=kl7z47ywY93jPcQ4YUcCIKKCLtvmuiKgopODNrbHqVksKKp9Hs9ce6tBbKZmnrubQg
         jkidfCIm2uvHf36pgydTZZcVN79uIkFsI7gX5BuyTiJdGKTF1nzc7tBrt50DVsHFF7q1
         nglsvGwozitU8OsZOOX+vYOG0XSQDO3EdYkmooTHUN5856X0dSMsD5IKv3Rm3tegJHXj
         AWvHF09n5WQtTt9Vb8YRDSlRBSyElJ00cTShaNfGtkeyU9iX2gkkDMx5v7/Dt+q8nOp/
         FrUCZt+fQO8SiKj1uHQQbnUpdUA+1VC0paLgfcI+CgM/B42lnWtdcmHXMjhpRRx+GlML
         RzlQ==
X-Gm-Message-State: AC+VfDxvXQSuB8cHTRayOqwAbk8KXBs6SeLpud+agQOljId5tSk4ptD9
	5H4tFKOZ4/kRnJ+mx8p60e8=
X-Google-Smtp-Source: ACHHUZ5vRlNa5hmDl35XTuUI3lhBrTRlE2IpTxxAAAK84ES5Z0A+2ltwOJFGr2Gmom9CjcTivX+7Yg==
X-Received: by 2002:a17:907:169f:b0:96f:2b3f:61 with SMTP id hc31-20020a170907169f00b0096f2b3f0061mr17542704ejc.7.1686773620212;
        Wed, 14 Jun 2023 13:13:40 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id p4-20020a1709060dc400b0096f937b0d3esm8470966eji.3.2023.06.14.13.13.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 13:13:39 -0700 (PDT)
Date: Wed, 14 Jun 2023 23:13:36 +0300
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
Subject: Re: [PATCH net v4 3/7] net: dsa: mt7530: fix trapping frames on
 non-MT7621 SoC MT7530 switch
Message-ID: <20230614201336.lf5hqrp5nw7han4r@skbuf>
References: <20230612075945.16330-1-arinc.unal@arinc9.com>
 <20230612075945.16330-4-arinc.unal@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230612075945.16330-4-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 10:59:41AM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> The check for setting the CPU_PORT bits must include the non-MT7621 SoC
> MT7530 switch variants to trap frames. Expand the check to include them.
> 
> Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---
>  drivers/net/dsa/mt7530.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index ef8879087932..2bde2fdb5fba 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -3073,7 +3073,7 @@ mt753x_master_state_change(struct dsa_switch *ds,
>  	 * the numerically smallest CPU port which is affine to the DSA conduit
>  	 * interface that is up.
>  	 */
> -	if (priv->id != ID_MT7621)
> +	if (priv->id != ID_MT7530 && priv->id != ID_MT7621)
>  		return;

This patch and 2/7 should probably be reversed, since 2/7 is not going to net.

>  
>  	if (operational)
> -- 
> 2.39.2
> 

