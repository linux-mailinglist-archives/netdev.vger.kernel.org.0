Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA324FE356
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 16:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239517AbiDLOB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 10:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiDLOBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 10:01:54 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C19839B99
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 06:59:36 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id g18so12581624ejc.10
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 06:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0oxRiV7Xn2OLfcaX35f0mhFMqIdT52sPuFOy5Wtxayg=;
        b=j0xDg/N5jPDnYazxjhUZrOxM/pqiLjdpsSWw1j58vOt00NshCPgnp8oCGjRVk6XR86
         kf5KjKEwooK2Z2QHr0qaPbUIup0weH3MB279FadHubQq4/nN2fq/IYDLrISMRBfNraB2
         RkyNqgFANKQEX7uvB24hvBGFmQoSUg0WaN99ne+0wkZBnh1yvceRrAJDNrHdN5K+A9Tl
         JwaR1laBRsYEIu/XXoiTWTzdeR6P6moeqniWQOvZe0xS8kO05tADOiYObhJyHq3ZHjNf
         2V8AilUXumKAkb/QCkxdFxDdLpbBjXKSinsHAm6vg2UVGaT/IVQW171/nAO7dG4HHlL/
         OlwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0oxRiV7Xn2OLfcaX35f0mhFMqIdT52sPuFOy5Wtxayg=;
        b=ebTxQbLdmE+eslBkDjl71XyTCxj5LEvF7kpTCIPcUDgQZojWYsUIIiopJaHWTdZmP0
         /BQqqbRPkvVbQS+kan6pmx0kD5rDO3/MC6RLxCmoV2jzuGxiixUawpKj9N+dND0dJswl
         n4TuZKQKmLQrYCMqWJoqoC/AVPFHnQfL1/FYw/pmx3Y0X4KifPTdQ03nmWZGe1hQe5SZ
         ErRyvbOSW+eJEENlNEBmA48xWZLyjwOx3YyDAYMj0VroNiyU+nQ3vp+Dg7Zocpn+5eCD
         GyC9xr6S6PhNhQx4sDEkSNeefFxp+TFGMQ8KbEv/a6TIl8Wz8wTz3ExYC4z3FOEKKBUG
         Z5Ew==
X-Gm-Message-State: AOAM532j+GoAIPmRdO6xGc4hYtTKiqPP1Fpg++jN5vlpM4dL7maC+LSQ
        pdBjQHOk+z+EkVCqCQrubosppw==
X-Google-Smtp-Source: ABdhPJwZTPu50LzeTguTLdfwFmqnXO2fqq1Q/aKCshQcVxo01cgRD23S0faffFKTbNqoCv3Q5PXVMw==
X-Received: by 2002:a17:907:7209:b0:6da:9781:ae5d with SMTP id dr9-20020a170907720900b006da9781ae5dmr33150269ejc.73.1649771974943;
        Tue, 12 Apr 2022 06:59:34 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id gq5-20020a170906e24500b006e87644f2f7sm3887789ejb.38.2022.04.12.06.59.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 06:59:34 -0700 (PDT)
Message-ID: <ebd182a2-20bc-471c-e649-a2689ea5a5d1@blackwall.org>
Date:   Tue, 12 Apr 2022 16:59:33 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH RFC net-next 08/13] net: bridge: avoid classifying unknown
 multicast as mrouters_only
Content-Language: en-US
To:     Joachim Wiberg <troglobit@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20220411133837.318876-1-troglobit@gmail.com>
 <20220411133837.318876-9-troglobit@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220411133837.318876-9-troglobit@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/04/2022 16:38, Joachim Wiberg wrote:
> Unknown multicast, MAC/IPv4/IPv6, should always be flooded according to
> the per-port mcast_flood setting, as well as to detected and configured
> mcast_router ports.
> 
> This patch drops the mrouters_only classifier of unknown IP multicast
> and moves the flow handling from br_multicast_flood() to br_flood().
> This in turn means br_flood() must know about multicast router ports.
> 
> Signed-off-by: Joachim Wiberg <troglobit@gmail.com>
> ---
>  net/bridge/br_forward.c   | 11 +++++++++++
>  net/bridge/br_multicast.c |  6 +-----
>  2 files changed, 12 insertions(+), 5 deletions(-)
> 

If you'd like to flood unknown mcast traffic when a router is present please add
a new option which defaults to the current state (disabled).

> diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
> index 02bb620d3b8d..ab5b97a8c12e 100644
> --- a/net/bridge/br_forward.c
> +++ b/net/bridge/br_forward.c
> @@ -199,9 +199,15 @@ static struct net_bridge_port *maybe_deliver(
>  void br_flood(struct net_bridge *br, struct sk_buff *skb,
>  	      enum br_pkt_type pkt_type, bool local_rcv, bool local_orig)
>  {
> +	struct net_bridge_mcast *brmctx = &br->multicast_ctx;

Note this breaks per-vlan mcast. You have to use the inferred mctx.

> +	struct net_bridge_port *rport = NULL;
>  	struct net_bridge_port *prev = NULL;
> +	struct hlist_node *rp = NULL;
>  	struct net_bridge_port *p;
>  
> +	if (pkt_type == BR_PKT_MULTICAST)
> +		rp = br_multicast_get_first_rport_node(brmctx, skb);
> +
>  	list_for_each_entry_rcu(p, &br->port_list, list) {
>  		/* Do not flood unicast traffic to ports that turn it off, nor
>  		 * other traffic if flood off, except for traffic we originate
> @@ -212,6 +218,11 @@ void br_flood(struct net_bridge *br, struct sk_buff *skb,
>  				continue;
>  			break;
>  		case BR_PKT_MULTICAST:
> +			rport = br_multicast_rport_from_node_skb(rp, skb);
> +			if (rport == p) {
> +				rp = rcu_dereference(hlist_next_rcu(rp));
> +				break;
> +			}
>  			if (!(p->flags & BR_MCAST_FLOOD) && skb->dev != br->dev)
>  				continue;
>  			break;
> diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
> index db4f2641d1cd..c57e3bbb00ad 100644
> --- a/net/bridge/br_multicast.c
> +++ b/net/bridge/br_multicast.c
> @@ -3643,9 +3643,7 @@ static int br_multicast_ipv4_rcv(struct net_bridge_mcast *brmctx,
>  	err = ip_mc_check_igmp(skb);
>  
>  	if (err == -ENOMSG) {
> -		if (!ipv4_is_local_multicast(ip_hdr(skb)->daddr)) {
> -			BR_INPUT_SKB_CB(skb)->mrouters_only = 1;
> -		} else if (pim_ipv4_all_pim_routers(ip_hdr(skb)->daddr)) {
> +		if (pim_ipv4_all_pim_routers(ip_hdr(skb)->daddr)) {
>  			if (ip_hdr(skb)->protocol == IPPROTO_PIM)
>  				br_multicast_pim(brmctx, pmctx, skb);
>  		} else if (ipv4_is_all_snoopers(ip_hdr(skb)->daddr)) {
> @@ -3712,8 +3710,6 @@ static int br_multicast_ipv6_rcv(struct net_bridge_mcast *brmctx,
>  	err = ipv6_mc_check_mld(skb);
>  
>  	if (err == -ENOMSG || err == -ENODATA) {
> -		if (!ipv6_addr_is_ll_all_nodes(&ipv6_hdr(skb)->daddr))
> -			BR_INPUT_SKB_CB(skb)->mrouters_only = 1;
>  		if (err == -ENODATA &&
>  		    ipv6_addr_is_all_snoopers(&ipv6_hdr(skb)->daddr))
>  			br_ip6_multicast_mrd_rcv(brmctx, pmctx, skb);

