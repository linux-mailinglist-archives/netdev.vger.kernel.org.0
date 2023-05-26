Return-Path: <netdev+bounces-5778-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C99E1712B9D
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 19:18:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3199428189B
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 17:18:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65F6C28C1B;
	Fri, 26 May 2023 17:18:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5579F2CA6
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 17:18:35 +0000 (UTC)
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16984E66;
	Fri, 26 May 2023 10:18:01 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-96ff9c0a103so140585466b.0;
        Fri, 26 May 2023 10:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685121479; x=1687713479;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rXAfU4krUfQItxKONERdy0UnGwuPi9mhVPa4tKH3xW4=;
        b=blT6VhBS2mX05s5wK3U4WHJiAAhqRpdhqtpQnhde0RcdR3Z9PVGwJ+60BHw26bot3m
         +MD3e5vekpWGhzpB9kMSAh13hs30iC6kdknWyrV36JwWcEfxBtzduGUfatSI5WNNxceC
         lJXiA1WOxGJiRvpUH9FfKpyG4OMDw+tzzsY1YHVSGWYmlkj1fGpxyTjgvcJmf1FKbAs1
         Lq5nbnIvcifvXWLQP4TcDSylXxYlUBssE540Sr7QbfgBb3C0DwmROamC7xzgYG64VIWo
         uYuSdmgJ9M0od8/63dOnwHogZajZA8/QzcnOPlvwNXCnMY3dd07SFvN3eDbYjIJSjKiP
         bXmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685121479; x=1687713479;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rXAfU4krUfQItxKONERdy0UnGwuPi9mhVPa4tKH3xW4=;
        b=lSK+fosVioD9UhB8q0ZDMhdrGgcETi8amFUT0BfKOgr4sUd1K0E7+NOvElY6g1vc1F
         1KzalpuAM3dAQHEdl9OiDeRAuy5zh+m5o41znJz3jpBV3kmMu1QkxMnoB7YqNJ+lE+AE
         huFcV+U53JizrDLxp3X2JFKg7GZGTHO3yz/l+O0Oqtcq+UUv1bVxk9OE5FG9pHejo7pO
         5WC+x66KZbmfuR+zx74Hlasxb5HlDTosPyIsAx1N06dLGmeN5eKesgce7Arzj1JU7k+M
         OL159CLmgPfNETbW5sUVtT/DUYLXUdf8SbrhSprU0M/pa64VuHf5BcRl2X7A7wYCqPRN
         OUCA==
X-Gm-Message-State: AC+VfDxfy9s2p522QEj0hVIFMlH8zCm/MibfS6Au3Z3fF9LKPvkTAlGr
	XhhcQnPeSV71QMjCsSh8oT0=
X-Google-Smtp-Source: ACHHUZ68f6SeRUgo46bYThmj4j2ets/qH5kJd72OCPkCJgENbXUwPSZg0P94z960AlvESDfW1LPHfA==
X-Received: by 2002:a17:907:6e8e:b0:955:dcc9:d101 with SMTP id sh14-20020a1709076e8e00b00955dcc9d101mr3392414ejc.18.1685121478956;
        Fri, 26 May 2023 10:17:58 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id dk24-20020a170906f0d800b00958434d4ecesm2440881ejb.13.2023.05.26.10.17.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 10:17:58 -0700 (PDT)
Date: Fri, 26 May 2023 20:17:55 +0300
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
Subject: Re: [PATCH net-next 29/30] net: dsa: introduce
 preferred_default_local_cpu_port and use on MT7530
Message-ID: <20230526171755.nk643aphoojvhjpg@skbuf>
References: <20230522121532.86610-1-arinc.unal@arinc9.com>
 <20230522121532.86610-1-arinc.unal@arinc9.com>
 <20230522121532.86610-30-arinc.unal@arinc9.com>
 <20230522121532.86610-30-arinc.unal@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230522121532.86610-30-arinc.unal@arinc9.com>
 <20230522121532.86610-30-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 03:15:31PM +0300, arinc9.unal@gmail.com wrote:
> From: Vladimir Oltean <olteanv@gmail.com>
> 
> When multiple CPU ports are being used, the numerically smallest CPU port
> becomes the port all user ports become affine to. This may not be the best
> choice for all switches as there may be a numerically greater CPU port with
> more bandwidth than the numerically smallest one.
> 
> Such switches are MT7530 and MT7531BE, which the MT7530 DSA subdriver
> controls. Port 5 of these switches has got RGMII whilst port 6 has got
> either TRGMII or SGMII.
> 
> Therefore, introduce the preferred_default_local_cpu_port operation to the
> DSA subsystem and use it on the MT7530 DSA subdriver to prefer port 6 as
> the default CPU port.
> 
> To prove the benefit of this operation, I (Arınç) have done a bidirectional
> speed test between two DSA user ports on the MT7531BE switch using iperf3.
> The user ports are 1 Gbps full duplex and on different networks so the SoC
> MAC would have to do 2 Gbps TX and 2 Gbps RX to deliver full speed.

I think the real argument would sound like this:

Since the introduction of the OF bindings, DSA has always had a policy
that in case multiple CPU ports are present in the device tree, the
numerically first one is always chosen.

The MT7530 switch family has 2 CPU ports, 5 and 6, where port 6 is
preferable because it has higher bandwidth.

The MT7530 driver developers had 3 options:
- to modify DSA when the driver was introduced, such as to prefer the
  better port
- to declare both CPU ports in device trees as CPU ports, and live with
  the sub-optimal performance resulting from not preferring the better
  port
- to declare just port 6 in the device tree as a CPU port

Of course they chose the path of least resistance (3rd option), kicking
the can down the road. The hardware description in the device tree is
supposed to be stable - developers are not supposed to adopt the
strategy of piecemeal hardware description, where the device tree is
updated in lockstep with the features that the kernel currently supports.

Now, as a result of the fact that they did that, any attempts to modify
the device tree and describe both CPU ports as CPU ports would make DSA
change its default selection from port 6 to 5, effectively resulting in
a performance degradation visible to users as can be seen below vvvvv

> 
> Without preferring port 6:
> 
> [ ID][Role] Interval           Transfer     Bitrate         Retr
> [  5][TX-C]   0.00-20.00  sec   374 MBytes   157 Mbits/sec  734    sender
> [  5][TX-C]   0.00-20.00  sec   373 MBytes   156 Mbits/sec    receiver
> [  7][RX-C]   0.00-20.00  sec  1.81 GBytes   778 Mbits/sec    0    sender
> [  7][RX-C]   0.00-20.00  sec  1.81 GBytes   777 Mbits/sec    receiver
> 
> With preferring port 6:
> 
> [ ID][Role] Interval           Transfer     Bitrate         Retr
> [  5][TX-C]   0.00-20.00  sec  1.99 GBytes   856 Mbits/sec  273    sender
> [  5][TX-C]   0.00-20.00  sec  1.99 GBytes   855 Mbits/sec    receiver
> [  7][RX-C]   0.00-20.00  sec  1.72 GBytes   737 Mbits/sec   15    sender
> [  7][RX-C]   0.00-20.00  sec  1.71 GBytes   736 Mbits/sec    receiver
> 
> Using one port for WAN and the other ports for LAN is a very popular use
> case which is what this test emulates.

As such, this change proposes that we retroactively modify stable
kernels to keep the mt7530 driver preferring port 6 even with device
trees where the hardware is more fully described.

Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")

> 
> This doesn't affect the remaining switches, MT7531AE and the switch on the
> MT7988 SoC. Both CPU ports of the MT7531AE switch have got SGMII and there
> is only one CPU port on the switch on the MT7988 SoC.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---

See the difference in intent?

