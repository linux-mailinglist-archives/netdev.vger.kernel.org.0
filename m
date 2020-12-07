Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B652D15EB
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 17:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbgLGQ0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 11:26:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58682 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725832AbgLGQ0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 11:26:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607358317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1D3JIzobwKk9i7LVUpI3dNGISxtvGHPzfqVPE78YWk8=;
        b=dajHc3hRZ3AopkjGwesvhZ0BiBcBdRfrNPAMl6rtKDMoaIJsoyqYGu9jJftWu9loGRJ/Df
        21Kun8+7TTyYlwMhsDUgduWT/x/kBQP/uuOGLzfu3gczuOWJts1iBk7P5wl2ss6Nu8hagS
        HGpJ2dTU4mgm9AiOHfr1teEf14AC1Pg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-537-mkTbvSUcO9GkVEHEfa8fBQ-1; Mon, 07 Dec 2020 11:25:13 -0500
X-MC-Unique: mkTbvSUcO9GkVEHEfa8fBQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F1A2E802B42;
        Mon,  7 Dec 2020 16:25:09 +0000 (UTC)
Received: from llong.remote.csb (ovpn-118-86.rdu2.redhat.com [10.10.118.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 414565D6AB;
        Mon,  7 Dec 2020 16:25:08 +0000 (UTC)
Subject: Re: [PATCH v2 bpf-next 03/13] Revert "locking/spinlocks: Remove the
 unused spin_lock_bh_nested() API"
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201207132456.65472-1-kuniyu@amazon.co.jp>
 <20201207132456.65472-4-kuniyu@amazon.co.jp>
From:   Waiman Long <longman@redhat.com>
Organization: Red Hat
Message-ID: <541e72f2-f836-1534-cd86-f3f0a13074a7@redhat.com>
Date:   Mon, 7 Dec 2020 11:25:07 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201207132456.65472-4-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/7/20 8:24 AM, Kuniyuki Iwashima wrote:
> This reverts commit 607904c357c61adf20b8fd18af765e501d61a385 to use
> spin_lock_bh_nested() in the next commit.
>
> Link: https://lore.kernel.org/netdev/9d290a57-49e1-04cd-2487-262b0d7c5844@gmail.com/
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> CC: Waiman Long <longman@redhat.com>

If there is a use case for spin_lock_bh_nested(), it is perfectly fine 
to add it back.

Acked-by: Waiman Long <longman@redhat.com>

> ---
>   include/linux/spinlock.h         | 8 ++++++++
>   include/linux/spinlock_api_smp.h | 2 ++
>   include/linux/spinlock_api_up.h  | 1 +
>   kernel/locking/spinlock.c        | 8 ++++++++
>   4 files changed, 19 insertions(+)
>
> diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
> index 79897841a2cc..c020b375a071 100644
> --- a/include/linux/spinlock.h
> +++ b/include/linux/spinlock.h
> @@ -227,6 +227,8 @@ static inline void do_raw_spin_unlock(raw_spinlock_t *lock) __releases(lock)
>   #ifdef CONFIG_DEBUG_LOCK_ALLOC
>   # define raw_spin_lock_nested(lock, subclass) \
>   	_raw_spin_lock_nested(lock, subclass)
> +# define raw_spin_lock_bh_nested(lock, subclass) \
> +	_raw_spin_lock_bh_nested(lock, subclass)
>   
>   # define raw_spin_lock_nest_lock(lock, nest_lock)			\
>   	 do {								\
> @@ -242,6 +244,7 @@ static inline void do_raw_spin_unlock(raw_spinlock_t *lock) __releases(lock)
>   # define raw_spin_lock_nested(lock, subclass)		\
>   	_raw_spin_lock(((void)(subclass), (lock)))
>   # define raw_spin_lock_nest_lock(lock, nest_lock)	_raw_spin_lock(lock)
> +# define raw_spin_lock_bh_nested(lock, subclass)	_raw_spin_lock_bh(lock)
>   #endif
>   
>   #if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
> @@ -369,6 +372,11 @@ do {								\
>   	raw_spin_lock_nested(spinlock_check(lock), subclass);	\
>   } while (0)
>   
> +#define spin_lock_bh_nested(lock, subclass)			\
> +do {								\
> +	raw_spin_lock_bh_nested(spinlock_check(lock), subclass);\
> +} while (0)
> +
>   #define spin_lock_nest_lock(lock, nest_lock)				\
>   do {									\
>   	raw_spin_lock_nest_lock(spinlock_check(lock), nest_lock);	\
> diff --git a/include/linux/spinlock_api_smp.h b/include/linux/spinlock_api_smp.h
> index 19a9be9d97ee..d565fb6304f2 100644
> --- a/include/linux/spinlock_api_smp.h
> +++ b/include/linux/spinlock_api_smp.h
> @@ -22,6 +22,8 @@ int in_lock_functions(unsigned long addr);
>   void __lockfunc _raw_spin_lock(raw_spinlock_t *lock)		__acquires(lock);
>   void __lockfunc _raw_spin_lock_nested(raw_spinlock_t *lock, int subclass)
>   								__acquires(lock);
> +void __lockfunc _raw_spin_lock_bh_nested(raw_spinlock_t *lock, int subclass)
> +								__acquires(lock);
>   void __lockfunc
>   _raw_spin_lock_nest_lock(raw_spinlock_t *lock, struct lockdep_map *map)
>   								__acquires(lock);
> diff --git a/include/linux/spinlock_api_up.h b/include/linux/spinlock_api_up.h
> index d0d188861ad6..d3afef9d8dbe 100644
> --- a/include/linux/spinlock_api_up.h
> +++ b/include/linux/spinlock_api_up.h
> @@ -57,6 +57,7 @@
>   
>   #define _raw_spin_lock(lock)			__LOCK(lock)
>   #define _raw_spin_lock_nested(lock, subclass)	__LOCK(lock)
> +#define _raw_spin_lock_bh_nested(lock, subclass) __LOCK(lock)
>   #define _raw_read_lock(lock)			__LOCK(lock)
>   #define _raw_write_lock(lock)			__LOCK(lock)
>   #define _raw_spin_lock_bh(lock)			__LOCK_BH(lock)
> diff --git a/kernel/locking/spinlock.c b/kernel/locking/spinlock.c
> index 0ff08380f531..48e99ed1bdd8 100644
> --- a/kernel/locking/spinlock.c
> +++ b/kernel/locking/spinlock.c
> @@ -363,6 +363,14 @@ void __lockfunc _raw_spin_lock_nested(raw_spinlock_t *lock, int subclass)
>   }
>   EXPORT_SYMBOL(_raw_spin_lock_nested);
>   
> +void __lockfunc _raw_spin_lock_bh_nested(raw_spinlock_t *lock, int subclass)
> +{
> +	__local_bh_disable_ip(_RET_IP_, SOFTIRQ_LOCK_OFFSET);
> +	spin_acquire(&lock->dep_map, subclass, 0, _RET_IP_);
> +	LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
> +}
> +EXPORT_SYMBOL(_raw_spin_lock_bh_nested);
> +
>   unsigned long __lockfunc _raw_spin_lock_irqsave_nested(raw_spinlock_t *lock,
>   						   int subclass)
>   {


