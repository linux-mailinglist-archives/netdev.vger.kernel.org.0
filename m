Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B09C5204A43
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 08:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730720AbgFWG4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 02:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730583AbgFWG4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 02:56:22 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A746C061573;
        Mon, 22 Jun 2020 23:56:22 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id i16so14618949qtr.7;
        Mon, 22 Jun 2020 23:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tUBJjNtTMQFGN+holuFcQjhryb9trvn8k0jvRFsvvl4=;
        b=gGSFnbV34EGSmg+8IFJtm8rHkI6BqknBjNEOMAP35gjv+6o4Mf55XdnGWZ5dQHlYdD
         VhMt/wJnpqknqUQgs0M75dHj+FUlrOm7bwVZ/htl6Fnn+d7hmzqVVm8ASue+SXhJt63y
         l2zbZyC0q5EsYEn9PF3jSiPbVC38nmyI3PhQS+s78klxTgTn59UNdqO9WwdDPomGJSur
         1jiQiWVU4K6goRP+W3lP1ZFShW/chbPXlY8KIibmHNq0TGrxooHM5bUT5t5dxiZ5vYEo
         NERSpA8EBhXVBtMdPxpOBWwCR6ESxGTvfCMySpwoD5PyPoVMPwQMeEHwmxrG+v1j3T5H
         NedA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tUBJjNtTMQFGN+holuFcQjhryb9trvn8k0jvRFsvvl4=;
        b=I7SjjLSZYVva+wIq/mBnDCbHsZN4ruh8GlLd3L8YDtQu1H6Gs1QtYT9NRm/L57UGXI
         ygRPnvajCzeB77QNlrI5ePxO28Am7ECcttCbaOlgokQGK6EaH34vnq3nLj0PtZaVA+79
         DOpuLq5CwU5Ymroewlud5M9PClUmn/hXW1Kva46otyqiAMXGc6rsa2YgDaJWTBJcCcKx
         gwZHOit3pfXhY3P0upwKB38Q8LQD+iFNXj4PlTVUbL163BXKSjTsa1zhP4KkzwLvv021
         kY7drbZ4CCNpE/G/khJW2jSeExA/QLOJGbCOvcT8p+/LW2dnlybSS3M44cbZfHe8FuBq
         VCUA==
X-Gm-Message-State: AOAM532FOc060COl6C1gG5D/pv+UMQ6BwC7noFHRoBIblr/rVbmAa5TL
        XdDnMCl0r1V4/ngtiqPVN2v8j87R9zR8HaWorTI=
X-Google-Smtp-Source: ABdhPJyvplbRScpoV9iwi2MifFsdUscZPK1KUKm6qDY+15v/kqtPJHDkP6FJOBl4VA/7ueX3Q95JwFWsgaUe+oYsCnk=
X-Received: by 2002:ac8:42ce:: with SMTP id g14mr20117869qtm.117.1592895381571;
 Mon, 22 Jun 2020 23:56:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200623003626.3072825-1-yhs@fb.com> <20200623003641.3074883-1-yhs@fb.com>
In-Reply-To: <20200623003641.3074883-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 22 Jun 2020 23:56:10 -0700
Message-ID: <CAEf4BzatNEOJSuM2t-1eLQuT4E8gcRLB38B=rqZU3G=vVGkizQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 13/15] tools/bpf: selftests: implement sample
 tcp/tcp6 bpf_iter programs
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 22, 2020 at 5:38 PM Yonghong Song <yhs@fb.com> wrote:
>
> In my VM, I got identical result compared to /proc/net/{tcp,tcp6}.
> For tcp6:
>   $ cat /proc/net/tcp6
>     sl  local_address                         remote_address                        st tx_queue rx_queue tr tm->when retrnsmt   uid  timeout inode
>      0: 00000000000000000000000000000000:0016 00000000000000000000000000000000:0000 0A 00000000:00000000 00:00000001 00000000     0        0 17955 1 000000003eb3102e 100 0 0 10 0
>
>   $ cat /sys/fs/bpf/p1
>     sl  local_address                         remote_address                        st tx_queue rx_queue tr tm->when retrnsmt   uid  timeout inode
>      0: 00000000000000000000000000000000:0016 00000000000000000000000000000000:0000 0A 00000000:00000000 00:00000000 00000000     0        0 17955 1 000000003eb3102e 100 0 0 10 0
>
> For tcp:
>   $ cat /proc/net/tcp
>   sl  local_address rem_address   st tx_queue rx_queue tr tm->when retrnsmt   uid  timeout inode
>    0: 00000000:0016 00000000:0000 0A 00000000:00000000 00:00000000 00000000     0        0 2666 1 000000007152e43f 100 0 0 10 0
>   $ cat /sys/fs/bpf/p2
>   sl  local_address                         remote_address                        st tx_queue rx_queue tr tm->when retrnsmt   uid  timeout inode
>    1: 00000000:0016 00000000:0000 0A 00000000:00000000 00:00000000 00000000     0        0 2666 1 000000007152e43f 100 0 0 10 0
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

Looks reasonable, to the extent possible ;)

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/testing/selftests/bpf/progs/bpf_iter.h  |  15 ++
>  .../selftests/bpf/progs/bpf_iter_tcp4.c       | 235 ++++++++++++++++
>  .../selftests/bpf/progs/bpf_iter_tcp6.c       | 250 ++++++++++++++++++
>  3 files changed, 500 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_tcp4.c
>  create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_tcp6.c
>

[...]

> +static int hlist_unhashed_lockless(const struct hlist_node *h)
> +{
> +        return !(h->pprev);
> +}
> +
> +static int timer_pending(const struct timer_list * timer)
> +{
> +       return !hlist_unhashed_lockless(&timer->entry);
> +}
> +
> +extern unsigned CONFIG_HZ __kconfig __weak;

Why the __weak? We expect to have /proc/kconfig.gz in other tests
anyway? __weak will make CONFIG_HZ to be a zero and you'll get a bunch
of divisions by zero.

> +
> +#define USER_HZ                100
> +#define NSEC_PER_SEC   1000000000ULL
> +static clock_t jiffies_to_clock_t(unsigned long x)
> +{
> +       /* The implementation here tailored to a particular
> +        * setting of USER_HZ.
> +        */
> +       u64 tick_nsec = (NSEC_PER_SEC + CONFIG_HZ/2) / CONFIG_HZ;
> +       u64 user_hz_nsec = NSEC_PER_SEC / USER_HZ;
> +
> +       if ((tick_nsec % user_hz_nsec) == 0) {
> +               if (CONFIG_HZ < USER_HZ)
> +                       return x * (USER_HZ / CONFIG_HZ);
> +               else
> +                       return x / (CONFIG_HZ / USER_HZ);
> +       }
> +       return x * tick_nsec/user_hz_nsec;
> +}
> +

[...]

> +       if (sk_common->skc_family != AF_INET)
> +               return 0;
> +
> +       tp = bpf_skc_to_tcp_sock(sk_common);
> +       if (tp) {
> +               return dump_tcp_sock(seq, tp, uid, seq_num);
> +       }

nit: unnecessary {}

> +
> +       tw = bpf_skc_to_tcp_timewait_sock(sk_common);
> +       if (tw)
> +               return dump_tw_sock(seq, tw, uid, seq_num);
> +
> +       req = bpf_skc_to_tcp_request_sock(sk_common);
> +       if (req)
> +               return dump_req_sock(seq, req, uid, seq_num);
> +
> +       return 0;
> +}

[...]

> +static int timer_pending(const struct timer_list * timer)
> +{
> +       return !hlist_unhashed_lockless(&timer->entry);
> +}
> +
> +extern unsigned CONFIG_HZ __kconfig __weak;

same about __weak here

> +
> +#define USER_HZ                100
> +#define NSEC_PER_SEC   1000000000ULL
> +static clock_t jiffies_to_clock_t(unsigned long x)
> +{
> +       /* The implementation here tailored to a particular
> +        * setting of USER_HZ.
> +        */
> +       u64 tick_nsec = (NSEC_PER_SEC + CONFIG_HZ/2) / CONFIG_HZ;
> +       u64 user_hz_nsec = NSEC_PER_SEC / USER_HZ;
> +
> +       if ((tick_nsec % user_hz_nsec) == 0) {
> +               if (CONFIG_HZ < USER_HZ)
> +                       return x * (USER_HZ / CONFIG_HZ);
> +               else
> +                       return x / (CONFIG_HZ / USER_HZ);
> +       }
> +       return x * tick_nsec/user_hz_nsec;
> +}

nit: jiffies_to_clock_t() implementation looks like an overkill for
this use case... Would it be just `x / CONFIG_HZ * NSEC_PER_SEC` with
some potential rounding error?

> +
> +static clock_t jiffies_delta_to_clock_t(long delta)
> +{
> +       if (delta <= 0)
> +               return 0;
> +
> +       return jiffies_to_clock_t(delta);
> +}
> +

[...]
