Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0026B91E4
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 12:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbjCNLmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 07:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbjCNLmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 07:42:08 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF639DE1E
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 04:41:56 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id v16so14096817wrn.0
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 04:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1678794115;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rjlDp8/x86m0U9/yRYrRz5qP8F6BLrKqt+GnbXWpvvs=;
        b=yZjWeLZUuHe0uTj6f6sCkvlOZ0FPf6xndFi7lz65TugOvuKB0mpMEVEZvSdzvLFxcn
         pUIs5j9eRnh7U1sKYqKWfOZeq2P41SERtY4tC/PA3k/RZNFOoaVYMwxHx3dGCJBVmOwm
         5qeAm567+QUgx9LxWgnqdPMCQw5hduuuj8rAzRW7RXIczY6JCFA2OHQB7mWmlLhOcDgC
         o2uAVeOpvi/xHhM/nOluL2yy+3u04jaoKAz1zryGYCywXlCJLF/QQlZbA7S+MNQUI3J9
         2mNo2f67hqLD1txbdZk+VA5uhOXHIh6XYx1NjiTJbr2nhAlDq920cqxy3kDHJZT6d9XK
         8Nnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678794115;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rjlDp8/x86m0U9/yRYrRz5qP8F6BLrKqt+GnbXWpvvs=;
        b=ZFFqAU809rjnkiEBUCoiSTPoEBDa+iJlxhiHxzt8jnosevmtgx+DC93v8tvjiLi+EJ
         NKvZ9yZx8Azajdu9w2S/HbANxJOEX+PzTstACmlVonT2iAJsUxnjWW2VXx8Cp6I5i8H+
         wsjxO68uHPzlDfk21lPsNkpRCx645nTWa90rT415oFMO38/DUq/r4RWPrB3ri9pbLwi/
         dUNP6BKaDWsxuCQV/c3XsSlSk40nR1zoSdXx2rblFSIRbaWcjGQrSj6PqQg3ipBUtHDD
         gTqxNCQQjzUXtdRTzlYLH0zjAwnbyGBlCyWWPX75M8t+gAnqeKHSI+wqXNzF9bfBSIF+
         FLgA==
X-Gm-Message-State: AO0yUKWrA4SVK/wlCkuGBGS/cqsgi5dkQRIMZAGaDMh84EplYoQkmXuH
        rLZ1ODK4stQLeRQeXBpvkDCzqg==
X-Google-Smtp-Source: AK7set/CrB/fYHXc+GcYfuLjuixfX2XH7bqmyLqs+QH+LqmMfHFS4+GhNPvFFZFQ45273sRx32kw5w==
X-Received: by 2002:adf:dec8:0:b0:2c7:454:cee3 with SMTP id i8-20020adfdec8000000b002c70454cee3mr23852034wrn.7.1678794115116;
        Tue, 14 Mar 2023 04:41:55 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id z17-20020a5d4d11000000b002c5a1bd527dsm1846139wrt.96.2023.03.14.04.41.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Mar 2023 04:41:54 -0700 (PDT)
Message-ID: <36d6a40a-8f5a-3152-a694-d15bdb3578b4@blackwall.org>
Date:   Tue, 14 Mar 2023 13:41:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next 01/11] net: Add MDB net device operations
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, petrm@nvidia.com,
        mlxsw@nvidia.com
References: <20230313145349.3557231-1-idosch@nvidia.com>
 <20230313145349.3557231-2-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230313145349.3557231-2-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/03/2023 16:53, Ido Schimmel wrote:
> Add MDB net device operations that will be invoked by rtnetlink code in
> response to received RTM_{NEW,DEL,GET}MDB messages. Subsequent patches
> will implement these operations in the bridge and VXLAN drivers.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  include/linux/netdevice.h | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index ee483071cf59..23b0d7eaaadd 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -1307,6 +1307,17 @@ struct netdev_net_notifier {
>   *	Used to add FDB entries to dump requests. Implementers should add
>   *	entries to skb and update idx with the number of entries.
>   *
> + * int (*ndo_mdb_add)(struct net_device *dev, struct nlattr *tb[],
> + *		      u16 nlmsg_flags, struct netlink_ext_ack *extack);
> + *	Adds an MDB entry to dev.
> + * int (*ndo_mdb_del)(struct net_device *dev, struct nlattr *tb[],
> + *		      struct netlink_ext_ack *extack);
> + *	Deletes the MDB entry from dev.
> + * int (*ndo_mdb_dump)(struct net_device *dev, struct sk_buff *skb,
> + *		       struct netlink_callback *cb);
> + *	Dumps MDB entries from dev. The first argument (marker) in the netlink
> + *	callback is used by core rtnetlink code.
> + *
>   * int (*ndo_bridge_setlink)(struct net_device *dev, struct nlmsghdr *nlh,
>   *			     u16 flags, struct netlink_ext_ack *extack)
>   * int (*ndo_bridge_getlink)(struct sk_buff *skb, u32 pid, u32 seq,
> @@ -1569,6 +1580,16 @@ struct net_device_ops {
>  					       const unsigned char *addr,
>  					       u16 vid, u32 portid, u32 seq,
>  					       struct netlink_ext_ack *extack);
> +	int			(*ndo_mdb_add)(struct net_device *dev,
> +					       struct nlattr *tb[],
> +					       u16 nlmsg_flags,
> +					       struct netlink_ext_ack *extack);
> +	int			(*ndo_mdb_del)(struct net_device *dev,
> +					       struct nlattr *tb[],
> +					       struct netlink_ext_ack *extack);
> +	int			(*ndo_mdb_dump)(struct net_device *dev,
> +						struct sk_buff *skb,
> +						struct netlink_callback *cb);
>  	int			(*ndo_bridge_setlink)(struct net_device *dev,
>  						      struct nlmsghdr *nlh,
>  						      u16 flags,

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>

