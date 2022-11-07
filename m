Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A697E62023F
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 23:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbiKGWVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 17:21:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbiKGWVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 17:21:00 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6877F17A88
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 14:20:59 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id n12so33866435eja.11
        for <netdev@vger.kernel.org>; Mon, 07 Nov 2022 14:20:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MHrJf3FaHE29Zutftd68zifmo1hPeGGqoFOlGdw1rmI=;
        b=AwKIlmwuZ1I8VHunXQwxi+/ErYiayfnN4dMfUdfI3Npj+twoFT/uRoF6atPcIXPuVJ
         wLBaH1d9dY3V6F111ijqYhVgUn7BRAphSWDzyvcUiL+XGIZcbDCAvH1yg6I2s5D4ttsD
         KUoohK5DHbBa1mSxFb7R7E1HF8OoFkZHeplJBA1Ff12MzsUql7k7Xi7Uj7Mk/jHSRcnd
         2T1ZMBqU3CEjMuPW3XVA5amjms9J8OAr/kdtmdKr5R5mShNeNKgoLJ68yymJwg7vuZfS
         Jyp7WdXYRS6Hqee33uaMpXbvykumlpBYGKTzDZI1hfWpdmI2N+9w1ZnYhYJex0A3DwIZ
         ObRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MHrJf3FaHE29Zutftd68zifmo1hPeGGqoFOlGdw1rmI=;
        b=XCH9rWFdkHFgtKCbPSSNGMm/ree9EI2/foiO3t8KnxAGG5BBFRnY3/sY4kfRkqGfOm
         frxunQKpBGlSxcrP2c2KpRlgT7l9yWQT7Smzf7ptMEURyJdoUn7vtBvAkjbUmuY9L7uK
         2r3+qdZYvyorC1wIE4HPMXHU7fSULXXmf7B31Oj44rXA6RnPxEY2Q9dGbSdGqxAqHs3L
         8IeQ0wYy9gCMUH1FdTIfihiXemdbAuG5tvpSO6gAZx9N5kFxoC4ex79w5Z4/o0Hd1cjy
         aPxxlR2VYg4AVt9n+1kaQ02vAb0t94P70e9CqNvbs8mzfsUkvqJYbc5dP7xYfBd9EI//
         LfWQ==
X-Gm-Message-State: ACrzQf0JXUI9bsQqgR/tCu9dPwI3FFtDMVV+p8D8+Q9P1/aXchP53BEF
        zepjOoPdf7RqsjckmpbG5YOtecFl5cPTk4HKtVw=
X-Google-Smtp-Source: AMsMyM5JNZG0Mf560/Ow4a4TT5OMTI8s8DOqotSAAXDUPHIIOIr9ahutvigVGb0VmM5ATMdzTFB7yLCaxHNM83LSIzU=
X-Received: by 2002:a17:906:cc49:b0:7ad:93d1:5eaf with SMTP id
 mm9-20020a170906cc4900b007ad93d15eafmr49673219ejb.393.1667859657841; Mon, 07
 Nov 2022 14:20:57 -0800 (PST)
MIME-Version: 1.0
References: <20221029001249.86337-1-kuniyu@amazon.com>
In-Reply-To: <20221029001249.86337-1-kuniyu@amazon.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Mon, 7 Nov 2022 14:20:46 -0800
Message-ID: <CAJnrk1Y_yE+-UQUkrkG-NmwKVM0NAQJwV4HcLtRQf+CNq4Tf_g@mail.gmail.com>
Subject: Re: [RFC] bhash2 and WARN_ON() for inconsistent sk saddr.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 28, 2022 at 5:13 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> Hi,
>
> I want to discuss bhash2 and WARN_ON() being fired every day this month
> on my syzkaller instance without repro.
>
>   WARNING: CPU: 0 PID: 209 at net/ipv4/inet_connection_sock.c:548 inet_csk_get_port (net/ipv4/inet_connection_sock.c:548 (discriminator 1))
>   ...
>   inet_csk_listen_start (net/ipv4/inet_connection_sock.c:1205)
>   inet_listen (net/ipv4/af_inet.c:228)
>   __sys_listen (net/socket.c:1810)
>   __x64_sys_listen (net/socket.c:1819 net/socket.c:1817 net/socket.c:1817)
>   do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
>   entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)
>
[...]
>
> Please see the source addresses of s2/s3 below after connect() fails.
> The s2 case is another variant of the first syzbot report, which has
> been already _fixed_.  And the s3 case is a repro for the issue that
> Mat and I saw.

Since the s2 address mismatch case is addressed by your patch
https://lore.kernel.org/netdev/20221103172419.20977-1-kuniyu@amazon.com/,
I will focus my comments here on the s3 case.

>
>   # sysctl -w net.ipv4.tcp_syn_retries=1
>   net.ipv4.tcp_syn_retries = 1
>   # python3
>   >>> from socket import *
>   >>>
>   >>> s1 = socket()
>   >>> s1.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
>   >>> s1.bind(('0.0.0.0', 10000))
>   >>> s1.connect(('127.0.0.1', 10000))
>   >>>
>   >>> s2 = socket()
>   >>> s2.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
>   >>> s2.bind(('0.0.0.0', 10000))
>   >>> s2
>   <socket.socket fd=4, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=('0.0.0.0', 10000)>
>   >>>
>   >>> s2.connect(('127.0.0.1', 10000))
>   Traceback (most recent call last):
>     File "<stdin>", line 1, in <module>
>   OSError: [Errno 99] Cannot assign requested address
>   >>>
>   >>> s2
>   <socket.socket fd=4, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=('127.0.0.1', 10000)>
>                                                                                                    ^^^ ???
>   >>> s3 = socket()
>   >>> s3.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
>   >>> s3.bind(('0.0.0.0', 10000))
>   >>> s3
>   <socket.socket fd=5, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=('0.0.0.0', 10000)>
>   >>>
>   >>> s3.connect(('0.0.0.1', 1))
>   Traceback (most recent call last):
>     File "<stdin>", line 1, in <module>
>   TimeoutError: [Errno 110] Connection timed out
>   >>>
>   >>> s3
>   <socket.socket fd=5, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=('0.0.0.0', 10000)>
>
> We can fire the WARN_ON() by s3.listen().
>
>   >>> s3.listen()
>   [ 1096.845905] ------------[ cut here ]------------
>   [ 1096.846290] WARNING: CPU: 0 PID: 209 at net/ipv4/inet_connection_sock.c:548 inet_csk_get_port+0x6bb/0x9e0

I'm on the head of net-next/master (commit
bf46390f39c686d62afeae9845860e63886d63b) and trying to repro this
locally, but the warning isn't showing up for me after following the
steps above. Not sure why.

>
> In the s3 case, connect() resets sk->sk_rcv_saddr to INADDR_ANY without
> updating the bhash2 bucket; OTOH sk has the correct non-NULL bhash bucket.

To summarize, the path you are talking about is tcp_v4_connect() in
kernel/linux/net/ipv4/tcp_ipv4.c where the sk originally has saddr
INADDR_ANY, the sk gets assigned a new address, that new address gets
updated in the bhash2 table, and then when inet_hash_connect() is
called, it fails which brings us to the "goto failure". In the failure
goto, we call "tcp_set_state(sk, TCP_CLOSE)" but in the case where
"SOCK_BINDPORT_LOCK" is held, "inet_put_port(sk)" is *not* called,
which means the sk will still be in the bhash2 table with the new
address.

> So, when we call listen() for s3, inet_csk_get_port() does not call
> inet_bind_hash() and the WARN_ON() for bhash2 fires.
>
>   if (!inet_csk(sk)->icsk_bind_hash)
>         inet_bind_hash(sk, tb, tb2, port);
>   WARN_ON(inet_csk(sk)->icsk_bind_hash != tb);
>   WARN_ON(inet_csk(sk)->icsk_bind2_hash != tb2);
>
[...]
>
> In the s3 case, connect() falls into a different path.  We reach the
> sock_error label in __inet_stream_connect() and call sk_prot->disconnect(),
> which resets sk->sk_rcv_saddr.

This is the case where in __inet_stream_connect(), the call to
"sk->sk_prot->connect()" succeeds but then the connection is closed by
RST/timeout/ICMP error, so then the "goto sock_error" is triggered,
correct?

>
> Then, there could be two subsequent issues.
>
>   * listen() leaks a newly allocated bhash2 bucket
>
>   * In inet_put_port(), inet_bhashfn_portaddr() computes a wrong hash for
>     inet_csk(sk)->icsk_bind2_hash, resulting in list corruption.
>
> We can fix these easily but it still leaves inconsistent sockets in bhash2,
> so we need to fix the root cause.
>
> As a side note, this issue only happens when we bind() only port before
> connect().  If we do not bind() port, tcp_set_state(sk, TCP_CLOSE) calls
> inet_put_port() and unhashes the sk from bhash2.
>
>
> At first, I applied the patch below so that both sk2 and sk3 trigger
> WARN_ON().  Then, I tried two approaches:
>
>   * Fix up the bhash2 entry when calling sk_rcv_saddr
>
>   * Change the bhash2 entry only when connect() succeeds
>
> The former does not work when we run out of memory.  When we change saddr
> from INADDR_ANY, inet_bhash2_update_saddr() could free (INADDR_ANY, port)
> bhash2 bucket.  Then, we possibly could not allocate it again when
> restoring saddr in the failure path.
>
> The latter does not work when a sk is in non-blocking mode.  In this case,
> a user might not call the second connect() to fix up the bhash2 bucket.
>
>   >>> s4 = socket()
>   >>> s4.bind(('0.0.0.0', 10000))
>   >>> s4.setblocking(False)
>   >>> s4
>   <socket.socket fd=3, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=('0.0.0.0', 10000)>
>
>   >>> s4.connect(('0.0.0.1', 1))
>   Traceback (most recent call last):
>     File "<stdin>", line 1, in <module>
>   BlockingIOError: [Errno 115] Operation now in progress
>   >>> s4
>   <socket.socket fd=3, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=('10.0.2.15', 10000)>
>
> Also, the former approach does not work for the non-blocking case.  Let's
> say the second connect() fails.  What if we fail to allocate an INADDR_ANY
> bhash2 bucket?  We have to change saddr to INADDR_ANY but cannot.... but
> the connect() actually failed....??
>
>   >>> s4.connect(('0.0.0.1', 1))
>   Traceback (most recent call last):
>     File "<stdin>", line 1, in <module>
>   ConnectionRefusedError: [Errno 111] Connection refused
>   >>> s4
>   <socket.socket fd=3, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=('0.0.0.0', 10000)>
>
>
> Now, I'm thinking bhash2 bucket needs a refcnt not to be freed while
> refcnt is greater than 1.  And we need to change the conflict logic
> so that the kernel ignores empty bhash2 bucket.  Such changes could
> be big for the net tree, but the next LTS will likely be v6.1 which
> has bhash2.
>
> What do you think is the best way to fix the issue?

To summarize your analysis, there is an issue right now where for
sockets that are binded on address INADDR_ANY,  we need to handle the
error case where if a connection fails and SOCK_BINDPORT_LOCK is held,
the new address it was assigned needs to be taken out of bhash2 and
the original address (INADDR_ANY) needs to be re-added to bhash2.
There are two of these error cases we need to handle,  as you
mentioned above - 1) in dccp/tcp_v4_connect() where the connect call
fails and 2) in __inet_stream_connect() where the connect call
succeeds but the connection is closed by a RST/timeout/ICMP error.

I think the simplest solution is to modify inet_bhash2_update_saddr()
so that we don't free the inet_bind2_bucket() for INADDR_ANY/port (if
it is empty after we update the saddr to the new addr) *until* the
connect succeeds. When the connect succeeds, then we can check whether
the inet_bind2_bucket for INADDR_ANY is empty, and if it is, then do
the freeing for it.

What are your thoughts on this?

Thank you.

>
> Thank you.
>
>
> ---8<---
> diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
> index 713b7b8dad7e..40640c26680e 100644
> --- a/net/dccp/ipv4.c
> +++ b/net/dccp/ipv4.c
> @@ -157,6 +157,8 @@ int dccp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
>          * This unhashes the socket and releases the local port, if necessary.
>          */
>         dccp_set_state(sk, DCCP_CLOSED);
> +       if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> +               inet_reset_saddr(sk);
>         ip_rt_put(rt);
>         sk->sk_route_caps = 0;
>         inet->inet_dport = 0;
> diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
> index e57b43006074..626166cb6d7e 100644
> --- a/net/dccp/ipv6.c
> +++ b/net/dccp/ipv6.c
> @@ -985,6 +985,8 @@ static int dccp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
>
>  late_failure:
>         dccp_set_state(sk, DCCP_CLOSED);
> +       if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> +               inet_reset_saddr(sk);
>         __sk_dst_reset(sk);
>  failure:
>         inet->inet_dport = 0;
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index 7a250ef9d1b7..834245da1e95 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -343,6 +343,8 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
>          * if necessary.
>          */
>         tcp_set_state(sk, TCP_CLOSE);
> +       if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> +               inet_reset_saddr(sk);
>         ip_rt_put(rt);
>         sk->sk_route_caps = 0;
>         inet->inet_dport = 0;
> diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> index 2a3f9296df1e..81b396e5cf79 100644
> --- a/net/ipv6/tcp_ipv6.c
> +++ b/net/ipv6/tcp_ipv6.c
> @@ -359,6 +359,8 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
>
>  late_failure:
>         tcp_set_state(sk, TCP_CLOSE);
> +       if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> +               inet_reset_saddr(sk);
>  failure:
>         inet->inet_dport = 0;
>         sk->sk_route_caps = 0;
> ---8<---
