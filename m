Return-Path: <netdev+bounces-6698-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 33310717777
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 09:02:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E2EA1C20D9D
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 07:02:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 524129454;
	Wed, 31 May 2023 07:02:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF21748C
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 07:02:11 +0000 (UTC)
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 879C1191;
	Wed, 31 May 2023 00:01:58 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id 6a1803df08f44-5ed99ebe076so55841106d6.2;
        Wed, 31 May 2023 00:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685516517; x=1688108517;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ELdaPHSVBw6JCbG+jxG73XXuerCHgPKjbl6y/4YP3Zg=;
        b=mzAIntpbF35YCT4YLPKeHLc94zJHA1TNesOHzdo0Ov+90qkl1H9nvVHQFDUALIhE2x
         O17mKp0B5lrKhqw75Nuw4TJanLrOvLNknoeIfU4oHOdGEpqzp4ubZVMu4E4mY7zTOvJG
         RH+wBaSj10aLU0XL9jfnBnDtoHnbNj6QiBAKqX8DRUidrqKoFlJAH6lCFDb+yjZVGBG2
         qhSh2n7nH/EtgxDSY3oTEXlNEYUQ8+KVIxpiMjWh3xODCtev5gakqLVMwiKhqjEz20F2
         6XjeNXGF6EC0iAG2+3pjLIi3sY7MkDszp+pcZT7sktQtebPwbyB0UTbSJvNd1qTeBJG9
         rNLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685516517; x=1688108517;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ELdaPHSVBw6JCbG+jxG73XXuerCHgPKjbl6y/4YP3Zg=;
        b=fKdPVHmVRJar87rTH92Ypfpwotu+WIleVmBXpyWhfSd5KJ/l3zcUebqnVRLSrqT6K1
         IE2gm9+4f8wyu8vL2P/b3ULGW4GYRSFf9yP+uCJWQttNsBSlfghFw31cHzIfz3hFSY0f
         KH15vZ1RR2z/GXf604pWStBs16X2Tn0usCtZs1e+EMFHVPT4ap0Zr5ZjFxSnXr45GtOU
         owJ838uxueNMErw7/tQoqqRBCsNJ5By0pqF35fukg4a7eNLTlU6pKuRujZ3y8Gq2TJ8x
         VlWDi9lIbVIew0axJGrdAaL2+umHDTQZui+URVWfvhE3Ace16OEyK9MoV6Z+XzwG+bmc
         CXBw==
X-Gm-Message-State: AC+VfDxldv2G9UTh7gGJWzBYWYTh7olyKQpg7ejipSF+oKcF+D/dZJC+
	/Thnz+4AvOHAs5DrwSa83zo=
X-Google-Smtp-Source: ACHHUZ5Cwq52/xdLHo2zn3P8yk51xmiASh4vjPC17VV1SvYgJcxk46dgO1DZqECHh9UAKH2HdKw0Bg==
X-Received: by 2002:a05:6214:1c09:b0:625:aa49:9abb with SMTP id u9-20020a0562141c0900b00625aa499abbmr5372905qvc.63.1685516517432;
        Wed, 31 May 2023 00:01:57 -0700 (PDT)
Received: from localhost (172.174.245.35.bc.googleusercontent.com. [35.245.174.172])
        by smtp.gmail.com with ESMTPSA id n4-20020a0cfbc4000000b006211a5495adsm3194049qvp.75.2023.05.31.00.01.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 00:01:56 -0700 (PDT)
Date: Wed, 31 May 2023 03:01:56 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Breno Leitao <leitao@debian.org>, 
 dsahern@kernel.org, 
 willemdebruijn.kernel@gmail.com, 
 Remi Denis-Courmont <courmisch@gmail.com>, 
 "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, 
 Alexander Aring <alex.aring@gmail.com>, 
 Stefan Schmidt <stefan@datenfreihafen.org>, 
 Miquel Raynal <miquel.raynal@bootlin.com>, 
 Matthieu Baerts <matthieu.baerts@tessares.net>, 
 Mat Martineau <martineau@kernel.org>, 
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
 Xin Long <lucien.xin@gmail.com>
Cc: leit@fb.com, 
 axboe@kernel.dk, 
 asml.silence@gmail.com, 
 linux-kernel@vger.kernel.org, 
 netdev@vger.kernel.org, 
 dccp@vger.kernel.org, 
 linux-wpan@vger.kernel.org, 
 mptcp@lists.linux.dev, 
 linux-sctp@vger.kernel.org
Message-ID: <6476f0e4b0182_3c8862294b2@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230530175403.2434218-1-leitao@debian.org>
References: <20230530175403.2434218-1-leitao@debian.org>
Subject: RE: [PATCH net-next v4] net: ioctl: Use kernel memory on protocol
 ioctl callbacks
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

Breno Leitao wrote:
> Most of the ioctls to net protocols operates directly on userspace
> argument (arg). Usually doing get_user()/put_user() directly in the
> ioctl callback.  This is not flexible, because it is hard to reuse these
> functions without passing userspace buffers.
> 
> Change the "struct proto" ioctls to avoid touching userspace memory and
> operate on kernel buffers, i.e., all protocol's ioctl callbacks is
> adapted to operate on a kernel memory other than on userspace (so, no
> more {put,get}_user() and friends being called in the ioctl callback).
> 
> This changes the "struct proto" ioctl format in the following way:
> 
>     int                     (*ioctl)(struct sock *sk, int cmd,
> -                                        unsigned long arg);
> +                                        int *karg);
> 
> So, the "karg" argument, which is passed to the ioctl callback, is a
> pointer allocated to kernel space memory (inside a function wrapper).
> This buffer (karg) may contain input argument (copied from userspace in
> a prep function) and it might return a value/buffer, which is copied
> back to userspace if necessary. There is not one-size-fits-all format
> (that is I am using 'may' above), but basically, there are three type of
> ioctls:
> 
> 1) Do not read from userspace, returns a result to userspace
> 2) Read an input parameter from userspace, and does not return anything
>   to userspace
> 3) Read an input from userspace, and return a buffer to userspace.
> 
> The default case (1) (where no input parameter is given, and an "int" is
> returned to userspace) encompasses more than 90% of the cases, but there
> are two other exceptions. Here is a list of exceptions:
> 
> * Protocol RAW:
>    * cmd = SIOCGETVIFCNT:
>      * input and output = struct sioc_vif_req
>    * cmd = SIOCGETSGCNT
>      * input and output = struct sioc_sg_req
>    * Explanation: for the SIOCGETVIFCNT case, userspace passes the input
>      argument, which is struct sioc_vif_req. Then the callback populates
>      the struct, which is copied back to userspace.
> 
> * Protocol RAW6:
>    * cmd = SIOCGETMIFCNT_IN6
>      * input and output = struct sioc_mif_req6
>    * cmd = SIOCGETSGCNT_IN6
>      * input and output = struct sioc_sg_req6
> 
> * Protocol PHONET:
>   * cmd == SIOCPNADDRESOURCE | SIOCPNDELRESOURCE
>      * input int (4 bytes)
>   * Nothing is copied back to userspace.
> 
> For the exception cases, functions sock_sk_ioctl_inout() will
> copy the userspace input, and copy it back to kernel space.
> 
> The wrapper that prepare the buffer and put the buffer back to user is
> sk_ioctl(), so, instead of calling sk->sk_prot->ioctl(), the callee now
> calls sk_ioctl(), which will handle all cases.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  include/linux/mroute.h      | 21 ++++++++++--
>  include/linux/mroute6.h     | 18 +++++++++--
>  include/net/phonet/phonet.h | 20 ++++++++++++
>  include/net/sock.h          |  5 ++-
>  include/net/tcp.h           |  2 +-
>  include/net/udp.h           |  2 +-
>  net/core/sock.c             | 63 ++++++++++++++++++++++++++++++++++++
>  net/dccp/dccp.h             |  2 +-
>  net/dccp/proto.c            | 12 +++----
>  net/ieee802154/socket.c     | 15 ++++-----
>  net/ipv4/af_inet.c          |  2 +-
>  net/ipv4/ipmr.c             | 63 ++++++++++++++++++++++--------------
>  net/ipv4/raw.c              | 16 +++++-----
>  net/ipv4/tcp.c              |  5 +--
>  net/ipv4/udp.c              | 12 +++----
>  net/ipv6/af_inet6.c         |  2 +-
>  net/ipv6/ip6mr.c            | 64 ++++++++++++++++++++++---------------
>  net/ipv6/raw.c              | 16 +++++-----
>  net/l2tp/l2tp_core.h        |  2 +-
>  net/l2tp/l2tp_ip.c          |  9 +++---
>  net/mptcp/protocol.c        | 11 +++----
>  net/phonet/datagram.c       | 11 +++----
>  net/phonet/pep.c            | 11 +++----
>  net/phonet/socket.c         |  2 +-
>  net/sctp/socket.c           |  8 ++---
>  25 files changed, 265 insertions(+), 129 deletions(-)
> 
> diff --git a/include/linux/mroute.h b/include/linux/mroute.h
> index 80b8400ab8b2..5e6787f700db 100644
> --- a/include/linux/mroute.h
> +++ b/include/linux/mroute.h
> @@ -16,12 +16,19 @@ static inline int ip_mroute_opt(int opt)
>  	return opt >= MRT_BASE && opt <= MRT_MAX;
>  }
>  
> +static inline int sk_is_ipmr(struct sock *sk)
> +{
> +	return sk->sk_family == AF_INET &&
> +		inet_sk(sk)->inet_num == IPPROTO_IGMP;
> +}
> +
>  int ip_mroute_setsockopt(struct sock *, int, sockptr_t, unsigned int);
>  int ip_mroute_getsockopt(struct sock *, int, sockptr_t, sockptr_t);
> -int ipmr_ioctl(struct sock *sk, int cmd, void __user *arg);
> +int ipmr_ioctl(struct sock *sk, int cmd, void *arg);
>  int ipmr_compat_ioctl(struct sock *sk, unsigned int cmd, void __user *arg);
>  int ip_mr_init(void);
>  bool ipmr_rule_default(const struct fib_rule *rule);
> +int ipmr_sk_ioctl(struct sock *sk, unsigned int cmd, void __user *arg);
>  #else
>  static inline int ip_mroute_setsockopt(struct sock *sock, int optname,
>  				       sockptr_t optval, unsigned int optlen)
> @@ -35,7 +42,7 @@ static inline int ip_mroute_getsockopt(struct sock *sk, int optname,
>  	return -ENOPROTOOPT;
>  }
>  
> -static inline int ipmr_ioctl(struct sock *sk, int cmd, void __user *arg)
> +static inline int ipmr_ioctl(struct sock *sk, int cmd, void *arg)
>  {
>  	return -ENOIOCTLCMD;
>  }
> @@ -50,10 +57,20 @@ static inline int ip_mroute_opt(int opt)
>  	return 0;
>  }
>  
> +static inline int sk_is_ipmr(struct sock *sk)
> +{
> +	return 0;
> +}
> +
>  static inline bool ipmr_rule_default(const struct fib_rule *rule)
>  {
>  	return true;
>  }
> +
> +static inline int ipmr_sk_ioctl(struct sock *sk, unsigned int cmd, void __user *arg)
> +{
> +	return 1;
> +}
>  #endif
>  
>  #define VIFF_STATIC 0x8000
> diff --git a/include/linux/mroute6.h b/include/linux/mroute6.h
> index 8f2b307fb124..d9095d83968c 100644
> --- a/include/linux/mroute6.h
> +++ b/include/linux/mroute6.h
> @@ -29,7 +29,7 @@ struct sock;
>  extern int ip6_mroute_setsockopt(struct sock *, int, sockptr_t, unsigned int);
>  extern int ip6_mroute_getsockopt(struct sock *, int, sockptr_t, sockptr_t);
>  extern int ip6_mr_input(struct sk_buff *skb);
> -extern int ip6mr_ioctl(struct sock *sk, int cmd, void __user *arg);
> +extern int ip6mr_ioctl(struct sock *sk, int cmd, void *arg);
>  extern int ip6mr_compat_ioctl(struct sock *sk, unsigned int cmd, void __user *arg);
>  extern int ip6_mr_init(void);
>  extern void ip6_mr_cleanup(void);
> @@ -48,7 +48,7 @@ int ip6_mroute_getsockopt(struct sock *sock,
>  }
>  
>  static inline
> -int ip6mr_ioctl(struct sock *sk, int cmd, void __user *arg)
> +int ip6mr_ioctl(struct sock *sk, int cmd, void *arg)
>  {
>  	return -ENOIOCTLCMD;
>  }
> @@ -100,6 +100,12 @@ extern int ip6mr_get_route(struct net *net, struct sk_buff *skb,
>  #ifdef CONFIG_IPV6_MROUTE
>  bool mroute6_is_socket(struct net *net, struct sk_buff *skb);
>  extern int ip6mr_sk_done(struct sock *sk);
> +int ip6mr_sk_ioctl(struct sock *sk, unsigned int cmd, void __user *arg);
> +static inline int sk_is_ip6mr(struct sock *sk)
> +{
> +	return sk->sk_family == AF_INET6 &&
> +		inet_sk(sk)->inet_num == IPPROTO_ICMPV6;
> +}

Technically, this is just sk_is_icmpv6, which is broader than IPv6
multicast routing.

There are no other ICMPv6 specific ioctls defined, and even if there
were this callback would return 1 and continue. So I suppose it is
okay.

No other concerns from me.

Two small asides, that are fine to ignore.

The $PROTO_sk_ioctl functions could conceivably call directly into
the $PROTO_ioctl functions without the indirect function pointer.
But that would require open coding the sock_sk_ioctl_inout helpers.

The demux now first checks relatively unlikely multicast routing
and phonet before falling through to the more common protocols. But
ioctl is not a hot path operation.



