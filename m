Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 830C01E1479
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 20:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389860AbgEYSp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 14:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389656AbgEYSp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 14:45:58 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37BD7C061A0E;
        Mon, 25 May 2020 11:45:58 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id z9so8357396qvi.12;
        Mon, 25 May 2020 11:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fVQ8ZzBluQKzy3OQ/CVweXHnnL9H9nMVFTqGvLfL/5Q=;
        b=OKgAtithpuFVFBKnxG5dM7Ryh2sBu1I+FLRCnrv2G9YqtGWWV+vAZxnfPoFT5aXByj
         71KnfmROu6WWfUiGDXYrnDAMptSjh+kRxXt4VAeGbWAglSCgtbTKpbAxqsVD2PufZSqK
         8K0Wh6kH9WX1bBoSb3vMlPv/heKpeUpSnlrK/nlIua6hwLG2RnNMn7TddxTcfjbNhjLh
         ytDOMvVgLZ6xFmDEk5zfMXppOlA6c99NfEo5XDXo4OpnF4qaGbNqIbScdQtUKT6Un8AU
         /wol7pS7ESqx5A+UF7/Xjm9xXeKvFdGTkd9ko7+i+x7fGiCb0f7gkg0ZGrA0M0dCJUZZ
         1ZpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fVQ8ZzBluQKzy3OQ/CVweXHnnL9H9nMVFTqGvLfL/5Q=;
        b=WAQlbBPGixGcuU7VMJPjpTC1yWt2//KA/By+1mIEC+eb0eDngSirAtH6jBVONWUoaL
         8YDrJRjZM8JGM6klrzVa0Yk9ZMacXEqlzhbrSn3NHJIwceq1yNzJ0DX86bMZ+pGAT0s4
         w43AvjxqSvO9PriVxaMFjqX17331PrX2qBNuupMIqUCj1xJ0JFfRpEZIgzmZde0OYFzm
         VN9eCeP/JbJW3aptEB4ZYoswUfMy9Oa/BiKsxqj8H0GngKy2drgMY44oEOJLIp3BcOHa
         1OGNmM3dZP9d5yZX2Nq8yjBEX8XNZ4iAWUEAxlgnQgieTitdMTfAoOajLK6npp7OG9NO
         PEEA==
X-Gm-Message-State: AOAM533pJTD4OTe+YR0avi06xzwg8n3zjNv0X0fwslo+wVjRGMJiRTxR
        aioXcXPhe+Fjt7cDRT9QqWaHLVXs0hbtubaLXUE=
X-Google-Smtp-Source: ABdhPJwsqV1B1KGSN3QuBv46cEUG9i1+Uv/B6Ol/g1Yojmp7fJcp4H4YFA3geqnYXvmXfCNx+KqXSSolyQFSznaNd2Y=
X-Received: by 2002:a0c:e4d4:: with SMTP id g20mr15913135qvm.228.1590432357252;
 Mon, 25 May 2020 11:45:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200517195727.279322-1-andriin@fb.com> <20200517195727.279322-2-andriin@fb.com>
 <20200522002502.GF2869@paulmck-ThinkPad-P72> <CAEf4Bza26AbRMtWcoD5+TFhnmnU6p5YJ8zO+SoAJCDtp1jVhcQ@mail.gmail.com>
 <20200525160120.GX2869@paulmck-ThinkPad-P72>
In-Reply-To: <20200525160120.GX2869@paulmck-ThinkPad-P72>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 25 May 2020 11:45:46 -0700
Message-ID: <CAEf4BzYKBvoH7iH9kCjxSQ=G1w--Ydh=Hz7fBLL2CNRi3jFDdg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/7] bpf: implement BPF ring buffer and
 verifier support for it
To:     "Paul E . McKenney" <paulmck@kernel.org>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 25, 2020 at 9:01 AM Paul E. McKenney <paulmck@kernel.org> wrote:
>
> On Fri, May 22, 2020 at 11:46:49AM -0700, Andrii Nakryiko wrote:
> > On Thu, May 21, 2020 at 5:25 PM Paul E. McKenney <paulmck@kernel.org> wrote:
> > >
> > > On Sun, May 17, 2020 at 12:57:21PM -0700, Andrii Nakryiko wrote:
> > > > This commits adds a new MPSC ring buffer implementation into BPF ecosystem,
> > > > which allows multiple CPUs to submit data to a single shared ring buffer. On
> > > > the consumption side, only single consumer is assumed.
> > >
> > > [ . . . ]
> > >
> > > Focusing just on the ring-buffer mechanism, with a question or two
> > > below.  Looks pretty close, actually!
> > >
> > >                                                         Thanx, Paul
> > >
> >
> > Thanks for review, Paul!
> >
> > > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > > ---

[...]

> > > > +
> > > > +static unsigned long ringbuf_avail_data_sz(struct bpf_ringbuf *rb)
> > > > +{
> > > > +     unsigned long cons_pos, prod_pos;
> > > > +
> > > > +     cons_pos = smp_load_acquire(&rb->consumer_pos);
> > >
> > > What happens if there is a delay here?  (The delay might be due to
> > > interrupts, preemption in PREEMPT=y kernels, vCPU preemption, ...)
> > >
> > > If this is called from a producer holding the lock, then the only
> > > ->consumer_pos can change, and that can only decrease the amount of
> > > data available.  Besides which, ->consumer_pos is sampled first.
> > > But why would a producer care how much data was queued, as opposed
> > > to how much free space was available?
> >
> > see second point below, it's for BPF program to implement custom
> > notification policy/heuristics
> >
> > >
> > > From the consumer, only ->producer_pos can change, and that can only
> > > increase the amount of data available.  (Assuming that producers cannot
> > > erase old data on wrap-around before the consumer consumes it.)
> >
> > right, they can't overwrite data
> >
> > >
> > > So probably nothing bad happens.
> > >
> > > On the bit about the producer holding the lock, some lockdep assertions
> > > might make things easier on your future self.
> >
> > So this function is currently called in two situations, both not
> > holding the spinlock. I'm fully aware this is a racy way to do this,
> > but it's ok for the applications.
> >
> > So the first place is during initial poll "subscription", when we need
> > to figure out if there is already some unconsumed data in ringbuffer
> > to let poll/epoll subsystem know whether caller can do read without
> > waiting. If this is done from consumer thread, it's race free, because
> > consumer position won't change, so either we'll see that producer >
> > consumer, or if we race with producer, producer will see that consumer
> > pos == to-be-committed record pos, so will send notification. If epoll
> > happens from non-consumer thread, it's similarly racy to perf buffer
> > poll subscription implementation, but with next record subscriber will
> > get notification anyways.
> >
> > The second place is from BPF side (so potential producer), but it's
> > outside of producer lock. It's called from bpf_ringbuf_query() helper
> > which is supposed to return various potentially stale properties of
> > ringbuf (e.g., consumer/producer position, amount of unconsumed data,
> > etc). The use case here is for BPF program to implement its own
> > flexible poll notification strategy (or whatever else creative
> > programmer will come up with, of course). E.g., batched notification,
> > which happens not on every record, but only once enough data is
> > accumulated. In this case exact amount of unconsumed data is not
> > critical, it's only a heuristics. And it's more convenient than amount
> > of data left free, IMO, but both can be calculated using the other,
> > provided the total size of ring buffer is known (which can be returned
> > by bpf_ringbuf_query() helper as well).
> >
> > So I think in both cases I don't want to take spinlock. If this is not
> > done under spinlock, then I have to read consumer pos first, producer
> > pos second, otherwise I can get into a situation of having
> > consumer_pos > producer_pos (due to delays), which is really bad.
> >
> > It's a bit wordy explanation, but I hope this makes sense.
>
> Fair enough, and the smp_load_acquire() calls do telegraph the lockless
> access.  But what if timing results in the difference below coming out
> negative, that is, a very large unsigned long value?

This can happen only if, in the meantime, consumer_pos gets updated at
least once, while producer_pos advances by at least 2^32 or 2^64,
depending on architecture. This is essentially impossible on 64-bit
arches, and extremely unlikely on 32-bit ones. So I'd say it is ok,
especially given that this is for heuristics?

>
> > > > +     prod_pos = smp_load_acquire(&rb->producer_pos);
> > > > +     return prod_pos - cons_pos;
> > > > +}
> > > > +
> > > > +static __poll_t ringbuf_map_poll(struct bpf_map *map, struct file *filp,
> > > > +                              struct poll_table_struct *pts)
> > > > +{
> > > > +     struct bpf_ringbuf_map *rb_map;
> > > > +
> > > > +     rb_map = container_of(map, struct bpf_ringbuf_map, map);
> > > > +     poll_wait(filp, &rb_map->rb->waitq, pts);
> > > > +
> > > > +     if (ringbuf_avail_data_sz(rb_map->rb))
> > > > +             return EPOLLIN | EPOLLRDNORM;
> > > > +     return 0;
> > > > +}
> > > > +
> > > > +const struct bpf_map_ops ringbuf_map_ops = {
> > > > +     .map_alloc = ringbuf_map_alloc,
> > > > +     .map_free = ringbuf_map_free,
> > > > +     .map_mmap = ringbuf_map_mmap,
> > > > +     .map_poll = ringbuf_map_poll,
> > > > +     .map_lookup_elem = ringbuf_map_lookup_elem,
> > > > +     .map_update_elem = ringbuf_map_update_elem,
> > > > +     .map_delete_elem = ringbuf_map_delete_elem,
> > > > +     .map_get_next_key = ringbuf_map_get_next_key,
> > > > +};
> > > > +
> > > > +/* Given pointer to ring buffer record metadata and struct bpf_ringbuf itself,
> > > > + * calculate offset from record metadata to ring buffer in pages, rounded
> > > > + * down. This page offset is stored as part of record metadata and allows to
> > > > + * restore struct bpf_ringbuf * from record pointer. This page offset is
> > > > + * stored at offset 4 of record metadata header.
> > > > + */
> > > > +static size_t bpf_ringbuf_rec_pg_off(struct bpf_ringbuf *rb,
> > > > +                                  struct bpf_ringbuf_hdr *hdr)
> > > > +{
> > > > +     return ((void *)hdr - (void *)rb) >> PAGE_SHIFT;
> > > > +}
> > > > +
> > > > +/* Given pointer to ring buffer record header, restore pointer to struct
> > > > + * bpf_ringbuf itself by using page offset stored at offset 4
> > > > + */
> > > > +static struct bpf_ringbuf *
> > > > +bpf_ringbuf_restore_from_rec(struct bpf_ringbuf_hdr *hdr)
> > > > +{
> > > > +     unsigned long addr = (unsigned long)(void *)hdr;
> > > > +     unsigned long off = (unsigned long)hdr->pg_off << PAGE_SHIFT;
> > > > +
> > > > +     return (void*)((addr & PAGE_MASK) - off);
> > > > +}
> > > > +
> > > > +static void *__bpf_ringbuf_reserve(struct bpf_ringbuf *rb, u64 size)
> > > > +{
> > > > +     unsigned long cons_pos, prod_pos, new_prod_pos, flags;
> > > > +     u32 len, pg_off;
> > > > +     struct bpf_ringbuf_hdr *hdr;
> > > > +
> > > > +     if (unlikely(size > RINGBUF_MAX_RECORD_SZ))
> > > > +             return NULL;
> > > > +
> > > > +     len = round_up(size + BPF_RINGBUF_HDR_SZ, 8);
> > > > +     cons_pos = smp_load_acquire(&rb->consumer_pos);
> > >
> > > There might be a longish delay acquiring the spinlock, which could mean
> > > that cons_pos was out of date, which might result in an unnecessary
> > > producer-side failure.  Why not pick up cons_pos after the lock is
> > > acquired?  After all, it is in the same cache line as the lock, so this
> > > should have negligible effect on lock-hold time.
> >
> > Right, the goal was to minimize amount of time that spinlock is hold.
> >
> > Spinlock and consumer_pos are certainly not on the same cache line,
> > consumer_pos is deliberately on a different *page* altogether (due to
> > mmap() and to avoid unnecessary sharing between consumers, who don't
> > touch spinlock, and producers, who do use lock to coordinate).
> >
> > So I chose to potentially drop sample due to a bit stale consumer pos,
> > but speed up locked section.
>
> OK, fair enough!
>
> > > (Unless you had either really small cachelines or really big locks.
> > >
> > > > +     if (in_nmi()) {
> > > > +             if (!spin_trylock_irqsave(&rb->spinlock, flags))
> > > > +                     return NULL;
> > > > +     } else {
> > > > +             spin_lock_irqsave(&rb->spinlock, flags);
> > > > +     }
> > > > +
> > > > +     prod_pos = rb->producer_pos;
> > > > +     new_prod_pos = prod_pos + len;
> > > > +
> > > > +     /* check for out of ringbuf space by ensuring producer position
> > > > +      * doesn't advance more than (ringbuf_size - 1) ahead
> > > > +      */
> > > > +     if (new_prod_pos - cons_pos > rb->mask) {
> > > > +             spin_unlock_irqrestore(&rb->spinlock, flags);
> > > > +             return NULL;
> > > > +     }
> > > > +
> > > > +     hdr = (void *)rb->data + (prod_pos & rb->mask);
> > > > +     pg_off = bpf_ringbuf_rec_pg_off(rb, hdr);
> > > > +     hdr->len = size | BPF_RINGBUF_BUSY_BIT;
> > > > +     hdr->pg_off = pg_off;
> > > > +
> > > > +     /* ensure header is written before updating producer positions */
> > > > +     smp_wmb();
> > >
> > > The smp_store_release() makes this unnecessary with respect to
> > > ->producer_pos.  So what later write is it also ordering against?
> > > If none, this smp_wmb() can go away.
> > >
> > > And if the later write is the xchg() in bpf_ringbuf_commit(), the
> > > xchg() implies full barriers before and after, so that the smp_wmb()
> > > could still go away.
> > >
> > > So other than the smp_store_release() and the xchg(), what later write
> > > is the smp_wmb() ordering against?
> >
> > I *think* my intent here was to make sure that when consumer reads
> > producer_pos, it sees hdr->len with busy bit set. But I also think
> > that you are right and smp_store_release (producer_pos) ensures that
> > if consumer does smp_read_acquire(producer_pos) it will see up-to-date
> > hdr->len, for a given value of producer_pos. So yeah, I think I should
> > drop smp_wmb(). I dropped it in litmus tests, and they still pass,
> > which gives me a bit more confidence as well. :)
> >
> > I say "I *think*", because this algorithm started off completely
> > locklessly without producer spinlock, so maybe I needed this barrier
> > for something there, but I honestly don't remember details of lockless
> > implementation by now.
> >
> > So in summary, yeah, I'll drop smp_wmb().
>
> Sounds good!
>
>                                                         Thanx, Paul
>
> > > > +     /* pairs with consumer's smp_load_acquire() */
> > > > +     smp_store_release(&rb->producer_pos, new_prod_pos);
> > > > +
> > > > +     spin_unlock_irqrestore(&rb->spinlock, flags);
> > > > +
> > > > +     return (void *)hdr + BPF_RINGBUF_HDR_SZ;
> > > > +}
> > > > +
> > > > +BPF_CALL_3(bpf_ringbuf_reserve, struct bpf_map *, map, u64, size, u64, flags)
> > > > +{
> > > > +     struct bpf_ringbuf_map *rb_map;
> > > > +
> > > > +     if (unlikely(flags))
> > > > +             return 0;
> > > > +
> > > > +     rb_map = container_of(map, struct bpf_ringbuf_map, map);
> > > > +     return (unsigned long)__bpf_ringbuf_reserve(rb_map->rb, size);
> > > > +}
> > > > +
> > > > +const struct bpf_func_proto bpf_ringbuf_reserve_proto = {
> > > > +     .func           = bpf_ringbuf_reserve,
> > > > +     .ret_type       = RET_PTR_TO_ALLOC_MEM_OR_NULL,
> > > > +     .arg1_type      = ARG_CONST_MAP_PTR,
> > > > +     .arg2_type      = ARG_CONST_ALLOC_SIZE_OR_ZERO,
> > > > +     .arg3_type      = ARG_ANYTHING,
> > > > +};
> > > > +
> > > > +static void bpf_ringbuf_commit(void *sample, u64 flags, bool discard)
> > > > +{
> > > > +     unsigned long rec_pos, cons_pos;
> > > > +     struct bpf_ringbuf_hdr *hdr;
> > > > +     struct bpf_ringbuf *rb;
> > > > +     u32 new_len;
> > > > +
> > > > +     hdr = sample - BPF_RINGBUF_HDR_SZ;
> > > > +     rb = bpf_ringbuf_restore_from_rec(hdr);
> > > > +     new_len = hdr->len ^ BPF_RINGBUF_BUSY_BIT;
> > > > +     if (discard)
> > > > +             new_len |= BPF_RINGBUF_DISCARD_BIT;
> > > > +
> > > > +     /* update record header with correct final size prefix */
> > > > +     xchg(&hdr->len, new_len);
> > > > +
> > > > +     /* if consumer caught up and is waiting for our record, notify about
> > > > +      * new data availability
> > > > +      */
> > > > +     rec_pos = (void *)hdr - (void *)rb->data;
> > > > +     cons_pos = smp_load_acquire(&rb->consumer_pos) & rb->mask;
> > > > +
> > > > +     if (flags & BPF_RB_FORCE_WAKEUP)
> > > > +             irq_work_queue(&rb->work);
> > > > +     else if (cons_pos == rec_pos && !(flags & BPF_RB_NO_WAKEUP))
> > > > +             irq_work_queue(&rb->work);
> > > > +}
