Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDCD47558D
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 10:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236424AbhLOJyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 04:54:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233823AbhLOJyv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 04:54:51 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42BD5C061574;
        Wed, 15 Dec 2021 01:54:51 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id z7so11526040edc.11;
        Wed, 15 Dec 2021 01:54:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2GXmeZ9/N4JtnrmfdsBXQaXp1uAf30pBM/FTJji4OxQ=;
        b=dVGFtgr7o0x7N3TB4h0nBXx/+pYdGdBmbuB2zBlXIYpRSa6+4ax8xsKYr/8XBVgZgM
         Nlric39a35fm0d1pMMUAY9FjYRIAZxmDCbKcjGeAiubRKyG7fYwJp4CajSBk0aoh7uo2
         PCXMTFIdYzTSISVOh4w1pLy6l2Yj2D8S+y24WLEdI0g1Wf44iAN+usM0aKU5k1jl5s0L
         Xs2dIDNfRhq3avbl7tbzvH/D9Cninz0pL8EIwEWZZ1strkWCRWjDkqE4ybnI+wlzMWR0
         aEdzVVGRTI3hh4eAylxJIXWXaQS+MvsgudPXZRQTlbUtc5ag9em6byEsefLa9KaMq0hZ
         oRkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2GXmeZ9/N4JtnrmfdsBXQaXp1uAf30pBM/FTJji4OxQ=;
        b=amQuR6dJpUScCmntHhMYhjY9N53evLkb+lz+JjG/mJaAycEZyCeLc1t+hqNzSmJgnH
         IgLwW5CvrptVKm7EyUJ+ObjXlln6nlAQgtFS3kFSqBz65QRJpbC2vVx6tfOrX2fKeK4I
         /bEcdH1cHjv1/f/O+KL0vXxngPWKMHHWqYZ35MTikKpF6b2FvLlF08SHa9O8h52SfreI
         E/AKq91VbBXgVN0rgmp58WXgmCs75pkrDQ7c4Aoqlt50u73Ws+h99KDeP5V6OZX4aR/1
         HrwLl9ORd2re7YxxT0Xnjjw9d/dvR1mCYJ8wJrHdo/+1DJWFURNwO4dGgzSRM11JlTTA
         XnNg==
X-Gm-Message-State: AOAM533TCCygVgPbk4Ss0vXUuYZFlbdCa6xDNGr9pgQSmxxG0t+MP6pn
        vqcQCqehvL8h3S9KRlLGyhCMPU82V6M=
X-Google-Smtp-Source: ABdhPJzct5rB+FgQb+NVATM7ISjSxHXUfqL9aEQ6ljTn7Kj+uUzLx/HlQ+XeR5sjby0FgAARzFtJcg==
X-Received: by 2002:a17:906:7944:: with SMTP id l4mr10491415ejo.598.1639562089793;
        Wed, 15 Dec 2021 01:54:49 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id q17sm754852edd.10.2021.12.15.01.54.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 01:54:49 -0800 (PST)
Date:   Wed, 15 Dec 2021 11:54:48 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next PATCH RFC v6 10/16] net: dsa: tag_qca: add support for
 handling mdio Ethernet and MIB packet
Message-ID: <20211215095448.r362nnr25yq22ixm@skbuf>
References: <20211214224409.5770-1-ansuelsmth@gmail.com>
 <20211214224409.5770-11-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214224409.5770-11-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 11:44:03PM +0100, Ansuel Smith wrote:
> Add connect/disconnect helper to assign private struct to the cpu port
> dsa priv.
> Add support for Ethernet mdio packet and MIB packet if the dsa driver
> provide an handler to correctly parse and elaborate the data.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  include/linux/dsa/tag_qca.h |  7 +++++++
>  net/dsa/tag_qca.c           | 35 +++++++++++++++++++++++++++++++++--
>  2 files changed, 40 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/dsa/tag_qca.h b/include/linux/dsa/tag_qca.h
> index cd6275bac103..203e72dad9bb 100644
> --- a/include/linux/dsa/tag_qca.h
> +++ b/include/linux/dsa/tag_qca.h
> @@ -69,4 +69,11 @@ struct mib_ethhdr {
>  	__be16 hdr;		/* qca hdr */
>  } __packed;
>  
> +struct tag_qca_priv {

Could you keep the "priv" name for later, in case you need to hide some
tagger storage from the switch driver? This could be renamed to
"qca_tagger_data".

> +	void (*rw_reg_ack_handler)(struct dsa_port *dp,
> +				   struct sk_buff *skb);
> +	void (*mib_autocast_handler)(struct dsa_port *dp,
> +				     struct sk_buff *skb);
> +};
> +
>  #endif /* __TAG_QCA_H */
> diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
> index f5547d357647..59e04157f53b 100644
> --- a/net/dsa/tag_qca.c
> +++ b/net/dsa/tag_qca.c
> @@ -32,11 +32,15 @@ static struct sk_buff *qca_tag_xmit(struct sk_buff *skb, struct net_device *dev)
>  
>  static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
>  {
> +	struct dsa_port *dp = dev->dsa_ptr;

cpu_dp, for clarity

> +	struct tag_qca_priv *priv;
>  	u16  hdr, pk_type;
>  	__be16 *phdr;
>  	int port;
>  	u8 ver;
>  
> +	priv = dp->ds->tagger_data;
> +
>  	if (unlikely(!pskb_may_pull(skb, QCA_HDR_LEN)))
>  		return NULL;
>  
> @@ -52,12 +56,18 @@ static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
>  	pk_type = FIELD_GET(QCA_HDR_RECV_TYPE, hdr);
>  
>  	/* Ethernet MDIO read/write packet */
> -	if (pk_type == QCA_HDR_RECV_TYPE_RW_REG_ACK)
> +	if (pk_type == QCA_HDR_RECV_TYPE_RW_REG_ACK) {
> +		if (priv->rw_reg_ack_handler)
> +			priv->rw_reg_ack_handler(dp, skb);

Minor nitpick, but why not pass the "ds" as argument?

>  		return NULL;
> +	}
>  
>  	/* Ethernet MIB counter packet */
> -	if (pk_type == QCA_HDR_RECV_TYPE_MIB)
> +	if (pk_type == QCA_HDR_RECV_TYPE_MIB) {
> +		if (priv->mib_autocast_handler)
> +			priv->mib_autocast_handler(dp, skb);
>  		return NULL;
> +	}
>  
>  	/* Remove QCA tag and recalculate checksum */
>  	skb_pull_rcsum(skb, QCA_HDR_LEN);
> @@ -73,9 +83,30 @@ static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
>  	return skb;
>  }
>  
> +static int qca_tag_connect(struct dsa_switch *ds)
> +{
> +	struct tag_qca_priv *priv;
> +
> +	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	ds->tagger_data = priv;
> +
> +	return 0;
> +}
> +
> +static void qca_tag_disconnect(struct dsa_switch *ds)
> +{
> +	kfree(ds->tagger_data);
> +	ds->tagger_data = NULL;
> +}
> +
>  static const struct dsa_device_ops qca_netdev_ops = {
>  	.name	= "qca",
>  	.proto	= DSA_TAG_PROTO_QCA,
> +	.connect = qca_tag_connect,
> +	.disconnect = qca_tag_disconnect,
>  	.xmit	= qca_tag_xmit,
>  	.rcv	= qca_tag_rcv,
>  	.needed_headroom = QCA_HDR_LEN,
> -- 
> 2.33.1
> 

