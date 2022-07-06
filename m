Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0C2A5685BC
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 12:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232756AbiGFKig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 06:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbiGFKid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 06:38:33 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE54B11446
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 03:38:30 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id q9so21431984wrd.8
        for <netdev@vger.kernel.org>; Wed, 06 Jul 2022 03:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=IvnTYFSu0PEL+3o4XACW2izZIlmZOdd78cdDroOX11g=;
        b=1ajCLL4XIKG7Kc7pr+qDLSG4FQ90drTfPzOYz7WWMVGnk+NmlGYZKD8EyYidlkpiXl
         SGXh1HyZbgYywxHIMw+475z8FcRbbS4Jzdy9wAob5ifXV69EEuqVIe4MfVGG3NysBVNS
         j8HsPrUyAj6QLd2MEHKH0mR/6ppXXnCeVJYCxnwIBOaPK+938b9oNWZnwxkXFzJjzLUA
         KVx2XSDfQeab6PmU59WKUe95DpuRk5/z5l51JVh5L7cAu8zmcodrpQm2vo/COisQaHYo
         2YR4ZM5HU4YpoFtNOTIwhrrCj4evnd6qyZnJWHSisA4KOBdsiikz+wR7TG27z/ThQmqu
         PT1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IvnTYFSu0PEL+3o4XACW2izZIlmZOdd78cdDroOX11g=;
        b=ivtWz1mLKsgcvIa8pKfzPxdiiUgMX6dA8lSxZhFj9Kng1djxBnaQyl4uMRdSsWD+Eb
         oz/IbSoS8tczcPZ3KEAjpq9g+7VhWRxZ275fLBtgtqbUqgSBCVmQrILG5ITMuSEvmtgp
         3x3v6DFrfsVxqDJPqMcSFiScK9W145YJgh6QFvgqYapzIm05zZFavSTgJ4M3MclFueDu
         MXjzqQsYD7OGsyOZZ8P6NcHej0YTVzxBtvNdaBqmyprj3ON/mb5/UuJgH4lxxk46AQD2
         gf6tERTsJtigeuKDaK/A/4ALOnmtUxLWXz5CWj20VDd0XkfdfnfBzz2r4IVe8iMNfKjQ
         YiyQ==
X-Gm-Message-State: AJIora9bHFVZRqLUPyVMv5UoQ0BIU0CZX4/4aWiVZmTEd71tJaPKqlJm
        k5/kKj9/kb8B2pc0yLCrMkCW0A==
X-Google-Smtp-Source: AGRyM1uSftXBrEcsk4OUB70MUQiroh1dmw8wNWNZ3KYJFLMTXEh1rOgv1XA5KJ/tjREyJZsBMFaopA==
X-Received: by 2002:adf:ea50:0:b0:21d:6547:1154 with SMTP id j16-20020adfea50000000b0021d65471154mr18038120wrn.186.1657103909094;
        Wed, 06 Jul 2022 03:38:29 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id t10-20020adfe10a000000b00210320d9fbfsm42541525wrz.18.2022.07.06.03.38.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jul 2022 03:38:28 -0700 (PDT)
Message-ID: <19a7e57d-0a7d-b01e-ffce-dcf6b1249263@blackwall.org>
Date:   Wed, 6 Jul 2022 13:38:27 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v4] net: ip6mr: add RTM_GETROUTE netlink op
Content-Language: en-US
To:     David Lamparter <equinox@diac24.net>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
References: <20220706100024.112074-1-equinox@diac24.net>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220706100024.112074-1-equinox@diac24.net>
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

On 06/07/2022 13:00, David Lamparter wrote:
> The IPv6 multicast routing code previously implemented only the dump
> variant of RTM_GETROUTE.  Implement single MFC item retrieval by copying
> and adapting the respective IPv4 code.
> 
> Tested against FRRouting's IPv6 PIM stack.
> 
> Signed-off-by: David Lamparter <equinox@diac24.net>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: Nikolay Aleksandrov <razor@blackwall.org>
> ---
> 
> v4: rename policy to indicate it is dedicated for getroute, remove
> extra validation loop to reject attrs, and add missing "static".
> 
> v3: reorder/remove some redundant bits, fix style.  Thanks Nikolay for
> pointing them out.  The "extra" validation loop is still there for the
> time being;  happy to drop it if that's the consensus.
> 
> v2: changeover to strict netlink attribute parsing.  Doing so actually
> exposed a bunch of other issues, first and foremost that rtm_ipv6_policy
> does not have RTA_SRC or RTA_DST.  This made reusing that policy rather
> pointless so I changed it to use a separate rtm_ipv6_mr_policy.
> 
> Thanks again dsahern@ for the feedback on the previous version!
> 
> ---
>  net/ipv6/ip6mr.c | 102 ++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 101 insertions(+), 1 deletion(-)
> 

Patch looks good to me overall, one minor nit below in case there's a next version.
Thanks,
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>

> diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
> index ec6e1509fc7c..f567c055dba4 100644
> --- a/net/ipv6/ip6mr.c
> +++ b/net/ipv6/ip6mr.c
[snip]
> +static int ip6mr_rtm_getroute(struct sk_buff *in_skb, struct nlmsghdr *nlh,
> +			      struct netlink_ext_ack *extack)
> +{
> +	struct net *net = sock_net(in_skb->sk);
> +	struct in6_addr src = {}, grp = {};
> +	struct nlattr *tb[RTA_MAX + 1];
> +	struct sk_buff *skb = NULL;
> +	struct mfc6_cache *cache;
> +	struct mr_table *mrt;
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

minor nit: some errors have ":" after "ipv6", in this function's errors it's missing

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

ditto

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

