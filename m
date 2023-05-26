Return-Path: <netdev+bounces-5773-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 147A0712B56
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 19:02:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C1D79281957
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 17:02:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AE1828C10;
	Fri, 26 May 2023 17:02:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F33F271F6
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 17:02:29 +0000 (UTC)
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23CBAD9;
	Fri, 26 May 2023 10:02:28 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-96f53c06babso172257166b.3;
        Fri, 26 May 2023 10:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685120546; x=1687712546;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SS6kMs+u9yaM8ffbjosYMxdgJboVzMiJqPmKQK1XNCQ=;
        b=FYcJg0QRD45Vj7/k3uaWJMQtzn9rB2pItBRDJkRbTotkXsg4f5QYHx0yOXaV1zcA2R
         KzGQ1jCP6N3cX0T757RcOsr7vj1fBnAIjWTpRkIhMFsWvhXrgaz9Wwn3jTgl8Jct9Dnf
         kxy2z5mX++KMGhTonEZKso80z5qhGVbwhvNdN5ZBh1FmjPLubRIbmIFp9U/uu6rdbhqP
         f04eF7x47WIvMjZobgdsM3Yd03n5uqRrELll9hTawVeoXfKKpiZIHeKw/rqKZk2o3OPX
         iAo0Rh+v9s7VLHqxx3HEWMSBWp3QlXNLSroFHB7tZvALUXsrWseavTVEU8tZwwCpiqPc
         mRFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685120546; x=1687712546;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SS6kMs+u9yaM8ffbjosYMxdgJboVzMiJqPmKQK1XNCQ=;
        b=Jl1AUuuS7wqmTuspl7S8HOmnoIkq/KF4RkjrrwsocgBs7ziSJNeJrytZaPLxL/meAd
         LKj6HOO9n3jZHQas0n0La/jzVwRwG8FV4Ggqhqz/50XN5cHk7t+9aV7YG9s3xRRw4VqI
         3kd/B+HBCLf8mYrh9yT60fgCwvmyQTdM6+2TNMswZlXCXY1bLyZtdNo1EMN7i4zpP5Ji
         4UtlE7XTUDSKodegbVepe3Rz8lzjv0UEYubz8G8uQodeFz2YR0xH1QjLn07ybZt4GiFH
         v4uavZW5bZIxqw6r2vjjLveCbRMpASDwCXQrv/Ex5QlSN1CzxucCTykYWtYAh0iLW7i4
         O7xQ==
X-Gm-Message-State: AC+VfDyTLbL/usALFqL9We4j1GMeqFEY9x8qAA772Y5+aZuFmBif/JRY
	m0kYK97/1AvXXcbGtLwOEjU=
X-Google-Smtp-Source: ACHHUZ6RpU4KDLswYEExALywRUzB2t870g07ER7XqGgSAAKLHwX6vYLZhJ4U9D3LrLvFC7F3kYjJ8Q==
X-Received: by 2002:a17:907:743:b0:969:9fd0:7cee with SMTP id xc3-20020a170907074300b009699fd07ceemr2636652ejb.10.1685120546389;
        Fri, 26 May 2023 10:02:26 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id qw23-20020a170906fcb700b0096f71ace804sm2371847ejb.99.2023.05.26.10.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 10:02:26 -0700 (PDT)
Date: Fri, 26 May 2023 20:02:23 +0300
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
Subject: Re: [PATCH net-next 27/30] net: dsa: mt7530: introduce BPDU trapping
 for MT7530 switch
Message-ID: <20230526170223.gjdek6ob2w2kibzr@skbuf>
References: <20230522121532.86610-1-arinc.unal@arinc9.com>
 <20230522121532.86610-28-arinc.unal@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230522121532.86610-28-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 03:15:29PM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> The MT753X switches are capable of trapping certain frames. Introduce
> trapping BPDUs to the CPU port for the MT7530 switch.
> 
> BPDUs will be trapped to the numerically smallest CPU port which is affine
> to the DSA conduit interface that is set up. The BPDUs won't necessarily be
> trapped to the CPU port the user port, which these BPDUs are received from,
> is affine to.
> 
> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---
>  drivers/net/dsa/mt7530.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index cd16911fcb01..2fb4b0bc6335 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -2223,6 +2223,10 @@ mt7530_setup(struct dsa_switch *ds)
>  	val |= MHWTRAP_MANUAL;
>  	mt7530_write(priv, MT7530_MHWTRAP, val);
>  
> +	/* Trap BPDUs to the CPU port */
> +	mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
> +		   MT753X_BPDU_CPU_ONLY);
> +

If the switch doesn't currently trap BPDUs, isn't STP broken?

ip link add br0 type bridge stp_state 1
(with or without a userspace helper installed at /sbin/bridge-stp
for more modern protocols than the original 802.1D STP)

>  	/* Enable and reset MIB counters */
>  	mt7530_mib_reset(ds);
>  
> -- 
> 2.39.2
> 

