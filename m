Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9CE665BAF
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 13:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbjAKMpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 07:45:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbjAKMpE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 07:45:04 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64777FD
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 04:45:03 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id u9so36588751ejo.0
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 04:45:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=dMYEIYouutIur6KiBhxQQAE56VlNMrU6ItYzLkJ29QY=;
        b=ntjz0uZghpMA7vqd5GHoLDZsUGP7CmToCK/qXUMHPbrO16545MxNY0/gwkxplTVqnY
         AgCtvtmILj1cO+KNEKJGoddhA7ACEr/MKKZy5eUUl0VHd3wYOKGwNRnWH06XaeXf0Tcr
         AmhZRf0EsTzJ4QkpcYoPNmbeP05l6olXQ/iy8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dMYEIYouutIur6KiBhxQQAE56VlNMrU6ItYzLkJ29QY=;
        b=GV3SQNdMx+kVRlxZf5IWZiLjivvOA83SZLYW/hkexZmSo9cyGOzUz3SPz1oi4meiVv
         I0A7kLKCkTb2PoigeYv8vkKnyPwO8l2CMgTbmA+ExKeTte4Dy4UKKd369q9qcleAYLJt
         3Q+vSldFb+lJBjXffMr1P+E1y5uYilwfxtZtjGvAZ2W/Jb2+ySYQW6ihHWOrSr5m3B6X
         vfOp6Pxusp1OyY3dY70DhkKPJHI5aobRuji+SVkzRn1pLa6yvjvuEj36KgrNeGITuCzQ
         9uo2pRr8xDsg9ipNfWLMhrnGe5UJygo+tRZ2wT5aVORRNUSUP6umbw0xG0XmGhaNtqBH
         Rw4g==
X-Gm-Message-State: AFqh2kp2w5DJYF2tSbcZPp1Sc87fQaHRHP6ry/ol0gjE9PVWGoWOsLBU
        Mi+V5l+hEGoJD19hfcm2i9cO4OXOzMdw9ewY
X-Google-Smtp-Source: AMrXdXufSP4UPuWh2IdmuozSctsK2TplITQOiG6BmtHkAMB6RnsQOSlB/DKKGaIw0ZFvk/cPvfuHXQ==
X-Received: by 2002:a17:907:c60c:b0:84d:4394:e8e with SMTP id ud12-20020a170907c60c00b0084d43940e8emr10834341ejc.41.1673441101870;
        Wed, 11 Jan 2023 04:45:01 -0800 (PST)
Received: from cloudflare.com (79.184.151.107.ipv4.supernova.orange.pl. [79.184.151.107])
        by smtp.gmail.com with ESMTPSA id k2-20020a170906970200b0073dbaeb50f6sm6049886ejx.169.2023.01.11.04.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 04:45:01 -0800 (PST)
References: <20221221-sockopt-port-range-v2-1-1d5f114bf627@cloudflare.com>
 <20230111005923.47037-1-kuniyu@amazon.com>
User-agent: mu4e 1.6.10; emacs 28.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, edumazet@google.com,
        kernel-team@cloudflare.com, kuba@kernel.org, marek@cloudflare.com,
        netdev@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next v2 1/2] inet: Add IP_LOCAL_PORT_RANGE socket
 option
Date:   Wed, 11 Jan 2023 13:44:03 +0100
In-reply-to: <20230111005923.47037-1-kuniyu@amazon.com>
Message-ID: <87tu0xckab.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 11, 2023 at 09:59 AM +09, Kuniyuki Iwashima wrote:
> From:   Jakub Sitnicki <jakub@cloudflare.com>
> Date:   Tue, 10 Jan 2023 14:37:29 +0100
>> Users who want to share a single public IP address for outgoing connections
>> between several hosts traditionally reach for SNAT. However, SNAT requires
>> state keeping on the node(s) performing the NAT.
>> 
>> A stateless alternative exists, where a single IP address used for egress
>> can be shared between several hosts by partitioning the available ephemeral
>> port range. In such a setup:
>> 
>> 1. Each host gets assigned a disjoint range of ephemeral ports.
>> 2. Applications open connections from the host-assigned port range.
>> 3. Return traffic gets routed to the host based on both, the destination IP
>>    and the destination port.
>> 
>> An application which wants to open an outgoing connection (connect) from a
>> given port range today can choose between two solutions:
>> 
>> 1. Manually pick the source port by bind()'ing to it before connect()'ing
>>    the socket.
>> 
>>    This approach has a couple of downsides:
>> 
>>    a) Search for a free port has to be implemented in the user-space. If
>>       the chosen 4-tuple happens to be busy, the application needs to retry
>>       from a different local port number.
>> 
>>       Detecting if 4-tuple is busy can be either easy (TCP) or hard
>>       (UDP). In TCP case, the application simply has to check if connect()
>>       returned an error (EADDRNOTAVAIL). That is assuming that the local
>>       port sharing was enabled (REUSEADDR) by all the sockets.
>> 
>>         # Assume desired local port range is 60_000-60_511
>>         s = socket(AF_INET, SOCK_STREAM)
>>         s.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
>>         s.bind(("192.0.2.1", 60_000))
>>         s.connect(("1.1.1.1", 53))
>>         # Fails only if 192.0.2.1:60000 -> 1.1.1.1:53 is busy
>>         # Application must retry with another local port
>> 
>>       In case of UDP, the network stack allows binding more than one socket
>>       to the same 4-tuple, when local port sharing is enabled
>>       (REUSEADDR). Hence detecting the conflict is much harder and involves
>>       querying sock_diag and toggling the REUSEADDR flag [1].
>> 
>>    b) For TCP, bind()-ing to a port within the ephemeral port range means
>>       that no connecting sockets, that is those which leave it to the
>>       network stack to find a free local port at connect() time, can use
>>       the this port.
>> 
>>       IOW, the bind hash bucket tb->fastreuse will be 0 or 1, and the port
>>       will be skipped during the free port search at connect() time.
>> 
>> 2. Isolate the app in a dedicated netns and use the use the per-netns
>>    ip_local_port_range sysctl to adjust the ephemeral port range bounds.
>> 
>>    The per-netns setting affects all sockets, so this approach can be used
>>    only if:
>> 
>>    - there is just one egress IP address, or
>>    - the desired egress port range is the same for all egress IP addresses
>>      used by the application.
>> 
>>    For TCP, this approach avoids the downsides of (1). Free port search and
>>    4-tuple conflict detection is done by the network stack:
>> 
>>      system("sysctl -w net.ipv4.ip_local_port_range='60000 60511'")
>> 
>>      s = socket(AF_INET, SOCK_STREAM)
>>      s.setsockopt(SOL_IP, IP_BIND_ADDRESS_NO_PORT, 1)
>>      s.bind(("192.0.2.1", 0))
>>      s.connect(("1.1.1.1", 53))
>>      # Fails if all 4-tuples 192.0.2.1:60000-60511 -> 1.1.1.1:53 are busy
>> 
>>   For UDP this approach has limited applicability. Setting the
>>   IP_BIND_ADDRESS_NO_PORT socket option does not result in local source
>>   port being shared with other connected UDP sockets.
>> 
>>   Hence relying on the network stack to find a free source port, limits the
>>   number of outgoing UDP flows from a single IP address down to the number
>>   of available ephemeral ports.
>> 
>> To put it another way, partitioning the ephemeral port range between hosts
>> using the existing Linux networking API is cumbersome.
>> 
>> To address this use case, add a new socket option at the SOL_IP level,
>> named IP_LOCAL_PORT_RANGE. The new option can be used to clamp down the
>> ephemeral port range for each socket individually.
>> 
>> The option can be used only to narrow down the per-netns local port
>> range. If the per-socket range lies outside of the per-netns range, the
>> latter takes precedence.
>> 
>> UAPI-wise, the low and high range bounds are passed to the kernel as a pair
>> of u16 values packed into a u32. This avoids pointer passing.
>> 
>>   PORT_LO = 40_000
>>   PORT_HI = 40_511
>> 
>>   s = socket(AF_INET, SOCK_STREAM)
>>   v = struct.pack("I", PORT_HI << 16 | PORT_LO)
>>   s.setsockopt(SOL_IP, IP_LOCAL_PORT_RANGE, v)
>>   s.bind(("127.0.0.1", 0))
>>   s.getsockname()
>>   # Local address between ("127.0.0.1", 40_000) and ("127.0.0.1", 40_511),
>>   # if there is a free port. EADDRINUSE otherwise.
>> 
>> [1] https://github.com/cloudflare/cloudflare-blog/blob/232b432c1d57/2022-02-connectx/connectx.py#L116
>> 
>> v1 -> v2:
>>  * Fix the corner case when the per-socket range doesn't overlap with the
>>    per-netns range. Fallback correctly to the per-netns range. (Kuniyuki)
>> 
>> Reviewed-by: Marek Majkowski <marek@cloudflare.com>
>> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>> ---

[...]

>>  include/net/ip.h                |  3 ++-
>>  include/uapi/linux/in.h         |  1 +
>>  net/ipv4/inet_connection_sock.c | 25 +++++++++++++++++++++++--
>>  net/ipv4/inet_hashtables.c      |  2 +-
>>  net/ipv4/ip_sockglue.c          | 18 ++++++++++++++++++
>>  net/ipv4/udp.c                  |  2 +-
>>  7 files changed, 50 insertions(+), 5 deletions(-)
>> 
>> diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
>> index bf5654ce711e..51857117ac09 100644
>> --- a/include/net/inet_sock.h
>> +++ b/include/net/inet_sock.h
>> @@ -249,6 +249,10 @@ struct inet_sock {
>>  	__be32			mc_addr;
>>  	struct ip_mc_socklist __rcu	*mc_list;
>>  	struct inet_cork_full	cork;
>> +	struct {
>> +		__u16 lo;
>> +		__u16 hi;
>> +	}			local_port_range;
>>  };
>>  
>>  #define IPCORK_OPT	1	/* ip-options has been held in ipcork.opt */
>> diff --git a/include/net/ip.h b/include/net/ip.h
>> index 144bdfbb25af..c3fffaa92d6e 100644
>> --- a/include/net/ip.h
>> +++ b/include/net/ip.h
>> @@ -340,7 +340,8 @@ static inline u64 snmp_fold_field64(void __percpu *mib, int offt, size_t syncp_o
>>  	} \
>>  }
>>  
>> -void inet_get_local_port_range(struct net *net, int *low, int *high);
>> +void inet_get_local_port_range(const struct net *net, int *low, int *high);
>> +void inet_sk_get_local_port_range(const struct sock *sk, int *low, int *high);
>>  
>>  #ifdef CONFIG_SYSCTL
>>  static inline bool inet_is_local_reserved_port(struct net *net, unsigned short port)
>> diff --git a/include/uapi/linux/in.h b/include/uapi/linux/in.h
>> index 07a4cb149305..4b7f2df66b99 100644
>> --- a/include/uapi/linux/in.h
>> +++ b/include/uapi/linux/in.h
>> @@ -162,6 +162,7 @@ struct in_addr {
>>  #define MCAST_MSFILTER			48
>>  #define IP_MULTICAST_ALL		49
>>  #define IP_UNICAST_IF			50
>> +#define IP_LOCAL_PORT_RANGE		51
>>  
>>  #define MCAST_EXCLUDE	0
>>  #define MCAST_INCLUDE	1
>> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
>> index d1f837579398..1049a9b8d152 100644
>> --- a/net/ipv4/inet_connection_sock.c
>> +++ b/net/ipv4/inet_connection_sock.c
>> @@ -117,7 +117,7 @@ bool inet_rcv_saddr_any(const struct sock *sk)
>>  	return !sk->sk_rcv_saddr;
>>  }
>>  
>> -void inet_get_local_port_range(struct net *net, int *low, int *high)
>> +void inet_get_local_port_range(const struct net *net, int *low, int *high)
>>  {
>>  	unsigned int seq;
>>  
>> @@ -130,6 +130,27 @@ void inet_get_local_port_range(struct net *net, int *low, int *high)
>>  }
>>  EXPORT_SYMBOL(inet_get_local_port_range);
>>  
>> +void inet_sk_get_local_port_range(const struct sock *sk, int *low, int *high)
>> +{
>> +	const struct inet_sock *inet = inet_sk(sk);
>> +	const struct net *net = sock_net(sk);
>> +	int lo, hi, sk_lo, sk_hi;
>> +
>> +	inet_get_local_port_range(net, &lo, &hi);
>> +
>> +	sk_lo = inet->local_port_range.lo;
>> +	sk_hi = inet->local_port_range.hi;
>> +
>> +	if (unlikely(sk_lo && sk_lo <= hi))
>> +		lo = max(lo, sk_lo);
>> +	if (unlikely(sk_hi && sk_hi >= lo))
>> +		hi = min(hi, sk_hi);
>
> nit: The min of sysctl lo/hi is 1, so
>
>         if (unlikely(lo <= sk_lo && sk_lo <= hi))
>                 lo = sk_lo;
>         if (unlikely(lo <= sk_hi && sk_hi <= hi))
>                 hi = sk_hi;
>
> this seems cleaner.

That is much cleaner. Will apply to v3.
