Return-Path: <netdev+bounces-8586-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 42ECE724A71
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 19:41:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 57F7A1C20AF8
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 17:40:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B498022D50;
	Tue,  6 Jun 2023 17:40:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A597E19915
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 17:40:56 +0000 (UTC)
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3728010DE
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 10:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1686073254; x=1717609254;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bMq+EmFy2v2LAuDYnDAYK8iO1IVrAxfj1R6hbcueUFw=;
  b=q3Zec5Brs9ORsi1B+nQRD0qL4utx2MUDrVohcXlqgVLGs8ppTSvhLmWn
   FGsCzQfIM3L7QcahxKphXRezovZoTQdjNyQBbryFeKjpV4HjwHQvZ7Nul
   f6V19FxA5hMN8OxNfPUM4GNFVbh6IJvxoItgqy66gZ3bc9BejVgZ+GifX
   I=;
X-IronPort-AV: E=Sophos;i="6.00,221,1681171200"; 
   d="scan'208";a="8543787"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-32fb4f1a.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 17:40:52 +0000
Received: from EX19MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
	by email-inbound-relay-pdx-2b-m6i4x-32fb4f1a.us-west-2.amazon.com (Postfix) with ESMTPS id C6A64C064E;
	Tue,  6 Jun 2023 17:40:51 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 6 Jun 2023 17:40:51 +0000
Received: from 88665a182662.ant.amazon.com (10.187.170.12) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.26;
 Tue, 6 Jun 2023 17:40:49 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <edumazet@google.com>
CC: <davem@davemloft.net>, <eric.dumazet@gmail.com>, <kuba@kernel.org>,
	<netdev@vger.kernel.org>, <pabeni@redhat.com>, <simon.horman@corigine.com>,
	<kuniyu@amazon.com>
Subject: Re: [PATCH v2 net 1/2] rfs: annotate lockless accesses to sk->sk_rxhash
Date: Tue, 6 Jun 2023 10:40:39 -0700
Message-ID: <20230606174039.75356-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230606074115.3789733-2-edumazet@google.com>
References: <20230606074115.3789733-2-edumazet@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.187.170.12]
X-ClientProxiedBy: EX19D045UWC004.ant.amazon.com (10.13.139.203) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Eric Dumazet <edumazet@google.com>
Date: Tue,  6 Jun 2023 07:41:14 +0000
> Add READ_ONCE()/WRITE_ONCE() on accesses to sk->sk_rxhash.
> 
> This also prevents a (smart ?) compiler to remove the condition in:
> 
> if (sk->sk_rxhash != newval)
> 	sk->sk_rxhash = newval;
> 
> We need the condition to avoid dirtying a shared cache line.
> 
> Fixes: fec5e652e58f ("rfs: Receive Flow Steering")
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>

Thank you!


> ---
>  include/net/sock.h | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/include/net/sock.h b/include/net/sock.h
> index b418425d7230c8cee81df34fcc66d771ea5085e9..6f428a7f356755e73852c0e0006f2eb533fc7f57 100644
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
> +		}
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

