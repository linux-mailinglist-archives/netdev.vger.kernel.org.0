Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4CAD20C84F
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 15:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgF1Nvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 09:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbgF1Nvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 09:51:39 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A308C061794
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 06:51:39 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id s10so13953302wrw.12
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 06:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5mgxW9hsOT95jVSdqt76TrXzIwErXLqCYT4Cq2hSi2M=;
        b=NFO8nqxL0+fVz+1c89X1diLzfnP3FW2Y6K5MMkeSE24rXbkHW+OserBRVE94mmgKbk
         EOUijvy/Tbs9J39/PjQy9jMxzC83AaxW5gepBY90eFM55griMlLeJG6f9m7MDEEfuADR
         0vuA9xtQR55aG9Dx7YJx/cxCY/+yQlanRB2aI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5mgxW9hsOT95jVSdqt76TrXzIwErXLqCYT4Cq2hSi2M=;
        b=CJqlN1112Qm3RTJZW3Gmpoz5qzfp4KEg/9ZPQvBKjjvFA/TrDrIvaJnWUD1lW8MtNY
         BgBdoExVQnhhA46BlLlTFv8l270wpDKEIi2xbHSq6WfdB8eFF6ymKdrU2LXmpQWO8GfX
         hKyi0lFH2AHlyI+e+m25H3ER3AFcRix7Gb+kpFCImVf1wkBWeZ88Pdi40ibr7def2h+Z
         QsaeVSR2Y3K0rYgkZnRRzXWKs8i0JWYk+ncNqxJHcGsTMG0SjrjMtzgQZwradoR1qb/g
         QwtY4WOyYARUa1dL834u9C/o14hHFiM/kiENXiZI13aFFq1T3Pxibhf74EjcAmevOqkx
         0wxw==
X-Gm-Message-State: AOAM530XY6gQbP232w9LaIG0KDZgukneH7AkxGpTJw/mvOzq2E2TGlny
        P2aVrDni+kVKJoYurY9WmFmdn6fTxxLgug==
X-Google-Smtp-Source: ABdhPJwL9ReXwP1aRuRXCzuMl/FylxRej/lPdxWKwZRbrGQtRzVjp8f4q95EKHzgOAL03Z3H1xMPLw==
X-Received: by 2002:adf:f20a:: with SMTP id p10mr13696730wro.41.1593352298280;
        Sun, 28 Jun 2020 06:51:38 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id 138sm26714390wma.23.2020.06.28.06.51.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Jun 2020 06:51:37 -0700 (PDT)
Subject: Re: [PATCH net] bridge: mrp: Fix endian conversion and some other
 warnings
To:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        roopa@cumulusnetworks.com, davem@davemloft.net, kuba@kernel.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com
Cc:     kernel test robot <lkp@intel.com>
References: <20200628134516.3767607-1-horatiu.vultur@microchip.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <3adf6b93-6cd7-0a9f-9411-736b3d9ca148@cumulusnetworks.com>
Date:   Sun, 28 Jun 2020 16:51:36 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200628134516.3767607-1-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/06/2020 16:45, Horatiu Vultur wrote:
> The following sparse warnings are fixed:
> net/bridge/br_mrp.c:106:18: warning: incorrect type in assignment (different base types)
> net/bridge/br_mrp.c:106:18:    expected unsigned short [usertype]
> net/bridge/br_mrp.c:106:18:    got restricted __be16 [usertype]
> net/bridge/br_mrp.c:281:23: warning: incorrect type in argument 1 (different modifiers)
> net/bridge/br_mrp.c:281:23:    expected struct list_head *entry
> net/bridge/br_mrp.c:281:23:    got struct list_head [noderef] *
> net/bridge/br_mrp.c:332:28: warning: incorrect type in argument 1 (different modifiers)
> net/bridge/br_mrp.c:332:28:    expected struct list_head *new
> net/bridge/br_mrp.c:332:28:    got struct list_head [noderef] *
> net/bridge/br_mrp.c:332:40: warning: incorrect type in argument 2 (different modifiers)
> net/bridge/br_mrp.c:332:40:    expected struct list_head *head
> net/bridge/br_mrp.c:332:40:    got struct list_head [noderef] *
> net/bridge/br_mrp.c:682:29: warning: incorrect type in argument 1 (different modifiers)
> net/bridge/br_mrp.c:682:29:    expected struct list_head const *head
> net/bridge/br_mrp.c:682:29:    got struct list_head [noderef] *
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: 2f1a11ae11d222 ("bridge: mrp: Add MRP interface.")
> Fixes: 4b8d7d4c599182 ("bridge: mrp: Extend bridge interface")
> Fixes: 9a9f26e8f7ea30 ("bridge: mrp: Connect MRP API with the switchdev API")
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  net/bridge/br_mrp.c         | 2 +-
>  net/bridge/br_private.h     | 2 +-
>  net/bridge/br_private_mrp.h | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

> diff --git a/net/bridge/br_mrp.c b/net/bridge/br_mrp.c
> index 779e1eb754430..90592af9db619 100644
> --- a/net/bridge/br_mrp.c
> +++ b/net/bridge/br_mrp.c
> @@ -86,7 +86,7 @@ static struct sk_buff *br_mrp_skb_alloc(struct net_bridge_port *p,
>  {
>  	struct ethhdr *eth_hdr;
>  	struct sk_buff *skb;
> -	u16 *version;
> +	__be16 *version;
>  
>  	skb = dev_alloc_skb(MRP_MAX_FRAME_LENGTH);
>  	if (!skb)
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index 2130fe0194e64..e0ea6dbbc97ed 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -430,7 +430,7 @@ struct net_bridge {
>  	struct hlist_head		fdb_list;
>  
>  #if IS_ENABLED(CONFIG_BRIDGE_MRP)
> -	struct list_head		__rcu mrp_list;
> +	struct list_head		mrp_list;
>  #endif
>  };
>  
> diff --git a/net/bridge/br_private_mrp.h b/net/bridge/br_private_mrp.h
> index 33b255e38ffec..315eb37d89f0f 100644
> --- a/net/bridge/br_private_mrp.h
> +++ b/net/bridge/br_private_mrp.h
> @@ -8,7 +8,7 @@
>  
>  struct br_mrp {
>  	/* list of mrp instances */
> -	struct list_head		__rcu list;
> +	struct list_head		list;
>  
>  	struct net_bridge_port __rcu	*p_port;
>  	struct net_bridge_port __rcu	*s_port;
> 

