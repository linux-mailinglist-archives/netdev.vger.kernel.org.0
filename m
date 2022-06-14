Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10EAF54AB7D
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 10:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbiFNIPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 04:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiFNIP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 04:15:29 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC293F899;
        Tue, 14 Jun 2022 01:15:27 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id v19so10493202edd.4;
        Tue, 14 Jun 2022 01:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NJkhEHqFT06HHswMPiYd0nxYY448wV+uSdhje8Y1/Ok=;
        b=Mg+8SysLtGNO129kkYQ5bUWUJLi2pQEsHLd9GCnmN21aYuWMen+nXjvVMt1xj9Q7ac
         +t9ciruWjwZ9lxWYUW5YFYUi8oGqx6nrtaTWJQZKWQWOkIwBkaOS/N4k6pX275YGWPaS
         Ywwy1TAFlnQAD12z42Xvo6mnZvF7gFuIPdwZAm/oKZdGC+9fRDxCr+Ak07esMh7OupXr
         GnLTKnqa0geEnLmJmvoxsg9M8tuJnG08t+WajefQQ771Q4pQeyQ1qzeFE9D287mnJhM6
         qeIjTueGVkazdbnKJYhNf93sa+VtG/JD9+Ef6SNVVqi6jL+HR0rdCm+IEG7qvfr08ovd
         5StQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NJkhEHqFT06HHswMPiYd0nxYY448wV+uSdhje8Y1/Ok=;
        b=lGHvcqs+rNfMdxRXgSInsX8BaXtKbrPFOcuKA8Ge0/aFhrcQgakoeE4JWchSGZdAIw
         OHwdKtjUWcwtpIQU1fp7W4UA0uN9TbAwPAlIlIU2df6QpMKqnORJDSLbOpxMI70HqaOK
         5qOwXA4N96NzLyYe+EPWHL2DyAbNAzIjWfY7kuHTP2xHDpjXvSJGdnaZsQm0knSj1PK4
         C/d38cNNP2nYMxUJbJ69PvILWFZRzgPbx0b4VHF+2yO+ogIMZkr9Nd8KEOnW11fKjmLm
         PHFF3SPyAUtie1pdtqAR0q3j5VUdGOsSS3wlx/V+GL6syWUFrp2l5g7UK1GH44j7LFvJ
         nMIw==
X-Gm-Message-State: AOAM530dBFUSz9NlKn3kQ9wLqiyhyrp/QtnyPVaTXlvT5wn59oSwyJ3w
        /4uW8cL1JEUUw/mMF0t0s3s=
X-Google-Smtp-Source: AGRyM1ublbbNk+NjfF2PDhw2FRBf63PMhIwPgMjIWP4K+zGw5SLgg3qnAccbBwWdTH2YSXtKUY+6kw==
X-Received: by 2002:a05:6402:528f:b0:42a:c778:469e with SMTP id en15-20020a056402528f00b0042ac778469emr4274661edb.404.1655194525994;
        Tue, 14 Jun 2022 01:15:25 -0700 (PDT)
Received: from skbuf ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id p8-20020a056402500800b0042dc0181307sm6485254eda.93.2022.06.14.01.15.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 01:15:25 -0700 (PDT)
Date:   Tue, 14 Jun 2022 11:15:23 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [RFC Patch net-next v2 10/15] net: dsa: microchip: move the
 setup, get_phy_flags & mtu to ksz_common
Message-ID: <20220614081523.wseqxqw576nyzerh@skbuf>
References: <20220530104257.21485-1-arun.ramadoss@microchip.com>
 <20220530104257.21485-11-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220530104257.21485-11-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 30, 2022 at 04:12:52PM +0530, Arun Ramadoss wrote:
> This patch assigns the .setup, get_phy_flags & mtu  hook of ksz8795 and
> ksz9477 in dsa_switch_ops to ksz_common. And the individual switches
> setup implementations are called based on the ksz_dev_ops.  For
> get_phy_flags hooks,checks whether the chip is ksz8863/kss8793 then it
> returns error for port1.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---
>  drivers/net/dsa/microchip/ksz8795.c    | 17 ++-------
>  drivers/net/dsa/microchip/ksz9477.c    | 14 ++++----
>  drivers/net/dsa/microchip/ksz_common.c | 50 ++++++++++++++++++++++++++
>  drivers/net/dsa/microchip/ksz_common.h |  7 ++++
>  4 files changed, 68 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
> index 528de481b319..1058b6883caa 100644
> --- a/drivers/net/dsa/microchip/ksz8795.c
> +++ b/drivers/net/dsa/microchip/ksz8795.c
> @@ -898,18 +898,6 @@ static void ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
>  	}
>  }
>  
> -static u32 ksz8_sw_get_phy_flags(struct dsa_switch *ds, int port)
> -{
> -	/* Silicon Errata Sheet (DS80000830A):
> -	 * Port 1 does not work with LinkMD Cable-Testing.
> -	 * Port 1 does not respond to received PAUSE control frames.
> -	 */
> -	if (!port)
> -		return MICREL_KSZ8_P1_ERRATA;
> -
> -	return 0;
> -}
> -
>  static void ksz8_cfg_port_member(struct ksz_device *dev, int port, u8 member)
>  {
>  	u8 data;
> @@ -1476,8 +1464,8 @@ static void ksz8_get_caps(struct ksz_device *dev, int port,
>  
>  static const struct dsa_switch_ops ksz8_switch_ops = {
>  	.get_tag_protocol	= ksz_get_tag_protocol,
> -	.get_phy_flags		= ksz8_sw_get_phy_flags,
> -	.setup			= ksz8_setup,
> +	.get_phy_flags		= ksz_get_phy_flags,
> +	.setup			= ksz_setup,
>  	.phy_read		= ksz_phy_read16,
>  	.phy_write		= ksz_phy_write16,
>  	.phylink_get_caps	= ksz_phylink_get_caps,
> @@ -1544,6 +1532,7 @@ static void ksz8_switch_exit(struct ksz_device *dev)
>  }
>  
>  static const struct ksz_dev_ops ksz8_dev_ops = {
> +	.setup = ksz8_setup,
>  	.get_port_addr = ksz8_get_port_addr,
>  	.cfg_port_member = ksz8_cfg_port_member,
>  	.flush_dyn_mac_table = ksz8_flush_dyn_mac_table,
> diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
> index d70e0c32b309..d7474d9d4384 100644
> --- a/drivers/net/dsa/microchip/ksz9477.c
> +++ b/drivers/net/dsa/microchip/ksz9477.c
> @@ -47,9 +47,8 @@ static void ksz9477_port_cfg32(struct ksz_device *dev, int port, int offset,
>  			   bits, set ? bits : 0);
>  }
>  
> -static int ksz9477_change_mtu(struct dsa_switch *ds, int port, int mtu)
> +static int ksz9477_change_mtu(struct ksz_device *dev, int port, int mtu)
>  {
> -	struct ksz_device *dev = ds->priv;
>  	u16 frame_size, max_frame = 0;
>  	int i;
>  
> @@ -65,7 +64,7 @@ static int ksz9477_change_mtu(struct dsa_switch *ds, int port, int mtu)
>  				  REG_SW_MTU_MASK, max_frame);
>  }
>  
> -static int ksz9477_max_mtu(struct dsa_switch *ds, int port)
> +static int ksz9477_max_mtu(struct ksz_device *dev, int port)
>  {
>  	return KSZ9477_MAX_FRAME_SIZE - VLAN_ETH_HLEN - ETH_FCS_LEN;
>  }
> @@ -1296,7 +1295,7 @@ static int ksz9477_setup(struct dsa_switch *ds)
>  
>  static const struct dsa_switch_ops ksz9477_switch_ops = {
>  	.get_tag_protocol	= ksz_get_tag_protocol,
> -	.setup			= ksz9477_setup,
> +	.setup			= ksz_setup,
>  	.phy_read		= ksz_phy_read16,
>  	.phy_write		= ksz_phy_write16,
>  	.phylink_mac_link_down	= ksz_mac_link_down,
> @@ -1320,8 +1319,8 @@ static const struct dsa_switch_ops ksz9477_switch_ops = {
>  	.port_mirror_add	= ksz_port_mirror_add,
>  	.port_mirror_del	= ksz_port_mirror_del,
>  	.get_stats64		= ksz_get_stats64,
> -	.port_change_mtu	= ksz9477_change_mtu,
> -	.port_max_mtu		= ksz9477_max_mtu,
> +	.port_change_mtu	= ksz_change_mtu,
> +	.port_max_mtu		= ksz_max_mtu,
>  };
>  
>  static u32 ksz9477_get_port_addr(int port, int offset)
> @@ -1382,6 +1381,7 @@ static void ksz9477_switch_exit(struct ksz_device *dev)
>  }
>  
>  static const struct ksz_dev_ops ksz9477_dev_ops = {
> +	.setup = ksz9477_setup,
>  	.get_port_addr = ksz9477_get_port_addr,
>  	.cfg_port_member = ksz9477_cfg_port_member,
>  	.flush_dyn_mac_table = ksz9477_flush_dyn_mac_table,
> @@ -1405,6 +1405,8 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
>  	.fdb_del = ksz9477_fdb_del,
>  	.mdb_add = ksz9477_mdb_add,
>  	.mdb_del = ksz9477_mdb_del,
> +	.change_mtu = ksz9477_change_mtu,
> +	.max_mtu = ksz9477_max_mtu,
>  	.shutdown = ksz9477_reset_switch,
>  	.init = ksz9477_switch_init,
>  	.exit = ksz9477_switch_exit,
> diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
> index 8f79ff1ac648..19f8e492d3aa 100644
> --- a/drivers/net/dsa/microchip/ksz_common.c
> +++ b/drivers/net/dsa/microchip/ksz_common.c
> @@ -16,6 +16,7 @@
>  #include <linux/if_bridge.h>
>  #include <linux/of_device.h>
>  #include <linux/of_net.h>
> +#include <linux/micrel_phy.h>
>  #include <net/dsa.h>
>  #include <net/switchdev.h>
>  
> @@ -593,6 +594,14 @@ static void ksz_update_port_member(struct ksz_device *dev, int port)
>  	dev->dev_ops->cfg_port_member(dev, port, port_member | cpu_port);
>  }
>  
> +int ksz_setup(struct dsa_switch *ds)
> +{
> +	struct ksz_device *dev = ds->priv;
> +
> +	return dev->dev_ops->setup(ds);
> +}
> +EXPORT_SYMBOL_GPL(ksz_setup);

I see these changes as being of questionable value if you do not plan to
actually share some code between ->setup implementations. What would be
desirable is if ksz_common.c decides what to do, and ksz8795.c /
ksz9477.c only offer the implementations for fine-grained dev_ops.
Currently there is code that can be reused between the setup functions
of the 2 drivers, but also there is some divergence in configuration
which doesn't have its place (10% rate limit for broadcast storm
protection in ksz8795?). The goal should be for individual switch
drivers to not apply configuration behind the curtains as much as possible.

> +
>  static void port_r_cnt(struct ksz_device *dev, int port)
>  {
>  	struct ksz_port_mib *mib = &dev->ports[port].mib;
> @@ -692,6 +701,23 @@ int ksz_phy_write16(struct dsa_switch *ds, int addr, int reg, u16 val)
>  }
>  EXPORT_SYMBOL_GPL(ksz_phy_write16);
>  
> +u32 ksz_get_phy_flags(struct dsa_switch *ds, int port)
> +{
> +	struct ksz_device *dev = ds->priv;
> +
> +	if (dev->chip_id == KSZ8830_CHIP_ID) {
> +		/* Silicon Errata Sheet (DS80000830A):
> +		 * Port 1 does not work with LinkMD Cable-Testing.
> +		 * Port 1 does not respond to received PAUSE control frames.
> +		 */
> +		if (!port)
> +			return MICREL_KSZ8_P1_ERRATA;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(ksz_get_phy_flags);
> +
>  void ksz_mac_link_down(struct dsa_switch *ds, int port, unsigned int mode,
>  		       phy_interface_t interface)
>  {
> @@ -981,6 +1007,30 @@ void ksz_port_mirror_del(struct dsa_switch *ds, int port,
>  }
>  EXPORT_SYMBOL_GPL(ksz_port_mirror_del);
>  
> +int ksz_change_mtu(struct dsa_switch *ds, int port, int mtu)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	int ret = -EOPNOTSUPP;
> +
> +	if (dev->dev_ops->change_mtu)
> +		ret = dev->dev_ops->change_mtu(dev, port, mtu);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(ksz_change_mtu);
> +
> +int ksz_max_mtu(struct dsa_switch *ds, int port)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	int ret = -EOPNOTSUPP;
> +
> +	if (dev->dev_ops->max_mtu)
> +		ret = dev->dev_ops->max_mtu(dev, port);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(ksz_max_mtu);
> +
>  static int ksz_switch_detect(struct ksz_device *dev)
>  {
>  	u8 id1, id2;
> diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
> index 133b1a257868..f7275c4f633a 100644
> --- a/drivers/net/dsa/microchip/ksz_common.h
> +++ b/drivers/net/dsa/microchip/ksz_common.h
> @@ -161,6 +161,7 @@ struct alu_struct {
>  };
>  
>  struct ksz_dev_ops {
> +	int (*setup)(struct dsa_switch *ds);
>  	u32 (*get_port_addr)(int port, int offset);
>  	void (*cfg_port_member)(struct ksz_device *dev, int port, u8 member);
>  	void (*flush_dyn_mac_table)(struct ksz_device *dev, int port);
> @@ -207,6 +208,8 @@ struct ksz_dev_ops {
>  	int (*get_stp_reg)(void);
>  	void (*get_caps)(struct ksz_device *dev, int port,
>  			 struct phylink_config *config);
> +	int (*change_mtu)(struct ksz_device *dev, int port, int mtu);
> +	int (*max_mtu)(struct ksz_device *dev, int port);
>  	void (*freeze_mib)(struct ksz_device *dev, int port, bool freeze);
>  	void (*port_init_cnt)(struct ksz_device *dev, int port);
>  	int (*shutdown)(struct ksz_device *dev);
> @@ -232,8 +235,10 @@ extern const struct ksz_chip_data ksz_switch_chips[];
>  
>  /* Common DSA access functions */
>  
> +int ksz_setup(struct dsa_switch *ds);
>  int ksz_phy_read16(struct dsa_switch *ds, int addr, int reg);
>  int ksz_phy_write16(struct dsa_switch *ds, int addr, int reg, u16 val);
> +u32 ksz_get_phy_flags(struct dsa_switch *ds, int port);
>  void ksz_mac_link_down(struct dsa_switch *ds, int port, unsigned int mode,
>  		       phy_interface_t interface);
>  int ksz_sset_count(struct dsa_switch *ds, int port, int sset);
> @@ -274,6 +279,8 @@ int ksz_port_mirror_add(struct dsa_switch *ds, int port,
>  			bool ingress, struct netlink_ext_ack *extack);
>  void ksz_port_mirror_del(struct dsa_switch *ds, int port,
>  			 struct dsa_mall_mirror_tc_entry *mirror);
> +int ksz_change_mtu(struct dsa_switch *ds, int port, int mtu);
> +int ksz_max_mtu(struct dsa_switch *ds, int port);
>  
>  /* Common register access functions */
>  
> -- 
> 2.36.1
> 

