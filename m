Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD8161D3C09
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 21:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730170AbgENTHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 15:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730169AbgENTGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 15:06:54 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B76C061A0C;
        Thu, 14 May 2020 12:06:53 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id j21so1656813pgb.7;
        Thu, 14 May 2020 12:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5o4jBNp9y8OxajJVxff4YMypmeXrQrtAtE1Puv6ZyaQ=;
        b=qHUTovjVnsl7jvTd8JreO1O9BStnBU+RXXBR2wvfJtPplsl6ZtjV936w0hZNPHAI0J
         KElcC8VtBNarXthpGoFsQVighWghAWjrQG56JduwUDERHc6un39zs7swtVj9yKKdOdAO
         L3/EZOt+zAy0dP5bgC4xWCHsTzEQ+HMlm4FdKKZOmZjCnFoNX9835ff2CuidtoyxRLK7
         DSeVtmxtdzdTL7y3JehjxJ04VG8lCD8Uym9wAj/iQq+Xs8YpqYlORNOAnSthLYWwH5fr
         VVpzSaLYi3bY8a64ITH+M6bjKN91iBge+6wMZ6B+ZRNMNg3gp8rLDLG1HnJhA0Y5BJm1
         mI0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5o4jBNp9y8OxajJVxff4YMypmeXrQrtAtE1Puv6ZyaQ=;
        b=fczmRdsUhbg8oWleYfg5YNMgNZZcagvdLJ7cFfL2hkAF52jzZ9HPGIgKKqokaoAeSd
         2/ks1RBkk3WORGGO3agPE1zNcy/9utZ5VBXksKZxk0s7FIgmxitZO/aWp8AjVsCt5u3z
         jco/J6YpxkQqEu6OlBd6TBB+b+FELXVjSbB82+rJwRuTTYaWx8NMx33feJAQP59rIUcG
         21nvzpCRKrnzW05hjjoaTsYH3QtLsgLrvA8kCiGPGIaYKPGOdcee+YSEeP0ORJ42D1VZ
         I/ConjTF+M9RMj6AXMdL4KHP3WK0E5jiyVumaqUPiALxOoce3dfMFVezHyc0vfE8rtjZ
         2n/Q==
X-Gm-Message-State: AOAM533xfH3fIELn0cdtQI/Vh7N4s+1dvb2J3LIl2V/4yM5nw9YbA32n
        jIBxwDJyAbJBgYEUmr8n2j4=
X-Google-Smtp-Source: ABdhPJzj9tM+D/DlQkLfaSgNm9m+0XARxOu61h+r2cl/oE6+dni4LzO+JCbvO7olPj83QSUsgCZuYg==
X-Received: by 2002:a63:1556:: with SMTP id 22mr5477432pgv.307.1589483212751;
        Thu, 14 May 2020 12:06:52 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:4646])
        by smtp.gmail.com with ESMTPSA id a129sm2933182pfb.102.2020.05.14.12.06.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 12:06:51 -0700 (PDT)
Date:   Thu, 14 May 2020 12:06:49 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com,
        kernel-team@fb.com, "Paul E . McKenney" <paulmck@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [PATCH bpf-next 1/6] bpf: implement BPF ring buffer and verifier
 support for it
Message-ID: <20200514190649.ca4qugueh5sp32ax@ast-mbp.dhcp.thefacebook.com>
References: <20200513192532.4058934-1-andriin@fb.com>
 <20200513192532.4058934-2-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513192532.4058934-2-andriin@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 12:25:27PM -0700, Andrii Nakryiko wrote:
> +
> +/* Given pointer to ring buffer record metadata, restore pointer to struct
> + * bpf_ringbuf itself by using page offset stored at offset 4
> + */
> +static struct bpf_ringbuf *bpf_ringbuf_restore_from_rec(void *meta_ptr)
> +{
> +	unsigned long addr = (unsigned long)meta_ptr;
> +	unsigned long off = *(u32 *)(meta_ptr + 4) << PAGE_SHIFT;

Looking at the further code it seems this one should be READ_ONCE, but...

> +
> +	return (void*)((addr & PAGE_MASK) - off);
> +}
> +
> +static void *__bpf_ringbuf_reserve(struct bpf_ringbuf *rb, u64 size)
> +{
> +	unsigned long cons_pos, prod_pos, new_prod_pos, flags;
> +	u32 len, pg_off;
> +	void *meta_ptr;
> +
> +	if (unlikely(size > UINT_MAX))
> +		return NULL;
> +
> +	len = round_up(size + RINGBUF_META_SZ, 8);

it may overflow despite the check above.

> +	cons_pos = READ_ONCE(rb->consumer_pos);
> +
> +	if (in_nmi()) {
> +		if (!spin_trylock_irqsave(&rb->spinlock, flags))
> +			return NULL;
> +	} else {
> +		spin_lock_irqsave(&rb->spinlock, flags);
> +	}
> +
> +	prod_pos = rb->producer_pos;
> +	new_prod_pos = prod_pos + len;
> +
> +	/* check for out of ringbuf space by ensuring producer position
> +	 * doesn't advance more than (ringbuf_size - 1) ahead
> +	 */
> +	if (new_prod_pos - cons_pos > rb->mask) {
> +		spin_unlock_irqrestore(&rb->spinlock, flags);
> +		return NULL;
> +	}
> +
> +	meta_ptr = rb->data + (prod_pos & rb->mask);
> +	pg_off = bpf_ringbuf_rec_pg_off(rb, meta_ptr);
> +
> +	WRITE_ONCE(*(u32 *)meta_ptr, RINGBUF_BUSY_BIT | size);
> +	WRITE_ONCE(*(u32 *)(meta_ptr + 4), pg_off);

it doens't match to few other places where normal read is done.
But why WRITE_ONCE here?
How does it race with anything?
producer_pos is updated later.

> +
> +	/* ensure length prefix is written before updating producer positions */
> +	smp_wmb();

this barrier is enough to make sure meta_ptr and meta_ptr+4 init
is visible before producer_pos is updated below.

> +	WRITE_ONCE(rb->producer_pos, new_prod_pos);
> +
> +	spin_unlock_irqrestore(&rb->spinlock, flags);
> +
> +	return meta_ptr + RINGBUF_META_SZ;
> +}
> +
> +BPF_CALL_3(bpf_ringbuf_reserve, struct bpf_map *, map, u64, size, u64, flags)
> +{
> +	struct bpf_ringbuf_map *rb_map;
> +
> +	if (unlikely(flags))
> +		return -EINVAL;
> +
> +	rb_map = container_of(map, struct bpf_ringbuf_map, map);
> +	return (unsigned long)__bpf_ringbuf_reserve(rb_map->rb, size);
> +}
> +
> +const struct bpf_func_proto bpf_ringbuf_reserve_proto = {
> +	.func		= bpf_ringbuf_reserve,
> +	.ret_type	= RET_PTR_TO_ALLOC_MEM_OR_NULL,
> +	.arg1_type	= ARG_CONST_MAP_PTR,
> +	.arg2_type	= ARG_CONST_ALLOC_SIZE_OR_ZERO,
> +	.arg3_type	= ARG_ANYTHING,
> +};
> +
> +static void bpf_ringbuf_commit(void *sample, bool discard)
> +{
> +	unsigned long rec_pos, cons_pos;
> +	u32 new_meta, old_meta;
> +	void *meta_ptr;
> +	struct bpf_ringbuf *rb;
> +
> +	meta_ptr = sample - RINGBUF_META_SZ;
> +	rb = bpf_ringbuf_restore_from_rec(meta_ptr);
> +	old_meta = *(u32 *)meta_ptr;

I think this one will race with user space and should be READ_ONCE.

> +	new_meta = old_meta ^ RINGBUF_BUSY_BIT;
> +	if (discard)
> +		new_meta |= RINGBUF_DISCARD_BIT;
> +
> +	/* update metadata header with correct final size prefix */
> +	xchg((u32 *)meta_ptr, new_meta);
> +
> +	/* if consumer caught up and is waiting for our record, notify about
> +	 * new data availability
> +	 */
> +	rec_pos = (void *)meta_ptr - (void *)rb->data;
> +	cons_pos = smp_load_acquire(&rb->consumer_pos) & rb->mask;

hmm. Earlier WRITE_ONCE(rb->producer_pos) is used, but here it's load_acquire.
Please be consistent with pairing.

> +	if (cons_pos == rec_pos)
> +		wake_up_all(&rb->waitq);

Is it legal to do from preempt_disabled region?
