Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47B892CBA2C
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 11:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388290AbgLBKIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 05:08:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387847AbgLBKIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 05:08:20 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8ECC0613CF
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 02:07:39 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id j14so3049401edy.3
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 02:07:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wGHJMbaMgaAU2ATKs3Nd4ux4bYzZZ+g3X83hZajJsRQ=;
        b=kJrv90035Kuy4k7X8uF6eIe/hUXoy2VHfmKvotEIvUWxUJbALuLQPzURmwHPqle0PL
         SfqnGNbHMUe8MONRODzsGhEsM9blnE3EYXEmrkz6IMYg6ZRsFmHJSnc1V4WwHYPdKHJt
         y2EfhWviAsiI0RQCBTU4UtgwUz1Nos7CVy6Ls0Nj05xkH5Ol7o7h/8HU4dige8uRhrcq
         Wq4dTbA24NsIPdc6hXQAtlFvy7ztrU8dObR4gdb4CpMK493lXEx/o4PXq0Ak5kJqIcba
         SqstAlr8civsp+gh4Zg7MWxezV1Mzc+BKaoOnK9EK2a7IaQsCy/ZlqFNRrtFc2oAVhzJ
         30gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wGHJMbaMgaAU2ATKs3Nd4ux4bYzZZ+g3X83hZajJsRQ=;
        b=pSG8N1m43gBWBM9ECnjiskgVMQ027ydSMn1ZuQ+HUu5m4YOUW9+KEYXpWHoCy6ufz3
         L9ftb40wbv6Hh9zC2yYWa/Ol1TfkAT9UvjZTCvlQCl/cQIFRmBh3oDObGo5/wtt6E5PD
         FvG0PB/6Q356+/01yrwec4Ehmf9Bd2lTujQieAQV8uNmiqVEHZULKGH8EqmpNasP2shN
         /3aGBelPmb3l5vDurpv8WbBt9Z1CvY3Qw9+hj87rTLuUtvD7BEANqv4dhWEkfEi4pYdz
         YRDR4k8UAMxKSmfT7GIRbNtvmihEVlaM8wnwkMSz5tTEn/yOKVhr2uVBBFLAqY1/DW2S
         Xe/Q==
X-Gm-Message-State: AOAM532719tPhwYqLYvcVqZqdtl9zfka2DePegxvKOecaFozeQJYfxZp
        oMX4F8AORF95/aBm4bljKvs=
X-Google-Smtp-Source: ABdhPJzhjq65Ttw8+RR2DCBiainjfcrtp0fVrK4v3wCNcQQpRl2X8m3eQCcapMudA1vWHlpaKIKCgA==
X-Received: by 2002:a50:9eae:: with SMTP id a43mr1777474edf.109.1606903658552;
        Wed, 02 Dec 2020 02:07:38 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id mb15sm801253ejb.9.2020.12.02.02.07.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 02:07:38 -0800 (PST)
Date:   Wed, 2 Dec 2020 12:07:36 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
Message-ID: <20201202100736.gdvi754tdcxrqb5b@skbuf>
References: <20201202091356.24075-1-tobias@waldekranz.com>
 <20201202091356.24075-3-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201202091356.24075-3-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 02, 2020 at 10:13:54AM +0100, Tobias Waldekranz wrote:
> Monitor the following events and notify the driver when:
> 
> - A DSA port joins/leaves a LAG.
> - A LAG, made up of DSA ports, joins/leaves a bridge.
> - A DSA port in a LAG is enabled/disabled (enabled meaning
>   "distributing" in 802.3ad LACP terms).
> 
> Each LAG interface to which a DSA port is attached is represented by a
> `struct dsa_lag` which is globally reachable from the switch tree and
> from each associated port.
> 
> When a LAG joins a bridge, the DSA subsystem will treat that as each
> individual port joining the bridge. The driver may look at the port's
> LAG pointer to see if it is associated with any LAG, if that is
> required. This is analogue to how switchdev events are replicated out
> to all lower devices when reaching e.g. a LAG.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>  include/net/dsa.h  |  97 +++++++++++++++++++++++++++++++++
>  net/dsa/dsa2.c     |  51 ++++++++++++++++++
>  net/dsa/dsa_priv.h |  31 +++++++++++
>  net/dsa/port.c     | 132 +++++++++++++++++++++++++++++++++++++++++++++
>  net/dsa/slave.c    |  83 +++++++++++++++++++++++++---
>  net/dsa/switch.c   |  49 +++++++++++++++++
>  6 files changed, 437 insertions(+), 6 deletions(-)
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index 4e60d2610f20..aaa350b78c55 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -7,6 +7,7 @@
>  #ifndef __LINUX_NET_DSA_H
>  #define __LINUX_NET_DSA_H
>  
> +#include <linux/bitmap.h>
>  #include <linux/if.h>
>  #include <linux/if_ether.h>
>  #include <linux/list.h>
> @@ -71,6 +72,7 @@ enum dsa_tag_protocol {
>  
>  struct packet_type;
>  struct dsa_switch;
> +struct dsa_lag;
>  
>  struct dsa_device_ops {
>  	struct sk_buff *(*xmit)(struct sk_buff *skb, struct net_device *dev);
> @@ -149,6 +151,13 @@ struct dsa_switch_tree {
>  
>  	/* List of DSA links composing the routing table */
>  	struct list_head rtable;
> +
> +	/* Link aggregates */
> +	struct {
> +		struct dsa_lag *pool;
> +		unsigned long *busy;
> +		unsigned int num;

Can we get rid of the busy array and just look at the refcounts?
Can we also get rid of the "num" variable?

> +	} lags;
>  };
