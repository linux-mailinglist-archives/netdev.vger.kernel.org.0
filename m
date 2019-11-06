Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDDCF205B
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 22:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732589AbfKFVGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 16:06:38 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36589 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727794AbfKFVGh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 16:06:37 -0500
Received: by mail-wr1-f67.google.com with SMTP id r10so216894wrx.3
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 13:06:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MqpzOP5xpsOGjxOWnYRkigNeIfXpG8rAI4fIo15URUY=;
        b=P1oAt0qlmih7JMLNJhSKqQU4lqJwqZB8qwP555w60EsNIjTAikbFGpt295wdN/GMHC
         8NJtuYhp4lKjYGcGElAfTYpezzhRHQZBn1PCpSN/Rn1y9RVvnufwU/T3U708c2NliNpQ
         beq+Xp/PYJ+xDXJsKcOrQ5b1vyDiiac3xXV6KZ/QZrwiY8oJn4xHVkgr/FF0jQL77zgn
         xA+mJlgIKM9WfPOxrzY9rv8QvMwPDMtyM7qj8YOh9C5tQV4Vnt9QvNCnaD5cHS2OayOZ
         v7jyO+4MYr/h9sGGJbpy15isNJQ8bIXWngs5Rn67Tl0kNK1bQ43qlTs2/E4n3VayfnKh
         PSdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=MqpzOP5xpsOGjxOWnYRkigNeIfXpG8rAI4fIo15URUY=;
        b=h16tOyrVIIJ93O2cHMLofFiczua1RyakaUmZuIUkqS3ZI+4wAUq3etr3FZpDe9dHje
         LY9d5cfk7Ingc1vTE6cVSYMwKEFt3piA1az10FY+t6+/Xtg4jbWWRdEDFd9iz1N0nr7Z
         ASLsGGZyyP9jElHpFz6zEpomduCE2pD0JlpgaByJe+jG+nHQTx6NyFNTYCr9HYkNWEgM
         jPMZ4fg/1Jax6UPRZdShZX9a+HAfRMivuc+zgJ4rWejmQd7e3JmTPDNttgTco2nAfJ7v
         nqnBHJert/rQfH6+Eo4n+oxm0MMo3wprTWvaKedHPpIJfXM35HacDJb4biE2E/WubVyP
         QJGw==
X-Gm-Message-State: APjAAAXlfykFeP+kK9QbjEqyWG2r2NkNLrrJKFtrrLx1YMZ1DUNoywPw
        tsFQ0muC0pqogDJRRTLZ4dBPF2NwzUE=
X-Google-Smtp-Source: APXvYqwTUSiPjuk15gUSlYdIkf+wbFPwh8bCd8IdB3llI0ntHZ/2HZKzv5VwlEvWH3wOKa09pnOmoQ==
X-Received: by 2002:a5d:4649:: with SMTP id j9mr4710551wrs.248.1573074394971;
        Wed, 06 Nov 2019 13:06:34 -0800 (PST)
Received: from ?IPv6:2a01:e35:8b63:dc30:95e0:8058:2b4b:3437? ([2a01:e35:8b63:dc30:95e0:8058:2b4b:3437])
        by smtp.gmail.com with ESMTPSA id x205sm5354939wmb.5.2019.11.06.13.06.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Nov 2019 13:06:33 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH v2 4/5] net: ipv4: allow setting address on interface
 outside current namespace
To:     Jonas Bonn <jonas@norrbonn.se>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net
References: <20191106053923.10414-1-jonas@norrbonn.se>
 <20191106053923.10414-5-jonas@norrbonn.se>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <1f8a0f3e-e4ac-40c9-26e6-f14498ccdbe9@6wind.com>
Date:   Wed, 6 Nov 2019 22:06:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191106053923.10414-5-jonas@norrbonn.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 06/11/2019 à 06:39, Jonas Bonn a écrit :
> This patch allows an interface outside of the current namespace to be
> selected when setting a new IPv4 address for a device.  This uses the
> IFA_TARGET_NETNSID attribute to select the namespace in which to search
> for the interface to act upon.
> 
> Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
> ---
[snip]
> @@ -922,16 +917,37 @@ static int inet_rtm_newaddr(struct sk_buff *skb, struct nlmsghdr *nlh,
>  			    struct netlink_ext_ack *extack)
>  {
>  	struct net *net = sock_net(skb->sk);
> +	struct net *tgt_net = NULL;
>  	struct in_ifaddr *ifa;
>  	struct in_ifaddr *ifa_existing;
>  	__u32 valid_lft = INFINITY_LIFE_TIME;
>  	__u32 prefered_lft = INFINITY_LIFE_TIME;
> +	struct nlattr *tb[IFA_MAX+1];
> +	int err;
>  
>  	ASSERT_RTNL();
>  
> -	ifa = rtm_to_ifaddr(net, nlh, &valid_lft, &prefered_lft, extack);
> -	if (IS_ERR(ifa))
> -		return PTR_ERR(ifa);
> +	err = nlmsg_parse_deprecated(nlh, sizeof(struct ifaddrmsg), tb, IFA_MAX,
> +				     ifa_ipv4_policy, extack);
> +	if (err < 0)
> +		return err;
> +
> +	if (tb[IFA_TARGET_NETNSID]) {
> +		int32_t netnsid = nla_get_s32(tb[IFA_TARGET_NETNSID]);
> +
> +		tgt_net = rtnl_get_net_ns_capable(NETLINK_CB(skb).sk, netnsid);
> +		if (IS_ERR(net)) {
if (IS_ERR(tgt_net)) ?

Nicolas
