Return-Path: <netdev+bounces-10865-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B429D73096D
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 22:50:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E21E281564
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 20:50:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCB8F11CA3;
	Wed, 14 Jun 2023 20:50:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D015F11C86
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 20:50:17 +0000 (UTC)
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDB3E2688;
	Wed, 14 Jun 2023 13:50:13 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-51640b9ed95so12051790a12.2;
        Wed, 14 Jun 2023 13:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686775812; x=1689367812;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8/8NwNNJTBuf6M4bs1oGKo/XENM1375c2z+Z+9Ow5uA=;
        b=iQu8hw9S5dWONmBpsohjbVjkLwCAZd/KFdBFuMSrg0cvTDPHJaPBKcvo+NtMBeobr6
         dGpYVZ1LEurVX3LK0fGBAc9SBD1nNHmk3muc6BrB/sb+Ak1BgPYefkMMK8sZdbDtK92L
         QvmnaXghboqMqUvHc1/UGWXflQEoUSsKmRlear4E0vSFZtoNXAusC6HJk/FMP6g/+tE0
         y8sXwbGUU2VGPubGn8moPwf3nuepbiehJE1G6r1CJ27M5JhyKlqqmFZ7KQs9vh7LkCUA
         52NPEWqMRw0PR6cAOpAltEFQXnafM8pcTOHlyO7F3ixwmF9nd4ZVAaSkdCG4DmkStC46
         MwAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686775812; x=1689367812;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8/8NwNNJTBuf6M4bs1oGKo/XENM1375c2z+Z+9Ow5uA=;
        b=LR4oiJ/ieg9p3P7Ey2yBsmRV9tP0GsxqIq8eJv1uJESD7MwdkeAq7XLp3I59BvEZsz
         4rgGQW6BnBSAApDQFt7qylFtxljehogSul9CCYrX7IKgEOtdUG/479yqugpFN2zZqbdg
         d6gfHsTK3/Bua23HKGUeEA5mkJMBVwXc48M5X0pgDBNtGONxaJnW7+oy25f8FCsxOlt6
         AZqy9lkznN588ursC+h1/Ay2QgKNX8QRrMxP5RZwEmY6MSFeIc8u5xKnQSCKrtoD9gN0
         eCdEzQo6TzzoFuM5ce8W+ZDHc0dfC3kdc/QsDlOz7LifHMCX+m+FkE2k0r7AgpJ0k56b
         KY7w==
X-Gm-Message-State: AC+VfDxx3fKhHm400maVgQIJ35ffUPO/6RPKHGmE5O6jHBlswfP85OHy
	rU4tYsUEddmvsX113Qvnyxc=
X-Google-Smtp-Source: ACHHUZ5ilYOCfJJWBBC6ieLvpGF5MCFogSdgzXRwt3E7w5/wJltwDLjy1/AO8dtN1/+c842pFItVWQ==
X-Received: by 2002:aa7:c74d:0:b0:514:9d2f:10be with SMTP id c13-20020aa7c74d000000b005149d2f10bemr10049447eds.18.1686775812049;
        Wed, 14 Jun 2023 13:50:12 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id p9-20020aa7cc89000000b005166663b8dcsm8058311edt.16.2023.06.14.13.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 13:50:11 -0700 (PDT)
Date: Wed, 14 Jun 2023 23:50:08 +0300
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
Subject: Re: [PATCH net v4 4/7] net: dsa: mt7530: fix handling of BPDUs on
 MT7530 switch
Message-ID: <20230614205008.czro45ogsc4c6sb5@skbuf>
References: <20230612075945.16330-1-arinc.unal@arinc9.com>
 <20230612075945.16330-5-arinc.unal@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230612075945.16330-5-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 10:59:42AM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> BPDUs are link-local frames, therefore they must be trapped to the CPU
> port. Currently, the MT7530 switch treats BPDUs as regular multicast
> frames, therefore flooding them to user ports. To fix this, set BPDUs to be
> trapped to the CPU port.
> 
> BPDUs received from a user port will be trapped to the numerically smallest
> CPU port which is affine to the DSA conduit interface that is up.
> 
> Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---
>  drivers/net/dsa/mt7530.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index 2bde2fdb5fba..e4c169843f2e 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -2259,6 +2259,10 @@ mt7530_setup(struct dsa_switch *ds)
>  
>  	priv->p6_interface = PHY_INTERFACE_MODE_NA;
>  
> +	/* Trap BPDUs to the CPU port */
> +	mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
> +		   MT753X_BPDU_CPU_ONLY);
> +
>  	/* Enable and reset MIB counters */
>  	mt7530_mib_reset(ds);
>  
> -- 
> 2.39.2
> 

Where have you seen the BPC register in the memory map of MT7530 or MT7621?

