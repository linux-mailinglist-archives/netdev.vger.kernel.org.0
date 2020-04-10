Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9D1B1A4A37
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 21:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgDJTPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 15:15:44 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55750 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726142AbgDJTPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 15:15:44 -0400
Received: by mail-wm1-f65.google.com with SMTP id e26so3411812wmk.5
        for <netdev@vger.kernel.org>; Fri, 10 Apr 2020 12:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lrjUZsrELM7m4SlJ+9uENDrXv8OPhuZwcNmebnVp+g4=;
        b=sUYdYF4ng7IxA3oM7M4EXrPxtjOlrd07lGI0bZ7V3I9oL/U0Jju1ENtZw6khx4uiE6
         Ftp7kw+8g46oDI1ylThDUYn9y2sJ08l7u6BmnBnVJbKwHpjpw9+S2G3ef+DCoiWtVP2r
         ZmCi60xr/BRFD0EPe7N+0X2T8xlsAh8mFPJeO8kRzWOtILLoIxcs4fZc16002hVgRmDs
         nvU8ApZy9MfU33ZsDae2golB5fmjpemDbFuyejlxh28dOUzAUT0zBWvVNam962iHvUq1
         74l85u3hPvgceMev0I7wCUNDC2F+6xwwgaP9ZOhWVzWGGXq3IKT73CQwi86z9VbFQnbH
         RgPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lrjUZsrELM7m4SlJ+9uENDrXv8OPhuZwcNmebnVp+g4=;
        b=oiHS64sDeenspKaMwRYp8IJy1FxCoZ2N6TpJA94qQCow55p9P2qublJ8Ldm25zVMpN
         DF+9NSrdCFWicXKmIQfTcX/VqJRJyISXeao/zZsmRO0W0wiq6mA7+GrRWdwLYhFL98vM
         RfVurwDOoJ7N2MUR1K1zg3hFUZKb90k4mtecNol6g9dXCXH0usTwB0Ele/X0IcuxwgWt
         yTg89/d9KALCqAUbpmk4B3j2xkqSZ9DTsXs9kwGNDQo7jdILbeS769MvA2f764TYwrNI
         LkszmImxQiSOETp21WlkHIHuExgkiZOA47CQtPMGB5KCNJhdLbV14RYqNvq9IQstoKag
         rLgw==
X-Gm-Message-State: AGi0PubZdDue0ftbdd+FjPifwP1jHMEQnbVQpr0cmb+SEky7F7QuCn2K
        Z+areuMRtgjQxxOqq4TzwEH/IxzszhN5S8Sncqq5IA==
X-Google-Smtp-Source: APiQypLr8/Zce0NrHgv+zGJPQH+trYjcHEyQwuE6spT5cIasUPOPuHIwu1JExbYTBfOXO4IbRx7lW1eARB+HzIWuMyI=
X-Received: by 2002:a1c:1f4a:: with SMTP id f71mr6377573wmf.8.1586546140136;
 Fri, 10 Apr 2020 12:15:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200128025958.43490-1-arjunroy.kdev@gmail.com>
 <20200128025958.43490-3-arjunroy.kdev@gmail.com> <20200212185605.d89c820903b7aa9fbbc060b2@linux-foundation.org>
 <CAOFY-A1o0L_D7Oyi1S=+Ng+2dK35-QHSSUQ9Ct3EA5y-DfWaXA@mail.gmail.com>
 <CAOFY-A0G+NOpi7r=gnrLNsJ-OHYnGKCJ0mJ5PWwH5m7_99bD5w@mail.gmail.com> <20200410120443.ad7856db13e158fbd441f3ae@linux-foundation.org>
In-Reply-To: <20200410120443.ad7856db13e158fbd441f3ae@linux-foundation.org>
From:   Arjun Roy <arjunroy@google.com>
Date:   Fri, 10 Apr 2020 12:15:29 -0700
Message-ID: <CAOFY-A0w51=3M0Gj80wt8BhJryXeEgTTovWVLVieOTW=NwrRmA@mail.gmail.com>
Subject: Re: [PATCH resend mm,net-next 3/3] net-zerocopy: Use
 vm_insert_pages() for tcp rcv zerocopy.
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Arjun Roy <arjunroy.kdev@gmail.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, linux-mm@kvack.org,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 10, 2020 at 12:04 PM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Fri, 21 Feb 2020 13:21:41 -0800 Arjun Roy <arjunroy@google.com> wrote:
>
> > I remain a bit concerned regarding the merge process for this specific
> > patch (0003, the net/ipv4/tcp.c change) since I have other in-flight
> > changes for TCP receive zerocopy that I'd like to upstream for
> > net-next - and would like to avoid weird merge issues.
> >
> > So perhaps the following could work:
> >
> > 1. Andrew, perhaps we could remove this particular patch (0003, the
> > net/ipv4/tcp.c change) from mm-next; that way we merge
> > vm_insert_pages() but not the call-site within TCP, for now.
> > 2. net-next will eventually pick vm_insert_pages() up.
> > 3. I can modify the zerocopy code to use it at that point?
> >
> > Else I'm concerned a complicated merge situation may result.
>
> The merge situation is quite clean.
>
> I guess I'll hold off on
> net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy.patch (below) and
> shall send it to davem after Linus has merged the prerequisites.
>

Acknowledged, thank you!
(resend because gmail conveniently forgot my plain text mode preference...)

-Arjun

>
> From: Arjun Roy <arjunroy@google.com>
> Subject: net-zerocopy: use vm_insert_pages() for tcp rcv zerocopy
>
> Use vm_insert_pages() for tcp receive zerocopy.  Spin lock cycles (as
> reported by perf) drop from a couple of percentage points to a fraction of
> a percent.  This results in a roughly 6% increase in efficiency, measured
> roughly as zerocopy receive count divided by CPU utilization.
>
> The intention of this patchset is to reduce atomic ops for tcp zerocopy
> receives, which normally hits the same spinlock multiple times
> consecutively.
>
> [akpm@linux-foundation.org: suppress gcc-7.2.0 warning]
> Link: http://lkml.kernel.org/r/20200128025958.43490-3-arjunroy.kdev@gmail.com
> Signed-off-by: Arjun Roy <arjunroy@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
> Cc: David Miller <davem@davemloft.net>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  net/ipv4/tcp.c |   70 ++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 63 insertions(+), 7 deletions(-)
>
> --- a/net/ipv4/tcp.c~net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy
> +++ a/net/ipv4/tcp.c
> @@ -1734,14 +1734,48 @@ int tcp_mmap(struct file *file, struct s
>  }
>  EXPORT_SYMBOL(tcp_mmap);
>
> +static int tcp_zerocopy_vm_insert_batch(struct vm_area_struct *vma,
> +                                       struct page **pages,
> +                                       unsigned long pages_to_map,
> +                                       unsigned long *insert_addr,
> +                                       u32 *length_with_pending,
> +                                       u32 *seq,
> +                                       struct tcp_zerocopy_receive *zc)
> +{
> +       unsigned long pages_remaining = pages_to_map;
> +       int bytes_mapped;
> +       int ret;
> +
> +       ret = vm_insert_pages(vma, *insert_addr, pages, &pages_remaining);
> +       bytes_mapped = PAGE_SIZE * (pages_to_map - pages_remaining);
> +       /* Even if vm_insert_pages fails, it may have partially succeeded in
> +        * mapping (some but not all of the pages).
> +        */
> +       *seq += bytes_mapped;
> +       *insert_addr += bytes_mapped;
> +       if (ret) {
> +               /* But if vm_insert_pages did fail, we have to unroll some state
> +                * we speculatively touched before.
> +                */
> +               const int bytes_not_mapped = PAGE_SIZE * pages_remaining;
> +               *length_with_pending -= bytes_not_mapped;
> +               zc->recv_skip_hint += bytes_not_mapped;
> +       }
> +       return ret;
> +}
> +
>  static int tcp_zerocopy_receive(struct sock *sk,
>                                 struct tcp_zerocopy_receive *zc)
>  {
>         unsigned long address = (unsigned long)zc->address;
>         u32 length = 0, seq, offset, zap_len;
> +       #define PAGE_BATCH_SIZE 8
> +       struct page *pages[PAGE_BATCH_SIZE];
>         const skb_frag_t *frags = NULL;
>         struct vm_area_struct *vma;
>         struct sk_buff *skb = NULL;
> +       unsigned long pg_idx = 0;
> +       unsigned long curr_addr;
>         struct tcp_sock *tp;
>         int inq;
>         int ret;
> @@ -1754,6 +1788,8 @@ static int tcp_zerocopy_receive(struct s
>
>         sock_rps_record_flow(sk);
>
> +       tp = tcp_sk(sk);
> +
>         down_read(&current->mm->mmap_sem);
>
>         ret = -EINVAL;
> @@ -1762,7 +1798,6 @@ static int tcp_zerocopy_receive(struct s
>                 goto out;
>         zc->length = min_t(unsigned long, zc->length, vma->vm_end - address);
>
> -       tp = tcp_sk(sk);
>         seq = tp->copied_seq;
>         inq = tcp_inq(sk);
>         zc->length = min_t(u32, zc->length, inq);
> @@ -1774,8 +1809,20 @@ static int tcp_zerocopy_receive(struct s
>                 zc->recv_skip_hint = zc->length;
>         }
>         ret = 0;
> +       curr_addr = address;
>         while (length + PAGE_SIZE <= zc->length) {
>                 if (zc->recv_skip_hint < PAGE_SIZE) {
> +                       /* If we're here, finish the current batch. */
> +                       if (pg_idx) {
> +                               ret = tcp_zerocopy_vm_insert_batch(vma, pages,
> +                                                                  pg_idx,
> +                                                                  &curr_addr,
> +                                                                  &length,
> +                                                                  &seq, zc);
> +                               if (ret)
> +                                       goto out;
> +                               pg_idx = 0;
> +                       }
>                         if (skb) {
>                                 if (zc->recv_skip_hint > 0)
>                                         break;
> @@ -1784,7 +1831,6 @@ static int tcp_zerocopy_receive(struct s
>                         } else {
>                                 skb = tcp_recv_skb(sk, seq, &offset);
>                         }
> -
>                         zc->recv_skip_hint = skb->len - offset;
>                         offset -= skb_headlen(skb);
>                         if ((int)offset < 0 || skb_has_frag_list(skb))
> @@ -1808,14 +1854,24 @@ static int tcp_zerocopy_receive(struct s
>                         zc->recv_skip_hint -= remaining;
>                         break;
>                 }
> -               ret = vm_insert_page(vma, address + length,
> -                                    skb_frag_page(frags));
> -               if (ret)
> -                       break;
> +               pages[pg_idx] = skb_frag_page(frags);
> +               pg_idx++;
>                 length += PAGE_SIZE;
> -               seq += PAGE_SIZE;
>                 zc->recv_skip_hint -= PAGE_SIZE;
>                 frags++;
> +               if (pg_idx == PAGE_BATCH_SIZE) {
> +                       ret = tcp_zerocopy_vm_insert_batch(vma, pages, pg_idx,
> +                                                          &curr_addr, &length,
> +                                                          &seq, zc);
> +                       if (ret)
> +                               goto out;
> +                       pg_idx = 0;
> +               }
> +       }
> +       if (pg_idx) {
> +               ret = tcp_zerocopy_vm_insert_batch(vma, pages, pg_idx,
> +                                                  &curr_addr, &length, &seq,
> +                                                  zc);
>         }
>  out:
>         up_read(&current->mm->mmap_sem);
> _
>
