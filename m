Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAC07621AEC
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 18:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234528AbiKHRki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 12:40:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233817AbiKHRkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 12:40:36 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F39C50F14
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 09:40:35 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id z18so23610984edb.9
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 09:40:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PCTuI0WwcXSkbmCjlkPJOSALMl3kAmhUL2Ev+qRl8qM=;
        b=XG5TwlTTX56z38JqrmjqLYmOYySiYaU1FqmG5O6jri/31wNDCzuX8C5RClm2GzPfvK
         2dV46dbTqWK+L+vKdKnwd8Y0DT6Z0evYcSm3KX3/cL9/TP+7HhNrprPYFdZ2E2f9CKBL
         h7bnq1H9w6dW45ELJJJ/5DS/FKqq/PUQkQSV6oXTKj43iV3UMHP65F7oVkFeM0whABkY
         /SG7yxAEj0eKd7AasYgpMuKtrM8p/NZD99Xmibmzut7jYBDFlToHc1AXz04RF8UHaIfz
         SUQNhwHlyScOB7SYqmyVb3KkmUDe2ES2XfLWbDm1h36+WxWmtFqtINmylSnlVg7pWDu7
         QBzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PCTuI0WwcXSkbmCjlkPJOSALMl3kAmhUL2Ev+qRl8qM=;
        b=XXx5OmfAtVTLgHetYXVZuNoBcXcQjwsT1Z8lYUulG1L+2mdt9hbM5HcSG/UJTMaPoU
         Ea3AfxlltckOrhvyUqenx9nf8jKBEaLDzgDfqSc6FJBpRd/4DL5MalLnC4Jw04FHcxhP
         TTjZGxZK2Ck18PjzxXLZNk/8ucoJ6FX+2jrwyS73o75aTnWOdgk4DSsmivtk/wFYjdys
         VzG2dPenig87eFLkU5A7oL2fHWFAjk+xe01FTAInn8uWlXmEHeCgNmiQm+MYWNWbbyRg
         5tIpkY8Inee0dHH7sz7BkSWRck621e7Lj59QdRy7xXOo1qwmfgD+gNo7G1GD3Zt7U4Ds
         0xBw==
X-Gm-Message-State: ACrzQf0xCYPJhlvJLUWEZ95ubJkNLnoxPkoG/CleaZ9t32pfLq6vsC9H
        fiihwWc2ifWcaDVeZ7MWxcBG708zCU44MzwkK5c=
X-Google-Smtp-Source: AMsMyM6YkbBMyYud8qnT98MCjCUppKL46nrfP+E/ADUi795CNtZw7lbrw4AF1n+iTiYS/AS63fY86JRsT9P5UJ1ECpM=
X-Received: by 2002:aa7:c6d9:0:b0:461:b431:9058 with SMTP id
 b25-20020aa7c6d9000000b00461b4319058mr56996916eds.208.1667929233507; Tue, 08
 Nov 2022 09:40:33 -0800 (PST)
MIME-Version: 1.0
References: <CAJnrk1Y_yE+-UQUkrkG-NmwKVM0NAQJwV4HcLtRQf+CNq4Tf_g@mail.gmail.com>
 <20221108012743.33905-1-kuniyu@amazon.com>
In-Reply-To: <20221108012743.33905-1-kuniyu@amazon.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Tue, 8 Nov 2022 09:40:22 -0800
Message-ID: <CAJnrk1YZXns7sysWk4qFoikNUxie+Z1fJrP5LN9EqpWfzcQALQ@mail.gmail.com>
Subject: Re: [RFC] bhash2 and WARN_ON() for inconsistent sk saddr.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        kuni1840@gmail.com, martin.lau@kernel.org,
        mathew.j.martineau@linux.intel.com, netdev@vger.kernel.org,
        pabeni@redhat.com
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

 On Mon, Nov 7, 2022 at 5:27 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> From:   Joanne Koong <joannelkoong@gmail.com>
> Date:   Mon, 7 Nov 2022 14:20:46 -0800
> > On Fri, Oct 28, 2022 at 5:13 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > >
> > > Hi,
> > >
> > > I want to discuss bhash2 and WARN_ON() being fired every day this month
> > > on my syzkaller instance without repro.
> > >
> > >   WARNING: CPU: 0 PID: 209 at net/ipv4/inet_connection_sock.c:548 inet_csk_get_port (net/ipv4/inet_connection_sock.c:548 (discriminator 1))
> > >   ...
> > >   inet_csk_listen_start (net/ipv4/inet_connection_sock.c:1205)
> > >   inet_listen (net/ipv4/af_inet.c:228)
> > >   __sys_listen (net/socket.c:1810)
> > >   __x64_sys_listen (net/socket.c:1819 net/socket.c:1817 net/socket.c:1817)
> > >   do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
> > >   entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)
> > >
> > [...]
> > >
> > > Please see the source addresses of s2/s3 below after connect() fails.
> > > The s2 case is another variant of the first syzbot report, which has
> > > been already _fixed_.  And the s3 case is a repro for the issue that
> > > Mat and I saw.
> >
> > Since the s2 address mismatch case is addressed by your patch
> > https://lore.kernel.org/netdev/20221103172419.20977-1-kuniyu@amazon.com/,
> > I will focus my comments here on the s3 case.
> >
> > >
> > >   # sysctl -w net.ipv4.tcp_syn_retries=1
> > >   net.ipv4.tcp_syn_retries = 1
> > >   # python3
> > >   >>> from socket import *
> > >   >>>
> > >   >>> s1 = socket()
> > >   >>> s1.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
> > >   >>> s1.bind(('0.0.0.0', 10000))
> > >   >>> s1.connect(('127.0.0.1', 10000))
> > >   >>>
> > >   >>> s2 = socket()
> > >   >>> s2.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
> > >   >>> s2.bind(('0.0.0.0', 10000))
> > >   >>> s2
> > >   <socket.socket fd=4, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=('0.0.0.0', 10000)>
> > >   >>>
> > >   >>> s2.connect(('127.0.0.1', 10000))
> > >   Traceback (most recent call last):
> > >     File "<stdin>", line 1, in <module>
> > >   OSError: [Errno 99] Cannot assign requested address
> > >   >>>
> > >   >>> s2
> > >   <socket.socket fd=4, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=('127.0.0.1', 10000)>
> > >                                                                                                    ^^^ ???
> > >   >>> s3 = socket()
> > >   >>> s3.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
> > >   >>> s3.bind(('0.0.0.0', 10000))
> > >   >>> s3
> > >   <socket.socket fd=5, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=('0.0.0.0', 10000)>
> > >   >>>
> > >   >>> s3.connect(('0.0.0.1', 1))
> > >   Traceback (most recent call last):
> > >     File "<stdin>", line 1, in <module>
> > >   TimeoutError: [Errno 110] Connection timed out
> > >   >>>
> > >   >>> s3
> > >   <socket.socket fd=5, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=('0.0.0.0', 10000)>
> > >
> > > We can fire the WARN_ON() by s3.listen().
> > >
> > >   >>> s3.listen()
> > >   [ 1096.845905] ------------[ cut here ]------------
> > >   [ 1096.846290] WARNING: CPU: 0 PID: 209 at net/ipv4/inet_connection_sock.c:548 inet_csk_get_port+0x6bb/0x9e0
> >
> > I'm on the head of net-next/master (commit
> > bf46390f39c686d62afeae9845860e63886d63b) and trying to repro this
> > locally, but the warning isn't showing up for me after following the
> > steps above. Not sure why.
>
> Hmm... it reproduced on top of the commit.  I'm testing on QEMU and login
> to serial console which outputs syslog in the same stream, so you may want
> to check /var/log/messages or something.
>
> ---8<---
> # sysctl -w net.ipv4.tcp_syn_retries=1
> # python3
> >>> from socket import *
> >>>
> >>> s = socket()
> >>> s.bind(('0', 10000))
> >>> s.connect(('0.0.0.1', 1))
> Traceback (most recent call last):
>   File "<stdin>", line 1, in <module>
> TimeoutError: [Errno 110] Connection timed out
> >>> s
> <socket.socket fd=3, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=('0.0.0.0', 10000)>
> >>> s.listen(32)
> [   96.598308] ------------[ cut here ]------------
> [   96.598598] WARNING: CPU: 0 PID: 214 at net/ipv4/inet_connection_sock.c:548 inet_csk_get_port+0x6bb/0x9e0
> ...
>
> >>> s = socket()
> >>> s.bind(('0', 10001))
> >>> s.connect(('localhost', 1))
> Traceback (most recent call last):
>   File "<stdin>", line 1, in <module>
> ConnectionRefusedError: [Errno 111] Connection refused
> >>> s.listen(32)
> [  139.157193] ------------[ cut here ]------------
> [  139.157528] WARNING: CPU: 0 PID: 214 at net/ipv4/inet_connection_sock.c:548 inet_csk_get_port+0x6bb/0x9e0
> ---8<---
>
>
> >
> > >
> > > In the s3 case, connect() resets sk->sk_rcv_saddr to INADDR_ANY without
> > > updating the bhash2 bucket; OTOH sk has the correct non-NULL bhash bucket.
> >
> > To summarize, the path you are talking about is tcp_v4_connect() in
> > kernel/linux/net/ipv4/tcp_ipv4.c where the sk originally has saddr
> > INADDR_ANY, the sk gets assigned a new address, that new address gets
> > updated in the bhash2 table, and then when inet_hash_connect() is
> > called, it fails which brings us to the "goto failure". In the failure
> > goto, we call "tcp_set_state(sk, TCP_CLOSE)" but in the case where
> > "SOCK_BINDPORT_LOCK" is held, "inet_put_port(sk)" is *not* called,
> > which means the sk will still be in the bhash2 table with the new
> > address.
>
> Correct.
>
> More precisely, 3 functions after inet_hash_connect() can cause the same
> issue.
>
> - ip_route_newports
> - tcp_fastopen_defer_connect
> - tcp_connect
>
>
> >
> > > So, when we call listen() for s3, inet_csk_get_port() does not call
> > > inet_bind_hash() and the WARN_ON() for bhash2 fires.
> > >
> > >   if (!inet_csk(sk)->icsk_bind_hash)
> > >         inet_bind_hash(sk, tb, tb2, port);
> > >   WARN_ON(inet_csk(sk)->icsk_bind_hash != tb);
> > >   WARN_ON(inet_csk(sk)->icsk_bind2_hash != tb2);
> > >
> > [...]
> > >
> > > In the s3 case, connect() falls into a different path.  We reach the
> > > sock_error label in __inet_stream_connect() and call sk_prot->disconnect(),
> > > which resets sk->sk_rcv_saddr.
> >
> > This is the case where in __inet_stream_connect(), the call to
> > "sk->sk_prot->connect()" succeeds but then the connection is closed by
> > RST/timeout/ICMP error, so then the "goto sock_error" is triggered,
> > correct?
>
> Yes.
>
>
> >
> > >
> > > Then, there could be two subsequent issues.
> > >
> > >   * listen() leaks a newly allocated bhash2 bucket
> > >
> > >   * In inet_put_port(), inet_bhashfn_portaddr() computes a wrong hash for
> > >     inet_csk(sk)->icsk_bind2_hash, resulting in list corruption.
> > >
> > > We can fix these easily but it still leaves inconsistent sockets in bhash2,
> > > so we need to fix the root cause.
> > >
> > > As a side note, this issue only happens when we bind() only port before
> > > connect().  If we do not bind() port, tcp_set_state(sk, TCP_CLOSE) calls
> > > inet_put_port() and unhashes the sk from bhash2.
> > >
> > >
> > > At first, I applied the patch below so that both sk2 and sk3 trigger
> > > WARN_ON().  Then, I tried two approaches:
> > >
> > >   * Fix up the bhash2 entry when calling sk_rcv_saddr
> > >
> > >   * Change the bhash2 entry only when connect() succeeds
> > >
> > > The former does not work when we run out of memory.  When we change saddr
> > > from INADDR_ANY, inet_bhash2_update_saddr() could free (INADDR_ANY, port)
> > > bhash2 bucket.  Then, we possibly could not allocate it again when
> > > restoring saddr in the failure path.
> > >
> > > The latter does not work when a sk is in non-blocking mode.  In this case,
> > > a user might not call the second connect() to fix up the bhash2 bucket.
> > >
> > >   >>> s4 = socket()
> > >   >>> s4.bind(('0.0.0.0', 10000))
> > >   >>> s4.setblocking(False)
> > >   >>> s4
> > >   <socket.socket fd=3, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=('0.0.0.0', 10000)>
> > >
> > >   >>> s4.connect(('0.0.0.1', 1))
> > >   Traceback (most recent call last):
> > >     File "<stdin>", line 1, in <module>
> > >   BlockingIOError: [Errno 115] Operation now in progress
> > >   >>> s4
> > >   <socket.socket fd=3, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=('10.0.2.15', 10000)>
> > >
> > > Also, the former approach does not work for the non-blocking case.  Let's
> > > say the second connect() fails.  What if we fail to allocate an INADDR_ANY
> > > bhash2 bucket?  We have to change saddr to INADDR_ANY but cannot.... but
> > > the connect() actually failed....??
> > >
> > >   >>> s4.connect(('0.0.0.1', 1))
> > >   Traceback (most recent call last):
> > >     File "<stdin>", line 1, in <module>
> > >   ConnectionRefusedError: [Errno 111] Connection refused
> > >   >>> s4
> > >   <socket.socket fd=3, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=('0.0.0.0', 10000)>
> > >
> > >
> > > Now, I'm thinking bhash2 bucket needs a refcnt not to be freed while
> > > refcnt is greater than 1.  And we need to change the conflict logic
> > > so that the kernel ignores empty bhash2 bucket.  Such changes could
> > > be big for the net tree, but the next LTS will likely be v6.1 which
> > > has bhash2.
> > >
> > > What do you think is the best way to fix the issue?
> >
> > To summarize your analysis, there is an issue right now where for
> > sockets that are binded on address INADDR_ANY,  we need to handle the
> > error case where if a connection fails and SOCK_BINDPORT_LOCK is held,
> > the new address it was assigned needs to be taken out of bhash2 and
> > the original address (INADDR_ANY) needs to be re-added to bhash2.
> > There are two of these error cases we need to handle,  as you
> > mentioned above - 1) in dccp/tcp_v4_connect() where the connect call
> > fails and 2) in __inet_stream_connect() where the connect call
> > succeeds but the connection is closed by a RST/timeout/ICMP error.
> >
> > I think the simplest solution is to modify inet_bhash2_update_saddr()
> > so that we don't free the inet_bind2_bucket() for INADDR_ANY/port (if
> > it is empty after we update the saddr to the new addr) *until* the
> > connect succeeds. When the connect succeeds, then we can check whether
> > the inet_bind2_bucket for INADDR_ANY is empty, and if it is, then do
> > the freeing for it.
> >
> > What are your thoughts on this?
>
> I was thinking the same, but this scenario will break it ?
>
>   connect() <-- unblocking socket
>     return -EINPROGRESS
>
>   receive SYN+ACK, send back ACK, and set state to TCP_ESTABLISEHD
>
>   free the old INADDR_ANY bucket
>
>   get RST and set state to TCP_CLOSE
>
>   connect()
>     goto sock_error and ->disconect() fail to restore the bucket
>

I don't think this scenario will break it because after a successful
connect call, a disconnect will remove the socket from the bhash (and
bhash2) table altogether since the socket will *not* have
SOCK_BINDPORT_LOCK set.

This is the code path I'm looking at:

connect call is successful and the three way handshake has completed
-> tcp_v4_syn_recv_sock() is called where we create the new socket
tcp_v4_syn_recv_sock() -> tcp_create_openreq_child() ->
inet_csk_clone_lock() -> sk_clone_lock()

In sk_clone_lock(), we create a newsk where newsk->sk_userlocks will
*not* have the SOCK_BINDPORT_LOCK flag set (newsk->sk_userlocks =
sk->sk_userlocks & ~SOCK_BINDPORT_LOCK;).

If the connection gets closed by a RST/timeout/ICMP error, then this
socket will go through disconnect() where in the disconnect call, it
will remove the socket from the bhash and bhash2 tables. For example,
for tcp, this code path is tcp_disconnect() -> tcp_set_state(sk,
TCP_CLOSE) -> inet_put_port() - this is also verified by the
"WARN_ON(inet->inet_num && !icsk->icsk_bind_hash);" at the end of
tcp_disconnect().

What are your thoughts?

>
> >
> > Thank you.
> >
> > >
> > > Thank you.
> > >
> > >
> > > ---8<---
> > > diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
> > > index 713b7b8dad7e..40640c26680e 100644
> > > --- a/net/dccp/ipv4.c
> > > +++ b/net/dccp/ipv4.c
> > > @@ -157,6 +157,8 @@ int dccp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
> > >          * This unhashes the socket and releases the local port, if necessary.
> > >          */
> > >         dccp_set_state(sk, DCCP_CLOSED);
> > > +       if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> > > +               inet_reset_saddr(sk);
> > >         ip_rt_put(rt);
> > >         sk->sk_route_caps = 0;
> > >         inet->inet_dport = 0;
> > > diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
> > > index e57b43006074..626166cb6d7e 100644
> > > --- a/net/dccp/ipv6.c
> > > +++ b/net/dccp/ipv6.c
> > > @@ -985,6 +985,8 @@ static int dccp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
> > >
> > >  late_failure:
> > >         dccp_set_state(sk, DCCP_CLOSED);
> > > +       if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> > > +               inet_reset_saddr(sk);
> > >         __sk_dst_reset(sk);
> > >  failure:
> > >         inet->inet_dport = 0;
> > > diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> > > index 7a250ef9d1b7..834245da1e95 100644
> > > --- a/net/ipv4/tcp_ipv4.c
> > > +++ b/net/ipv4/tcp_ipv4.c
> > > @@ -343,6 +343,8 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
> > >          * if necessary.
> > >          */
> > >         tcp_set_state(sk, TCP_CLOSE);
> > > +       if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> > > +               inet_reset_saddr(sk);
> > >         ip_rt_put(rt);
> > >         sk->sk_route_caps = 0;
> > >         inet->inet_dport = 0;
> > > diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> > > index 2a3f9296df1e..81b396e5cf79 100644
> > > --- a/net/ipv6/tcp_ipv6.c
> > > +++ b/net/ipv6/tcp_ipv6.c
> > > @@ -359,6 +359,8 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
> > >
> > >  late_failure:
> > >         tcp_set_state(sk, TCP_CLOSE);
> > > +       if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> > > +               inet_reset_saddr(sk);
> > >  failure:
> > >         inet->inet_dport = 0;
> > >         sk->sk_route_caps = 0;
> > > ---8<---
