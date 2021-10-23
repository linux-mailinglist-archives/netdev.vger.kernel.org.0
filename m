Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3703438155
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 03:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbhJWBws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 21:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhJWBwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 21:52:47 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 585B4C061764;
        Fri, 22 Oct 2021 18:50:29 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id 67so10860799yba.6;
        Fri, 22 Oct 2021 18:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tGIfsA5idU/xyMElxJu9hI+Bm2MAp6eyGaojOMDc3+Y=;
        b=ZSHYBLJx9LGA8uYb7OY/zUFYM05Edz3hkHPEAkJmh/n/SxtugMA9ktcL222w2oNkd0
         PeM9qT7vB8jIcmAGXt2OdBTnMuLViO4rGZoQovLjK279s7OVvcfq14NcHF9ZL9VmP1b7
         y4bznk0fzvaDjNhGYYbh2D9q7ZKnH7T/uwMg4Ke0pbtqd2ag0vRv1KNUHvrl+6/GtduA
         ybFjpDZ4u8jZM+WGfDXPJTfVftJ/WOqGMfqsDQy6OMaIZBQDLVtKwL3zjhGxkzJBjuCX
         UBQREd9AT9KZ44UamwxUgSQXGXg2qMrvmQ4OtB9XCFEIOhNB4aTe1rkjV6O6PnlMBd1/
         gdzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tGIfsA5idU/xyMElxJu9hI+Bm2MAp6eyGaojOMDc3+Y=;
        b=14PZ6VQvoVsyUfEQReVRFWggojAkkssBH61TPBGlecAH63fxHBmmSVim9HHlIE3HuQ
         ZkOtaCokqtckQx5NGJJ5qOv/gdewwUS6YCOqVHf5z+y+iT4h6QlQcUWzGTsosqEmsm+l
         zWLls335WG6d9aJkfqUIgGEGQNN5PUP5bup9O0HLcO2UgLFUXv1bfOFTufT4CoBC3Qjx
         FSdO5t90mg5+KraVqKCdPJ5Gaty5210cRnh1pfXYhE9rMKkjJyavdL6ApwLXARliXojV
         VyYwQHRKg4jrI58nqqPdSK9+GANuT1mkzDjxZjopsAc9s2gv3XGdaEKeHeMTIKMwbfl6
         ZKFg==
X-Gm-Message-State: AOAM532Uyxi/gqeMVxxKhf/21tkkZIpyDamj/m8BdXDqUyfRdqteIop7
        Q4d5ujGFQHVWIUc27tVvpB4aJBshpEpXCG0YajM=
X-Google-Smtp-Source: ABdhPJyJpZ9Fa7pA94EElGMPLeDObDDBNokKtFz+OWBDS/p2riCeGZ2J4te58inOOXG/ViscF59I7QiB+ZZXKOJo74c=
X-Received: by 2002:a25:5606:: with SMTP id k6mr3340123ybb.51.1634953828398;
 Fri, 22 Oct 2021 18:50:28 -0700 (PDT)
MIME-Version: 1.0
References: <20211022171647.27885-1-quentin@isovalent.com> <20211022171647.27885-6-quentin@isovalent.com>
In-Reply-To: <20211022171647.27885-6-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 22 Oct 2021 18:50:17 -0700
Message-ID: <CAEf4BzacXLz=Q+wk+5=+LNvgTO+SMM47hh+Pt+sF1qsXW5pA5Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/5] bpftool: Switch to libbpf's hashmap for
 PIDs/names references
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 22, 2021 at 10:16 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> In order to show PIDs and names for processes holding references to BPF
> programs, maps, links, or BTF objects, bpftool creates hash maps to
> store all relevant information. This commit is part of a set that
> transitions from the kernel's hash map implementation to the one coming
> with libbpf.
>
> The motivation is to make bpftool less dependent of kernel headers, to
> ease the path to a potential out-of-tree mirror, like libbpf has.
>
> This is the third and final step of the transition, in which we convert
> the hash maps used for storing the information about the processes
> holding references to BPF objects (programs, maps, links, BTF), and at
> last we drop the inclusion of tools/include/linux/hashtable.h.
>
> Note: Checkpatch complains about the use of __weak declarations, and the
> missing empty lines after the bunch of empty function declarations when
> compiling without the BPF skeletons (none of these were introduced in
> this patch). We want to keep things as they are, and the reports should
> be safe to ignore.
>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
>  tools/bpf/bpftool/btf.c  |  7 ++--
>  tools/bpf/bpftool/link.c |  6 +--
>  tools/bpf/bpftool/main.c |  5 ++-
>  tools/bpf/bpftool/main.h | 17 +++-----
>  tools/bpf/bpftool/map.c  |  6 +--
>  tools/bpf/bpftool/pids.c | 84 ++++++++++++++++++++++------------------
>  tools/bpf/bpftool/prog.c |  6 +--
>  7 files changed, 67 insertions(+), 64 deletions(-)
>

[...]

>  #include "pid_iter.skel.h"
>
> -static void add_ref(struct obj_refs_table *table, struct pid_iter_entry *e)
> +static void add_ref(struct hashmap *map, struct pid_iter_entry *e)
>  {
> +       struct hashmap_entry *entry;
>         struct obj_refs *refs;
>         struct obj_ref *ref;
>         void *tmp;
>         int i;
>
> -       hash_for_each_possible(table->table, refs, node, e->id) {
> -               if (refs->id != e->id)
> -                       continue;
> +       hashmap__for_each_key_entry(map, entry, u32_as_hash_field(e->id)) {
> +               refs = entry->value;
>
>                 for (i = 0; i < refs->ref_cnt; i++) {
>                         if (refs->refs[i].pid == e->pid)
> @@ -64,7 +66,6 @@ static void add_ref(struct obj_refs_table *table, struct pid_iter_entry *e)
>                 return;
>         }
>
> -       refs->id = e->id;
>         refs->refs = malloc(sizeof(*refs->refs));
>         if (!refs->refs) {
>                 free(refs);
> @@ -76,7 +77,7 @@ static void add_ref(struct obj_refs_table *table, struct pid_iter_entry *e)
>         ref->pid = e->pid;
>         memcpy(ref->comm, e->comm, sizeof(ref->comm));
>         refs->ref_cnt = 1;
> -       hash_add(table->table, &refs->node, e->id);
> +       hashmap__append(map, u32_as_hash_field(e->id), refs);

here as well, can fail

>  }
>
>  static int __printf(2, 0)
> @@ -87,7 +88,7 @@ libbpf_print_none(__maybe_unused enum libbpf_print_level level,
>         return 0;
>  }
>

[...]
