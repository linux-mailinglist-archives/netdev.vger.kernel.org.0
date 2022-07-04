Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAB4956522A
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 12:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234432AbiGDKXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 06:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234702AbiGDKXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 06:23:03 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC7B5218F
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 03:22:39 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id mf9so16007873ejb.0
        for <netdev@vger.kernel.org>; Mon, 04 Jul 2022 03:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=99c+tB+4XXEOKJova0DNTDWOXfHZyhXjztEGCxi3OCs=;
        b=7dv5ybsMe66950lto9c2K9T/umRiMdybWkmNzSqf/Bf/xFFDHZ5ljJK8KuCbgnUiUw
         byVf0Ox8dgHfTP8ThGw/ykMtivR2X0jphvK/RpdKp63uAgSPxumMcMFlsliWxUPbVQOw
         SVrZIHgQqdAf677amWuigiGZsG95t+ZHQIk/2iQ9KJ0wdaJG7ksG9Y9Zs5EoClO+H26N
         p0ndBIzwLk9zHnSMInX9b9bbe3n1bYcmj/qPhxM0inT50HIP4Ecd4WWmd33mjhDExfh0
         wNJu3qB/Z2pquwnsrii9Is1FvRzPLDKdyG8xLHur9QsJY+bTNWUSrqOASItaJK8NQRc/
         j2yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=99c+tB+4XXEOKJova0DNTDWOXfHZyhXjztEGCxi3OCs=;
        b=21JiQolykikD6YNWiUs4k1kbAtmfvzTICCH/0zqhq5qsoA0sJwO9oljM5dw87AzLyY
         yd9eClPw80I9eTWMfrpQt5v4hMViXqam2F4yXsrLwEcH2kJsJOgEUbSZKGLS0DuQIZTj
         xR5kt2by1M2zxBxqGqwOPH+q2MEOobNOJ949MEJusgAAWRn0Nl26sKBgcfNRVVTJkyd3
         WgoOnoRNYMAvRzCdUW4aBCjSwwU++3OqPMKZuZJ6xS4t0Dxbqz+8M/ZMnskW245sa4y3
         iGRAXs93SkeX5nA+2gkCCXg28nShZUSEUva0tRaKH4cyIAyF/s6+7JtJJFJAuoRxgBhm
         4NnQ==
X-Gm-Message-State: AJIora8IPc8ZRMqmvcUw7IoA0Mf3y+gepgfGYQ47UoeiCS5erwDO1zLN
        B4xRtwrrOtjch/UN10Tva0Tv6gCWJVR/r/35
X-Google-Smtp-Source: AGRyM1v8Tl4IbX0HQV4/hMFlMSk7QGZWoENOjM2YaH3QjV0vkwW9dT8/rD2wyijFg+vjGLHO2pazRg==
X-Received: by 2002:a17:906:58cf:b0:726:97db:4f6d with SMTP id e15-20020a17090658cf00b0072697db4f6dmr27873012ejs.261.1656930158343;
        Mon, 04 Jul 2022 03:22:38 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id fi9-20020a170906da0900b00722e5b234basm14086359ejb.179.2022.07.04.03.22.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jul 2022 03:22:37 -0700 (PDT)
Message-ID: <80dd41cc-5ff2-f27f-3764-841acf008237@blackwall.org>
Date:   Mon, 4 Jul 2022 13:22:36 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v2] net: ip6mr: add RTM_GETROUTE netlink op
Content-Language: en-US
To:     David Lamparter <equinox@diac24.net>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
References: <20220630202706.33555ad2@kernel.org>
 <20220704095845.365359-1-equinox@diac24.net>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220704095845.365359-1-equinox@diac24.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/07/2022 12:58, David Lamparter wrote:
> The IPv6 multicast routing code previously implemented only the dump
> variant of RTM_GETROUTE.  Implement single MFC item retrieval by copying
> and adapting the respective IPv4 code.
> 
> Tested against FRRouting's IPv6 PIM stack.
> 
> Signed-off-by: David Lamparter <equinox@diac24.net>
> Cc: David Ahern <dsahern@kernel.org>
> ---
> 
> v2: changeover to strict netlink attribute parsing.  Doing so actually
> exposed a bunch of other issues, first and foremost that rtm_ipv6_policy
> does not have RTA_SRC or RTA_DST.  This made reusing that policy rather
> pointless so I changed it to use a separate rtm_ipv6_mr_policy.
> 
> Thanks again dsahern@ for the feedback on the previous version!
> 
> ---
>  net/ipv6/ip6mr.c | 128 ++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 127 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
> index ec6e1509fc7c..95dc366a2d9b 100644
> --- a/net/ipv6/ip6mr.c
> +++ b/net/ipv6/ip6mr.c
> @@ -95,6 +95,8 @@ static int ip6mr_cache_report(const struct mr_table *mrt, struct sk_buff *pkt,
>  static void mr6_netlink_event(struct mr_table *mrt, struct mfc6_cache *mfc,
>  			      int cmd);
>  static void mrt6msg_netlink_event(const struct mr_table *mrt, struct sk_buff *pkt);
> +static int ip6mr_rtm_getroute(struct sk_buff *in_skb, struct nlmsghdr *nlh,
> +			      struct netlink_ext_ack *extack);
>  static int ip6mr_rtm_dumproute(struct sk_buff *skb,
>  			       struct netlink_callback *cb);
>  static void mroute_clean_tables(struct mr_table *mrt, int flags);
> @@ -1390,7 +1392,7 @@ int __init ip6_mr_init(void)
>  	}
>  #endif
>  	err = rtnl_register_module(THIS_MODULE, RTNL_FAMILY_IP6MR, RTM_GETROUTE,
> -				   NULL, ip6mr_rtm_dumproute, 0);
> +				   ip6mr_rtm_getroute, ip6mr_rtm_dumproute, 0);
>  	if (err == 0)
>  		return 0;
>  
> @@ -2510,6 +2512,130 @@ static void mrt6msg_netlink_event(const struct mr_table *mrt, struct sk_buff *pk
>  	rtnl_set_sk_err(net, RTNLGRP_IPV6_MROUTE_R, -ENOBUFS);
>  }
>  
> +const struct nla_policy rtm_ipv6_mr_policy[RTA_MAX + 1] = {
> +	[RTA_UNSPEC]		= { .strict_start_type = RTA_UNSPEC },

I don't think you need to add RTA_UNSPEC, nlmsg_parse() would reject it due to NL_VALIDATE_STRICT

> +	[RTA_SRC]		= NLA_POLICY_EXACT_LEN(sizeof(struct in6_addr)),
> +	[RTA_DST]		= NLA_POLICY_EXACT_LEN(sizeof(struct in6_addr)),
> +	[RTA_TABLE]		= { .type = NLA_U32 },
> +};
> +
> +static int ip6mr_rtm_valid_getroute_req(struct sk_buff *skb,
> +					const struct nlmsghdr *nlh,
> +					struct nlattr **tb,
> +					struct netlink_ext_ack *extack)
> +{
> +	struct rtmsg *rtm;
> +	int i, err;
> +
> +	if (nlh->nlmsg_len < nlmsg_msg_size(sizeof(*rtm))) {
> +		NL_SET_ERR_MSG(extack, "ipv6: Invalid header for multicast route get request");
> +		return -EINVAL;
> +	}

I think you can drop this check if you...

> +
> +	rtm = nlmsg_data(nlh);
> +	if ((rtm->rtm_src_len && rtm->rtm_src_len != 128) ||
> +	    (rtm->rtm_dst_len && rtm->rtm_dst_len != 128) ||
> +	    rtm->rtm_tos || rtm->rtm_table || rtm->rtm_protocol ||
> +	    rtm->rtm_scope || rtm->rtm_type || rtm->rtm_flags) {
> +		NL_SET_ERR_MSG(extack,
> +			       "ipv6: Invalid values in header for multicast route get request");
> +		return -EINVAL;
> +	}

...move these after nlmsg_parse() because it already does the hdrlen check for you

> +
> +	err = nlmsg_parse(nlh, sizeof(*rtm), tb, RTA_MAX, rtm_ipv6_mr_policy,
> +			  extack);
> +	if (err)
> +		return err;
> +
> +	if ((tb[RTA_SRC] && !rtm->rtm_src_len) ||
> +	    (tb[RTA_DST] && !rtm->rtm_dst_len)) {
> +		NL_SET_ERR_MSG(extack, "ipv6: rtm_src_len and rtm_dst_len must be 128 for IPv6");
> +		return -EINVAL;
> +	}
> +
> +	/* rtm_ipv6_mr_policy does not list other attributes right now, but
> +	 * future changes may reuse rtm_ipv6_mr_policy with adding further
> +	 * attrs.  Enforce the subset.
> +	 */
> +	for (i = 0; i <= RTA_MAX; i++) {
> +		if (!tb[i])
> +			continue;
> +
> +		switch (i) {
> +		case RTA_SRC:
> +		case RTA_DST:
> +		case RTA_TABLE:
> +			break;
> +		default:
> +			NL_SET_ERR_MSG_ATTR(extack, tb[i],
> +					    "ipv6: Unsupported attribute in multicast route get request");
> +			return -EINVAL;
> +		}
> +	}

I think you can skip this loop as well, nlmsg_parse() shouldn't allow attributes that
don't have policy defined when policy is provided (i.e. they should show up as NLA_UNSPEC
and you should get "Error: Unknown attribute type.").

> +
> +	return 0;
> +}
> +
> +static int ip6mr_rtm_getroute(struct sk_buff *in_skb, struct nlmsghdr *nlh,
> +			      struct netlink_ext_ack *extack)
> +{
> +	struct net *net = sock_net(in_skb->sk);
> +	struct nlattr *tb[RTA_MAX + 1];
> +	struct sk_buff *skb = NULL;
> +	struct mfc6_cache *cache;
> +	struct mr_table *mrt;
> +	struct in6_addr src = {}, grp = {};

reverse xmas tree order

> +	u32 tableid;
> +	int err;
> +
> +	err = ip6mr_rtm_valid_getroute_req(in_skb, nlh, tb, extack);
> +	if (err < 0)
> +		goto errout;
> +
> +	if (tb[RTA_SRC])
> +		src = nla_get_in6_addr(tb[RTA_SRC]);
> +	if (tb[RTA_DST])
> +		grp = nla_get_in6_addr(tb[RTA_DST]);
> +	tableid = tb[RTA_TABLE] ? nla_get_u32(tb[RTA_TABLE]) : 0;
> +
> +	mrt = ip6mr_get_table(net, tableid ? tableid : RT_TABLE_DEFAULT);
> +	if (!mrt) {
> +		NL_SET_ERR_MSG_MOD(extack, "ipv6 MR table does not exist");
> +		err = -ENOENT;
> +		goto errout_free;
> +	}
> +
> +	/* entries are added/deleted only under RTNL */
> +	rcu_read_lock();
> +	cache = ip6mr_cache_find(mrt, &src, &grp);
> +	rcu_read_unlock();
> +	if (!cache) {
> +		NL_SET_ERR_MSG_MOD(extack, "ipv6 MR cache entry not found");
> +		err = -ENOENT;
> +		goto errout_free;
> +	}
> +
> +	skb = nlmsg_new(mr6_msgsize(false, mrt->maxvif), GFP_KERNEL);
> +	if (!skb) {
> +		err = -ENOBUFS;
> +		goto errout_free;
> +	}
> +
> +	err = ip6mr_fill_mroute(mrt, skb, NETLINK_CB(in_skb).portid,
> +				nlh->nlmsg_seq, cache, RTM_NEWROUTE, 0);
> +	if (err < 0)
> +		goto errout_free;
> +
> +	err = rtnl_unicast(skb, net, NETLINK_CB(in_skb).portid);
> +
> +errout:
> +	return err;
> +
> +errout_free:
> +	kfree_skb(skb);
> +	goto errout;
> +}
> +
>  static int ip6mr_rtm_dumproute(struct sk_buff *skb, struct netlink_callback *cb)
>  {
>  	const struct nlmsghdr *nlh = cb->nlh;

