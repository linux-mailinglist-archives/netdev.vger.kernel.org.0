Return-Path: <netdev+bounces-7570-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C867D720A2D
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 22:21:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 77F87281A9D
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 20:21:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81CA91F186;
	Fri,  2 Jun 2023 20:20:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73EE91F178
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 20:20:58 +0000 (UTC)
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 643DE1B5
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 13:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1685737256; x=1717273256;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Hm3H7cvS7u1N6QbWPE1xdIcPoMFuC5SXqJxjYLSEW0U=;
  b=hxGwOqQFdG1jPaFNQVDTIcMVF8/9qWgpjoby85Ms8IlLBg8Y1QAvHIWT
   NW0oQObiSx4eZzQnmZW+CtugFovze4i5sv6/0kXHo2KjdnrPLq/Itpl/X
   twGu3tsLcP/vKMTN5/psge4L/p/2IQN+1i0z08fp887f6jTO0VyY1regV
   A=;
X-IronPort-AV: E=Sophos;i="6.00,214,1681171200"; 
   d="scan'208";a="343314474"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-1box-2bm6-32cf6363.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 20:20:51 +0000
Received: from EX19MTAUWC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
	by email-inbound-relay-pdx-1box-2bm6-32cf6363.us-west-2.amazon.com (Postfix) with ESMTPS id 0CD8581CC2;
	Fri,  2 Jun 2023 20:20:51 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 2 Jun 2023 20:20:41 +0000
Received: from 88665a182662.ant.amazon.com (10.106.100.9) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 2 Jun 2023 20:20:38 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <edumazet@google.com>
CC: <davem@davemloft.net>, <eric.dumazet@gmail.com>, <kuba@kernel.org>,
	<netdev@vger.kernel.org>, <pabeni@redhat.com>, <kuniyu@amazon.com>
Subject: Re: [PATCH net 1/2] rfs: annotate lockless accesses to sk->sk_rxhash
Date: Fri, 2 Jun 2023 13:20:28 -0700
Message-ID: <20230602202028.49984-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230602163141.2115187-2-edumazet@google.com>
References: <20230602163141.2115187-2-edumazet@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.100.9]
X-ClientProxiedBy: EX19D040UWA001.ant.amazon.com (10.13.139.22) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Eric Dumazet <edumazet@google.com>
Date: Fri,  2 Jun 2023 16:31:40 +0000
> Add READ_ONCE()/WRITE_ONCE() on accesses to sk->sk_rxhash.
> 
> This also prevents a (smart ?) compiler to remove the condition in:
> 
> if (sk->sk_rxhash != newval)
> 	sk->sk_rxhash = newval;
> 
> We need the condition to avoid dirtying a shared cache line.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  include/net/sock.h | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/include/net/sock.h b/include/net/sock.h
> index b418425d7230c8cee81df34fcc66d771ea5085e9..bf71855d47feccda716b3cabf259d6055b764a3c 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -1152,8 +1152,12 @@ static inline void sock_rps_record_flow(const struct sock *sk)
>  		 * OR	an additional socket flag
>  		 * [1] : sk_state and sk_prot are in the same cache line.
>  		 */
> -		if (sk->sk_state == TCP_ESTABLISHED)
> -			sock_rps_record_flow_hash(sk->sk_rxhash);
> +		if (sk->sk_state == TCP_ESTABLISHED) {
> +			/* This READ_ONCE() is paired with the WRITE_ONCE()
> +			 * from sock_rps_save_rxhash() and sock_rps_reset_rxhash().
> +			 */
> +			sock_rps_record_flow_hash(READ_ONCE(sk->sk_rxhash));
> +			}

nit: unnecessary \t here

other than that

Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>

Thanks!

>  	}
>  #endif
>  }
> @@ -1162,15 +1166,19 @@ static inline void sock_rps_save_rxhash(struct sock *sk,
>  					const struct sk_buff *skb)
>  {
>  #ifdef CONFIG_RPS
> -	if (unlikely(sk->sk_rxhash != skb->hash))
> -		sk->sk_rxhash = skb->hash;
> +	/* The following WRITE_ONCE() is paired with the READ_ONCE()
> +	 * here, and another one in sock_rps_record_flow().
> +	 */
> +	if (unlikely(READ_ONCE(sk->sk_rxhash) != skb->hash))
> +		WRITE_ONCE(sk->sk_rxhash, skb->hash);
>  #endif
>  }
>  
>  static inline void sock_rps_reset_rxhash(struct sock *sk)
>  {
>  #ifdef CONFIG_RPS
> -	sk->sk_rxhash = 0;
> +	/* Paired with READ_ONCE() in sock_rps_record_flow() */
> +	WRITE_ONCE(sk->sk_rxhash, 0);
>  #endif
>  }
>  
> -- 
> 2.41.0.rc0.172.g3f132b7071-goog

