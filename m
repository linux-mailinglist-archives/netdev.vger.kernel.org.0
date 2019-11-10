Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4664BF6A74
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 18:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbfKJRFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 12:05:12 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:42142 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbfKJRFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 12:05:11 -0500
Received: by mail-qk1-f196.google.com with SMTP id m4so9278991qke.9;
        Sun, 10 Nov 2019 09:05:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Cji3P/+/iv6xM2dBesjL/U0gPT0R14+ktVFzlPMpCaQ=;
        b=ts6UrP65DuBVimqFkd68ZVLVi+rioOkg17sjY2i8wA+wdDncU8+3Mug46OkTW8exbx
         qUUa+6j9l7mmusVr153uqDZG3e4pzV0L1j6ARq0avF1D7PY2wLy79JI2s/fBzN4mTgaG
         C4K3ZFUEY/SQ0Z/gsA9ZDo+46bax7OG3WnOMt9ULhaAZPvWBRLdJtqFH+yI7a0wbR7SN
         InoJi75pvO4z2lmNHGy8gAj5tG0EMMkMiSR34RQDksFiOaSxbPVZCbDrc9p0iL3SL17T
         4L+hFtFQdu92DVZuR4j+qDeRV/TE07pN/JlJhPOALgXUeeEE0vPUZoJTZxvvXLmElTRA
         2Yzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Cji3P/+/iv6xM2dBesjL/U0gPT0R14+ktVFzlPMpCaQ=;
        b=kw0VGfal5rPtnFH4z5B6b67Pide3e7Gk2o1oG85mIzjAPkYnkTk5oIYalDm8zEMIzI
         cemtnhX9DXubGnvQRj7RuIENjpQuJdRDHZXJRCJgb0aUYxHDP6/Rs3lHXHMBoRk7QUb7
         Lt1PqLhfKuyEfYqxrJLPdgAzlPtDtPN0DX1lLI99LUOQXvlAwWqD5lA7KSQ73iRzji1Z
         fCbO3woDfJvOsdNkSX2fhK9RMKmWec3nuNJn1HhHYUOH6FBLcB61TilbKKyfj2hzpmIL
         4tAkUeqaauLbD5dOnZahIv5Sxeq7X1KvnqUgVMc3Yy4IrMQUlbobPR7uhw/poAlY6Xin
         VqsA==
X-Gm-Message-State: APjAAAUtI7qy0ACG4kZaTPVOyKAjl6zcFG1a53TvHbG+uZw/EoYEqhvr
        HN7arinhlUm3R7n1CdXBVnVE3Q/OGemxc4VNfeBwPw==
X-Google-Smtp-Source: APXvYqzuZqRuFzVn2+1I2PQtmjiqHADc5NTlh9jElST4aLGWhHQQuJ8iFnheI7jD3P5u8lFfUBtQppkD7iVAAfmVtvc=
X-Received: by 2002:a37:b3c4:: with SMTP id c187mr7065985qkf.36.1573405510548;
 Sun, 10 Nov 2019 09:05:10 -0800 (PST)
MIME-Version: 1.0
References: <20191108064039.2041889-1-ast@kernel.org> <20191108064039.2041889-19-ast@kernel.org>
In-Reply-To: <20191108064039.2041889-19-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 10 Nov 2019 09:04:58 -0800
Message-ID: <CAEf4BzYt4L7pxKr0ES=-kUd92NMtBPabM2hZW=TrGNARsLnCJA@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 18/18] selftests/bpf: Add a test for attaching
 BPF prog to another BPF prog and subprog
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>, x86@kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 7, 2019 at 10:43 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> Add a test that attaches one FEXIT program to main sched_cls networking program
> and two other FEXIT programs to subprograms. All three tracing programs
> access return values and skb->len of networking program and subprograms.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  .../selftests/bpf/prog_tests/fexit_bpf2bpf.c  | 76 ++++++++++++++++
>  .../selftests/bpf/progs/fexit_bpf2bpf.c       | 91 +++++++++++++++++++
>  2 files changed, 167 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
>  create mode 100644 tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c
>

[...]

> +SEC("fexit/test_pkt_access_subprog2")
> +int test_subprog2(struct args_subprog2 *ctx)
> +{
> +       struct sk_buff *skb = (void *)ctx->args[0];
> +       __u64 ret;
> +       int len;
> +
> +       bpf_probe_read(&len, sizeof(len),
> +                      __builtin_preserve_access_index(&skb->len));

nit: we have bpf_core_read() for this, but I suspect you may have
wanted __builtin spelled out explicitly


> +
> +       ret = ctx->ret;
> +       /* bpf_prog_load() loads "test_pkt_access.o" with BPF_F_TEST_RND_HI32
> +        * which randomizes upper 32 bits after BPF_ALU32 insns.
> +        * Hence after 'w0 <<= 1' upper bits of $rax are random.
> +        * That is expected and correct. Trim them.
> +        */
> +       ret = (__u32) ret;
> +       if (len != 74 || ret != 148)
> +               return 0;
> +       test_result_subprog2 = 1;
> +       return 0;
> +}
> +char _license[] SEC("license") = "GPL";
> --
> 2.23.0
>
