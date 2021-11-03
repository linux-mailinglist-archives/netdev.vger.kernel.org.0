Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0994446C3
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 18:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbhKCRPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 13:15:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbhKCRPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 13:15:02 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0137DC061714;
        Wed,  3 Nov 2021 10:12:26 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id o12so1555524qtv.4;
        Wed, 03 Nov 2021 10:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9Yon/UNkvBv++0ELrNkjj8vCgTMl+XYKOntpW9f64Bw=;
        b=HjYxBmcoWQoUGLuHCKKWEKX5kjOjXU6KFT8ycDPcR5Bas9M2mFqKPjupkNJ58t6CJB
         YeOi0TDsj2ij/2mgqSHhaLPa8C1n/UvAYKEycX3B1WLXXUfs2FS1q27V3Lh1+/KzNkUJ
         tD4fOQdX8uCaiQu+AFLzrgULjsdyEwAUPO+b1gryzbfrE06GL/Br9FYLcGsTzmUQKALY
         i1kO1e/a/vNzdmNPvPA7Z2B++Fykd9xmlCCPshu342G1bF1W2XgM5F6cvNUYD71kThEJ
         TBOzm3a11joNl4svA9qA81MH5EWs3eD0HCrR0WgDLRILc60+WDddSZ4O8SgAsAV43D+g
         Uj7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9Yon/UNkvBv++0ELrNkjj8vCgTMl+XYKOntpW9f64Bw=;
        b=jAVJhxj5WejsJ2zQPZqwqV80NoVoww3XbTh4SCGBIxBlZgQJNpSQ6VLbxx2HN4VaLX
         jgcaRiMe1aG+vZALW1LnxSWHjx2S2gR+ZJ0dK+KNsbbAc6Lu06/CDSsH5h45ptIcFNL7
         ZHbZAUYAi3Upi0qAEsco7ABYvSZPoxsa1xQZxqQgk3kNUAa/ua090UBWvrIrmOFf4mdZ
         bPpHk/trNUkAqyqIhwtJJeiQKWnbA3bMCULiAX4onRI14PboDOCwsH/XNqDnhhNiLiCy
         eeJiBJzgZUiqT8sb1F6XnSg+92Gwnn/5MFvohFcOWk6J98PvvEEtJiJR49ah3jxuXAnT
         OQBw==
X-Gm-Message-State: AOAM532gtYt9X1lh5b0LufVvFLIN/rYRqbdRK2kdJ3LwlzIVIKbHhxoP
        mIgZjecfB/8RiQL0gWqd/izoDhiS4K6lpY9Khw==
X-Google-Smtp-Source: ABdhPJxq2UgyOnxT41jhoN4lP4xkSptM+QHl4MmThU3e1NiJfPJjtIHydWt1Nf7ZCOHjBe91DzZk1RJ0JUxrxUpbM+M=
X-Received: by 2002:ac8:5bd6:: with SMTP id b22mr25897430qtb.157.1635959545206;
 Wed, 03 Nov 2021 10:12:25 -0700 (PDT)
MIME-Version: 1.0
References: <20211102021432.2807760-1-jevburton.kernel@gmail.com> <aa6081aa-9741-be05-8051-e01909662ff1@mojatatu.com>
In-Reply-To: <aa6081aa-9741-be05-8051-e01909662ff1@mojatatu.com>
From:   Joe Burton <jevburton.kernel@gmail.com>
Date:   Wed, 3 Nov 2021 10:12:14 -0700
Message-ID: <CAN22DihBMX=xTMeTQ2-Z8Fa6r=1ynKshbfhFJJ5Jb=-ww_9hDQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 0/3] Introduce BPF map tracing capability
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Petar Penkov <ppenkov@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Joe Burton <jevburton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

That's a good point. Since the probe is invoked before the update takes
place, it would not be possible to account for the possibility that the
update failed.

Unless someone wants the `pre update' hook, I'll simply adjust the
existing hooks' semantics so that they are invoked after the update.
As discussed, this better suits the intended use case.

On Wed, Nov 3, 2021 at 3:34 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> On 2021-11-01 22:14, Joe Burton wrote:
> > From: Joe Burton<jevburton@google.com>
> >
> > This is the third version of a patch series implementing map tracing.
> >
> > Map tracing enables executing BPF programs upon BPF map updates. This
> > might be useful to perform upgrades of stateful programs; e.g., tracing
> > programs can propagate changes to maps that occur during an upgrade
> > operation.
> >
> > This version uses trampoline hooks to provide the capability.
> > fentry/fexit/fmod_ret programs can attach to two new functions:
> >          int bpf_map_trace_update_elem(struct bpf_map* map, void* key,
> >                  void* val, u32 flags);
> >          int bpf_map_trace_delete_elem(struct bpf_map* map, void* key);
> >
> > These hooks work as intended for the following map types:
> >          BPF_MAP_TYPE_ARRAY
> >          BPF_MAP_TYPE_PERCPU_ARRAY
> >          BPF_MAP_TYPE_HASH
> >          BPF_MAP_TYPE_PERCPU_HASH
> >          BPF_MAP_TYPE_LRU_HASH
> >          BPF_MAP_TYPE_LRU_PERCPU_HASH
> >
> > The only guarantee about the semantics of these hooks is that they execute
> > before the operation takes place. We cannot call them with locks held
> > because the hooked program might try to acquire the same locks. Thus they
> > may be invoked in situations where the traced map is not ultimately
> > updated.
>
> Sorry, I may have missed something obvious while staring at the patches,
> but:
> Dont you want the notification if the command actually was successful
> on the map? If the command failed for whatever reason theres nothing
> to synchronize? Unless you use that as an indicator to re-read the map?
>
> cheers,
> jamal
