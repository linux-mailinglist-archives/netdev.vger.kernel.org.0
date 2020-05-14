Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3581D3F31
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 22:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728135AbgENUto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 16:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725975AbgENUtm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 16:49:42 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8330C061A0C;
        Thu, 14 May 2020 13:49:41 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id z80so370599qka.0;
        Thu, 14 May 2020 13:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=imUONWd0trYNYPIyNTvFxTDcMij5ilW7wLu4w4MPYtI=;
        b=QXIL/eBwluafEAOR+k0xYPb99eNRci/dOUDtClHKiXaFTYausYXJJFcsjTbTFBI3u2
         vy7vrAoRlvJjl6wEpHGnBSPXLJdK+hGwdTTGu27FolKvAw5dlk3gKYgg7qsn5iVLeENx
         JOJg6hjfd1t3Wz6ii7jA96nfko5PJShX7tYBNXpURpbljJt7qOPzf+Drd9YtQiAuTOn4
         pzSdBVeTawIDN8+pQtj84+uf9A+UeI2Jp+3Zqdf4xU9KYbO7eVeTZ8juZO1GrWsHEx5r
         KCJvRkmYENvx03ArjZhpLa9cCWZ3qJ06njod0S6j3+A4VSdrSDyKOpk0otduqu930o3/
         bUvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=imUONWd0trYNYPIyNTvFxTDcMij5ilW7wLu4w4MPYtI=;
        b=bfJs0WzWRqfnuQ+xwBUWVgRYG1GXupTqXsKMthtiXvk3lUnQfKbSne8dqmiZlLA3Up
         b08T0bXUymLFNccRyCfj6wSkTu2Zntko6TKzooRN2VOrfq6tkrEUxk807IDdluAjE/ue
         gLrdjy5aRKvZbIH8e8Q1Pv7+8b8XEUHWBN5xb1BWIG+wblkhmK6cL9ENB8loqbW8rk8u
         XwW0HAMFEH13BM6GvZO1rPTQiH8jo9SjWWJmO3CL6/rvPnrIiw/7pB4LboqTXKj4iZa1
         JmPBbDDsgahFNR98ZitGt1jtrp7oW4Dp9SAAs61+uUujMADUTfQjKKJvUj4kqUbVpYSy
         e2qQ==
X-Gm-Message-State: AOAM533sHHMmWNV7rSUguIG35mpEe4+EaSCjJUS0LqSRhRHD9bdwwhEJ
        pU57lSmJkXwUZpzQ9KaNYneqceghpekrd2S3gmc=
X-Google-Smtp-Source: ABdhPJxbYqAlDHpRwnP/ptzQiEScHwFOM1+uCaDjkQzCOZa8Unw6qtmENYss8CBTtuVzulv7/DROZQoGC2IGlPFVPe4=
X-Received: by 2002:a05:620a:14a1:: with SMTP id x1mr263160qkj.92.1589489380999;
 Thu, 14 May 2020 13:49:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200513192532.4058934-1-andriin@fb.com> <20200513192532.4058934-2-andriin@fb.com>
 <20200514190649.ca4qugueh5sp32ax@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200514190649.ca4qugueh5sp32ax@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 14 May 2020 13:49:30 -0700
Message-ID: <CAEf4BzZp7Hzni=eQKKodfi-W1R46ia2+cRfFG1W6Li5xRX5qJA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/6] bpf: implement BPF ring buffer and verifier
 support for it
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 12:06 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, May 13, 2020 at 12:25:27PM -0700, Andrii Nakryiko wrote:
> > +
> > +/* Given pointer to ring buffer record metadata, restore pointer to struct
> > + * bpf_ringbuf itself by using page offset stored at offset 4
> > + */
> > +static struct bpf_ringbuf *bpf_ringbuf_restore_from_rec(void *meta_ptr)
> > +{
> > +     unsigned long addr = (unsigned long)meta_ptr;
> > +     unsigned long off = *(u32 *)(meta_ptr + 4) << PAGE_SHIFT;
>
> Looking at the further code it seems this one should be READ_ONCE, but...
>

This will be called from commit(), which will be called after
successful reserve(), which dose spin_unlock at the end. So in terms
of memory barriers, everything should be fine? Or am I missing some
trickier aspect?

> > +
> > +     return (void*)((addr & PAGE_MASK) - off);
> > +}
> > +
> > +static void *__bpf_ringbuf_reserve(struct bpf_ringbuf *rb, u64 size)
> > +{
> > +     unsigned long cons_pos, prod_pos, new_prod_pos, flags;
> > +     u32 len, pg_off;
> > +     void *meta_ptr;
> > +
> > +     if (unlikely(size > UINT_MAX))
> > +             return NULL;
> > +
> > +     len = round_up(size + RINGBUF_META_SZ, 8);
>
> it may overflow despite the check above.

As Jonathan pointed out, max size should be enforced about to be at
most (UINT_MAX/4), due to 2 bits reserved for BUSY and DISCARD. So it
shouldn't overflow.

>
> > +     cons_pos = READ_ONCE(rb->consumer_pos);
> > +
> > +     if (in_nmi()) {
> > +             if (!spin_trylock_irqsave(&rb->spinlock, flags))
> > +                     return NULL;
> > +     } else {
> > +             spin_lock_irqsave(&rb->spinlock, flags);
> > +     }
> > +
> > +     prod_pos = rb->producer_pos;
> > +     new_prod_pos = prod_pos + len;
> > +
> > +     /* check for out of ringbuf space by ensuring producer position
> > +      * doesn't advance more than (ringbuf_size - 1) ahead
> > +      */
> > +     if (new_prod_pos - cons_pos > rb->mask) {
> > +             spin_unlock_irqrestore(&rb->spinlock, flags);
> > +             return NULL;
> > +     }
> > +
> > +     meta_ptr = rb->data + (prod_pos & rb->mask);
> > +     pg_off = bpf_ringbuf_rec_pg_off(rb, meta_ptr);
> > +
> > +     WRITE_ONCE(*(u32 *)meta_ptr, RINGBUF_BUSY_BIT | size);
> > +     WRITE_ONCE(*(u32 *)(meta_ptr + 4), pg_off);
>
> it doens't match to few other places where normal read is done.
> But why WRITE_ONCE here?
> How does it race with anything?
> producer_pos is updated later.

Yeah, I think you are right. I left it as WRITE_ONCE from my initial
lockless variant, but this could be just a normal store, will fix.

>
> > +
> > +     /* ensure length prefix is written before updating producer positions */
> > +     smp_wmb();
>
> this barrier is enough to make sure meta_ptr and meta_ptr+4 init
> is visible before producer_pos is updated below.

yep, 100% agree


>
> > +     WRITE_ONCE(rb->producer_pos, new_prod_pos);

consumer reads this with smp_load_acquire, I guess for consistency
I'll switch this to smp_store_release() then, right?

> > +
> > +     spin_unlock_irqrestore(&rb->spinlock, flags);
> > +
> > +     return meta_ptr + RINGBUF_META_SZ;
> > +}
> > +
> > +BPF_CALL_3(bpf_ringbuf_reserve, struct bpf_map *, map, u64, size, u64, flags)
> > +{
> > +     struct bpf_ringbuf_map *rb_map;
> > +
> > +     if (unlikely(flags))
> > +             return -EINVAL;
> > +
> > +     rb_map = container_of(map, struct bpf_ringbuf_map, map);
> > +     return (unsigned long)__bpf_ringbuf_reserve(rb_map->rb, size);
> > +}
> > +
> > +const struct bpf_func_proto bpf_ringbuf_reserve_proto = {
> > +     .func           = bpf_ringbuf_reserve,
> > +     .ret_type       = RET_PTR_TO_ALLOC_MEM_OR_NULL,
> > +     .arg1_type      = ARG_CONST_MAP_PTR,
> > +     .arg2_type      = ARG_CONST_ALLOC_SIZE_OR_ZERO,
> > +     .arg3_type      = ARG_ANYTHING,
> > +};
> > +
> > +static void bpf_ringbuf_commit(void *sample, bool discard)
> > +{
> > +     unsigned long rec_pos, cons_pos;
> > +     u32 new_meta, old_meta;
> > +     void *meta_ptr;
> > +     struct bpf_ringbuf *rb;
> > +
> > +     meta_ptr = sample - RINGBUF_META_SZ;
> > +     rb = bpf_ringbuf_restore_from_rec(meta_ptr);
> > +     old_meta = *(u32 *)meta_ptr;
>
> I think this one will race with user space and should be READ_ONCE.

This is never modified by user-space, only by previous reserve(). Is
that still considered a race by some tooling?

>
> > +     new_meta = old_meta ^ RINGBUF_BUSY_BIT;
> > +     if (discard)
> > +             new_meta |= RINGBUF_DISCARD_BIT;
> > +
> > +     /* update metadata header with correct final size prefix */
> > +     xchg((u32 *)meta_ptr, new_meta);
> > +
> > +     /* if consumer caught up and is waiting for our record, notify about
> > +      * new data availability
> > +      */
> > +     rec_pos = (void *)meta_ptr - (void *)rb->data;
> > +     cons_pos = smp_load_acquire(&rb->consumer_pos) & rb->mask;
>
> hmm. Earlier WRITE_ONCE(rb->producer_pos) is used, but here it's load_acquire.
> Please be consistent with pairing.

wait, it's *consumer* vs *producer* positions. consumer_pos is updated
by consumer using smp_store_release(), so it's paired. But I mentioned
above that producer_pos has to be written with smp_store_release().
Does that address your concern?


>
> > +     if (cons_pos == rec_pos)
> > +             wake_up_all(&rb->waitq);
>
> Is it legal to do from preempt_disabled region?

Don't know, couldn't find anything about this aspect. But looking at
perf buffer code, all the wakeups are done after irq_work_queue(), so
I guess it's not safe then? I'll add irq_work_queue() then.
