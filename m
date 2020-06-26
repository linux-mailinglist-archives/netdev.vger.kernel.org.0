Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9860720BC3F
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 00:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725861AbgFZWNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 18:13:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbgFZWNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 18:13:52 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B98C03E979;
        Fri, 26 Jun 2020 15:13:52 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id b4so10215619qkn.11;
        Fri, 26 Jun 2020 15:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DFFDjNNXEfjCWIRy9/fBc5oNNA3yVMHmIODUCwXA8NA=;
        b=b/2ZlOrfQLgTNlE/XSG0YqSv/rhPBHTR/T++5VP25mygu27YN7S/y2ZJC1jpD6gAYa
         gBI4lLmERUU4g4unuP8zHsgRWDftp/KiHVnLBdGPlBUXBQP956GM2nRG1jKY6qz4mEVl
         EGoHUAZNB+M0IywcRn4EIwUMP5oPjO4psWGPGa5xEm8dAuWlXrh8MTVGGntDNBL07yxL
         0wKWp0vuZ4f0tcHwwanvTomeVB4N1AL49e4Piw9Mj+5CEv9ogYG63TlFg+ycqy1VH5R2
         zQplpBBT2Rg2LGSfkLb0CxKW6rmsiyRXhpCZGhwiIbYSdSOk0AAc9TMyp0tkeI+Rzxhf
         7rfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DFFDjNNXEfjCWIRy9/fBc5oNNA3yVMHmIODUCwXA8NA=;
        b=Bqh65+FOJhbs4+ZsVZGk6UzKGbN5Rgu09PiRFtcdoeEoA/bUM3IiNd/Lk75e8JKWMt
         6rF9z7wQXK6bl3ilbxubM1XQ2/8yCy6g3wyjlgXkYvIJxp1W6EV9L/CKLiYvVOoVGmJq
         eG/ygvNNOYWUEacE6NKWFudIjnBIHOQlGuLkAH1Igc3efiHdTzmuECNU5cb3sGQWIt3D
         rpYLRLTqQIZR2xqCqf/5TTwx2ugekwWkVHEY2zPLMUBhg5W193PtwhJYIc6k/eFJFl0a
         r8cFwnPhrx3sifOy66fcr4/waRWEkSMWZIM61xjCQWPEmrSHKVXk3uWI+gnTdb6V5YeL
         ERfA==
X-Gm-Message-State: AOAM5320D8sNu8MEIQwQLrMHjrEDKf+krhgus8U2M2FDtLLQ/R6JQyol
        B/L3Bk4ACgqvsxIPUAt0gmZZST0M8/r8w7JxVOA=
X-Google-Smtp-Source: ABdhPJzDBfJN4g5bLZW/TxdRek21XEd8/ob9dpigYZ3pZ50064nenlx+h7aOS+yCHXv6B42ZB7JmBA9UntirSkhV5jE=
X-Received: by 2002:a05:620a:12d2:: with SMTP id e18mr5062397qkl.437.1593209631410;
 Fri, 26 Jun 2020 15:13:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200625141357.910330-1-jakub@cloudflare.com> <20200625141357.910330-3-jakub@cloudflare.com>
 <CAEf4Bzar93mCMm5vgMiYu6_m2N=icv2Wgmy2ohuKoQr810Kk1w@mail.gmail.com> <87imfema7n.fsf@cloudflare.com>
In-Reply-To: <87imfema7n.fsf@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 26 Jun 2020 15:13:40 -0700
Message-ID: <CAEf4BzbW+xVRmxhmm35CbArzXTTaXJ_ByK2UKB3XCnvwhNE7xg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 2/4] bpf, netns: Keep attached programs in bpf_prog_array
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 2:45 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Thu, Jun 25, 2020 at 10:50 PM CEST, Andrii Nakryiko wrote:
> > On Thu, Jun 25, 2020 at 7:17 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
> >>
> >> Prepare for having multi-prog attachments for new netns attach types by
> >> storing programs to run in a bpf_prog_array, which is well suited for
> >> iterating over programs and running them in sequence.
> >>
> >> After this change bpf(PROG_QUERY) may block to allocate memory in
> >> bpf_prog_array_copy_to_user() for collected program IDs. This forces a
> >> change in how we protect access to the attached program in the query
> >> callback. Because bpf_prog_array_copy_to_user() can sleep, we switch from
> >> an RCU read lock to holding a mutex that serializes updaters.
> >>
> >> Because we allow only one BPF flow_dissector program to be attached to
> >> netns at all times, the bpf_prog_array pointed by net->bpf.run_array is
> >> always either detached (null) or one element long.
> >>
> >> No functional changes intended.
> >>
> >> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> >> ---
> >
> > I wonder if instead of NULL prog_array, it's better to just use a
> > dummy empty (but allocated) array. Might help eliminate some of the
> > IFs, maybe even in the hot path.
>
> That was my initial approach, which I abandoned seeing that it leads to
> replacing NULL prog_array checks in flow_dissector with
> bpf_prog_array_is_empty() checks to determine which netns has a BPF
> program attached. So no IFs gone there.
>
> While on the hot path, where we run the program, we probably would still
> be left with an IF checking for empty prog_array to avoid building the
> context if no progs will RUN.
>
> The checks I'm referring to are on attach path, in
> flow_dissector_bpf_prog_attach_check(), and hot-path,
> __skb_flow_dissect().
>

Fair enough.

> >
> >
> >>  include/net/netns/bpf.h    |   5 +-
> >>  kernel/bpf/net_namespace.c | 120 +++++++++++++++++++++++++------------
> >>  net/core/flow_dissector.c  |  19 +++---
> >>  3 files changed, 96 insertions(+), 48 deletions(-)
> >>
> >
> > [...]
> >
> >
> >>
> >> +/* Must be called with netns_bpf_mutex held. */
> >> +static int __netns_bpf_prog_query(const union bpf_attr *attr,
> >> +                                 union bpf_attr __user *uattr,
> >> +                                 struct net *net,
> >> +                                 enum netns_bpf_attach_type type)
> >> +{
> >> +       __u32 __user *prog_ids = u64_to_user_ptr(attr->query.prog_ids);
> >> +       struct bpf_prog_array *run_array;
> >> +       u32 prog_cnt = 0, flags = 0;
> >> +
> >> +       run_array = rcu_dereference_protected(net->bpf.run_array[type],
> >> +                                             lockdep_is_held(&netns_bpf_mutex));
> >> +       if (run_array)
> >> +               prog_cnt = bpf_prog_array_length(run_array);
> >> +
> >> +       if (copy_to_user(&uattr->query.attach_flags, &flags, sizeof(flags)))
> >> +               return -EFAULT;
> >> +       if (copy_to_user(&uattr->query.prog_cnt, &prog_cnt, sizeof(prog_cnt)))
> >> +               return -EFAULT;
> >> +       if (!attr->query.prog_cnt || !prog_ids || !prog_cnt)
> >> +               return 0;
> >> +
> >> +       return bpf_prog_array_copy_to_user(run_array, prog_ids,
> >> +                                          attr->query.prog_cnt);
> >
> > It doesn't seem like bpf_prog_array_copy_to_user can handle NULL run_array
>
> Correct. And we never invoke it when run_array is NULL because then
> prog_cnt == 0.

Oh, that !prog_cnt above, right.. it's easy to miss.

>
> >
> >> +}
> >> +
> >>  int netns_bpf_prog_query(const union bpf_attr *attr,
> >>                          union bpf_attr __user *uattr)
> >>  {
> >> -       __u32 __user *prog_ids = u64_to_user_ptr(attr->query.prog_ids);
> >> -       u32 prog_id, prog_cnt = 0, flags = 0;
> >>         enum netns_bpf_attach_type type;
> >> -       struct bpf_prog *attached;
> >>         struct net *net;
> >> +       int ret;
> >>
> >>         if (attr->query.query_flags)
> >>                 return -EINVAL;
> >
> > [...]
