Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6F45B4F34
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 15:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbiIKNqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 09:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbiIKNqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 09:46:34 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB2532CCA6
        for <netdev@vger.kernel.org>; Sun, 11 Sep 2022 06:46:31 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id t5so9177669edc.11
        for <netdev@vger.kernel.org>; Sun, 11 Sep 2022 06:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=4Iv5TL0mfrsaoQS6g68dgiPxR0H0aebhiRLve3amcSo=;
        b=LkmjBPkOMWk0juzmA8i+Hoh0xzL2KkAvCTkXVK9a+NJCueFQ3AgaxkAU75mYxTEkPF
         BW3ciPdBVFIj/UWz+BDeL0tgXfAY66t95hIkUtfc9lnoXRHi0SprGg2E9zaRb9Ni+x/T
         5eO8vzjYt9v8SjVUpvE+KIWe5g3vx7uDKADqpKyeyJzqzBs8ITUdyN6+gSREp1hTdofz
         vPlSUZiaPmMWjPYlxMSeFZfhm0i+uf7eCgscauYuYW3bE0+Vimu6Bobxi6CTUME08wT+
         aIxQ//B+u8rUI2obegoECZiy6eDTJw4u3/fbGMxjFvAmp7sIOY6tz9AVbRY3hQ/LGMtS
         Frdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=4Iv5TL0mfrsaoQS6g68dgiPxR0H0aebhiRLve3amcSo=;
        b=gVAdEGYFReejEcnbK8OplEzXgQEbJZD2CJ8mgsDrePOG3pF2T6uKmL6663KWjJQDSN
         lWyEtGi8fMuKBZg51AGX3oGXx3ArO+t+Ilquwqv4LO9OEjOa/tXtSkKHwAkI0+TRhZdP
         z2ayvwpBKIjXNZypJk4iN1slepxMpHvdy/HyNyNCZQCCdRCoRx/BFq3/16GiFyrxjqdZ
         p27CRYVlXwObp0SWuo9nb4u/ew4H2vb2k7l+nljyOOcLrUd4YEVyur7ZBb6yvb2a5hzq
         +KZvdCccb/sj9XDHLDzWCx+t3MmKbe99LPmZ+gYmU0tWTibnxrSvdZWV2VcDbwdRZEI1
         P6IQ==
X-Gm-Message-State: ACgBeo0kqag8GzRh0d7zfAlQiurCjPSBSSG18aGWfePb249xVJzD+v+F
        w90yqJ8YXbcTiad5nX0Z1hw=
X-Google-Smtp-Source: AA6agR6u5Z+nvFCiuVnfq36xTaTHVzq5o1m4j6ucxS6g7gQcXIMODWMsPhTCJRYD6na1Qctovuw0qQ==
X-Received: by 2002:a05:6402:748:b0:44e:b48f:f5ec with SMTP id p8-20020a056402074800b0044eb48ff5ecmr19551608edy.146.1662903990337;
        Sun, 11 Sep 2022 06:46:30 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id lb26-20020a170907785a00b0073bdf71995dsm2997815ejc.139.2022.09.11.06.46.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Sep 2022 06:46:27 -0700 (PDT)
Date:   Sun, 11 Sep 2022 16:46:24 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v8 3/6] net: dsa: Introduce dsa tagger data
 operation.
Message-ID: <20220911134624.24a5pjlw77z6b7f3@skbuf>
References: <20220909085138.3539952-1-mattias.forsblad@gmail.com>
 <20220909085138.3539952-1-mattias.forsblad@gmail.com>
 <20220909085138.3539952-4-mattias.forsblad@gmail.com>
 <20220909085138.3539952-4-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220909085138.3539952-4-mattias.forsblad@gmail.com>
 <20220909085138.3539952-4-mattias.forsblad@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A proper prefix for this patch would be "net: dsa: tag_dsa: ", since
"net: dsa:" refers to the whole subsystem.

On Fri, Sep 09, 2022 at 10:51:35AM +0200, Mattias Forsblad wrote:
> Support connecting dsa tagger for frame2reg decoding
> with it's associated hookup functions.

s/it's/its/

> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> 
> Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
> ---
>  include/net/dsa.h |  5 +++++
>  net/dsa/tag_dsa.c | 32 +++++++++++++++++++++++++++++---
>  2 files changed, 34 insertions(+), 3 deletions(-)
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index 0e8a7ef17490..8510267d6188 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -130,6 +130,11 @@ struct dsa_lag {
>  	refcount_t refcount;
>  };
>  
> +struct dsa_tagger_data {
> +	void (*decode_frame2reg)(struct net_device *netdev,
> +				 struct sk_buff *skb);
> +};
> +

You probably mean to put this in include/linux/dsa/mv88e6xxx.h. Despite
the common naming, there is a big difference between DSA the framework
and DSA the Marvell implementation.

>  struct dsa_switch_tree {
>  	struct list_head	list;
>  
> diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
> index e4b6e3f2a3db..3dd1dcddaf05 100644
> --- a/net/dsa/tag_dsa.c
> +++ b/net/dsa/tag_dsa.c
> @@ -198,7 +198,10 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
>  static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
>  				  u8 extra)
>  {
> +	struct dsa_tagger_data *tagger_data;
> +	struct dsa_port *dp = dev->dsa_ptr;
>  	bool trap = false, trunk = false;
> +	struct dsa_switch *ds = dp->ds;
>  	int source_device, source_port;
>  	enum dsa_code code;
>  	enum dsa_cmd cmd;
> @@ -218,9 +221,9 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
>  
>  		switch (code) {
>  		case DSA_CODE_FRAME2REG:
> -			/* Remote management is not implemented yet,
> -			 * drop.
> -			 */
> +			tagger_data = ds->tagger_data;

You allocate one ds->tagger_data structure for each switch in the tree,
but you always use the tagger_data of the upstream-most "ds", the one
associated with the cpu_dp behind master->dsa_ptr.

How about minimally parsing the skb within the tagger, to figure out the
proper destination switch, and pass to tagger_data->decode_frame2reg()
the actual correct ds, plus a pointer to the skb so you can take a
reference on it?

> +			if (likely(tagger_data->decode_frame2reg))
> +				tagger_data->decode_frame2reg(dev, skb);
>  			return NULL;
>  		case DSA_CODE_ARP_MIRROR:
>  		case DSA_CODE_POLICY_MIRROR:
> @@ -323,6 +326,25 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
>  	return skb;
>  }
>  
> +static int dsa_tag_connect(struct dsa_switch *ds)
> +{
> +	struct dsa_tagger_data *tagger_data;
> +
> +	tagger_data = kzalloc(sizeof(*tagger_data), GFP_KERNEL);
> +	if (!tagger_data)
> +		return -ENOMEM;
> +
> +	ds->tagger_data = tagger_data;
> +
> +	return 0;
> +}
> +
> +static void dsa_tag_disconnect(struct dsa_switch *ds)
> +{
> +	kfree(ds->tagger_data);
> +	ds->tagger_data = NULL;
> +}
> +
>  #if IS_ENABLED(CONFIG_NET_DSA_TAG_DSA)
>  
>  static struct sk_buff *dsa_xmit(struct sk_buff *skb, struct net_device *dev)
> @@ -343,6 +365,8 @@ static const struct dsa_device_ops dsa_netdev_ops = {
>  	.proto	  = DSA_TAG_PROTO_DSA,
>  	.xmit	  = dsa_xmit,
>  	.rcv	  = dsa_rcv,
> +	.connect  = dsa_tag_connect,
> +	.disconnect = dsa_tag_disconnect,
>  	.needed_headroom = DSA_HLEN,
>  };
>  
> @@ -385,6 +409,8 @@ static const struct dsa_device_ops edsa_netdev_ops = {
>  	.proto	  = DSA_TAG_PROTO_EDSA,
>  	.xmit	  = edsa_xmit,
>  	.rcv	  = edsa_rcv,
> +	.connect  = dsa_tag_connect,
> +	.disconnect = dsa_tag_disconnect,
>  	.needed_headroom = EDSA_HLEN,
>  };
>  
> -- 
> 2.25.1
> 

