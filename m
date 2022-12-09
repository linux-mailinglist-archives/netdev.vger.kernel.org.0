Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 410AA647E9C
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 08:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiLIHcX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 02:32:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiLIHbr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 02:31:47 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98479322
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 23:30:48 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id j5-20020a05600c410500b003cfa9c0ea76so2761449wmi.3
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 23:30:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U7fC1syZtXHLgbpou3o4m3NT/tshVkaTSTf4nVD7gqQ=;
        b=w4kjIdlfb7CW4KRPyj0jUIA9uzCSD+/hYcGIYgGZrhaYcfs53qI/OoQgTYBV8W21IE
         67YLi4aKQMjDbFs0ntZOqB0/TCbF7uPc8qoPqFaOD5oFmdUhzjtm6BMe05SH6zX4Jd+q
         ImY50nTkuE7VU/00XTlwyJ6JMt3v/QhmbdCRZ6zJ55mS+TWJ45F8vo6+acNk02vEixhJ
         fKCmtITBJ9BXp6W5L40cvhXMEV5s2UjAl1LLRbl2vbzglXPUmaq+fvzeRDfGL43z62Vn
         hGnfL7kURf82TtyFBJ2pL8fgQ5ASGkTXabJFrVSyzQjKrMDp4ikyhKNjzIoNkLh+iIRP
         2CoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U7fC1syZtXHLgbpou3o4m3NT/tshVkaTSTf4nVD7gqQ=;
        b=p5IKOQ4nVbH7sxN7VLyhy+Yb8eGYbYbpkXufu18qxuI8A9C3ezsSS0h5mQ3/KrAnbR
         XshH/6FDoLUiUQbxlE9hldj1m42eH+nzMW5HOaDa8ywODiC/P0tPywX5x2JPiO60exVa
         /JAYAQWilp8M3mdrbq+CtGOoBDEF8Es4YOUt4+g80qnkySXzUSSE3hexKF2ZrzTIWd59
         6bGzpSbJyYG9dAYQAUQpYuKaBOxmSkmQnV51HorFw5159+co+K7BB5pf69nbNbjfwV7T
         QK9Tudh0UemYzKfRPX8L2kxGX+SPASft7bU8f/TzrDDPljSFsnIHF7NgW0a+7t7rH0V1
         xIaQ==
X-Gm-Message-State: ANoB5pnZP8B5e6LDXI37b3rhNXnrEoJufXFjO8IbrJr8jEDRBg8Xbtwx
        rZa+8PSswnThuZfvJCfCA03Rb58QTPImL9xaVdE=
X-Google-Smtp-Source: AA0mqf73WEFddJ5mcq4p/r0oYO7qKFZmkTLG7d7G6elwVCj2zm4nAgSvodaf+Qw9S4YhD6D+AEvIMw==
X-Received: by 2002:a05:600c:1c91:b0:3d2:640:c4e5 with SMTP id k17-20020a05600c1c9100b003d20640c4e5mr2293910wms.8.1670571047051;
        Thu, 08 Dec 2022 23:30:47 -0800 (PST)
Received: from [192.168.0.161] (79-100-144-200.ip.btc-net.bg. [79.100.144.200])
        by smtp.gmail.com with ESMTPSA id p24-20020a05600c205800b003c6b874a0dfsm1136494wmg.14.2022.12.08.23.30.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Dec 2022 23:30:46 -0800 (PST)
Message-ID: <455ce972-3b48-4ec3-92c8-3a50f7d96918@blackwall.org>
Date:   Fri, 9 Dec 2022 09:30:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 05/14] bridge: mcast: Expose
 br_multicast_new_group_src()
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, mlxsw@nvidia.com
References: <20221208152839.1016350-1-idosch@nvidia.com>
 <20221208152839.1016350-6-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20221208152839.1016350-6-idosch@nvidia.com>
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
> Currently, new group source entries are only created in response to
> received Membership Reports. Subsequent patches are going to allow user
> space to install (*, G) entries with a source list.
> 
> As a preparatory step, expose br_multicast_new_group_src() so that it
> could later be invoked from the MDB code (i.e., br_mdb.c) that handles
> RTM_NEWMDB messages.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/bridge/br_multicast.c | 2 +-
>  net/bridge/br_private.h   | 3 +++
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
> index db4c3900ae95..b2bc23fdcee5 100644
> --- a/net/bridge/br_multicast.c
> +++ b/net/bridge/br_multicast.c
> @@ -1232,7 +1232,7 @@ br_multicast_find_group_src(struct net_bridge_port_group *pg, struct br_ip *ip)
>  	return NULL;
>  }
>  
> -static struct net_bridge_group_src *
> +struct net_bridge_group_src *
>  br_multicast_new_group_src(struct net_bridge_port_group *pg, struct br_ip *src_ip)
>  {
>  	struct net_bridge_group_src *grp_src;
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index 3997e16c15fc..183de6c57d72 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -974,6 +974,9 @@ void br_multicast_sg_add_exclude_ports(struct net_bridge_mdb_entry *star_mp,
>  				       struct net_bridge_port_group *sg);
>  struct net_bridge_group_src *
>  br_multicast_find_group_src(struct net_bridge_port_group *pg, struct br_ip *ip);
> +struct net_bridge_group_src *
> +br_multicast_new_group_src(struct net_bridge_port_group *pg,
> +			   struct br_ip *src_ip);
>  void br_multicast_del_group_src(struct net_bridge_group_src *src,
>  				bool fastleave);
>  void br_multicast_ctx_init(struct net_bridge *br,

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>

