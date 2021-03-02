Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE23432B3AD
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449918AbhCCEEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:04:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236964AbhCBSYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 13:24:47 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72925C0617A7;
        Tue,  2 Mar 2021 10:23:40 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id o6so2572619pjf.5;
        Tue, 02 Mar 2021 10:23:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bnxJ87u4sbrwdk1LAB30YLXwHUgFDPCGUB44sFI7n1s=;
        b=uI/i8gcpuYmFguZTeZ92j+H6EHouSCIOf1vxo0rFq4INLXiAhldffcUPKE31UyGoXb
         rUieOrPz71RSIdEtfeXFKBHEcSdz3udJzOCuMb9SWQB7nPSl2Opu2gZWX2gWI2Csg43n
         wOiPKKMTmOXkvx8UdE3ZwRVJ++bHYmNN8T7N+ZWZPPDhRkB5EwrJqAko4zd+BNnENLWZ
         8eBPRcoP73a3SZ9es+bzRk6h1UfNzCN2riPte6TT8Pz/+GdHiUqBxmkxkL8ZGtVjkP8Y
         iHUlCcs9AYc86qMy8pGiuCVjvGmoOXJJRnkRVcb/8xSYgBulx4082bpZUzN124KM+Cpr
         nLjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bnxJ87u4sbrwdk1LAB30YLXwHUgFDPCGUB44sFI7n1s=;
        b=sLUOM0roNXK3MespzFIUJ3mHYz4H11cOjoo01SYqZGuFHxIoI4p0Xb6RAOysJ5tyIp
         bgZraxAzvvZt4NZGr4coJcZzcodfI32qQKWcGzLnjKAipFn+kjRiGh+/3CnNv/MGispY
         ydOWtiwb/4sqkHyYTKCxsoBr3J2YzsxtoxGFdppOaaOq+mpc4KRQ5FJVCOZxAuUEho1M
         fNfrVsxQEU78d6dDSi6QDvIyBHnBHcxMVPY+FZv7gHca3/P9+2pbUTWcJepE9WXfQt7D
         N4WeUR4Xke6Z2f620YQP5dYuAqf1ZlQo13zrh0z+xfSs5oqbyDHjFGE1llBeuCWnsc70
         0dOA==
X-Gm-Message-State: AOAM5317/mq4lhozH+GGkQ+PBhca7CpaEUNA9yDhooQZ/+tNgAoSTEfH
        u2W9hPX/j5aABlM/pqmEumn7L7BgFSjfTpJzwHiAhm+bE1rWtw==
X-Google-Smtp-Source: ABdhPJwKMmxE8PKMms10iLp+avFpm/jVT/64xFRltVsfI+uuHTglt6Su1krBT5kTb5KSxtJNLi3qMTCxgNaFQhOHS08=
X-Received: by 2002:a17:90a:ce92:: with SMTP id g18mr5839612pju.52.1614709419796;
 Tue, 02 Mar 2021 10:23:39 -0800 (PST)
MIME-Version: 1.0
References: <20210302023743.24123-1-xiyou.wangcong@gmail.com>
 <20210302023743.24123-3-xiyou.wangcong@gmail.com> <CACAyw9-SjsNn4_J1KDXuFh1nd9Hr-Mo+=7S-kVtooJwdi1fodQ@mail.gmail.com>
In-Reply-To: <CACAyw9-SjsNn4_J1KDXuFh1nd9Hr-Mo+=7S-kVtooJwdi1fodQ@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 2 Mar 2021 10:23:28 -0800
Message-ID: <CAM_iQpXqE9qJ=+zKA6H1Rq=KKgm8LZ=p=ZtvrrH+hfSrTg+zxw@mail.gmail.com>
Subject: Re: [Patch bpf-next v2 2/9] sock: introduce sk_prot->update_proto()
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 2, 2021 at 8:22 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> On Tue, 2 Mar 2021 at 02:37, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> ...
> >  static inline void sk_psock_restore_proto(struct sock *sk,
> >                                           struct sk_psock *psock)
> >  {
> >         sk->sk_prot->unhash = psock->saved_unhash;
>
> Not related to your patch set, but why do an extra restore of
> sk_prot->unhash here? At this point sk->sk_prot is one of our tcp_bpf
> / udp_bpf protos, so overwriting that seems wrong?

Good catch. It seems you are right, but I need a double check. And
yes, it is completely unrelated to my patch, as the current code has
the same problem.

>
> > -       if (inet_csk_has_ulp(sk)) {
> > -               tcp_update_ulp(sk, psock->sk_proto, psock->saved_write_space);
> > -       } else {
> > -               sk->sk_write_space = psock->saved_write_space;
> > -               /* Pairs with lockless read in sk_clone_lock() */
> > -               WRITE_ONCE(sk->sk_prot, psock->sk_proto);
> > -       }
> > +       if (psock->saved_update_proto)
> > +               psock->saved_update_proto(sk, true);
> >  }
> >
> >  static inline void sk_psock_set_state(struct sk_psock *psock,
> > diff --git a/include/net/sock.h b/include/net/sock.h
> > index 636810ddcd9b..0e8577c917e8 100644
> > --- a/include/net/sock.h
> > +++ b/include/net/sock.h
> > @@ -1184,6 +1184,9 @@ struct proto {
> >         void                    (*unhash)(struct sock *sk);
> >         void                    (*rehash)(struct sock *sk);
> >         int                     (*get_port)(struct sock *sk, unsigned short snum);
> > +#ifdef CONFIG_BPF_SYSCALL
> > +       int                     (*update_proto)(struct sock *sk, bool restore);
>
> Kind of a nit, but this name suggests that the callback is a lot more
> generic than it really is. The only thing you can use it for is to
> prep the socket to be sockmap ready since we hardwire sockmap_unhash,
> etc. It's also not at all clear that this only works if sk has an
> sk_psock associated with it. Calling it without one would crash the
> kernel since the update_proto functions don't check for !sk_psock.
>
> Might as well call it install_sockmap_hooks or something and have a
> valid sk_psock be passed in to the callback. Additionally, I'd prefer

For the name, sure, I am always open to better names. Not sure if
'install_sockmap_hooks' is a good name, I also want to express we
are overriding sk_prot. How about 'psock_update_sk_prot'?


> if the function returned a struct proto * like it does at the moment.
> That way we keep sk->sk_prot manipulation confined to the sockmap code
> and don't have to copy paste it into every proto.

Well, TCP seems too special to do this, as it could call tcp_update_ulp()
to update the proto.

>
> > diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> > index 3bddd9dd2da2..13d2af5bb81c 100644
> > --- a/net/core/sock_map.c
> > +++ b/net/core/sock_map.c
> > @@ -184,26 +184,10 @@ static void sock_map_unref(struct sock *sk, void *link_raw)
> >
> >  static int sock_map_init_proto(struct sock *sk, struct sk_psock *psock)
> >  {
> > -       struct proto *prot;
> > -
> > -       switch (sk->sk_type) {
> > -       case SOCK_STREAM:
> > -               prot = tcp_bpf_get_proto(sk, psock);
> > -               break;
> > -
> > -       case SOCK_DGRAM:
> > -               prot = udp_bpf_get_proto(sk, psock);
> > -               break;
> > -
> > -       default:
> > +       if (!sk->sk_prot->update_proto)
> >                 return -EINVAL;
> > -       }
> > -
> > -       if (IS_ERR(prot))
> > -               return PTR_ERR(prot);
> > -
> > -       sk_psock_update_proto(sk, psock, prot);
> > -       return 0;
> > +       psock->saved_update_proto = sk->sk_prot->update_proto;
> > +       return sk->sk_prot->update_proto(sk, false);
>
> I think reads / writes from sk_prot need READ_ONCE / WRITE_ONCE. We've
> not been diligent about this so far, but I think it makes sense to be
> careful in new code.

Hmm, there are many places not using READ_ONCE/WRITE_ONCE,
for a quick example:

void sock_map_unhash(struct sock *sk)
{
        void (*saved_unhash)(struct sock *sk);
        struct sk_psock *psock;

        rcu_read_lock();
        psock = sk_psock(sk);
        if (unlikely(!psock)) {
                rcu_read_unlock();
                if (sk->sk_prot->unhash)
                        sk->sk_prot->unhash(sk);
                return;
        }

        saved_unhash = psock->saved_unhash;
        sock_map_remove_links(sk, psock);
        rcu_read_unlock();
        saved_unhash(sk);
}

Thanks.
