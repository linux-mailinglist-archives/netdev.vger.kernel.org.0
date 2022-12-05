Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 526D964278B
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 12:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbiLELeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 06:34:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231151AbiLELeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 06:34:12 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 808311901C
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 03:34:11 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id td2so27003414ejc.5
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 03:34:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f1KimoZD/4pavk1dyfC2nM/GPdOAWDB3KJt4OBapbgc=;
        b=vF/EYPE/s4UMEImbM1WcGc2QpHWPUutT4y0hzMF3fU1Z7SKZvXYIwqx6ykqUwVjl8u
         tE5Bx1dI3CNYT2l/Nan1Haaur+FZ6A20v0opucHaJaTBOvq/nW9oMBfdL0JyblInAEMr
         1Rs3tN1qWElrFK0mb4g57VQ9mZ8OwAKr8eQqB1S2/FJXwYnPbgcR9HUy5m0ScLYsVKMy
         rRwkalwWKEIHOQduY1vWyZEk2sG1KUioy1Es4No8994tnN+37yj+AmkjY2pMXw6yGNFH
         x/BRRpviy2neOE5kMGHQWgwdaHlkN6hMDJwkr/dKwREfStJRB2OC+7iIqTbGXJ1JsZAP
         rNyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f1KimoZD/4pavk1dyfC2nM/GPdOAWDB3KJt4OBapbgc=;
        b=JoVkd/TuScLEBRWHc5vZWpZ1biaSTiajwEFXO7kl6e9FRUi5ABoiE2SECtXB7NSw6O
         jzvSqssmrB54jYS8MIrn/2N1VerdA3N1ITllM0GmaRUErpa4YiuIQvsh7bhbugzd/6QK
         h6I5+BtTYmOxcF4rfHcOeBGxm3zUofMEJel4i73T8JCuSWeSOr2+woxRkA5mfgEtL0Xx
         Of4SQdnIZvcLoK5Lqw/Je+Mr9vnb3kVgnXz91Wfk/gRxZkIuRSKfelDQxUiXzvioOiEY
         VFAr+1i2NUUxFeGQmKmkP5hWmQ9V2MZwcLAVCO7YFxh7A7INgv1Z5DoFvvvPo2BAoaf/
         SUTg==
X-Gm-Message-State: ANoB5pmuULOK6NGjmTW5En1u/S14zSKCoywk/Q/MZwVcjRMM1zNnC/P/
        n6OfhnFT4ZnZZkOyxU5ilOA1/n1suBc8nJWjqYw=
X-Google-Smtp-Source: AA0mqf7ar/XI0+WI39H1bgr9OR9Mzf2AP8OZhn5NKeiNRab+7W1BUaRN9WJX+1oNO2NYuc4y6o73Ug==
X-Received: by 2002:a17:907:3117:b0:7ae:6746:f26b with SMTP id wl23-20020a170907311700b007ae6746f26bmr68863115ejb.171.1670240049834;
        Mon, 05 Dec 2022 03:34:09 -0800 (PST)
Received: from [192.168.0.161] (79-100-144-200.ip.btc-net.bg. [79.100.144.200])
        by smtp.gmail.com with ESMTPSA id e15-20020a170906c00f00b0078c213ad441sm6182846ejz.101.2022.12.05.03.34.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 03:34:09 -0800 (PST)
Message-ID: <06490c08-bf5e-1714-f56c-1a6068fb2ec9@blackwall.org>
Date:   Mon, 5 Dec 2022 13:34:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 1/8] bridge: mcast: Centralize netlink attribute
 parsing
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, mlxsw@nvidia.com
References: <20221205074251.4049275-1-idosch@nvidia.com>
 <20221205074251.4049275-2-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20221205074251.4049275-2-idosch@nvidia.com>
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

On 05/12/2022 09:42, Ido Schimmel wrote:
> Netlink attributes are currently passed deep in the MDB creation call
> chain, making it difficult to add new attributes. In addition, some
> validity checks are performed under the multicast lock although they can
> be performed before it is ever acquired.
> 
> As a first step towards solving these issues, parse the RTM_{NEW,DEL}MDB
> messages into a configuration structure, relieving other functions from
> the need to handle raw netlink attributes.
> 
> Subsequent patches will convert the MDB code to use this configuration
> structure.
> 
> This is consistent with how other rtnetlink objects are handled, such as
> routes and nexthops.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/bridge/br_mdb.c     | 120 ++++++++++++++++++++++++++++++++++++++++
>  net/bridge/br_private.h |   7 +++
>  2 files changed, 127 insertions(+)
> 
> diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
> index 321be94c445a..c53050e47a0f 100644
> --- a/net/bridge/br_mdb.c
> +++ b/net/bridge/br_mdb.c
> @@ -974,6 +974,116 @@ static int __br_mdb_add(struct net *net, struct net_bridge *br,
>  	return ret;
>  }
>  
> +static int br_mdb_config_attrs_init(struct nlattr *set_attrs,
> +				    struct br_mdb_config *cfg,
> +				    struct netlink_ext_ack *extack)
> +{
> +	struct nlattr *mdb_attrs[MDBE_ATTR_MAX + 1];
> +	int err;
> +
> +	err = nla_parse_nested(mdb_attrs, MDBE_ATTR_MAX, set_attrs,
> +			       br_mdbe_attrs_pol, extack);
> +	if (err)
> +		return err;
> +
> +	if (mdb_attrs[MDBE_ATTR_SOURCE] &&
> +	    !is_valid_mdb_source(mdb_attrs[MDBE_ATTR_SOURCE],
> +				 cfg->entry->addr.proto, extack))
> +		return -EINVAL;
> +
> +	__mdb_entry_to_br_ip(cfg->entry, &cfg->group, mdb_attrs);
> +
> +	return 0;
> +}
> +
> +static int br_mdb_config_init(struct net *net, struct sk_buff *skb,
> +			      struct nlmsghdr *nlh, struct br_mdb_config *cfg,
> +			      struct netlink_ext_ack *extack)
> +{

I just noticed the skb argument is unused. Does it get used in a future change?
Also a minor nit - I think nlh can be a const, nlmsg_parse_deprecated already uses a const nlh.


