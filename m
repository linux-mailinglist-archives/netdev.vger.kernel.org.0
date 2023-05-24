Return-Path: <netdev+bounces-5066-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7317C70F92E
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 16:51:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C5212813E3
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:51:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA60718C0E;
	Wed, 24 May 2023 14:49:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD769182CF
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 14:49:53 +0000 (UTC)
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBFD612F;
	Wed, 24 May 2023 07:49:51 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-96f53c06babso188036366b.3;
        Wed, 24 May 2023 07:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684939790; x=1687531790;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FyedHscGEFlAyTcL2YX1NQlnWA/wiw8R69Wx/wJ/hdc=;
        b=RV82gdRnlL16Wu65qUhDbXspGrdeIIJWl7xoa/6zOSti527MJevjRimiCUzTPziFZO
         LXQF1ZDTV/3/zcamdtRZz8ZjTaCRwsRV9S4pFZ5uklNReyQaGjFVv3TJgM4bAWXjYWza
         5scM0fGoMJ8KHYC5sOXZKcIu/O7oNwIojF7xr6ksdH8Y/wsUh0ZyAQ63d0autUHNZ+2u
         twl1rjWsIe9uU1TwygoWEQUSMnIkZxXuGB36/3ZQrCHItcfEfFNz/Ks7G+2HWFII+w15
         iVvlxK9KgFPbc/ltVEXrdiH94N3tysE4hkZxe5PjKCfJbv7tdp0ZDa1jmwaj+2d0e82d
         h0Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684939790; x=1687531790;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FyedHscGEFlAyTcL2YX1NQlnWA/wiw8R69Wx/wJ/hdc=;
        b=RRwqH/lkVKmbGORZN5zEUTNsaL/RLePSZ1l5WX+9Qoke4XW3+nsMId3uDKMMEXFBx7
         GEFUOx7mPV4OKKeBapFKArwc+YZE9l7CT9IqGnCHcgEA5wNTRPpXzh50q8HoJFC/nTkM
         m43UZlj4dlpdr8LaGEuRQ+xJJJ1dOONwd+0TeDZ/Hji+4M3DVKmZPPYme1P8Mg1iqNvJ
         Jw6QZtzuJ3w5jiMTDjqAO9sFSIQ4ndUZuwbwsrwsVvmAhE02c/sQVO4xK0w4ES46HHss
         09wGG3Mgl4KzaRHww7MOWg807DDtYZFBN9j5BHfpHGtG9IufCZj3xkjqAkMWprVW2Uyj
         4+iw==
X-Gm-Message-State: AC+VfDwvNwfdCDNptjcA0B4wqVBTaJ0WGARd7FVBLTAhr255RljxkIVm
	Und09XJ2fOUUuqDZaPsKthE=
X-Google-Smtp-Source: ACHHUZ5f5jpmlXfXl69c8NP7gio6BtFCBwM5CIosxzVdgEMVR+GMD/bINdQsFaYe/W+T8c0ISQL5aw==
X-Received: by 2002:a17:907:9308:b0:969:fc68:fa9a with SMTP id bu8-20020a170907930800b00969fc68fa9amr16755972ejc.40.1684939790273;
        Wed, 24 May 2023 07:49:50 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id z27-20020a17090674db00b0096efa536229sm6055956ejl.149.2023.05.24.07.49.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 07:49:50 -0700 (PDT)
Date: Wed, 24 May 2023 17:49:47 +0300
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
Subject: Re: [PATCH net-next 04/30] net: dsa: mt7530: improve comments
 regarding port 5 and 6
Message-ID: <20230524144947.tdpwdvcssjkr7efu@skbuf>
References: <20230522121532.86610-1-arinc.unal@arinc9.com>
 <20230522121532.86610-5-arinc.unal@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230522121532.86610-5-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 03:15:06PM +0300, arinc9.unal@gmail.com wrote:
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index 024b853f9558..b28d66a7c0b2 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -2499,7 +2499,9 @@ static void mt7530_mac_port_get_caps(struct dsa_switch *ds, int port,
>  			  config->supported_interfaces);
>  		break;
>  
> -	case 5: /* 2nd cpu port with phy of port 0 or 4 / external phy */
> +	case 5: /* Port 5 which can be used as a CPU port supports rgmii with
> +		 * delays, mii, and gmii.
> +		 */

Please put the comments on dedicated lines:

	/* Port X can be used as ... */
	case X:

