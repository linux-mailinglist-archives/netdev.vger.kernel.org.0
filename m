Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66B03198AAC
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 05:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729795AbgCaDyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 23:54:49 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:33823 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727358AbgCaDyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 23:54:49 -0400
Received: by mail-qt1-f195.google.com with SMTP id 10so17242503qtp.1;
        Mon, 30 Mar 2020 20:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vbv4wVL9aDWjgc0l/oEVuiG2/UoearZM1KlxGlj6iTA=;
        b=Rac8IpO53SrtuYhqn+25V683NUH9Wa/ki/pLGMGIdwo6drOTHxK3XO7YF+sMoZ7sCg
         IwnRxoH70Ywzw0Crg4jDug+G8e9YECcVYLlmkbZ0gRSdrAfIr0jcVYdF1Xr42TvLcecG
         lKRw+sVeFwTSo5Adf2R9jF299VIihFtvuXy0Br6firJBdh3zuN7kdxh5VKCYM6opCnG/
         ezXKBuPdKOXx+eFEu6CON7mns+rvimzbsvvsu207VEr9QwaEML4glZ4y109zfSulWbIt
         hxC+jYMOEO7s2ZzKPhon4IOrNCFORxtmgOafOpNx5OmNe57AhLYkhZcTk8m+zsPV2zKh
         BvlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vbv4wVL9aDWjgc0l/oEVuiG2/UoearZM1KlxGlj6iTA=;
        b=QPyrLnJrY2YbKOTV+jdaQ5o0O6Ls7onseTOsdrxG3I9kJradK96pp3nQWHia/RN4mz
         nlI/vI/bDIqACnKSmhxhfhHjwa0Rnj9mX4LHIqmwndvVBXYR9CI+luEitnN/bJ0o7exv
         zf89+moJRDM2EMswrlVwbMcJ6/ib1zqyeAvpgONB4t8zdSxEc0CJUdcNhUIpYvVg42ok
         BtBLs1WdOAw2JYdND4Z1qgwJRNNZ31pUlPifEw4WIXoDXDC1vU7CXdzukdyOJNxaiP0W
         3H2abX0lsiY4kSZYDDckYRUiWG+HIwpPV+9SwGTCnxYt2Gk+9YAdSsbj1op7dVAHt+5P
         swow==
X-Gm-Message-State: ANhLgQ3+8oTE/t4kjyk87j3f627Bp7yZxz1jKIAApFCyaqDPB8CiA+Ab
        HRldOq1nYU6Vrpp/f5ay9KGwJ2a174b8LKYK+as=
X-Google-Smtp-Source: ADFU+vvfbKGAp2bjhbXi7yk7NBF85fgrF5Ad/c2/4mn0rAKoUsUkAlu1K1H7N3LlURUNm4Ztqm+X/eRRJn7JJgB+9jE=
X-Received: by 2002:ac8:7cb0:: with SMTP id z16mr3105237qtv.59.1585626886610;
 Mon, 30 Mar 2020 20:54:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200330030001.2312810-1-andriin@fb.com> <c9f52288-5ea8-a117-8a67-84ba48374d3a@gmail.com>
 <CAEf4BzZpCOCi1QfL0peBRjAOkXRwGEi_DAW4z34Mf3Tv_sbRFw@mail.gmail.com>
 <662788f9-0a53-72d4-2675-daec893b5b81@gmail.com> <CAADnVQK8oMZehQVt34=5zgN12VBc2940AWJJK2Ft0cbOi1jDhQ@mail.gmail.com>
 <cdd576be-8075-13a7-98ee-9bc9355a2437@gmail.com> <20200331003222.gdc2qb5rmopphdxl@ast-mbp>
 <58cea4c7-e832-2632-7f69-5502b06310b2@gmail.com>
In-Reply-To: <58cea4c7-e832-2632-7f69-5502b06310b2@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 30 Mar 2020 20:54:35 -0700
Message-ID: <CAEf4BzZSCdtSRw9mj2W5Vv3C-G6iZdMJsZ8WGon11mN3oBiguQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 0/4] Add support for cgroup bpf_link
To:     David Ahern <dsahern@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrey Ignatov <rdna@fb.com>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 30, 2020 at 5:57 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 3/30/20 6:32 PM, Alexei Starovoitov wrote:
> >>
> >> This is not a large feature, and there is no reason for CREATE/UPDATE -
> >> a mere 4 patch set - to go in without something as essential as the
> >> QUERY for observability.
> >
> > As I said 'bpftool cgroup' covers it. Observability is not reduced in any way.
>
> You want a feature where a process can prevent another from installing a
> program on a cgroup. How do I learn which process is holding the
> bpf_link reference and preventing me from installing a program? Unless I
> have missed some recent change that is not currently covered by bpftool
> cgroup, and there is no way reading kernel code will tell me.
>
> ###
> To quote Lorenz from an earlier response:
>
> "However, this behaviour concerns me. It's like Windows not
> letting you delete a file while an application has it opened, which just
> leads to randomly killing programs until you find the right one. It's
> frustrating and counter productive.
>
> You're taking power away from the operator. In your deployment scenario
> this might make sense, but I think it's a really bad model in general.
> If I am privileged I need to be able to exercise that privilege."
> ###
>
> That is my point. You are restricting what root can do and people will
> not want to resort to killing random processes trying to find the one
> holding a reference. This is an essential missing piece and should go in
> at the same time as this set.

No need to kill random processes, you can kill only those that hold
bpf_link FD. You can find them using drgn tool with script like [0].
It will give you quite a lot of information already, but it should
also find pinned bpf_links, I haven't added it yet.

Found total 11 bpf_links.
-------------------------------------------------
type: tracing
prog: 'test1' id:223 type:BPF_PROG_TYPE_TRACING
pids: 449027
-------------------------------------------------
type: tracing
prog: 'test2' id:224 type:BPF_PROG_TYPE_TRACING
pids: 449027
-------------------------------------------------
type: tracing
prog: 'test3' id:225 type:BPF_PROG_TYPE_TRACING
pids: 449027
-------------------------------------------------
type: tracing
prog: 'test4' id:226 type:BPF_PROG_TYPE_TRACING
pids: 449027
-------------------------------------------------
type: tracing
prog: 'test5' id:227 type:BPF_PROG_TYPE_TRACING
pids: 449027
-------------------------------------------------
type: tracing
prog: 'test6' id:228 type:BPF_PROG_TYPE_TRACING
pids: 449027
-------------------------------------------------
type: raw_tp
prog: '' id:237 type:BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE
tp: bpf_test_finish
pids: 449462
-------------------------------------------------
type: cgroup
prog: 'egress' id:242 type:BPF_PROG_TYPE_CGROUP_SKB
attach: BPF_CGROUP_INET_EGRESS
cgroup: /cgroup-test-work-dir/cg1
pids: 449881
-------------------------------------------------
type: cgroup
prog: 'egress' id:242 type:BPF_PROG_TYPE_CGROUP_SKB
attach: BPF_CGROUP_INET_EGRESS
cgroup: /cgroup-test-work-dir/cg1/cg2
pids: 449881
-------------------------------------------------
type: cgroup
prog: 'egress' id:242 type:BPF_PROG_TYPE_CGROUP_SKB
attach: BPF_CGROUP_INET_EGRESS
cgroup: /cgroup-test-work-dir/cg1/cg2/cg3
pids: 449881
-------------------------------------------------
type: cgroup
prog: 'egress' id:242 type:BPF_PROG_TYPE_CGROUP_SKB
attach: BPF_CGROUP_INET_EGRESS
cgroup: /cgroup-test-work-dir/cg1/cg2/cg3/cg4
pids: 449881
-------------------------------------------------


   [0] https://gist.github.com/anakryiko/562dff8e39c619a5ee247bb55aa057c7
