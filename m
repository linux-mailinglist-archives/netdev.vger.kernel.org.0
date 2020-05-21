Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0EB1DD651
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 20:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729702AbgEUSwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 14:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729151AbgEUSwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 14:52:04 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E784C061A0E;
        Thu, 21 May 2020 11:52:03 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id g185so8287666qke.7;
        Thu, 21 May 2020 11:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eAw18fkPq4vzLe3nMgBPQCym23arvcEaOLjj5OFMCwk=;
        b=FGxWTJ+exdwJQxwQJ3Sa++1YlYnO7odiMKNLqALTiyfwCa7k1234NQFTsKHZ1vnhYv
         YLGq5uccgWjsbtkAJ1ZGjePy0hUaDFBKUNgQLhmlvlKrxxwoTNCkh1F1tomGJRpYUdN0
         zyacm9RgTcXZp3BPhUIbFRUHo4Fml+j5SYrpWrAxiRWDBWdEYQc5u6D58DbXR45VD3ax
         pJoiP58O0rZ88bry1dWcL94lUyznWjeyJS5S59yQ3TnKekZYkeTE3TS5hPz1XorF8yeq
         47FlZEFnIugZeJgTeCv1+S+Wn2UmjIWoD2H5UfKubPQAlse0MsOkOMzN9zvjUBWxCxNr
         BJ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eAw18fkPq4vzLe3nMgBPQCym23arvcEaOLjj5OFMCwk=;
        b=ccbdyvwhLOMx0K+uVVe4OFDVGbzy8VPB6oV6Kmv7DIU65oU6JYe+ErQanjsH6f3Pcd
         P1GYyCx278xESk3twogAKS5b9GVPx9kRGCXPPVBXAWZhrRitTjEnWq9FGzcGhbKC6nHg
         sskKcbtHZl/h7Vfc+8lHUnnXJJHe33cbtcrKbmntE9CaDsiTz1bKLYrmDq9kVh71aUpZ
         7KFF4KUHfRcFQERdFFjvVEaqn29rS6Z/worUoHQMsEMykTmMEwpspqEzUUTItIlurZmX
         Zm3KumOI3ysPg9T57BpUjuqxZBt6pWj6F5qB7AWO0zAqYM1Aom+9huoIf8H6AV0Z0PRr
         S6Bg==
X-Gm-Message-State: AOAM532BKuSKi3iVV3cxNBbHaGvhDZeEACqONfXWvQKgusRWmoHZNCRR
        oDlIAuzKoH2z0ZuQNJi6F6O13T7gXlxN9NEv4no=
X-Google-Smtp-Source: ABdhPJzOZ1aVZC8d7oJOv4OGQ67Ree+z+qmp488uiYHJvjwD+CkkE9Ir2yuvJZkCL+fWgHk9nRBEgpSDKypdMOiYIMQ=
X-Received: by 2002:a05:620a:2049:: with SMTP id d9mr12267369qka.449.1590087122678;
 Thu, 21 May 2020 11:52:02 -0700 (PDT)
MIME-Version: 1.0
References: <159007153289.10695.12380087259405383510.stgit@john-Precision-5820-Tower>
 <159007175735.10695.9639519610473734809.stgit@john-Precision-5820-Tower>
In-Reply-To: <159007175735.10695.9639519610473734809.stgit@john-Precision-5820-Tower>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 21 May 2020 11:51:51 -0700
Message-ID: <CAEf4BzZpZ5_Mn66h9a+VE0UtrXUcYdNe-Fj0zEvfDbhUG7Z=sw@mail.gmail.com>
Subject: Re: [bpf-next PATCH v3 4/5] bpf: selftests, add sk_msg helpers load
 and attach test
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
> The test itself is not particularly useful but it encodes a common
> pattern we have.
>
> Namely do a sk storage lookup then depending on data here decide if
> we need to do more work or alternatively allow packet to PASS. Then
> if we need to do more work consult task_struct for more information
> about the running task. Finally based on this additional information
> drop or pass the data. In this case the suspicious check is not so
> realisitic but it encodes the general pattern and uses the helpers
> so we test the workflow.
>
> This is a load test to ensure verifier correctly handles this case.
>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  .../selftests/bpf/prog_tests/sockmap_basic.c       |   57 ++++++++++++++++++++
>  .../selftests/bpf/progs/test_skmsg_load_helpers.c  |   48 +++++++++++++++++
>  2 files changed, 105 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/progs/test_skmsg_load_helpers.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
> index aa43e0b..cacb4ad 100644
> --- a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
> +++ b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
> @@ -1,13 +1,46 @@
>  // SPDX-License-Identifier: GPL-2.0
>  // Copyright (c) 2020 Cloudflare
> +#include <error.h>
>
>  #include "test_progs.h"
> +#include "test_skmsg_load_helpers.skel.h"
>
>  #define TCP_REPAIR             19      /* TCP sock is under repair right now */
>
>  #define TCP_REPAIR_ON          1
>  #define TCP_REPAIR_OFF_NO_WP   -1      /* Turn off without window probes */
>
> +#define _FAIL(errnum, fmt...)                                                  \
> +       ({                                                                     \
> +               error_at_line(0, (errnum), __func__, __LINE__, fmt);           \
> +               CHECK_FAIL(true);                                              \
> +       })
> +#define FAIL(fmt...) _FAIL(0, fmt)
> +#define FAIL_ERRNO(fmt...) _FAIL(errno, fmt)
> +#define FAIL_LIBBPF(err, msg)                                                  \
> +       ({                                                                     \
> +               char __buf[MAX_STRERR_LEN];                                    \
> +               libbpf_strerror((err), __buf, sizeof(__buf));                  \
> +               FAIL("%s: %s", (msg), __buf);                                  \
> +       })
> +
> +#define xbpf_prog_attach(prog, target, type, flags)                            \
> +       ({                                                                     \
> +               int __ret =                                                    \
> +                       bpf_prog_attach((prog), (target), (type), (flags));    \
> +               if (__ret == -1)                                               \
> +                       FAIL_ERRNO("prog_attach(" #type ")");                  \
> +               __ret;                                                         \
> +       })
> +
> +#define xbpf_prog_detach2(prog, target, type)                                  \
> +       ({                                                                     \
> +               int __ret = bpf_prog_detach2((prog), (target), (type));        \
> +               if (__ret == -1)                                               \
> +                       FAIL_ERRNO("prog_detach2(" #type ")");                 \
> +               __ret;                                                         \
> +       })

I'm not convinced we need these macro, can you please just use CHECKs?
I'd rather not learn each specific test's custom macros.

> +
>  static int connected_socket_v4(void)
>  {
>         struct sockaddr_in addr = {
> @@ -70,10 +103,34 @@ static void test_sockmap_create_update_free(enum bpf_map_type map_type)
>         close(s);
>  }
>
> +static void test_skmsg_helpers(enum bpf_map_type map_type)
> +{
> +       struct test_skmsg_load_helpers *skel;
> +       int err, map, verdict;
> +
> +       skel = test_skmsg_load_helpers__open_and_load();
> +       if (!skel) {
> +               FAIL("skeleton open/load failed");
> +               return;
> +       }
> +
> +       verdict = bpf_program__fd(skel->progs.prog_msg_verdict);
> +       map = bpf_map__fd(skel->maps.sock_map);
> +
> +       err = xbpf_prog_attach(verdict, map, BPF_SK_MSG_VERDICT, 0);
> +       if (err)
> +               return;
> +       xbpf_prog_detach2(verdict, map, BPF_SK_MSG_VERDICT);

no cleanup in this test, at all

> +}
> +

[...]

> +
> +int _version SEC("version") = 1;

version not needed

> +char _license[] SEC("license") = "GPL";
>
