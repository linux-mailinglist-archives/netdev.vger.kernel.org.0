Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2D3C69AD34
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 14:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbjBQNyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 08:54:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbjBQNyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 08:54:01 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1954C66CC1
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 05:53:46 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id er25so4289443edb.6
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 05:53:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/QW0mj2OAwfXeURyYtHmXL5vROau39LeBC17qnk7LD0=;
        b=bCo4B0Q5rTWvnptIaqqrFHU0ozKR8b6G2NtIoKP/rXOM5kYGhY/9MgG+9Dk5ob5X1x
         uP8SxSMwBE9MEAa1nMLnlVfdVrkLMXfqvEa+hLxmkLNrUprgDi4i9V6TZhEM4uZcddVN
         qmvutDpS3yBHWXzzom6bp6mo8zrhq1q65Zb9JQuTIYMeq6/3WKvsDG9VgVew99q+iAL3
         aH3r9lG39mpvX2gL5x2UPttzDH3jP8pFTX61xxSWsFFfSNgjRjwfPsBDaayFh54Zam2Q
         U3ArUvoMZKzdh1XqQMv1YnXa1vqrfVH4ddkWU/bUDMamoRg6xvRa+PqpfnppxqVnUMKc
         xXpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/QW0mj2OAwfXeURyYtHmXL5vROau39LeBC17qnk7LD0=;
        b=MsDd6l+Snb3uD1nLGNpMkElqzwcdPcLaL5pIiXnpEXOF6ePAJTgyXEBDdjY2KdIxqu
         ydvDdaaCWi0NKJkCSHRD6je3titDjdf4TvSXb0KMpHxtduBrXFT5+3Lx7VEJeEe+fXvw
         vnexXunciiW/1xbgiYqcMar7bVXUfkXaFAbAfrDY18GqnV/loddEoKD0ojCVMRNcisxr
         PfhcA0ZpS20cR4kUZ9QDE8SI5fCkfHYVYlsHM++ur90gPj0TJoytPTM/MQ43T4r55Fj1
         keSQ5NEWqTRCCsJh/0wu5w3fiZNBhxkt8yKoVXpZMdRHtrJKROP4KrATgLatcM6WkWB/
         93aw==
X-Gm-Message-State: AO0yUKW1rFZsE5aqQbeY/4V1mzRV6RCpUImDLLdL3Mvy3wTJO/DxNO9r
        5p3fnb99sTU0195KEqHgG/3bJQ==
X-Google-Smtp-Source: AK7set8WnNQRokhh3f4p2tA8kO1L7bydhK5WNBEkMBrcDrUpnWHpUemEoXtA4/LfrZ7tzcRD706OWw==
X-Received: by 2002:aa7:c695:0:b0:4ad:66b:84a8 with SMTP id n21-20020aa7c695000000b004ad066b84a8mr2008729edq.6.1676642024370;
        Fri, 17 Feb 2023 05:53:44 -0800 (PST)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id i28-20020a50d75c000000b004acde0a1ae5sm2321073edj.89.2023.02.17.05.53.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Feb 2023 05:53:44 -0800 (PST)
Message-ID: <a7cef78d-81fb-7de6-1f6e-a948cca1b46b@blackwall.org>
Date:   Fri, 17 Feb 2023 15:53:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] net-bridge: fix unsafe dereference of potential null ptr
 in __vlan_del()
Content-Language: en-US
To:     Alexander Sapozhnikov <alsp705@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
References: <20230217131657.12649-1-alsp705@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230217131657.12649-1-alsp705@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/02/2023 15:16, Alexander Sapozhnikov wrote:
> After having been compared to NULL value at br_vlan.c:399,
> pointer 'p' is passed as 1st parameter in call to function
> 'nbp_vlan_set_vlan_dev_state' at br_vlan.c:420, 
> where it is dereferenced at br_vlan.c:1722.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Signed-off-by: Alexander Sapozhnikov <alsp705@gmail.com>
> ---
>  net/bridge/br_vlan.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
> index bc75fa1e4666..87091e270adf 100644
> --- a/net/bridge/br_vlan.c
> +++ b/net/bridge/br_vlan.c
> @@ -417,7 +417,8 @@ static int __vlan_del(struct net_bridge_vlan *v)
>  		rhashtable_remove_fast(&vg->vlan_hash, &v->vnode,
>  				       br_vlan_rht_params);
>  		__vlan_del_list(v);
> -		nbp_vlan_set_vlan_dev_state(p, v->vid);
> +		if (p)
> +			nbp_vlan_set_vlan_dev_state(p, v->vid);
>  		br_multicast_toggle_one_vlan(v, false);
>  		br_multicast_port_ctx_deinit(&v->port_mcast_ctx);
>  		call_rcu(&v->rcu, nbp_vlan_rcu_free);

This cannot happen, read the code more carefully.
If you have a trace or have hit a bug, please provide the log.
Thanks,

Nacked-by: Nikolay Aleksandrov <razor@blackwall.org>


