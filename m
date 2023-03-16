Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFB606BD83A
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 19:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbjCPShF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 14:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjCPShE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 14:37:04 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F363B32A5;
        Thu, 16 Mar 2023 11:37:03 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id c18so2849142qte.5;
        Thu, 16 Mar 2023 11:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678991822;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5yHp4jREjQWsbctCYQ1reY9QDPf2OVmLm7z44LvG+Sc=;
        b=UiJyRovNvybmojhj6CL+YSVtnvvEuY1cQ6QWsePLs0WPo7YG0uIrkqZ2SmyUtAFfCD
         4lCpZF19u/SwFeuYGg8eaj19uKLxl5ij7W0+GBhutb6Il2sSUS0iUZok2BHLOHmEiZ3l
         d/6WzPc4WDllIYoi1nHAi1rwfpEgYEOUttx3e+0oP1u/r5qmvflhWl+zySaI4Uwg3bWJ
         06xS5Kg1whSXqkDgW/O5xgTEkUfxosJJFo9qikUjRVnZnm6SAeBRt2Gx5/izsyJTz93g
         Jbab2mzAPm0nSbRnno+mRX+6votuVVY+kfAIIdslubgylyz60wpjL5Y757fGjE0N0biu
         IKGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678991822;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5yHp4jREjQWsbctCYQ1reY9QDPf2OVmLm7z44LvG+Sc=;
        b=Nt+rq9gOhyN8M2RnfBkaZPcJ8sF2vB172jstOti0tCNwXUEMn9Td68GfCOacWaa9vB
         NZf+bmfFDHrLLiOnBucRHeZvoor/UdNezJbS26xIvJL1dCAbmIhew9S4bt+NGJmVre87
         DDAuZvWOZqfCPVbaodNumo6HXG71MsNK10uirncmXX2iGT4tyWw+Kc1QkGGIhcdQZb3u
         7cXe8LT494/HtQInFUQhK/wAoVLJ+SgqVhtprA5FtrEU6vapOuLcp8vJif0AhoVo6F3G
         iAyqQ5IbDAgqpaep/8UXM+QhJrg5Dva/E854jf+oU7jBR79BYmQOLCyeven08mDuyHCn
         cirg==
X-Gm-Message-State: AO0yUKUJEnDgfT+TOBB2ZJo9Pw4rFW+Cpj5TLLmFBW4heOwFW+bnJJA+
        +qQ2NsergmH3xVbpwjQBDjs=
X-Google-Smtp-Source: AK7set89m0NxgI0Dr4tvwq/CeeXie8ta0Jwg+0yZvAdMSGDc1GAqO0zueLl2XM2RZ4hYiuKSDlAdVg==
X-Received: by 2002:ac8:5dd4:0:b0:3b6:3995:2ec2 with SMTP id e20-20020ac85dd4000000b003b639952ec2mr8002266qtx.19.1678991822174;
        Thu, 16 Mar 2023 11:37:02 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id j8-20020ac85c48000000b003bf9f9f1844sm6299599qtj.71.2023.03.16.11.37.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 11:37:01 -0700 (PDT)
Date:   Thu, 16 Mar 2023 14:37:01 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     David Howells <dhowells@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Message-ID: <641361cd8d704_33b0cc20823@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230316152618.711970-4-dhowells@redhat.com>
References: <20230316152618.711970-1-dhowells@redhat.com>
 <20230316152618.711970-4-dhowells@redhat.com>
Subject: RE: [RFC PATCH 03/28] tcp: Support MSG_SPLICE_PAGES
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Howells wrote:
> Make TCP's sendmsg() support MSG_SPLICE_PAGES.  This causes pages to be
> spliced from the source iterator if possible (the iterator must be
> ITER_BVEC and the pages must be spliceable).
> 
> This allows ->sendpage() to be replaced by something that can handle
> multiple multipage folios in a single transaction.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Eric Dumazet <edumazet@google.com>
> cc: "David S. Miller" <davem@davemloft.net>
> cc: Jakub Kicinski <kuba@kernel.org>
> cc: Paolo Abeni <pabeni@redhat.com>
> cc: Jens Axboe <axboe@kernel.dk>
> cc: Matthew Wilcox <willy@infradead.org>
> cc: netdev@vger.kernel.org
> ---
>  net/ipv4/tcp.c | 59 +++++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 53 insertions(+), 6 deletions(-)
> 
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 288693981b00..77c0c69208a5 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -1220,7 +1220,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>  	int flags, err, copied = 0;
>  	int mss_now = 0, size_goal, copied_syn = 0;
>  	int process_backlog = 0;
> -	bool zc = false;
> +	int zc = 0;
>  	long timeo;
>  
>  	flags = msg->msg_flags;
> @@ -1231,17 +1231,24 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>  		if (msg->msg_ubuf) {
>  			uarg = msg->msg_ubuf;
>  			net_zcopy_get(uarg);
> -			zc = sk->sk_route_caps & NETIF_F_SG;
> +			if (sk->sk_route_caps & NETIF_F_SG)
> +				zc = 1;
>  		} else if (sock_flag(sk, SOCK_ZEROCOPY)) {
>  			uarg = msg_zerocopy_realloc(sk, size, skb_zcopy(skb));
>  			if (!uarg) {
>  				err = -ENOBUFS;
>  				goto out_err;
>  			}
> -			zc = sk->sk_route_caps & NETIF_F_SG;
> -			if (!zc)
> +			if (sk->sk_route_caps & NETIF_F_SG)
> +				zc = 1;
> +			else
>  				uarg_to_msgzc(uarg)->zerocopy = 0;
>  		}
> +	} else if (unlikely(flags & MSG_SPLICE_PAGES) && size) {
> +		if (!iov_iter_is_bvec(&msg->msg_iter))
> +			return -EINVAL;
> +		if (sk->sk_route_caps & NETIF_F_SG)
> +			zc = 2;
>  	}

The commit message mentions MSG_SPLICE_PAGES as an internal flag.

It can be passed from userspace. The code anticipates that and checks
preconditions.

A side effect is that legacy applications that may already be setting
this bit in the flags now start failing. Most socket types are
historically permissive and simply ignore undefined flags.

With MSG_ZEROCOPY we chose to be extra cautious and added
SOCK_ZEROCOPY, only testing the MSG_ZEROCOPY bit if this socket option
is explicitly enabled. Perhaps more cautious than necessary, but FYI.
