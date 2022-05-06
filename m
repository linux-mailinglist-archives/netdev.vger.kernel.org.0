Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACDF51E1E9
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 01:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444744AbiEFWa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 18:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444734AbiEFWaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 18:30:55 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D118427FE9;
        Fri,  6 May 2022 15:27:10 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id g21so9528057iom.13;
        Fri, 06 May 2022 15:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YJWiJkdYGbBSzS+2Wxslwj9TmG4q/ytv0/hJtkg8UQg=;
        b=ktcUjwf3H30s1wm61j3zKM6tKWY1rfKoW8d54w9wNM6bfoYJPvn8uNDW0i/BTaf7Ih
         n/crwQWaJXGVKgNJPeLFb1LPGVQnxKJcQGwslGxFyuQ64tA9T5Gxx0KDEba39g3Eqx/L
         CcSNL4FFmBIu61JFHYxatFI2rVA6jgHGp1iajc0v6KLmlG120keCx5CLXP0Za1vCSb5F
         eauf5mBaXWoFmb00tr80prjDvzS7u57HQFxDYmFgpS9+8Yuj9zjpgn1Bfw/V8pDZt0Ko
         YXrWgr+s2mxgI/WkTz7mQbZZ3TSSvp6A8PTkBzl6N8f3avwzRokMhOmIOpsO3zJd+JdQ
         rsWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YJWiJkdYGbBSzS+2Wxslwj9TmG4q/ytv0/hJtkg8UQg=;
        b=xLxfYzDlXGwcWitDAgKe5/QcuKHrUidJx6/OVE9teBpX+hpPBZxjgBtLhJpaPiyuaD
         1h40eyVThNuEyciOLwQuxTqDwObxzeRghYzix/ObCim5os/DXezLoS9PyaiqVBQHmSRS
         9oHwXpe9/YhdRLRk1+jpB8JgVdTbVUoJp/aVAoYOnuDGkGXl5sd4FXF+PkL3fabVV/cI
         J9vFNS8bY9ONQmttwQyMp5hLwisLWm17y7VzfpwU7VVo5BMN0phganWaCgDrapMYQ43k
         8GtFJYi0Q3FBDZDFoNrH1y8O71c/cgCx7G7VBzWpF62+NqPiMKNbUbTFluJ29lVrL73b
         7DVg==
X-Gm-Message-State: AOAM530w3j2y8314S2RoC0sDiRIeIzCFG3MNEYLqWEG+mOIRh2KLLah3
        dIdHLcsqHaMGdaB8JKdy+pg1vKNstvPR+NKZgcI=
X-Google-Smtp-Source: ABdhPJzaj0DIFHrLtlkn84RWVvdJ/q3hiqsgHOI7ZpI37NHJVB/7z/MEMSqjQnZqZbefbKdJKKLOhOjszH4B5vTnS1k=
X-Received: by 2002:a05:6638:33a1:b0:32b:8e2b:f9ba with SMTP id
 h33-20020a05663833a100b0032b8e2bf9bamr2386086jav.93.1651876030268; Fri, 06
 May 2022 15:27:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220502211235.142250-1-mathew.j.martineau@linux.intel.com> <20220502211235.142250-6-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20220502211235.142250-6-mathew.j.martineau@linux.intel.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 6 May 2022 15:26:59 -0700
Message-ID: <CAEf4BzY-t=ZtmU+6yeSo5DD6+C==NUN=twAKq=OQyVb2rS2ENw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 5/8] selftests: bpf: test bpf_skc_to_mptcp_sock
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Geliang Tang <geliang.tang@suse.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, mptcp@lists.linux.dev,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 2, 2022 at 2:12 PM Mat Martineau
<mathew.j.martineau@linux.intel.com> wrote:
>
> From: Geliang Tang <geliang.tang@suse.com>
>
> This patch extends the MPTCP test base, to test the new helper
> bpf_skc_to_mptcp_sock().
>
> Define struct mptcp_sock in bpf_tcp_helpers.h, use bpf_skc_to_mptcp_sock
> to get the msk socket in progs/mptcp_sock.c and store the infos in
> socket_storage_map.
>
> Get the infos from socket_storage_map in prog_tests/mptcp.c. Add a new
> function verify_msk() to verify the infos of MPTCP socket, and rename
> verify_sk() to verify_tsk() to verify TCP socket only.
>
> v2: Add CONFIG_MPTCP check for clearer error messages
>
> Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Signed-off-by: Geliang Tang <geliang.tang@suse.com>
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> ---
>  MAINTAINERS                                   |  1 +
>  .../testing/selftests/bpf/bpf_mptcp_helpers.h | 14 ++++++++
>  .../testing/selftests/bpf/prog_tests/mptcp.c  | 36 +++++++++++++++----
>  .../testing/selftests/bpf/progs/mptcp_sock.c  | 24 ++++++++++---
>  4 files changed, 65 insertions(+), 10 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/bpf_mptcp_helpers.h
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 359afc617b92..d48d3cb6abbc 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13780,6 +13780,7 @@ F:      include/net/mptcp.h
>  F:     include/trace/events/mptcp.h
>  F:     include/uapi/linux/mptcp.h
>  F:     net/mptcp/
> +F:     tools/testing/selftests/bpf/bpf_mptcp_helpers.h
>  F:     tools/testing/selftests/bpf/*/*mptcp*.c
>  F:     tools/testing/selftests/net/mptcp/
>
> diff --git a/tools/testing/selftests/bpf/bpf_mptcp_helpers.h b/tools/testing/selftests/bpf/bpf_mptcp_helpers.h
> new file mode 100644
> index 000000000000..18da4cc65e89
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/bpf_mptcp_helpers.h
> @@ -0,0 +1,14 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright (c) 2022, SUSE. */
> +
> +#ifndef __BPF_MPTCP_HELPERS_H
> +#define __BPF_MPTCP_HELPERS_H
> +
> +#include "bpf_tcp_helpers.h"
> +
> +struct mptcp_sock {
> +       struct inet_connection_sock     sk;
> +
> +} __attribute__((preserve_access_index));

why can't all this live in bpf_tcp_helpers.h? why do we need extra header?

> +
> +#endif
> diff --git a/tools/testing/selftests/bpf/prog_tests/mptcp.c b/tools/testing/selftests/bpf/prog_tests/mptcp.c
> index cd548bb2828f..4b40bbdaf91f 100644
> --- a/tools/testing/selftests/bpf/prog_tests/mptcp.c
> +++ b/tools/testing/selftests/bpf/prog_tests/mptcp.c
> @@ -10,14 +10,12 @@ struct mptcp_storage {
>         __u32 is_mptcp;
>  };
>

[...]
