Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86E9C3AB6E4
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 17:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233059AbhFQPI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 11:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231712AbhFQPI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 11:08:26 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31AABC061574
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 08:06:17 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id w22-20020a0568304116b02904060c6415c7so6468314ott.1
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 08:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uoDRyjx9oDLOMuaBap9HedruKcV6wYqiEw8g8fMpMWg=;
        b=LUfiHoutEJsgXelJLqbCnGjWYbJ2btEEWrac1iVUH2coVmzFr9xA903VxkMdfD1xxL
         eJr9U+HI1c+PzzH5PJZ0sqd76BSVxdvVd7O7yudYTOappONMR2z+vik+zQZ9/3VZJVI1
         DV4/xEty1MSNRLYTFvI1y3NqHVbkJtqoUZ2Nvtr0ZA44Sjhs3jlqTo0G6e6K4xTlfV/h
         R1tENk8kxQEG5l9mHyJf2yLs9VJxoB2RZgCvneyoxF7+FPHrJbkbF3RZBO9Jwbj+vWUC
         dAUKuQBb8k5TLzswLNvq7Ikzm+tXxpIX/gLyk6axH9kc6b/RDMS/0KviW/oZ7p88P3Sb
         n0OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uoDRyjx9oDLOMuaBap9HedruKcV6wYqiEw8g8fMpMWg=;
        b=iIYDGIbhno0VlVj6FEkbo3KzfcDhB5Uwg7mdcpUytdnF4pX80SbGMkSsdQsX/w8YzY
         UASwz71Rdw0nyP43uxqnIFQ7iLnIjUWJLnB+Zg0dfB/eokoZn7+iCjUETBN14iKmcXhl
         oJTY3hLF0qlY6wSEIyH/MtJWB1tAXKeQlAJTtofHRzqmuWJnctWFcSfn44kPT0exSeP3
         2IFFJmW5qdwuJM+/sjHzsYxTgpRncruOBjRCwve5G1pIAqYCg8pgLhU/4FXwKW7HAmst
         yxba/qofBM0ixM+Sqw8X4zJhAdPtukyFCq0ngzqE1D6CHwjbg3fOArBxP7Hl1QuZwRzj
         PvmQ==
X-Gm-Message-State: AOAM530WEKq05B1AGPrcJvmYBxpodiDvZmtOQw5cBEwCbG7PRJASGara
        hd3hAu1TfH1ZBK8w7MBNf+c=
X-Google-Smtp-Source: ABdhPJw5Cqh24QqqzpLH6JzA87EpK1ywmyXwwHDy1FY1FmiNJCe82QV5gOT/qTeOhA7bMD3Avrok9w==
X-Received: by 2002:a9d:6c89:: with SMTP id c9mr4897873otr.163.1623942376624;
        Thu, 17 Jun 2021 08:06:16 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.44])
        by smtp.googlemail.com with ESMTPSA id s187sm1165628oig.6.2021.06.17.08.06.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Jun 2021 08:06:15 -0700 (PDT)
Subject: Re: [PATCH net] icmp: don't send out ICMP messages with a source
 address of 0.0.0.0
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        Juliusz Chroboczek <jch@irif.fr>
References: <20210615110709.541499-1-toke@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e4dc611e-2509-2e16-324b-87c574b708dc@gmail.com>
Date:   Thu, 17 Jun 2021 09:06:14 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210615110709.541499-1-toke@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/15/21 5:07 AM, Toke Høiland-Jørgensen wrote:
> When constructing ICMP response messages, the kernel will try to pick a
> suitable source address for the outgoing packet. However, if no IPv4
> addresses are configured on the system at all, this will fail and we end up
> producing an ICMP message with a source address of 0.0.0.0. This can happen
> on a box routing IPv4 traffic via v6 nexthops, for instance.
> 
> Since 0.0.0.0 is not generally routable on the internet, there's a good
> chance that such ICMP messages will never make it back to the sender of the
> original packet that the ICMP message was sent in response to. This, in
> turn, can create connectivity and PMTUd problems for senders. Fortunately,
> RFC7600 reserves a dummy address to be used as a source for ICMP
> messages (192.0.0.8/32), so let's teach the kernel to substitute that
> address as a last resort if the regular source address selection procedure
> fails.
> 
> Below is a quick example reproducing this issue with network namespaces:
> 
> ip netns add ns0
> ip l add type veth peer netns ns0
> ip l set dev veth0 up
> ip a add 10.0.0.1/24 dev veth0
> ip a add fc00:dead:cafe:42::1/64 dev veth0
> ip r add 10.1.0.0/24 via inet6 fc00:dead:cafe:42::2
> ip -n ns0 l set dev veth0 up
> ip -n ns0 a add fc00:dead:cafe:42::2/64 dev veth0
> ip -n ns0 r add 10.0.0.0/24 via inet6 fc00:dead:cafe:42::1
> ip netns exec ns0 sysctl -w net.ipv4.icmp_ratelimit=0
> ip netns exec ns0 sysctl -w net.ipv4.ip_forward=1
> tcpdump -tpni veth0 -c 2 icmp &
> ping -w 1 10.1.0.1 > /dev/null
> tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
> listening on veth0, link-type EN10MB (Ethernet), snapshot length 262144 bytes
> IP 10.0.0.1 > 10.1.0.1: ICMP echo request, id 29, seq 1, length 64
> IP 0.0.0.0 > 10.0.0.1: ICMP net 10.1.0.1 unreachable, length 92
> 2 packets captured
> 2 packets received by filter
> 0 packets dropped by kernel
> 
> With this patch the above capture changes to:
> IP 10.0.0.1 > 10.1.0.1: ICMP echo request, id 31127, seq 1, length 64
> IP 192.0.0.8 > 10.0.0.1: ICMP net 10.1.0.1 unreachable, length 92

We should capture this use case in a test script. There is already an
icmp_redirect.sh; how about starting an icmp.sh script?

> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

This should be the one that allows IPv6 nexthops with IPv4 routes.

Fixes: d15662682db2 ("ipv4: Allow ipv6 gateway with ipv4 routes")

> Reported-by: Juliusz Chroboczek <jch@irif.fr>
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
>  include/uapi/linux/in.h | 3 +++
>  net/ipv4/icmp.c         | 7 +++++++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/include/uapi/linux/in.h b/include/uapi/linux/in.h
> index 7d6687618d80..d1b327036ae4 100644
> --- a/include/uapi/linux/in.h
> +++ b/include/uapi/linux/in.h
> @@ -289,6 +289,9 @@ struct sockaddr_in {
>  /* Address indicating an error return. */
>  #define	INADDR_NONE		((unsigned long int) 0xffffffff)
>  
> +/* Dummy address for src of ICMP replies if no real address is set (RFC7600). */
> +#define	INADDR_DUMMY		((unsigned long int) 0xc0000008)
> +
>  /* Network number for local host loopback. */
>  #define	IN_LOOPBACKNET		127
>  
> diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
> index 7b6931a4d775..752e392083e6 100644
> --- a/net/ipv4/icmp.c
> +++ b/net/ipv4/icmp.c
> @@ -759,6 +759,13 @@ void __icmp_send(struct sk_buff *skb_in, int type, int code, __be32 info,
>  		icmp_param.data_len = room;
>  	icmp_param.head_len = sizeof(struct icmphdr);
>  
> +	/* if we don't have a source address at this point, fall back to the
> +	 * dummy address instead of sending out a packet with a source address
> +	 * of 0.0.0.0
> +	 */
> +	if (!fl4.saddr)
> +		fl4.saddr = htonl(INADDR_DUMMY);
> +
>  	icmp_push_reply(&icmp_param, &fl4, &ipc, &rt);
>  ende:
>  	ip_rt_put(rt);
> 

Reviewed-by: David Ahern <dsahern@kernel.org>
