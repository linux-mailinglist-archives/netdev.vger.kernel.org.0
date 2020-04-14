Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9EEC1A7336
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 07:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405676AbgDNF4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 01:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405672AbgDNF4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 01:56:16 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 532B8C0A3BDC;
        Mon, 13 Apr 2020 22:56:16 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id z90so9201189qtd.10;
        Mon, 13 Apr 2020 22:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PZlrHZ01xsbg88HIp1L/IORP/s8wpbtZlVJLqqY+T3M=;
        b=Was4lc2VTxJkY5TnZOftJWu+Yl0EfWtcntcFS5HRgFBERCcjOsK/8X2oQXwVT9qCjM
         P196oRde0WzvXoUcF7qKpTSZk1ux9rIATmtorGyXeeRNOyuV+kLEYiHrArbF6AuouuTf
         a87AAD6ON2CtgT5WYbLtq9Bg09DwF6nrD2XRvU5ztkx8Tm9gNTkcgRxFibc6X1S1vKlA
         mChiBeq4Qt1RIMyqgUs7X9ZNIC2xF3NebnQwKPcUJxZCggKfbx+qbjpIlEzgQVdGaZju
         m3RONsvpuSpfMv0O/kIqFwG4q+0ltyCcAfKW0PoG1k2kcEBswJhmpnDumcVDhe9s/Pto
         9K/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PZlrHZ01xsbg88HIp1L/IORP/s8wpbtZlVJLqqY+T3M=;
        b=QDVSDFZ5SCGkUa7yce3Eh0qDkL09rv40avPT3UZFixEtEVjr9mLy2ZFxrpwmy1/r0y
         Ty0IQpnPtIhJXMcqIOWIdrQ1ZwMXTOWzibokN4QpeIOC2FKuv821GNBNGgg42tSPxKFI
         iF+snJRZIfeOwt0i/tbivapp2AGJtF0SZCqO7CmhwAjFPL5XZNj27lBBX6asZq9ZpZiw
         G9n2q+ACFvk72BaUuC+yFq156r2rwSpMio0045DfiTtf3A1jeBm7xjIZNhYOcIl9zGKp
         x113eB9xrXWz1snalLq7cvixrpS7cmbAKn94YxwNcgMPM1owSMwkMeh5aZW55b3yogis
         leKw==
X-Gm-Message-State: AGi0PubkP+9WB1eox7JIA5O+QrbuUGkdC0O2MvMXAbmm8SpsgEDMMCMs
        4ksdHbXtxoW8FeOvqoaXsJaogns1Hu7MrDmGeMo=
X-Google-Smtp-Source: APiQypJYk8DAj/d+T10MWHq7pzwFA8RGM7eQM2ITVMlP3uoj9cK5EdtLhcMfMAlZubJyQ52RBr9joMXH9JBVz182iqI=
X-Received: by 2002:ac8:468d:: with SMTP id g13mr14335066qto.59.1586843775346;
 Mon, 13 Apr 2020 22:56:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200408232520.2675265-1-yhs@fb.com> <20200408232526.2675664-1-yhs@fb.com>
In-Reply-To: <20200408232526.2675664-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 13 Apr 2020 22:56:04 -0700
Message-ID: <CAEf4Bzawu2dFXL7nvYhq1tKv9P7Bb9=6ksDpui5nBjxRrx=3_w@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 05/16] bpf: create file or anonymous dumpers
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 8, 2020 at 4:26 PM Yonghong Song <yhs@fb.com> wrote:
>
> Given a loaded dumper bpf program, which already
> knows which target it should bind to, there
> two ways to create a dumper:
>   - a file based dumper under hierarchy of
>     /sys/kernel/bpfdump/ which uses can
>     "cat" to print out the output.
>   - an anonymous dumper which user application
>     can "read" the dumping output.
>
> For file based dumper, BPF_OBJ_PIN syscall interface
> is used. For anonymous dumper, BPF_PROG_ATTACH
> syscall interface is used.

We discussed this offline with Yonghong a bit, but I thought I'd put
my thoughts about this in writing for completeness. To me, it seems
like the most consistent way to do both anonymous and named dumpers is
through the following steps:

1. BPF_PROG_LOAD to load/verify program, that created program FD.
2. LINK_CREATE using that program FD and direntry FD. This creates
dumper bpf_link (bpf_dumper_link), returns anonymous link FD. If link
FD is closed, dumper program is detached and dumper is destroyed
(unless pinned in bpffs, just like with any other bpf_link.
3. At this point bpf_dumper_link can be treated like a factory of
seq_files. We can add a new BPF_DUMPER_OPEN_FILE (all names are for
illustration purposes) command, that accepts dumper link FD and
returns a new seq_file FD, which can be read() normally (or, e.g.,
cat'ed from shell).
4. Additionally, this anonymous bpf_link can be pinned/mounted in
bpfdumpfs. We can do it as BPF_OBJ_PIN or as a separate command. Once
pinned at, e.g., /sys/fs/bpfdump/task/my_dumper, just opening that
file is equivalent to BPF_DUMPER_OPEN_FILE and will create a new
seq_file that can be read() independently from other seq_files opened
against the same dumper. Pinning bpfdumpfs entry also bumps refcnt of
bpf_link itself, so even if process that created link dies, bpf dumper
stays attached until its bpfdumpfs entry is deleted.

Apart from BPF_DUMPER_OPEN_FILE and open()'ing bpfdumpfs file duality,
it seems pretty consistent and follows safe-by-default auto-cleanup of
anonymous link, unless pinned in bpfdumpfs (or one can still pin
bpf_link in bpffs, but it can't be open()'ed the same way, it just
preserves BPF program from being cleaned up).

Out of all schemes I could come up with, this one seems most unified
and nicely fits into bpf_link infra. Thoughts?

>
> To facilitate target seq_ops->show() to get the
> bpf program easily, dumper creation increased
> the target-provided seq_file private data size
> so bpf program pointer is also stored in seq_file
> private data.
>
> Further, a seq_num which represents how many
> bpf_dump_get_prog() has been called is also
> available to the target seq_ops->show().
> Such information can be used to e.g., print
> banner before printing out actual data.
>
> Note the seq_num does not represent the num
> of unique kernel objects the bpf program has
> seen. But it should be a good approximate.
>
> A target feature BPF_DUMP_SEQ_NET_PRIVATE
> is implemented specifically useful for
> net based dumpers. It sets net namespace
> as the current process net namespace.
> This avoids changing existing net seq_ops
> in order to retrieve net namespace from
> the seq_file pointer.
>
> For open dumper files, anonymous or not, the
> fdinfo will show the target and prog_id associated
> with that file descriptor. For dumper file itself,
> a kernel interface will be provided to retrieve the
> prog_id in one of the later patches.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  include/linux/bpf.h            |   5 +
>  include/uapi/linux/bpf.h       |   6 +-
>  kernel/bpf/dump.c              | 338 ++++++++++++++++++++++++++++++++-
>  kernel/bpf/syscall.c           |  11 +-
>  tools/include/uapi/linux/bpf.h |   6 +-
>  5 files changed, 362 insertions(+), 4 deletions(-)
>

[...]
