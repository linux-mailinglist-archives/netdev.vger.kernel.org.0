Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96D0C511592
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 13:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232621AbiD0LcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 07:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232590AbiD0LcO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 07:32:14 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7630737029;
        Wed, 27 Apr 2022 04:29:01 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id b24so1559276edu.10;
        Wed, 27 Apr 2022 04:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NkJteM65W6zQPWRXCAleN3D0FlNTwOT7i0Kr6m0yEgc=;
        b=hC4TnU/qm3AqQ6GI5lr3KG3Cj5VkamVGPz+q/U1eyBScp9bw/KWsnAH8+n7A+2E3At
         ez32w2p4cC7TZSv29GvtK5mzZYK9pqNUDUx6zKC2iz1nfxsceYqKPcJhUquPKba/cBO5
         /BwxPwNpWvy4ooeuRYTMGCMQmt2sarLOWfRQb0DBS7LQM7coTG89EE1fft9ye05dADj9
         JHikId7CW/lHnk13j8vmg9QUngIMMo+Arfze530vf7rV9ygEEGGB3e75UGiUekGvJi/X
         CtiCdsVb1H2rpC9djz/6T38ag5ERSrrObBLYQDI2B7Kk8Cq5YqRpfX2IAEHRmAri8Yw3
         ZuNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NkJteM65W6zQPWRXCAleN3D0FlNTwOT7i0Kr6m0yEgc=;
        b=ErlAxFnw3M5Ot/89OGVkQbuVaWbWNUVYc70pcyJEu4KB+XcRo1RYrvC8lqsqwubDsQ
         OJhIkW+rfxvAB9ZqNGuhgSKOya9AQXdWTLDNWUfUxYH+SXg4/gSGToNwcSm5ztFKYBwI
         vdCTRfvapeiyYIdAOvx+01PzMlnERTOjODokFbtvQcenQgb0R1+MvbkgsPWdBJUkou51
         2SX0YAAkhEnU/7iiMINBA4qhpWLcOdHmwP15NP89QtDuof0JaYagEZ/Z1bD5F4+1575m
         9nPBAM4J4bolbx8mvIUsUErIgEdpgKh/gTGLRej+D1nTZjb8GbBMUqLTOL64pABO52cX
         d2uw==
X-Gm-Message-State: AOAM530fpqxc1IvVRsAkM4ty2n3eu0PSRDAu21PkD9aUaQdVHTmPJg37
        Zd6D20Q1Eoz8yOls04SSLjs=
X-Google-Smtp-Source: ABdhPJzLYggzhFJDDA2zXYNCKiXxnqxYBEgVeqOwRyJRgRoaJdh3iPZd2PqxHUdp1VRgRIQo8kZA4g==
X-Received: by 2002:a05:6402:2932:b0:425:d7b3:e0d1 with SMTP id ee50-20020a056402293200b00425d7b3e0d1mr20731767edb.141.1651058939732;
        Wed, 27 Apr 2022 04:28:59 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id h22-20020a056402281600b004206bd9d0c6sm8813509ede.8.2022.04.27.04.28.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 04:28:58 -0700 (PDT)
Date:   Wed, 27 Apr 2022 14:28:56 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Frank Wunderlich <linux@fw-web.de>
Cc:     linux-mediatek@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Frank Wunderlich <frank-w@public-files.de>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC v1 2/3] net: dsa: mt753x: make CPU-Port dynamic
Message-ID: <20220427112856.vzlxnmgm4el4yynj@skbuf>
References: <20220426134924.30372-1-linux@fw-web.de>
 <20220426134924.30372-3-linux@fw-web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426134924.30372-3-linux@fw-web.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 26, 2022 at 03:49:23PM +0200, Frank Wunderlich wrote:
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
>  drivers/net/dsa/mt7530.c | 46 ++++++++++++++++++++++------------------
>  drivers/net/dsa/mt7530.h |  2 +-
>  2 files changed, 26 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index ccf4cb944167..4789105b8137 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -1004,6 +1004,7 @@ mt753x_cpu_port_enable(struct dsa_switch *ds, int port)
>  			return ret;
>  	}
>  
> +	priv->cpu_port = port;
>  	/* Enable Mediatek header mode on the cpu port */
>  	mt7530_write(priv, MT7530_PVC_P(port),
>  		     PORT_SPEC_TAG);
> @@ -1041,7 +1042,7 @@ mt7530_port_enable(struct dsa_switch *ds, int port,
>  	 * restore the port matrix if the port is the member of a certain
>  	 * bridge.
>  	 */
> -	priv->ports[port].pm |= PCR_MATRIX(BIT(MT7530_CPU_PORT));
> +	priv->ports[port].pm |= PCR_MATRIX(BIT(priv->cpu_port));

This is called with an "int port" argument, so could you please do:

	struct dsa_port *dp = dsa_to_port(ds, port);

	if (dsa_port_is_user(dp)) {
		struct dsa_port *cpu_dp = dp->cpu_dp;

		priv->ports[port].pm |= PCR_MATRIX(BIT(cpu_dp->index));
	}

>  	priv->ports[port].enable = true;
>  	mt7530_rmw(priv, MT7530_PCR_P(port), PCR_MATRIX_MASK,
>  		   priv->ports[port].pm);
> @@ -1190,8 +1191,8 @@ mt7530_port_bridge_join(struct dsa_switch *ds, int port,
>  			struct netlink_ext_ack *extack)
>  {
>  	struct dsa_port *dp = dsa_to_port(ds, port), *other_dp;
> -	u32 port_bitmap = BIT(MT7530_CPU_PORT);
>  	struct mt7530_priv *priv = ds->priv;
> +	u32 port_bitmap = BIT(priv->cpu_port);

Here we know for certain that "port" is a user port, so could you please:

	struct dsa_port *cpu_dp = dp->cpu_dp;
	u32 port_bitmap = BIT(cpu_dp->index);

>  
>  	mutex_lock(&priv->reg_mutex);
>  
> @@ -1267,9 +1268,9 @@ mt7530_port_set_vlan_unaware(struct dsa_switch *ds, int port)
>  	 * the CPU port get out of VLAN filtering mode.
>  	 */
>  	if (all_user_ports_removed) {
> -		mt7530_write(priv, MT7530_PCR_P(MT7530_CPU_PORT),
> +		mt7530_write(priv, MT7530_PCR_P(priv->cpu_port),
>  			     PCR_MATRIX(dsa_user_ports(priv->ds)));
> -		mt7530_write(priv, MT7530_PVC_P(MT7530_CPU_PORT), PORT_SPEC_TAG
> +		mt7530_write(priv, MT7530_PVC_P(priv->cpu_port), PORT_SPEC_TAG
>  			     | PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
>  	}
>  }

Same idea here, go through dp->cpu_dp.

> @@ -1335,8 +1336,8 @@ mt7530_port_bridge_leave(struct dsa_switch *ds, int port,
>  	 */
>  	if (priv->ports[port].enable)
>  		mt7530_rmw(priv, MT7530_PCR_P(port), PCR_MATRIX_MASK,
> -			   PCR_MATRIX(BIT(MT7530_CPU_PORT)));
> -	priv->ports[port].pm = PCR_MATRIX(BIT(MT7530_CPU_PORT));
> +			   PCR_MATRIX(BIT(priv->cpu_port)));
> +	priv->ports[port].pm = PCR_MATRIX(BIT(priv->cpu_port));

Same.

>  
>  	/* When a port is removed from the bridge, the port would be set up
>  	 * back to the default as is at initial boot which is a VLAN-unaware
> @@ -1503,6 +1504,7 @@ static int
>  mt7530_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
>  			   struct netlink_ext_ack *extack)
>  {
> +	struct mt7530_priv *priv = ds->priv;
>  	if (vlan_filtering) {
>  		/* The port is being kept as VLAN-unaware port when bridge is
>  		 * set up with vlan_filtering not being set, Otherwise, the
> @@ -1510,7 +1512,7 @@ mt7530_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
>  		 * for becoming a VLAN-aware port.
>  		 */
>  		mt7530_port_set_vlan_aware(ds, port);
> -		mt7530_port_set_vlan_aware(ds, MT7530_CPU_PORT);
> +		mt7530_port_set_vlan_aware(ds, priv->cpu_port);
>  	} else {
>  		mt7530_port_set_vlan_unaware(ds, port);
>  	}

Same.

> @@ -1526,7 +1528,7 @@ mt7530_hw_vlan_add(struct mt7530_priv *priv,
>  	u32 val;
>  
>  	new_members = entry->old_members | BIT(entry->port) |
> -		      BIT(MT7530_CPU_PORT);
> +		      BIT(priv->cpu_port);
>  
>  	/* Validate the entry with independent learning, create egress tag per
>  	 * VLAN and joining the port as one of the port members.
> @@ -1550,8 +1552,8 @@ mt7530_hw_vlan_add(struct mt7530_priv *priv,
>  	 * DSA tag.
>  	 */
>  	mt7530_rmw(priv, MT7530_VAWD2,
> -		   ETAG_CTRL_P_MASK(MT7530_CPU_PORT),
> -		   ETAG_CTRL_P(MT7530_CPU_PORT,
> +		   ETAG_CTRL_P_MASK(priv->cpu_port),
> +		   ETAG_CTRL_P(priv->cpu_port,
>  			       MT7530_VLAN_EGRESS_STACK));
>  }

This one is interesting. For some reason, the driver author felt the
need to explicitly add BIT(MT7530_CPU_PORT) to new_members, even though
mt7530_port_vlan_add() will be called on the CPU port too

bridge vlan add dev swp0 vid 100
bridge vlan add dev br0 vid 100 self		# here

I would first make a patch that leaves it up to DSA to call
port_vlan_add for the CPU port, rather than doing it implicitly.
There is a certain advantage to that too. You can do autonomous
forwarding in a certain VLAN, but not add br0 to that VLAN, and then,
you could avoid flooding the CPU with those packets, if you know that
software doesn't need to process them.

The modified function would look like this:

static void
mt7530_hw_vlan_add(struct mt7530_priv *priv,
		   struct mt7530_hw_vlan_entry *entry)
{
	struct dsa_port *dp = dsa_to_port(priv->ds, entry->port);
	u8 new_members;
	u32 val;

	new_members = entry->old_members | BIT(entry->port);

	/* Validate the entry with independent learning, create egress tag per
	 * VLAN and joining the port as one of the port members.
	 */
	val = IVL_MAC | VTAG_EN | PORT_MEM(new_members) | FID(FID_BRIDGED) |
	      VLAN_VALID;
	mt7530_write(priv, MT7530_VAWD1, val);

	/* Decide whether adding tag or not for those outgoing packets from the
	 * port inside the VLAN.
	 * CPU port is always taken as a tagged port for serving more than one
	 * VLANs across and also being applied with egress type stack mode for
	 * that VLAN tags would be appended after hardware special tag used as
	 * DSA tag.
	 */
	if (dsa_port_is_cpu(dp))
		val = MT7530_VLAN_EGRESS_STACK;
	else if (entry->untagged)
		val = MT7530_VLAN_EGRESS_UNTAG;
	else
		val = MT7530_VLAN_EGRESS_TAG;
	mt7530_rmw(priv, MT7530_VAWD2,
		   ETAG_CTRL_P_MASK(entry->port),
		   ETAG_CTRL_P(entry->port, val));
}

Then please confirm that there aren't regressions in local traffic
termination for a VLAN-aware bridge. Pinging over a bridge with
vlan_filtering=1 should be sufficient, since that is done in the default
pvid of 1.

With this change, you no longer need to concern yourself about the fixed
value of MT7530_CPU_PORT.

>  
> @@ -1575,7 +1577,7 @@ mt7530_hw_vlan_del(struct mt7530_priv *priv,
>  	 * the entry would be kept valid. Otherwise, the entry is got to be
>  	 * disabled.
>  	 */
> -	if (new_members && new_members != BIT(MT7530_CPU_PORT)) {
> +	if (new_members && new_members != BIT(priv->cpu_port)) {
>  		val = IVL_MAC | VTAG_EN | PORT_MEM(new_members) |
>  		      VLAN_VALID;
>  		mt7530_write(priv, MT7530_VAWD1, val);

Here the logic is again too convoluted for its own good. Let's think
before changing.

What I think was happening was this. DSA used to be super blind when
adding a VLAN to the CPU port. Since there is no netdev for the CPU
port, then what DSA used to do was to implicitly program a bridge VLAN to
the CPU port whenever that VLAN was programmed on a user port. The
downside is that you never know when you can remove that VLAN, since the
CPU port is shared between multiple user ports and refcounting was
impossible due to technical switchdev API details.

Here, the mt7530 driver tries to outsmart DSA by saying "hey, if the CPU
port is the only remaining member of the VLAN, this VLAN is garbage,
let's remove it". Which, I mean, fair point.

But since commit 134ef2388e7f ("net: dsa: add explicit support for host
bridge VLANs"), DSA does a better job of keeping track of VLANs added on
CPU ports, and it doesn't leave dangling VLANs behind. You need to trust it.

So in this case, you would have to change the code like this:

	if (new_members) {
		val = IVL_MAC | VTAG_EN | PORT_MEM(new_members) |
		      VLAN_VALID;
		mt7530_write(priv, MT7530_VAWD1, val);
	} else {
		mt7530_write(priv, MT7530_VAWD1, 0);
		mt7530_write(priv, MT7530_VAWD2, 0);
	}

and then delete the comment, it isn't relevant any longer.

> @@ -2105,7 +2107,7 @@ mt7530_setup(struct dsa_switch *ds)
>  	 * controller also is the container for two GMACs nodes representing
>  	 * as two netdev instances.
>  	 */
> -	dn = dsa_to_port(ds, MT7530_CPU_PORT)->master->dev.of_node->parent;
> +	dn = dsa_to_port(ds, priv->cpu_port)->master->dev.of_node->parent;

Holy ####, this is convoluted. This gets us the OF node of the container
of the DSA master, alright.

Could you do something more generic? Something like this:

	struct device_node *dn = NULL;
	struct dsa_port *cpu_dp;

	dsa_switch_for_each_cpu_port(cpu_dp, ds) {
		dn = cpu_dp->master->dev.of_node->parent;
		/* It doesn't matter which CPU port is found first,
		 * their masters should share the same parent OF node
		 */
		break;
	}

	if (!dn) {
		ERROR ERROR ERROR, no CPU port
	}

>  	ds->assisted_learning_on_cpu_port = true;
>  	ds->mtu_enforcement_ingress = true;
>  
> @@ -2337,15 +2339,6 @@ mt7531_setup(struct dsa_switch *ds)
>  	mt7531_ind_c45_phy_write(priv, MT753X_CTRL_PHY_ADDR, MDIO_MMD_VEND2,
>  				 CORE_PLL_GROUP4, val);
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
>  	for (i = 0; i < MT7530_NUM_PORTS; i++) {
>  		/* Disable forwarding by default on all ports */
>  		mt7530_rmw(priv, MT7530_PCR_P(i), PCR_MATRIX_MASK,
> @@ -2373,6 +2366,15 @@ mt7531_setup(struct dsa_switch *ds)
>  			   PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
>  	}
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
>  	/* Setup VLAN ID 0 for VLAN-unaware bridges */
>  	ret = mt7530_setup_vlan0(priv);
>  	if (ret)
> @@ -3213,6 +3215,8 @@ mt7530_probe(struct mdio_device *mdiodev)
>  	if (!priv)
>  		return -ENOMEM;
>  
> +	priv->cpu_port = 6;
> +
>  	priv->ds = devm_kzalloc(&mdiodev->dev, sizeof(*priv->ds), GFP_KERNEL);
>  	if (!priv->ds)
>  		return -ENOMEM;
> diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
> index 91508e2feef9..62df8d10f6d4 100644
> --- a/drivers/net/dsa/mt7530.h
> +++ b/drivers/net/dsa/mt7530.h
> @@ -8,7 +8,6 @@
>  
>  #define MT7530_NUM_PORTS		7
>  #define MT7530_NUM_PHYS			5
> -#define MT7530_CPU_PORT			6
>  #define MT7530_NUM_FDB_RECORDS		2048
>  #define MT7530_ALL_MEMBERS		0xff
>  
> @@ -823,6 +822,7 @@ struct mt7530_priv {
>  	u8			mirror_tx;
>  
>  	struct mt7530_port	ports[MT7530_NUM_PORTS];
> +	int			cpu_port;

And this should no longer be needed.

>  	/* protect among processes for registers access*/
>  	struct mutex reg_mutex;
>  	int irq;
> -- 
> 2.25.1
> 

