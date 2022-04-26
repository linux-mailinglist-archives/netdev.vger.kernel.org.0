Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC7E51021F
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 17:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352480AbiDZPse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 11:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352481AbiDZPsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 11:48:31 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2AE912AFB;
        Tue, 26 Apr 2022 08:45:22 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id c12so30581610plr.6;
        Tue, 26 Apr 2022 08:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=xu8vZlRwQ3tIBZgu9W5je38lqnNS6mBhPAIYzgfxDUw=;
        b=SGoh+VAqipMK2ox3PHPwV37PdR/UMVsUgA7+1p//vrSoOR6LUPviqG34C8V4+BJ/1h
         wHNnKmBpQgnEzOcJyX1/cFQMOLW1/n4G4klGomjDUjgNiIcjkLn8Z5hkivmxLKkDBQFC
         B4waFVyUU2AaD0tPMUt10JeX9dBBH2TP/82AyU1LFzT30ZGG5IXPzQQRekDLROIXnTpL
         EY9owZNtNZfa0EfVfBEMBsMNBXAiQEprhNoqtsqoUBMMQsgEc+euOQvCWR6Tn89B5Jc0
         b2df2Y6z+RieG0VsphMfx6rXNSpLIQNzt/z3xSuOLy3OakYJxGQZkNMyoaxp5+YaoMZw
         /wUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xu8vZlRwQ3tIBZgu9W5je38lqnNS6mBhPAIYzgfxDUw=;
        b=PiUIIIzgj3UxOOZJj43nGjLaYjtu1/I3KDYNXTSSvr19cOKfO1NNKg6f7oUvS4UV3e
         kaEnE2E7J1odh04SLrfNmG+BO83OJegV8kuhBQU1wuHMYb74+NhCerXB+b8ZVY6pzj7I
         gd/tnshP6QRIkQDU6SjQ2CXWs7N61urM8XxadIxi6YRBH3cVNTJxnnLgcJeFOfYDNg4P
         nsZj3noFW6zvcgowCjIheEqYU9WfFVHYEVMOZWqg/jXjvlsAy/e0bXSqFpxxrR6R9JjD
         rNNHmkOhBw3zWh/DCn9ugkwH+UIq+xxxPORLV7Ubz7QP57T7j5PIy/RLGmS8LUrdQdCP
         yY5g==
X-Gm-Message-State: AOAM530vVJtTwNGu59/3T2SkQWwqbqC1eECKSR+JzfnLX0J5GczFanBO
        CjTmxm6fAGXfM5yMKZR4k7k=
X-Google-Smtp-Source: ABdhPJzsQFjPYOSt9aJIDyYEraxAJfexGOhLplqqhr9/0v6giyJc2nNYhU+K5Upi9wVDIw69rJAcag==
X-Received: by 2002:a17:90a:4a95:b0:1d8:2918:7065 with SMTP id f21-20020a17090a4a9500b001d829187065mr25303001pjh.117.1650987921530;
        Tue, 26 Apr 2022 08:45:21 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id gw19-20020a17090b0a5300b001d97f7fca06sm4114181pjb.24.2022.04.26.08.45.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Apr 2022 08:45:21 -0700 (PDT)
Message-ID: <046a334b-d972-6ab9-5127-f845cef72751@gmail.com>
Date:   Tue, 26 Apr 2022 08:45:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC v1 2/3] net: dsa: mt753x: make CPU-Port dynamic
Content-Language: en-US
To:     Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220426134924.30372-1-linux@fw-web.de>
 <20220426134924.30372-3-linux@fw-web.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220426134924.30372-3-linux@fw-web.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/26/22 06:49, Frank Wunderlich wrote:
> From: Frank Wunderlich <frank-w@public-files.de>
> 
> Currently CPU-Port is hardcoded to Port 6.
> 
> On BPI-R2-Pro board this port is not connected and only Port 5 is
> connected to gmac of SoC.
> 
> Replace this hardcoded CPU-Port with a member in mt7530_priv struct
> which is set in mt753x_cpu_port_enable to the right port.
> 
> I defined a default in probe (in case no CPU-Port will be setup) and
> if both cpu-port were setup port 6 will be used like the const prior
> this patch.
> 
> In mt7531_setup first access is before we know which port should be used
> (mt753x_cpu_port_enable) so section "BPDU to CPU port" needs to be moved
> down.
> 
> Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
> ---
>   drivers/net/dsa/mt7530.c | 46 ++++++++++++++++++++++------------------
>   drivers/net/dsa/mt7530.h |  2 +-
>   2 files changed, 26 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index ccf4cb944167..4789105b8137 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -1004,6 +1004,7 @@ mt753x_cpu_port_enable(struct dsa_switch *ds, int port)
>   			return ret;
>   	}
>   
> +	priv->cpu_port = port;
>   	/* Enable Mediatek header mode on the cpu port */
>   	mt7530_write(priv, MT7530_PVC_P(port),
>   		     PORT_SPEC_TAG);
> @@ -1041,7 +1042,7 @@ mt7530_port_enable(struct dsa_switch *ds, int port,
>   	 * restore the port matrix if the port is the member of a certain
>   	 * bridge.
>   	 */
> -	priv->ports[port].pm |= PCR_MATRIX(BIT(MT7530_CPU_PORT));
> +	priv->ports[port].pm |= PCR_MATRIX(BIT(priv->cpu_port));
>   	priv->ports[port].enable = true;
>   	mt7530_rmw(priv, MT7530_PCR_P(port), PCR_MATRIX_MASK,
>   		   priv->ports[port].pm);
> @@ -1190,8 +1191,8 @@ mt7530_port_bridge_join(struct dsa_switch *ds, int port,
>   			struct netlink_ext_ack *extack)
>   {
>   	struct dsa_port *dp = dsa_to_port(ds, port), *other_dp;
> -	u32 port_bitmap = BIT(MT7530_CPU_PORT);
>   	struct mt7530_priv *priv = ds->priv;
> +	u32 port_bitmap = BIT(priv->cpu_port);

No need to re-order these two lines.

>   
>   	mutex_lock(&priv->reg_mutex);
>   
> @@ -1267,9 +1268,9 @@ mt7530_port_set_vlan_unaware(struct dsa_switch *ds, int port)
>   	 * the CPU port get out of VLAN filtering mode.
>   	 */
>   	if (all_user_ports_removed) {
> -		mt7530_write(priv, MT7530_PCR_P(MT7530_CPU_PORT),
> +		mt7530_write(priv, MT7530_PCR_P(priv->cpu_port),
>   			     PCR_MATRIX(dsa_user_ports(priv->ds)));
> -		mt7530_write(priv, MT7530_PVC_P(MT7530_CPU_PORT), PORT_SPEC_TAG
> +		mt7530_write(priv, MT7530_PVC_P(priv->cpu_port), PORT_SPEC_TAG
>   			     | PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
>   	}
>   }
> @@ -1335,8 +1336,8 @@ mt7530_port_bridge_leave(struct dsa_switch *ds, int port,
>   	 */
>   	if (priv->ports[port].enable)
>   		mt7530_rmw(priv, MT7530_PCR_P(port), PCR_MATRIX_MASK,
> -			   PCR_MATRIX(BIT(MT7530_CPU_PORT)));
> -	priv->ports[port].pm = PCR_MATRIX(BIT(MT7530_CPU_PORT));
> +			   PCR_MATRIX(BIT(priv->cpu_port)));
> +	priv->ports[port].pm = PCR_MATRIX(BIT(priv->cpu_port));
>   
>   	/* When a port is removed from the bridge, the port would be set up
>   	 * back to the default as is at initial boot which is a VLAN-unaware
> @@ -1503,6 +1504,7 @@ static int
>   mt7530_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
>   			   struct netlink_ext_ack *extack)
>   {
> +	struct mt7530_priv *priv = ds->priv;

Add a space to separate declaration from code.

>   	if (vlan_filtering) {
>   		/* The port is being kept as VLAN-unaware port when bridge is
>   		 * set up with vlan_filtering not being set, Otherwise, the
> @@ -1510,7 +1512,7 @@ mt7530_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
>   		 * for becoming a VLAN-aware port.
>   		 */
>   		mt7530_port_set_vlan_aware(ds, port);
> -		mt7530_port_set_vlan_aware(ds, MT7530_CPU_PORT);
> +		mt7530_port_set_vlan_aware(ds, priv->cpu_port);
>   	} else {
>   		mt7530_port_set_vlan_unaware(ds, port);
>   	}
> @@ -1526,7 +1528,7 @@ mt7530_hw_vlan_add(struct mt7530_priv *priv,
>   	u32 val;
>   
>   	new_members = entry->old_members | BIT(entry->port) |
> -		      BIT(MT7530_CPU_PORT);
> +		      BIT(priv->cpu_port);
>   
>   	/* Validate the entry with independent learning, create egress tag per
>   	 * VLAN and joining the port as one of the port members.
> @@ -1550,8 +1552,8 @@ mt7530_hw_vlan_add(struct mt7530_priv *priv,
>   	 * DSA tag.
>   	 */
>   	mt7530_rmw(priv, MT7530_VAWD2,
> -		   ETAG_CTRL_P_MASK(MT7530_CPU_PORT),
> -		   ETAG_CTRL_P(MT7530_CPU_PORT,
> +		   ETAG_CTRL_P_MASK(priv->cpu_port),
> +		   ETAG_CTRL_P(priv->cpu_port,
>   			       MT7530_VLAN_EGRESS_STACK));
>   }
>   
> @@ -1575,7 +1577,7 @@ mt7530_hw_vlan_del(struct mt7530_priv *priv,
>   	 * the entry would be kept valid. Otherwise, the entry is got to be
>   	 * disabled.
>   	 */
> -	if (new_members && new_members != BIT(MT7530_CPU_PORT)) {
> +	if (new_members && new_members != BIT(priv->cpu_port)) {
>   		val = IVL_MAC | VTAG_EN | PORT_MEM(new_members) |
>   		      VLAN_VALID;
>   		mt7530_write(priv, MT7530_VAWD1, val);
> @@ -2105,7 +2107,7 @@ mt7530_setup(struct dsa_switch *ds)
>   	 * controller also is the container for two GMACs nodes representing
>   	 * as two netdev instances.
>   	 */
> -	dn = dsa_to_port(ds, MT7530_CPU_PORT)->master->dev.of_node->parent;
> +	dn = dsa_to_port(ds, priv->cpu_port)->master->dev.of_node->parent;
>   	ds->assisted_learning_on_cpu_port = true;
>   	ds->mtu_enforcement_ingress = true;
>   
> @@ -2337,15 +2339,6 @@ mt7531_setup(struct dsa_switch *ds)
>   	mt7531_ind_c45_phy_write(priv, MT753X_CTRL_PHY_ADDR, MDIO_MMD_VEND2,
>   				 CORE_PLL_GROUP4, val);
>   
> -	/* BPDU to CPU port */
> -	mt7530_rmw(priv, MT7531_CFC, MT7531_CPU_PMAP_MASK,
> -		   BIT(MT7530_CPU_PORT));
> -	mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
> -		   MT753X_BPDU_CPU_ONLY);
> -
> -	/* Enable and reset MIB counters */
> -	mt7530_mib_reset(ds);
> -
>   	for (i = 0; i < MT7530_NUM_PORTS; i++) {
>   		/* Disable forwarding by default on all ports */
>   		mt7530_rmw(priv, MT7530_PCR_P(i), PCR_MATRIX_MASK,
> @@ -2373,6 +2366,15 @@ mt7531_setup(struct dsa_switch *ds)
>   			   PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
>   	}
>   
> +	/* BPDU to CPU port */
> +	mt7530_rmw(priv, MT7531_CFC, MT7531_CPU_PMAP_MASK,
> +		   BIT(priv->cpu_port));
> +	mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
> +		   MT753X_BPDU_CPU_ONLY);
> +
> +	/* Enable and reset MIB counters */
> +	mt7530_mib_reset(ds);
> +
>   	/* Setup VLAN ID 0 for VLAN-unaware bridges */
>   	ret = mt7530_setup_vlan0(priv);
>   	if (ret)
> @@ -3213,6 +3215,8 @@ mt7530_probe(struct mdio_device *mdiodev)
>   	if (!priv)
>   		return -ENOMEM;
>   
> +	priv->cpu_port = 6;
> +
>   	priv->ds = devm_kzalloc(&mdiodev->dev, sizeof(*priv->ds), GFP_KERNEL);
>   	if (!priv->ds)
>   		return -ENOMEM;
> diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
> index 91508e2feef9..62df8d10f6d4 100644
> --- a/drivers/net/dsa/mt7530.h
> +++ b/drivers/net/dsa/mt7530.h
> @@ -8,7 +8,6 @@
>   
>   #define MT7530_NUM_PORTS		7
>   #define MT7530_NUM_PHYS			5
> -#define MT7530_CPU_PORT			6

We could have kept this define and rename it MT7530_DEFAULT_CPU_PORT or 
something and in m7530_probe() use that newly renamed constant to 
illustrate that we have a default value assigned, just in case.

>   #define MT7530_NUM_FDB_RECORDS		2048
>   #define MT7530_ALL_MEMBERS		0xff
>   
> @@ -823,6 +822,7 @@ struct mt7530_priv {
>   	u8			mirror_tx;
>   
>   	struct mt7530_port	ports[MT7530_NUM_PORTS];
> +	int			cpu_port;

This can be an unsigned integer since you do not assign negative values. 
With that fixes, this looks good to me.
-- 
Florian
