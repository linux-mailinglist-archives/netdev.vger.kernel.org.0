Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F13D514305B
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 18:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgATRAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 12:00:17 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:46967 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgATRAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 12:00:16 -0500
Received: by mail-il1-f196.google.com with SMTP id t17so19066ilm.13;
        Mon, 20 Jan 2020 09:00:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=0hF+SQQMzCKRRBNDnvAlt1/TCfoTsNReqxtCw9ixOs0=;
        b=YOwGI3cydRPghL2Fe1/yFF7medVcsZDJmu4HoMhGTN7JpMZAOCNG6qNUE4JRwwsNRr
         UOIZkDYWUomT6Z+kp8gGzS22XNBC6gT6zyHmQ2Gf84bB5FuB2j41uBQ9Y10prosgPc7J
         SR5SCtKltQUTZRa/dLWlp5boPEBrASZPkGDp0qNN6vz/jf1x+V+xIYwv7jgmMM1Xtf9M
         ld6C2NHG8FwEG+DTjQxXNLYSa+QJNcddGvdhffvePqgMgP7hpsw4/ZP9OKQ1gc2ynIBw
         bhnAqA/gaMdmQbUrG+r4/nwa//1sOR6sgpaw/8rqdMJT+EgdhK2bSMT3C3As/9UKT9oZ
         Fz/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=0hF+SQQMzCKRRBNDnvAlt1/TCfoTsNReqxtCw9ixOs0=;
        b=Nom0kbjj/fDWtBwJhZzN3K9rjJhhjRaMxTa9mxFv6jgUP/jJaaVCpVUWr3gWxokJ9T
         s8kwGqYTtZNlYc8u1piobT0+Wa7sOizP0BdgLzowoTI6ONbTgsLNTREhvJjMoiSvy4kB
         +kAF5MHlfztEH7URjCjKVyIjBKMS2V9Q7owxLQFIB1xPkvBGDlMB+/OsxO/3OjZKVkML
         DdtwXVMIVEMQBnqIS7LmJh09pTNFXJa8pq1YdqRQrlgmfe4bGkaii0I9tnBbTra8Xo8I
         6d0BH0Cj8E9yWanHzTUHNuvFefie0F2FH467A+LF2HaQdagdNoSZOiVWL2tXnC/Tswol
         UkXg==
X-Gm-Message-State: APjAAAUTPiQXUtcQ7ODC8UNHjm4LEYz68QsfIm2dB9pBU3tOBTJTtoXF
        DgPT1OSCAyNqj7pAzH+SxWw=
X-Google-Smtp-Source: APXvYqxa19BPkhWM2YyPRzu/WM3PkVenOI/LBf1/9Ech1xIWu2CF36fI6QJNqIrvpeqFe9mtER3Tow==
X-Received: by 2002:a92:2907:: with SMTP id l7mr31009ilg.140.1579539615750;
        Mon, 20 Jan 2020 09:00:15 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id n5sm11970880ila.7.2020.01.20.09.00.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 09:00:15 -0800 (PST)
Date:   Mon, 20 Jan 2020 09:00:09 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com, Eric Dumazet <edumazet@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Message-ID: <5e25dc995d7d_74082aaee6e465b441@john-XPS-13-9370.notmuch>
In-Reply-To: <87muars890.fsf@cloudflare.com>
References: <20200110105027.257877-1-jakub@cloudflare.com>
 <20200110105027.257877-3-jakub@cloudflare.com>
 <5e1a56e630ee1_1e7f2b0c859c45c0c4@john-XPS-13-9370.notmuch>
 <87muars890.fsf@cloudflare.com>
Subject: Re: [PATCH bpf-next v2 02/11] net, sk_msg: Annotate lockless access
 to sk_prot on clone
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> On Sun, Jan 12, 2020 at 12:14 AM CET, John Fastabend wrote:
> > Jakub Sitnicki wrote:
> >> sk_msg and ULP frameworks override protocol callbacks pointer in
> >> sk->sk_prot, while TCP accesses it locklessly when cloning the listening
> >> socket.
> >>
> >> Once we enable use of listening sockets with sockmap (and hence sk_msg),
> >> there can be shared access to sk->sk_prot if socket is getting cloned while
> >> being inserted/deleted to/from the sockmap from another CPU. Mark the
> >> shared access with READ_ONCE/WRITE_ONCE annotations.
> >>
> >> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> >
> > In sockmap side I fixed this by wrapping the access in a lock_sock[0]. So
> > Do you think this is still needed with that in mind? The bpf_clone call
> > is using sk_prot_creater and also setting the newsk's proto field. Even
> > if the listening parent sock was being deleted in parallel would that be
> > a problem? We don't touch sk_prot_creator from the tear down path. I've
> > only scanned the 3..11 patches so maybe the answer is below. If that is
> > the case probably an improved commit message would be helpful.
> 
> I think it is needed. Not because of tcp_bpf_clone or that we access
> listener's sk_prot_creator from there, if I'm grasping your question.
> 
> Either way I'm glad this came up. Let's go though my reasoning and
> verify it. tcp stack accesses the listener sk_prot while cloning it:
> 
> tcp_v4_rcv
>   sk = __inet_lookup_skb(...)
>   tcp_check_req(sk)
>     inet_csk(sk)->icsk_af_ops->syn_recv_sock
>       tcp_v4_syn_recv_sock
>         tcp_create_openreq_child
>           inet_csk_clone_lock
>             sk_clone_lock
>               READ_ONCE(sk->sk_prot)
> 
> It grabs a reference to the listener, but doesn't grab the sk_lock.
> 
> On another CPU we can be inserting/removing the listener socket from the
> sockmap and writing to its sk_prot. We have the update and the remove
> path:
> 
> sock_map_ops->map_update_elem
>   sock_map_update_elem
>     sock_map_update_common
>       sock_map_link_no_progs
>         tcp_bpf_init
>           tcp_bpf_update_sk_prot
>             sk_psock_update_proto
>               WRITE_ONCE(sk->sk_prot, ops)
> 
> sock_map_ops->map_delete_elem
>   sock_map_delete_elem
>     __sock_map_delete
>      sock_map_unref
>        sk_psock_put
>          sk_psock_drop
>            sk_psock_restore_proto
>              tcp_update_ulp
>                WRITE_ONCE(sk->sk_prot, proto)
> 
> Following the guidelines from KTSAN project [0], sk_prot looks like a
> candidate for annotating it. At least on these 3 call paths.
> 
> If that sounds correct, I can add it to the patch description.
> 
> Thanks,
> -jkbs
> 
> [0] https://github.com/google/ktsan/wiki/READ_ONCE-and-WRITE_ONCE

Hi Jakub, can push this to bpf tree as well? There is another case
already in-kernel where this is needed. If the map is removed while
a recvmsg is in flight.

 tcp_bpf_recvmsg()
  psock = sk_psock_get(sk)                         <- refcnt 2
  lock_sock(sk);
  ...                                
                                  sock_map_free()  <- refcnt 1
  release_sock(sk)
  sk_psock_put()                                   <- refcnt 0

Then can you add this diff as well I got a bit too carried away
with that. If your busy I can do it as well if you want. Thanks!

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 3866d7e20c07..ded2d5227678 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -594,8 +594,6 @@ EXPORT_SYMBOL_GPL(sk_psock_destroy);
 
 void sk_psock_drop(struct sock *sk, struct sk_psock *psock)
 {
-       sock_owned_by_me(sk);
-
        sk_psock_cork_free(psock);
        sk_psock_zap_ingress(psock);
