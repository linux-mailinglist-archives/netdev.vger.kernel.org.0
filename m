Return-Path: <netdev+bounces-5157-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F0BAD70FD6E
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 20:04:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 694651C20E8B
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 18:04:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDD2CD2E1;
	Wed, 24 May 2023 18:04:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3D2848D
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 18:04:40 +0000 (UTC)
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B519194;
	Wed, 24 May 2023 11:04:33 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3f60ec45314so9986425e9.3;
        Wed, 24 May 2023 11:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684951471; x=1687543471;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PbGGH2S3w7HcoJCp7d0j90HcXaq6j3Fgosa8UJEEVfY=;
        b=UwL5D7dqjeyyVogHuw+vr4kTyy8m3QwcpUwkIf50pcw11+nKU8hibHk9iQG3PduHz3
         l+MnVdjeb1HWtGpz5cosOld1neklNsNQJqIIzjtCrey1rQHzTYfc/RHtoVpOg73HgXlL
         0qNFcHTgyNGa8ajdOaCjick2Bo5LalpYUy2I2XDcwGWCVJxmq2uTVBSXjUagVxZ5Z7px
         cokK63ETdLfT4Wozb+QLhD7APgo3Yt+BA4FSCQCSqQHM0ogLU5qEEWksemPSQ6hKc/jx
         2wVsyrvkc7afl5km4Rtigfr1zTvWO2za8QiPtjCiMTeITDmmle6UJVNFIA08ku3696kr
         OjHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684951471; x=1687543471;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PbGGH2S3w7HcoJCp7d0j90HcXaq6j3Fgosa8UJEEVfY=;
        b=LYfMyjqXvufEDeVtjdw1ixaos6rvgkT/oKPa3dYbnxLwpAK84NRyz0HVi6hs95wjsf
         CkTXh/4G9Ww/czCeU1O/hW7xha7kIn85zztFFdUeXn9FQ0yDzNg7DUf2KchEKFvCDFAq
         2eAhggWy58patjJrIfLQrRSfcekb5k+XoGKXyNeyqfHk/TKm+ZzOXH6aGWDWHPgXjOK2
         R5V+O83gIo5dwstvEsSAslQWXqV8ocTSWM3lAtBRtHbcupxfYu6bTKk5AKIz2eCX7f4u
         2N1f3oW7PC3hGIXsD15HtWlphW5Ku0vzkt2Mjb9przUgP8iHubDiVuo5mmvJDQxx2mI+
         SkUA==
X-Gm-Message-State: AC+VfDwze+RbLrr2+xzsj+ddlFeELnl0/0hkNoHQRw+B3V8HqZj12vPR
	1IDqdJsuXY3v1FHRac3/1FA=
X-Google-Smtp-Source: ACHHUZ4TjJmVnHvv5pYI09ns9MQOl/UVt7YfJISuZVNO22gwZiqXDmnrVLOyMThPojnNCNy/e53ukQ==
X-Received: by 2002:a05:600c:ac5:b0:3f6:536:a4b2 with SMTP id c5-20020a05600c0ac500b003f60536a4b2mr461872wmr.27.1684951470896;
        Wed, 24 May 2023 11:04:30 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id o9-20020adfeac9000000b0030647d1f34bsm15367534wrn.1.2023.05.24.11.04.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 11:04:30 -0700 (PDT)
Date: Wed, 24 May 2023 21:04:27 +0300
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
Subject: Re: [PATCH net-next 09/30] net: dsa: mt7530: empty default case on
 mt7530_setup_port5()
Message-ID: <20230524180427.t77iohojxelpa4yk@skbuf>
References: <20230522121532.86610-1-arinc.unal@arinc9.com>
 <20230522121532.86610-10-arinc.unal@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230522121532.86610-10-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 03:15:11PM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> There're two code paths for setting up port 5:
> 
> mt7530_setup()
> -> mt7530_setup_port5()
> 
> mt753x_phylink_mac_config()
> -> mt753x_mac_config()
>    -> mt7530_mac_config()
>       -> mt7530_setup_port5()
> 
> On the first code path, priv->p5_intf_sel is either set to
> P5_INTF_SEL_PHY_P0 or P5_INTF_SEL_PHY_P4 when mt7530_setup_port5() is run.
> 
> On the second code path, priv->p5_intf_sel is set to P5_INTF_SEL_GMAC5 when
> mt7530_setup_port5() is run.
> 
> Empty the default case which will never run but is needed nonetheless to
> handle all the remaining enumeration values.
> 
> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

