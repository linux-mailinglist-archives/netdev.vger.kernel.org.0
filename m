Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1405BD6B4
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 00:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbiISWBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 18:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiISWBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 18:01:03 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F20422F4
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 15:01:01 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id z2so1206210edi.1
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 15:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=RhVfg4Qcp1TGjYuh/qG0HdLXiDtMvn/nDK9BXmeRXHs=;
        b=VlPR/LmIBmku8c7WSZrF2Ltl+Y4ysM3ANBduqtogc2lEUh1BsfIc1vcsUJLEYZS5yd
         l2B71SQe2TsHOqnBLQstipBbiAgw763B0xttJe/XGLBXpn9qJIdegmTS+O7rjQIJ38g7
         a52a5KieC4ePnevvQbmnSx0eii8qNBs1FYBxDmctpvJSCE02G8ZOI37NeZd/W50985H4
         ZUDfWVbkYRaakx85OHO+QIDfQp42ub5lOHkvujCK71RKWYelBU8hptSKa8MjHkDXCh9M
         nVZaxG0+OxR+uIsaAzZYFqBXkiQexNCt92O8WFqgsVl6lIV0dM0oMoZYu4X4CK4fncq/
         dupw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=RhVfg4Qcp1TGjYuh/qG0HdLXiDtMvn/nDK9BXmeRXHs=;
        b=H/2zG5eKjP8eOaux3PUHcgPBHCJ7PLZ61lB8Li9bis1dRbi7/36gQ7+2TchSZzjp+4
         QpoSZvVH//p7Zkwk+a7OFUvlhHTC1HN1TElGJFivtt+Mj6ox090mlvL4j344Ec/b/BK+
         1vs9LRKae4wm9J+Ilm7QWjwBJouj3aOLlVGfBdWogb2E6jltxBudUmhTboex/91JO/x1
         AXYS+2BLI0BcKdbDVUsMDxqPdsFcXE6tYtAl94L8Q9QpY4PJCwJ06tZWHE3BpWnGtinm
         k9F1BVb29Z4bI2shO3B2plx1QBGsRyl2nxkd3mESoLfHeySU67nRis6A5i/CR9UlbPFN
         l7Dg==
X-Gm-Message-State: ACrzQf0Sr7zzy+EWNIzRozvjNr8v/Bf2mtltBry+yZl956VSFfYtI5mh
        Pn9cDmAEFyEvGcNaZ7poOUE=
X-Google-Smtp-Source: AMsMyM4Rbi2J1hzh2Ose5v1Wvs7PuRs+lsrgT7Uam2r+VyBL/t8CSv6WtlsDUbrKVMDle3aJLyChAg==
X-Received: by 2002:a05:6402:278c:b0:451:fabf:d885 with SMTP id b12-20020a056402278c00b00451fabfd885mr16917182ede.91.1663624859741;
        Mon, 19 Sep 2022 15:00:59 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id g17-20020a170906c19100b0073dbc35a0desm16143089ejz.100.2022.09.19.15.00.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 15:00:58 -0700 (PDT)
Date:   Tue, 20 Sep 2022 01:00:56 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux@armlinux.org.uk,
        ansuelsmth@gmail.com
Subject: Re: [PATCH net-next v14 3/7] net: dsa: Introduce dsa tagger data
 operation.
Message-ID: <20220919220056.dactchsdzhcb5sev@skbuf>
References: <20220919110847.744712-1-mattias.forsblad@gmail.com>
 <20220919110847.744712-1-mattias.forsblad@gmail.com>
 <20220919110847.744712-4-mattias.forsblad@gmail.com>
 <20220919110847.744712-4-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220919110847.744712-4-mattias.forsblad@gmail.com>
 <20220919110847.744712-4-mattias.forsblad@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Regarding the commit title. There is a difference between DSA the
framework and DSA the Marvell implementation of a tagging protocol.
This patch implements something pertaining to the latter, hence the
prefix should be "net: dsa: tag_dsa: ".

Why do I have a feeling I've said this before?
https://patchwork.kernel.org/project/netdevbpf/patch/20220909085138.3539952-4-mattias.forsblad@gmail.com/#25006260

Also, the body of the commit title, and the commit message, are
meaningless. What dsa tagger data operations? Connect what to what and why?
What does this patch really achieve? What I'd like to see as a reviewer
is a summary of the change, plus a justification for how the solution
came to be what it is.

On Mon, Sep 19, 2022 at 01:08:43PM +0200, Mattias Forsblad wrote:
> Support connecting dsa tagger for frame2reg decoding
> with its associated hookup functions.
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
> ---
>  include/linux/dsa/mv88e6xxx.h |  6 ++++++
>  net/dsa/dsa_priv.h            |  2 ++
>  net/dsa/tag_dsa.c             | 40 +++++++++++++++++++++++++++++++----
>  3 files changed, 44 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/dsa/mv88e6xxx.h b/include/linux/dsa/mv88e6xxx.h
> index 8c3d45eca46b..a8b6f3c110e5 100644
> --- a/include/linux/dsa/mv88e6xxx.h
> +++ b/include/linux/dsa/mv88e6xxx.h
> @@ -5,9 +5,15 @@
>  #ifndef _NET_DSA_TAG_MV88E6XXX_H
>  #define _NET_DSA_TAG_MV88E6XXX_H
>  
> +#include <net/dsa.h>
>  #include <linux/if_vlan.h>
>  
>  #define MV88E6XXX_VID_STANDALONE	0
>  #define MV88E6XXX_VID_BRIDGED		(VLAN_N_VID - 1)
>  
> +struct dsa_tagger_data {
> +	void (*decode_frame2reg)(struct dsa_switch *ds,
> +				 struct sk_buff *skb);
> +};
> +
>  #endif
> diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
> index 614fbba8fe39..3b23b37eb0f4 100644
> --- a/net/dsa/dsa_priv.h
> +++ b/net/dsa/dsa_priv.h
> @@ -17,6 +17,8 @@
>  
>  #define DSA_MAX_NUM_OFFLOADING_BRIDGES		BITS_PER_LONG
>  
> +#define DSA_FRAME2REG_SOURCE_DEV		GENMASK(5, 0)
> +

So in v8 I said that struct dsa_tagger_data is a hardware-specific data
structure, and it has no place in the common net/dsa/dsa_priv.h header
for the framework, and that you should move it to include/linux/dsa/mv88e6xxx.h.
https://patchwork.kernel.org/project/netdevbpf/patch/20220909085138.3539952-4-mattias.forsblad@gmail.com/#25006260
Which you did in v9. But whoop, one more hardware-specific definition
appears in v9, this DSA_FRAME2REG_SOURCE_DEV, again in net/dsa/dsa_priv.h.
https://patchwork.kernel.org/project/netdevbpf/patch/20220912112855.339804-4-mattias.forsblad@gmail.com/
Please use your own judgement to infer the fact that multiple attempts
to code up things in the same way will just lead to more of the same
observations during review.

>  enum {
>  	DSA_NOTIFIER_AGEING_TIME,
>  	DSA_NOTIFIER_BRIDGE_JOIN,
> diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
> index e4b6e3f2a3db..e7fdf3b5cb4a 100644
> --- a/net/dsa/tag_dsa.c
> +++ b/net/dsa/tag_dsa.c
> @@ -198,8 +198,11 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
>  static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
>  				  u8 extra)
>  {
> +	struct dsa_port *cpu_dp = dev->dsa_ptr;
> +	struct dsa_tagger_data *tagger_data;
>  	bool trap = false, trunk = false;
>  	int source_device, source_port;
> +	struct dsa_switch *ds;
>  	enum dsa_code code;
>  	enum dsa_cmd cmd;
>  	u8 *dsa_header;
> @@ -218,9 +221,16 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
>  
>  		switch (code) {
>  		case DSA_CODE_FRAME2REG:
> -			/* Remote management is not implemented yet,
> -			 * drop.
> -			 */
> +			source_device = FIELD_GET(DSA_FRAME2REG_SOURCE_DEV, dsa_header[0]);
> +			ds = dsa_switch_find(cpu_dp->dst->index, source_device);
> +			if (ds) {
> +				tagger_data = ds->tagger_data;

Can you please also parse the sequence number here, so the
decode_frame2reg() data consumer doesn't have to concern itself with the
dsa_header at all?

> +				if (likely(tagger_data->decode_frame2reg))
> +					tagger_data->decode_frame2reg(ds, skb);
> +			} else {
> +				net_err_ratelimited("RMU: Didn't find switch with index %d",
> +						    source_device);
> +			}
>  			return NULL;
>  		case DSA_CODE_ARP_MIRROR:
>  		case DSA_CODE_POLICY_MIRROR:
> @@ -254,7 +264,6 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
>  	source_port = (dsa_header[1] >> 3) & 0x1f;
>  
>  	if (trunk) {
> -		struct dsa_port *cpu_dp = dev->dsa_ptr;
>  		struct dsa_lag *lag;
>  
>  		/* The exact source port is not available in the tag,
> @@ -323,6 +332,25 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
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
> @@ -343,6 +371,8 @@ static const struct dsa_device_ops dsa_netdev_ops = {
>  	.proto	  = DSA_TAG_PROTO_DSA,
>  	.xmit	  = dsa_xmit,
>  	.rcv	  = dsa_rcv,
> +	.connect  = dsa_tag_connect,
> +	.disconnect = dsa_tag_disconnect,
>  	.needed_headroom = DSA_HLEN,
>  };
>  
> @@ -385,6 +415,8 @@ static const struct dsa_device_ops edsa_netdev_ops = {
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

