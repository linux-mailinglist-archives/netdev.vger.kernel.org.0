Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0A295BAE5B
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 15:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbiIPNjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 09:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231765AbiIPNjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 09:39:11 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66CBBADCDD
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 06:39:04 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id k9so36137563wri.0
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 06:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date;
        bh=LR9ygl3xWe+EPTa1/+fhRXoLP5xpObgkfksV5IO2uiU=;
        b=iDl+wpJFBBeFhuNc0GW1XRlZIkJagtxotk6FrL6QRwr+9mHROtbCLD7yMbNgDKE/aj
         A067dGe+F5W9/+YwDfASDaKi1Jx+0SZkTcZ3hmF6Mb/Me/EiBWya4KXNeMdIAqSFw8Lf
         S9KkSjPtoyVrhFwx7cRBczP88K4FaMMsL//kiOwVt2q+nu10v83rsPZvIN1dZ/RL2H8t
         GbChZrZKzSZpQa4QYi6MfsCpoTtygCZdX+/czWfpVvps/odq/BpEenK+WK23lqR0erew
         zBaB7cCKzow+gv4J+sTfLwMKSonraWhio4dQgDBfNsazsmSpdm11xYJtPHKCuc9VRWuo
         Kn9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=LR9ygl3xWe+EPTa1/+fhRXoLP5xpObgkfksV5IO2uiU=;
        b=6PqKrKTLm0WOs9TczA3aH0H9Akvy8fem+UuM1hUtqWux6VnKSIrAVrJacsOxLU97a6
         pU4KqnIydhCJMtpa5cqW/SKwLWCV+n/uptBNGp59bWLTpH2wqnd6E8Ym89rpZDzbqb6v
         RpIq5HvGRz0CQzVYqBGRI6BHxniASMCfKj1FaDKHXYs+ZnZQoOA3kIl9tgB5qeG7Hq13
         qN8L+ucDxJ24eRqliOkBngsuI5fuIR6AbbMhw15Un0hERZ6CalnGNXABiVqT8gF2Hp5t
         OG+RFoF4zxef/B8PUyu3+kEp15BHyPJRYoSa87wDY4qqIxzUX1194JUEjATbCeNG2BH5
         V23g==
X-Gm-Message-State: ACrzQf28ABtjBIX9+lktf2pKAShHX/ePqpll9pxq1fK2cZnjbNE9qxCX
        oRJqYyhJ0DqLBkjaiLGzKlA=
X-Google-Smtp-Source: AMsMyM7dfcGZpXlqyc6OesIWz2YuhHLW8qgZk/jka4Zxib8g4rkebyAS0Hvk1YoFmc+w3W+Ecqjg4A==
X-Received: by 2002:a05:6000:18a2:b0:22a:dc77:eca7 with SMTP id b2-20020a05600018a200b0022adc77eca7mr2520387wri.477.1663335542109;
        Fri, 16 Sep 2022 06:39:02 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-134.ip85.fastwebnet.it. [93.42.70.134])
        by smtp.gmail.com with ESMTPSA id o6-20020a5d58c6000000b0022860e8ae7csm4896803wrf.77.2022.09.16.06.39.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 06:39:01 -0700 (PDT)
Message-ID: <63247c75.5d0a0220.e6823.b58e@mx.google.com>
X-Google-Original-Message-ID: <YyQTNlkfRvW3XfJj@Ansuel-xps.>
Date:   Fri, 16 Sep 2022 08:09:58 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux@armlinux.org.uk
Subject: Re: [PATCH net-next v13 6/6] net: dsa: qca8k: Use new convenience
 functions
References: <20220916121817.4061532-1-mattias.forsblad@gmail.com>
 <20220916121817.4061532-7-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220916121817.4061532-7-mattias.forsblad@gmail.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 16, 2022 at 02:18:17PM +0200, Mattias Forsblad wrote:
> Use the new common convenience functions for sending and
> waiting for frames.
> 
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
> ---
>  drivers/net/dsa/qca/qca8k-8xxx.c | 61 +++++++++-----------------------
>  1 file changed, 17 insertions(+), 44 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
> index c181346388a4..4e9bc103c0a5 100644
> --- a/drivers/net/dsa/qca/qca8k-8xxx.c
> +++ b/drivers/net/dsa/qca/qca8k-8xxx.c
> @@ -160,7 +160,7 @@ static void qca8k_rw_reg_ack_handler(struct dsa_switch *ds, struct sk_buff *skb)
>  			       QCA_HDR_MGMT_DATA2_LEN);
>  	}
>  
> -	complete(&mgmt_eth_data->rw_done);
> +	dsa_switch_inband_complete(ds, &mgmt_eth_data->rw_done);
>  }
>  
>  static struct sk_buff *qca8k_alloc_mdio_header(enum mdio_cmd cmd, u32 reg, u32 *val,
> @@ -228,6 +228,7 @@ static void qca8k_mdio_header_fill_seq_num(struct sk_buff *skb, u32 seq_num)
>  static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
>  {
>  	struct qca8k_mgmt_eth_data *mgmt_eth_data = &priv->mgmt_eth_data;
> +	struct dsa_switch *ds = priv->ds;
>  	struct sk_buff *skb;
>  	bool ack;
>  	int ret;
> @@ -248,17 +249,12 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
>  
>  	skb->dev = priv->mgmt_master;
>  
> -	reinit_completion(&mgmt_eth_data->rw_done);
> -
>  	/* Increment seq_num and set it in the mdio pkt */
>  	mgmt_eth_data->seq++;
>  	qca8k_mdio_header_fill_seq_num(skb, mgmt_eth_data->seq);
>  	mgmt_eth_data->ack = false;
>  
> -	dev_queue_xmit(skb);
> -
> -	ret = wait_for_completion_timeout(&mgmt_eth_data->rw_done,
> -					  msecs_to_jiffies(QCA8K_ETHERNET_TIMEOUT));
> +	ret = dsa_switch_inband_tx(ds, skb, &mgmt_eth_data->rw_done, QCA8K_ETHERNET_TIMEOUT);
>  
>  	*val = mgmt_eth_data->data[0];
>  	if (len > QCA_HDR_MGMT_DATA1_LEN)
> @@ -280,6 +276,7 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
>  static int qca8k_write_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
>  {
>  	struct qca8k_mgmt_eth_data *mgmt_eth_data = &priv->mgmt_eth_data;
> +	struct dsa_switch *ds = priv->ds;
>  	struct sk_buff *skb;
>  	bool ack;
>  	int ret;
> @@ -300,17 +297,12 @@ static int qca8k_write_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
>  
>  	skb->dev = priv->mgmt_master;
>  
> -	reinit_completion(&mgmt_eth_data->rw_done);
> -
>  	/* Increment seq_num and set it in the mdio pkt */
>  	mgmt_eth_data->seq++;
>  	qca8k_mdio_header_fill_seq_num(skb, mgmt_eth_data->seq);
>  	mgmt_eth_data->ack = false;
>  
> -	dev_queue_xmit(skb);
> -
> -	ret = wait_for_completion_timeout(&mgmt_eth_data->rw_done,
> -					  msecs_to_jiffies(QCA8K_ETHERNET_TIMEOUT));
> +	ret = dsa_switch_inband_tx(ds, skb, &mgmt_eth_data->rw_done, QCA8K_ETHERNET_TIMEOUT);
>  
>  	ack = mgmt_eth_data->ack;
>  
> @@ -441,24 +433,21 @@ static struct regmap_config qca8k_regmap_config = {
>  };
>  
>  static int
> -qca8k_phy_eth_busy_wait(struct qca8k_mgmt_eth_data *mgmt_eth_data,
> +qca8k_phy_eth_busy_wait(struct qca8k_priv *priv,
>  			struct sk_buff *read_skb, u32 *val)
>  {
> +	struct qca8k_mgmt_eth_data *mgmt_eth_data = &priv->mgmt_eth_data;
>  	struct sk_buff *skb = skb_copy(read_skb, GFP_KERNEL);
> +	struct dsa_switch *ds = priv->ds;
>  	bool ack;
>  	int ret;
>  
> -	reinit_completion(&mgmt_eth_data->rw_done);
> -
>  	/* Increment seq_num and set it in the copy pkt */
>  	mgmt_eth_data->seq++;
>  	qca8k_mdio_header_fill_seq_num(skb, mgmt_eth_data->seq);
>  	mgmt_eth_data->ack = false;
>  
> -	dev_queue_xmit(skb);
> -
> -	ret = wait_for_completion_timeout(&mgmt_eth_data->rw_done,
> -					  QCA8K_ETHERNET_TIMEOUT);
> +	ret = dsa_switch_inband_tx(ds, skb, &mgmt_eth_data->rw_done, QCA8K_ETHERNET_TIMEOUT);
>  
>  	ack = mgmt_eth_data->ack;
>  
> @@ -480,6 +469,7 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
>  	struct sk_buff *write_skb, *clear_skb, *read_skb;
>  	struct qca8k_mgmt_eth_data *mgmt_eth_data;
>  	u32 write_val, clear_val = 0, val;
> +	struct dsa_switch *ds = priv->ds;
>  	struct net_device *mgmt_master;
>  	int ret, ret1;
>  	bool ack;
> @@ -540,17 +530,12 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
>  	clear_skb->dev = mgmt_master;
>  	write_skb->dev = mgmt_master;
>  
> -	reinit_completion(&mgmt_eth_data->rw_done);
> -
>  	/* Increment seq_num and set it in the write pkt */
>  	mgmt_eth_data->seq++;
>  	qca8k_mdio_header_fill_seq_num(write_skb, mgmt_eth_data->seq);
>  	mgmt_eth_data->ack = false;
>  
> -	dev_queue_xmit(write_skb);
> -
> -	ret = wait_for_completion_timeout(&mgmt_eth_data->rw_done,
> -					  QCA8K_ETHERNET_TIMEOUT);
> +	ret = dsa_switch_inband_tx(ds, write_skb, &mgmt_eth_data->rw_done, QCA8K_ETHERNET_TIMEOUT);
>  
>  	ack = mgmt_eth_data->ack;
>  
> @@ -569,7 +554,7 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
>  	ret = read_poll_timeout(qca8k_phy_eth_busy_wait, ret1,
>  				!(val & QCA8K_MDIO_MASTER_BUSY), 0,
>  				QCA8K_BUSY_WAIT_TIMEOUT * USEC_PER_MSEC, false,
> -				mgmt_eth_data, read_skb, &val);
> +				priv, read_skb, &val);
>  
>  	if (ret < 0 && ret1 < 0) {
>  		ret = ret1;
> @@ -577,17 +562,13 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
>  	}
>  
>  	if (read) {
> -		reinit_completion(&mgmt_eth_data->rw_done);
> -
>  		/* Increment seq_num and set it in the read pkt */
>  		mgmt_eth_data->seq++;
>  		qca8k_mdio_header_fill_seq_num(read_skb, mgmt_eth_data->seq);
>  		mgmt_eth_data->ack = false;
>  
> -		dev_queue_xmit(read_skb);
> -
> -		ret = wait_for_completion_timeout(&mgmt_eth_data->rw_done,
> -						  QCA8K_ETHERNET_TIMEOUT);
> +		ret = dsa_switch_inband_tx(ds, read_skb, &mgmt_eth_data->rw_done,
> +					   QCA8K_ETHERNET_TIMEOUT);
>  
>  		ack = mgmt_eth_data->ack;
>  
> @@ -606,17 +587,12 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
>  		kfree_skb(read_skb);
>  	}
>  exit:
> -	reinit_completion(&mgmt_eth_data->rw_done);
> -
>  	/* Increment seq_num and set it in the clear pkt */
>  	mgmt_eth_data->seq++;
>  	qca8k_mdio_header_fill_seq_num(clear_skb, mgmt_eth_data->seq);
>  	mgmt_eth_data->ack = false;
>  
> -	dev_queue_xmit(clear_skb);
> -
> -	wait_for_completion_timeout(&mgmt_eth_data->rw_done,
> -				    QCA8K_ETHERNET_TIMEOUT);
> +	ret = dsa_switch_inband_tx(ds, clear_skb, &mgmt_eth_data->rw_done, QCA8K_ETHERNET_TIMEOUT);

This cause the breakage of qca8k!

The clear_skb is used to clean a state but is optional and we should not
check exit value.

On top of that this overwrites the mdio return value from the read
condition.

ret = mgmt_eth_data->data[0] & QCA8K_MDIO_MASTER_DATA_MASK;

This should be changed to just

dsa_switch_inband_tx(ds, clear_skb, &mgmt_eth_data->rw_done, QCA8K_ETHERNET_TIMEOUT);

Also considering the majority of the driver is alligned to 80 column can
you wrap these new function to that? (personal taste)

>  
>  	mutex_unlock(&mgmt_eth_data->mutex);
>  
> @@ -1528,7 +1504,7 @@ static void qca8k_mib_autocast_handler(struct dsa_switch *ds, struct sk_buff *sk
>  exit:
>  	/* Complete on receiving all the mib packet */
>  	if (refcount_dec_and_test(&mib_eth_data->port_parsed))
> -		complete(&mib_eth_data->rw_done);
> +		dsa_switch_inband_complete(ds, &mib_eth_data->rw_done);
>  }
>  
>  static int
> @@ -1543,8 +1519,6 @@ qca8k_get_ethtool_stats_eth(struct dsa_switch *ds, int port, u64 *data)
>  
>  	mutex_lock(&mib_eth_data->mutex);
>  
> -	reinit_completion(&mib_eth_data->rw_done);
> -
>  	mib_eth_data->req_port = dp->index;
>  	mib_eth_data->data = data;
>  	refcount_set(&mib_eth_data->port_parsed, QCA8K_NUM_PORTS);
> @@ -1562,8 +1536,7 @@ qca8k_get_ethtool_stats_eth(struct dsa_switch *ds, int port, u64 *data)
>  	if (ret)
>  		goto exit;
>  
> -	ret = wait_for_completion_timeout(&mib_eth_data->rw_done, QCA8K_ETHERNET_TIMEOUT);
> -
> +	ret = dsa_switch_inband_tx(ds, NULL, &mib_eth_data->rw_done, QCA8K_ETHERNET_TIMEOUT);
>  exit:
>  	mutex_unlock(&mib_eth_data->mutex);
>  
> -- 
> 2.25.1
> 

-- 
	Ansuel
