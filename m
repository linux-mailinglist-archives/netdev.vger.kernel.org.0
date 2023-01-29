Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6076967FDBD
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 10:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbjA2JJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 04:09:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjA2JJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 04:09:36 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E8E31F4B5
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 01:09:33 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id mg12so24130916ejc.5
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 01:09:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w/AZ/A/olYCP18HetNsEPN25VtnURtcy+kAXgeU7ycM=;
        b=fjrTGrhig1y4OqWIksdP6M4gdfwa71nXHU9U/H7D7xPlxVJ+zyBk2qqW5YfW0OAwX1
         PNkeIbHDkAKnRhhZV2G0GEknGvaUi82PvwJqeZ5jQJ/zh/I8fZuNI0uDKckoBfVI49AZ
         RMrG3mTEOjU1ZlJMbpxWVr9BKBsvaHodQfpGksB0+qnZ4hbJeWAJwgXitwJGyeyj7Q6x
         hgUXtqI7GCcUYj3Azk0GrGJTx5RdEKSGNl1QXzS+D2IHFfTFUmHSIAo0TunNi7eOZ7en
         abS5zii44GGB8pDiHYuMORB5OI7eyTzWqqAa7kp3XnP3jCVhkoun01+63SGyPH4zEf4d
         peug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w/AZ/A/olYCP18HetNsEPN25VtnURtcy+kAXgeU7ycM=;
        b=1/4Gj0M5RTRMHKuUdT1oFKXBAp8LYu89ikpSS8YOsq/85jvKBjwFjTc9mlklvToZy2
         Hw20oHXT5qa0oY8i1dOBAmwsWo3eNnHejpGgf6utoqz/9GGOWtFoUSLh8YpfevZwWPGm
         I2TEARHbt9AavHtMSgUyVDoJYKUUrH/pyLEF9JzszyYKL3RmrywA5nmf+/87gupYZffe
         yJfCJQrQC6JkybBEuOug9dFNkKZx5Vem+BRwbM5WnE3hY7tjddbN2vRzh7luF5QPZ41c
         enp23WawDod9a8w/U0MpfmRDU80uf2Sv0J+aKqYEr3QneIhfjK10i67y6fdMTH1XDg3L
         rCOQ==
X-Gm-Message-State: AO0yUKVEjJklmrMVSkwoLYgR1vWGN7eI3ypGwQx0vfxE6rYS+rmYjff5
        3lq52hxpLRUEqnOyx4c/HBaJSA==
X-Google-Smtp-Source: AK7set+xrkOl75NXQGdbhKa3dA+O1VoVZVhRT37/njPIz0GGw6OkB75sdaM2Bjtu4xcUfT2TbBDiig==
X-Received: by 2002:a17:907:9a89:b0:880:ffaa:16f4 with SMTP id km9-20020a1709079a8900b00880ffaa16f4mr5602985ejc.10.1674983371424;
        Sun, 29 Jan 2023 01:09:31 -0800 (PST)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id n5-20020a1709061d0500b0084d420503a3sm5126497ejh.178.2023.01.29.01.09.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Jan 2023 01:09:31 -0800 (PST)
Message-ID: <dbfe0af4-24f8-bdc9-38ea-c873936bdd7f@blackwall.org>
Date:   Sun, 29 Jan 2023 11:09:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH net-next 01/16] net: bridge: Set strict_start_type at two
 policies
To:     Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, netdev@vger.kernel.org
Cc:     bridge@lists.linux-foundation.org, Ido Schimmel <idosch@nvidia.com>
References: <cover.1674752051.git.petrm@nvidia.com>
 <8886e11bde5874305a26c0b7dc397923a1d5a794.1674752051.git.petrm@nvidia.com>
Content-Language: en-US
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <8886e11bde5874305a26c0b7dc397923a1d5a794.1674752051.git.petrm@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/01/2023 19:01, Petr Machata wrote:
> Make any attributes newly-added to br_port_policy or vlan_tunnel_policy
> parsed strictly, to prevent userspace from passing garbage. Note that this
> patchset only touches the former policy. The latter was adjusted for
> completeness' sake. There do not appear to be other _deprecated calls
> with non-NULL policies.
> 
> Suggested-by: Ido Schimmel <idosch@nvidia.com>
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/bridge/br_netlink.c        | 2 ++
>  net/bridge/br_netlink_tunnel.c | 3 +++
>  2 files changed, 5 insertions(+)
> 
> diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
> index 4316cc82ae17..a6133d469885 100644
> --- a/net/bridge/br_netlink.c
> +++ b/net/bridge/br_netlink.c
> @@ -858,6 +858,8 @@ static int br_afspec(struct net_bridge *br,
>  }
>  
>  static const struct nla_policy br_port_policy[IFLA_BRPORT_MAX + 1] = {
> +	[IFLA_BRPORT_UNSPEC]	= { .strict_start_type =
> +					IFLA_BRPORT_MCAST_EHT_HOSTS_LIMIT + 1 },
>  	[IFLA_BRPORT_STATE]	= { .type = NLA_U8 },
>  	[IFLA_BRPORT_COST]	= { .type = NLA_U32 },
>  	[IFLA_BRPORT_PRIORITY]	= { .type = NLA_U16 },
> diff --git a/net/bridge/br_netlink_tunnel.c b/net/bridge/br_netlink_tunnel.c
> index 8914290c75d4..17abf092f7ca 100644
> --- a/net/bridge/br_netlink_tunnel.c
> +++ b/net/bridge/br_netlink_tunnel.c
> @@ -188,6 +188,9 @@ int br_fill_vlan_tunnel_info(struct sk_buff *skb,
>  }
>  
>  static const struct nla_policy vlan_tunnel_policy[IFLA_BRIDGE_VLAN_TUNNEL_MAX + 1] = {
> +	[IFLA_BRIDGE_VLAN_TUNNEL_UNSPEC] = {
> +		.strict_start_type = IFLA_BRIDGE_VLAN_TUNNEL_FLAGS + 1
> +	},
>  	[IFLA_BRIDGE_VLAN_TUNNEL_ID] = { .type = NLA_U32 },
>  	[IFLA_BRIDGE_VLAN_TUNNEL_VID] = { .type = NLA_U16 },
>  	[IFLA_BRIDGE_VLAN_TUNNEL_FLAGS] = { .type = NLA_U16 },

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>

