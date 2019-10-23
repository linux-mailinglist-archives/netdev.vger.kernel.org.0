Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBCFE0F92
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 03:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732328AbfJWBKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 21:10:39 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37251 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732188AbfJWBKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 21:10:39 -0400
Received: by mail-pg1-f196.google.com with SMTP id p1so11070264pgi.4
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 18:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=suKcbjs27TNYLjQ5qKmsBBPJ/AYcEvEyPi0zqfkfKQA=;
        b=ZPJahJn+BucCm8sRjzWxhSVAT/hGhQ0KNUbbxAFh5Gf3PQEtAhxJ6eAR2E0ENZ+JmX
         xB/1MkJ6d4QNYLs9Eh9K+me+Ls6LQ4d2zIF4/jU6ZcEu8hmEO50s8HyYWQWxpdUx/Pck
         ILTySWpM4KaC7Ai+Oauqje3lgpsmx1mioOpm30UKgyQGiDH7G5O+ym+ECXW8j/qJHOEu
         I+AbmfF5WHtBD1Eie32zKR8BkfClLjRnhV5dKtTxXgh+hW4iH3w7sB93cyuNqUirgVMn
         OLt+CCtMKndTuyE68jH+938AQ8sMbThRElsZiBJqWRVDRlHjL54hpkS1n69QBSgoZnBH
         y7ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=suKcbjs27TNYLjQ5qKmsBBPJ/AYcEvEyPi0zqfkfKQA=;
        b=U4b7A5p6sLuVTraASwThd2mWe1EnnnsU6OSQXYnGDkUNCeKv8Y8NghleY44Mwjze7W
         atg497yRQOh5J7WeDzcqhHes7BMRJa/zepGVqm1FLWGBg5ZwbIhbUtzE35IJ40NOCe0a
         tGj+UxraBzNSV1GdH6GQD8cS7n9iXl7XJ5X2+6snuAEisEheH+Y7D4yhCGoe9gaIeBkY
         tW81jV6Q0oyoMFhRX5uCYEkhbvkGBQH5Y7q12SIbzOVgv9JnAyTjYz/I1FRo67fKVrUy
         WZ9WEtPRp3z1ZWaqIt/STHAgNt4bojWGFCMrs8kHTokocfzU48eXpr1KWfmb09bu/PTX
         XHIA==
X-Gm-Message-State: APjAAAWh+bLuIVnXhe/JS17JQAETIZwCcNIX2xkVnpPNF07oyk0VCeuH
        V74fsE/dM8b9k0EfghHs8SeseNq6IshZy6L1h44=
X-Google-Smtp-Source: APXvYqwR9XlO4o1tjWqnXoC5EU+I/WVtfLatg1RhxvgpgBZ6c3DlSvctSWTkUriEvNSydVlqgY5GRwXAL1wSMJOjMOs=
X-Received: by 2002:a63:a849:: with SMTP id i9mr6689630pgp.237.1571793038756;
 Tue, 22 Oct 2019 18:10:38 -0700 (PDT)
MIME-Version: 1.0
References: <20191022231051.30770-1-xiyou.wangcong@gmail.com>
 <20191022231051.30770-4-xiyou.wangcong@gmail.com> <CANn89i+Y+fMqPbT-YyKcbQOH96+D=U8K4wnNgFkGYtjStKPrEQ@mail.gmail.com>
In-Reply-To: <CANn89i+Y+fMqPbT-YyKcbQOH96+D=U8K4wnNgFkGYtjStKPrEQ@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 22 Oct 2019 18:10:27 -0700
Message-ID: <CAM_iQpWxDN7Wm_ar7cStiMnhmmy7RK=BG5k4zwD+K6kbgfPEKw@mail.gmail.com>
Subject: Re: [Patch net-next 3/3] tcp: decouple TLP timer from RTO timer
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>, Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 4:24 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Oct 22, 2019 at 4:11 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > Currently RTO, TLP and PROBE0 all share a same timer instance
> > in kernel and use icsk->icsk_pending to dispatch the work.
> > This causes spinlock contention when resetting the timer is
> > too frequent, as clearly shown in the perf report:
> >
> >    61.72%    61.71%  swapper          [kernel.kallsyms]                        [k] queued_spin_lock_slowpath
> >    ...
> >     - 58.83% tcp_v4_rcv
> >       - 58.80% tcp_v4_do_rcv
> >          - 58.80% tcp_rcv_established
> >             - 52.88% __tcp_push_pending_frames
> >                - 52.88% tcp_write_xmit
> >                   - 28.16% tcp_event_new_data_sent
> >                      - 28.15% sk_reset_timer
> >                         + mod_timer
> >                   - 24.68% tcp_schedule_loss_probe
> >                      - 24.68% sk_reset_timer
> >                         + 24.68% mod_timer
> >
> > This patch decouples TLP timer from RTO timer by adding a new
> > timer instance but still uses icsk->icsk_pending to dispatch,
> > in order to minimize the risk of this patch.
> >
> > After this patch, the CPU time spent in tcp_write_xmit() reduced
> > down to 10.92%.
>
> What is the exact benchmark you are running ?
>
> We never saw any contention like that, so lets make sure you are not
> working around another issue.

I simply ran 256 parallel netperf with 128 CPU's to trigger this
spinlock contention, 100% reproducible here.

A single netperf TCP_RR could _also_ confirm the improvement:

Before patch:

$ netperf -H XXX -t TCP_RR -l 20
MIGRATED TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0
AF_INET to XXX () port 0 AF_INET : first burst 0
Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate
bytes  Bytes  bytes    bytes   secs.    per sec

655360 873800 1        1       20.00    17665.59
655360 873800


After patch:

$ netperf -H XXX -t TCP_RR -l 20
MIGRATED TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0
AF_INET to XXX () port 0 AF_INET : first burst 0
Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate
bytes  Bytes  bytes    bytes   secs.    per sec

655360 873800 1        1       20.00    18829.31
655360 873800

(I have run it for multiple times, just pick a median one here.)

The difference can also be observed by turning off/on TLP without patch.

Thanks.
