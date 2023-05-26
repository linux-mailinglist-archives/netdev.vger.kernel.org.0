Return-Path: <netdev+bounces-5693-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8594B712762
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 15:20:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 406691C2106C
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 13:20:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D45461D2A0;
	Fri, 26 May 2023 13:20:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C971A19E7A
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 13:20:23 +0000 (UTC)
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3EC9187;
	Fri, 26 May 2023 06:20:18 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-51144dddd4cso1027400a12.1;
        Fri, 26 May 2023 06:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685107217; x=1687699217;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=l4MwRu+xy8iMy6y78CZiipQFPUpQ1fQNAnvOg9FBsTE=;
        b=UEnJDMMAincGgk9uz3J9XzyuqVh8gU13UloLZk3DxqUfW1KsU/FwQHcKxVyVRQ/Hbt
         tSARZdD1vS8OdcvVZCJSFqkEKRjnQXvhQzQtQ/28Cfg59fycBD5hiXzDaW60T6B9Ft2B
         LG9uXrZbY7hX2He4PPhG6ZZbp1Q4QSTANq07Z4rtaTD1sF4OpjzbV0jbxrVdbWapt0GS
         mvnogCeNVXwDbi131yWn83mEBKMyT9cPOr/y5cpGvOkasiN0bR7XClreHg571Ca//Zan
         uebECgk+XYT7kMPf62Qt8115z5Aadfn8rTe+7/f+ul1D9GyhAWw0ju+lNcXQ7ao9ca4s
         Wz8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685107217; x=1687699217;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l4MwRu+xy8iMy6y78CZiipQFPUpQ1fQNAnvOg9FBsTE=;
        b=jt4ZH/qNyNJoeCO1Z9MgM+jUBXlEsQPam+/0+Q9RROLSxIX6E7IgCs+t80emQYzryJ
         x0vALgb+GkFsL3T3FIA5qI3LBVtceBq1xSHvWDLRguVD0mb1j+yWYOoUObCUIACPywhL
         lNG53BInX223hgILOW46SWVpRp6+Y6zcEoJ9dAQmgW4NNqIjCUZ5HrSTdryivtVJozKa
         BsU3AL2EnYk3bQLCgpWENetFoQl6SEkBf/8voHiBQ4RVLMu16LC3sWJzmV4sjTnmdm1E
         Ol1Y5xOPWpa2hfNW/bOUX2avcIonD1tnYfqiJl/wlDg6UfJ6gMFKgrwRv1bILtc3xjvv
         y4NA==
X-Gm-Message-State: AC+VfDyfEnsUi6MHXPX/Yd5Yj4bkWcE06us/wN5HOwZm3/zRTTjIYKoS
	PrEek3tlxiGyMhrritPOm4Y=
X-Google-Smtp-Source: ACHHUZ4ROYCRJ1eZ8pma/X20Mq4HcGhSL3Yh2wdZG+2/MlFdobcoKgHf+aai+j3QiY1AiU0L7R2RCg==
X-Received: by 2002:a17:907:6d1b:b0:96a:f688:db6e with SMTP id sa27-20020a1709076d1b00b0096af688db6emr2058486ejc.74.1685107216953;
        Fri, 26 May 2023 06:20:16 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id lk15-20020a170906cb0f00b0096f5781205fsm2106665ejb.165.2023.05.26.06.20.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 06:20:16 -0700 (PDT)
Date: Fri, 26 May 2023 16:20:13 +0300
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
Subject: Re: [PATCH net-next 17/30] net: dsa: mt7530: fix port capabilities
 for MT7988
Message-ID: <20230526132013.rnc7awhqsunnepxi@skbuf>
References: <20230522121532.86610-1-arinc.unal@arinc9.com>
 <20230522121532.86610-18-arinc.unal@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230522121532.86610-18-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 03:15:19PM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> On the switch on the MT7988 SoC, there are only 4 PHYs. That's port 0 to 3.
> Set the internal phy cases to '0 ... 3'.
> 
> There's no need to clear the config->supported_interfaces bitmap before
> reporting the supported interfaces as all bits in the bitmap will already
> be initialized to zero when the phylink_config structure is allocated.
> There's no code that would change the bitmap beforehand. Remove it.
> 
> Fixes: 110c18bfed41 ("net: dsa: mt7530: introduce driver for MT7988 built-in switch")
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Acked-by: Daniel Golle <daniel@makrotopia.org>
> ---

Either there is a user visible bug and in that case the patch needs to
go to the 'net' tree, or you need to drop the 'Fixes' tag.

Also, 2 separate logical changes => 2 patches please. Thanks.

>  drivers/net/dsa/mt7530.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index 514e82299537..f017cc028183 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -2533,10 +2533,8 @@ static void mt7531_mac_port_get_caps(struct dsa_switch *ds, int port,
>  static void mt7988_mac_port_get_caps(struct dsa_switch *ds, int port,
>  				     struct phylink_config *config)
>  {
> -	phy_interface_zero(config->supported_interfaces);
> -
>  	switch (port) {
> -	case 0 ... 4: /* Internal phy */
> +	case 0 ... 3: /* Internal phy */
>  		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
>  			  config->supported_interfaces);
>  		break;
> -- 
> 2.39.2
> 

