Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85D2EF08B5
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 22:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730087AbfKEVud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 16:50:33 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:34373 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726751AbfKEVuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 16:50:32 -0500
Received: by mail-qk1-f194.google.com with SMTP id 205so21356453qkk.1;
        Tue, 05 Nov 2019 13:50:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H4ZJkkXh66JgD7Y8RaA75Q3ueTUt9xl1ZxQcRHfv1z8=;
        b=Pid5aTEwjJeMy5eeifg85fPF1KGUW8ncs2WfOityerGiilw1C51PAGUszTnh7F9kMy
         CQyK17iR2m1qVNimKB9at/w8xEVKZ2yFmVLZ3wewS2CaEsDIWseoaJzl600lbruE0dLC
         GRMTU8kHHdyXd4GlNKEqC5vE1WkXiiaI1Cv2uNgE/Ak+PPIqYEpr4FkmGlHLTT6fZ3zB
         SHYW0LX7mxFYX3sHxmv3tn3SA3EDA3FNrzqax+B5Qzo7tLVPx4VA3E8fy/DqovR4eJ34
         Fj5rg9dsKs76BtcAz333QSH7pZscpj70MVlmZPv8FH+vi7aMkzyoIaRfoX5NhtNZtxB2
         URkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H4ZJkkXh66JgD7Y8RaA75Q3ueTUt9xl1ZxQcRHfv1z8=;
        b=B+gUZYSZJvM9eFyJxMTDUTQ8PqLdJJlGg4yot8nEfKSp1hRmxKTT1wCKxMZQqiOKpl
         oeW8V0tpOb8UEBHOyEJWmOUw75+7BnzDfBMnY1nr79VOgclKcMQcEv3H2w4sYNHAV7X2
         wrnzE8bC99UTNrJHDbBQwGffErInmtR+GfPQhqAuGZieRDpZJNy+9NT0/UuevdEsS2KK
         l7sPYlVvw3+XFLC4v3uXjJx/C/rb2OIafHdMMbi1CNu+EzXmc1wZ7YzRiCxReqRMzKqO
         PaIDdvMqwOUgDpeHon/qvehH4rDZIpkz5lmTQ8uXCO8sNWnDY1C/rLyIwixBzqJw4Zl0
         SdGw==
X-Gm-Message-State: APjAAAVfvBhgrfhE3CZH9SoAvBXOWw5HVBb1kzsrZzETEQpAMX5EDvtP
        GbcARLZE7zWA7aUoKqS2xN2LLptZnAlopBqpoh0=
X-Google-Smtp-Source: APXvYqzRwq7/iHq3U+iPF4ksumKyEoCIo92JpwqtlZPjGaZvGmv02xVRknwCJrdUVBR/OjG1PW2cHRsXSggnlRW3WTU=
X-Received: by 2002:a37:aa8b:: with SMTP id t133mr4275429qke.449.1572990630176;
 Tue, 05 Nov 2019 13:50:30 -0800 (PST)
MIME-Version: 1.0
References: <20191102220025.2475981-1-ast@kernel.org> <20191102220025.2475981-8-ast@kernel.org>
In-Reply-To: <20191102220025.2475981-8-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 5 Nov 2019 13:50:19 -0800
Message-ID: <CAEf4BzZCHGXCAdVNm2MoxrjgXxNHqXrZgw70j=byQuo4LSNQfg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 7/7] selftests/bpf: Add test for BPF trampoline
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Peter Ziljstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, x86@kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 2, 2019 at 3:04 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> Add sanity test for BPF trampoline that checks kernel functions
> with up to 6 arguments of different sizes.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  tools/lib/bpf/bpf_helpers.h                   | 13 +++
>  .../selftests/bpf/prog_tests/fentry_test.c    | 65 ++++++++++++++
>  .../testing/selftests/bpf/progs/fentry_test.c | 90 +++++++++++++++++++
>  3 files changed, 168 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/fentry_test.c
>  create mode 100644 tools/testing/selftests/bpf/progs/fentry_test.c
>
> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> index 0c7d28292898..c63ab1add126 100644
> --- a/tools/lib/bpf/bpf_helpers.h
> +++ b/tools/lib/bpf/bpf_helpers.h
> @@ -44,4 +44,17 @@ enum libbpf_pin_type {
>         LIBBPF_PIN_BY_NAME,
>  };
>
> +/* The following types should be used by BPF_PROG_TYPE_TRACING program to
> + * access kernel function arguments. BPF trampoline and raw tracepoints
> + * typecast arguments to 'unsigned long long'.
> + */
> +typedef int __attribute__((aligned(8))) ks32;
> +typedef char __attribute__((aligned(8))) ks8;
> +typedef short __attribute__((aligned(8))) ks16;
> +typedef long long __attribute__((aligned(8))) ks64;
> +typedef unsigned int __attribute__((aligned(8))) ku32;
> +typedef unsigned char __attribute__((aligned(8))) ku8;
> +typedef unsigned short __attribute__((aligned(8))) ku16;
> +typedef unsigned long long __attribute__((aligned(8))) ku64;
> +
>  #endif

[...]

> +
> +       err = bpf_prog_load("./test_pkt_access.o", BPF_PROG_TYPE_SCHED_CLS,
> +                           &pkt_obj, &pkt_fd);
> +       if (CHECK(err, "prog_load sched cls", "err %d errno %d\n", err, errno))
> +               return;
> +       err = bpf_prog_load_xattr(&attr, &obj, &kfree_skb_fd);
> +       if (CHECK(err, "prog_load fail", "err %d errno %d\n", err, errno))
> +               goto close_prog;
> +
> +       for (i = 0; i < 6; i++) {
> +               prog_name[sizeof(prog_name) - 2] = '1' + i;
> +               prog[i] = bpf_object__find_program_by_title(obj, prog_name);
> +               if (CHECK(!prog[i], "find_prog", "prog %s not found\n", prog_name))
> +                       goto close_prog;
> +               link[i] = bpf_program__attach_trace(prog[i]);

CHECK() here?

> +       }
> +       data_map = bpf_object__find_map_by_name(obj, "fentry_t.bss");
> +       if (CHECK(!data_map, "find_data_map", "data map not found\n"))
> +               goto close_prog;
> +
> +       err = bpf_prog_test_run(pkt_fd, 1, &pkt_v6, sizeof(pkt_v6),
> +                               NULL, NULL, &retval, &duration);
> +       CHECK(err || retval, "ipv6",
> +             "err %d errno %d retval %d duration %d\n",
> +             err, errno, retval, duration);
> +
> +       err = bpf_map_lookup_elem(bpf_map__fd(data_map), &zero, &result);
> +       if (CHECK(err, "get_result",
> +                 "failed to get output data: %d\n", err))
> +               goto close_prog;
> +
> +       for (i = 0; i < 6; i++)
> +               if (CHECK(result[i] != 1, "result", "bpf_fentry_test%d failed err %ld\n",
> +                         i + 1, result[i]))
> +                       goto close_prog;
> +
> +       passed = true;
> +       CHECK_FAIL(!passed);

passed and CHECK_FAIL are completely redundant?

> +close_prog:
> +       for (i = 0; i < 6; i++)
> +               if (!IS_ERR_OR_NULL(link[i]))
> +                       bpf_link__destroy(link[i]);
> +       bpf_object__close(obj);
> +       bpf_object__close(pkt_obj);
> +}

[...]
