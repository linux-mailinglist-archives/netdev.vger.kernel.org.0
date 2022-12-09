Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E94B4647EFB
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 09:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbiLIIJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 03:09:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiLIII4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 03:08:56 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD775C770
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 00:08:51 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id f13-20020a1cc90d000000b003d08c4cf679so2813329wmb.5
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 00:08:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sInxKAvWLrMiI4fj8yMPqsC6tYHDJ+LuR9I4DU3L8N4=;
        b=C0/uDINpzs13oxx0s5AE72rKVpMHz0zuD3NZ9ti5IZ6TL4EumMAJ+YO8DWegNoILKJ
         pEfV8UwZ59XNbeHBrG//Eo7m1KM9+Y5aUj3rUj81RDYaDbsetkUD6TSMskO7ZkPtzebn
         PUxHKoT3owEDE/O35e8vt+82aGJNm70nUwL4P4/t4prX1Qg6pP1C2c9V9ZkMPpdpD8ud
         FPo6pE0WVbRlaF3nyAnzh2IpQu8XmkA6te8nzGCuPTSU2S0a5xSNhY3/ln5WKotzwzn5
         yWKWqz5T6qUNKZwF9K/S9nVnBsppwDBE+WinzzXSaVJxAtd7edX8S2EFNbAov24AXhrU
         fpSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sInxKAvWLrMiI4fj8yMPqsC6tYHDJ+LuR9I4DU3L8N4=;
        b=UsgSQg6wbhC66HwTFt0h7sOfaVU71JSL2UXVWGI/v+QlG8zgchJRBLeV0I47P/csoI
         CISTD60nfKzkBvLR4gNCLjL0AH2cBNQQ1/ICIxAyTlz3t+skkpL5216+WxftSrlDODwL
         hOwWA6cXQVkuG98a6Uv6qavHmvK2gu1aVI6zXJn2OwyYVBN1yDGaYNFUNa7qpbgSZQH4
         ZhgJez3/kTxCnXWhVRCV5713HARxVnbxkX10CyXfAf3PykLNtE6tSFFUnDGWz5B4MsFT
         uCN4ODlCiyTeoH5KWbXxSIJjnxmHH8EBEkl/2fkVduz1InpYxR+rgJB92MOV60jCE6MK
         F1/g==
X-Gm-Message-State: ANoB5pl/SJHRd44HvEKptJiXdRZa6BPVxa6yZ+xPE52DnEN8XrQN3Qpy
        GZS6RgGQh5Ngy55Nf3jwwaJo4w==
X-Google-Smtp-Source: AA0mqf7t3oeNURel+lWMdzu3MPG7iMqZFhl65PnQWInUfiEQAcn3d7W6cN+DOrn0TXkeDRRGvxTSrw==
X-Received: by 2002:a05:600c:1c87:b0:3cf:ae53:9193 with SMTP id k7-20020a05600c1c8700b003cfae539193mr4291964wms.39.1670573330140;
        Fri, 09 Dec 2022 00:08:50 -0800 (PST)
Received: from [192.168.0.161] (79-100-144-200.ip.btc-net.bg. [79.100.144.200])
        by smtp.gmail.com with ESMTPSA id fc18-20020a05600c525200b003d04e4ed873sm8263495wmb.22.2022.12.09.00.08.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Dec 2022 00:08:49 -0800 (PST)
Message-ID: <38bcf2b8-83eb-1df7-b836-d2de4db851a0@blackwall.org>
Date:   Fri, 9 Dec 2022 10:08:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 12/14] bridge: mcast: Support replacement of MDB
 port group entries
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, mlxsw@nvidia.com
References: <20221208152839.1016350-1-idosch@nvidia.com>
 <20221208152839.1016350-13-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20221208152839.1016350-13-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/12/2022 17:28, Ido Schimmel wrote:
> Now that user space can specify additional attributes of port group
> entries such as filter mode and source list, it makes sense to allow
> user space to atomically modify these attributes by replacing entries
> instead of forcing user space to delete the entries and add them back.
> 
> Replace MDB port group entries when the 'NLM_F_REPLACE' flag is
> specified in the netlink message header.
> 
> When a (*, G) entry is replaced, update the following attributes: Source
> list, state, filter mode, protocol and flags. If the entry is temporary
> and in EXCLUDE mode, reset the group timer to the group membership
> interval. If the entry is temporary and in INCLUDE mode, reset the
> source timers of associated sources to the group membership interval.
> 
> Examples:
> 
>  # bridge mdb replace dev br0 port dummy10 grp 239.1.1.1 permanent source_list 192.0.2.1,192.0.2.2 filter_mode include
>  # bridge -d -s mdb show
>  dev br0 port dummy10 grp 239.1.1.1 src 192.0.2.2 permanent filter_mode include proto static     0.00
>  dev br0 port dummy10 grp 239.1.1.1 src 192.0.2.1 permanent filter_mode include proto static     0.00
>  dev br0 port dummy10 grp 239.1.1.1 permanent filter_mode include source_list 192.0.2.2/0.00,192.0.2.1/0.00 proto static     0.00
> 
>  # bridge mdb replace dev br0 port dummy10 grp 239.1.1.1 permanent source_list 192.0.2.1,192.0.2.3 filter_mode exclude proto zebra
>  # bridge -d -s mdb show
>  dev br0 port dummy10 grp 239.1.1.1 src 192.0.2.3 permanent filter_mode include proto zebra  blocked    0.00
>  dev br0 port dummy10 grp 239.1.1.1 src 192.0.2.1 permanent filter_mode include proto zebra  blocked    0.00
>  dev br0 port dummy10 grp 239.1.1.1 permanent filter_mode exclude source_list 192.0.2.3/0.00,192.0.2.1/0.00 proto zebra     0.00
> 
>  # bridge mdb replace dev br0 port dummy10 grp 239.1.1.1 temp source_list 192.0.2.4,192.0.2.3 filter_mode include proto bgp
>  # bridge -d -s mdb show
>  dev br0 port dummy10 grp 239.1.1.1 src 192.0.2.4 temp filter_mode include proto bgp     0.00
>  dev br0 port dummy10 grp 239.1.1.1 src 192.0.2.3 temp filter_mode include proto bgp     0.00
>  dev br0 port dummy10 grp 239.1.1.1 temp filter_mode include source_list 192.0.2.4/259.44,192.0.2.3/259.44 proto bgp     0.00
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/bridge/br_mdb.c     | 103 ++++++++++++++++++++++++++++++++++++++--
>  net/bridge/br_private.h |   1 +
>  2 files changed, 99 insertions(+), 5 deletions(-)
> 
> diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
> index 72d4e53193e5..98d899427c03 100644
> --- a/net/bridge/br_mdb.c
> +++ b/net/bridge/br_mdb.c
> @@ -802,6 +802,28 @@ __br_mdb_choose_context(struct net_bridge *br,
>  	return brmctx;
>  }
>  
> +static int br_mdb_replace_group_sg(const struct br_mdb_config *cfg,
> +				   struct net_bridge_mdb_entry *mp,
> +				   struct net_bridge_port_group *pg,
> +				   struct net_bridge_mcast *brmctx,
> +				   unsigned char flags,
> +				   struct netlink_ext_ack *extack)

extack seems unused here

> +{
> +	unsigned long now = jiffies;
> +
> +	pg->flags = flags;
> +	pg->rt_protocol = cfg->rt_protocol;
> +	if (!(flags & MDB_PG_FLAGS_PERMANENT) && !cfg->src_entry)
> +		mod_timer(&pg->timer,
> +			  now + brmctx->multicast_membership_interval);
> +	else
> +		del_timer(&pg->timer);
> +
> +	br_mdb_notify(cfg->br->dev, mp, pg, RTM_NEWMDB);
> +
> +	return 0;
> +}
> +
>  static int br_mdb_add_group_sg(const struct br_mdb_config *cfg,
>  			       struct net_bridge_mdb_entry *mp,
>  			       struct net_bridge_mcast *brmctx,
[snip]
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index cdc9e040f1f6..2473add41e16 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -107,6 +107,7 @@ struct br_mdb_config {
>  	struct br_mdb_src_entry		*src_entries;
>  	int				num_src_entries;
>  	u8				rt_protocol;
> +	u32				nlflags;

nlmsg_flags is u16 (__u16), also I'd add it before rt_protocol

>  };
>  #endif
>  

