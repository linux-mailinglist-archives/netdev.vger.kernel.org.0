Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78E6D64F66
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 01:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727653AbfGJX52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 19:57:28 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33974 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727386AbfGJX52 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 19:57:28 -0400
Received: by mail-qt1-f196.google.com with SMTP id k10so4503038qtq.1;
        Wed, 10 Jul 2019 16:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vm1tVbhQpvHWsXffjaSnaFHT1SscgoMTOQl51QNkYuU=;
        b=DgXDeg3++iIAfEw1RQwcNOG++6kooAArYaBKpFUvjeIaYRYMhRYLnAYO+2BWUkjrr3
         Ol2U3efQjm4vXiXLeVEcpUS1iWHZyBkiSVzOpna598WbkzkFynFbs6R1S0Xp7TZd7uUH
         jwDV33Y9ispkmz0/k4d67eyDpPVzqJQ6usCxXYSVr4IIh69RhbJ/hBYa4gJb+T5D/QgP
         hDBxRiRMlBGWwd4F9FejS6fllbQPI2dumDFOCkmsnm64kQUBHbwSVmOUgwm3KxPKVLny
         zFOTtOgD6k+uaA92D1aP2YlRmq2maT1P+63NwBX8btPOe/Z4ntZfynXX6CAUhrJ+9Qx1
         Auag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vm1tVbhQpvHWsXffjaSnaFHT1SscgoMTOQl51QNkYuU=;
        b=ijI399gqpsgx5Ng3SPti7SZqpvOOq1BlI9x/PONIHQoCQ43t3ZUB2EBAHaauT4EQlB
         Lx1KAr2OH5hhSMlY3jXHMu+TrS/4vUVdcEiv/MQSZiJdqwdbuwMmSZ+VA7uzKxchhG7x
         ZqcnN+sm88Ywk4X2jTeMFsZy16jj2QDBqIys0j1ua8R6yoqi6RkpcL8hJkTTcO0Mjjxt
         gsIoWg8BhchkF+GM1DXZGDhWrIqm8+dQGRahRYtAJ85WDwCe5YOvN07J2ATf5K91zlFK
         t0AQhzpbcwdMGmufoy/Mm8QSW70fPrPJ2Xpn7eJ0jrvKCs0kQ97vGUNkvqC4gz9bEhtq
         GCyw==
X-Gm-Message-State: APjAAAXg8ufAwbZTd/BdG3IFHXEBZYjBXRZFbJIA/RROvdynJ5W9vjc3
        G3eDEdSNETE4Z52xn6JKGNUIdi/80gNnDrtVY/o=
X-Google-Smtp-Source: APXvYqwbvo6jaHPWWRaf/CoYsZbw4JKCj+tSd90LAsafEHlIYQ614EMOSE4fuSEeR2x2X16oRfsJJMadselw5eeyYn4=
X-Received: by 2002:a0c:818f:: with SMTP id 15mr418329qvd.162.1562803046595;
 Wed, 10 Jul 2019 16:57:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190708163121.18477-1-krzesimir@kinvolk.io> <20190708163121.18477-4-krzesimir@kinvolk.io>
In-Reply-To: <20190708163121.18477-4-krzesimir@kinvolk.io>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 10 Jul 2019 16:57:15 -0700
Message-ID: <CAEf4BzbM6EiCkN5mwK1YP-NC2bavkkHV7nFR-PXCWGOvVt7nTg@mail.gmail.com>
Subject: Re: [bpf-next v3 03/12] selftests/bpf: Avoid another case of errno clobbering
To:     Krzesimir Nowak <krzesimir@kinvolk.io>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Alban Crequy <alban@kinvolk.io>,
        =?UTF-8?Q?Iago_L=C3=B3pez_Galeiras?= <iago@kinvolk.io>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        xdp-newbies@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 8, 2019 at 3:43 PM Krzesimir Nowak <krzesimir@kinvolk.io> wrote:
>
> Commit 8184d44c9a57 ("selftests/bpf: skip verifier tests for
> unsupported program types") added a check for an unsupported program
> type. The function doing it changes errno, so test_verifier should
> save it before calling it if test_verifier wants to print a reason why
> verifying a BPF program of a supported type failed.
>
> Changes since v2:
> - Move the declaration to fit the reverse christmas tree style.
>
> Fixes: 8184d44c9a57 ("selftests/bpf: skip verifier tests for unsupported program types")
> Cc: Stanislav Fomichev <sdf@google.com>
> Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/testing/selftests/bpf/test_verifier.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
> index 3fe126e0083b..c7541f572932 100644
> --- a/tools/testing/selftests/bpf/test_verifier.c
> +++ b/tools/testing/selftests/bpf/test_verifier.c
> @@ -864,6 +864,7 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
>         int run_errs, run_successes;
>         int map_fds[MAX_NR_MAPS];
>         const char *expected_err;
> +       int saved_errno;
>         int fixup_skips;

nit: combine those ints? or even with i and err below as well?

>         __u32 pflags;
>         int i, err;
> @@ -894,6 +895,7 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
>                 pflags |= BPF_F_ANY_ALIGNMENT;
>         fd_prog = bpf_verify_program(prog_type, prog, prog_len, pflags,
>                                      "GPL", 0, bpf_vlog, sizeof(bpf_vlog), 4);
> +       saved_errno = errno;
>         if (fd_prog < 0 && !bpf_probe_prog_type(prog_type, 0)) {
>                 printf("SKIP (unsupported program type %d)\n", prog_type);
>                 skips++;
> @@ -910,7 +912,7 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
>         if (expected_ret == ACCEPT) {
>                 if (fd_prog < 0) {
>                         printf("FAIL\nFailed to load prog '%s'!\n",
> -                              strerror(errno));
> +                              strerror(saved_errno));
>                         goto fail_log;
>                 }
>  #ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> --
> 2.20.1
>
