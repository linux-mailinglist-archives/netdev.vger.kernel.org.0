Return-Path: <netdev+bounces-11783-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EB6D734720
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 18:54:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1147C1C20947
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 16:54:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CF4263BE;
	Sun, 18 Jun 2023 16:54:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A225226;
	Sun, 18 Jun 2023 16:54:43 +0000 (UTC)
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD2610B;
	Sun, 18 Jun 2023 09:54:41 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id af79cd13be357-76344f8140dso23198385a.3;
        Sun, 18 Jun 2023 09:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687107281; x=1689699281;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4sK61SVjYCcgummf/cy7pNsLb9SbPBeqU0f1FYDFMyI=;
        b=rY8QSvEl6p4fIeB+cNXrfBx3Qi8Q0oRZm5VoS2BoCgfjuYRQQUwrdFGEDdU23IrXo0
         chGoGHKPwP0LXmrfTl3qHlcCmo1sRYapzINEnQSow+fzi+pFn5PGiApYOrJ50HKaB68T
         utE+yg2GnzRQ30Bj8a8L69p3c374+UtcDkNfJR34GIn05f0b7+0AmEbyApvKm1DNJWT/
         bJcRj7sz29ir/3TzVW+gzb/qTkz7VnAPSgi9enEEZ3+K74hSxYqhdeSEvqiAsjKKoCqT
         OzoP6N5BMK7b0x2JfdgrfrTiD4DoK57jW0lPFco02d1KYyD6s/pMa/qc2P6IX40592qx
         JtnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687107281; x=1689699281;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4sK61SVjYCcgummf/cy7pNsLb9SbPBeqU0f1FYDFMyI=;
        b=PvJr6nOajjEg6nBWopPUvyV3lClFlhSHKoj82QChhFMt5m0zUes7J2L5PDvWmtiU3f
         Tkv7uvyfCLXXiQ9UPnBzG/c6gN5imTqXeq9eqnmsEbpxASViHl5pamiWZ0b7bpDy2N6Y
         fcJUj1N5qzG+TiD8kZVzEMYgLTHHhkDjpw7BR1RZFfxEgoS8HpnUf10BLt0IUKVKR3G7
         0kR/tp/e+qFdY9jwf4y2q2Pv5xkb6q7bwXujC6jzKuS7YBTEiz7t7roz6cNe1O24RMDL
         +MaqHuMQhHqZqG7iQqUsM5DAz5ENn/nqB8rnM4cj0NgZp94pX3zzfjSfOmAJSRD0fvoE
         wT8A==
X-Gm-Message-State: AC+VfDwwVj5h13DIgF4ld/PJoPOX85Y7FxEt4vVz5VMfxDa5ThP1KLpo
	AfAazsDXyLUe6K6DxIRLknI=
X-Google-Smtp-Source: ACHHUZ7rD2n8b5vnYB/xOzS5BAQNWYuxXJrQo4BmBND6gWZP6jCAnPQahStFSM7LauZ1ZKr4AefxaQ==
X-Received: by 2002:ad4:5be2:0:b0:626:33bb:3fd3 with SMTP id k2-20020ad45be2000000b0062633bb3fd3mr8290593qvc.19.1687107280821;
        Sun, 18 Jun 2023 09:54:40 -0700 (PDT)
Received: from localhost (172.174.245.35.bc.googleusercontent.com. [35.245.174.172])
        by smtp.gmail.com with ESMTPSA id t3-20020ac85303000000b003f7a54fa72fsm1857340qtn.0.2023.06.18.09.54.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Jun 2023 09:54:40 -0700 (PDT)
Date: Sun, 18 Jun 2023 12:54:40 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: David Howells <dhowells@redhat.com>, 
 netdev@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>, 
 Alexander Duyck <alexander.duyck@gmail.com>, 
 "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, 
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
 David Ahern <dsahern@kernel.org>, 
 Matthew Wilcox <willy@infradead.org>, 
 Jens Axboe <axboe@kernel.dk>, 
 linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, 
 dccp@vger.kernel.org, 
 linux-afs@lists.infradead.org, 
 linux-arm-msm@vger.kernel.org, 
 linux-can@vger.kernel.org, 
 linux-crypto@vger.kernel.org, 
 linux-doc@vger.kernel.org, 
 linux-hams@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, 
 linux-rdma@vger.kernel.org, 
 linux-sctp@vger.kernel.org, 
 linux-wpan@vger.kernel.org, 
 linux-x25@vger.kernel.org, 
 mptcp@lists.linux.dev, 
 rds-devel@oss.oracle.com, 
 tipc-discussion@lists.sourceforge.net, 
 virtualization@lists.linux-foundation.org
Message-ID: <648f36d02fe6e_33cfbc2944f@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230617121146.716077-18-dhowells@redhat.com>
References: <20230617121146.716077-1-dhowells@redhat.com>
 <20230617121146.716077-18-dhowells@redhat.com>
Subject: RE: [PATCH net-next v2 17/17] net: Kill MSG_SENDPAGE_NOTLAST
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

David Howells wrote:
> Now that ->sendpage() has been removed, MSG_SENDPAGE_NOTLAST can be cleaned
> up.  Things were converted to use MSG_MORE instead, but the protocol
> sendpage stubs still convert MSG_SENDPAGE_NOTLAST to MSG_MORE, which is now
> unnecessary.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: "David S. Miller" <davem@davemloft.net>
> cc: Eric Dumazet <edumazet@google.com>
> cc: Jakub Kicinski <kuba@kernel.org>
> cc: Paolo Abeni <pabeni@redhat.com>
> cc: Jens Axboe <axboe@kernel.dk>
> cc: Matthew Wilcox <willy@infradead.org>
> cc: bpf@vger.kernel.org
> cc: dccp@vger.kernel.org
> cc: linux-afs@lists.infradead.org
> cc: linux-arm-msm@vger.kernel.org
> cc: linux-can@vger.kernel.org
> cc: linux-crypto@vger.kernel.org
> cc: linux-doc@vger.kernel.org
> cc: linux-hams@vger.kernel.org
> cc: linux-perf-users@vger.kernel.org
> cc: linux-rdma@vger.kernel.org
> cc: linux-sctp@vger.kernel.org
> cc: linux-wpan@vger.kernel.org
> cc: linux-x25@vger.kernel.org
> cc: mptcp@lists.linux.dev
> cc: netdev@vger.kernel.org
> cc: rds-devel@oss.oracle.com
> cc: tipc-discussion@lists.sourceforge.net
> cc: virtualization@lists.linux-foundation.org
> ---
>  include/linux/socket.h                         | 4 +---
>  net/ipv4/tcp_bpf.c                             | 4 +++-
>  net/tls/tls_device.c                           | 3 +--
>  net/tls/tls_main.c                             | 2 +-
>  net/tls/tls_sw.c                               | 2 +-
>  tools/perf/trace/beauty/include/linux/socket.h | 1 -
>  tools/perf/trace/beauty/msg_flags.c            | 3 ---
>  7 files changed, 7 insertions(+), 12 deletions(-)
>
 
> @@ -90,7 +90,9 @@ static int tcp_bpf_push(struct sock *sk, struct sk_msg *msg, u32 apply_bytes,
>  {
>  	bool apply = apply_bytes;
>  	struct scatterlist *sge;
> -	struct msghdr msghdr = { .msg_flags = flags | MSG_SPLICE_PAGES, };
> +	struct msghdr msghdr = {
> +		.msg_flags = flags | MSG_SPLICE_PAGES | MSG_MORE,
> +	};
>  	struct page *page;
>  	int size, ret = 0;
>  	u32 off;

Is it intentional to add MSG_MORE here in this patch?

I do see that patch 3 removes this branch:

@@ -111,9 +111,6 @@  static int tcp_bpf_push(struct sock *sk, struct sk_msg *msg, u32 apply_bytes,
 		if (has_tx_ulp)
 			msghdr.msg_flags |= MSG_SENDPAGE_NOPOLICY;
 
-		if (flags & MSG_SENDPAGE_NOTLAST)
-			msghdr.msg_flags |= MSG_MORE;
-

