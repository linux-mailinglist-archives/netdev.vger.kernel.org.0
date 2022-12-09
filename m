Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABA8647E97
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 08:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiLIHcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 02:32:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbiLIHbh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 02:31:37 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B438C537D3
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 23:30:10 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id m19so2910407wms.5
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 23:30:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6QRPL8jVNR4wcNXjj50aKPMrExKMvKLBoy4ZEO7obgQ=;
        b=DNXFEOJlNom33o3zlOv9nXCjJgm33+jGxiYg6uBYl+0oAIYPq+1z0VwLfipryb4Xg0
         wbH6hAaEGvszxQ7sgqkz0QikMqIzFc+ZK6cE+tQZgUi2H6o05P6k/lORAuD6pwAZtEUH
         jRCdQ10Kw9mxTUIMLbqCVaCUf8Kh1wIvcQzScIWFLZNq8WGK0xix2RTT0tSo+GGNXATC
         5XEhG9ePUTbh5+RJKxW/mA/RfrGZLw0l75kXnhyBH3BYZbiNWClDRy2GWFQ5E+xjqMNR
         ga4Kkfhwtqr/FGS6pyzVYarvhBxM3W7m+LVqUDdvRGdlJADH7f3GRlmqwjoF4/bA7sJi
         E4cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6QRPL8jVNR4wcNXjj50aKPMrExKMvKLBoy4ZEO7obgQ=;
        b=1zIun5wpjDoFEzIhXfetn7Kmwm3bKB7ts3QqP0cNeaIGNh7+wp6xsfXi3AX6xsN1cG
         WV/mcp49uXNBRjaak0pNZ/foa6sZUJrNWMV7rNrKXxkEm4cxRVeI6SD2l4EmoKN4hhwp
         Dinv1t8GtTeTKh3D8NDEdyxy/5WlJoUusFF5AlvWmrRU9Xg6RW48wAfqy9AD6Vg+wZeQ
         +UHcwMaEBuWSGCWA5932BckfGMjVg0HT0QvwgQqNXPEOkFtlo/oxehYPr1DRjNisWyRq
         RHSTfua8HcHurc9lNTjkAZids9ofhD9WzCdK4s6vJUpa9gtCZ66t0dhOuT4jJaeG70vZ
         UMGQ==
X-Gm-Message-State: ANoB5pkNKLHXH3ukiyKV7YLrkfDiefntJZvpiMJtgjIvYe1sljxjYNIH
        i66WvhQrUrXTo+nQWNXDLXoucw==
X-Google-Smtp-Source: AA0mqf4e1/rzPWyF8ZiSD3w4NQxFz7fGOHj2Y7bchdta2xqFlz1j23WOP+7cIGslIAoUfApcFDVy+g==
X-Received: by 2002:a05:600c:4f52:b0:3cf:6e78:e3ad with SMTP id m18-20020a05600c4f5200b003cf6e78e3admr3913857wmq.6.1670571009039;
        Thu, 08 Dec 2022 23:30:09 -0800 (PST)
Received: from [192.168.0.161] (79-100-144-200.ip.btc-net.bg. [79.100.144.200])
        by smtp.gmail.com with ESMTPSA id p6-20020a1c5446000000b003c6cd82596esm7187235wmi.43.2022.12.08.23.30.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Dec 2022 23:30:08 -0800 (PST)
Message-ID: <127afe2b-9bbb-57e3-6374-c1df0505ebfb@blackwall.org>
Date:   Fri, 9 Dec 2022 09:30:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 03/14] bridge: mcast: Place netlink policy before
 validation functions
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, mlxsw@nvidia.com
References: <20221208152839.1016350-1-idosch@nvidia.com>
 <20221208152839.1016350-4-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20221208152839.1016350-4-idosch@nvidia.com>
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
> Subsequent patches are going to add additional validation functions and
> netlink policies. Some of these functions will need to perform parsing
> using nla_parse_nested() and the new policies.
> 
> In order to keep all the policies next to each other, move the current
> policy to before the validation functions.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/bridge/br_mdb.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
> index e3bd2122d559..fcdd464cf997 100644
> --- a/net/bridge/br_mdb.c
> +++ b/net/bridge/br_mdb.c
> @@ -663,6 +663,12 @@ void br_rtr_notify(struct net_device *dev, struct net_bridge_mcast_port *pmctx,
>  	rtnl_set_sk_err(net, RTNLGRP_MDB, err);
>  }
>  
> +static const struct nla_policy br_mdbe_attrs_pol[MDBE_ATTR_MAX + 1] = {
> +	[MDBE_ATTR_SOURCE] = NLA_POLICY_RANGE(NLA_BINARY,
> +					      sizeof(struct in_addr),
> +					      sizeof(struct in6_addr)),
> +};
> +
>  static bool is_valid_mdb_entry(struct br_mdb_entry *entry,
>  			       struct netlink_ext_ack *extack)
>  {
> @@ -748,12 +754,6 @@ static bool is_valid_mdb_source(struct nlattr *attr, __be16 proto,
>  	return true;
>  }
>  
> -static const struct nla_policy br_mdbe_attrs_pol[MDBE_ATTR_MAX + 1] = {
> -	[MDBE_ATTR_SOURCE] = NLA_POLICY_RANGE(NLA_BINARY,
> -					      sizeof(struct in_addr),
> -					      sizeof(struct in6_addr)),
> -};
> -
>  static struct net_bridge_mcast *
>  __br_mdb_choose_context(struct net_bridge *br,
>  			const struct br_mdb_entry *entry,

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
