Return-Path: <netdev+bounces-5746-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B471F7129F2
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 17:51:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5FC271C210AD
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 15:51:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8296C27208;
	Fri, 26 May 2023 15:51:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77EC7742EE
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 15:51:32 +0000 (UTC)
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9063187;
	Fri, 26 May 2023 08:51:29 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-96fe2a1db26so161235266b.0;
        Fri, 26 May 2023 08:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685116288; x=1687708288;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4dgxGjGPq9B4BTMs3oBF79nFKdG/JfMIEAxOn4RCl9c=;
        b=i0IAtIFhPzBl8gwRKkjpt8ZxONqxs+fOve/1EOjxDmnMugCzaxA2J6L/7fLUjsMhyO
         enSKvTaetZqRF599KOD7chSziRIOv1IxlgE+zG2zG2lop8yhx/U4xUX6IyxMOseBJd0n
         lROHBAnroUqG2MBQNrDh3DSdUTG4cevxIXgJ3P6d+4vmt8/iYIbgTt74SvTW108DrCXf
         az/pqLgcWChfJo1ri8MCi64oC65GygxACwjtBkHZip/fZw7DUiOQQ2Zzy32aJ2x6as/7
         ugeOFpcjV+2ZfyuQA6Nh8FmQ81CN9gskXpqxOBQejo9NXiLmdUds0cPL3NXUF6rFBcAK
         Km4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685116288; x=1687708288;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4dgxGjGPq9B4BTMs3oBF79nFKdG/JfMIEAxOn4RCl9c=;
        b=f4eZKliacPuuSfgNbu+HcKwIpXflNae4zi4d5xqrs6bupN8imTMGSdzUbE4ho81dCc
         E05Jk+srrEaP1SWlaNuyvanCZuxWv8Ca42tSJOR2D2cs9ybwHG/91Y57IEF27j/KzxXM
         NXFZLL2XhG76l0QbPExysRw3aNhX+dn4QzEyAywVwjpSdS7lb5iHQRj8/FZRaDp4I3ST
         ta2jimj1wdJoHLrEivKFa6W07h4UcHi9wb8sDll9aD3PPusE/RAM+0ngTFsV0U8mgYQH
         8GuSXdUORDS7bk10sn3f5GZrB/Od/nZCVaSr59cHM6qHGFRl0oDQfo/I/9UpCofFdSft
         01Aw==
X-Gm-Message-State: AC+VfDx5GGY7y7JEsQ+K8r0wAx0M2FKytPji/u3z/Og5+pXbvtc2XZUk
	lFfc3G6bnZZQJueJUxBpJWA=
X-Google-Smtp-Source: ACHHUZ5BbaM6qT+X4mipLLBDQrNNgEQTBj8wVNxUGWplmpGPdIn1TCwtHQVBX6Zt6AzlqGugCe+/IQ==
X-Received: by 2002:a17:906:fe48:b0:973:9521:cd50 with SMTP id wz8-20020a170906fe4800b009739521cd50mr2117091ejb.41.1685116288079;
        Fri, 26 May 2023 08:51:28 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id ja8-20020a170907988800b00961277a426dsm2283115ejc.205.2023.05.26.08.51.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 08:51:27 -0700 (PDT)
Date: Fri, 26 May 2023 18:51:24 +0300
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
Subject: Re: [PATCH net-next 25/30] net: dsa: mt7530: properly set
 MT7531_CPU_PMAP
Message-ID: <20230526155124.sps74wayui6bydao@skbuf>
References: <20230522121532.86610-1-arinc.unal@arinc9.com>
 <20230522121532.86610-1-arinc.unal@arinc9.com>
 <20230522121532.86610-26-arinc.unal@arinc9.com>
 <20230522121532.86610-26-arinc.unal@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230522121532.86610-26-arinc.unal@arinc9.com>
 <20230522121532.86610-26-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 03:15:27PM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> Every bit of the CPU port bitmap for MT7531 and the switch on the MT7988
> SoC represents a CPU port to trap frames to. Currently only the bit that
> corresponds to the first found CPU port is set on the bitmap. Introduce the
> MT7531_CPU_PMAP macro to individually set the bits of the CPU port bitmap.
> Set the CPU port bitmap for MT7531 and the switch on the MT7988 SoC on
> mt753x_cpu_port_enable() which runs on a loop for each CPU port. Add
> comments to explain this.
> 
> According to the document MT7531 Reference Manual for Development Board
> v1.0, the MT7531_CPU_PMAP bits are unset after reset so no need to clear it
> beforehand. Since there's currently no public document for the switch on
> the MT7988 SoC, I assume this is also the case for this switch.
> 
> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---

Is this supposed to be a bug fix? (incompatibility with past or future
device trees also counts as bugs) If so, it needs a Fixes: tag and to be
targeted towards the "net" tree. Also, the impact of the current behavior
and of the change need to be explained better.

>  drivers/net/dsa/mt7530.c | 15 ++++++++-------
>  drivers/net/dsa/mt7530.h |  3 ++-
>  2 files changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index 58d8738d94d3..0b513e3628fe 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -963,6 +963,13 @@ mt753x_cpu_port_enable(struct dsa_switch *ds, int port)
>  		mt7530_rmw(priv, MT753X_MFC, MT7530_CPU_MASK, MT7530_CPU_EN |
>  			   MT7530_CPU_PORT(port));
>  
> +	/* Add the CPU port to the CPU port bitmap for MT7531 and the switch on
> +	 * the MT7988 SoC. Any frames set for trapping to CPU port will be
> +	 * trapped to the CPU port the user port is affine to.
> +	 */
> +	if (priv->id == ID_MT7531 || priv->id == ID_MT7988)
> +		mt7530_set(priv, MT7531_CFC, MT7531_CPU_PMAP(BIT(port)));
> +

Stylistically, the existence of an indirect call to priv->info->cpu_port_config()
per switch family is a bit dissonant with an explicit check for device id later
in the same function.

>  	/* CPU port gets connected to all user ports of
>  	 * the switch.
>  	 */
> @@ -2315,15 +2322,9 @@ static int
>  mt7531_setup_common(struct dsa_switch *ds)
>  {
>  	struct mt7530_priv *priv = ds->priv;
> -	struct dsa_port *cpu_dp;
>  	int ret, i;
>  
> -	/* BPDU to CPU port */
> -	dsa_switch_for_each_cpu_port(cpu_dp, ds) {
> -		mt7530_rmw(priv, MT7531_CFC, MT7531_CPU_PMAP_MASK,
> -			   BIT(cpu_dp->index));
> -		break;
> -	}
> +	/* Trap BPDUs to the CPU port(s) */
>  	mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
>  		   MT753X_BPDU_CPU_ONLY);
>  
> diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
> index 5ebb942b07ef..fd2a2f726b8a 100644
> --- a/drivers/net/dsa/mt7530.h
> +++ b/drivers/net/dsa/mt7530.h
> @@ -53,7 +53,8 @@ enum mt753x_id {
>  #define  MT7531_MIRROR_MASK		(0x7 << 16)
>  #define  MT7531_MIRROR_PORT_GET(x)	(((x) >> 16) & 0x7)
>  #define  MT7531_MIRROR_PORT_SET(x)	(((x) & 0x7) << 16)
> -#define  MT7531_CPU_PMAP_MASK		GENMASK(7, 0)
> +#define  MT7531_CPU_PMAP(x)		((x) & 0xff)

You can leave this as ((x) & GENMASK(7, 0))

> +#define  MT7531_CPU_PMAP_MASK		MT7531_CPU_PMAP(~0)

There's no other user of MT7531_CPU_PMAP_MASK, you can remove this.

>  
>  #define MT753X_MIRROR_REG(id)		((((id) == ID_MT7531) || ((id) == ID_MT7988)) ?	\
>  					 MT7531_CFC : MT753X_MFC)
> -- 
> 2.39.2
> 


