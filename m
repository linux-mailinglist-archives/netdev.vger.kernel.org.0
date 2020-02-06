Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 374B0153E5E
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 06:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbgBFFvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 00:51:51 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46342 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbgBFFvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 00:51:51 -0500
Received: by mail-pf1-f194.google.com with SMTP id k29so2466612pfp.13;
        Wed, 05 Feb 2020 21:51:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=62nu+m88CACCByWb3L9kOXlT3y3+3IilGWM/r5Z4UkY=;
        b=sZu1TXalbNiz04Ls1xB48vzXTghfXwELfCUhuxa9m6Sp5NHG5Ui5lm4MhffeJCNOfC
         C7n3bzWglGDJ8861jkmuYLpvh71TDmCDmnLt0d3iNDNTMfSCTQ3BJ5K+fBuzL3dW4C+0
         /nTdZVuLhb2A/dMQ4ddrlW4RyF038M0DDLHPQI6IWvBv+3S/marrcqgqaheR673vLO5d
         irxP2Qq5MDr2jUznlVzKOOCGiKHUHOlpTy6RzBCq1E5ygFrZMzwcJsJjgXV1yOY5rzNE
         ZmqKBLWTyZ8PT48lrt7FSMiWyCWqytmAmQastZ6RUFTzGseL8O1Vu+QAekI2gRoLlnDl
         1yoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=62nu+m88CACCByWb3L9kOXlT3y3+3IilGWM/r5Z4UkY=;
        b=nUo3UO6X0MGKy6cKsy1wShWFMrqr7xstcPOWI3Azrs0D6fi2RK7Ip3CxMjYj83rwov
         EN0NEATuAXTHq78hXD8hLslKLwwI80BroAArGpg61cAiYdp8KbMKdpYYu8N9FNNhX4G+
         k1od3j0P/o96Id0E2Avfbs+C5+QTgPuLD1MFdYTpZm/8aq60M29ta3v4+5KdvUXFEY+c
         +yibRqfyi+EH06oI82jtYAYA4+xl3n5DfLEqqYfZhJupqMHY712zPEtfLG5T0Xe+tUhg
         XY53VwePiF3JhGF/e5qMBNzTEnnPwsacoHwujkv90Xa+D75rjT5NJC+cDA6hOyvgkas4
         MiZw==
X-Gm-Message-State: APjAAAVNlrGnI1N8+BosUGFNob0bdi++d9eqPM0LSJFForuMEvCLi4bJ
        YL6EFinwUQaTGY7+p7TMAB4=
X-Google-Smtp-Source: APXvYqxHJooo/7GvZZWVklkQ12001Rac6lKTO2v7du1fTInc4KqkFK8EWPIj2rmIFO52E8e8f86Bmg==
X-Received: by 2002:a63:df02:: with SMTP id u2mr1695034pgg.403.1580968310381;
        Wed, 05 Feb 2020 21:51:50 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id z26sm1537021pfa.90.2020.02.05.21.51.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 21:51:49 -0800 (PST)
Date:   Wed, 05 Feb 2020 21:51:40 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, song@kernel.org, jonathan.lemon@gmail.com
Message-ID: <5e3ba96ca7889_6b512aafe4b145b812@john-XPS-13-9370.notmuch>
In-Reply-To: <8736boor55.fsf@cloudflare.com>
References: <20200111061206.8028-1-john.fastabend@gmail.com>
 <20200111061206.8028-3-john.fastabend@gmail.com>
 <8736boor55.fsf@cloudflare.com>
Subject: Re: [bpf PATCH v2 2/8] bpf: sockmap, ensure sock lock held during
 tear down
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> On Sat, Jan 11, 2020 at 07:12 AM CET, John Fastabend wrote:
> > The sock_map_free() and sock_hash_free() paths used to delete sockmap
> > and sockhash maps walk the maps and destroy psock and bpf state associated
> > with the socks in the map. When done the socks no longer have BPF programs
> > attached and will function normally. This can happen while the socks in
> > the map are still "live" meaning data may be sent/received during the walk.
> >
> > Currently, though we don't take the sock_lock when the psock and bpf state
> > is removed through this path. Specifically, this means we can be writing
> > into the ops structure pointers such as sendmsg, sendpage, recvmsg, etc.
> > while they are also being called from the networking side. This is not
> > safe, we never used proper READ_ONCE/WRITE_ONCE semantics here if we
> > believed it was safe. Further its not clear to me its even a good idea
> > to try and do this on "live" sockets while networking side might also
> > be using the socket. Instead of trying to reason about using the socks
> > from both sides lets realize that every use case I'm aware of rarely
> > deletes maps, in fact kubernetes/Cilium case builds map at init and
> > never tears it down except on errors. So lets do the simple fix and
> > grab sock lock.
> >
> > This patch wraps sock deletes from maps in sock lock and adds some
> > annotations so we catch any other cases easier.
> >
> > Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
> > Cc: stable@vger.kernel.org
> > Acked-by: Song Liu <songliubraving@fb.com>
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > ---
> >  net/core/skmsg.c    | 2 ++
> >  net/core/sock_map.c | 7 ++++++-
> >  2 files changed, 8 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> > index ded2d5227678..3866d7e20c07 100644
> > --- a/net/core/skmsg.c
> > +++ b/net/core/skmsg.c
> > @@ -594,6 +594,8 @@ EXPORT_SYMBOL_GPL(sk_psock_destroy);
> >
> >  void sk_psock_drop(struct sock *sk, struct sk_psock *psock)
> >  {
> > +	sock_owned_by_me(sk);
> > +
> >  	sk_psock_cork_free(psock);
> >  	sk_psock_zap_ingress(psock);
> >
> > diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> > index eb114ee419b6..8998e356f423 100644
> > --- a/net/core/sock_map.c
> > +++ b/net/core/sock_map.c
> > @@ -241,8 +241,11 @@ static void sock_map_free(struct bpf_map *map)
> >  		struct sock *sk;
> >
> >  		sk = xchg(psk, NULL);
> > -		if (sk)
> > +		if (sk) {
> > +			lock_sock(sk);
> >  			sock_map_unref(sk, psk);
> > +			release_sock(sk);
> > +		}
> >  	}
> >  	raw_spin_unlock_bh(&stab->lock);
> >  	rcu_read_unlock();
> 
> John, I've noticed this is triggering warnings that we might sleep in
> lock_sock while (1) in RCU read-side section, and (2) holding a spin
> lock:

OK, this patch was misguided, it makes things worse rather than better,
the real fix is to do proper READ_ONCE/WRITE_ONCE on the sk ops. That
is coming soon. Thanks for following up on it.

> 
> =============================
> WARNING: suspicious RCU usage
> 5.5.0-04012-g38c811e4cd3c #443 Not tainted
> -----------------------------
> include/linux/rcupdate.h:272 Illegal context switch in RCU read-side critical section!
> 
> other info that might help us debug this:

[...]

> 
> Easy to trigger on a VM with 1 vCPU, reproducer below.

When net-next opens we should add some tests to cover this its not something
I test often because our use case the maps are rarely free'd.

> 
> Here's an idea how to change the locking. I'm still wrapping my head
> around what protects what in sock_map_free, so please bear with me:
> 
> 1. synchronize_rcu before we iterate over the array is not needed,
>    AFAICT. We are not free'ing the map just yet, hence any readers
>    accessing the map via the psock are not in danger of use-after-free.

Agreed. When we added 2bb90e5cc90e ("bpf: sockmap, synchronize_rcu before
free'ing map") we could have done this.

> 
> 2. rcu_read_lock is needed to protect access to psock inside
>    sock_map_unref, but we can't sleep while in RCU read-side.  So push
>    it down, after we grab the sock lock.

yes this looks better.

> 
> 3. Grabbing stab->lock seems not needed, either. We get called from
>    bpf_map_free_deferred, after map refcnt dropped to 0, so we're not
>    racing with any other map user to modify its contents.

This I'll need to think on a bit. We have the link-lock there so
probably should be safe to drop. But will need to trace this through
git history to be sure.

> 
> diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> index 2cbde385e1a0..7f54e0d27d32 100644
> --- a/net/core/sock_map.c
> +++ b/net/core/sock_map.c
> @@ -259,9 +259,6 @@ static void sock_map_free(struct bpf_map *map)
>         struct bpf_stab *stab = container_of(map, struct bpf_stab, map);
>         int i;
> 
> -       synchronize_rcu();
> -       rcu_read_lock();
> -       raw_spin_lock_bh(&stab->lock);
>         for (i = 0; i < stab->map.max_entries; i++) {
>                 struct sock **psk = &stab->sks[i];
>                 struct sock *sk;
> @@ -269,12 +266,12 @@ static void sock_map_free(struct bpf_map *map)
>                 sk = xchg(psk, NULL);
>                 if (sk) {
>                         lock_sock(sk);
> +                       rcu_read_lock();
>                         sock_map_unref(sk, psk);
> +                       rcu_read_unlock();
>                         release_sock(sk);
>                 }
>         }
> -       raw_spin_unlock_bh(&stab->lock);
> -       rcu_read_unlock();
> 
>         synchronize_rcu();
> 
> > @@ -862,7 +865,9 @@ static void sock_hash_free(struct bpf_map *map)
> >  		raw_spin_lock_bh(&bucket->lock);
> >  		hlist_for_each_entry_safe(elem, node, &bucket->head, node) {
> >  			hlist_del_rcu(&elem->node);
> > +			lock_sock(elem->sk);
> >  			sock_map_unref(elem->sk, elem);
> > +			release_sock(elem->sk);
> >  		}
> >  		raw_spin_unlock_bh(&bucket->lock);
> >  	}
> 
> Similar problems here. With one extra that it seems we're missing a
> synchronize_rcu *after* walking over the htable for the same reason as
> it got added to sock_map_free in 2bb90e5cc90e ("bpf: sockmap,
> synchronize_rcu before free'ing map"):
> 
>     We need to have a synchronize_rcu before free'ing the sockmap because
>     any outstanding psock references will have a pointer to the map and
>     when they use this could trigger a use after free.
> 
> WDYT?

Can you push the fix to bpf but leave the stab->lock for now. I think
we can do a slightly better cleanup on stab->lock in bpf-next.

> 
> Reproducer follows.

push reproducer into selftests?

Thanks.
