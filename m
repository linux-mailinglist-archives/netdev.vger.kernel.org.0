Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D99AD20A713
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 22:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405184AbgFYUum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 16:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404004AbgFYUum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 16:50:42 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC34C08C5C1;
        Thu, 25 Jun 2020 13:50:41 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id j10so5811385qtq.11;
        Thu, 25 Jun 2020 13:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L5sBsv2VLcxQkwy3Z1G10hTQJuI20Eze6ofD5v+LMz0=;
        b=NTeS+7SEXEzhROIyC6OlKtFIZnj+QZ7WMHOitMgPteCYnaaTTJjtsRInZ1w0e5AaeW
         iw+EZt1JaDufB9H6Ds8rsQA6DYcRnH9q5XdcRAIDb/nZNyuspC5mfwU3EMUOlLOdruSV
         I0tkLAVeWUtNF9MFFKwBR5kuGK5n8t66dYnNnBCzagH0qu6HTtzOdscH7NDL5ZVn5K7E
         M1S6DMo+JbkIjjqQ5LdJLgmjwhkUZqYJLYSCVznS3JrLRNN+u7+9eI5S688e8csKFXOE
         7g+u7dCe/URHQ0qIUNIAzraQjjPVaR8Q11dPfollIVD47ECX27pHt1OCW3ZQHWGVHGHo
         28vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L5sBsv2VLcxQkwy3Z1G10hTQJuI20Eze6ofD5v+LMz0=;
        b=VeDAIzqC6Svcw+I8Z+3Jj69igsfmOH6H0khtqj1M7WHBvch9X8RG4R9M69aidmwcau
         QFy5W5ZaykNZkCgp+wsyWKlYXWUiInZh37VvsDIoSYVeYz9m8I6tCsj43jlJmf41vxSt
         htE5ZIHAC2+5RQiqswOzW1eIc10OubqfBAymw8nqP0VXSH5Z5u6ElvpLPyoyjuyMbmMW
         lyPJbknCNK4crCj5+CjsfM9nt09TdVmLJgVZ2gKsYAYg/LqjT1lwDdBDXKIq/Vdx0LDB
         kZmoYfOKSkmk9TlvmnvMUMSuu9UWy8ybAweesKxnOSXphSQDZAO/Qhij66ixCVDOO+lS
         tErA==
X-Gm-Message-State: AOAM5334hXWbvgBgUhCtQHte0cMGuRaBAsk4GfrFG8EvNC+7qZV37lFz
        HbNg+g4cMmFPIGHnk20PEFS9MAD0UE+sELgUcck=
X-Google-Smtp-Source: ABdhPJyr0FC5yZDOdt0VdVhuE7WqEP2MW+KZr6pWoIdQpLNUyP1ue9S6ng8xPuRXf/Fe2zU5CYzOwroH2/wO8MMcH2o=
X-Received: by 2002:ac8:2bba:: with SMTP id m55mr33744407qtm.171.1593118240960;
 Thu, 25 Jun 2020 13:50:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200625141357.910330-1-jakub@cloudflare.com> <20200625141357.910330-3-jakub@cloudflare.com>
In-Reply-To: <20200625141357.910330-3-jakub@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 25 Jun 2020 13:50:29 -0700
Message-ID: <CAEf4Bzar93mCMm5vgMiYu6_m2N=icv2Wgmy2ohuKoQr810Kk1w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 2/4] bpf, netns: Keep attached programs in bpf_prog_array
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 25, 2020 at 7:17 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> Prepare for having multi-prog attachments for new netns attach types by
> storing programs to run in a bpf_prog_array, which is well suited for
> iterating over programs and running them in sequence.
>
> After this change bpf(PROG_QUERY) may block to allocate memory in
> bpf_prog_array_copy_to_user() for collected program IDs. This forces a
> change in how we protect access to the attached program in the query
> callback. Because bpf_prog_array_copy_to_user() can sleep, we switch from
> an RCU read lock to holding a mutex that serializes updaters.
>
> Because we allow only one BPF flow_dissector program to be attached to
> netns at all times, the bpf_prog_array pointed by net->bpf.run_array is
> always either detached (null) or one element long.
>
> No functional changes intended.
>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---

I wonder if instead of NULL prog_array, it's better to just use a
dummy empty (but allocated) array. Might help eliminate some of the
IFs, maybe even in the hot path.


>  include/net/netns/bpf.h    |   5 +-
>  kernel/bpf/net_namespace.c | 120 +++++++++++++++++++++++++------------
>  net/core/flow_dissector.c  |  19 +++---
>  3 files changed, 96 insertions(+), 48 deletions(-)
>

[...]


>
> +/* Must be called with netns_bpf_mutex held. */
> +static int __netns_bpf_prog_query(const union bpf_attr *attr,
> +                                 union bpf_attr __user *uattr,
> +                                 struct net *net,
> +                                 enum netns_bpf_attach_type type)
> +{
> +       __u32 __user *prog_ids = u64_to_user_ptr(attr->query.prog_ids);
> +       struct bpf_prog_array *run_array;
> +       u32 prog_cnt = 0, flags = 0;
> +
> +       run_array = rcu_dereference_protected(net->bpf.run_array[type],
> +                                             lockdep_is_held(&netns_bpf_mutex));
> +       if (run_array)
> +               prog_cnt = bpf_prog_array_length(run_array);
> +
> +       if (copy_to_user(&uattr->query.attach_flags, &flags, sizeof(flags)))
> +               return -EFAULT;
> +       if (copy_to_user(&uattr->query.prog_cnt, &prog_cnt, sizeof(prog_cnt)))
> +               return -EFAULT;
> +       if (!attr->query.prog_cnt || !prog_ids || !prog_cnt)
> +               return 0;
> +
> +       return bpf_prog_array_copy_to_user(run_array, prog_ids,
> +                                          attr->query.prog_cnt);

It doesn't seem like bpf_prog_array_copy_to_user can handle NULL run_array

> +}
> +
>  int netns_bpf_prog_query(const union bpf_attr *attr,
>                          union bpf_attr __user *uattr)
>  {
> -       __u32 __user *prog_ids = u64_to_user_ptr(attr->query.prog_ids);
> -       u32 prog_id, prog_cnt = 0, flags = 0;
>         enum netns_bpf_attach_type type;
> -       struct bpf_prog *attached;
>         struct net *net;
> +       int ret;
>
>         if (attr->query.query_flags)
>                 return -EINVAL;

[...]
