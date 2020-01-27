Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7129214A0F1
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 10:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729611AbgA0Jgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 04:36:36 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:39475 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729506AbgA0Jgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 04:36:36 -0500
Received: by mail-lf1-f66.google.com with SMTP id t23so5701364lfk.6
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 01:36:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=QJT3RA54pYoMv11EwgiQ3cf4HUn1FlplARMZYfyLOY8=;
        b=yq4IGmrv35vm79mS4l0yxLdNNAvhg1TuR1kxDCeuQuRt5/R6M0IutyKGj7nVbzQPgo
         ekfTQ+SqNr5mtUcG3xnVBdPCD/8Y7fBvoUOjT0BxU34+vgcVMFt7auA7YjKq38jFfcyv
         6ORSHau7UyRIQJhg4jOJPHXGF5EoPBUhsp4p0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=QJT3RA54pYoMv11EwgiQ3cf4HUn1FlplARMZYfyLOY8=;
        b=CDh3CATixww6pzXiNh8MY8U62g4xiwPvwqsQZ9if5jDBLQlkVeA/xDd1klfs1GCdBj
         hLDqkGTn6sDuMLYTZMp31G2cmG2z7EERoEmW4ThLuEKfJTATYNU2t6nityzns/BWQs3l
         ppyR1JwWbcgCFlcERF4tQuvRV0yvySuNIKZ43ieD/eXKTbOkgV0Hab4Hn0HtD5XCIT7I
         aRmPhfU6J+alKdeK2RK/p5aIjzlsCZgmWjJ+0d0vsPFmXYO0LmROPhLSq2NTi6k2qLDD
         W4FhiW1ACyZVM1wOBCR8XJfdseFJTmsP4sDCw+HufkFyWDuh4Hu+Piph0Ftmoooc0YXp
         ZE5A==
X-Gm-Message-State: APjAAAXm5uSBsL/gWRTP6PIPJlx+ZFWqLCq8e98cdm5t2YnMzKVzs6cn
        1rQCcZgg1+R7Bb8M4hPLIQ3iY9+sy4mRdw==
X-Google-Smtp-Source: APXvYqx2ZPrHK9EbYUN8/bJv6wgzsdBS4ufy0OU9V4HAeSDlJVKKOe6qze/mDYxIiRKG4seDoaFGnQ==
X-Received: by 2002:a19:c205:: with SMTP id l5mr7520755lfc.159.1580117794136;
        Mon, 27 Jan 2020 01:36:34 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id b17sm7772447ljd.5.2020.01.27.01.36.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 01:36:33 -0800 (PST)
References: <20200123155534.114313-1-jakub@cloudflare.com> <20200123155534.114313-3-jakub@cloudflare.com> <a6bf279e-a998-84ab-4371-cd6c1ccbca5d@gmail.com> <874kwm2e8a.fsf@cloudflare.com> <5e29f0caaec93_5aac2ad03f6d65c09b@john-XPS-13-9370.notmuch>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Lorenz Bauer <lmb@cloudflare.com>, Martin Lau <kafai@fb.com>
Subject: Re: [PATCH bpf-next v4 02/12] net, sk_msg: Annotate lockless access to sk_prot on clone
In-reply-to: <5e29f0caaec93_5aac2ad03f6d65c09b@john-XPS-13-9370.notmuch>
Date:   Mon, 27 Jan 2020 10:36:32 +0100
Message-ID: <87k15dckbj.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 23, 2020 at 08:15 PM CET, John Fastabend wrote:
> Jakub Sitnicki wrote:
>> On Thu, Jan 23, 2020 at 06:18 PM CET, Eric Dumazet wrote:
>> > On 1/23/20 7:55 AM, Jakub Sitnicki wrote:
>> >> sk_msg and ULP frameworks override protocol callbacks pointer in
>> >> sk->sk_prot, while tcp accesses it locklessly when cloning the listening
>> >> socket, that is with neither sk_lock nor sk_callback_lock held.
>> >>
>> >> Once we enable use of listening sockets with sockmap (and hence sk_msg),
>> >> there will be shared access to sk->sk_prot if socket is getting cloned
>> >> while being inserted/deleted to/from the sockmap from another CPU:
>
> [...]
>
>> >>  include/linux/skmsg.h | 3 ++-
>> >>  net/core/sock.c       | 5 +++--
>> >>  net/ipv4/tcp_bpf.c    | 4 +++-
>> >>  net/ipv4/tcp_ulp.c    | 3 ++-
>> >>  net/tls/tls_main.c    | 3 ++-
>> >>  5 files changed, 12 insertions(+), 6 deletions(-)
>> >>
>> >> diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
>> >> index 41ea1258d15e..55c834a5c25e 100644
>> >> --- a/include/linux/skmsg.h
>> >> +++ b/include/linux/skmsg.h
>> >> @@ -352,7 +352,8 @@ static inline void sk_psock_update_proto(struct sock *sk,
>> >>  	psock->saved_write_space = sk->sk_write_space;
>> >>
>> >>  	psock->sk_proto = sk->sk_prot;
>> >> -	sk->sk_prot = ops;
>> >> +	/* Pairs with lockless read in sk_clone_lock() */
>> >> +	WRITE_ONCE(sk->sk_prot, ops);
>> >
>> >
>> > Note there are dozens of calls like
>> >
>> > if (sk->sk_prot->handler)
>> >     sk->sk_prot->handler(...);
>> >
>> > Some of them being done lockless.
>> >
>> > I know it is painful, but presumably we need
>
> Correct.
>
>> >
>> > const struct proto *ops = READ_ONCE(sk->sk_prot);
>> >
>> > if (ops->handler)
>> >     ops->handler(....);

[...]

>>
>> Considering these are lacking today, can I do it as a follow up?
>
> In my opinion yes. I think pulling your patches in is OK and I started
> doing this conversion already so we can have a fix shortly. I didn't
> want to push it into rc7 though so I'll push it next week or into
> net-next tree.

Thanks, John. I'll take a look if there is any access to sk_prot, apart
from the clone path, applicable only to TCP listening sockets that needs
annotating.
