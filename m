Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89F8D6E3A5D
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 18:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbjDPQ5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 12:57:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjDPQ5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 12:57:04 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68ED81FE9;
        Sun, 16 Apr 2023 09:57:03 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-504e232fe47so4269968a12.2;
        Sun, 16 Apr 2023 09:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681664222; x=1684256222;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ULPJSdz1zrgmNqFOUW8doMiT+cRQuJfZObvpjAUQOk8=;
        b=FdO78lUolkXiGkSk0uOY8TYUrMddC0W3liTVk6ZZh2gNhFtEKZjEMLyeuIWSA+Q1Du
         k8623st4RhvI2f8XA4LJtnQ3HdecbJZ1NZ/PUbCcuP1TeA87d1H5VMz3t0nFCB3BhWwd
         iuaBqww/qxDMkoH1919Kt1ojN0/a3cj6wndkiNqHMdSZZJkha4zaYr3Jg0OO8w5UrD5b
         RDaiJ8dUf1gMdepdGrOl/fT8h2STsRs3pfHH3FUXSWpK0HsMBX3ILaspbd6ti/nDnHbw
         Zyq5Eo9MO/HP+OdBSitLnAg0ddPsciUlJ+ldFANdoOPNk9b/hj1yEpt6ammgCD4SnXVT
         QTcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681664222; x=1684256222;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ULPJSdz1zrgmNqFOUW8doMiT+cRQuJfZObvpjAUQOk8=;
        b=WhiqmIY7SYENG1MJXPV4zojLRtrmElg7sWrc9aPoa+stuyVk8PhnJu5pPBJihktrH6
         XfQhGVDgrLA+8Oc/4CwYlti1C1ROeKcqai87lAqHiRTMWjEdFQ3kf+wfseKTYci7VuDG
         wVKwP4GwiFxwQCGWNKTVq+VttwbjdIMi9YvymITG6qA6K+Rb+c6ooxGGCUgnXadwkybG
         ghNICoopYeYoMYIJ53XwVkSVVqsY+IvCf5PE0nreOJzrlUhGNbMbMQkW0yMBV94QO7Vq
         fVf6rstFNxEcZDYLF9oWbst6YWcYzy6fJjEds2Z30BoXKN7pqE79xiYDbSveXmZvMIZV
         KQ5g==
X-Gm-Message-State: AAQBX9fEAjeatt/kH7AxT36u3/Wr4NJazK9qGmjRVX/MB9Q7vIzj8/UG
        c1+8RHvY7lnYqBCdyjh1eqI=
X-Google-Smtp-Source: AKy350Yei1plO+r6qAvxmHIyhYBTrtZiwoE7cm7e37PHtZQ52RN8f10UdZeyFShf7ZZj8I8bJkpdGw==
X-Received: by 2002:a05:6402:3c2:b0:506:92d7:6dce with SMTP id t2-20020a05640203c200b0050692d76dcemr4210375edw.15.1681664221709;
        Sun, 16 Apr 2023 09:57:01 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id w17-20020aa7cb51000000b004aeeb476c5bsm4640725edt.24.2023.04.16.09.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Apr 2023 09:57:00 -0700 (PDT)
Date:   Sun, 16 Apr 2023 19:56:58 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v1 2/2] net: dsa: microchip: Add partial ACL
 support for ksz9477 switches
Message-ID: <20230416165658.fuo7vwer7m7ulkg2@skbuf>
References: <20230411172456.3003003-1-o.rempel@pengutronix.de>
 <20230411172456.3003003-1-o.rempel@pengutronix.de>
 <20230411172456.3003003-3-o.rempel@pengutronix.de>
 <20230411172456.3003003-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411172456.3003003-3-o.rempel@pengutronix.de>
 <20230411172456.3003003-3-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oleksij,

I only took a superficial look, and hence, here are some superficial comments.

On Tue, Apr 11, 2023 at 07:24:55PM +0200, Oleksij Rempel wrote:
> The ACL also implements a count function, generating an interrupt
> instead of a forwarding action. It can be used as a watchdog timer or an
> event counter.

Is the interrupt handled here? I didn't see cls_flower_stats().

> The ACL consists of three parts: matching rules, action
> rules, and processing entries. Multiple match conditions can be either
> AND'ed or OR'ed together.
> 
> This patch introduces support for a subset of the available ACL
> functionality, specifically layer 2 matching and prioritization of
> matched packets. For example:
> 
> tc qdisc add dev lan2 clsact
> tc filter add dev lan2 ingress protocol 0x88f7 flower skip_sw hw_tc 7
> 
> tc qdisc add dev lan1 clsact
> tc filter add dev lan1 ingress protocol 0x88f7 flower skip_sw hw_tc 7

Have you considered the "skbedit priority" action as opposed to hw_tc?

> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/dsa/microchip/Makefile      |   2 +-
>  drivers/net/dsa/microchip/ksz9477.c     |   7 +
>  drivers/net/dsa/microchip/ksz9477.h     |   7 +
>  drivers/net/dsa/microchip/ksz9477_acl.c | 950 ++++++++++++++++++++++++
>  drivers/net/dsa/microchip/ksz_common.c  |  40 +
>  drivers/net/dsa/microchip/ksz_common.h  |   1 +
>  6 files changed, 1006 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/net/dsa/microchip/ksz9477_acl.c
> 
> diff --git a/drivers/net/dsa/microchip/Makefile b/drivers/net/dsa/microchip/Makefile
> index 48360cc9fc68..50851519c9a1 100644
> --- a/drivers/net/dsa/microchip/Makefile
> +++ b/drivers/net/dsa/microchip/Makefile
> @@ -1,7 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ_COMMON)	+= ksz_switch.o
>  ksz_switch-objs := ksz_common.o
> -ksz_switch-objs += ksz9477.o
> +ksz_switch-objs += ksz9477.o ksz9477_acl.o
>  ksz_switch-objs += ksz8795.o
>  ksz_switch-objs += lan937x_main.o
>  
> diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
> index bf13d47c26cf..f2c34ab3d3eb 100644
> --- a/drivers/net/dsa/microchip/ksz9477.c
> +++ b/drivers/net/dsa/microchip/ksz9477.c
> @@ -1151,6 +1151,7 @@ int ksz9477_setup(struct dsa_switch *ds)
>  {
>  	struct ksz_device *dev = ds->priv;
>  	int ret = 0;
> +	int i;
>  
>  	ds->mtu_enforcement_ingress = true;
>  
> @@ -1176,6 +1177,12 @@ int ksz9477_setup(struct dsa_switch *ds)
>  	/* enable global MIB counter freeze function */
>  	ksz_cfg(dev, REG_SW_MAC_CTRL_6, SW_MIB_COUNTER_FREEZE, true);
>  
> +	for (i = 0; i < dev->info->port_cnt; i++) {
> +		if (i == dev->cpu_port)
> +			continue;

dsa_switch_for_each_user_port()

> +		ksz9477_port_acl_init(dev, i);

Don't ignore the return code.

> +	}
> +
>  	return 0;
>  }
>  
> diff --git a/drivers/net/dsa/microchip/ksz9477.h b/drivers/net/dsa/microchip/ksz9477.h
> index b6f7e3c46e3f..5201bccda0ed 100644
> --- a/drivers/net/dsa/microchip/ksz9477.h
> +++ b/drivers/net/dsa/microchip/ksz9477.h
> @@ -59,4 +59,11 @@ int ksz9477_switch_init(struct ksz_device *dev);
>  void ksz9477_switch_exit(struct ksz_device *dev);
>  void ksz9477_port_queue_split(struct ksz_device *dev, int port);
>  
> +
> +int ksz9477_port_acl_init(struct ksz_device *dev, int port);
> +int ksz9477_cls_flower_add(struct dsa_switch *ds, int port,
> +			   struct flow_cls_offload *cls, bool ingress);
> +int ksz9477_cls_flower_del(struct dsa_switch *ds, int port,
> +			   struct flow_cls_offload *cls, bool ingress);
> +
>  #endif
> diff --git a/drivers/net/dsa/microchip/ksz9477_acl.c b/drivers/net/dsa/microchip/ksz9477_acl.c
> new file mode 100644
> index 000000000000..319158ebbdd9
> --- /dev/null
> +++ b/drivers/net/dsa/microchip/ksz9477_acl.c
> +#define KSZ9477_ACL_ENTRY_SIZE		18
> +#define KSZ9477_ACL_MAX_ENTRIES		16
> +#define KSZ9477_MAC_TC			7

MAC_TC or MAX_TC?

> +	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
> +		u8 bcast[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
> +
> +		flow_rule_match_eth_addrs(rule, &ematch);
> +
> +		if (!is_zero_ether_addr(ematch.key->src)) {
> +			if (!ether_addr_equal(ematch.mask->src, bcast))

is_broadcast_ether_addr()

> +				goto not_full_mask_err;
> +
> +			src_mac = ematch.key->src;
> +		}
> +
> +		if (!is_zero_ether_addr(ematch.key->dst)) {
> +			if (!ether_addr_equal(ematch.mask->dst, bcast))
> +				goto not_full_mask_err;
> +
> +			dst_mac = ematch.key->dst;
> +		}
> +	}
> +
> +	acles = &acl->acles;
> +	/* ACL supports only one MAC per entry */
> +	required_entries = src_mac && dst_mac ? 2 : 1;
