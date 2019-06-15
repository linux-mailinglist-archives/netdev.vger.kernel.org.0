Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88F1046D59
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 03:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbfFOBAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 21:00:30 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43408 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbfFOBAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 21:00:30 -0400
Received: by mail-pl1-f195.google.com with SMTP id cl9so1657438plb.10
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 18:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Z8ILayutdSWFr5Nt9di0wIwDTAVvdPo6MIZ15y9+gbQ=;
        b=gErIYj3yWfWtkQ8x2wqG4kZ1OYQ4qziT7H2rcrVRflpgAbIhJrfbzF/rsiV1Zuatvd
         oiVxsG6eusy0pwca3761HJeWpr88sUkz7rscnJZLU6NT18EGv1ANi2y0d0RshLOAcVeZ
         h3jjEKIp3yLzqYPT2kLBlUls1ApdPhZ2Smk8/5zCajv1pEaxUiKk6sOwv7/+Y0roMDFA
         XMUDQrn9l5jtFT1sjVXS+5VbZPgp5njZJVEGwNfzM9Qw3w/HWzbAamYRu6UHjU3/uQz9
         g91knxPameKFXtWn4L5rQZA6nMUgSfGTOypl/cbkNt0f+gcoaOLn6XT1kyppwHkW26Hf
         QW9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z8ILayutdSWFr5Nt9di0wIwDTAVvdPo6MIZ15y9+gbQ=;
        b=NxdIvtl9j3V3YqD4vbGUhp0LlRd8BJGJoa+oPR3C6++N76LI7r37joX6AtT+oNz2kY
         S4cTz0q8x7r8wefTIcgVpIqMwtkodcdOe5vURwVD0LGdbdWwlRbcSRGRDwpQC8dtXTzy
         ujFIgEWgzWXgNbpLSLDC78M8thaJicN2UdS/xmNHI5dfLLtHSxp6B8xfqg9UQ5TSzpbs
         FJ0m29henCCZqPYBVqkSsAGsNu1UB6FxvgPr69wW4Getn4V4n6ijYIYcZZYAdjaPDZdn
         zjaiMUejWrs0joL/vByHNoCMf87GnqUTnXlc1wt8IDx9xe6b0WLB9BnUBuNywX8OHGXZ
         zXuA==
X-Gm-Message-State: APjAAAXzUTIWR7djyvyDqN76/cohjkinqE9vxeLNi3JyFhJF2vs6Z8ae
        XAq+lC63Fzao1YQhErDf43+N/YOVQhg=
X-Google-Smtp-Source: APXvYqxcCALuD/o7D6OMFkqGWKfRtMgZv6YMEnoOisJMLZ7fkOhjOHOuVSgDd7/G/MjiMUPnGT07xw==
X-Received: by 2002:a17:902:a986:: with SMTP id bh6mr94476865plb.100.1560560429799;
        Fri, 14 Jun 2019 18:00:29 -0700 (PDT)
Received: from [172.27.227.153] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id s24sm3948361pfh.133.2019.06.14.18.00.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 18:00:28 -0700 (PDT)
Subject: Re: [PATCH] ipv4: fix inet_select_addr() when enable route_localnet
To:     luoshijie <luoshijie1@huawei.com>, davem@davemloft.net,
        tgraf@suug.ch
Cc:     netdev@vger.kernel.org, viro@zeniv.linux.org.uk
References: <1560531321-163094-1-git-send-email-luoshijie1@huawei.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7f4443a0-b63f-22ea-2b39-9ab9752b3479@gmail.com>
Date:   Fri, 14 Jun 2019 19:00:27 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1560531321-163094-1-git-send-email-luoshijie1@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/14/19 10:55 AM, luoshijie wrote:
> From: Shijie Luo <luoshijie1@huawei.com>
> 
> Suppose we have two interfaces eth0 and eth1 in two hosts, follow 
> the same steps in the two hosts:
> # sysctl -w net.ipv4.conf.eth1.route_localnet=1
> # sysctl -w net.ipv4.conf.eth1.arp_announce=2
> # ip route del 127.0.0.0/8 dev lo table local
> and then set ip to eth1 in host1 like:
> # ifconfig eth1 127.25.3.4/24
> set ip to eth2 in host2 and ping host1:
> # ifconfig eth1 127.25.3.14/24
> # ping -I eth1 127.25.3.4
> Well, host2 cannot connect to host1.

Since you already have the commands, create a test script in
tools/testing/selftests/net that uses network namespaces for host1 and
host2 and demonstrates the problem. There quite a few examples in that
directory to use as a template. eg., see icmp_redirect.sh

> diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
> index ea4bd8a52..325fafd4b 100644
> --- a/net/ipv4/devinet.c
> +++ b/net/ipv4/devinet.c
> @@ -1249,14 +1249,19 @@ __be32 inet_select_addr(const struct net_device *dev, __be32 dst, int scope)
>  	struct in_device *in_dev;
>  	struct net *net = dev_net(dev);
>  	int master_idx;
> +	unsigned char localnet_scope = RT_SCOPE_HOST;

net code uses reverse xmas tree ordering. ie., move that up.

>  
>  	rcu_read_lock();
>  	in_dev = __in_dev_get_rcu(dev);
>  	if (!in_dev)
>  		goto no_in_dev;
>  
> +	if (unlikely(IN_DEV_ROUTE_LOCALNET(in_dev))) {
> +		localnet_scope = RT_SCOPE_LINK;
> +	}
> +

brackets are not needed.


>  	for_primary_ifa(in_dev) {
> -		if (ifa->ifa_scope > scope)
> +		if (min(ifa->ifa_scope, localnet_scope) > scope)
>  			continue;
>  		if (!dst || inet_ifa_match(dst, ifa)) {
>  			addr = ifa->ifa_local;
> 

