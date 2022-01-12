Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A36D248CCAF
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 21:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233552AbiALUA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 15:00:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357410AbiALT7m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 14:59:42 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA9AEC061757
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 11:59:41 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id w7so76924ioj.5
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 11:59:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ts/Uegc7xczt3VhuuJ4i19lQ4EP3ZFgUztuaM66waIY=;
        b=oV5ffN4cd+4pvQdyzef3BMB7GS9CV6CffVgIU1MNC+SfNT4hdUkl2U8IqtjJ+O2zeL
         mAizLdau/QNz6R++NLHUF1q2GG9JPaOZ/HKSgEQ6gqk0R51neU8SyUmAfTCYWc3t2+tg
         V5lyeVrM+NuHI0D0qpPcIL3L7IbhBPhJYeWMmxi/5ru7Vf+25MQG/ULxRUdQg95Yd7d+
         /eg4RbBjtgWrMqOiaSeHkvz6Wcs21TouLPN2mfE7lc8JNPpXY0MSYy0/yOa+eTxxpC2k
         KvsJtLYK5t4P9jfr9uaBE81SlzNB+NIB4vhxsDReP1XqJe2cSMo0sBpmpY+rvNNxR3Da
         OJKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ts/Uegc7xczt3VhuuJ4i19lQ4EP3ZFgUztuaM66waIY=;
        b=QSGsWJ1wiEY7jO/6nBy+v3ZHDvFK5KOrTr+rtt2K4vhPtdFvQwIqZW7drIHU/V+YkX
         mVw+GpS9xIiFq6/b6gTPuVpjKWW8rmZ0wD6FEnEni1rRqO5K36HJM7Iv5Ac1Y/yK7D+u
         Dkt0YoVEDEATTT4PvVHSyoUU/mETfSo/9vV+d+TSVmyrEG+U6qWZavH+fqRSNjLeuVmS
         dtmt5ZUJfmn8E0O+GYxe0Fg7JDXK0W0wigudlz4bHu6tt89B8ohPbX+LkucwnHcygdIK
         F/7+Tg6PKKEC25z0cnuFoQsQDyMfE+FBjJgTd2D7RZAemiA/yVWQRdBuBKFFqQUQTYvJ
         wDlw==
X-Gm-Message-State: AOAM5326uiYslwkcDqu/QiKph0jcSMDFluw/fWcLtPNBWrF/+uCZ8jkq
        jCdLuelXo2JbiZg61I5vgDBFcaZue84=
X-Google-Smtp-Source: ABdhPJzQXx7YSC2D0715dcpeyL6i4YYy7uDn8+vJm1YAQiLtiH9Xxzds4toTpD6EyCnmqYITEus/Hw==
X-Received: by 2002:a5e:9b0e:: with SMTP id j14mr669388iok.127.1642017581213;
        Wed, 12 Jan 2022 11:59:41 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.58])
        by smtp.googlemail.com with ESMTPSA id g6sm539656iow.34.2022.01.12.11.59.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jan 2022 11:59:40 -0800 (PST)
Message-ID: <446f3303-d520-7353-713e-baf213c2ed2e@gmail.com>
Date:   Wed, 12 Jan 2022 12:59:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH] sit: allow encapsulated IPv6 traffic to be delivered
 locally
Content-Language: en-US
To:     Ignat Korchagin <ignat@cloudflare.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Cc:     kernel-team@cloudflare.com, Amir Razmjou <arazmjou@cloudflare.com>
References: <20220107123842.211335-1-ignat@cloudflare.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220107123842.211335-1-ignat@cloudflare.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/7/22 5:38 AM, Ignat Korchagin wrote:
> While experimenting with FOU encapsulation Amir noticed that encapsulated IPv6
> traffic fails to be delivered, if the peer IP address is configured locally.
> 
> It can be easily verified by creating a sit interface like below:
> 
> $ sudo ip link add name fou_test type sit remote 127.0.0.1 encap fou encap-sport auto encap-dport 1111
> $ sudo ip link set fou_test up
> 
> and sending some IPv4 and IPv6 traffic to it
> 
> $ ping -I fou_test -c 1 1.1.1.1
> $ ping6 -I fou_test -c 1 fe80::d0b0:dfff:fe4c:fcbc
> 
> "tcpdump -i any udp dst port 1111" will confirm that only the first IPv4 ping
> was encapsulated and attempted to be delivered.
> 
> This seems like a limitation: for example, in a cloud environment the "peer"
> service may be arbitrarily scheduled on any server within the cluster, where all
> nodes are trying to send encapsulated traffic. And the unlucky node will not be
> able to. Moreover, delivering encapsulated IPv4 traffic locally is allowed.
> 
> But I may not have all the context about this restriction and this code predates
> the observable git history.
> 
> Reported-by: Amir Razmjou <arazmjou@cloudflare.com>
> Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
> ---
>  net/ipv6/sit.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
> index 8a3618a30632..72968d4188b9 100644
> --- a/net/ipv6/sit.c
> +++ b/net/ipv6/sit.c
> @@ -956,7 +956,7 @@ static netdev_tx_t ipip6_tunnel_xmit(struct sk_buff *skb,
>  		dst_cache_set_ip4(&tunnel->dst_cache, &rt->dst, fl4.saddr);
>  	}
>  
> -	if (rt->rt_type != RTN_UNICAST) {
> +	if (rt->rt_type != RTN_UNICAST && rt->rt_type != RTN_LOCAL) {
>  		ip_rt_put(rt);
>  		dev->stats.tx_carrier_errors++;
>  		goto tx_error_icmp;

Reviewed-by: David Ahern <dsahern@kernel.org>
