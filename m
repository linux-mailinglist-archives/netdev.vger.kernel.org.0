Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3E4A5E9C31
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 10:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234461AbiIZIh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 04:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234470AbiIZIh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 04:37:57 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A043BC77
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 01:37:50 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id z6so9059939wrq.1
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 01:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date;
        bh=BlMeeUEVodPBdqThTNC1beQRPVqh3BMP+jz01cEkl2Q=;
        b=bxdk56PRw6L4abkbFZZN14bHDPlCQVQ4SAGfIIa6SAhjeMzxJVGsHP8wV9xkbP0fh0
         oJx+2afqhLOwtgp33QsbDMwVhLpa1xGLJqMNetNlYKzmqeo6xq7uOP/FyD6sYMR1F/Aq
         jr2oW64uC9IMkf2UkPI/NBAfVv6IVZpdpH3roclasP2/izB3QHy/XBOXhI0sIhATmrdL
         ZDYOh9jepinRShFDutVHdFSmwrpwSaYuKkcyimiuj0buL9D8cTJt5A3PMOU/pUbXGsKl
         SYwwyIHycvdIZwX8C4n7d0EGciQ3Z6ziUJRUkp5DyK6i/dFJPMfdDWHy31NCYF3vaOGL
         hAGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=BlMeeUEVodPBdqThTNC1beQRPVqh3BMP+jz01cEkl2Q=;
        b=zARnydY8/z021Cl2om+pZixX1lZn4naqfTquFekZdmBxNJgN0W1+w08EHr6B+0ELTH
         Mi71PpZ9uxKEclwSD+iVGi2V0SHM2LNnsFpgADRYahR1RY8Tnhp7k5IY0ptTP4WkFSg7
         BcPq/HGULi1ijb241mUUCPbxhl9H1eWAGOsFE+grt/LsXMvyvCMzTOrZotUHS8LgB7iK
         7nFKsjVWwx5fJuZOOLsH4BL/lYgrkcseSqj6TkwyYLn/IUc4axz6ghOIds0Bj1HUPx9+
         n79qTmJq6h6MjRGbtYbgYs7Y9HFgzABiXB6jhs9ojc/ycAqeeXXhrG/mHMX4hyew7sZB
         BsrQ==
X-Gm-Message-State: ACrzQf2j1v0dhO0qk0hxdt7XA2avTaJwT7lG7h+owjtA8n1fPxvfbqzP
        OqD6XFX3s3LEO8ojWH6cqbyakrr1YnP7ZQ==
X-Google-Smtp-Source: AMsMyM74iY95H84GB6eiyxiDqR2iFNL3c8f4hBGlM4p4TJLN7Zvb6GZiBhLOXEpoGDgG/zf4OXegJw==
X-Received: by 2002:a5d:62d2:0:b0:22a:3a88:e902 with SMTP id o18-20020a5d62d2000000b0022a3a88e902mr12584366wrv.637.1664181468229;
        Mon, 26 Sep 2022 01:37:48 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:ec8f:a2ed:f455:6b0a? ([2a01:e0a:b41:c160:ec8f:a2ed:f455:6b0a])
        by smtp.gmail.com with ESMTPSA id e4-20020a05600c4e4400b003a682354f63sm10741914wmq.11.2022.09.26.01.37.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Sep 2022 01:37:47 -0700 (PDT)
Message-ID: <e74aeed9-fd93-43dd-7692-251efbc5e5b9@6wind.com>
Date:   Mon, 26 Sep 2022 10:37:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCHv2 net-next] rtnetlink: Honour NLM_F_ECHO flag in
 rtnl_{new, set, del}link
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
References: <20220926071246.38805-1-liuhangbin@gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <20220926071246.38805-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Le 26/09/2022 à 09:12, Hangbin Liu a écrit :
> Netlink messages are used for communicating between user and kernel space.
> When user space configures the kernel with netlink messages, it can set the
> NLM_F_ECHO flag to request the kernel to send the applied configuration back
> to the caller. This allows user space to retrieve configuration information
> that are filled by the kernel (either because these parameters can only be
> set by the kernel or because user space let the kernel choose a default
> value).
> 
> The kernel has support this feature in some places like RTM_{NEW, DEL}ADDR,
> RTM_{NEW, DEL}ROUTE. This patch handles NLM_F_ECHO flag and send link info
> back after rtnl_{new, set, del}link.
> 
> Suggested-by: Guillaume Nault <gnault@redhat.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
> v2:
> 1) rename rtnl_echo_link_info() to rtnl_link_notify().
> 2) remove IFLA_LINK_NETNSID and IFLA_EXT_MASK, which do not fit here.
> 3) Add NLM_F_ECHO in rtnl_dellink. But we can't re-use the rtnl_link_notify()
>    helper as we need to get the link info before rtnl_delete_link().
> ---
>  net/core/rtnetlink.c | 66 ++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 58 insertions(+), 8 deletions(-)
> 
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index 74864dc46a7e..0897cb6cc931 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -2645,13 +2645,41 @@ static int do_set_proto_down(struct net_device *dev,
>  	return 0;
>  }
>  
> +static void rtnl_link_notify(struct net_device *dev, u32 pid,
> +			     struct nlmsghdr *nlh)
> +{
> +	struct sk_buff *skb;
> +	int err = -ENOBUFS;
> +
> +	skb = nlmsg_new(if_nlmsg_size(dev, 0), GFP_KERNEL);
> +	if (!skb)
> +		goto errout;
> +
> +	err = rtnl_fill_ifinfo(skb, dev, dev_net(dev), RTM_NEWLINK, pid,
> +			       nlh->nlmsg_seq, 0, 0, 0, 0, NULL, 0, 0,
> +			       GFP_KERNEL);
> +	if (err < 0) {
> +		/* -EMSGSIZE implies BUG in if_nlmsg_size */
> +		WARN_ON(err == -EMSGSIZE);
> +		kfree_skb(skb);
> +		goto errout;
> +	}
> +
> +	rtnl_notify(skb, dev_net(dev), pid, RTM_NEWLINK, nlh, GFP_KERNEL);
The fourth argument is the group, not the command. It should be RTNLGRP_LINK
here. But it would be better to pass 0 to avoid multicasting a new / duplicate
notification. Calling functions already multicast one.
