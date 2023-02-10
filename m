Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8B5692595
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 19:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232896AbjBJSov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 13:44:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232466AbjBJSou (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 13:44:50 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1648F7D3D7;
        Fri, 10 Feb 2023 10:44:14 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id c1so1676554edt.4;
        Fri, 10 Feb 2023 10:44:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fb0wKEc3mmbdGMSXDzSrYj5qYNI0XKkPSAyyWf1uEgk=;
        b=V2rNVBt9iSWj+cz1hVbKyDY8zaFUGybNt0tLkCUxm9oj2mQWP125DqQC/q0fV/gH2G
         0e0kxdVMYEiCtFuS5px5N56DHlP+7hcADcQDehAEGqHkJ5cPjZNCGc5Kf8SEQ65INvFj
         UyQELoT18ps5Y8wG8aiFsb0dMvkuWfhJ2wrHFnZxKI/njeDeY1nXPz757rMYlJP+Ff0Y
         AfzEgkGsJA49TZNHHJyqkhZq4pfCh7Ld+5X468mo93X9S7vH0mwoyDlVqc0njUk7ocKn
         0Kl4z1eR3sOuI1vKQFvRv4wIRazEOwPX3XdFEaaTDvwVE46xw3Hd7XPWgqrxyiPrf2wR
         lR3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fb0wKEc3mmbdGMSXDzSrYj5qYNI0XKkPSAyyWf1uEgk=;
        b=F9HY/RRN0UkP+C763zDTwn7CiomfCA7aRTcX5um+2fRYZLVp5ecKU49lnUDwUMETOG
         ylirPaZUzckIf+cMubJjOursIgRcs73BjFhhUL6QEV9TkGTjWqCUddDG8viVUtSUyECK
         nuMRgrTVC4WqfTOSKU6m4jE7bfrCTqihIYwXXj+oOtfvDlmG5stf6RS98rW/X/ahMh+p
         +e9DZ76mAx0eYUwZWTj8YCGQANdd26z/fyvfRUVsRQGqcr1+iGQPbrzXEUtnpfovbwCZ
         OqalF+ftFA0UdyqZ5fqaNXPpXe4nxygbMgHgTSQdEABinmQSGCWuXhEN7SLJfqIipmrH
         ZmQQ==
X-Gm-Message-State: AO0yUKVFxmzEl4DWCo+X7BVqhcytF4ZE9VxrSlOxHfC5tG46IJIKTMwo
        sYRDOzyyAVu26q3Pcw7ssNQ=
X-Google-Smtp-Source: AK7set+eHoRfSH2DTpPtyrzwU+ly2GB8pWfMecLZ6SSAwjM/9Uie0c0NlUi95XZp7q87JdFil8BrBg==
X-Received: by 2002:a50:c05b:0:b0:4ab:2033:8c55 with SMTP id u27-20020a50c05b000000b004ab20338c55mr6498926edd.33.1676054652468;
        Fri, 10 Feb 2023 10:44:12 -0800 (PST)
Received: from skbuf ([188.26.185.183])
        by smtp.gmail.com with ESMTPSA id c25-20020a17090603d900b0087bd50f6986sm2749646eja.42.2023.02.10.10.44.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 10:44:12 -0800 (PST)
Date:   Fri, 10 Feb 2023 20:44:09 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     arinc9.unal@gmail.com
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Richard van Schagen <richard@routerhints.com>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, erkin.bozoglu@xeront.com
Subject: Re: [PATCH net] net: dsa: mt7530: fix CPU flooding and do not set
 CPU association
Message-ID: <20230210184409.e6ueolfdsmhqfph5@skbuf>
References: <20230210172822.12960-1-richard@routerhints.com>
 <20230210172822.12960-1-richard@routerhints.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230210172822.12960-1-richard@routerhints.com>
 <20230210172822.12960-1-richard@routerhints.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Feb 10, 2023 at 08:28:23PM +0300, arinc9.unal@gmail.com wrote:
> From: Richard van Schagen <richard@routerhints.com>
> 
> The original code only enables flooding on CPU port, on port 6, since
> that's the last one set up. In doing so, it removes flooding on port 5,
> which made so that, in order to communicate properly over port 5, a frame
> had to be sent from a user port to the DSA master. Fix this.

Separate patch for this. I don't understand the correlation with the
other part below.

FWIW, the problem can also be solved similar to 8d5f7954b7c8 ("net: dsa:
felix: break at first CPU port during init and teardown"), and both CPU
ports could be added to the flooding mask only as part of the "multiple
CPU ports" feature. When a multiple CPU ports device tree is used with a
kernel capable of a single CPU port, your patch enables flooding towards
the second CPU port, which will never be used (or up). Not sure if you
want that.

> 
> Since CPU->port is forced via the DSA tag, connecting CPU to all user ports
> of the switch breaks communication over VLAN tagged frames.

Here, I understand almost nothing from this phrase.

"CPU->port" means "association between user port and CPU port"?

You're saying that association is forced through the DSA tag? Details?
Who or what is the DSA tag? Or are you saying that packets transmitted
by tag_mtk.c are always sent as control plane, and will reach an egress
port regardless of the port matrix of the CPU port?

"Connecting CPU to all user ports" means assigning PCR_MATRIX(dsa_user_ports())
to the port matrix of the CPU port, yes? Why would that break communication
for VLAN-tagged traffic (and what is the source and destination of that
traffic)?

> Therefore, remove the code that sets CPU assocation.
> This way, the CPU reverts to not being connected to any port as soon
> as ".port_enable" is called.

Partly to blame may be the poor phrasing here. AFAICS, the port matrix
of the CPU port remains 0 throughout the lifetime of the driver. Why
mention ".port_enable"? That handles the user -> CPU direction, not the
CPU -> user direction.

> 
> [ arinc.unal@arinc9.com: Wrote subject and changelog ]
> 
> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Signed-off-by: Richard van Schagen <richard@routerhints.com>
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>

Missing Fixes: tags for patches sent to "net". Multiple problems =>
multiple patches.

> ---
>  drivers/net/dsa/mt7530.c | 17 ++++++++---------
>  1 file changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index 3a15015bc409..b5ad4b4fc00c 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -997,6 +997,7 @@ mt753x_cpu_port_enable(struct dsa_switch *ds, int port)
>  {
>  	struct mt7530_priv *priv = ds->priv;
>  	int ret;
> +	u32 val;
>  
>  	/* Setup max capability of CPU port at first */
>  	if (priv->info->cpu_port_config) {
> @@ -1009,20 +1010,15 @@ mt753x_cpu_port_enable(struct dsa_switch *ds, int port)
>  	mt7530_write(priv, MT7530_PVC_P(port),
>  		     PORT_SPEC_TAG);
>  
> -	/* Disable flooding by default */
> -	mt7530_rmw(priv, MT7530_MFC, BC_FFP_MASK | UNM_FFP_MASK | UNU_FFP_MASK,
> -		   BC_FFP(BIT(port)) | UNM_FFP(BIT(port)) | UNU_FFP(BIT(port)));
> +	/* Enable flooding on CPU */
> +	val = mt7530_read(priv, MT7530_MFC);
> +	val |= BC_FFP(BIT(port)) | UNM_FFP(BIT(port)) | UNU_FFP(BIT(port));
> +	mt7530_write(priv, MT7530_MFC, val);
>  
>  	/* Set CPU port number */
>  	if (priv->id == ID_MT7621)
>  		mt7530_rmw(priv, MT7530_MFC, CPU_MASK, CPU_EN | CPU_PORT(port));
>  
> -	/* CPU port gets connected to all user ports of
> -	 * the switch.
> -	 */
> -	mt7530_write(priv, MT7530_PCR_P(port),
> -		     PCR_MATRIX(dsa_user_ports(priv->ds)));
> -
>  	/* Set to fallback mode for independent VLAN learning */
>  	mt7530_rmw(priv, MT7530_PCR_P(port), PCR_PORT_VLAN_MASK,
>  		   MT7530_PORT_FALLBACK_MODE);
> @@ -2204,6 +2200,9 @@ mt7530_setup(struct dsa_switch *ds)
>  
>  	priv->p6_interface = PHY_INTERFACE_MODE_NA;
>  
> +	/* Disable flooding by default */
> +	mt7530_rmw(priv, MT7530_MFC, BC_FFP_MASK | UNM_FFP_MASK | UNU_FFP_MASK, 0);
> +

Shouldn't mt7531_setup() have this too?

>  	/* Enable and reset MIB counters */
>  	mt7530_mib_reset(ds);
>  
> -- 
> 2.37.2
> 

