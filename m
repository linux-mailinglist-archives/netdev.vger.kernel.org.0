Return-Path: <netdev+bounces-4687-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FC8770DE22
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 15:54:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0377F281147
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 13:54:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0CA21F162;
	Tue, 23 May 2023 13:54:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF1E1EA7E
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 13:54:33 +0000 (UTC)
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B9DE56;
	Tue, 23 May 2023 06:54:25 -0700 (PDT)
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-3f607dc98cdso14080365e9.1;
        Tue, 23 May 2023 06:54:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684850064; x=1687442064;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1mc3JRJZXPFyTZ68DrWTJks/5tRPJ+X1/0qnu16j9u0=;
        b=ePpON6/4uFLrwOdodpNKjfCPYSYlAbys8ZZ9+B172iKliZwEGmw2wzozD5zmEnn+k2
         FT2WpCQGqOj+ojUe240pOd425x3Ss49/GnhYgr3lwd9WJnTuzXDmOYUPvJozYSG/CyzY
         rXmWWFJWQkqvTywTnCAVZ/0YMuwTU3DXQfH/CaBjctL1SOxLck06X0/888F/7of6KJRh
         axYpozX+vN3h9gLIrBCz1Ck9oLQNbeVpUtX59EjYs+Fjyvkraokg789ApnK1g101JxdC
         U0d4tOJfgDgLxqS6rQe0RDGC042Lrf0lSMF956X4zvV8Pq30BhBDzJUJ+X2gElsRHE/g
         d88A==
X-Gm-Message-State: AC+VfDw7LuSmJYwI++ZsCYXrwKT0SpypIeeDeADZ/BI2fqe+ypxsERYv
	jtvbB4UtbDl4czT0Q5GRHag=
X-Google-Smtp-Source: ACHHUZ5MUw5rOm0ITE9vg8BDUc0iTAtkxFjeM5WIw2g9raAjmkpaBHxiTeJ4Zr5YuxXaFBzLNFUnJw==
X-Received: by 2002:a7b:cd8a:0:b0:3f6:a66:a372 with SMTP id y10-20020a7bcd8a000000b003f60a66a372mr1890685wmj.1.1684850063779;
        Tue, 23 May 2023 06:54:23 -0700 (PDT)
Received: from gmail.com (fwdproxy-cln-012.fbsv.net. [2a03:2880:31ff:c::face:b00c])
        by smtp.gmail.com with ESMTPSA id o5-20020a05600c378500b003f42314832fsm11741715wmr.18.2023.05.23.06.54.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 06:54:23 -0700 (PDT)
Date: Tue, 23 May 2023 06:54:21 -0700
From: Breno Leitao <leitao@debian.org>
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Alexander Aring <alex.aring@gmail.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	David Ahern <dsahern@kernel.org>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Mat Martineau <martineau@kernel.org>,
	Remi Denis-Courmont <courmisch@gmail.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>, leit@fb.com,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	dccp@vger.kernel.org, linux-wpan@vger.kernel.org,
	mptcp@lists.linux.dev, linux-sctp@vger.kernel.org
Subject: Re: [PATCH v2] net: ioctl: Use kernel memory on protocol ioctl
 callbacks
Message-ID: <ZGzFjQNKklyAmLaV@gmail.com>
References: <20230522134735.2810070-1-leitao@debian.org>
 <CAF=yD-+3SnE2gsE4S3=uxxEgW+2MCLdTLx24G72fkS=AkchCEA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAF=yD-+3SnE2gsE4S3=uxxEgW+2MCLdTLx24G72fkS=AkchCEA@mail.gmail.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 03:26:55PM -0400, Willem de Bruijn wrote:
> On Mon, May 22, 2023 at 9:51 AM Breno Leitao <leitao@debian.org> wrote:
> >
> > Most of the ioctls to net protocols  operates directly on userspace
> > argument (arg). Usually doing get_user()/put_user() directly in the
> > ioctl callback.  This is not flexible, because it is hard to reuse these
> > functions without passing userspace buffers.
> >
> > Change the "struct proto" ioctls to avoid touching userspace memory and
> > operate on kernel buffers, i.e., all protocol's ioctl callbacks is
> > adapted to operate on a kernel memory other than on userspace (so, no
> > more {put,get}_user() and friends being called in the ioctl callback).
> >
> > This changes the "struct proto" ioctl format in the following way:
> >
> >     int                     (*ioctl)(struct sock *sk, int cmd,
> > -                                        unsigned long arg);
> > +                                        int *karg);
> >
> > So, the "karg" argument, which is passed to the ioctl callback, is a
> > pointer allocated to kernel space memory (inside a function wrapper -
> > sk_ioctl()). This buffer (karg) may contain input argument
> > (copied from userspace in a prep function) and it might return a
> > value/buffer, which is copied back to userspace if necessary. There is
> > not one-size-fits-all format (that is I am using 'may' above), but
> > basically, there are three type of ioctls:
> >
> > 1) Do not read from userspace, returns a result to userspace
> > 2) Read an input parameter from userspace, and does not return anything
> >   to userspace
> > 3) Read an input from userspace, and return a buffer to userspace.
> >
> > The default case (1) (where no input parameter is given, and an "int" is
> > returned to userspace) encompasses more than 90% of the cases, but there
> > are two other exceptions. Here is a list of exceptions:
> >
> > * Protocol RAW:
> >    * cmd = SIOCGETVIFCNT:
> >      * input and output = struct sioc_vif_req
> >    * cmd = SIOCGETSGCNT
> >      * input and output = struct sioc_sg_req
> >    * Explanation: for the SIOCGETVIFCNT case, userspace passes the input
> >      argument, which is struct sioc_vif_req. Then the callback populates
> >      the struct, which is copied back to userspace.
> >
> > * Protocol RAW6:
> >    * cmd = SIOCGETMIFCNT_IN6
> >      * input and output = struct sioc_mif_req6
> >    * cmd = SIOCGETSGCNT_IN6
> >      * input and output = struct sioc_sg_req6
> >
> > * Protocol PHONET:
> >   * cmd == SIOCPNADDRESOURCE | SIOCPNDELRESOURCE
> >      * input int (4 bytes)
> >   * Nothing is copied back to userspace.
> >
> > For the exception cases, functions sk_ioctl_in{out}() will
> > copy the userspace input, and copy it back to kernel space.
> >
> > The wrapper that prepare the buffer and put the buffer back to user is
> > sk_ioctl(), so, instead of calling sk->sk_prot->ioctl(), the
> > callee now calls sk_ioctl(), which will handle all cases.
> >
> > Signed-off-by: Breno Leitao <leitao@debian.org>
> 
> Going forward, please mark patches for net-next with [PATCH net-next v2]
> 
> > --- a/include/net/udp.h
> > +++ b/include/net/udp.h
> > @@ -283,7 +283,7 @@ void udp_flush_pending_frames(struct sock *sk);
> >  int udp_cmsg_send(struct sock *sk, struct msghdr *msg, u16 *gso_size);
> >  void udp4_hwcsum(struct sk_buff *skb, __be32 src, __be32 dst);
> >  int udp_rcv(struct sk_buff *skb);
> > -int udp_ioctl(struct sock *sk, int cmd, unsigned long arg);
> > +int udp_ioctl(struct sock *sk, int cmd, int *karg);
> >  int udp_init_sock(struct sock *sk);
> >  int udp_pre_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len);
> >  int __udp_disconnect(struct sock *sk, int flags);
> > diff --git a/net/core/sock.c b/net/core/sock.c
> > index 5440e67bcfe3..a2cea95aec99 100644
> > --- a/net/core/sock.c
> > +++ b/net/core/sock.c
> > @@ -114,6 +114,8 @@
> >  #include <linux/memcontrol.h>
> >  #include <linux/prefetch.h>
> >  #include <linux/compat.h>
> > +#include <linux/mroute.h>
> > +#include <linux/mroute6.h>
> 
> This is for the ioctl constants only, right.

Right.

> Then like those header files, include the uapi header, and only that,
> to minimize the dependencies added to net/core/sock.c

ack!

> 
> >  #include <linux/uaccess.h>
> >
> > @@ -138,6 +140,7 @@
> >
> >  #include <net/tcp.h>
> >  #include <net/busy_poll.h>
> > +#include <net/phonet/phonet.h>
> >
> >  #include <linux/ethtool.h>
> >
> > @@ -4106,3 +4109,112 @@ int sock_bind_add(struct sock *sk, struct sockaddr *addr, int addr_len)
> >         return sk->sk_prot->bind_add(sk, addr, addr_len);
> >  }
> >  EXPORT_SYMBOL(sock_bind_add);
> > +
> > +#ifdef CONFIG_PHONET
> > +/* Copy u32 value from userspace and do not return anything back */
> > +static int sk_ioctl_in(struct sock *sk, unsigned int cmd, void __user *arg)
> 
> The pointer can be const.
> 
> > +{
> > +       int karg;
> > +
> > +       if (get_user(karg, (u32 __user *)arg))
> > +               return -EFAULT;
> 
> The comment and cast are u32, but the datatype is int. Is there a
> reason for that.

I just copied what we have in pn_ioctl()[1]

	static int pn_ioctl(struct sock *sk, int cmd, unsigned long arg)
	{

		switch (cmd) {
		case SIOCPNADDRESOURCE:
		case SIOCPNDELRESOURCE: {
				u32 res;
				if (get_user(res, (u32 __user *)arg))
				....


I will cast it to "int" on V3.

[1] https://github.com/torvalds/linux/blob/ae8373a5add4ea39f032563cf12a02946d1e3546/net/phonet/datagram.c#L47

