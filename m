Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93D4D1DEFB7
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 21:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730979AbgEVTH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 15:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730867AbgEVTH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 15:07:59 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21CF6C05BD43;
        Fri, 22 May 2020 12:07:58 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id s1so11765253qkf.9;
        Fri, 22 May 2020 12:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cP5NZcCM4E0ML+MjDR5Tnt9wAZKTWYo4VSKRdeIz7EE=;
        b=KczSMAuZR3ZxghK8BWr4poKujf+qNDoAMUsj3EewtvYcpwOGxykoI3F4k58KZ+sudp
         s1LX/2LwygR+q2T3lACD2jJRlEAg47nq38naDwdHftAMQ2a2BzWn3XVZ+9+YJtqg0qB0
         lv/C41V+HBB40lnwoPuK/knkd6KzhD7VRtPZUB4NVdRm/WmnbiaQtY+KtF0Oazx3207L
         iVAbZcOJs9LWuzPlDaO9wY9HIIJ4hb1mEEB2nU3k5UD8qc8haQCmC13UwTHSStx9JsGY
         eXC5I2Z0BiBmcjCNKrKV5ZecCUZCrraFNXL0CGkx09JXYeg0cG0+CBs8HExjK4hT6bug
         a4aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cP5NZcCM4E0ML+MjDR5Tnt9wAZKTWYo4VSKRdeIz7EE=;
        b=COBvMovd6Sp+aIqVdfz1lmrYVhl2FmCTIVyV2nUwwPG8g5qhkD5M2GU97+YWVJbgzH
         YgCJDnDh5jNIY2sxHVkttmCEWDKjWLU9uYmtPBKClIIY3mpJOGbHPuus0G5ZFuR4BwmO
         6/yjvwQAgsNUw3hKJpFP11onHldRrRP1dpMB93QBFkiTAbWu4gPietfaQW6v+zL6Fyuh
         iNmRSIk9QbZHQsNbBTilSCpZWCBA3pSbz0Rcjx40/WH7Q2JaGrKmCiVmFbyW/3IkoTNh
         gMmZgBYhibzSCnP6pp/MzRj/0U/d1+GJbyY9w9uIlIPvdsnuI4UEWqgkjP71gIU/hM9T
         g+yA==
X-Gm-Message-State: AOAM530PnQGCZMTLj7+eYKbjUIlLztorQtCwMcPBlN5AT5ZTuFny2Zh2
        cKsoo9yrl8Q8G7yRJYqi+CEKE5rLgAyS2hS2xnLkB8mn
X-Google-Smtp-Source: ABdhPJw4rQ1oYVQPO2v0pSrSZw3oxGarJJ1LkCm6NTyyi7QSDy4VX0WvnPkxtbG4o8dkHvOAImI7Iaf6bX4X9W2dmN8=
X-Received: by 2002:a05:620a:2049:: with SMTP id d9mr17756600qka.449.1590174477089;
 Fri, 22 May 2020 12:07:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200517195727.279322-1-andriin@fb.com> <20200517195727.279322-7-andriin@fb.com>
 <20200522012147.shnwybm5my7dgy4v@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200522012147.shnwybm5my7dgy4v@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 22 May 2020 12:07:46 -0700
Message-ID: <CAEf4Bza34RXPn_1m-nnEceRCQLFykEv9YQXpZZnyk0sE3X-Jwg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 6/7] bpf: add BPF ringbuf and perf buffer benchmarks
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

On Thu, May 21, 2020 at 6:21 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sun, May 17, 2020 at 12:57:26PM -0700, Andrii Nakryiko wrote:
> > +
> > +static inline int roundup_len(__u32 len)
> > +{
> > +     /* clear out top 2 bits */
> > +     len <<= 2;
> > +     len >>= 2;
> > +     /* add length prefix */
> > +     len += RINGBUF_META_LEN;
> > +     /* round up to 8 byte alignment */
> > +     return (len + 7) / 8 * 8;
> > +}
>
> the same round_up again?
>
> > +
> > +static void ringbuf_custom_process_ring(struct ringbuf_custom *r)
> > +{
> > +     unsigned long cons_pos, prod_pos;
> > +     int *len_ptr, len;
> > +     bool got_new_data;
> > +
> > +     cons_pos = smp_load_acquire(r->consumer_pos);
> > +     while (true) {
> > +             got_new_data = false;
> > +             prod_pos = smp_load_acquire(r->producer_pos);
> > +             while (cons_pos < prod_pos) {
> > +                     len_ptr = r->data + (cons_pos & r->mask);
> > +                     len = smp_load_acquire(len_ptr);
> > +
> > +                     /* sample not committed yet, bail out for now */
> > +                     if (len & RINGBUF_BUSY_BIT)
> > +                             return;
> > +
> > +                     got_new_data = true;
> > +                     cons_pos += roundup_len(len);
> > +
> > +                     atomic_inc(&buf_hits.value);
> > +             }
> > +             if (got_new_data)
> > +                     smp_store_release(r->consumer_pos, cons_pos);
> > +             else
> > +                     break;
> > +     };
> > +}
>
> copy paste from libbpf? why?

Yep, it's deliberate, see description of rb-custom benchmark in commit message.

Basically, I was worried that generic libbpf callback calling might
introduce a noticeable slowdown and wanted to test the case where
ultimate peformance was necessary and someone would just implement
custom reading loop with inlined processing logic. And it turned out
to be noticeable, see benchmark results for rb-libbpf and rb-custom
benchmarks. So I satisfied my curiosity :), but if you think that's
not necessary, I can drop rb-custom (and, similarly, pb-custom for
perfbuf). It still seems useful to me, though (and is sort of an
example of minimal correct implementation of ringbuf/perfbuf reading).

Btw, apart from speed up from avoiding indirect calls (due to
callback), this algorithm also does "batched"
smp_store_release(r->consumer_pos) only once after each inner
`while(cons_pos < prod_pos)` loop, so there is theoretically less
cache line bouncing, which might give a bit more speed as well. Libbpf
pessimistically does smp_store_release() after each record in
assumption that customer-provided callback might take a while, so it's
better to give producers a bit more space back as early as possible.
