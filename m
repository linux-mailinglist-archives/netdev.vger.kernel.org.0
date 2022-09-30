Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC295F0D76
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 16:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbiI3OXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 10:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231839AbiI3OX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 10:23:29 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18BEE1A88E7
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 07:22:25 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id s14so7138721wro.0
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 07:22:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date;
        bh=LCM//XbUEVNdKK9Wz7aMuRUZYRSJJ0bR+3XEZZQpyn4=;
        b=W85WnJiKww03DuEa1wqM8rWSRR0qy9ls3uQZPsGHeIGSstF3iANo+AktUolsdpH0D9
         fl4TXuUmagQr8ff6Kd989FmZtHJe0g4kOpcXw7DJL7zanTraQVxIq54UwqdYmNJyzZuD
         WFpWFj7HifxWqKUaLk3ibzq7uiGnyrSYDSEghBwGFfS8SUkRjNqRVKL26B3wXxtjrNng
         ZTsT/r8QcKKABFqIqOSnUGoFk/yBNoUR+3tVKSNaeE0mqltfR2HLP/MwbJlv5wTUsDfp
         bT3mEcpCzJHqZ84805wp/VQnRLp9PFHsNs42w/ndMa3xwjA/zCTSHrcPCJqyAn/Yb8PS
         zKjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=LCM//XbUEVNdKK9Wz7aMuRUZYRSJJ0bR+3XEZZQpyn4=;
        b=kJQuM06HAHcmpDx+tD+vSD7kW+L/5TLZjlKdmWhkLAq5AmQ4jMjy5PpcxyzJEX9V1k
         Csw5DNtiFDGsK9g49ItXM8YiXHHwdmSkNLwW/ShulFW8QpDdeSP4ZFI+Rw1Dmtfjf0/R
         /rv1L//Sy4Ank7/ud0iH6BHZz4X0MsQSIHideZnN4g5jQSYK9noPBDn0XNQtLZGb3gyg
         MVG7Dvyuq0vaQl0R1QBE9HjBiwVxekZ6tmFaizjTtZ/DV5/SyfoJvR4/Yu1Q9SxXIFmi
         BUMZ4xY0n0B3AAtQh/KzLDAJ9t52RkILdghNcJvy/HqyDwiUX3W2ey2RiURzyk598X58
         fF4g==
X-Gm-Message-State: ACrzQf3xDWzBG4J3m0jQsOC2NmyCCOCHgIGuh23yIE1t8KUWqJhAarj9
        wCDiBJ2TYyi9WqSzxhARyewzCQ==
X-Google-Smtp-Source: AMsMyM6VRQBe2G21se4or1kTaOIw9fMRfKGf4ljyxuEP9byzu4EJhmNvWBpoZwBzMF5cArkKOzbyQQ==
X-Received: by 2002:a5d:6d0f:0:b0:228:e075:b148 with SMTP id e15-20020a5d6d0f000000b00228e075b148mr5740475wrq.156.1664547740416;
        Fri, 30 Sep 2022 07:22:20 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:eccf:bbfd:a57d:90d5? ([2a01:e0a:b41:c160:eccf:bbfd:a57d:90d5])
        by smtp.gmail.com with ESMTPSA id v14-20020a5d678e000000b0022cc85140d9sm2202199wru.117.2022.09.30.07.22.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Sep 2022 07:22:19 -0700 (PDT)
Message-ID: <ede1abd0-970a-dec8-4dee-290d4a43200f@6wind.com>
Date:   Fri, 30 Sep 2022 16:22:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCHv5 net-next 1/4] rtnetlink: add new helper
 rtnl_configure_link_notify()
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
        Guillaume Nault <gnault@redhat.com>,
        David Ahern <dsahern@kernel.org>
References: <20220930094506.712538-1-liuhangbin@gmail.com>
 <20220930094506.712538-2-liuhangbin@gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <20220930094506.712538-2-liuhangbin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Le 30/09/2022 à 11:45, Hangbin Liu a écrit :
> This patch update rtnl_configure_link() to rtnl_configure_link_nlh() by
> adding parameter netlink message header and port id so we can notify the
> userspace about the new link info if NLM_F_ECHO flag is set.
> 
> The rtnl_configure_link() will be a wrapper of the new function. The new
> call chain looks like:
> 
> - rtnl_configure_link_notify()
>   - __dev_notify_flags()
>     - rtmsg_ifinfo_nlh()
>       - rtmsg_ifinfo_event()
>         - rtmsg_ifinfo_build_skb()
>         - rtmsg_ifinfo_send()
> 
> All the functions in this call chain will add parameter nlh and pid, so
> we can use them in the last call rtnl_notify().
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  include/linux/netdevice.h |  2 +-
>  include/linux/rtnetlink.h |  6 ++++--
>  net/core/dev.c            | 14 ++++++-------
>  net/core/rtnetlink.c      | 41 ++++++++++++++++++++++++++-------------
>  4 files changed, 40 insertions(+), 23 deletions(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index eddf8ee270e7..a71d378945e3 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -3856,7 +3856,7 @@ int __dev_change_flags(struct net_device *dev, unsigned int flags,
>  int dev_change_flags(struct net_device *dev, unsigned int flags,
>  		     struct netlink_ext_ack *extack);
>  void __dev_notify_flags(struct net_device *, unsigned int old_flags,
> -			unsigned int gchanges);
> +			unsigned int gchanges, u32 pid, struct nlmsghdr *nlh);
Order is pid/nlh.

[snip]

> +void rtmsg_ifinfo_nlh(int type, struct net_device *dev, unsigned int change,
> +		      gfp_t flags, u32 pid, struct nlmsghdr *nlh);
Same here.

>  struct sk_buff *rtmsg_ifinfo_build_skb(int type, struct net_device *dev,
>  				       unsigned change, u32 event,
>  				       gfp_t flags, int *new_nsid,
> -				       int new_ifindex);
> +				       int new_ifindex, u32 pid, u32 seq);
Same here.

>  void rtmsg_ifinfo_send(struct sk_buff *skb, struct net_device *dev,
> -		       gfp_t flags);
> +		       gfp_t flags, u32 pid, struct nlmsghdr *nlh);
Same here.

[snip]


> -int rtnl_configure_link(struct net_device *dev, const struct ifinfomsg *ifm)
> +static int rtnl_configure_link_notify(struct net_device *dev, const struct ifinfomsg *ifm,
> +				      struct nlmsghdr *nlh, u32 pid)
But not here. Following patches also use this order instead of the previous one.
For consistency, it could be good to keep the same order everywhere.


Regards,
Nicolas
