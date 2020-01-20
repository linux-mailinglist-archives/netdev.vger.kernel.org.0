Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9971143147
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 19:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbgATSLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 13:11:14 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:35238 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgATSLO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 13:11:14 -0500
Received: by mail-lf1-f67.google.com with SMTP id z18so7502lfe.2
        for <netdev@vger.kernel.org>; Mon, 20 Jan 2020 10:11:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=juQIOWYaiehCxzY9D6tCr/6ycr20HOoR4Qc/dDOwnFM=;
        b=thzmVqnxMDbCUR4hcqAnUT7M9EWd5/3jGxRetKNWWTuKozFB1eCQxP8dU9TNRjL1F7
         E9fuQ821857KROYTqtMPKlmUlMS2mlBa9+6rAYQ9DxLK6XfREMi+K8eCryfSbNwhx8/d
         rBQjziVtl7Lf2obhg8DL5huW6N5DTBVBBnXSM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=juQIOWYaiehCxzY9D6tCr/6ycr20HOoR4Qc/dDOwnFM=;
        b=GIH88j/nbiHUTDEpihLutBzwP9nQ3CWwC9e6Cr9r5kjQFpAeEnKCIr0eZojtZGSBeg
         FNc/KR7dx2SDgV7AAIhCWjmttnwCNOUmdT4oTl6Udf0CDpYnGnCBasszShCUnYwQB4JN
         eG6hryvkzW1ePtUWBwtcHojYZEvyDEl69nk55Xpx7jTYlspr3bvj5PJyi6a6U4kHc2M2
         ZbrU6ajw72IaqzW8ScXS2b0v0LF9RbL3IVyMmCZ3+9pa5VQ+rR40lhN4JjsnoGjqS6R4
         GZlTg4ZSIwMXrOeWQDyOmg/WymumLxEVF5gcheWKeroxhlVqMYpLm8K/80zYbBdzr7NU
         7Npw==
X-Gm-Message-State: APjAAAULFTlSbL4V6m4Xqi1V1muQMcWs7OrbSiM5jrSDRw2YuLEc6roI
        jwlu1dLdkEOqu9YMWq3rYfdygQ==
X-Google-Smtp-Source: APXvYqzBNUOUfFlXkUVtq5UagVO5Ak9T84MrvAqqSqZCZ9QOM7wGNxOjqGtHyyP7pBgcOyIQlu38ZQ==
X-Received: by 2002:a19:e30b:: with SMTP id a11mr328450lfh.48.1579543871726;
        Mon, 20 Jan 2020 10:11:11 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id m15sm17524176ljg.4.2020.01.20.10.11.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 10:11:11 -0800 (PST)
References: <20200110105027.257877-1-jakub@cloudflare.com> <20200110105027.257877-3-jakub@cloudflare.com> <5e1a56e630ee1_1e7f2b0c859c45c0c4@john-XPS-13-9370.notmuch> <87muars890.fsf@cloudflare.com> <5e25dc995d7d_74082aaee6e465b441@john-XPS-13-9370.notmuch>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com, Eric Dumazet <edumazet@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCH bpf-next v2 02/11] net, sk_msg: Annotate lockless access to sk_prot on clone
In-reply-to: <5e25dc995d7d_74082aaee6e465b441@john-XPS-13-9370.notmuch>
Date:   Mon, 20 Jan 2020 19:11:10 +0100
Message-ID: <874kwqroap.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 20, 2020 at 06:00 PM CET, John Fastabend wrote:
> Jakub Sitnicki wrote:
>> On Sun, Jan 12, 2020 at 12:14 AM CET, John Fastabend wrote:
>> > Jakub Sitnicki wrote:
>> >> sk_msg and ULP frameworks override protocol callbacks pointer in
>> >> sk->sk_prot, while TCP accesses it locklessly when cloning the listening
>> >> socket.
>> >>
>> >> Once we enable use of listening sockets with sockmap (and hence sk_msg),
>> >> there can be shared access to sk->sk_prot if socket is getting cloned while
>> >> being inserted/deleted to/from the sockmap from another CPU. Mark the
>> >> shared access with READ_ONCE/WRITE_ONCE annotations.
>> >>
>> >> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>> >
>> > In sockmap side I fixed this by wrapping the access in a lock_sock[0]. So
>> > Do you think this is still needed with that in mind? The bpf_clone call
>> > is using sk_prot_creater and also setting the newsk's proto field. Even
>> > if the listening parent sock was being deleted in parallel would that be
>> > a problem? We don't touch sk_prot_creator from the tear down path. I've
>> > only scanned the 3..11 patches so maybe the answer is below. If that is
>> > the case probably an improved commit message would be helpful.
>>
>> I think it is needed. Not because of tcp_bpf_clone or that we access
>> listener's sk_prot_creator from there, if I'm grasping your question.
>>
>> Either way I'm glad this came up. Let's go though my reasoning and
>> verify it. tcp stack accesses the listener sk_prot while cloning it:
>>
>> tcp_v4_rcv
>>   sk = __inet_lookup_skb(...)
>>   tcp_check_req(sk)
>>     inet_csk(sk)->icsk_af_ops->syn_recv_sock
>>       tcp_v4_syn_recv_sock
>>         tcp_create_openreq_child
>>           inet_csk_clone_lock
>>             sk_clone_lock
>>               READ_ONCE(sk->sk_prot)
>>
>> It grabs a reference to the listener, but doesn't grab the sk_lock.
>>
>> On another CPU we can be inserting/removing the listener socket from the
>> sockmap and writing to its sk_prot. We have the update and the remove
>> path:
>>
>> sock_map_ops->map_update_elem
>>   sock_map_update_elem
>>     sock_map_update_common
>>       sock_map_link_no_progs
>>         tcp_bpf_init
>>           tcp_bpf_update_sk_prot
>>             sk_psock_update_proto
>>               WRITE_ONCE(sk->sk_prot, ops)
>>
>> sock_map_ops->map_delete_elem
>>   sock_map_delete_elem
>>     __sock_map_delete
>>      sock_map_unref
>>        sk_psock_put
>>          sk_psock_drop
>>            sk_psock_restore_proto
>>              tcp_update_ulp
>>                WRITE_ONCE(sk->sk_prot, proto)
>>
>> Following the guidelines from KTSAN project [0], sk_prot looks like a
>> candidate for annotating it. At least on these 3 call paths.
>>
>> If that sounds correct, I can add it to the patch description.
>>
>> Thanks,
>> -jkbs
>>
>> [0] https://github.com/google/ktsan/wiki/READ_ONCE-and-WRITE_ONCE
>
> Hi Jakub, can push this to bpf tree as well? There is another case
> already in-kernel where this is needed. If the map is removed while
> a recvmsg is in flight.
>
>  tcp_bpf_recvmsg()
>   psock = sk_psock_get(sk)                         <- refcnt 2
>   lock_sock(sk);
>   ...
>                                   sock_map_free()  <- refcnt 1
>   release_sock(sk)
>   sk_psock_put()                                   <- refcnt 0
>
> Then can you add this diff as well I got a bit too carried away
> with that. If your busy I can do it as well if you want. Thanks!

Hi John, I get the race between map_free and tcp_bpf_recvmsg, and how we
end up dropping psock on a path where we don't hold the sock lock. What
a rare case, since we don't destory maps that often usually.

However, I'm not sure I follow where shared lockless access to
sk->sk_prot is in this case?

Perhaps between drop path:

sk_psock_put
  sk_psock_drop
    sk_psock_restore_proto
      WRITE_ONCE(sk->sk_prot, proto)

... and update path where we grab sk_callback_lock a little too late,
that is after updating the proto?

sock_map_update_common
  sock_map_link
    tcp_bpf_init
      tcp_bpf_update_sk_prot
        sk_psock_update_proto
          WRITE_ONCE(sk->sk_prot, ops)

I'm getting v3 ready to post, so happy to help you spin these bits.
I'll need to do it with a fresh head tomorrow, though.

If I don't see any patches from you hit the ML, I'll split out the
chunks that annotate sk_prot access in sk_psock_{retore,update}_proto
and post them together with the revert you suggested below.

-jkbs

>
> diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> index 3866d7e20c07..ded2d5227678 100644
> --- a/net/core/skmsg.c
> +++ b/net/core/skmsg.c
> @@ -594,8 +594,6 @@ EXPORT_SYMBOL_GPL(sk_psock_destroy);
>
>  void sk_psock_drop(struct sock *sk, struct sk_psock *psock)
>  {
> -       sock_owned_by_me(sk);
> -
>         sk_psock_cork_free(psock);
>         sk_psock_zap_ingress(psock);
