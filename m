Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B50D14F84B6
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 18:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345663AbiDGQSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 12:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345681AbiDGQSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 12:18:45 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A8BC1E6FA3
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 09:16:44 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id b2-20020a17090a010200b001cb0c78db57so3532003pjb.2
        for <netdev@vger.kernel.org>; Thu, 07 Apr 2022 09:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0yrxVL6xhRd/sdLuiSvmYyX87dqeoDckLZbdQPLqkd8=;
        b=YLx0Q8tKCRfI/UO7dFeN4/R+v2Tp/kB7N0smu8bt0DssonIDnzvxDIV3O/s6WLCWXE
         3kTeeulbNvJlxV3Hg4JnQ+PMORipZXgsjNNadhhPEV6d3knnxD9SGQmifnJeoP8zQ2nH
         NdFlpJaW8O7LnVgJoge/9/DWjfQqmOcrWZBwMAaVlgC86NdG6jzHA7v1OoEUVRnOxhwE
         kbKllme/FsqhEIX8glGlhM0kO/KpBhgR+LmA/Csnoa4ZjO53azDAekaB+hpbBAJAPYge
         dglPKpT5wJ2tlQwM2UPHk8lszSKPvWYePjvoqzDAofDfq21rcM7kkgP5oNSZSU78dc6o
         zy6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0yrxVL6xhRd/sdLuiSvmYyX87dqeoDckLZbdQPLqkd8=;
        b=dLM2bu2Juctu4gFv3QrgZvBcLxjeDJhG/O+fK0zSZmwproLpf03xkxAK7UDAgQJiIv
         B/HqDir9L68S736wwFuh0KzDejUMQdc/GZvV4UGlXHACso8ouEcixCotntX4QVeOlHea
         wRkZLVC5QC9/h2R97U4axMoldInKnNVXYd7bvMBEXbcMbSvTKWIlodTBTS5c6yGQJp3e
         WN4HVWnoJqw3X0xCuQwBYFCiJYMVY+cvM4BW3skGKSKiEtcT33XO4ZJwKmFJu8uQKxRK
         o3/9BJkKFl9UbrM3HHHhsZGJAEOzHaB9wycoDx6FDaDWmps/w3uKgb7bQN08LPoPlgot
         OSzQ==
X-Gm-Message-State: AOAM530sbs4XZfvUMkzegAzN1fu2iLL1sDvcSNbUxa4jMtLAx7QIngH8
        tbqNLrBI/ftM1qAo8EzOlgMbIQ2USc2cEQ==
X-Google-Smtp-Source: ABdhPJwfA7nNG9jVbCWmPh2bqGFoRCrVJ1/xJcVPzuBoJ0Twx2exhcOLf6U05UxRLCnoFSf/0NSA1A==
X-Received: by 2002:a17:90a:1142:b0:1ca:ad6b:cab4 with SMTP id d2-20020a17090a114200b001caad6bcab4mr16730953pje.144.1649348203819;
        Thu, 07 Apr 2022 09:16:43 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id nn7-20020a17090b38c700b001c9ba103530sm9390070pjb.48.2022.04.07.09.16.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 09:16:43 -0700 (PDT)
Date:   Thu, 7 Apr 2022 09:16:40 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Dave Jones <davej@codemonkey.org.uk>
Cc:     netdev@vger.kernel.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        bridge@lists.linux-foundation.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] decouple llc/bridge
Message-ID: <20220407091640.1551b9d4@hermes.local>
In-Reply-To: <20220407151217.GA8736@codemonkey.org.uk>
References: <20220407151217.GA8736@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Apr 2022 11:12:17 -0400
Dave Jones <davej@codemonkey.org.uk> wrote:

> I was wondering why the llc code was getting compiled and it turned out
> to be because I had bridging enabled. It turns out to only needs it for
> a single function (llc_mac_hdr_init).
> 
> Converting this to a static inline like the other llc functions it uses
> allows to decouple the dependency
> 
> Signed-off-by: Dave Jones <davej@codemonkey.org.uk>
> 
> diff --git include/net/llc.h include/net/llc.h
> index e250dca03963..edcb120ee6b0 100644
> --- include/net/llc.h
> +++ include/net/llc.h
> @@ -13,6 +13,7 @@
>   */
>  
>  #include <linux/if.h>
> +#include <linux/if_arp.h>
>  #include <linux/if_ether.h>
>  #include <linux/list.h>
>  #include <linux/spinlock.h>
> @@ -100,8 +101,34 @@ extern struct list_head llc_sap_list;
>  int llc_rcv(struct sk_buff *skb, struct net_device *dev, struct packet_type *pt,
>  	    struct net_device *orig_dev);
>  
> -int llc_mac_hdr_init(struct sk_buff *skb, const unsigned char *sa,
> -		     const unsigned char *da);
> +/**
> + *      llc_mac_hdr_init - fills MAC header fields
> + *      @skb: Address of the frame to initialize its MAC header
> + *      @sa: The MAC source address
> + *      @da: The MAC destination address
> + *
> + *      Fills MAC header fields, depending on MAC type. Returns 0, If MAC type
> + *      is a valid type and initialization completes correctly 1, otherwise.
> + */
> +static inline int llc_mac_hdr_init(struct sk_buff *skb,
> +				   const unsigned char *sa, const unsigned char *da)
> +{
> +	int rc = -EINVAL;
> +
> +	switch (skb->dev->type) {
> +	case ARPHRD_ETHER:
> +	case ARPHRD_LOOPBACK:
> +		rc = dev_hard_header(skb, skb->dev, ETH_P_802_2, da, sa,
> +				     skb->len);
> +		if (rc > 0)
> +			rc = 0;
> +		break;
> +	default:
> +		break;
> +	}
> +	return rc;
> +}
> +
>  
>  void llc_add_pack(int type,
>  		  void (*handler)(struct llc_sap *sap, struct sk_buff *skb));
> diff --git net/802/Kconfig net/802/Kconfig
> index aaa83e888240..8bea5d1d5118 100644
> --- net/802/Kconfig
> +++ net/802/Kconfig
> @@ -1,7 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  config STP
>  	tristate
> -	select LLC
>  
>  config GARP
>  	tristate
> diff --git net/bridge/Kconfig net/bridge/Kconfig
> index 3c8ded7d3e84..c011856d3386 100644
> --- net/bridge/Kconfig
> +++ net/bridge/Kconfig
> @@ -5,7 +5,6 @@
>  
>  config BRIDGE
>  	tristate "802.1d Ethernet Bridging"
> -	select LLC
>  	select STP
>  	depends on IPV6 || IPV6=n
>  	help
> diff --git net/llc/llc_output.c net/llc/llc_output.c
> index 5a6466fc626a..ad66886ed141 100644
> --- net/llc/llc_output.c
> +++ net/llc/llc_output.c
> @@ -13,34 +13,6 @@
>  #include <net/llc.h>
>  #include <net/llc_pdu.h>
>  
> -/**
> - *	llc_mac_hdr_init - fills MAC header fields
> - *	@skb: Address of the frame to initialize its MAC header
> - *	@sa: The MAC source address
> - *	@da: The MAC destination address
> - *
> - *	Fills MAC header fields, depending on MAC type. Returns 0, If MAC type
> - *	is a valid type and initialization completes correctly 1, otherwise.
> - */
> -int llc_mac_hdr_init(struct sk_buff *skb,
> -		     const unsigned char *sa, const unsigned char *da)
> -{
> -	int rc = -EINVAL;
> -
> -	switch (skb->dev->type) {
> -	case ARPHRD_ETHER:
> -	case ARPHRD_LOOPBACK:
> -		rc = dev_hard_header(skb, skb->dev, ETH_P_802_2, da, sa,
> -				     skb->len);
> -		if (rc > 0)
> -			rc = 0;
> -		break;
> -	default:
> -		break;
> -	}
> -	return rc;
> -}
> -
>  /**
>   *	llc_build_and_send_ui_pkt - unitdata request interface for upper layers
>   *	@sap: sap to use

You may break other uses of LLC.

Why not open code as different function.  I used the llc stuff because there
were multiple copies of same code (DRY).
