Return-Path: <netdev+bounces-9841-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34A9272ADF3
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 19:56:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F161C1C20A91
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 17:55:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E05771EA74;
	Sat, 10 Jun 2023 17:56:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D493A1E505
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 17:56:00 +0000 (UTC)
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D80B198C;
	Sat, 10 Jun 2023 10:55:59 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id ffacd0b85a97d-30aef0499b6so1757321f8f.1;
        Sat, 10 Jun 2023 10:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686419757; x=1689011757;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UtHowokCRUQ1d1MLBDU0YGNnSsBp4vn8ne+jSCs8FEQ=;
        b=BIhFRN+xWuhpLcCOcDYGafuGdugJe2Z7ANfFaQby1wn5yUHg3+dnrR8gTTulNJ87E+
         nnGnVu9MSSm66EkUkZ/YcrlfhwbAhMlaTlB3WBnsu25QUfMqypOPxcqZ/HLYhDat4JkY
         xclZLA8DVT/rCbaNkg+YpX48r6cfYZjJylFa2slSscIDv+AArGuL3MF/Bg8ilTxljTrX
         9Rrr8k2OILvMOePqug6oKN//vhBtwTw3xkoxtrsw8yiXETVBT2Cvz4uPZajtsOFFMk5U
         kUcWsUHVaA/RJuqf1xXd2YTM2c1K0nY+u8eca17GfDgzIzSlfOtw7wcOcCUkIDoofooD
         fZIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686419757; x=1689011757;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UtHowokCRUQ1d1MLBDU0YGNnSsBp4vn8ne+jSCs8FEQ=;
        b=BzkHEqCmMqJYVgFVkJc+kzX/3jAfYmCmWPkM05kRfCLwcBblRcFYKdkjFGjGm4rrAf
         f2LqpJ3iA7t772vLNOrihpXdRYFaZPB2LH0RKXl2je9U2YxbpeR1QWfy82UCN3t9+f+p
         CKCC6u4nAaO4dJ3HsJPeYwCke1RMvC5lq3ODNDpu73zaol0rMkK/SvEb+1AKgENNVlfM
         LTjyMCIHTUiZH+9NE5LBvCHnxBQ08Q/s0RzRGJ1adqy8N+SgJ/ur/w87Bkl/kH6eNNSi
         vnCSv0MssQ2EV/2L8ODshypVhf5q53885ZG0Y9ELcTghcHqReJUNnOdpFxXRKRATpMOW
         L+4g==
X-Gm-Message-State: AC+VfDwx9qb6ED/f5e7PlCG9Tc76ySWOY6lx5hVO2UnwWbv7ignQZpkA
	h23xfgnfp+pXsv8JGV/vjGc=
X-Google-Smtp-Source: ACHHUZ6kerNnk0qqGtX+W32DX0Px3TYWUwDEpdlA6tvSDrK98fVKz7F1tUu01kz0GvhASCFtCnmnSw==
X-Received: by 2002:adf:e490:0:b0:309:4ee8:35ce with SMTP id i16-20020adfe490000000b003094ee835cemr946948wrm.21.1686419757181;
        Sat, 10 Jun 2023 10:55:57 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id d6-20020adffd86000000b0030ae87bd3e3sm7628832wrr.18.2023.06.10.10.55.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jun 2023 10:55:56 -0700 (PDT)
Date: Sat, 10 Jun 2023 20:55:53 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>,
	Sean Wang <sean.wang@mediatek.com>,
	Landen Chao <Landen.Chao@mediatek.com>,
	DENG Qingfang <dqfext@gmail.com>,
	Daniel Golle <daniel@makrotopia.org>, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
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
Message-ID: <20230610175553.hle2josd5s5jfhjo@skbuf>
References: <826fd2fc-fbf8-dab7-9c90-b726d15e2983@arinc9.com>
 <ZHyA/AmXmCxO6YMq@shell.armlinux.org.uk>
 <20230604125517.fwqh2uxzvsa7n5hu@skbuf>
 <ZHyMezyKizkz2+Wg@shell.armlinux.org.uk>
 <d269ac88-9923-c00c-8047-cc8c9f94ef2c@arinc9.com>
 <ZHyqI2oOI4KkvgB8@shell.armlinux.org.uk>
 <ZHy1C7wzqaj5KCmy@shell.armlinux.org.uk>
 <ZHy2jQLesdYFMQtO@shell.armlinux.org.uk>
 <0542e150-5ff4-5f74-361a-1a531d19eb7d@arinc9.com>
 <7c224663-7588-988d-56cb-b9de5b43b504@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7c224663-7588-988d-56cb-b9de5b43b504@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, Jun 10, 2023 at 01:57:27PM +0300, Arınç ÜNAL wrote:
> I was able to confirm all user ports of the MT7531BE switch transmit/receive
> traffic to/from the SGMII CPU port and computer fine after getting rid of
> priv->info->cpu_port_config().
> 
> Tried all user ports being affine to the RGMII CPU port, that works too.
> 
> https://github.com/arinc9/linux/commit/4e79313a95d45950cab526456ef0030286ba4d4e

Did you do black-box testing after removing the code, or were you
also able to independently confirm that the configurations done by
cpu_port_config() were later overwritten? I'm trying to disambiguate
between "works by coincidence" and "works because the analysis was
correct".

