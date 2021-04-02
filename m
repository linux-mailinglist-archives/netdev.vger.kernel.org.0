Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDB04352F51
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 20:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236401AbhDBSc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 14:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbhDBSc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 14:32:28 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2226DC0613E6;
        Fri,  2 Apr 2021 11:32:27 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id u9so6380955ljd.11;
        Fri, 02 Apr 2021 11:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ad8VMz3WsxyloFA1un2SE8S0Vb3SXK/5tCOkJ+wMDVk=;
        b=hgzwlPBSIM190eN3Rsl3Os6i9tIlxa+0q4o702zLLHZwfNP7o7XVwtgxSTT616Cmyn
         CZX6FkDGqHeBC+qVoLOfyGbpvHN2Ez4sF1QweMn6xoHmNnZbxZtTUp4hwbaElWZisGpW
         NWuZytZ6o8+WOa3Wi/1US3LFeEbfetkWSbSx3OFJ/Edy8jFzv+89Dxdn9Je0wYhzmFaw
         ZwfQIU9t8ncjaUQiRWTXzyDWvvGb+UVje4mcyf1RiB70ShrYpR/FOUmrVDJOnb78Fwlj
         fvZDjFLv+y22kZ9Cs+PAG8zZF8+b9W/cVP4E4rEm8OqVYnLoElbEFy99R4JXtvLjSDsO
         fGOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ad8VMz3WsxyloFA1un2SE8S0Vb3SXK/5tCOkJ+wMDVk=;
        b=O8bp0akaPP48GDW+u11ADFai3N5mztn3pqZpNbovy/Rin8DDx70MB3p+AO4F2Dnfkk
         RINwBacp+RDehAE2AYHJ+FLzf/I1jWKLkUVd7djm/bwJEi3pkg3ccSKfHP4DT/MqDjjB
         Jvbkys85Kas4DsfUBUPHqhQgDyzg5x05cwhgY+RcUYQsO9sovbLs7yOhW0mydzcJPM96
         al0IYFrf4Odg2GOgDPfKq5XlA9bk9J5SV/G9m9gtwAK6K+RpOKQ28w7s8ZH0/+3I6eke
         B4+fou8jLW72BiaRMjdl4bP9a//QKSDKo89Nbb6EtHDFGwsgKMrPYCdzWoVscPMnMB3d
         SWjw==
X-Gm-Message-State: AOAM5312Yxmzc0PFVLcH/sFTrS6bxYTJ4cETHznPxAIvr7SvPHPM2//Q
        GnZkjI2s1RzdN6RTe7D8XkSuyVXRGY6dv0Hh/os=
X-Google-Smtp-Source: ABdhPJzDt/m+lC1BzgsA4s5CdZw4tYVpOB9H34jfZ0ELnOZ6Shxr8RG5L4t7XV1QRw/yNbCVk6U8VdZUK8WL5lJt3LM=
X-Received: by 2002:a2e:8ec1:: with SMTP id e1mr8871661ljl.236.1617388345623;
 Fri, 02 Apr 2021 11:32:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210325120020.236504-1-memxor@gmail.com> <20210325120020.236504-4-memxor@gmail.com>
 <CAEf4Bzbz9OQ_vfqyenurPV7XRVpK=zcvktwH2Dvj-9kUGL1e7w@mail.gmail.com>
 <20210328080648.oorx2no2j6zslejk@apollo> <CAEf4BzaMsixmrrgGv6Qr68Ytq8k9W+WP6m4Vdb1wDhDFBKStgw@mail.gmail.com>
 <48b99ccc-8ef6-4ba9-00f9-d7e71ae4fb5d@iogearbox.net> <20210331094400.ldznoctli6fljz64@apollo>
 <5d59b5ee-a21e-1860-e2e5-d03f89306fd8@iogearbox.net> <20210402152743.dbadpgcmrgjt4eca@apollo>
In-Reply-To: <20210402152743.dbadpgcmrgjt4eca@apollo>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 2 Apr 2021 11:32:14 -0700
Message-ID: <CAADnVQ+wqrEnOGd8E1yp+1WTAx8ZcAx3HUjJs6ipPd0eKmOrgA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/5] libbpf: add low level TC-BPF API
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
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

On Fri, Apr 2, 2021 at 8:27 AM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
>
> This would be fine, because it's not a fast path or anything, but right now we
> return the id using the netlink response, otherwise for query we have to open
> the socket, prepare the msg, send and recv again. So it's a minor optimization.
>
> However, there's one other problem. In an earlier version of this series, I
> didn't keep the id/index out parameters (to act as handle to the newly attached
> filter/action). This lead to problems on query. Suppose a user doesn't properly
> fill the opts during query (e.g. in case of filters). This means the netlink
> dump includes all filters matching filled in attributes. If the prog_id for all
> of these is same (e.g. all have same bpf classifier prog attached to them), it
> becomes impossible to determine which one is the filter user asked for. It is
> not possible to enforce filling in all kinds of attributes since some can be
> left out and assigned by default in the kernel (priority, chain_index etc.). So
> returning the newly created filter's id turned out to be the best option. This
> is also used to stash filter related information in bpf_link to properly release
> it later.
>
> The same problem happens with actions, where we look up using the prog_id, we
> multiple actions with different index can match on same prog_id. It is not
> possible to determine which index corresponds to last loaded action.
>
> So unless there's a better idea on how to deal with this, a query API won't work
> for the case where same bpf prog is attached more than once. Returning the
> id/index during attach seemed better than all other options we considered.

All of these things are messy because of tc legacy. bpf tried to follow tc style
with cls and act distinction and it didn't quite work. cls with
direct-action is the only
thing that became mainstream while tc style attach wasn't really addressed.
There were several incidents where tc had tens of thousands of progs attached
because of this attach/query/index weirdness described above.
I think the only way to address this properly is to introduce bpf_link style of
attaching to tc. Such bpf_link would support ingress/egress only.
direction-action will be implied. There won't be any index and query
will be obvious.
So I would like to propose to take this patch set a step further from
what Daniel said:
int bpf_tc_attach(prog_fd, ifindex, {INGRESS,EGRESS}):
and make this proposed api to return FD.
To detach from tc ingress/egress just close(fd).
The user processes will not conflict with each other and will not accidently
detach bpf program that was attached by another user process.
Such api will address the existing tc query/attach/detach race race conditions.
And libbpf side of support for this api will be trivial. Single bpf
link_create command
with ifindex and ingress|egress arguments.
wdyt?
