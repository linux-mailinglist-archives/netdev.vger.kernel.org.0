Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA2DD466E76
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 01:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343611AbhLCAZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 19:25:12 -0500
Received: from smtp-fw-80007.amazon.com ([99.78.197.218]:3295 "EHLO
        smtp-fw-80007.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234586AbhLCAZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 19:25:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1638490907; x=1670026907;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mJZ7M/igJC+sEHH2mjr4iXyHZAIF3CWgjCJ3NvlOPLI=;
  b=E+kNMFbOijrZ5cF746sQ3lwvQYUWWnuitgHpnAaV+BNwJm6UcO+Lsdeo
   IkZlwjZRU8qvOXCSzpspkBKBPFwhJjUzlB8mjlSFcXJ0cOmp8DmEuvG6Z
   VHThPsNhJ0DXtDbIK3wRfYLJEI6Nxj2aGC0vKVSyDg/adMHezNhEFWPv7
   4=;
X-IronPort-AV: E=Sophos;i="5.87,283,1631577600"; 
   d="scan'208";a="45834717"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-02ee77e7.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 03 Dec 2021 00:21:47 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-02ee77e7.us-west-2.amazon.com (Postfix) with ESMTPS id E362541638;
        Fri,  3 Dec 2021 00:21:46 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Fri, 3 Dec 2021 00:21:46 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.154) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Fri, 3 Dec 2021 00:21:42 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <eric.dumazet@gmail.com>
CC:     <daniel@iogearbox.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <kafai@fb.com>, <kuba@kernel.org>,
        <kuniyu@amazon.co.jp>, <netdev@vger.kernel.org>,
        <tariqt@nvidia.com>
Subject: Re: [PATCH net] inet: use #ifdef CONFIG_SOCK_RX_QUEUE_MAPPING consistently
Date:   Fri, 3 Dec 2021 09:21:31 +0900
Message-ID: <20211203002131.14006-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211202224218.269441-1-eric.dumazet@gmail.com>
References: <20211202224218.269441-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.154]
X-ClientProxiedBy: EX13D04UWA003.ant.amazon.com (10.43.160.212) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <eric.dumazet@gmail.com>
Date:   Thu,  2 Dec 2021 14:42:18 -0800
> Since commit 4e1beecc3b58 ("net/sock: Add kernel config
> SOCK_RX_QUEUE_MAPPING"),
> sk_rx_queue_mapping access is guarded by CONFIG_SOCK_RX_QUEUE_MAPPING.
> 
> Fixes: 54b92e841937 ("tcp: Migrate TCP_ESTABLISHED/TCP_SYN_RECV sockets in accept queues.")
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Acked-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>

I missed the commit which was added while I was developing the SO_REUSEPORT
series.

Thank you, Eric!


> Cc: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Cc: Tariq Toukan <tariqt@nvidia.com>
> ---
>  net/ipv4/inet_connection_sock.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index f7fea3a7c5e64b92ca9c6b56293628923649e58c..62a67fdc344cd21505a84c905c1e2c05cc0ff866 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -721,7 +721,7 @@ static struct request_sock *inet_reqsk_clone(struct request_sock *req,
>  
>  	sk_node_init(&nreq_sk->sk_node);
>  	nreq_sk->sk_tx_queue_mapping = req_sk->sk_tx_queue_mapping;
> -#ifdef CONFIG_XPS
> +#ifdef CONFIG_SOCK_RX_QUEUE_MAPPING
>  	nreq_sk->sk_rx_queue_mapping = req_sk->sk_rx_queue_mapping;
>  #endif
>  	nreq_sk->sk_incoming_cpu = req_sk->sk_incoming_cpu;
> -- 
> 2.34.1.400.ga245620fadb-goog
