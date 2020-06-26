Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEA0620AF30
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 11:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbgFZJpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 05:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726836AbgFZJpw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 05:45:52 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF3DCC08C5DB
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 02:45:51 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id h22so2490741lji.9
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 02:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=5XWtFWgwZnD66tBDM/3i+lmk/MTgyC/Rg07cXurUlV8=;
        b=mJW7dH1liKL64hBpVLiWMMacAp5RmxEToSnRzbALmrc8CTk7EhcIDsLbXtzD7HKjoG
         tFgSic4SueaSPjTyvSSc921loJilw6ile5F8SqNObI6Wqtk8pfyYZOKfQXD9ZmuZI6P6
         yowUcEJcL85BNQ60LXU8ymxE9NMnD6ySR9qGA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=5XWtFWgwZnD66tBDM/3i+lmk/MTgyC/Rg07cXurUlV8=;
        b=cBfry+wpihRLOiFxSui7FZkjbPsox7UWYPRGmGxo3eP4p1mKDKfp10M+GBfS9hQpU6
         AtkIsxVu0xk1BVwtREuHhEdAZwV5mSQ/FX5X5/YHvvpQcqS5DbmnAyz8YZjbZsFS3pR2
         gh2r7+o7lTTUHWZn7niuM2GDMb+tuUWz7rF3vYBdZ9S9hrVRZciQi6e4mNl3ZO8ko+0U
         knI5FMTd6zLQpmRgxbvWO8eYDxEX1T5Z6B5F0Jqf1bNlnUrNgE5gQW0bNoQzTTgFKoO2
         6h6oS/BtYUG5satJYQt00C49119blKZJVOfpiHt5MX8G9fDh1efQoyOorYPEaTLfyHOy
         n4jg==
X-Gm-Message-State: AOAM532TIus591CIvnMdwKvByF/jjrU930paRuv7CF4C2wqkZDt/5+0s
        +NWmHsKQWTmsq97l2W4kdElfPg==
X-Google-Smtp-Source: ABdhPJyQhsH57f44jLnzS4ztkkIc8i1c/lOljaceK1e1Z14DG2IMs8pEpfRegX8FeRB7md053E3jLg==
X-Received: by 2002:a2e:991:: with SMTP id 139mr1004349ljj.314.1593164750141;
        Fri, 26 Jun 2020 02:45:50 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id n8sm6292176lji.126.2020.06.26.02.45.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2020 02:45:49 -0700 (PDT)
References: <20200625141357.910330-1-jakub@cloudflare.com> <20200625141357.910330-3-jakub@cloudflare.com> <CAEf4Bzar93mCMm5vgMiYu6_m2N=icv2Wgmy2ohuKoQr810Kk1w@mail.gmail.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Subject: Re: [PATCH bpf-next v3 2/4] bpf, netns: Keep attached programs in bpf_prog_array
In-reply-to: <CAEf4Bzar93mCMm5vgMiYu6_m2N=icv2Wgmy2ohuKoQr810Kk1w@mail.gmail.com>
Date:   Fri, 26 Jun 2020 11:45:48 +0200
Message-ID: <87imfema7n.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 25, 2020 at 10:50 PM CEST, Andrii Nakryiko wrote:
> On Thu, Jun 25, 2020 at 7:17 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>>
>> Prepare for having multi-prog attachments for new netns attach types by
>> storing programs to run in a bpf_prog_array, which is well suited for
>> iterating over programs and running them in sequence.
>>
>> After this change bpf(PROG_QUERY) may block to allocate memory in
>> bpf_prog_array_copy_to_user() for collected program IDs. This forces a
>> change in how we protect access to the attached program in the query
>> callback. Because bpf_prog_array_copy_to_user() can sleep, we switch from
>> an RCU read lock to holding a mutex that serializes updaters.
>>
>> Because we allow only one BPF flow_dissector program to be attached to
>> netns at all times, the bpf_prog_array pointed by net->bpf.run_array is
>> always either detached (null) or one element long.
>>
>> No functional changes intended.
>>
>> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>> ---
>
> I wonder if instead of NULL prog_array, it's better to just use a
> dummy empty (but allocated) array. Might help eliminate some of the
> IFs, maybe even in the hot path.

That was my initial approach, which I abandoned seeing that it leads to
replacing NULL prog_array checks in flow_dissector with
bpf_prog_array_is_empty() checks to determine which netns has a BPF
program attached. So no IFs gone there.

While on the hot path, where we run the program, we probably would still
be left with an IF checking for empty prog_array to avoid building the
context if no progs will RUN.

The checks I'm referring to are on attach path, in
flow_dissector_bpf_prog_attach_check(), and hot-path,
__skb_flow_dissect().

>
>
>>  include/net/netns/bpf.h    |   5 +-
>>  kernel/bpf/net_namespace.c | 120 +++++++++++++++++++++++++------------
>>  net/core/flow_dissector.c  |  19 +++---
>>  3 files changed, 96 insertions(+), 48 deletions(-)
>>
>
> [...]
>
>
>>
>> +/* Must be called with netns_bpf_mutex held. */
>> +static int __netns_bpf_prog_query(const union bpf_attr *attr,
>> +                                 union bpf_attr __user *uattr,
>> +                                 struct net *net,
>> +                                 enum netns_bpf_attach_type type)
>> +{
>> +       __u32 __user *prog_ids = u64_to_user_ptr(attr->query.prog_ids);
>> +       struct bpf_prog_array *run_array;
>> +       u32 prog_cnt = 0, flags = 0;
>> +
>> +       run_array = rcu_dereference_protected(net->bpf.run_array[type],
>> +                                             lockdep_is_held(&netns_bpf_mutex));
>> +       if (run_array)
>> +               prog_cnt = bpf_prog_array_length(run_array);
>> +
>> +       if (copy_to_user(&uattr->query.attach_flags, &flags, sizeof(flags)))
>> +               return -EFAULT;
>> +       if (copy_to_user(&uattr->query.prog_cnt, &prog_cnt, sizeof(prog_cnt)))
>> +               return -EFAULT;
>> +       if (!attr->query.prog_cnt || !prog_ids || !prog_cnt)
>> +               return 0;
>> +
>> +       return bpf_prog_array_copy_to_user(run_array, prog_ids,
>> +                                          attr->query.prog_cnt);
>
> It doesn't seem like bpf_prog_array_copy_to_user can handle NULL run_array

Correct. And we never invoke it when run_array is NULL because then
prog_cnt == 0.

>
>> +}
>> +
>>  int netns_bpf_prog_query(const union bpf_attr *attr,
>>                          union bpf_attr __user *uattr)
>>  {
>> -       __u32 __user *prog_ids = u64_to_user_ptr(attr->query.prog_ids);
>> -       u32 prog_id, prog_cnt = 0, flags = 0;
>>         enum netns_bpf_attach_type type;
>> -       struct bpf_prog *attached;
>>         struct net *net;
>> +       int ret;
>>
>>         if (attr->query.query_flags)
>>                 return -EINVAL;
>
> [...]
