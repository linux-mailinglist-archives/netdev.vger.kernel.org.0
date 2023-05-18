Return-Path: <netdev+bounces-3665-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 31E047083E1
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 16:24:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD44A281908
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 14:24:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 406FF209B3;
	Thu, 18 May 2023 14:24:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A0823C69
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 14:24:29 +0000 (UTC)
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4418C10A
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 07:24:27 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-96b4ed40d97so322104066b.0
        for <netdev@vger.kernel.org>; Thu, 18 May 2023 07:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684419866; x=1687011866;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tnkuLNJU13rtlymgdFYUP/eEQpEzQv9oC45e+/juZjc=;
        b=XHMfWmyOMQ6TCM2THBwWo5WVlaBQgYIy42HcvT8926SSJLor3T2rOFc0qIX7EVfd8q
         hyRQ1l3SljImRQsXTuziP8ZjyfvN7A3/KwwGBgChp73fCp/3RiH83X0WhrI7dmZ+P/e8
         Qgv1beRI3J3mFho3wCD9W4esBwX1VgxIvhqS/AX24gVqeJgPImHbG93K37xL3TqiWovZ
         3JgvpA+CMc6X+cyPhtEVoIl4oNmzbhKlYJnxkmRWigKEsiCmzl3MU1KJkBgpTTJysW0k
         AhOiehhanQ5RT8ZnYJfRPM7gDyKYm/QBphHqEpfgSLJr7FeLzvH/Y3scHZ0+Q+eV8YGP
         1D3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684419866; x=1687011866;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tnkuLNJU13rtlymgdFYUP/eEQpEzQv9oC45e+/juZjc=;
        b=XoU3MUaLrTcdy+q7Fm9bgIufEDZvtNs7QiLWf9KWUi/XSbdokzlgnGuw0ewH2abBcj
         38TKEV2Gb9ErZ+ungsiucYSCnLMCn4QurXLWeOTJ9ultJdJUTVu1nFA8IO+gtXhFyy9s
         JBAwNUbT2y3wJWNXaYEZ3hPvB/RMzotxob/Iyvf1dn+u9mzOMgXL3MelUIi3Z30CvIF6
         EzDJY4GJiVgJWDRNIeeKiIo0Sb1+ymbpIOMZA7GL0zNFHdRp2rqThQLAVMTbK/Sx4HXf
         7C9sGu/WTI3qGlZv9kcE9ksybJLY6snxsDfuNnXTA1lz5CP3WO/GUI40rvTNnplq+b2t
         BHZg==
X-Gm-Message-State: AC+VfDwrOUsFMZmGaj6w2dQtjICsvnDwhZsjmIDvsWts0d2BRNHZsQqD
	bRLM93FdCojdsxpKCKj+NYZxoEvu//v4OSzo
X-Google-Smtp-Source: ACHHUZ4cE7whhlD5dDgGrj7lW1pRTdBKmKFokOsSrYg8rsbD7mPH4uEYNQnUDATyROty1HVsVHbSLQ==
X-Received: by 2002:a17:907:2d1f:b0:968:db2f:383 with SMTP id gs31-20020a1709072d1f00b00968db2f0383mr33574736ejc.53.1684419865197;
        Thu, 18 May 2023 07:24:25 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id u24-20020a170906655800b009661afd3b86sm1044569ejn.171.2023.05.18.07.24.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 07:24:24 -0700 (PDT)
Date: Thu, 18 May 2023 17:24:22 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc: Frank Wunderlich <frank-w@public-files.de>,
	Felix Fietkau <nbd@nbd.name>, netdev <netdev@vger.kernel.org>,
	erkin.bozoglu@xeront.com, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	John Crispin <john@phrozen.org>,
	Mark Lee <Mark-MC.Lee@mediatek.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Landen Chao <Landen.Chao@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	DENG Qingfang <dqfext@gmail.com>, mithat.guner@xeront.com
Subject: Re: Choose a default DSA CPU port
Message-ID: <20230518142422.62hm5d4orvy7nroz@skbuf>
References: <f9fcf74b-7e30-9b51-776b-6a3537236bf6@arinc9.com>
 <6383a98a-1b00-913d-0db1-fe33685a8410@arinc9.com>
 <trinity-6ad483d2-5c50-4f38-b386-f4941c85c1fd-1677413524438@3c-app-gmx-bs15>
 <20230228115846.4r2wuyhsccmrpdfh@skbuf>
 <91c90cc5-7971-8a95-fe64-b6e5f53a8246@arinc9.com>
 <20230517161028.6xmt4dgxtb4optm6@skbuf>
 <e5f02399-5697-52f8-9388-00fa679bb058@arinc9.com>
 <20230517161657.a6ej5z53qicqe5aj@skbuf>
 <d2236430-0303-b74c-2b35-99bef4ac30a1@arinc9.com>
 <d2236430-0303-b74c-2b35-99bef4ac30a1@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d2236430-0303-b74c-2b35-99bef4ac30a1@arinc9.com>
 <d2236430-0303-b74c-2b35-99bef4ac30a1@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 18, 2023 at 01:36:42PM +0300, Arınç ÜNAL wrote:
> The frames won't necessarily be trapped to the CPU port the user port is
> connected to. This operation is only there to make sure the trapped frames
> always reach the CPU.

That's kind of understated and I don't regard that as that big of a deal.
Since control packets cannot be guaranteed to be processed by the
conduit interface affine to the user port, I would go one step further
and say: don't even attempt to keep an affinity, just use for that purpose
the numerically first conduit interface that is up.

> I don't (know how to) check for other conduits being up when changing the
> trap port. So if a conduit is set down which results in both conduits being
> down, the trap port will still be changed to the other port which is
> unnecessary but it doesn't break anything.
> 
> Looking forward to your comments.
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index b5c8fdd381e5..55c11633f96f 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -961,11 +961,6 @@ mt753x_cpu_port_enable(struct dsa_switch *ds, int port)
>  	mt7530_set(priv, MT753X_MFC, MT753X_BC_FFP(BIT(port)) |
>  		   MT753X_UNM_FFP(BIT(port)) | MT753X_UNU_FFP(BIT(port)));
> -	/* Set CPU port number */
> -	if (priv->id == ID_MT7621)
> -		mt7530_rmw(priv, MT753X_MFC, MT7530_CPU_MASK, MT7530_CPU_EN |
> -			   MT7530_CPU_PORT(port));
> -
>  	/* Add the CPU port to the CPU port bitmap for MT7531 and switch on
>  	 * MT7988 SoC. Any frames set for trapping to CPU port will be trapped
>  	 * to the CPU port the user port is connected to.
> @@ -2258,6 +2253,10 @@ mt7530_setup(struct dsa_switch *ds)
>  			   PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
>  	}
> +	/* Trap BPDUs to the CPU port */
> +	mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
> +		   MT753X_BPDU_CPU_ONLY);
> +

This part will need its own patch + explanation
.
>  	/* Setup VLAN ID 0 for VLAN-unaware bridges */
>  	ret = mt7530_setup_vlan0(priv);
>  	if (ret)
> @@ -2886,6 +2885,50 @@ static const struct phylink_pcs_ops mt7530_pcs_ops = {
>  	.pcs_an_restart = mt7530_pcs_an_restart,
>  };
> +static void
> +mt753x_master_state_change(struct dsa_switch *ds,
> +			   const struct net_device *master,
> +			   bool operational)
> +{
> +	struct mt7530_priv *priv = ds->priv;
> +	struct dsa_port *cpu_dp = master->dsa_ptr;
> +	unsigned int trap_port;
> +
> +	/* Set the CPU port to trap frames to for MT7530. There can be only one
> +	 * CPU port due to MT7530_CPU_PORT having only 3 bits. Any frames set
> +	 * for trapping to CPU port will be trapped to the CPU port connected to
> +	 * the most recently set up DSA conduit. If the most recently set up DSA
> +	 * conduit is set down, frames will be trapped to the CPU port connected
> +	 * to the other DSA conduit.
> +	 */
> +	if (priv->id == ID_MT7530 || priv->id == ID_MT7621) {

Just return early which saves one level of indentation.

	if (priv->id != ID_MT7530 && priv->id != ID_MT7621)
		return;

> +		trap_port = (mt7530_read(priv, MT753X_MFC) & MT7530_CPU_PORT_MASK) >> 4;
> +		dev_info(priv->dev, "trap_port is %d\n", trap_port);
> +		if (operational) {
> +			dev_info(priv->dev, "the conduit for cpu port %d is up\n", cpu_dp->index);
> +
> +			/* This check will be unnecessary if we find a way to
> +			 * not change the trap port to the other port when a
> +			 * conduit is set down which results in both conduits
> +			 * being down.
> +			 */
> +			if (!(cpu_dp->index == trap_port)) {
> +				dev_info(priv->dev, "trap to cpu port %d\n", cpu_dp->index);
> +				mt7530_set(priv, MT753X_MFC, MT7530_CPU_EN);
> +				mt7530_rmw(priv, MT753X_MFC, MT7530_CPU_PORT_MASK, MT7530_CPU_PORT(cpu_dp->index));
> +			}
> +		} else {
> +			if (cpu_dp->index == 5 && trap_port == 5) {
> +				dev_info(priv->dev, "the conduit for cpu port 5 is down, trap frames to port 6\n");
> +				mt7530_rmw(priv, MT753X_MFC, MT7530_CPU_PORT_MASK, MT7530_CPU_PORT(6));
> +			} else if (cpu_dp->index == 6 && trap_port == 6) {
> +				dev_info(priv->dev, "the conduit for cpu port 6 is down, trap frames to port 5\n");
> +				mt7530_rmw(priv, MT753X_MFC, MT7530_CPU_PORT_MASK, MT7530_CPU_PORT(5));
> +			}
> +		}

I believe that the implementation where you cache the "operational"
value of previous calls will be cleaner. Something like this (written in
an email client, so take it with a grain of salt):

struct mt7530_priv {
	unsigned long active_cpu_ports;
	...
};

	if (operational)
		priv->active_cpu_ports |= BIT(cpu_dp->index);
	else
		priv->active_cpu_ports &= ~BIT(cpu_dp->index);

	if (priv->active_cpu_ports) {
		mt7530_rmw(priv, MT753X_MFC, MT7530_CPU_EN | MT7530_CPU_PORT_MASK,
			   MT7530_CPU_EN |
			   MT7530_CPU_PORT(__ffs(priv->active_cpu_ports)));
	} else {
		mt7530_rmw(priv, MT753X_MFC, MT7530_CPU_EN | MT7530_CPU_PORT_MASK,
			   MT7530_CPU_PORT(0));
	}

> +	}
> +}
> +
>  static int
>  mt753x_setup(struct dsa_switch *ds)
>  {
> @@ -2999,6 +3042,7 @@ const struct dsa_switch_ops mt7530_switch_ops = {
>  	.phylink_mac_link_up	= mt753x_phylink_mac_link_up,
>  	.get_mac_eee		= mt753x_get_mac_eee,
>  	.set_mac_eee		= mt753x_set_mac_eee,
> +	.master_state_change	= mt753x_master_state_change,
>  };
>  EXPORT_SYMBOL_GPL(mt7530_switch_ops);
> diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
> index fd2a2f726b8a..2abd3c5ce05a 100644
> --- a/drivers/net/dsa/mt7530.h
> +++ b/drivers/net/dsa/mt7530.h
> @@ -41,8 +41,8 @@ enum mt753x_id {
>  #define  MT753X_UNU_FFP(x)		(((x) & 0xff) << 8)
>  #define  MT753X_UNU_FFP_MASK		MT753X_UNU_FFP(~0)
>  #define  MT7530_CPU_EN			BIT(7)
> -#define  MT7530_CPU_PORT(x)		((x) << 4)
> -#define  MT7530_CPU_MASK		(0xf << 4)
> +#define  MT7530_CPU_PORT(x)		(((x) & 0x7) << 4)
> +#define  MT7530_CPU_PORT_MASK		MT7530_CPU_PORT(~0)
>  #define  MT7530_MIRROR_EN		BIT(3)
>  #define  MT7530_MIRROR_PORT(x)		((x) & 0x7)
>  #define  MT7530_MIRROR_MASK		0x7
> 
> Arınç


