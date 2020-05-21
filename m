Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 807B11DD640
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 20:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729471AbgEUSsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 14:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728551AbgEUSsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 14:48:05 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F5CC061A0E;
        Thu, 21 May 2020 11:48:05 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id f189so8287761qkd.5;
        Thu, 21 May 2020 11:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Tnxigj2aTkX+JvQj4lmR9Hn6BTo5R/SbOnlweNnR57o=;
        b=ge55v3Qk7Ixtg+ZVlX3gLQQ38YO+9q1MH3aCc3ohqtewTPqhL/99X5KrA9uZohZuDM
         a7cJpi+XQEXAqj68Ms/FZrlbBsIJJYZubErhO+3Nq/Ul2r/AXyHXozFAT5srNDiJzSM6
         GHFU2m/NW2mZZnjQb05frmh0gaS1nwzvlWgYgyfzIwrXomJda52e+DANXhCxLiQ868iO
         YxWpKOrzrLr+BZeWp6FrrI/0/J53/iBKj8bnoU0yzaTW/UPHZMyvdH1cjpgW6/ZSv6Nh
         DovtTagv0FwDTExnF6Oc64yXYfk/riuTeK2JEJhInVGV5t5xlSL3omvX/rsNDlWxF4Fd
         wYwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Tnxigj2aTkX+JvQj4lmR9Hn6BTo5R/SbOnlweNnR57o=;
        b=qXHuc/g7w0+hb1IRBrwAAGhtjKpZST5ETCtKrUhN5ivxtg2jl7cQ71PcvfPeGK7Wu0
         Uv+LS/ofUohPeyE6P6qDNBfVDMtpQ0cdFM0WkeVtqyrved/jJ8NvGySYFzgCcz3r+stm
         XJa7uj/4lkVR91LT7oPiKLLylWOtsb17Jq8QfyqyFkGEfwS9hwe2xQ/dN2rptcHWafRN
         5sJ96/o17b9re9n5znyErRxXT+gw3Klu92QOgxyfAHbns0YTibqZ9eknlUU1MZCqzk9j
         6OZWuY28eSUvttyTpFAjLOEIzxCXOamFjRLFfn9pzNuLcsPg8+d8IZv3xwDXAsFpo14K
         zbMg==
X-Gm-Message-State: AOAM532Rzhd3UCJWPAlKiq1zfXmi51z+VqgHo63cuFYnFUGHeA/KsQRo
        yoLll4OQSiMRHdOev1jKda1W3bfXVfhESE/Pmm4=
X-Google-Smtp-Source: ABdhPJwvIhDVzTjshBj4EpqpRPabM/TaZRjyIT3XF6cqTDGqckaofu0E8RXvDxI+GJvo0ihTJBlHOjrrNbLhaCJpupQ=
X-Received: by 2002:a05:620a:2049:: with SMTP id d9mr12250675qka.449.1590086884584;
 Thu, 21 May 2020 11:48:04 -0700 (PDT)
MIME-Version: 1.0
References: <159007153289.10695.12380087259405383510.stgit@john-Precision-5820-Tower>
 <159007177838.10695.12211214514015683724.stgit@john-Precision-5820-Tower>
In-Reply-To: <159007177838.10695.12211214514015683724.stgit@john-Precision-5820-Tower>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 21 May 2020 11:47:53 -0700
Message-ID: <CAEf4BzYJRaY+tsa2TH5WoLAEo=ckd=D2XK5u4YFezkj4jfrZLQ@mail.gmail.com>
Subject: Re: [bpf-next PATCH v3 5/5] bpf: selftests, test probe_* helpers from SCHED_CLS
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>, bpf <bpf@vger.kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 7:36 AM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Lets test using probe* in SCHED_CLS network programs as well just
> to be sure these keep working. Its cheap to add the extra test
> and provides a second context to test outside of sk_msg after
> we generalized probe* helpers to all networking types.
>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  .../testing/selftests/bpf/prog_tests/skb_helpers.c |   30 ++++++++++++++++++
>  .../testing/selftests/bpf/progs/test_skb_helpers.c |   33 ++++++++++++++++++++
>  2 files changed, 63 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/skb_helpers.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_skb_helpers.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/skb_helpers.c b/tools/testing/selftests/bpf/prog_tests/skb_helpers.c
> new file mode 100644
> index 0000000..5a865c4
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/skb_helpers.c
> @@ -0,0 +1,30 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <test_progs.h>
> +#include <network_helpers.h>
> +
> +void test_skb_helpers(void)
> +{
> +       struct __sk_buff skb = {
> +               .wire_len = 100,
> +               .gso_segs = 8,
> +               .gso_size = 10,
> +       };
> +       struct bpf_prog_test_run_attr tattr = {
> +               .data_in = &pkt_v4,
> +               .data_size_in = sizeof(pkt_v4),
> +               .ctx_in = &skb,
> +               .ctx_size_in = sizeof(skb),
> +               .ctx_out = &skb,
> +               .ctx_size_out = sizeof(skb),
> +       };
> +       struct bpf_object *obj;
> +       int err;
> +
> +       err = bpf_prog_load("./test_skb_helpers.o", BPF_PROG_TYPE_SCHED_CLS, &obj,
> +                           &tattr.prog_fd);

hm... who's destroying bpf_object?


> +       if (CHECK_ATTR(err, "load", "err %d errno %d\n", err, errno))
> +               return;
> +
> +       err = bpf_prog_test_run_xattr(&tattr);
> +       CHECK_ATTR(err != 0, "len", "err %d errno %d\n", err, errno);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_skb_helpers.c b/tools/testing/selftests/bpf/progs/test_skb_helpers.c
> new file mode 100644
> index 0000000..05a1260
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_skb_helpers.c
> @@ -0,0 +1,33 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#include "vmlinux.h"
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_endian.h>
> +
> +int _version SEC("version") = 1;

version is not needed

> +
> +#define TEST_COMM_LEN 10

doesn't matter for this test, but it's 16 everywhere, let's stay consistent

> +
> +struct bpf_map_def SEC("maps") cgroup_map = {
> +       .type                   = BPF_MAP_TYPE_CGROUP_ARRAY,
> +       .key_size               = sizeof(u32),
> +       .value_size             = sizeof(u32),
> +       .max_entries    = 1,
> +};
> +

Please use new BTF syntax for maps

> +char _license[] SEC("license") = "GPL";
> +
> +SEC("classifier/test_skb_helpers")
> +int test_skb_helpers(struct __sk_buff *skb)
> +{
> +       struct task_struct *task;
> +       char *comm[TEST_COMM_LEN];

this is array of pointer, not array of chars

> +       __u32 tpid;
> +       int ctask;
> +
> +       ctask = bpf_current_task_under_cgroup(&cgroup_map, 0);

compiler might complain that ctask is written, but not read. Let's
assign it to some global variable?

> +       task = (struct task_struct *)bpf_get_current_task();
> +
> +       bpf_probe_read_kernel(&tpid , sizeof(tpid), &task->tgid);
> +       bpf_probe_read_kernel_str(&comm, sizeof(comm), &task->comm);
> +       return 0;
> +}
>
