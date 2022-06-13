Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5ACB548342
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 11:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234433AbiFMJ3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 05:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240892AbiFMJ2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 05:28:39 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF4913EA6;
        Mon, 13 Jun 2022 02:28:36 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id fu3so9965931ejc.7;
        Mon, 13 Jun 2022 02:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MyvCw3+X9veP8d/j+BQO5hDbd/SHGZ+8BAzWsLfr7TQ=;
        b=BG3cPgSSPGTJxhUQ6Srqd/L72nNNzFPWAfBjKVPBRKDzzaZorA6RhhWHPcSUSXndQO
         s2A8OJ+IcQg85xSRTSuPjURt9lexJ0d0cPMRrzJjyDuwdiiogzX9ur8pk9X+Mk1GguNA
         121zJcRJd8Blk257wYz3q1aTj4TzNdDfOvFnvIlLr6XsRTdQN50tREcLlkvXT0b5euA0
         OB7aDUEtmKcrSui+Yx9jU6GuQ4+eN7J5tgIHOBX+XRF76pU/SVPsHLfBMddwXJu9ne99
         yoS+3D4X2D7Bdju2JLUh0BG777aLDpDZ9FwWcTvA3lgwQp+i+IVfIc3hqQSjnvJOSc9q
         LwFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MyvCw3+X9veP8d/j+BQO5hDbd/SHGZ+8BAzWsLfr7TQ=;
        b=eY0HyX2VissEYnXG6vaHNmTCzW4BEwyRxhVU+VCj0CGKMRqlnalhQ49K3Ugl4KM9tC
         yPUb2VsTqPFDRdRFu1rSHBj34o/CctK+ewNFh2wESOUhm/d1hd9+SK1Ye+9Efn9XINXx
         xgfXaXZl1Pti3x4PB+UowiTTPfWxPgkszu8LqR7jdyQ8qp3vOZRrBhz9m0MjNZ3JNBof
         MTUcAcolv5+Zr9jfo6vpXSK+2UB+GStNvVVk168YPCcnq1xrCglV5FDgTBO2ufLivSyz
         KdvxR5zJgD52M8KmWgXsYZ8/9um5J/WA7DuIL6N1qRDjpQKE2MnJSp+0jxqT3NkwzE8y
         3wvA==
X-Gm-Message-State: AOAM5329hOxaY8p7qiUGnU18g0epj+be2U5QRb8if4i5llI44/1QbaW/
        fZ0Nvue4YoYwZSMN6XLbHxo=
X-Google-Smtp-Source: ABdhPJwWF3n6wjpHpsjKG6R6vVAgrkc/vZvpBaHpPzozzeK6w7yX+3n/h+G+lg3hDyU93lTxi86UKQ==
X-Received: by 2002:a17:907:7fa5:b0:711:c8e2:2f4c with SMTP id qk37-20020a1709077fa500b00711c8e22f4cmr37169341ejc.49.1655112515384;
        Mon, 13 Jun 2022 02:28:35 -0700 (PDT)
Received: from skbuf ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id zj11-20020a170907338b00b006ff0fe78cb7sm3599496ejb.133.2022.06.13.02.28.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 02:28:34 -0700 (PDT)
Date:   Mon, 13 Jun 2022 12:28:33 +0300
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
Subject: Re: [RFC Patch net-next v2 05/15] net: dsa: microchip: move the port
 mirror to ksz_common
Message-ID: <20220613092833.f4sk2lhhbl64imrb@skbuf>
References: <20220530104257.21485-1-arun.ramadoss@microchip.com>
 <20220530104257.21485-6-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220530104257.21485-6-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 30, 2022 at 04:12:47PM +0530, Arun Ramadoss wrote:
> This patch updates the common port mirror add/del dsa_switch_ops in
> ksz_common.c. The individual switches implementation is executed based
> on the ksz_dev_ops function pointers.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

>  drivers/net/dsa/microchip/ksz8795.c    | 13 ++++++-------
>  drivers/net/dsa/microchip/ksz9477.c    | 12 ++++++------
>  drivers/net/dsa/microchip/ksz_common.c | 25 +++++++++++++++++++++++++
>  drivers/net/dsa/microchip/ksz_common.h | 10 ++++++++++
>  4 files changed, 47 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
> index 157d69e46793..8657b520b336 100644
> --- a/drivers/net/dsa/microchip/ksz8795.c
> +++ b/drivers/net/dsa/microchip/ksz8795.c
> @@ -1089,12 +1089,10 @@ static int ksz8_port_vlan_del(struct ksz_device *dev, int port,
>  	return 0;
>  }
>  
> -static int ksz8_port_mirror_add(struct dsa_switch *ds, int port,
> +static int ksz8_port_mirror_add(struct ksz_device *dev, int port,
>  				struct dsa_mall_mirror_tc_entry *mirror,
>  				bool ingress, struct netlink_ext_ack *extack)
>  {
> -	struct ksz_device *dev = ds->priv;
> -
>  	if (ingress) {
>  		ksz_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_RX, true);
>  		dev->mirror_rx |= BIT(port);
> @@ -1113,10 +1111,9 @@ static int ksz8_port_mirror_add(struct dsa_switch *ds, int port,
>  	return 0;
>  }
>  
> -static void ksz8_port_mirror_del(struct dsa_switch *ds, int port,
> +static void ksz8_port_mirror_del(struct ksz_device *dev, int port,
>  				 struct dsa_mall_mirror_tc_entry *mirror)
>  {
> -	struct ksz_device *dev = ds->priv;
>  	u8 data;
>  
>  	if (mirror->ingress) {
> @@ -1400,8 +1397,8 @@ static const struct dsa_switch_ops ksz8_switch_ops = {
>  	.port_fdb_dump		= ksz_port_fdb_dump,
>  	.port_mdb_add           = ksz_port_mdb_add,
>  	.port_mdb_del           = ksz_port_mdb_del,
> -	.port_mirror_add	= ksz8_port_mirror_add,
> -	.port_mirror_del	= ksz8_port_mirror_del,
> +	.port_mirror_add	= ksz_port_mirror_add,
> +	.port_mirror_del	= ksz_port_mirror_del,
>  };
>  
>  static u32 ksz8_get_port_addr(int port, int offset)
> @@ -1464,6 +1461,8 @@ static const struct ksz_dev_ops ksz8_dev_ops = {
>  	.vlan_filtering = ksz8_port_vlan_filtering,
>  	.vlan_add = ksz8_port_vlan_add,
>  	.vlan_del = ksz8_port_vlan_del,
> +	.mirror_add = ksz8_port_mirror_add,
> +	.mirror_del = ksz8_port_mirror_del,
>  	.shutdown = ksz8_reset_switch,
>  	.init = ksz8_switch_init,
>  	.exit = ksz8_switch_exit,
> diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
> index e230fe1d1917..6796c9d89ab9 100644
> --- a/drivers/net/dsa/microchip/ksz9477.c
> +++ b/drivers/net/dsa/microchip/ksz9477.c
> @@ -811,11 +811,10 @@ static int ksz9477_port_mdb_del(struct dsa_switch *ds, int port,
>  	return ret;
>  }
>  
> -static int ksz9477_port_mirror_add(struct dsa_switch *ds, int port,
> +static int ksz9477_port_mirror_add(struct ksz_device *dev, int port,
>  				   struct dsa_mall_mirror_tc_entry *mirror,
>  				   bool ingress, struct netlink_ext_ack *extack)
>  {
> -	struct ksz_device *dev = ds->priv;
>  	u8 data;
>  	int p;
>  
> @@ -851,10 +850,9 @@ static int ksz9477_port_mirror_add(struct dsa_switch *ds, int port,
>  	return 0;
>  }
>  
> -static void ksz9477_port_mirror_del(struct dsa_switch *ds, int port,
> +static void ksz9477_port_mirror_del(struct ksz_device *dev, int port,
>  				    struct dsa_mall_mirror_tc_entry *mirror)
>  {
> -	struct ksz_device *dev = ds->priv;
>  	bool in_use = false;
>  	u8 data;
>  	int p;
> @@ -1327,8 +1325,8 @@ static const struct dsa_switch_ops ksz9477_switch_ops = {
>  	.port_fdb_del		= ksz9477_port_fdb_del,
>  	.port_mdb_add           = ksz9477_port_mdb_add,
>  	.port_mdb_del           = ksz9477_port_mdb_del,
> -	.port_mirror_add	= ksz9477_port_mirror_add,
> -	.port_mirror_del	= ksz9477_port_mirror_del,
> +	.port_mirror_add	= ksz_port_mirror_add,
> +	.port_mirror_del	= ksz_port_mirror_del,
>  	.get_stats64		= ksz_get_stats64,
>  	.port_change_mtu	= ksz9477_change_mtu,
>  	.port_max_mtu		= ksz9477_max_mtu,
> @@ -1406,6 +1404,8 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
>  	.vlan_filtering = ksz9477_port_vlan_filtering,
>  	.vlan_add = ksz9477_port_vlan_add,
>  	.vlan_del = ksz9477_port_vlan_del,
> +	.mirror_add = ksz9477_port_mirror_add,
> +	.mirror_del = ksz9477_port_mirror_del,
>  	.shutdown = ksz9477_reset_switch,
>  	.init = ksz9477_switch_init,
>  	.exit = ksz9477_switch_exit,
> diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
> index a1fef9e4e36c..1ed4cc94795e 100644
> --- a/drivers/net/dsa/microchip/ksz_common.c
> +++ b/drivers/net/dsa/microchip/ksz_common.c
> @@ -994,6 +994,31 @@ int ksz_port_vlan_del(struct dsa_switch *ds, int port,
>  }
>  EXPORT_SYMBOL_GPL(ksz_port_vlan_del);
>  
> +int ksz_port_mirror_add(struct dsa_switch *ds, int port,
> +			struct dsa_mall_mirror_tc_entry *mirror,
> +			bool ingress, struct netlink_ext_ack *extack)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	int ret = -EOPNOTSUPP;
> +
> +	if (dev->dev_ops->mirror_add)
> +		ret = dev->dev_ops->mirror_add(dev, port, mirror, ingress,
> +					       extack);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(ksz_port_mirror_add);

Just as a minor style comment, take it or leave it.

If you switch the function pointer presence check, you reduce the
indentation of the long statement, making it fit a single line, and you
eliminate the need for a "ret" variable:

	if (!dev->dev_ops->mirror_add)
		return -EOPNOTSUPP;

	return dev->dev_ops->mirror_add(dev, port, mirror, ingress, extack);

> +
> +void ksz_port_mirror_del(struct dsa_switch *ds, int port,
> +			 struct dsa_mall_mirror_tc_entry *mirror)
> +{
> +	struct ksz_device *dev = ds->priv;
> +
> +	if (dev->dev_ops->mirror_del)
> +		dev->dev_ops->mirror_del(dev, port, mirror);
> +}
> +EXPORT_SYMBOL_GPL(ksz_port_mirror_del);
> +
>  static int ksz_switch_detect(struct ksz_device *dev)
>  {
>  	u8 id1, id2;
> diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
> index 03e738c0cbb8..01080ec22bf1 100644
> --- a/drivers/net/dsa/microchip/ksz_common.h
> +++ b/drivers/net/dsa/microchip/ksz_common.h
> @@ -187,6 +187,11 @@ struct ksz_dev_ops {
>  			 struct netlink_ext_ack *extack);
>  	int  (*vlan_del)(struct ksz_device *dev, int port,
>  			 const struct switchdev_obj_port_vlan *vlan);
> +	int (*mirror_add)(struct ksz_device *dev, int port,
> +			  struct dsa_mall_mirror_tc_entry *mirror,
> +			  bool ingress, struct netlink_ext_ack *extack);
> +	void (*mirror_del)(struct ksz_device *dev, int port,
> +			   struct dsa_mall_mirror_tc_entry *mirror);
>  	void (*freeze_mib)(struct ksz_device *dev, int port, bool freeze);
>  	void (*port_init_cnt)(struct ksz_device *dev, int port);
>  	int (*shutdown)(struct ksz_device *dev);
> @@ -247,6 +252,11 @@ int ksz_port_vlan_add(struct dsa_switch *ds, int port,
>  		      struct netlink_ext_ack *extack);
>  int ksz_port_vlan_del(struct dsa_switch *ds, int port,
>  		      const struct switchdev_obj_port_vlan *vlan);
> +int ksz_port_mirror_add(struct dsa_switch *ds, int port,
> +			struct dsa_mall_mirror_tc_entry *mirror,
> +			bool ingress, struct netlink_ext_ack *extack);
> +void ksz_port_mirror_del(struct dsa_switch *ds, int port,
> +			 struct dsa_mall_mirror_tc_entry *mirror);
>  
>  /* Common register access functions */
>  
> -- 
> 2.36.1
> 

