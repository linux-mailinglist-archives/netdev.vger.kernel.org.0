Return-Path: <netdev+bounces-5152-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 571CF70FD30
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 19:51:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 128052813A8
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:51:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E58620686;
	Wed, 24 May 2023 17:51:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231F41D2C1
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 17:51:15 +0000 (UTC)
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1065B6;
	Wed, 24 May 2023 10:51:12 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id ffacd0b85a97d-30959c0dfd6so1111243f8f.3;
        Wed, 24 May 2023 10:51:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684950671; x=1687542671;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KXu0ixlx8Bs2sZSoysi/IhJBHkMW10MSkaolKltVuIc=;
        b=mnEHgyY864hpBjo7R5SdoPjJ7JaKoORJvAFOHIYOSexsbbh63yxp4u6N8189wW99WO
         aA/jkEaSFqPnDDQzJytp7oUWre0qxSomOoRo8wzLv2c3/z2sofe+h+0TAN7XrsHlqUtp
         hbjTvAGG/kLdZBUI6eufDe1xrm8BIS8JN+UO6Pp4n9tplrUGlIVlywDcG6Kp/DoNYkso
         0iq3Ka/xRlOmbnrHVKiOPgev9xXzisT1/F0CEd9HyqGUVyE0CoYzGx8jMlDzGCit6uuf
         An0elB2H8GGx6ywDd1bR0o8o2YEpR5b+gmsjUQyk9G0uuh8wmiAavVcsiJdQbcTkGMwt
         EW4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684950671; x=1687542671;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KXu0ixlx8Bs2sZSoysi/IhJBHkMW10MSkaolKltVuIc=;
        b=l4LqAplfqcwj6hUbYZmC6Z+sQhCvQ3F3Mmpl/eJGGmhNkP0wJh1w8OB273m92YlbFy
         V3X+3tCZNdwxTQsphNKbP7JcxKcpkLt1X4Lu1k3g3lViUoaJsFdLwncmUe2XKMpwl5pW
         whx0Far2UWAh+mDaCxII1G9BiAKjtigiilXTjyEuG4mjHAo21VrtVddkXH8+LlISw+sp
         rBs3ch7+ACyyV/dmzgBTS+MI55pak6Fo6Rkz16iGwLaLXXld+NYfpAfT0X8mD3u4EetJ
         idVdw0B5MsAUTm8g1FI3YvNHPB59CSWkgA2bBs7g5zvg2YjrUj8uJUqeQkqa1F0CMmWu
         B2lg==
X-Gm-Message-State: AC+VfDzTnbshlSXvEvYlWc+6abFIT5uSFU5gGwR1kPFYKdj43xmA+S3x
	trxxj3ob981PqRjdwhVyKyo=
X-Google-Smtp-Source: ACHHUZ6nHg6JV7rZJSiLV0PyiRpmf9YqEVbQKw28lyWlqt6n76W+PRApJSwU7hB5sHXKVHqSoxPFrw==
X-Received: by 2002:a5d:6acd:0:b0:309:334e:ee3f with SMTP id u13-20020a5d6acd000000b00309334eee3fmr417808wrw.44.1684950670986;
        Wed, 24 May 2023 10:51:10 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id o16-20020a5d62d0000000b002fb60c7995esm15313560wrv.8.2023.05.24.10.51.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 10:51:10 -0700 (PDT)
Date: Wed, 24 May 2023 20:51:07 +0300
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
Subject: Re: [PATCH net-next 08/30] net: dsa: mt7530: change p{5,6}_interface
 to p{5,6}_configured
Message-ID: <20230524175107.hwzygo7p4l4rvawj@skbuf>
References: <20230522121532.86610-1-arinc.unal@arinc9.com>
 <20230522121532.86610-1-arinc.unal@arinc9.com>
 <20230522121532.86610-9-arinc.unal@arinc9.com>
 <20230522121532.86610-9-arinc.unal@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230522121532.86610-9-arinc.unal@arinc9.com>
 <20230522121532.86610-9-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 03:15:10PM +0300, arinc9.unal@gmail.com wrote:
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index 710c6622d648..d837aa20968c 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -2728,25 +2722,20 @@ mt753x_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>  			goto unsupported;
>  		break;
>  	case 5: /* Port 5, can be used as a CPU port. */
> -		if (priv->p5_interface == state->interface)
> +		if (priv->p5_configured)
>  			break;
>  
>  		if (mt753x_mac_config(ds, port, mode, state) < 0)
>  			goto unsupported;
> -
> -		if (priv->p5_intf_sel != P5_DISABLED)
> -			priv->p5_interface = state->interface;

If you don't replace this bit with anything, who will set priv->p5_configured
for mt7530?

>  		break;
>  	case 6: /* Port 6, can be used as a CPU port. */
> -		if (priv->p6_interface == state->interface)
> +		if (priv->p6_configured)
>  			break;
>  
>  		mt753x_pad_setup(ds, state);
>  
>  		if (mt753x_mac_config(ds, port, mode, state) < 0)
>  			goto unsupported;
> -
> -		priv->p6_interface = state->interface;

Similar question for port 6.

