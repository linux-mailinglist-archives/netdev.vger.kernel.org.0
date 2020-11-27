Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC7922C5F0E
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 04:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392277AbgK0Dkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 22:40:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727037AbgK0Dkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 22:40:37 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 856ACC0613D1;
        Thu, 26 Nov 2020 19:40:37 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id s8so3298830yba.13;
        Thu, 26 Nov 2020 19:40:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kD1Le3QJWXJqjnlpHF5DqUqQjm8CPmlbUAqsXxlecIM=;
        b=fbDYnxgsTRbYk0E+2obbFZnlctUNUiShnxWc5rz/2XL8kO16qlKOv5Tj8kZ1LAfa7w
         F4DRvKyE6Miclh9ELGJCqzahrndQPas5iQV3azcbP/NBWiv8ft9i0fGCNMWJHh3I55C1
         6brJE/KKLFPk0TDLIFSg+sZco7y4X8/tTsTyYdwkPzXXhIz6iUNrRAuSVrbP8NpgtV60
         DN3h0N35BIwZ4E6Z+6OMmnhp6oHyEHdKgI1khlP+4vKTDJQwGPIEXS5nVq93FGXEMyf8
         lu5GtY7bdkzUMX6OVJswcwqZi5jTr50CIdYnPEkGJfennbct11xjuaSlN3a9SvaRylQc
         EVOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kD1Le3QJWXJqjnlpHF5DqUqQjm8CPmlbUAqsXxlecIM=;
        b=Eab1q7Vi3WORTcgvIF/D3Q9il4F5lxpQupNZ7Ub2hPFUlnhBnoRvQYIw/v3Oq0Qrlc
         kUWdP9t6U4xZZGdyI7I6aC0jAgXOR/9A1ltaI99Enh6KwihmKSWPdZuDn9Su+BLOVt/Z
         +C2evPixJZbBtNPzzhBKDw1RQ4Gl15cRv9XWlv2PV38Iq/OAnUAenAG2ggGoDv7iObBs
         Pt8tPQtISQBMB8U1Pm/LZwzw/2FLEWSqHJzOj8PraS0mKJ6dOrVQjcKREnX/L6BC5+Wv
         nNQA29R7i0cIhNiZR+GUN4pFRNm1AgQLHTN6QbiQfxWa4Ld+o7/r/PcJhpvrwQtN54rx
         7q2w==
X-Gm-Message-State: AOAM530flRTacG8XB95GNHuOZlNG0DQdYitfMpaXtjM4UYOoBkgBm44V
        V2a3HN4EavxFdmTvI5UrPkGFekHU83VWgbJrRKA=
X-Google-Smtp-Source: ABdhPJwjbVaqxohDbkXAKrhcutlfZXzG38k6+pPHJJkky3EINVWRkk+4LP4Qa5xfgvnKSqx7nSN+397qgQIeluyMRB0=
X-Received: by 2002:a25:2845:: with SMTP id o66mr9369163ybo.260.1606448436834;
 Thu, 26 Nov 2020 19:40:36 -0800 (PST)
MIME-Version: 1.0
References: <20201124090310.24374-1-danieltimlee@gmail.com> <20201124090310.24374-2-danieltimlee@gmail.com>
In-Reply-To: <20201124090310.24374-2-danieltimlee@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 26 Nov 2020 19:40:25 -0800
Message-ID: <CAEf4Bzby0AwzKfKwd5ZKXaEg1a1hpEfoPsqVLwPQVr89nAAxEA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 1/7] samples: bpf: refactor hbm program with libbpf
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, brakmo <brakmo@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        David Ahern <dsa@cumulusnetworks.com>,
        Yonghong Song <yhs@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>, Thomas Graf <tgraf@suug.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 24, 2020 at 1:03 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> This commit refactors the existing cgroup programs with libbpf
> bpf loader. Since bpf_program__attach doesn't support cgroup program
> attachment, this explicitly attaches cgroup bpf program with
> bpf_program__attach_cgroup(bpf_prog, cg1).
>
> Also, to change attach_type of bpf program, this uses libbpf's
> bpf_program__set_expected_attach_type helper to switch EGRESS to
> INGRESS. To keep bpf program attached to the cgroup hierarchy even
> after the exit, this commit uses the BPF_LINK_PINNING to pin the link
> attachment even after it is closed.
>
> Besides, this program was broken due to the typo of BPF MAP definition.
> But this commit solves the problem by fixing this from 'queue_stats' map
> struct hvm_queue_stats -> hbm_queue_stats.
>
> Fixes: 36b5d471135c ("selftests/bpf: samples/bpf: Split off legacy stuff from bpf_helpers.h")
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---
> Changes in v2:
>  - restore read_trace_pipe2
>  - remove unnecessary return code and cgroup fd compare
>  - add static at global variable and remove unused variable
>  - change cgroup path with unified controller (/unified/)
>  - add link pinning to prevent cleaning up on process exit
>
> Changes in v3:
>  - cleanup bpf_link, bpf_object and cgroup fd both on success and error
>  - remove link NULL cleanup since __destroy() can handle
>  - fix cgroup test on cgroup fd cleanup
>
>  samples/bpf/.gitignore     |   3 +
>  samples/bpf/Makefile       |   2 +-
>  samples/bpf/do_hbm_test.sh |  32 +++++------
>  samples/bpf/hbm.c          | 111 ++++++++++++++++++++-----------------
>  samples/bpf/hbm_kern.h     |   2 +-
>  5 files changed, 78 insertions(+), 72 deletions(-)
>

Thanks for the nice clean up! I've applied the series to bpf-next. If
Martin finds any other problems, those can be fixed in a follow up
patch(es). But see also below about find_program_by_title().

> -       if (ret) {
> -               printf("ERROR: bpf_prog_load_xattr failed for: %s\n", prog);
> -               printf("  Output from verifier:\n%s\n------\n", bpf_log_buf);
> -               ret = -1;
> -       } else {
> -               ret = map_fd;
> +       bpf_prog = bpf_object__find_program_by_title(obj, "cgroup_skb/egress");

It would be good to avoid using find_program_by_title(), as it's going
to get deprecated and eventually removed. Looking up by section name
("title") is ambiguous now that libbpf supports many BPF programs per
same section. There is find_program_by_name() which looks program by
its C function name. I suggest using it.


> +       if (!bpf_prog) {
> +               printf("ERROR: finding a prog in obj file failed\n");
> +               goto err;
> +       }
> +
