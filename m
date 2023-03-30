Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 105776D084D
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 16:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232498AbjC3O20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 10:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232086AbjC3O2V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 10:28:21 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C95FCA3F;
        Thu, 30 Mar 2023 07:28:13 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id n14so18574804qta.10;
        Thu, 30 Mar 2023 07:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680186492; x=1682778492;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1KLboLDFLFzlinaqIOWtCd3jSre3IkygbzwNJevdg7c=;
        b=Q9QTrHcqxShw4kQSVsdfF/J/Go0nb9iN1YwIbz6HNb7Sxc0w95lSr2ncpeaD61mPDI
         6/iUOOs200KePJ0wKlb4M0HsgYFO6bk1ba9BMFooPfKHlFvV5FxXHFHn4jbtJhN2ZZV9
         Ml0RZxBNONkwjOjmRz6Vt75KrAuUjB6UsgkDSwhDtNMc0en16xY3h3VVwF1W+tgefbqF
         KKtv6OMeQbP6KFA56uqnyY7UGml9LSp0O5bG/av1iyJDhBjhHdlj/K2Trily5Uzi6tIm
         Sx0lPExcInJ53U/wyRVWjTwHp7gbYjF1ay8/WW3NgcYWvsnCspt5hdljPXZG8wxNJcZL
         w2DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680186492; x=1682778492;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1KLboLDFLFzlinaqIOWtCd3jSre3IkygbzwNJevdg7c=;
        b=jFfhFwJDkJosqhFtA9wSN0gwx9ZbJS+EXIsRX+wgI8tko+y+VL6woVJ6paQnd/wnMP
         NrB0/JcocYSocFlvqDja3S+SIXg4RduIA/lm39ZYUxkGu9tIqBLTqofrwtr30EmX2cCq
         uEpMZfQ1Bna47ZTeC9TDj/BzPTabAuFg4pI21rGbsm38bd8Qc4KSPdCNRS4OYLm2LWEc
         4Sc18V2wBGJ90ib76F+DE/JSVc/iMVlewtfyxBhgStxJvPXQ0kYGgYZS7ajCd/iKkjGN
         2eQE9drJyKr8FQgAiHu4UdyukpXC7nx+bCGUDEvGPisZxafDMVjY9DFHxDvaBlObP/yg
         m4Xw==
X-Gm-Message-State: AO0yUKX0TDKDXNz8I3bxhDeVUKHz9+/JA3A3u7e4/q1B3ie5cqZech09
        Kwp7eQwroDaweYHGZgVSrpY=
X-Google-Smtp-Source: AK7set8e8WQk4TNn0PFFyPcyzGMxTO7qRHPU2IQ/nKsQX3YoS0JabNwGhzLrLgYoxvq+OUII8mhZeA==
X-Received: by 2002:ac8:57c2:0:b0:3dc:38e:8b7 with SMTP id w2-20020ac857c2000000b003dc038e08b7mr38360724qta.2.1680186492069;
        Thu, 30 Mar 2023 07:28:12 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id w2-20020ac87182000000b003b9a6d54b6csm16932858qto.59.2023.03.30.07.28.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 07:28:11 -0700 (PDT)
Date:   Thu, 30 Mar 2023 10:28:11 -0400
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
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Message-ID: <64259c7b2b327_21883920818@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230329141354.516864-5-dhowells@redhat.com>
References: <20230329141354.516864-1-dhowells@redhat.com>
 <20230329141354.516864-5-dhowells@redhat.com>
Subject: RE: [RFC PATCH v2 04/48] net: Declare MSG_SPLICE_PAGES internal
 sendmsg() flag
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Howells wrote:
> Declare MSG_SPLICE_PAGES, an internal sendmsg() flag, that hints to a
> network protocol that it should splice pages from the source iterator
> rather than copying the data if it can.  This flag is added to a list that
> is cleared by sendmsg and recvmsg syscalls on entry.
> 
> This is intended as a replacement for the ->sendpage() op, allowing a way
> to splice in several multipage folios in one go.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> cc: "David S. Miller" <davem@davemloft.net>
> cc: Eric Dumazet <edumazet@google.com>
> cc: Jakub Kicinski <kuba@kernel.org>
> cc: Paolo Abeni <pabeni@redhat.com>
> cc: Jens Axboe <axboe@kernel.dk>
> cc: Matthew Wilcox <willy@infradead.org>
> cc: netdev@vger.kernel.org
> ---
>  include/linux/socket.h | 3 +++
>  net/socket.c           | 7 +++++++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/include/linux/socket.h b/include/linux/socket.h
> index 13c3a237b9c9..c2fa0f800999 100644
> --- a/include/linux/socket.h
> +++ b/include/linux/socket.h
> @@ -327,6 +327,7 @@ struct ucred {
>  					  */
>  
>  #define MSG_ZEROCOPY	0x4000000	/* Use user data in kernel path */
> +#define MSG_SPLICE_PAGES 0x8000000	/* Splice the pages from the iterator in sendmsg() */
>  #define MSG_FASTOPEN	0x20000000	/* Send data in TCP SYN */
>  #define MSG_CMSG_CLOEXEC 0x40000000	/* Set close_on_exec for file
>  					   descriptor received through
> @@ -337,6 +338,8 @@ struct ucred {
>  #define MSG_CMSG_COMPAT	0		/* We never have 32 bit fixups */
>  #endif
>  
> +/* Flags to be cleared on entry by sendmsg, recvmsg, sendmmsg and recvmmsg syscalls */
> +#define MSG_INTERNAL_FLAGS (MSG_SPLICE_PAGES)

This is fine, but there is no real need to cover both send and receive.

The sendpage internal flags only ensure that those flags cannot enter sendpage
code from any unintentional path. Indeed those "internal" flags can end up in
sendmsg, at least for UDP.

Similarly, this flag set only has to protect sendto and sendmsg. That
can simplify the patch a bit.
 
>  /* Setsockoptions(2) level. Thanks to BSD these must match IPPROTO_xxx */
>  #define SOL_IP		0
> diff --git a/net/socket.c b/net/socket.c
> index 6bae8ce7059e..dfb912bbed62 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -2139,6 +2139,7 @@ int __sys_sendto(int fd, void __user *buff, size_t len, unsigned int flags,
>  		msg.msg_name = (struct sockaddr *)&address;
>  		msg.msg_namelen = addr_len;
>  	}
> +	flags &= ~MSG_INTERNAL_FLAGS;
>  	if (sock->file->f_flags & O_NONBLOCK)
>  		flags |= MSG_DONTWAIT;
>  	msg.msg_flags = flags;
> @@ -2192,6 +2193,7 @@ int __sys_recvfrom(int fd, void __user *ubuf, size_t size, unsigned int flags,
>  	if (!sock)
>  		goto out;
>  
> +	flags &= ~MSG_INTERNAL_FLAGS;
>  	if (sock->file->f_flags & O_NONBLOCK)
>  		flags |= MSG_DONTWAIT;
>  	err = sock_recvmsg(sock, &msg, flags);
> @@ -2579,6 +2581,7 @@ long __sys_sendmsg(int fd, struct user_msghdr __user *msg, unsigned int flags,
>  
>  	if (forbid_cmsg_compat && (flags & MSG_CMSG_COMPAT))
>  		return -EINVAL;
> +	flags &= ~MSG_INTERNAL_FLAGS;
>  
>  	sock = sockfd_lookup_light(fd, &err, &fput_needed);
>  	if (!sock)
> @@ -2627,6 +2630,7 @@ int __sys_sendmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
>  	entry = mmsg;
>  	compat_entry = (struct compat_mmsghdr __user *)mmsg;
>  	err = 0;
> +	flags &= ~MSG_INTERNAL_FLAGS;
>  	flags |= MSG_BATCH;
>

No need to modify __sys_sendmmsg explicitly, as it ends up calling
__sys_sendmsg?

Also, sendpage does this flags masking in the internal sock_FUNC
helpers rather than __sys_FUNC. Might be preferable.

>  	while (datagrams < vlen) {
> @@ -2775,6 +2779,7 @@ long __sys_recvmsg_sock(struct socket *sock, struct msghdr *msg,
>  			struct user_msghdr __user *umsg,
>  			struct sockaddr __user *uaddr, unsigned int flags)
>  {
> +	flags &= ~MSG_INTERNAL_FLAGS;
>  	return ____sys_recvmsg(sock, msg, umsg, uaddr, flags, 0);
>  }
>  
> @@ -2787,6 +2792,7 @@ long __sys_recvmsg(int fd, struct user_msghdr __user *msg, unsigned int flags,
>  
>  	if (forbid_cmsg_compat && (flags & MSG_CMSG_COMPAT))
>  		return -EINVAL;
> +	flags &= ~MSG_INTERNAL_FLAGS;
>  
>  	sock = sockfd_lookup_light(fd, &err, &fput_needed);
>  	if (!sock)
> @@ -2839,6 +2845,7 @@ static int do_recvmmsg(int fd, struct mmsghdr __user *mmsg,
>  			goto out_put;
>  		}
>  	}
> +	flags &= ~MSG_INTERNAL_FLAGS;
>  
>  	entry = mmsg;
>  	compat_entry = (struct compat_mmsghdr __user *)mmsg;
> 


