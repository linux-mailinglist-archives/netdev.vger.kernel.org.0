Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E408D4EC5B5
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 15:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236449AbiC3Nfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 09:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237223AbiC3Nfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 09:35:40 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5732612ABF;
        Wed, 30 Mar 2022 06:33:55 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1316A21603;
        Wed, 30 Mar 2022 13:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1648647234; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JZ7etbOkud23rePgYHX93VM2Npayks8E311gepaCXY8=;
        b=WpI/P3lwWz2bV3KFAUbTx0kz/vfwAV0U3f6iBQK1XjHMl8LXl4vOQYhPUvrL8MrCzkfgD7
        MEQWIsGbyrQaHo8iX5NkpvPZHn4rXD89G6gSTIfbJLGtt8yC106/LGheJT0WpM/TEgjyZj
        yu2ij34aoVAdBsVxonQlWow8zrQ2Btw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1648647234;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JZ7etbOkud23rePgYHX93VM2Npayks8E311gepaCXY8=;
        b=Dj4Od0Ng8MqvY192E61SBMgtpwD6sjqpn+eheGNsS/vwgu8+LIwt970QapimTNpxsw82xp
        mCASVJH5OkqnCrBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 561EE13AF3;
        Wed, 30 Mar 2022 13:33:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id o57tEUFcRGK1WQAAMHmgww
        (envelope-from <dkirjanov@suse.de>); Wed, 30 Mar 2022 13:33:53 +0000
Message-ID: <9f7a92f5-5674-5c9f-e5ec-4a68ec8cb0d1@suse.de>
Date:   Wed, 30 Mar 2022 16:33:48 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] tcp: Add tracepoint for tcp_set_ca_state
Content-Language: ru
To:     jackygam2001 <jacky_gam_2001@163.com>, edumazet@google.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        rostedt@goodmis.org, mingo@redhat.com, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ping.gan@dell.com
References: <20220330130128.10256-1-jacky_gam_2001@163.com>
From:   Denis Kirjanov <dkirjanov@suse.de>
In-Reply-To: <20220330130128.10256-1-jacky_gam_2001@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



3/30/22 16:01, jackygam2001 пишет:
> The congestion status of a tcp flow may be updated since there
> is congestion between tcp sender and receiver. It makes sense for
> adding tracepoint for congestion status update function to evaluate
> the performance of network and congestion algorithm.
> 
> Link: https://github.com/iovisor/bcc/pull/3899
> 
> Signed-off-by: jackygam2001 <jacky_gam_2001@163.com>
Please use net-next prefix and use your real name in SOB

> ---
>   include/net/tcp.h          | 12 +++---------
>   include/trace/events/tcp.h | 45 +++++++++++++++++++++++++++++++++++++++++++++
>   net/ipv4/tcp_cong.c        | 12 ++++++++++++
>   3 files changed, 60 insertions(+), 9 deletions(-)
> 
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 70ca4a5e330a..9a3786f33798 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -1139,15 +1139,6 @@ static inline bool tcp_ca_needs_ecn(const struct sock *sk)
>   	return icsk->icsk_ca_ops->flags & TCP_CONG_NEEDS_ECN;
>   }
>   
> -static inline void tcp_set_ca_state(struct sock *sk, const u8 ca_state)
> -{
> -	struct inet_connection_sock *icsk = inet_csk(sk);
> -
> -	if (icsk->icsk_ca_ops->set_state)
> -		icsk->icsk_ca_ops->set_state(sk, ca_state);
> -	icsk->icsk_ca_state = ca_state;
> -}
> -
>   static inline void tcp_ca_event(struct sock *sk, const enum tcp_ca_event event)
>   {
>   	const struct inet_connection_sock *icsk = inet_csk(sk);
> @@ -1156,6 +1147,9 @@ static inline void tcp_ca_event(struct sock *sk, const enum tcp_ca_event event)
>   		icsk->icsk_ca_ops->cwnd_event(sk, event);
>   }
>   
> +/* From tcp_cong.c */
> +void tcp_set_ca_state(struct sock *sk, const u8 ca_state);
> +
>   /* From tcp_rate.c */
>   void tcp_rate_skb_sent(struct sock *sk, struct sk_buff *skb);
>   void tcp_rate_skb_delivered(struct sock *sk, struct sk_buff *skb,
> diff --git a/include/trace/events/tcp.h b/include/trace/events/tcp.h
> index 521059d8dc0a..69a68b01c1de 100644
> --- a/include/trace/events/tcp.h
> +++ b/include/trace/events/tcp.h
> @@ -371,6 +371,51 @@ DEFINE_EVENT(tcp_event_skb, tcp_bad_csum,
>   	TP_ARGS(skb)
>   );
>   
> +TRACE_EVENT(tcp_cong_state_set,
> +
> +	TP_PROTO(struct sock *sk, const u8 ca_state),
> +
> +	TP_ARGS(sk, ca_state),
> +
> +	TP_STRUCT__entry(
> +		__field(const void *, skaddr)
> +		__field(__u16, sport)
> +		__field(__u16, dport)
> +		__array(__u8, saddr, 4)
> +		__array(__u8, daddr, 4)
> +		__array(__u8, saddr_v6, 16)
> +		__array(__u8, daddr_v6, 16)
> +		__field(__u8, cong_state)
> +	),
> +
> +	TP_fast_assign(
> +		struct inet_sock *inet = inet_sk(sk);
> +		__be32 *p32;
> +
> +		__entry->skaddr = sk;
> +
> +		__entry->sport = ntohs(inet->inet_sport);
> +		__entry->dport = ntohs(inet->inet_dport);
> +
> +		p32 = (__be32 *) __entry->saddr;
> +		*p32 = inet->inet_saddr;
> +
> +		p32 = (__be32 *) __entry->daddr;
> +		*p32 =  inet->inet_daddr;
> +
> +		TP_STORE_ADDRS(__entry, inet->inet_saddr, inet->inet_daddr,
> +			   sk->sk_v6_rcv_saddr, sk->sk_v6_daddr);
> +
> +		__entry->cong_state = ca_state;
> +	),
> +
> +	TP_printk("sport=%hu dport=%hu saddr=%pI4 daddr=%pI4 saddrv6=%pI6c daddrv6=%pI6c cong_state=%u",
> +		  __entry->sport, __entry->dport,
> +		  __entry->saddr, __entry->daddr,
> +		  __entry->saddr_v6, __entry->daddr_v6,
> +		  __entry->cong_state)
> +);
> +
>   #endif /* _TRACE_TCP_H */
>   
>   /* This part must be outside protection */
> diff --git a/net/ipv4/tcp_cong.c b/net/ipv4/tcp_cong.c
> index dc95572163df..98b48bdb8be7 100644
> --- a/net/ipv4/tcp_cong.c
> +++ b/net/ipv4/tcp_cong.c
> @@ -16,6 +16,7 @@
>   #include <linux/gfp.h>
>   #include <linux/jhash.h>
>   #include <net/tcp.h>
> +#include <trace/events/tcp.h>
>   
>   static DEFINE_SPINLOCK(tcp_cong_list_lock);
>   static LIST_HEAD(tcp_cong_list);
> @@ -33,6 +34,17 @@ struct tcp_congestion_ops *tcp_ca_find(const char *name)
>   	return NULL;
>   }
>   
> +void tcp_set_ca_state(struct sock *sk, const u8 ca_state)
> +{
> +	struct inet_connection_sock *icsk = inet_csk(sk);
> +
> +	trace_tcp_cong_state_set(sk, ca_state);
> +
> +	if (icsk->icsk_ca_ops->set_state)
> +		icsk->icsk_ca_ops->set_state(sk, ca_state);
> +	icsk->icsk_ca_state = ca_state;
> +}
> +
>   /* Must be called with rcu lock held */
>   static struct tcp_congestion_ops *tcp_ca_find_autoload(struct net *net,
>   						       const char *name)
