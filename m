Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34A7B647E9F
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 08:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbiLIHdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 02:33:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiLIHc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 02:32:58 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86A76260
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 23:32:53 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id o15so2580460wmr.4
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 23:32:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4CgxZCNJws0j636Fy5T/cCAzlRVsdGEH7eheOE17lVg=;
        b=06BPTj6mlub4bNGZ1y2nuZaPVTBeLJHSocCjSheTHZPY17Kn9HexRVW7MXile1VBLN
         EKxFcIpd7aY7zKxadBB6umGdQ6+kaWVFcJG2UUCU3RPxaZXHtz+dz1ADwAcQr9Kmpv7K
         RfTsCZlK6smY30fAhuFM8af5wZwWcXUgA/91s3q64RWI5RvOxewufDBieZCqB3i0ME3R
         eysAv4R8btVvK7EF5zClnFM3SreAj9U3nbw3gaFTq9iAq4E7hL+RmZautB5oIJBMPAn7
         v9fuSPCe2sqgm123+S9mzWeN/vS2EZg3xLlQKemlAQJz0U9YWQuLUIAHS1wEcUCsKwp7
         iPtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4CgxZCNJws0j636Fy5T/cCAzlRVsdGEH7eheOE17lVg=;
        b=YTw97rjVFYqBNPedFq2xvXxn1PtO4GpUjEiw9J2EUsAkbcRXFybk/jYaR2pG2VATXp
         cbv7gb9cZllE6F9mplPmxSWI/ZIppIYnGQqzubJ7uKJgUyKstB/G8g6FREjUrW/b2c3m
         bZsyJ3rkebUEob6s/N3lf+v6RolkhkAPg7vu+TcTeJ2rsLA0GJ2wVWX/HbXY2yNLt8jB
         u2e1W9XFdgecPwpYAWg237/Cazw6mTioJ15R/CbbNHIsX6vEnNJjTDfaBQbqTjJ/uoyP
         rIbA/lgxEUOSKs6mH3rpE0DfuqWdfwhJGSTcSv5PFEScWfINx7T3Z/9CCtmwSYnSyPVz
         3lVg==
X-Gm-Message-State: ANoB5pnyA5MClbreWCObS34KjzOr2GENm+Zg5UgySAcKdNGs+VDKJzgH
        nIBQy47aU7TJC7bVMBse+uPFQg==
X-Google-Smtp-Source: AA0mqf70l6iVwjERfcXUvrpUCnbof3YTt6IRdEgqVDRks9VmJuZwOvG+z/fS2ECrKV0wActUZ/Bf2Q==
X-Received: by 2002:a05:600c:1c81:b0:3d1:e907:17cb with SMTP id k1-20020a05600c1c8100b003d1e90717cbmr3744277wms.1.1670571172283;
        Thu, 08 Dec 2022 23:32:52 -0800 (PST)
Received: from [192.168.0.161] (79-100-144-200.ip.btc-net.bg. [79.100.144.200])
        by smtp.gmail.com with ESMTPSA id h5-20020a05600c2ca500b003c6bbe910fdsm9054483wmc.9.2022.12.08.23.32.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Dec 2022 23:32:51 -0800 (PST)
Message-ID: <b7933945-0c30-f007-3bea-5f6e5fc448a3@blackwall.org>
Date:   Fri, 9 Dec 2022 09:32:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 08/14] bridge: mcast: Avoid arming group timer
 when (S, G) corresponds to a source
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, mlxsw@nvidia.com
References: <20221208152839.1016350-1-idosch@nvidia.com>
 <20221208152839.1016350-9-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20221208152839.1016350-9-idosch@nvidia.com>
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
> User space will soon be able to install a (*, G) with a source list,
> prompting the creation of a (S, G) entry for each source.
> 
> In this case, the group timer of the (S, G) entry should never be set.
> 
> Solve this by adding a new field to the MDB configuration structure that
> denotes whether the (S, G) corresponds to a source or not.
> 
> The field will be set in a subsequent patch where br_mdb_add_group_sg()
> is called in order to create a (S, G) entry for each user provided
> source.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/bridge/br_mdb.c     | 2 +-
>  net/bridge/br_private.h | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
> index 95780652cdbf..7cda9d1c5c93 100644
> --- a/net/bridge/br_mdb.c
> +++ b/net/bridge/br_mdb.c
> @@ -814,7 +814,7 @@ static int br_mdb_add_group_sg(const struct br_mdb_config *cfg,
>  		return -ENOMEM;
>  	}
>  	rcu_assign_pointer(*pp, p);
> -	if (!(flags & MDB_PG_FLAGS_PERMANENT))
> +	if (!(flags & MDB_PG_FLAGS_PERMANENT) && !cfg->src_entry)
>  		mod_timer(&p->timer,
>  			  now + brmctx->multicast_membership_interval);
>  	br_mdb_notify(cfg->br->dev, mp, p, RTM_NEWMDB);
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index 74f17b56c9eb..e98bfe3c02e1 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -98,6 +98,7 @@ struct br_mdb_config {
>  	struct net_bridge_port		*p;
>  	struct br_mdb_entry		*entry;
>  	struct br_ip			group;
> +	bool				src_entry;
>  };
>  #endif
>  

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>

