Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1729D5BCA9A
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 13:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiISLYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 07:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbiISLX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 07:23:58 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A96381A80A
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 04:23:56 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id y8so33875357edc.10
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 04:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date;
        bh=32i0H2vxCq8ax7OlhoCoX5GmG8hbJry2wmACl7tmiUc=;
        b=ibvQOP8+9sW5MgZyes6ytEuizvem76vvXihQnD4jGMJoh5B/0cbrgboyYckM55DkWM
         sinKHb8QYDEPfOfosvd4J71hr89w+ymJgKszaWLaAc3Dyj6RJf5hrWyDF5ArQxy9NLXU
         Afb0SkxGNaifpWtRfb0VhkNwg5uPoVBs7l+TfC3qvcIzT8njNOa7MwcOTb01r/wT3srM
         tdbJx7TZSEbQ1GSjOFAktTb/EwoLGOK5Nwoy5QG2Sh2T78Bg8mj5ZINflyU49d5hErG6
         +3eYTZHdxqR/WXBPz8ws14lhOQIiSvSLJLov1Ad5+JnqfarX0RXUUDjGKLYyXKuDg2Dj
         BwBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=32i0H2vxCq8ax7OlhoCoX5GmG8hbJry2wmACl7tmiUc=;
        b=iDVM/6IUFcmv64olrqxbKZJYXXZpAIsgeyfjOrgjjKh533zxZwaKyFCn2neYr8tX6f
         j/jEEBHkpv8Hfr0dUJYBGRa1G02//QPjYPjGSdjCdhmQorTlz7u+meqxQ5wWlul75ntX
         eJc6A4CbQW+Ww+JIM+miDbKjsWgXNhcqhmh66w3Jf1czkS+Y14Uk+kBEgq06qIyy743v
         wR0uifdrQly9csD/Vaj9EyrrjVbVFc44nmxv0w4ITZVXm+MDArcyWY9IgoVYhwzKBCwL
         Zf5nXiTpo3xHdD0H+64tn0QqXqfq5jq8vCYEmrTnziLQ39f0usiCdi0NjmKvm8eFkg3Q
         xPjA==
X-Gm-Message-State: ACrzQf1c2BTAHwNnITYM2mAghAlqgxs/M5STB2DZs4VaPwEzpgTJga2J
        XQIy1C586ypGE+ofXy4ryl4=
X-Google-Smtp-Source: AMsMyM788BjknjHF6MpHhNmu2KP65/xTvS+DkzcAxQsRjzntU8VAAFqtK1TH80dfDIiqkVuQnV0xFA==
X-Received: by 2002:a05:6402:1909:b0:451:ace7:ccbd with SMTP id e9-20020a056402190900b00451ace7ccbdmr14923070edz.276.1663586634918;
        Mon, 19 Sep 2022 04:23:54 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-134.ip85.fastwebnet.it. [93.42.70.134])
        by smtp.gmail.com with ESMTPSA id 2-20020a170906210200b00715a02874acsm15624329ejt.35.2022.09.19.04.23.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 04:23:54 -0700 (PDT)
Message-ID: <6328514a.170a0220.dd15f.2706@mx.google.com>
X-Google-Original-Message-ID: <YyhRRmIUFcqHw1NG@Ansuel-xps.>
Date:   Mon, 19 Sep 2022 13:23:50 +0200
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
Subject: Re: [PATCH net-next v14 7/7] net: dsa: qca8k: Use new convenience
 functions
References: <20220919110847.744712-1-mattias.forsblad@gmail.com>
 <20220919110847.744712-8-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220919110847.744712-8-mattias.forsblad@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 19, 2022 at 01:08:47PM +0200, Mattias Forsblad wrote:
> Use the new common convenience functions for sending and
> waiting for frames.
> 
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>

Tested-by: Christian Marangi <ansuelsmth@gmail.com>

> ---
>  drivers/net/dsa/qca/qca8k-8xxx.c | 68 +++++++++++---------------------
>  1 file changed, 24 insertions(+), 44 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
> index c181346388a4..a4ec0d0e608d 100644
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
> @@ -248,17 +249,13 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
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
> +	ret = dsa_switch_inband_tx(ds, skb, &mgmt_eth_data->rw_done,
> +				   QCA8K_ETHERNET_TIMEOUT);
>  
>  	*val = mgmt_eth_data->data[0];
>  	if (len > QCA_HDR_MGMT_DATA1_LEN)
> @@ -280,6 +277,7 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
>  static int qca8k_write_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
>  {
>  	struct qca8k_mgmt_eth_data *mgmt_eth_data = &priv->mgmt_eth_data;
> +	struct dsa_switch *ds = priv->ds;
>  	struct sk_buff *skb;
>  	bool ack;
>  	int ret;
> @@ -300,17 +298,13 @@ static int qca8k_write_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
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
> +	ret = dsa_switch_inband_tx(ds, skb, &mgmt_eth_data->rw_done,
> +				   QCA8K_ETHERNET_TIMEOUT);
>  
>  	ack = mgmt_eth_data->ack;
>  
> @@ -441,24 +435,22 @@ static struct regmap_config qca8k_regmap_config = {
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
> +	ret = dsa_switch_inband_tx(ds, skb, &mgmt_eth_data->rw_done,
> +				   QCA8K_ETHERNET_TIMEOUT);
>  
>  	ack = mgmt_eth_data->ack;
>  
> @@ -480,6 +472,7 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
>  	struct sk_buff *write_skb, *clear_skb, *read_skb;
>  	struct qca8k_mgmt_eth_data *mgmt_eth_data;
>  	u32 write_val, clear_val = 0, val;
> +	struct dsa_switch *ds = priv->ds;
>  	struct net_device *mgmt_master;
>  	int ret, ret1;
>  	bool ack;
> @@ -540,17 +533,13 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
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
> +	ret = dsa_switch_inband_tx(ds, write_skb, &mgmt_eth_data->rw_done,
> +				   QCA8K_ETHERNET_TIMEOUT);
>  
>  	ack = mgmt_eth_data->ack;
>  
> @@ -569,7 +558,7 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
>  	ret = read_poll_timeout(qca8k_phy_eth_busy_wait, ret1,
>  				!(val & QCA8K_MDIO_MASTER_BUSY), 0,
>  				QCA8K_BUSY_WAIT_TIMEOUT * USEC_PER_MSEC, false,
> -				mgmt_eth_data, read_skb, &val);
> +				priv, read_skb, &val);
>  
>  	if (ret < 0 && ret1 < 0) {
>  		ret = ret1;
> @@ -577,17 +566,14 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
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
> +		ret = dsa_switch_inband_tx(ds, read_skb,
> +					   &mgmt_eth_data->rw_done,
> +					   QCA8K_ETHERNET_TIMEOUT);
>  
>  		ack = mgmt_eth_data->ack;
>  
> @@ -606,17 +592,13 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
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
> +	dsa_switch_inband_tx(ds, clear_skb, &mgmt_eth_data->rw_done,
> +			     QCA8K_ETHERNET_TIMEOUT);
>  
>  	mutex_unlock(&mgmt_eth_data->mutex);
>  
> @@ -1528,7 +1510,7 @@ static void qca8k_mib_autocast_handler(struct dsa_switch *ds, struct sk_buff *sk
>  exit:
>  	/* Complete on receiving all the mib packet */
>  	if (refcount_dec_and_test(&mib_eth_data->port_parsed))
> -		complete(&mib_eth_data->rw_done);
> +		dsa_switch_inband_complete(ds, &mib_eth_data->rw_done);
>  }
>  
>  static int
> @@ -1543,8 +1525,6 @@ qca8k_get_ethtool_stats_eth(struct dsa_switch *ds, int port, u64 *data)
>  
>  	mutex_lock(&mib_eth_data->mutex);
>  
> -	reinit_completion(&mib_eth_data->rw_done);
> -
>  	mib_eth_data->req_port = dp->index;
>  	mib_eth_data->data = data;
>  	refcount_set(&mib_eth_data->port_parsed, QCA8K_NUM_PORTS);
> @@ -1562,8 +1542,8 @@ qca8k_get_ethtool_stats_eth(struct dsa_switch *ds, int port, u64 *data)
>  	if (ret)
>  		goto exit;
>  
> -	ret = wait_for_completion_timeout(&mib_eth_data->rw_done, QCA8K_ETHERNET_TIMEOUT);
> -
> +	ret = dsa_switch_inband_tx(ds, NULL, &mib_eth_data->rw_done,
> +				   QCA8K_ETHERNET_TIMEOUT);
>  exit:
>  	mutex_unlock(&mib_eth_data->mutex);
>  
> -- 
> 2.25.1
> 

-- 
	Ansuel
