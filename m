Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 774661D3EBE
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 22:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbgENULw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 16:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726128AbgENULv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 16:11:51 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF978C061A0C;
        Thu, 14 May 2020 13:11:51 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id n14so198230qke.8;
        Thu, 14 May 2020 13:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SWTxaSNIaPrCERES4dBKm2aAsOkRsnixPtMUzOKzRpA=;
        b=DYKQOwQ42LSCSc47RMjHaOtJ0bCcftcelLOJjuChExKywOLSTEuLLwauis7IjyBAsq
         lAnb2sIOYAsvVqS9XbLtQBsLbTWzWkedESvZeOiab2GvL3IB+HSqKBZZtAWsgQFuKg5s
         BHgrko0arGfLjLGhku36TlTinAMm7QDQ+8KjWVp4n1NpkRUemuESdXvkZi29i1NB1MpY
         7VglKdXbhjeitsmGG1tUR7PTwMJqqXZKP9MEUSFJDYyTjTQrcIZQ3ci5h025RZrrp+S3
         /nCceJaQPJOCc43ASaUkVs0+tVJ6ML9faO2+aSwEO6B4FuxFkrNu1yV2kwuWJFvAKij+
         hutQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SWTxaSNIaPrCERES4dBKm2aAsOkRsnixPtMUzOKzRpA=;
        b=FxApYEUJ/UlDfjuafU6j57rV+jILxWc9oiuIK3dX3mVWmzjPW7tzc3iQwAEhGxvGD6
         QUOiMmVvTrdY6+4BDvmvB/pBFXDom9OTeVCmyKRYL/UqHtQCm5clVLkikzxC2khzOsdD
         XEWTIo8TtpQ2SK3lFoUwt8Dgi5tX7QxnDvWg3txCjPa+XJcCgF+vrZHwD/uSk438PkLQ
         f7h7ajuu5CO+2b4fneRsRSPf7oGiWyc/5hzjrTjpsjWxp00bC8m6SuZZYQeFu89ADjQC
         kgVZs8z++CVaXrqTQo3syQTZeqcjyZJysXz5bL6rQ76UVYlRm4FO49lAHjhnBKlYj6bW
         TBiA==
X-Gm-Message-State: AOAM53004y+690oZAbmPDxWC+DGc8GL8LeWMJbYqAUUqPL2TSFiojHKI
        dPI858AYErVudjZhxVayTJgw36/1kID0XfhInJY=
X-Google-Smtp-Source: ABdhPJyMrNUdVh3UMUD/6vKXwQgy5EDQ9EZiD3QuGNK3wJVF9pmeZDuaa6F+jXHsNahn6GU20CAs6cryAZQ0nqA0op8=
X-Received: by 2002:ae9:e713:: with SMTP id m19mr79643qka.39.1589487110850;
 Thu, 14 May 2020 13:11:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200513192532.4058934-1-andriin@fb.com> <20200513192532.4058934-2-andriin@fb.com>
 <20200514165045.sk6zjlhsfzxbo6mb@bsd-mbp>
In-Reply-To: <20200514165045.sk6zjlhsfzxbo6mb@bsd-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 14 May 2020 13:11:39 -0700
Message-ID: <CAEf4BzYgxueymz1xUeQMAkFEr1dW4T=kotw4PssE3cVKh7RMfw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/6] bpf: implement BPF ring buffer and verifier
 support for it
To:     Jonathan Lemon <bsd@fb.com>
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

On Thu, May 14, 2020 at 9:50 AM Jonathan Lemon <bsd@fb.com> wrote:
>
> On Wed, May 13, 2020 at 12:25:27PM -0700, Andrii Nakryiko wrote:
> > +static struct bpf_ringbuf *bpf_ringbuf_restore_from_rec(void *meta_ptr)
> > +{
> > +     unsigned long addr = (unsigned long)meta_ptr;
> > +     unsigned long off = *(u32 *)(meta_ptr + 4) << PAGE_SHIFT;
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
>
> Size should be 30 bits, not UINT_MAX, since 2 bits are reserved.

Oh, good catch, thanks. Yep, should be (UINT_MAX >> 2), will add a
constant for this.


>
> > +
> > +     len = round_up(size + RINGBUF_META_SZ, 8);
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
> Or define a 64bit word in the structure and use:
>
>         WRITE_ONCE(*(u64 *)meta_ptr, rec.header);

yep, can do that

>
>
> > +
> > +     /* ensure length prefix is written before updating producer positions */
> > +     smp_wmb();
> > +     WRITE_ONCE(rb->producer_pos, new_prod_pos);
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
>
> --
> Jonathan
