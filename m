Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1415BFA49
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 11:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbiIUJL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 05:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbiIUJLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 05:11:24 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D598A1D7
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 02:11:22 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id r7so8809626wrm.2
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 02:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date;
        bh=GOhbE3A+8wYCrEykuOBC1RAYe432gmD8jlXYFnSlnOI=;
        b=BWjXCZoVpfULiZN41JE4mgI//kTFGkoS5IcaOvCyQtYYz7/Dasud4JtqSs9opLXvtz
         02k5AYJtb/D2TDy3E+jgyPTwe8gc3uBC1YJiF/7gV17JBWAg4gXHEXRBy6JDbTrDK+ZD
         epwtd+LM1ZaSKxaBsJI69uvUcn+CEkb8KKywA5ZPna6Mz6qzshwMprK7XJRF2yL6LNvd
         GKyhOq1VMBPkjeW8pS4SM3rpzXpDMg9e9Z/SwkjkjJJH0/Rkw1mR2uCgClQoxlqHymqv
         H0nY8IvD8W3+Lu95NMDTriUdNt1tSV4e9uhlg34G0XjYcuozZuBKWjPqAWGPlhDmHoGY
         BRmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=GOhbE3A+8wYCrEykuOBC1RAYe432gmD8jlXYFnSlnOI=;
        b=13DosYrqXn3ejfgViBVuI257SVQiU7X32ARHYQIwdkS8l3itJW+rogvZbg27TCZ4YR
         J4T5lPmFvz6o500ooXPMrSiVVSRABV6Aia+5iu5Tc7a2EZnRatX/0PZh8bH1f+47QmeS
         YfWxYdNo/jek0h3XeGKcfjCP/hROi+UZPqdRMR8vBXj6j8Djsqpadc9kGSBuTj7mSaxe
         meq56ThEkwItBu6jJ7PNdZvaXtSjHYatni9PFmyIKumIofUtWQj2dotQ3W05mvsTuJf2
         X+r2ZdCDvhpxtA9NmecCXulEhRhdL0ggnyLdv7oAz5MDXig+sdV5TQRnIJqB/lAo0Mrd
         lp9g==
X-Gm-Message-State: ACrzQf2WbaZPZE36nBfZOmGp7x1kMmF1WgmRgjOTGhAxIPb+B848BRzh
        J9NpSH1MOHaZgTXSeicC6Ch6EA==
X-Google-Smtp-Source: AMsMyM6OaLfa73R//G1/yYeptTwZy+97f0THX4kbd9kyY2QDhUQYtek7bFWO8CSaF1izxq6+Er5xWw==
X-Received: by 2002:a5d:6481:0:b0:228:dc1f:4f95 with SMTP id o1-20020a5d6481000000b00228dc1f4f95mr16691045wri.298.1663751480601;
        Wed, 21 Sep 2022 02:11:20 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:d6f:4b37:41db:866e? ([2a01:e0a:b41:c160:d6f:4b37:41db:866e])
        by smtp.gmail.com with ESMTPSA id n13-20020adfe34d000000b002285f73f11dsm2303350wrj.81.2022.09.21.02.11.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Sep 2022 02:11:20 -0700 (PDT)
Message-ID: <1ff2e97e-003f-e6b4-d724-c42449fde221@6wind.com>
Date:   Wed, 21 Sep 2022 11:11:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next] rtnetlink: Honour NLM_F_ECHO flag in rtnl_{new,
 set}link
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Guillaume Nault <gnault@redhat.com>
References: <20220921030721.280528-1-liuhangbin@gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <20220921030721.280528-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Le 21/09/2022 à 05:07, Hangbin Liu a écrit :
> Netlink messages are used for communicating between user and kernel space.
> When user space configures the kernel with netlink messages, it can set the
> NLM_F_ECHO flag to request the kernel to send the applied configuration back
> to the caller. This allows user space to retrieve configuration information
> that are filled by the kernel (either because these parameters can only be
> set by the kernel or because user space let the kernel choose a default
> value).
> 
> This patch handles NLM_F_ECHO flag and send link info back after
> rtnl_{new, set}link.
> 
> Suggested-by: Guillaume Nault <gnault@redhat.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---

[snip]

> @@ -3336,9 +3381,9 @@ static int rtnl_newlink_create(struct sk_buff *skb, struct ifinfomsg *ifm,
>  		return PTR_ERR(dest_net);
>  
>  	if (tb[IFLA_LINK_NETNSID]) {
> -		int id = nla_get_s32(tb[IFLA_LINK_NETNSID]);
> +		netnsid = nla_get_s32(tb[IFLA_LINK_NETNSID]);
>  
> -		link_net = get_net_ns_by_id(dest_net, id);
> +		link_net = get_net_ns_by_id(dest_net, netnsid);
>  		if (!link_net) {
>  			NL_SET_ERR_MSG(extack, "Unknown network namespace id");
>  			err =  -EINVAL;
> @@ -3382,6 +3427,17 @@ static int rtnl_newlink_create(struct sk_buff *skb, struct ifinfomsg *ifm,
>  		if (err)
>  			goto out_unregister;
>  	}
> +
> +	if (nlmsg_flags & NLM_F_ECHO) {
> +		u32 ext_filter_mask = 0;
> +
> +		if (tb[IFLA_EXT_MASK])
> +			ext_filter_mask = nla_get_u32(tb[IFLA_EXT_MASK]);
> +
> +		rtnl_echo_link_info(dev, NETLINK_CB(skb).portid, nlmsg_seq,
> +				    ext_filter_mask, netnsid);
=> netnsid, ie IFLA_LINK_NETNSID has nothing to do with IFLA_TARGET_NETNSID.
Link netns is used for x-netns interface like vlan for example. The vlan iface
could be in a netns while its lower iface could be in another netns.

The target netns is used when a netlink message is sent in a netns but should
act in another netns.

Regards,
Nicolas
