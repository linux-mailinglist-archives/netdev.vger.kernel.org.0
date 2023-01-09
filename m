Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 462766622FD
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 11:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236621AbjAIKS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 05:18:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236851AbjAIKSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 05:18:10 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B0C13CEA
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 02:17:15 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id u9so18866039ejo.0
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 02:17:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=w8hXsiSjQX/0lbC7J/vX67SPCkCeZCgWEuzt/8V06fg=;
        b=VfiEt4GYQ+njpnCGDMnctgHQFWusc4cmRIAdSTWetAjUmF23iwMFyca6ZyFCGd5t6T
         zNr8Emh8yN2Le/YHQxKxoxu0ipSjkjERq489ksPuM0d+4nRxV1psLr4QfxiIOKmG1Fx+
         0CAYW4LL1MO8GZ9TcbbzsXxGkluDgNFM5sYIY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w8hXsiSjQX/0lbC7J/vX67SPCkCeZCgWEuzt/8V06fg=;
        b=r19L9ogf6fCGjNNqOeGhEU5Maxj53+rybUhZosO+yiUY0CIzs+X7I8xWMtNiZLq16/
         1203EwGEdZHZQmo1N/J8PLCIm3HQjELB4qRGmcMyIJ0F7bJWc3EvOLYOY4zdsxDQU82i
         qfuZ/LxkLFTdmZBPo/ALXavMcb0r6udLDAnJ1yfZ3O0A7avsurASsEBuz5k+BHKD+Di0
         NI13iaGih6gAlm9zPTavxJleGlI0xPREkQDfFVyGS8ANwcR3JUIege1goTFLOfx5frfy
         e3smhZHdQvwKoxMcFW+5c/nbJ5Hq2nDRAKZrbc7lRlVoQiK79LPpGfE1nITu9DI6HkpL
         rGMA==
X-Gm-Message-State: AFqh2kpqoHhs7RTetCS0NSeLXv10Yvh+65rdUTd7Q+15PoWRJRoCLkxG
        OkTsWaYZHamnZufL7ZCTde+lZg==
X-Google-Smtp-Source: AMrXdXsUwllX+nTuyxvKQRT8db6Ke1o0JZNYWJyHpX+ehWi6YHzTNbucBFPbFCzW+i0mtahIy8nMZQ==
X-Received: by 2002:a17:907:c58c:b0:82c:3642:79b5 with SMTP id tr12-20020a170907c58c00b0082c364279b5mr55602751ejc.58.1673259433927;
        Mon, 09 Jan 2023 02:17:13 -0800 (PST)
Received: from cloudflare.com (79.184.151.107.ipv4.supernova.orange.pl. [79.184.151.107])
        by smtp.gmail.com with ESMTPSA id cb1-20020a170906a44100b0084d199d7f08sm3525637ejb.21.2023.01.09.02.17.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 02:17:13 -0800 (PST)
References: <20221221-sockopt-port-range-v1-1-e2b094b60ffd@cloudflare.com>
 <20230106171632.10691-1-kuniyu@amazon.com>
User-agent: mu4e 1.6.10; emacs 28.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, edumazet@google.com,
        kernel-team@cloudflare.com, kuba@kernel.org, marek@cloudflare.com,
        netdev@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next 1/2] inet: Add IP_LOCAL_PORT_RANGE socket option
Date:   Mon, 09 Jan 2023 11:11:32 +0100
In-reply-to: <20230106171632.10691-1-kuniyu@amazon.com>
Message-ID: <87o7r89fmg.fsf@cloudflare.com>
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

On Sat, Jan 07, 2023 at 02:16 AM +09, Kuniyuki Iwashima wrote:
> From:   Jakub Sitnicki <jakub@cloudflare.com>
> Date:   Fri,  6 Jan 2023 11:37:37 +0100
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
>>   v = struct.pack("I", PORT_LO | (PORT_HI << 16))
>>   s.setsockopt(SOL_IP, IP_LOCAL_PORT_RANGE, v)
>>   s.bind(("127.0.0.1", 0))
>>   s.getsockname()
>>   # Local address between ("127.0.0.1", 40_000) and ("127.0.0.1", 40_511),
>>   # if there is a free port. EADDRINUSE otherwise.
>> 
>> [1] https://github.com/cloudflare/cloudflare-blog/blob/232b432c1d57/2022-02-connectx/connectx.py#L116
>> 
>> Reviewed-by: Marek Majkowski <marek@cloudflare.com>
>> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>> ---

[...]

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
>> @@ -130,6 +130,24 @@ void inet_get_local_port_range(struct net *net, int *low, int *high)
>>  }
>>  EXPORT_SYMBOL(inet_get_local_port_range);
>>  
>> +void inet_sk_get_local_port_range(const struct sock *sk, int *low, int *high)
>> +{
>> +	const struct inet_sock *inet = inet_sk(sk);
>> +	const struct net *net = sock_net(sk);
>> +	int lo, hi;
>> +
>> +	inet_get_local_port_range(net, &lo, &hi);
>> +
>> +	if (unlikely(inet->local_port_range.lo))
>> +		lo = clamp_val(inet->local_port_range.lo, lo, hi);
>> +	if (unlikely(inet->local_port_range.hi))
>> +		hi = clamp_val(inet->local_port_range.hi, lo, hi);
>
> If both vals are outside of the global range, the new range is clamped
> to (netns-lo, netns-lo) or (netnsl-hi, netns-hi).
>
>     .lo   .hi     lo                 hi     .lo    .hi
>      |-----|       |-----------------|       |------|
>
> It seems the description in the man page and changelog is not correct.

This is a bug. I overlooked this corner case.
Thank you for pointing it out.
Will fix and add test coverage in v2.

[...]

>> --- a/net/ipv4/ip_sockglue.c
>> +++ b/net/ipv4/ip_sockglue.c
>> @@ -923,6 +923,7 @@ int do_ip_setsockopt(struct sock *sk, int level, int optname,
>>  	case IP_CHECKSUM:
>>  	case IP_RECVFRAGSIZE:
>>  	case IP_RECVERR_RFC4884:
>> +	case IP_LOCAL_PORT_RANGE:
>>  		if (optlen >= sizeof(int)) {
>>  			if (copy_from_sockptr(&val, optval, sizeof(val)))
>>  				return -EFAULT;
>> @@ -1365,6 +1366,20 @@ int do_ip_setsockopt(struct sock *sk, int level, int optname,
>>  		WRITE_ONCE(inet->min_ttl, val);
>>  		break;
>>  
>> +	case IP_LOCAL_PORT_RANGE:
>> +	{
>> +		const __u16 lo = val;
>> +		const __u16 hi = val >> 16;
>> +
>> +		if (optlen != sizeof(__u32))
>> +			goto e_inval;
>> +		if (lo != 0 && hi != 0 && lo > hi)
>
> Should (0, 0) be EINVAL as it has no effect ?
>
>                 if ((!lo && !hi) || (lo && hi && lo > hi))
>                         goto e_inval;

User can pass (0, 0) to unset the setting. This is intentional.
The `get_port_range` test in the following patch covers it.

Thank you for feedback,
Jakub
