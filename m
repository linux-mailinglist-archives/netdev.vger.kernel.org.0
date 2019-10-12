Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC5FD4CF9
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 06:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbfJLEiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 00:38:19 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:46494 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbfJLEiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 00:38:19 -0400
Received: by mail-qt1-f196.google.com with SMTP id u22so16934926qtq.13;
        Fri, 11 Oct 2019 21:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TUKns7wuiKOPhZOksi8rGoNGy3wniKVMz8Gwo1AYhA4=;
        b=b/V+Eh3i3QF8FXzCfkOulJHgZj1exG1MgY//Id1GC1AduYVi3koPCuZV90TA+yI4RD
         1xwsNTzMASDsTMzZpUiITJk5HJ6oUxT9PHnWIKcDAYRqrKZSMs3zzPb+AEu06lW6COxq
         rwoqW2zhVo63M9YuvgAxkTmyzYLKj+/bQRNAM2pnMr46aFSlQa3buQNae+7NDB9X8rdS
         9qajGwKIbC23Xbu0wVhdB/ax103O/MyULm2aeHybGcxdTv9N+CCDsGK18YkZJrT+WZat
         DhRMkasrPZye/vNMGIWGlASIoOUnaYvfDuMxIHjEEOHgKtLTxb8yhbOOz/vfJmBUuUcA
         0d2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TUKns7wuiKOPhZOksi8rGoNGy3wniKVMz8Gwo1AYhA4=;
        b=Olz+b5fnEow5k8BfhAjVrvG6mDsM9QOgi2/hhDqqOYMVMVwIbio8EETC4Z3ka5L6IV
         Y6j4vy2v+bcMbeEsle3FtLHeL+h/QZPO2zCSej9wVCyFEYKl+R2YEBM3EffR+WEYO5tm
         rFWggfWsr92CtHbXZLODKsqNREvDbbL+SaTrqJL8AbipahBL8FIUVes1PbT8dowG7pK9
         57nsCAAcPAtkGxu09L7M/UIchecMYXnDRNnhwvkrB0CEVzeN7oFxhjhFaz4PEHLc6a5E
         ldLC9CVZQ0h6UNXrVyDrlLredCm0Vam1nby7z0pINvestL9Z12oHGFZKzejSfYFS7Wcc
         adCg==
X-Gm-Message-State: APjAAAXSH0iHlVghYEBM3xHPPk3gXOyagcT5VTcNsyUJzCL/D8FSDGKs
        Bb/bkMA2ySBomCczxZZaPc9XDYe4n9Ca++AJJOg=
X-Google-Smtp-Source: APXvYqzriVCzHruUq0dInxh/hj2C7wisIpTxHvfPsQZbHokbFCBBDvMeNVjp0sZBXxK7g3R1xtEhdBNugG71FeqvBUM=
X-Received: by 2002:a0c:f885:: with SMTP id u5mr19355583qvn.247.1570855097834;
 Fri, 11 Oct 2019 21:38:17 -0700 (PDT)
MIME-Version: 1.0
References: <20191010041503.2526303-1-ast@kernel.org> <20191010041503.2526303-6-ast@kernel.org>
 <CAEf4BzZxQDUzYYjF091135d+O_fwZVdK9Dqw5H4_z=5QBqueYg@mail.gmail.com>
 <0dbf83e8-10ec-cc17-c575-949639a7f018@fb.com> <ec2ca725-6228-b9e9-e9fc-34e4b34d8a1a@fb.com>
In-Reply-To: <ec2ca725-6228-b9e9-e9fc-34e4b34d8a1a@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 11 Oct 2019 21:38:06 -0700
Message-ID: <CAEf4BzZsz-6ftv628bk9LtEFr1qUoARL32x-kGagi7esOBURyA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 05/12] libbpf: auto-detect btf_id of raw_tracepoint
To:     Alexei Starovoitov <ast@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 11, 2019 at 6:29 PM Alexei Starovoitov <ast@fb.com> wrote:
>
> On 10/11/19 5:40 PM, Alexei Starovoitov wrote:
> >> But even if kernel supports attach_btf_id, I think users still need to
> >> opt in into specifying attach_btf_id by libbpf. Think about existing
> >> raw_tp programs that are using bpf_probe_read() because they were not
> >> created with this kernel feature in mind. They will suddenly stop
> >> working without any of user's fault.
> >
> > This one is excellent catch.
> > loop1.c should have caught it, since it has
> > SEC("raw_tracepoint/kfree_skb")
> > {
> >    int nested_loops(volatile struct pt_regs* ctx)
> >     .. = PT_REGS_RC(ctx);
> >
> > and verifier would have rejected it.
> > But the way the test is written it's not using libbpf's autodetect
> > of program type, so everything is passing.
>
> With:
> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
> b/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
> index 1c01ee2600a9..e27156dce10d 100644
> --- a/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
> @@ -67,7 +67,7 @@ void test_bpf_verif_scale(void)
>                   */
>                  { "pyperf600_nounroll.o", BPF_PROG_TYPE_RAW_TRACEPOINT },
>
> -               { "loop1.o", BPF_PROG_TYPE_RAW_TRACEPOINT },
> +               { "loop1.o", BPF_PROG_TYPE_UNSPEC},
>                  { "loop2.o", BPF_PROG_TYPE_RAW_TRACEPOINT },
>
> libbpf prog auto-detection kicks in and ...
> # ./test_progs -n 3/10
> libbpf: load bpf program failed: Permission denied
> libbpf: -- BEGIN DUMP LOG ---
> libbpf:
> raw_tp 'kfree_skb' doesn't have 10-th argument
> invalid bpf_context access off=80 size=8
>
> Good :) The verifier is doing its job.

oh, another super intuitive error from verifier ;) 10th argument, what?..
