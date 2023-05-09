Return-Path: <netdev+bounces-1083-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EAD566FC1F1
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 10:49:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 48F6D281065
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 08:49:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49FB953B4;
	Tue,  9 May 2023 08:49:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3695A20F7
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 08:49:11 +0000 (UTC)
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C132513D
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 01:49:09 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id d75a77b69052e-3f38a9918d1so82401cf.1
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 01:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683622149; x=1686214149;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SeRxELS8qIjBTYrcpZnB1X1j3TrucBUD8133KsTjuD0=;
        b=J7rTPo5WPBvirUCq2C43CE05bGXLkfhqw9+w4GkAzOkoRVeQYV0dfiNZiXzU/adOuV
         MDMnys34Wi8AuXFcl+MVjaGMPh45JfXlCtueEY0b5xY/ySheguUmEPS8gv8CcrBs65zZ
         AUmZbx9SwoVYKXWBnngTgcp6FcsVZ6rjRGV/u92iLkDhMmxe7wGT4rHnJUYWywtpI8q8
         xycCI0mR59EInD2D/PjSQEKCqX+F1sMQgQ5kZfZaZub6jRlMGuZIrUzHKIsWup0SdU2c
         Qx1GtQG9PQEY3RX/usieecSr8QH+bjakMQ1aHbfhua1mxE61/o+DzZrdp3EkSYW/CUGu
         c27A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683622149; x=1686214149;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SeRxELS8qIjBTYrcpZnB1X1j3TrucBUD8133KsTjuD0=;
        b=QCha1fURbJ/f5Lw1m+VSTEXTCY7Y17PGqrlw/8JST4AMOp5UIK5KiFahOu2HJW33DO
         sqTYvR0gTaBNoOucUVguTPNhRr3b+WD0tk6sK7PbI0hkKY4Lsf3LMvvZkD6dQ+Y9xJif
         8Ujn7l4FXZreo0povnD8GvZ2Kw24ctzVdiWJ1SaPglHQ8BfnRmk8eFoJOb/QcZ9aatjS
         LLuUSpATYdLeaax87xCE54krFd5qur4Xi4QRgWnDJ5qNgamkiS0JoveC/KCsazqFZ1oS
         HKBjYwHbBCHMiFXn9oHs6Qnac2FhCsWst/UuOzieF8BPVqwTWLY/3zKir/JHOTqMl5p8
         iShg==
X-Gm-Message-State: AC+VfDyWIHpSBEyskW9PslRfdADY2xZxb33HnGzrAjMkQxZULC0ZJPvr
	z6QjLL9v19BnidStFPYoIsZcnemnc7OgeMy1s9Mjwg==
X-Google-Smtp-Source: ACHHUZ7ANfU8FOLaB30QubqDDjynHLlOH3WuGWotFj8rV0lgj56qrjxpvsNSdNHsJxGDA/p3YqmNiyh+QSDw706ieSg=
X-Received: by 2002:a05:622a:1a11:b0:3ef:302c:319e with SMTP id
 f17-20020a05622a1a1100b003ef302c319emr320442qtb.8.1683622148647; Tue, 09 May
 2023 01:49:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230508020801.10702-1-cathy.zhang@intel.com> <20230508020801.10702-2-cathy.zhang@intel.com>
In-Reply-To: <20230508020801.10702-2-cathy.zhang@intel.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 9 May 2023 10:48:57 +0200
Message-ID: <CANn89iJBStfwej_SO3xZq32P0+jHcaPgxY9ZBk-y8p6ZbHeWZA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper size
To: Cathy Zhang <cathy.zhang@intel.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, 
	jesse.brandeburg@intel.com, suresh.srinivas@intel.com, tim.c.chen@intel.com, 
	lizhen.you@intel.com, eric.dumazet@gmail.com, netdev@vger.kernel.org, 
	Shakeel Butt <shakeelb@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 8, 2023 at 4:08=E2=80=AFAM Cathy Zhang <cathy.zhang@intel.com> =
wrote:
>
> Before commit 4890b686f408 ("net: keep sk->sk_forward_alloc as small as
> possible"), each TCP can forward allocate up to 2 MB of memory and
> tcp_memory_allocated might hit tcp memory limitation quite soon. To
> reduce the memory pressure, that commit keeps sk->sk_forward_alloc as
> small as possible, which will be less than 1 page size if SO_RESERVE_MEM
> is not specified.
>
> However, with commit 4890b686f408 ("net: keep sk->sk_forward_alloc as
> small as possible"), memcg charge hot paths are observed while system is
> stressed with a large amount of connections. That is because
> sk->sk_forward_alloc is too small and it's always less than
> sk->truesize, network handlers like tcp_rcv_established() should jump to
> slow path more frequently to increase sk->sk_forward_alloc. Each memory
> allocation will trigger memcg charge, then perf top shows the following
> contention paths on the busy system.
>
>     16.77%  [kernel]            [k] page_counter_try_charge
>     16.56%  [kernel]            [k] page_counter_cancel
>     15.65%  [kernel]            [k] try_charge_memcg
>
> In order to avoid the memcg overhead and performance penalty,
> sk->sk_forward_alloc should be kept with a proper size instead of as
> small as possible. Keep memory up to 64KB from reclaims when uncharging
> sk_buff memory, which is closer to the maximum size of sk_buff. It will
> help reduce the frequency of allocating memory during TCP connection.
> The original reclaim threshold for reserved memory per-socket is 2MB, so
> the extraneous memory reserved now is about 32 times less than before
> commit 4890b686f408 ("net: keep sk->sk_forward_alloc as small as
> possible").
>
> Run memcached with memtier_benchamrk to verify the optimization fix. 8
> server-client pairs are created with bridge network on localhost, server
> and client of the same pair share 28 logical CPUs.
>
> Results (Average for 5 run)
> RPS (with/without patch)        +2.07x
>
> Fixes: 4890b686f408 ("net: keep sk->sk_forward_alloc as small as possible=
")
>
> Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>
> Signed-off-by: Lizhen You <lizhen.you@intel.com>
> Tested-by: Long Tao <tao.long@intel.com>
> Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
> Reviewed-by: Suresh Srinivas <suresh.srinivas@intel.com>
> ---


I disagree.

Memcg folks have solved this issue already.

CC Shakeel

64KB per socket is too much, some of us have 10 million tcp sockets per hos=
t.


>  include/net/sock.h | 23 ++++++++++++++++++++++-
>  1 file changed, 22 insertions(+), 1 deletion(-)
>
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 8b7ed7167243..6d2960479a80 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -1657,12 +1657,33 @@ static inline void sk_mem_charge(struct sock *sk,=
 int size)
>         sk->sk_forward_alloc -=3D size;
>  }
>
> +/* The following macro controls memory reclaiming in sk_mem_uncharge().
> + */
> +#define SK_RECLAIM_THRESHOLD   (1 << 16)
>  static inline void sk_mem_uncharge(struct sock *sk, int size)
>  {
> +       int reclaimable;
> +
>         if (!sk_has_account(sk))
>                 return;
>         sk->sk_forward_alloc +=3D size;
> -       sk_mem_reclaim(sk);
> +
> +       reclaimable =3D sk->sk_forward_alloc - sk_unused_reserved_mem(sk)=
;
> +
> +       /* Reclaim memory to reduce memory pressure when multiple sockets
> +        * run in parallel. However, if we reclaim all pages and keep
> +        * sk->sk_forward_alloc as small as possible, it will cause
> +        * paths like tcp_rcv_established() going to the slow path with
> +        * much higher rate for forwarded memory expansion, which leads
> +        * to contention hot points and performance drop.
> +        *
> +        * In order to avoid the above issue, it's necessary to keep
> +        * sk->sk_forward_alloc with a proper size while doing reclaim.
> +        */
> +       if (reclaimable > SK_RECLAIM_THRESHOLD) {
> +               reclaimable -=3D SK_RECLAIM_THRESHOLD;
> +               __sk_mem_reclaim(sk, reclaimable);
> +       }
>  }
>
>  /*
> --
> 2.34.1
>

