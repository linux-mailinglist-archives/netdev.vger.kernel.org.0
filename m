Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C68253E4F70
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 00:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236835AbhHIWoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 18:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236799AbhHIWoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 18:44:22 -0400
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A8FAC0613D3;
        Mon,  9 Aug 2021 15:44:01 -0700 (PDT)
Received: by mail-oo1-xc36.google.com with SMTP id f33-20020a4a89240000b029027c19426fbeso4815442ooi.8;
        Mon, 09 Aug 2021 15:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JFm3i8hiQ9YKTYc3KaQhJAf5gW+QdhhYGs4FBgzwnT8=;
        b=mMaG/auye7Xh8CSntEKrHBp7K/TKrZsSX3E+NB20n023Qhd/FMMXGpVp/2BQocuOKp
         NwAxSlW6btH0Aj1GFHEVgr4oWtZ1y/bCBPwS3dbBq1WQY83Xe2ZZzH0PS1KmXcTtncJ7
         Vj4mOjYgp8bbWMxz0f7lHZaMgb+EklvK1h3hrRZx0DTgLHR9YUKwbqRhHYaRyTkBOctA
         e2RBA54dSFdVzVf+/RxWcOaxjQxrCnG8Yja6s2motyLHQfqsyne0obEFDSjXAdrJpCjG
         sR1ak3AdO8JGWCCTI2q2BcHpxDaEQ9+i/JTwdIIgwptd7jrjUCFUaR+c4OXLdVDALigl
         uw3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JFm3i8hiQ9YKTYc3KaQhJAf5gW+QdhhYGs4FBgzwnT8=;
        b=hYBWsLsuhvpG/7SijEcwbN+VvHLLDIohJQG3IC/bgeE7XkOMNbXa9jFuxgUQa9PQ40
         giXRzEOMfWqDpCjXf6JzgyG6Mz8p9y9BJd3diFWnnJrqcrthDLriExNbDkq8CDFhtVS8
         TLCM9w+poyXxyYn4fqvpvvBmgOZeuTJGYafS78NRXrn0PzfYtRdqKkB/pn8t3dLmRvub
         VAjpcztK0SZLPZKzTXKI/LC//eUkDrtZYsF41Hcc/URIqKUzQuytFBeWOZMAxJLNzPjj
         qatAOZDQGQlh3nT09LSWB0bq4lYC2Z4lvvu0xiHcStxGdNt/E8DniKTGbxJK+x20YYDz
         ETFQ==
X-Gm-Message-State: AOAM5303nrLVfyVvgjo3wAxu7kVbBIT2AHG2OXLU74tKIwYAbwaiaq46
        CuT3I1SyKnYauSy8q1yh1D8=
X-Google-Smtp-Source: ABdhPJxLRbIvAqDRZO4Fb+YLII3o1lTEdwpW6gHc06sH2A4nlmKAJtKpv1NgOTak43KOgR9sDGhkzg==
X-Received: by 2002:a4a:9464:: with SMTP id j33mr8555335ooi.5.1628549040579;
        Mon, 09 Aug 2021 15:44:00 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.45])
        by smtp.googlemail.com with ESMTPSA id s35sm3518922otv.44.2021.08.09.15.43.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 15:44:00 -0700 (PDT)
Subject: Re: [PATCH net-next v3] ipv6: add IFLA_INET6_RA_MTU to expose mtu
 value in the RA message
To:     Rocco Yue <rocco.yue@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, rocco.yue@gmail.com,
        chao.song@mediatek.com, zhuoliang.zhang@mediatek.com
References: <20210809140109.32595-1-rocco.yue@mediatek.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c0a6f817-0225-c863-722c-19c798daaa4b@gmail.com>
Date:   Mon, 9 Aug 2021 16:43:58 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210809140109.32595-1-rocco.yue@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/9/21 8:01 AM, Rocco Yue wrote:
> @@ -6129,6 +6136,66 @@ static void ipv6_ifa_notify(int event, struct inet6_ifaddr *ifp)
>  		__ipv6_ifa_notify(event, ifp);
>  }
>  
> +static inline size_t inet6_iframtu_msgsize(void)
> +{
> +	return NLMSG_ALIGN(sizeof(struct ifinfomsg))
> +	     + nla_total_size(IFNAMSIZ)	/* IFLA_IFNAME */
> +	     + nla_total_size(4);	/* IFLA_INET6_RA_MTU */
> +}
> +
> +static int inet6_fill_iframtu(struct sk_buff *skb, struct inet6_dev *idev)
> +{
> +	struct net_device *dev = idev->dev;
> +	struct ifinfomsg *hdr;
> +	struct nlmsghdr *nlh;
> +
> +	nlh = nlmsg_put(skb, 0, 0, RTM_NEWLINK, sizeof(*hdr), 0);
> +	if (!nlh)
> +		return -EMSGSIZE;
> +
> +	hdr = nlmsg_data(nlh);
> +	hdr->ifi_family = AF_INET6;
> +	hdr->__ifi_pad = 0;
> +	hdr->ifi_index = dev->ifindex;
> +	hdr->ifi_flags = dev_get_flags(dev);
> +	hdr->ifi_change = 0;
> +
> +	if (nla_put_string(skb, IFLA_IFNAME, dev->name) ||
> +	    nla_put_u32(skb, IFLA_INET6_RA_MTU, idev->ra_mtu))
> +		goto nla_put_failure;
> +
> +	nlmsg_end(skb, nlh);
> +	return 0;
> +
> +nla_put_failure:
> +	nlmsg_cancel(skb, nlh);
> +	return -EMSGSIZE;
> +}
> +
> +void inet6_iframtu_notify(struct inet6_dev *idev)
> +{
> +	struct sk_buff *skb;
> +	struct net *net = dev_net(idev->dev);
> +	int err = -ENOBUFS;
> +
> +	skb = nlmsg_new(inet6_iframtu_msgsize(), GFP_ATOMIC);
> +	if (!skb)
> +		goto errout;
> +
> +	err = inet6_fill_iframtu(skb, idev);
> +	if (err < 0) {
> +		/* -EMSGSIZE implies BUG in inet6_iframtu_msgsize() */
> +		WARN_ON(err == -EMSGSIZE);
> +		kfree_skb(skb);
> +		goto errout;
> +	}
> +	rtnl_notify(skb, net, 0, RTNLGRP_IPV6_IFINFO, NULL, GFP_ATOMIC);
> +	return;
> +errout:
> +	if (err < 0)
> +		rtnl_set_sk_err(net, RTNLGRP_IPV6_IFINFO, err);
> +}

pretty sure you don't need to build a new notify function.

> +
>  #ifdef CONFIG_SYSCTL
>  
>  static int addrconf_sysctl_forward(struct ctl_table *ctl, int write,
> diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
> index c467c6419893..a04164cbd77f 100644
> --- a/net/ipv6/ndisc.c
> +++ b/net/ipv6/ndisc.c
> @@ -1496,6 +1496,12 @@ static void ndisc_router_discovery(struct sk_buff *skb)
>  		memcpy(&n, ((u8 *)(ndopts.nd_opts_mtu+1))+2, sizeof(mtu));
>  		mtu = ntohl(n);
>  
> +		if (in6_dev->ra_mtu != mtu) {
> +			in6_dev->ra_mtu = mtu;
> +			inet6_iframtu_notify(in6_dev);
> +			ND_PRINTK(2, info, "update ra_mtu to %d\n", in6_dev->ra_mtu);
> +		}
> +
>  		if (mtu < IPV6_MIN_MTU || mtu > skb->dev->mtu) {
>  			ND_PRINTK(2, warn, "RA: invalid mtu: %d\n", mtu);
>  		} else if (in6_dev->cnf.mtu6 != mtu) {

Since this MTU is getting reported via af_info infrastructure,
rtmsg_ifinfo should be sufficient.

From there use 'ip monitor' to make sure you are not generating multiple
notifications; you may only need this on the error path.
