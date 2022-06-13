Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B195548376
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 11:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241045AbiFMJm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 05:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240971AbiFMJmY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 05:42:24 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 850FE2661;
        Mon, 13 Jun 2022 02:42:23 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id d14so6286556eda.12;
        Mon, 13 Jun 2022 02:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2LqYjtNa4isqkWB+lPEDKcNdn4CAaL+chKNUM4maY+k=;
        b=XnS8r3wJAaKnAFyVSRHeszHiRS7oujbPmEUlVGTWsIw6zTh0IIjtFkASoexxmpXok+
         L3Dc8XV8KhPQAjxWp0N/2umOyzfA2WVepb1peevus/ai3wXp98MfSqM6idWVWKOxnISZ
         posaz3qR50twBk4uJrbuk35bfd9ew/nPkSAdUjJPqafUPXDYZJS+p1KnkAFVFLufvHcc
         vtf77sQDVPaqBqZDXOt4fN1T0/ylMFl0WxjqbTxi8MmAFZEq2+GBSQr+F1WDNiLYDVds
         +IhBCUtpD4abZHfx6k8m9tdccmBIC9OnCpUImi2PClKwkFQEKAanTmkNlQ2/G7Pw/4hb
         2aTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2LqYjtNa4isqkWB+lPEDKcNdn4CAaL+chKNUM4maY+k=;
        b=MbsUBjtk7Xx070JJY1ddNT79otQ9b3F1zXTXxR2RGq3pKicWh2j7Pr+3evqMXrYJiw
         gJrZhordclkKaNQUBecIiy0UPucdqSIRCTz3iieUCoZeViqq08Gv7oAcwRfps4559I6q
         Hg4O+Tls089w5DHKIcCCu4/5oXHBwp271DoHmDySJiX1ZkmI3O8eTWCVeFGIX/2QyjJV
         oepU2ngfco+IcwpjRu5heQ82eogXkNLE2BFWm/QVc2Y/fOA7KedIMMX9CzkDSoLTJ/N6
         2b5bcPlrtsyRLCfZlGW0SUbI5hfW08/4sbNW1aAEliDNifF5DphWS+3f9fJp0ZA73gVB
         Z5tQ==
X-Gm-Message-State: AOAM532LK97Jn5Vagu6y2/KCfZIOj/1eQer0guwHOYeKJ6eGuCKfV5T1
        FGu8Uy0Id/aHMIOnuhLw+SM=
X-Google-Smtp-Source: ABdhPJyyzOML3rpWfzeIv72NuFkLie+UxcIx7S+c1/2MRduaLrbeZfwUzG5NjKj2eFJw7Ww9aiE1qg==
X-Received: by 2002:a05:6402:1cb5:b0:42d:ddda:7459 with SMTP id cz21-20020a0564021cb500b0042dddda7459mr65754064edb.16.1655113341961;
        Mon, 13 Jun 2022 02:42:21 -0700 (PDT)
Received: from skbuf ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id ko9-20020a170907986900b006fef5088792sm3632946ejc.108.2022.06.13.02.42.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 02:42:21 -0700 (PDT)
Date:   Mon, 13 Jun 2022 12:42:19 +0300
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
Subject: Re: [RFC Patch net-next v2 09/15] net: dsa: microchip: update fdb
 add/del/dump in ksz_common
Message-ID: <20220613094219.zmgbtebf32x42md6@skbuf>
References: <20220530104257.21485-1-arun.ramadoss@microchip.com>
 <20220530104257.21485-10-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220530104257.21485-10-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 30, 2022 at 04:12:51PM +0530, Arun Ramadoss wrote:
> This patch makes the dsa_switch_hook for fdbs to use ksz_common.c file.
> And from ksz_common, individual switches fdb functions are called using
> the dev->dev_ops.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---

I had to jump ahead and look at the other patches to see if you plan on
doing anything about the r_dyn_mac_table, r_sta_mac_table, w_sta_mac_table
dev_ops which are only implemented for ksz8. They become redundant when
you introduce new dev_ops for the entire FDB dump, add, del procedure.

I see those aren't touched - what's the plan there?

>  drivers/net/dsa/microchip/ksz8795.c    | 30 +++++++++++++++
>  drivers/net/dsa/microchip/ksz9477.c    | 28 +++++++-------
>  drivers/net/dsa/microchip/ksz_common.c | 52 +++++++++++++++-----------
>  drivers/net/dsa/microchip/ksz_common.h | 10 +++++
>  4 files changed, 84 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
> index abd28dc44eb5..528de481b319 100644
> --- a/drivers/net/dsa/microchip/ksz8795.c
> +++ b/drivers/net/dsa/microchip/ksz8795.c
> @@ -958,6 +958,35 @@ static void ksz8_flush_dyn_mac_table(struct ksz_device *dev, int port)
>  	}
>  }
>  
> +static int ksz8_fdb_dump(struct ksz_device *dev, int port,
> +			 dsa_fdb_dump_cb_t *cb, void *data)
> +{
> +	int ret = 0;
> +	u16 i = 0;
> +	u16 entries = 0;
> +	u8 timestamp = 0;
> +	u8 fid;
> +	u8 member;
> +	struct alu_struct alu;
> +
> +	do {
> +		alu.is_static = false;
> +		ret = dev->dev_ops->r_dyn_mac_table(dev, i, alu.mac, &fid,
> +						    &member, &timestamp,
> +						    &entries);
> +		if (!ret && (member & BIT(port))) {
> +			ret = cb(alu.mac, alu.fid, alu.is_static, data);
> +			if (ret)
> +				break;
> +		}
> +		i++;
> +	} while (i < entries);
> +	if (i >= entries)
> +		ret = 0;
> +
> +	return ret;
> +}
> +
>  static int ksz8_mdb_add(struct ksz_device *dev, int port,
>  			const struct switchdev_obj_port_mdb *mdb,
>  			struct dsa_db db)
> @@ -1528,6 +1557,7 @@ static const struct ksz_dev_ops ksz8_dev_ops = {
>  	.r_mib_pkt = ksz8_r_mib_pkt,
>  	.freeze_mib = ksz8_freeze_mib,
>  	.port_init_cnt = ksz8_port_init_cnt,
> +	.fdb_dump = ksz8_fdb_dump,
>  	.mdb_add = ksz8_mdb_add,
>  	.mdb_del = ksz8_mdb_del,
>  	.vlan_filtering = ksz8_port_vlan_filtering,
> diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
> index 045856656466..d70e0c32b309 100644
> --- a/drivers/net/dsa/microchip/ksz9477.c
> +++ b/drivers/net/dsa/microchip/ksz9477.c
> @@ -457,11 +457,10 @@ static int ksz9477_port_vlan_del(struct ksz_device *dev, int port,
>  	return 0;
>  }
>  
> -static int ksz9477_port_fdb_add(struct dsa_switch *ds, int port,
> -				const unsigned char *addr, u16 vid,
> -				struct dsa_db db)
> +static int ksz9477_fdb_add(struct ksz_device *dev, int port,
> +			   const unsigned char *addr, u16 vid,
> +			   struct dsa_db db)
>  {
> -	struct ksz_device *dev = ds->priv;
>  	u32 alu_table[4];
>  	u32 data;
>  	int ret = 0;
> @@ -515,11 +514,10 @@ static int ksz9477_port_fdb_add(struct dsa_switch *ds, int port,
>  	return ret;
>  }
>  
> -static int ksz9477_port_fdb_del(struct dsa_switch *ds, int port,
> -				const unsigned char *addr, u16 vid,
> -				struct dsa_db db)
> +static int ksz9477_fdb_del(struct ksz_device *dev, int port,
> +			   const unsigned char *addr, u16 vid,
> +			   struct dsa_db db)
>  {
> -	struct ksz_device *dev = ds->priv;
>  	u32 alu_table[4];
>  	u32 data;
>  	int ret = 0;
> @@ -606,10 +604,9 @@ static void ksz9477_convert_alu(struct alu_struct *alu, u32 *alu_table)
>  	alu->mac[5] = alu_table[3] & 0xFF;
>  }
>  
> -static int ksz9477_port_fdb_dump(struct dsa_switch *ds, int port,
> -				 dsa_fdb_dump_cb_t *cb, void *data)
> +static int ksz9477_fdb_dump(struct ksz_device *dev, int port,
> +			    dsa_fdb_dump_cb_t *cb, void *data)
>  {
> -	struct ksz_device *dev = ds->priv;
>  	int ret = 0;
>  	u32 ksz_data;
>  	u32 alu_table[4];
> @@ -1315,9 +1312,9 @@ static const struct dsa_switch_ops ksz9477_switch_ops = {
>  	.port_vlan_filtering	= ksz_port_vlan_filtering,
>  	.port_vlan_add		= ksz_port_vlan_add,
>  	.port_vlan_del		= ksz_port_vlan_del,
> -	.port_fdb_dump		= ksz9477_port_fdb_dump,
> -	.port_fdb_add		= ksz9477_port_fdb_add,
> -	.port_fdb_del		= ksz9477_port_fdb_del,
> +	.port_fdb_dump		= ksz_port_fdb_dump,
> +	.port_fdb_add		= ksz_port_fdb_add,
> +	.port_fdb_del		= ksz_port_fdb_del,
>  	.port_mdb_add           = ksz_port_mdb_add,
>  	.port_mdb_del           = ksz_port_mdb_del,
>  	.port_mirror_add	= ksz_port_mirror_add,
> @@ -1403,6 +1400,9 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
>  	.mirror_del = ksz9477_port_mirror_del,
>  	.get_stp_reg = ksz9477_get_stp_reg,
>  	.get_caps = ksz9477_get_caps,
> +	.fdb_dump = ksz9477_fdb_dump,
> +	.fdb_add = ksz9477_fdb_add,
> +	.fdb_del = ksz9477_fdb_del,
>  	.mdb_add = ksz9477_mdb_add,
>  	.mdb_del = ksz9477_mdb_del,
>  	.shutdown = ksz9477_reset_switch,
> diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
> index b9082952db0f..8f79ff1ac648 100644
> --- a/drivers/net/dsa/microchip/ksz_common.c
> +++ b/drivers/net/dsa/microchip/ksz_common.c
> @@ -765,32 +765,40 @@ void ksz_port_fast_age(struct dsa_switch *ds, int port)
>  }
>  EXPORT_SYMBOL_GPL(ksz_port_fast_age);
>  
> +int ksz_port_fdb_add(struct dsa_switch *ds, int port,
> +		     const unsigned char *addr, u16 vid, struct dsa_db db)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	int ret = -EOPNOTSUPP;
> +
> +	if (dev->dev_ops->fdb_add)
> +		ret = dev->dev_ops->fdb_add(dev, port, addr, vid, db);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(ksz_port_fdb_add);
> +
> +int ksz_port_fdb_del(struct dsa_switch *ds, int port,
> +		     const unsigned char *addr, u16 vid, struct dsa_db db)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	int ret = -EOPNOTSUPP;
> +
> +	if (dev->dev_ops->fdb_del)
> +		ret = dev->dev_ops->fdb_del(dev, port, addr, vid, db);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(ksz_port_fdb_del);
> +
>  int ksz_port_fdb_dump(struct dsa_switch *ds, int port, dsa_fdb_dump_cb_t *cb,
>  		      void *data)
>  {
>  	struct ksz_device *dev = ds->priv;
> -	int ret = 0;
> -	u16 i = 0;
> -	u16 entries = 0;
> -	u8 timestamp = 0;
> -	u8 fid;
> -	u8 member;
> -	struct alu_struct alu;
> -
> -	do {
> -		alu.is_static = false;
> -		ret = dev->dev_ops->r_dyn_mac_table(dev, i, alu.mac, &fid,
> -						    &member, &timestamp,
> -						    &entries);
> -		if (!ret && (member & BIT(port))) {
> -			ret = cb(alu.mac, alu.fid, alu.is_static, data);
> -			if (ret)
> -				break;
> -		}
> -		i++;
> -	} while (i < entries);
> -	if (i >= entries)
> -		ret = 0;
> +	int ret = -EOPNOTSUPP;
> +
> +	if (dev->dev_ops->fdb_dump)
> +		ret = dev->dev_ops->fdb_dump(dev, port, cb, data);
>  
>  	return ret;
>  }
> diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
> index 816581dd7f8e..133b1a257868 100644
> --- a/drivers/net/dsa/microchip/ksz_common.h
> +++ b/drivers/net/dsa/microchip/ksz_common.h
> @@ -192,6 +192,12 @@ struct ksz_dev_ops {
>  			  bool ingress, struct netlink_ext_ack *extack);
>  	void (*mirror_del)(struct ksz_device *dev, int port,
>  			   struct dsa_mall_mirror_tc_entry *mirror);
> +	int (*fdb_add)(struct ksz_device *dev, int port,
> +		       const unsigned char *addr, u16 vid, struct dsa_db db);
> +	int (*fdb_del)(struct ksz_device *dev, int port,
> +		       const unsigned char *addr, u16 vid, struct dsa_db db);
> +	int (*fdb_dump)(struct ksz_device *dev, int port,
> +			dsa_fdb_dump_cb_t *cb, void *data);
>  	int (*mdb_add)(struct ksz_device *dev, int port,
>  		       const struct switchdev_obj_port_mdb *mdb,
>  		       struct dsa_db db);
> @@ -239,6 +245,10 @@ void ksz_port_bridge_leave(struct dsa_switch *ds, int port,
>  			   struct dsa_bridge bridge);
>  void ksz_port_stp_state_set(struct dsa_switch *ds, int port, u8 state);
>  void ksz_port_fast_age(struct dsa_switch *ds, int port);
> +int ksz_port_fdb_add(struct dsa_switch *ds, int port,
> +		     const unsigned char *addr, u16 vid, struct dsa_db db);
> +int ksz_port_fdb_del(struct dsa_switch *ds, int port,
> +		     const unsigned char *addr, u16 vid, struct dsa_db db);
>  int ksz_port_fdb_dump(struct dsa_switch *ds, int port, dsa_fdb_dump_cb_t *cb,
>  		      void *data);
>  int ksz_port_mdb_add(struct dsa_switch *ds, int port,
> -- 
> 2.36.1
> 
