Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEEF5210290
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 05:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbgGADhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 23:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgGADhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 23:37:04 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18385C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 20:37:04 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id s1so11229886ybo.7
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 20:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s3Jq5zLzpbl6Zv3uYHByFe0ZmS4s3FezoDHzT/nIYcQ=;
        b=MKVnDFITxci7XZwoiI2Qwlr/n6NcWOarH7ex0rhrRXAfYSXZBOstF2ROLvMxeiCDkc
         UvKCz9Vdfr3s6ws1b6KY39kujwl9Y+TbQTAKz56nj1bk/C9IF2K6EBy38VjZXAulUqWK
         AXJ4iNasKw/tA0z0uJKYC562PRFKvOkQYrCA1z5o3WqyeBxbM9+1OvbWg8a6pnJX07jK
         wYkVEeKcmJ5kTb8zi2yOJlT3dY3ns0Df9MbjnkETH48l7DsBe6CveAhPuY/etE2WmxRB
         CvSJ+ybMGJjV86LvWAFyYC/wRUypUW7ajimzh0ksVFxcPavrKl8HATU2xMMdOdfj2nPA
         hpEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s3Jq5zLzpbl6Zv3uYHByFe0ZmS4s3FezoDHzT/nIYcQ=;
        b=cXyIzegNid+gGjzHFDRRVCKvi8gRm5lwD6KEXMf2ywqh/9n3YWQtymAxOOzZ/LCSZ7
         nKZUuyK3Op96wlZjMtLyFuGYs5IPi/6hKqn7JMQXr6c9+44pY0ucIy6Sy7jb+kXI7Yas
         ZOT0KI9bqilbTztRhc0+r/aIOxYVmGDtfMSd9+W6X8GGjxo+xCfpfNESQvoDtZKR+61Y
         Waiwu6UUjaTv99ZSJC0mmJKdvXvFqhIn/U5RRXkhhOV/zKCKaLyo1txyw2zx0tkkFMrh
         EWLwORGi9ObA5GEeOM1Z5WILUdhAXzcIcvmxRjOPpNsv+2OWv2BR6KdFKZ9g+74KpNRt
         7ceQ==
X-Gm-Message-State: AOAM5326Ppnd+idXjGKJI779ZPXY/KezkdmCAAvwpdLf7iq6Ut94uoEg
        OTLD9y7xUkNO2w3/Cin4uV/vWDCtLYFxxM9gG8L7AQ==
X-Google-Smtp-Source: ABdhPJzptl+ZwuKHWxBxEUKXN0tTbaalbFddIAtD50sheOjj7wa+/JmdyFI74aYBGH2qjkuBhjY6U5OjoVwYPi/KA6U=
X-Received: by 2002:a25:b7cc:: with SMTP id u12mr23794552ybj.173.1593574623004;
 Tue, 30 Jun 2020 20:37:03 -0700 (PDT)
MIME-Version: 1.0
References: <CANn89iLPqtJG0iESCHF+RcOjo95ukan1oSzjkPjoSJgKpO2wSQ@mail.gmail.com>
 <20200701020211.GA6875@gondor.apana.org.au> <CANn89iKP-evuLxeLo6p_98T+FuJ-J5YaMTRG230nqj3R=43tVA@mail.gmail.com>
 <20200701022241.GA7167@gondor.apana.org.au> <CANn89iLKZQAtpejcLHmOu3dsrGf5eyFfHc8JqoMNYisRPWQ8kQ@mail.gmail.com>
 <20200701025843.GA7254@gondor.apana.org.au>
In-Reply-To: <20200701025843.GA7254@gondor.apana.org.au>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 30 Jun 2020 20:36:51 -0700
Message-ID: <CANn89iKnf6=RFd-XRjPv=qaU8P-LGCBcw6JU5Ywwb16gU2iQqQ@mail.gmail.com>
Subject: Re: [regression] TCP_MD5SIG on established sockets
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Jonathan Rajotte-Julien <joraj@efficios.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 7:59 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Tue, Jun 30, 2020 at 07:30:43PM -0700, Eric Dumazet wrote:
> >
> > I made this clear in the changelog, do we want comments all over the places ?
> > Do not get me wrong, we had this bug for years and suddenly this is a
> > big deal...
>
> I thought you were adding a new pair of smp_rmb/smp_wmb.  If they
> already exist in the code then I agree it's not a big deal.  But
> adding a new pair of bogus smp_Xmb's is bad for maintenance.
>

If I knew so many people were excited about TCP / MD5, I would have
posted all my patches on lkml ;)

Without the smp_wmb() we would still need something to prevent KMSAN
from detecting that we read uninitialized bytes,
if key->keylen is increased.  (initial content of key->key[] is garbage)

Something like this :

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index f111660453241692a17c881dd6dc2910a1236263..c3af8180c7049d5c4987bf5c67e4aff2ed6967c9
100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4033,11 +4033,9 @@ EXPORT_SYMBOL(tcp_md5_hash_skb_data);

 int tcp_md5_hash_key(struct tcp_md5sig_pool *hp, const struct
tcp_md5sig_key *key)
 {
-       u8 keylen = key->keylen;
+       u8 keylen = READ_ONCE(key->keylen); /* paired with
WRITE_ONCE() in tcp_md5_do_add */
        struct scatterlist sg;

-       smp_rmb(); /* paired with smp_wmb() in tcp_md5_do_add() */
-
        sg_init_one(&sg, key->key, keylen);
        ahash_request_set_crypt(hp->md5_req, &sg, NULL, keylen);
        return crypto_ahash_update(hp->md5_req);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 99916fcc15ca0be12c2c133ff40516f79e6fdf7f..0d08e0134335a21d23702e6a5c24a0f2b3c61c6f
100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1114,9 +1114,13 @@ int tcp_md5_do_add(struct sock *sk, const union
tcp_md5_addr *addr,
                /* Pre-existing entry - just update that one. */
                memcpy(key->key, newkey, newkeylen);

-               smp_wmb(); /* pairs with smp_rmb() in tcp_md5_hash_key() */
+               /* Pairs with READ_ONCE() in tcp_md5_hash_key().
+                * Also note that a reader could catch new key->keylen value
+                * but old key->key[], this is the reason we use __GFP_ZERO
+                * at sock_kmalloc() time below these lines.
+                */
+               WRITE_ONCE(key->keylen, newkeylen);

-               key->keylen = newkeylen;
                return 0;
        }

@@ -1132,7 +1136,7 @@ int tcp_md5_do_add(struct sock *sk, const union
tcp_md5_addr *addr,
                rcu_assign_pointer(tp->md5sig_info, md5sig);
        }

-       key = sock_kmalloc(sk, sizeof(*key), gfp);
+       key = sock_kmalloc(sk, sizeof(*key), gfp | __GFP_ZERO);
        if (!key)
                return -ENOMEM;
        if (!tcp_alloc_md5sig_pool()) {
