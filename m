Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CAB234BAEA
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 06:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbhC1Eno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 00:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbhC1EnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 00:43:11 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 866D9C0613B1;
        Sat, 27 Mar 2021 21:42:51 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id o66so10160873ybg.10;
        Sat, 27 Mar 2021 21:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BQQTG8eN57WyyOH6br70k0yqKqktm8rT0M7Y08AXIKo=;
        b=pQVE+PySQMFnMAjmSDrvujNK7pl4RU3KDg0gqdXpftyc2aKmPxyiqXr4eYuMd+DdN5
         SUDwwEyyRYMF8XCKBRmgTClwm6EnqVjkp1Xp4joleXkIAq6TlG47ah67xB2eXLHl58b0
         YAKEnFWFeW9/wcQPtgWewidbE3jI//SuG39cz8jmGseOf6gywVwtFJB6yj4IeG0t7pu7
         Epe2jocOXFMH6MN2Sw/uchG3apdinrE/+GtOPrHMIK34AmbM/qov6ItRAe4NdhTumRrs
         k8G8ySSrLTh3dRc33JzBpiJMGXzDdt4KktJVVp8zM8JrJTf1FSwBDoFCBsQBpDr2WsfO
         7XYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BQQTG8eN57WyyOH6br70k0yqKqktm8rT0M7Y08AXIKo=;
        b=QbDwNFXbA9MBvnGh7Nm2xInOUetOPGVKn2x/Tje9v8auGTyz1fBKnEi+mN/cpXEwVJ
         kNK6SUyzFBWyYNiQsDP9aCk6DRpp4SsVcv5mWn3EDaSsi7Gq6lBIpccD5XJTrMG3UMMf
         F7NPE3fs2wjNGocJ1r+kgtncKPosn4VasGB5hAryA1j0DI1/aIo4s3ZUSBzEIIz57ZlI
         dLVlp8TgUub5S3dPGoGxziq8O1uUAUyK0lJpmRH/JZ+zQoe8RGRQoOW441FBPs4ls12k
         +U95YkSkAuDRLobc9FwoIAPMIzwxMNcOIeB6MaqDBTQxjyk/ISkI0pAB9L4bS8HT7UJ1
         PdsA==
X-Gm-Message-State: AOAM532OmkV4zo4DfHxtUtlUFmvkXc5wfc7MrM03RMLUfSV2xRWXyGu2
        sQVT2pE+WKx7cQaCVGslHY3Mq3MJ9f0H7hDnnLI=
X-Google-Smtp-Source: ABdhPJzo3vRP4nEJxeKRHLYQH5KJI+igRifdlzr2HwtIN42Y7q0yHry1zBuQggFA9tTEoqE2//U9U725PBORpEhXsoc=
X-Received: by 2002:a25:ab03:: with SMTP id u3mr24224904ybi.347.1616906570801;
 Sat, 27 Mar 2021 21:42:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210325120020.236504-1-memxor@gmail.com> <20210325120020.236504-4-memxor@gmail.com>
In-Reply-To: <20210325120020.236504-4-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 27 Mar 2021 21:42:40 -0700
Message-ID: <CAEf4Bzbz9OQ_vfqyenurPV7XRVpK=zcvktwH2Dvj-9kUGL1e7w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/5] libbpf: add low level TC-BPF API
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 5:02 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> This adds functions that wrap the netlink API used for adding,
> manipulating, and removing filters and actions. These functions operate
> directly on the loaded prog's fd, and return a handle to the filter and
> action using an out parameter (id for tc_cls, and index for tc_act).
>
> The basic featureset is covered to allow for attaching, manipulation of
> properties, and removal of filters and actions. Some additional features
> like TCA_BPF_POLICE and TCA_RATE for tc_cls have been omitted. These can
> added on top later by extending the bpf_tc_cls_opts struct.
>
> Support for binding actions directly to a classifier by passing them in
> during filter creation has also been omitted for now. These actions
> have an auto clean up property because their lifetime is bound to the
> filter they are attached to. This can be added later, but was omitted
> for now as direct action mode is a better alternative to it.
>
> An API summary:
>
> The BPF TC-CLS API
>
> bpf_tc_act_{attach, change, replace}_{dev, block} may be used to attach,
> change, and replace SCHED_CLS bpf classifiers. Separate set of functions
> are provided for network interfaces and shared filter blocks.
>
> bpf_tc_cls_detach_{dev, block} may be used to detach existing SCHED_CLS
> filter. The bpf_tc_cls_attach_id object filled in during attach,
> change, or replace must be passed in to the detach functions for them to
> remove the filter and its attached classififer correctly.
>
> bpf_tc_cls_get_info is a helper that can be used to obtain attributes
> for the filter and classififer. The opts structure may be used to
> choose the granularity of search, such that info for a specific filter
> corresponding to the same loaded bpf program can be obtained. By
> default, the first match is returned to the user.
>
> Examples:
>
>         struct bpf_tc_cls_attach_id id = {};
>         struct bpf_object *obj;
>         struct bpf_program *p;
>         int fd, r;
>
>         obj = bpf_object_open("foo.o");
>         if (IS_ERR_OR_NULL(obj))
>                 return PTR_ERR(obj);
>
>         p = bpf_object__find_program_by_title(obj, "classifier");
>         if (IS_ERR_OR_NULL(p))
>                 return PTR_ERR(p);
>
>         if (bpf_object__load(obj) < 0)
>                 return -1;
>
>         fd = bpf_program__fd(p);
>
>         r = bpf_tc_cls_attach_dev(fd, if_nametoindex("lo"),
>                                   BPF_TC_CLSACT_INGRESS, ETH_P_IP,
>                                   NULL, &id);
>         if (r < 0)
>                 return r;
>
> ... which is roughly equivalent to (after clsact qdisc setup):
>   # tc filter add dev lo ingress bpf obj /home/kkd/foo.o sec classifier
>
> If a user wishes to modify existing options on an attached filter, the
> bpf_tc_cls_change_{dev, block} API may be used. Parameters like
> chain_index, priority, and handle are ignored in the bpf_tc_cls_opts
> struct as they cannot be modified after attaching a filter.
>
> Example:
>
>         /* Optional parameters necessary to select the right filter */
>         DECLARE_LIBBPF_OPTS(bpf_tc_cls_opts, opts,
>                             .handle = id.handle,
>                             .priority = id.priority,
>                             .chain_index = id.chain_index)
>         /* Turn on direct action mode */
>         opts.direct_action = true;
>         r = bpf_tc_cls_change_dev(fd, id.ifindex, id.parent_id,
>                                   id.protocol, &opts, &id);
>         if (r < 0)
>                 return r;
>
>         /* Verify that the direct action mode has been set */
>         struct bpf_tc_cls_info info = {};
>         r = bpf_tc_cls_get_info_dev(fd, id.ifindex, id.parent_id,
>                                     id.protocol, &opts, &info);
>         if (r < 0)
>                 return r;
>
>         assert(info.bpf_flags & TCA_BPF_FLAG_ACT_DIRECT);
>
> This would be roughly equivalent to doing:
>   # tc filter change dev lo egress prio <p> handle <h> bpf obj /home/kkd/foo.o section classifier da
>
> ... except a new bpf program will be loaded and replace existing one.
>
> If a user wishes to either replace an existing filter, or create a new
> one with the same properties, they can use bpf_tc_cls_replace_dev. The
> benefit of bpf_tc_cls_change is that it fails if no matching filter
> exists.
>
> The BPF TC-ACT API

Is there some succinct but complete enough documentation/tutorial/etc
that I can reasonably read to understand kernel APIs provided by TC
(w.r.t. BPF, of course). I'm trying to wrap my head around this and
whether API makes sense or not. Please share links, if you have some.

>
> bpf_tc_act_{attach, replace} may be used to attach and replace already
> attached SCHED_ACT actions. Passing an index of 0 has special meaning,
> in that an index will be automatically chosen by the kernel. The index
> chosen by the kernel is the return value of these functions in case of
> success.
>
> bpf_tc_act_detach may be used to detach a SCHED_ACT action prog
> identified by the index parameter. The index 0 again has a special
> meaning, in that passing it will flush all existing SCHED_ACT actions
> loaded using the ACT API.
>
> bpf_tc_act_get_info is a helper to get the required attributes of a
> loaded program to be able to manipulate it futher, by passing them
> into the aforementioned functions.
>

[...]
