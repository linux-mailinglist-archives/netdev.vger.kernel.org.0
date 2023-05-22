Return-Path: <netdev+bounces-4414-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 36A3B70C742
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 21:27:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 07C6D1C20BD3
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 19:27:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E46E171C1;
	Mon, 22 May 2023 19:27:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E156168D1
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 19:27:35 +0000 (UTC)
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A5EDC;
	Mon, 22 May 2023 12:27:33 -0700 (PDT)
Received: by mail-vs1-xe2b.google.com with SMTP id ada2fe7eead31-437daacde18so3198451137.1;
        Mon, 22 May 2023 12:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684783652; x=1687375652;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=biTqhaRrwnq+6iF3H5aYXgbRPsgH38wnnbhYoL0fz9E=;
        b=VeI+0z+X21mUaVtYPwYQd/BzVpP8JaQ8sYQlxW9SvnnVfqaBpQzTI1swzmNubsANjS
         wBzWA52gvxpBP634URABcl9vyBvalzNCSS/LaLRl1A5l2mo8OlmJTQebnZilVUiuXRdf
         2MDf7UbBeU95F+fxbLpQoR5K7Q+7dY1GGQ1nKGJcGmAxw0v/fS0Qfn7bggon5ohDlODc
         9mHccdiHEI/Pi2kHPQhJfupNV7v38OwvbIG1xV71ODF3PfgFcXmS2jtLx4Z9ALg2v2LX
         491jYrJapNz1d3ldJMPFg+0v1MMB/emEoZvoFCxLGV7Z3wmTZqA3QOCYOdGuXKgRL6X2
         Pwqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684783652; x=1687375652;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=biTqhaRrwnq+6iF3H5aYXgbRPsgH38wnnbhYoL0fz9E=;
        b=DHHFakTvI9wUqJ2+iwV/d/cdtZQ8ETHyw5dOr3ydQfqEE9Xt5wpxl8FSrfWOEDRoaG
         kgZGGhsqVwEDqsNBCBQPdPbNuBg1U8POjo6ivI1vOZ60eIUww5OuCgUcRnYSEuZMZVAd
         Kk6t/MXkC0IJCvTHkxl5l6hoJgNYWnoHLTq8gX1HoKauG3vpOLNEJQiovfQqIsNpMXPt
         zMjnQ/L5m7s3ey0Sx5AnxqRg8PzNDAjryNfmCPLHzJkFpHITq1EQLQy3TkY65hRgW3/y
         kfjVvGXo8pcrYZsicHTvEg7cPTNJ93AU9nwqlZ5YX0mHYf1GUDpSUi0Hlr7IUHrMA5aD
         aI7w==
X-Gm-Message-State: AC+VfDwsBxLQQf0b+tId6cIMyfEaSh8mF3/rnVlleeGzQQO5zCLe/sR1
	plPp5bsS115FqxdrxR2YAqLWHJTeklF274xkANfCNl8kgbc=
X-Google-Smtp-Source: ACHHUZ6bXFql+cdJsT8yKVYD4W717qH/NriSPxaI56nhxUx37zbUAHaU1wXQjnL7PeE0UctCBDwzmxEaLni4q062rfk=
X-Received: by 2002:a05:6102:3179:b0:439:49f1:bb4d with SMTP id
 l25-20020a056102317900b0043949f1bb4dmr1106704vsm.7.1684783652346; Mon, 22 May
 2023 12:27:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230522134735.2810070-1-leitao@debian.org>
In-Reply-To: <20230522134735.2810070-1-leitao@debian.org>
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Mon, 22 May 2023 15:26:55 -0400
Message-ID: <CAF=yD-+3SnE2gsE4S3=uxxEgW+2MCLdTLx24G72fkS=AkchCEA@mail.gmail.com>
Subject: Re: [PATCH v2] net: ioctl: Use kernel memory on protocol ioctl callbacks
To: Breno Leitao <leitao@debian.org>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Alexander Aring <alex.aring@gmail.com>, Stefan Schmidt <stefan@datenfreihafen.org>, 
	Miquel Raynal <miquel.raynal@bootlin.com>, David Ahern <dsahern@kernel.org>, 
	Matthieu Baerts <matthieu.baerts@tessares.net>, Mat Martineau <martineau@kernel.org>, 
	Remi Denis-Courmont <courmisch@gmail.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
	Xin Long <lucien.xin@gmail.com>, leit@fb.com, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, dccp@vger.kernel.org, linux-wpan@vger.kernel.org, 
	mptcp@lists.linux.dev, linux-sctp@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 9:51=E2=80=AFAM Breno Leitao <leitao@debian.org> wr=
ote:
>
> Most of the ioctls to net protocols  operates directly on userspace
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
> pointer allocated to kernel space memory (inside a function wrapper -
> sk_ioctl()). This buffer (karg) may contain input argument
> (copied from userspace in a prep function) and it might return a
> value/buffer, which is copied back to userspace if necessary. There is
> not one-size-fits-all format (that is I am using 'may' above), but
> basically, there are three type of ioctls:
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
>    * cmd =3D SIOCGETVIFCNT:
>      * input and output =3D struct sioc_vif_req
>    * cmd =3D SIOCGETSGCNT
>      * input and output =3D struct sioc_sg_req
>    * Explanation: for the SIOCGETVIFCNT case, userspace passes the input
>      argument, which is struct sioc_vif_req. Then the callback populates
>      the struct, which is copied back to userspace.
>
> * Protocol RAW6:
>    * cmd =3D SIOCGETMIFCNT_IN6
>      * input and output =3D struct sioc_mif_req6
>    * cmd =3D SIOCGETSGCNT_IN6
>      * input and output =3D struct sioc_sg_req6
>
> * Protocol PHONET:
>   * cmd =3D=3D SIOCPNADDRESOURCE | SIOCPNDELRESOURCE
>      * input int (4 bytes)
>   * Nothing is copied back to userspace.
>
> For the exception cases, functions sk_ioctl_in{out}() will
> copy the userspace input, and copy it back to kernel space.
>
> The wrapper that prepare the buffer and put the buffer back to user is
> sk_ioctl(), so, instead of calling sk->sk_prot->ioctl(), the
> callee now calls sk_ioctl(), which will handle all cases.
>
> Signed-off-by: Breno Leitao <leitao@debian.org>

Going forward, please mark patches for net-next with [PATCH net-next v2]

> --- a/include/net/udp.h
> +++ b/include/net/udp.h
> @@ -283,7 +283,7 @@ void udp_flush_pending_frames(struct sock *sk);
>  int udp_cmsg_send(struct sock *sk, struct msghdr *msg, u16 *gso_size);
>  void udp4_hwcsum(struct sk_buff *skb, __be32 src, __be32 dst);
>  int udp_rcv(struct sk_buff *skb);
> -int udp_ioctl(struct sock *sk, int cmd, unsigned long arg);
> +int udp_ioctl(struct sock *sk, int cmd, int *karg);
>  int udp_init_sock(struct sock *sk);
>  int udp_pre_connect(struct sock *sk, struct sockaddr *uaddr, int addr_le=
n);
>  int __udp_disconnect(struct sock *sk, int flags);
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 5440e67bcfe3..a2cea95aec99 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -114,6 +114,8 @@
>  #include <linux/memcontrol.h>
>  #include <linux/prefetch.h>
>  #include <linux/compat.h>
> +#include <linux/mroute.h>
> +#include <linux/mroute6.h>

This is for the ioctl constants only, right.

Then like those header files, include the uapi header, and only that,
to minimize the dependencies added to net/core/sock.c

>  #include <linux/uaccess.h>
>
> @@ -138,6 +140,7 @@
>
>  #include <net/tcp.h>
>  #include <net/busy_poll.h>
> +#include <net/phonet/phonet.h>
>
>  #include <linux/ethtool.h>
>
> @@ -4106,3 +4109,112 @@ int sock_bind_add(struct sock *sk, struct sockadd=
r *addr, int addr_len)
>         return sk->sk_prot->bind_add(sk, addr, addr_len);
>  }
>  EXPORT_SYMBOL(sock_bind_add);
> +
> +#ifdef CONFIG_PHONET
> +/* Copy u32 value from userspace and do not return anything back */
> +static int sk_ioctl_in(struct sock *sk, unsigned int cmd, void __user *a=
rg)

The pointer can be const.

> +{
> +       int karg;
> +
> +       if (get_user(karg, (u32 __user *)arg))
> +               return -EFAULT;

The comment and cast are u32, but the datatype is int. Is there a
reason for that.

> +       return sk->sk_prot->ioctl(sk, cmd, &karg);
> +}
> +#endif

