Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16B3949B75B
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 16:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1581922AbiAYPOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 10:14:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1581513AbiAYPML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 10:12:11 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64366C06173B;
        Tue, 25 Jan 2022 07:12:11 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id p12so63951656edq.9;
        Tue, 25 Jan 2022 07:12:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=b/fVXGWL7pXguX3NnL+L9P3rO1c2oKSjzsBSQyAaKoI=;
        b=b49+POoNj5fEkS3FK8cNC5hrd0L0Q8NYvsXzIbXVCfLrjq5zOWOZ8IcLn5Cgdj53c5
         XmtWnBNl55rAQ1T8BTs604GyDQzge9/Q8QyG3n1obTzwEwHvSdykC4UsTyFWMukQnssv
         CaJxDzMJVbTDSvWto/RnZjUDDSANqJOaGn5VYB5HKjVAnJFygAeYPmi/SINAlFPK3x9N
         m5ZYMaYml97/4HFzJ0TgAANF7Bj5Z0jImirg6HY/6JP+ZlZWrqlAisFEikTJjas/KZPw
         e2bgqFdvMdAgtm/mo5myrCc8BVDEGvvxg2deACgWVA8Y1kZvQotbN3xuin2jkivFXBhF
         4uaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=b/fVXGWL7pXguX3NnL+L9P3rO1c2oKSjzsBSQyAaKoI=;
        b=HcYpK3pEg1B921yeZqKBW+uYOU8w2nXYxoEe7GSleTdByfOFjnqbR/9Yxv4RnoHa0N
         QCBBJ2WgmXzL7klxZTN9PHm/aaP1UUHQW9zd1g6hcZilrzc5OCHNb9C6BfFoCZ1FU8i0
         KyXKfe0jOp+5uQq9lFLZRJD34dhxFRuGrHFjUdbKanX8UxACM1uPp6oYRhqPWEvzga5x
         dbrOUZ8I0pmUfiOE6c2Jedj2+DGzh5H1BjVORKrbnkzX7Inn5bAysLiynQcl2avv0Vaz
         Jwl7jhI1D/tOnSWKma/eipAGZZtHEOO+61WfwPqKvk/b+RFE/WK3uTEnVYlF6pj1MZyx
         qLrQ==
X-Gm-Message-State: AOAM531zaGCrJqavTZI3IvGiPQ5ZXFP/hTTNjpu7rLXV2tX/NJtOdE+F
        pkgK9jQiImC7UYgHq2oRbbY=
X-Google-Smtp-Source: ABdhPJzSk6NWHSYclxAOyjZyJFZ1K6AbVTBS8s7c5CQF+5NDJeZFqS47qK6tI1OypDgzFrI3QS0Trg==
X-Received: by 2002:a05:6402:438b:: with SMTP id o11mr14226461edc.23.1643123529440;
        Tue, 25 Jan 2022 07:12:09 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id 5sm8706467edx.32.2022.01.25.07.12.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 07:12:08 -0800 (PST)
Date:   Tue, 25 Jan 2022 17:12:07 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH v7 11/16] net: dsa: qca8k: add support for mib
 autocast in Ethernet packet
Message-ID: <20220125151207.zmwioczu54kkwcjm@skbuf>
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
 <20220123013337.20945-12-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220123013337.20945-12-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 23, 2022 at 02:33:32AM +0100, Ansuel Smith wrote:
> The switch can autocast MIB counter using Ethernet packet.
> Add support for this and provide a handler for the tagger.
> The switch will send packet with MIB counter for each port, the switch
> will use completion API to wait for the correct packet to be received
> and will complete the task only when each packet is received.
> Although the handler will drop all the other packet, we still have to
> consume each MIB packet to complete the request. This is done to prevent
> mixed data with concurrent ethtool request.
> 
> connect_tag_protocol() is used to add the handler to the tag_qca tagger,
> master_state_change() use the MIB lock to make sure no MIB Ethernet is
> in progress.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  drivers/net/dsa/qca8k.c | 108 +++++++++++++++++++++++++++++++++++++++-
>  drivers/net/dsa/qca8k.h |  17 ++++++-
>  2 files changed, 122 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index 35711d010eb4..f51a6d8993ff 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -811,7 +811,10 @@ qca8k_mib_init(struct qca8k_priv *priv)
>  	int ret;
>  
>  	mutex_lock(&priv->reg_mutex);
> -	ret = regmap_set_bits(priv->regmap, QCA8K_REG_MIB, QCA8K_MIB_FLUSH | QCA8K_MIB_BUSY);
> +	ret = regmap_update_bits(priv->regmap, QCA8K_REG_MIB,
> +				 QCA8K_MIB_FUNC | QCA8K_MIB_BUSY,
> +				 FIELD_PREP(QCA8K_MIB_FUNC, QCA8K_MIB_FLUSH) |
> +				 QCA8K_MIB_BUSY);
>  	if (ret)
>  		goto exit;
>  
> @@ -1882,6 +1885,97 @@ qca8k_get_strings(struct dsa_switch *ds, int port, u32 stringset, uint8_t *data)
>  			ETH_GSTRING_LEN);
>  }
>  
> +static void qca8k_mib_autocast_handler(struct dsa_switch *ds, struct sk_buff *skb)
> +{
> +	const struct qca8k_match_data *match_data;
> +	struct qca8k_mib_hdr_data *mib_hdr_data;
> +	struct qca8k_priv *priv = ds->priv;
> +	const struct qca8k_mib_desc *mib;
> +	struct mib_ethhdr *mib_ethhdr;
> +	int i, mib_len, offset = 0;
> +	u64 *data;
> +	u8 port;
> +
> +	mib_ethhdr = (struct mib_ethhdr *)skb_mac_header(skb);
> +	mib_hdr_data = &priv->mib_hdr_data;
> +
> +	/* The switch autocast every port. Ignore other packet and
> +	 * parse only the requested one.
> +	 */
> +	port = FIELD_GET(QCA_HDR_RECV_SOURCE_PORT, ntohs(mib_ethhdr->hdr));
> +	if (port != mib_hdr_data->req_port)
> +		goto exit;
> +
> +	match_data = device_get_match_data(priv->dev);
> +	data = mib_hdr_data->data;
> +
> +	for (i = 0; i < match_data->mib_count; i++) {
> +		mib = &ar8327_mib[i];
> +
> +		/* First 3 mib are present in the skb head */
> +		if (i < 3) {
> +			data[i] = mib_ethhdr->data[i];
> +			continue;
> +		}
> +
> +		mib_len = sizeof(uint32_t);
> +
> +		/* Some mib are 64 bit wide */
> +		if (mib->size == 2)
> +			mib_len = sizeof(uint64_t);
> +
> +		/* Copy the mib value from packet to the */
> +		memcpy(data + i, skb->data + offset, mib_len);
> +
> +		/* Set the offset for the next mib */
> +		offset += mib_len;
> +	}
> +
> +exit:
> +	/* Complete on receiving all the mib packet */
> +	if (refcount_dec_and_test(&mib_hdr_data->port_parsed))
> +		complete(&mib_hdr_data->rw_done);
> +}
> +
> +static int
> +qca8k_get_ethtool_stats_eth(struct dsa_switch *ds, int port, u64 *data)
> +{
> +	struct dsa_port *dp = dsa_to_port(ds, port);
> +	struct qca8k_mib_hdr_data *mib_hdr_data;
> +	struct qca8k_priv *priv = ds->priv;
> +	int ret;
> +
> +	mib_hdr_data = &priv->mib_hdr_data;
> +
> +	mutex_lock(&mib_hdr_data->mutex);
> +
> +	reinit_completion(&mib_hdr_data->rw_done);
> +
> +	mib_hdr_data->req_port = dp->index;
> +	mib_hdr_data->data = data;
> +	refcount_set(&mib_hdr_data->port_parsed, QCA8K_NUM_PORTS);
> +
> +	mutex_lock(&priv->reg_mutex);
> +
> +	/* Send mib autocast request */
> +	ret = regmap_update_bits(priv->regmap, QCA8K_REG_MIB,
> +				 QCA8K_MIB_FUNC | QCA8K_MIB_BUSY,
> +				 FIELD_PREP(QCA8K_MIB_FUNC, QCA8K_MIB_CAST) |
> +				 QCA8K_MIB_BUSY);
> +
> +	mutex_unlock(&priv->reg_mutex);
> +
> +	if (ret)
> +		goto exit;
> +
> +	ret = wait_for_completion_timeout(&mib_hdr_data->rw_done, QCA8K_ETHERNET_TIMEOUT);
> +
> +exit:
> +	mutex_unlock(&mib_hdr_data->mutex);
> +
> +	return ret;
> +}
> +
>  static void
>  qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
>  			uint64_t *data)
> @@ -1893,6 +1987,10 @@ qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
>  	u32 hi = 0;
>  	int ret;
>  
> +	if (priv->mgmt_master &&
> +	    qca8k_get_ethtool_stats_eth(ds, port, data) > 0)
> +		return;
> +
>  	match_data = of_device_get_match_data(priv->dev);
>  
>  	for (i = 0; i < match_data->mib_count; i++) {
> @@ -2573,7 +2671,8 @@ qca8k_master_change(struct dsa_switch *ds, const struct net_device *master,
>  	if (dp->index != 0)
>  		return;
>  
> -	mutex_lock(&priv->mgmt_hdr_data.mutex);
> +	mutex_unlock(&priv->mgmt_hdr_data.mutex);

Why do you unlock mgmt_hdr_data here?

> +	mutex_lock(&priv->mib_hdr_data.mutex);
>  
>  	if (operational)
>  		priv->mgmt_master = master;
> @@ -2581,6 +2680,7 @@ qca8k_master_change(struct dsa_switch *ds, const struct net_device *master,
>  		priv->mgmt_master = NULL;
>  
>  	mutex_unlock(&priv->mgmt_hdr_data.mutex);
> +	mutex_unlock(&priv->mib_hdr_data.mutex);

Please unlock in the reverse order of locking.

>  }
>  
>  static int qca8k_connect_tag_protocol(struct dsa_switch *ds,
> @@ -2593,6 +2693,7 @@ static int qca8k_connect_tag_protocol(struct dsa_switch *ds,
>  		tagger_data = ds->tagger_data;
>  
>  		tagger_data->rw_reg_ack_handler = qca8k_rw_reg_ack_handler;
> +		tagger_data->mib_autocast_handler = qca8k_mib_autocast_handler;
>  
>  		break;
>  	default:
> @@ -2721,6 +2822,9 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
>  	mutex_init(&priv->mgmt_hdr_data.mutex);
>  	init_completion(&priv->mgmt_hdr_data.rw_done);
>  
> +	mutex_init(&priv->mib_hdr_data.mutex);
> +	init_completion(&priv->mib_hdr_data.rw_done);
> +
>  	priv->ds->dev = &mdiodev->dev;
>  	priv->ds->num_ports = QCA8K_NUM_PORTS;
>  	priv->ds->priv = priv;
> diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
> index a358a67044d3..dc1365542aa3 100644
> --- a/drivers/net/dsa/qca8k.h
> +++ b/drivers/net/dsa/qca8k.h
> @@ -67,7 +67,7 @@
>  #define QCA8K_REG_MODULE_EN				0x030
>  #define   QCA8K_MODULE_EN_MIB				BIT(0)
>  #define QCA8K_REG_MIB					0x034
> -#define   QCA8K_MIB_FLUSH				BIT(24)
> +#define   QCA8K_MIB_FUNC				GENMASK(26, 24)
>  #define   QCA8K_MIB_CPU_KEEP				BIT(20)
>  #define   QCA8K_MIB_BUSY				BIT(17)
>  #define QCA8K_MDIO_MASTER_CTRL				0x3c
> @@ -317,6 +317,12 @@ enum qca8k_vlan_cmd {
>  	QCA8K_VLAN_READ = 6,
>  };
>  
> +enum qca8k_mid_cmd {
> +	QCA8K_MIB_FLUSH = 1,
> +	QCA8K_MIB_FLUSH_PORT = 2,
> +	QCA8K_MIB_CAST = 3,
> +};
> +
>  struct ar8xxx_port_status {
>  	int enabled;
>  };
> @@ -340,6 +346,14 @@ struct qca8k_mgmt_hdr_data {
>  	u32 data[4];
>  };
>  
> +struct qca8k_mib_hdr_data {
> +	struct completion rw_done;
> +	struct mutex mutex; /* Process one command at time */
> +	refcount_t port_parsed; /* Counter to track parsed port */
> +	u8 req_port;
> +	u64 *data; /* pointer to ethtool data */
> +};
> +
>  struct qca8k_ports_config {
>  	bool sgmii_rx_clk_falling_edge;
>  	bool sgmii_tx_clk_falling_edge;
> @@ -367,6 +381,7 @@ struct qca8k_priv {
>  	unsigned int port_mtu[QCA8K_NUM_PORTS];
>  	const struct net_device *mgmt_master; /* Track if mdio/mib Ethernet is available */
>  	struct qca8k_mgmt_hdr_data mgmt_hdr_data;
> +	struct qca8k_mib_hdr_data mib_hdr_data;
>  };
>  
>  struct qca8k_mib_desc {
> -- 
> 2.33.1
> 
