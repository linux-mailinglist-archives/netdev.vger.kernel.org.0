Return-Path: <netdev+bounces-1283-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AEE16FD2D3
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 00:54:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 83B371C20C54
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 22:54:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 050EB12B63;
	Tue,  9 May 2023 22:54:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E38961990C
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 22:54:11 +0000 (UTC)
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0EFF468F
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 15:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1683672851; x=1715208851;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=axSqk++nwLeQ0D/XwLY69BPQ/tJXwcda6RGfv3H2UIc=;
  b=HjVw7HANBM/BG3cG5qKD7hovpq7kP5Sg0LXn5uk8PCKmdr+06OvBt93L
   Lld3/yrnRuSAsKBJcyAYwo9r4YK1vTm81YDboJmfudaYvunENg+0CyEVq
   BN6ZpPYmcPZXrGCqlNw/YUeQKErZluBxcKSyKL1ZjG63mLFF2wSovfj9e
   M=;
X-IronPort-AV: E=Sophos;i="5.99,263,1677542400"; 
   d="scan'208";a="212484731"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-3e1fab07.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 22:54:07 +0000
Received: from EX19MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
	by email-inbound-relay-iad-1e-m6i4x-3e1fab07.us-east-1.amazon.com (Postfix) with ESMTPS id 9DDA08630F;
	Tue,  9 May 2023 22:54:04 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 9 May 2023 22:53:50 +0000
Received: from 88665a182662.ant.amazon.com (10.187.171.39) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 9 May 2023 22:53:47 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <edumazet@google.com>
CC: <davem@davemloft.net>, <eric.dumazet@gmail.com>, <kuba@kernel.org>,
	<netdev@vger.kernel.org>, <pabeni@redhat.com>, <syzkaller@googlegroups.com>,
	<kuniyu@amazon.com>
Subject: Re: [PATCH net] net: annotate sk->sk_err write from do_recvmmsg()
Date: Tue, 9 May 2023 15:53:37 -0700
Message-ID: <20230509225337.20900-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230509163553.3081476-1-edumazet@google.com>
References: <20230509163553.3081476-1-edumazet@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.187.171.39]
X-ClientProxiedBy: EX19D042UWB003.ant.amazon.com (10.13.139.135) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
	T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Eric Dumazet <edumazet@google.com>
Date: Tue,  9 May 2023 16:35:53 +0000
> do_recvmmsg() can write to sk->sk_err from multiple threads.
> 
> As said before, many other points reading or writing sk_err
> need annotations.
> 
> Fixes: 34b88a68f26a ("net: Fix use after free in the recvmmsg exit path")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>


> ---
>  net/socket.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/socket.c b/net/socket.c
> index a7b4b37d86df7a9232d582a14863c05b5fd34b68..b7e01d0fe0824d1f277c1fe70f68f09a10319832 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -2911,7 +2911,7 @@ static int do_recvmmsg(int fd, struct mmsghdr __user *mmsg,
>  		 * error to return on the next call or if the
>  		 * app asks about it using getsockopt(SO_ERROR).
>  		 */
> -		sock->sk->sk_err = -err;
> +		WRITE_ONCE(sock->sk->sk_err, -err);
>  	}
>  out_put:
>  	fput_light(sock->file, fput_needed);
> -- 
> 2.40.1.521.gf1e218fcd8-goog

