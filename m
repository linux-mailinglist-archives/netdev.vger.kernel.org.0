Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA58C69EC5
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 00:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732179AbfGOWNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 18:13:19 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:37497 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727862AbfGOWNT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 18:13:19 -0400
Received: by mail-lj1-f196.google.com with SMTP id z28so17905198ljn.4;
        Mon, 15 Jul 2019 15:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RYvawgoVXxgKzHpmJobAA5+pmQDaHULBJ3kgW7j4fMw=;
        b=vVO92mJv1H+mtVSifGhFUZvrqSjH5WNcH9UcOMrfJ0/F40JP6tDJnocCojxnr8QGFH
         0xP9OW3K2v1KMgOirmGR0qVpFDOkjyKA5ELY22HldUt9YDUcB3c+Y7ChUyszCYgz2IvU
         gEG2MuwikJnLQYe3urWZrUMiE9ofVBcxC9qNoJglrnwL5/o0wnC3aggp9othtkHRzluM
         95BZcJEeLKPHg/zEjo7+QLyUqGNtxQeMNYNIldxnCe8orDOmLh9R/U/l/qqNvs73p8Fr
         RoQw1rFjUf0LXzofV+cuWrJ1HQ1YDEZ3R9HGm5U9SrViETfiJN1Z9paFRVSJ3mMT3AVI
         LrjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RYvawgoVXxgKzHpmJobAA5+pmQDaHULBJ3kgW7j4fMw=;
        b=N6Bav1MkKZDXMW+/9tXrO6/1S0/GGS6rv8G+9TqFg8lecYB7el3aVl9nNg3nlUWHyl
         6TIXS1j1CuGMR1N6JTVOJ5RDLk5NtKlJhNNZ006B3EOS/iigCbG8WfCvKdZ+DyzZBHHE
         puvZk5nekgNNqW1MA4/IskGqr3SJXUWh/ccXXoiPjt7rU+kiV955jdes/uCt1WBT7HdT
         +oDhL+Is+1S+MHM/BTGfWzDpU3cDw/enYYex8tP7oUOp7KjvVD03EIB1YUTt/cQ6BoNr
         Bn91crz9JOiFQIcjh2u+uf35H8ykJpHOZlwu1PHugVbQiHfrRJ/xv+zLAYMFypVAnrvt
         wZ+g==
X-Gm-Message-State: APjAAAXi5AhUpg0F9KjO6LPNvw1rMPRWNfdVI5kvDeIwILOd/DDKaTi6
        F2FeYgBkxpAvkPUiWWyqcYK8tSIfZywBcz5i3M8=
X-Google-Smtp-Source: APXvYqy/d+yxromHd4rFbHGssGVkg9GGpEgmZrJwyP3oSA2YWNgrA3A+czE1o4iCpfr5Cr57jiMxo5s3BrOfC6SvNwk=
X-Received: by 2002:a2e:7818:: with SMTP id t24mr14949499ljc.210.1563228797204;
 Mon, 15 Jul 2019 15:13:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190704085224.65223-1-iii@linux.ibm.com>
In-Reply-To: <20190704085224.65223-1-iii@linux.ibm.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 15 Jul 2019 15:13:05 -0700
Message-ID: <CAADnVQ+H9bOW+EY6=AKt7mqgdEgaPhc1Wk_o=Ez43CracLCaiA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next] selftests/bpf: fix "alu with different
 scalars 1" on s390
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Y Song <ys114321@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 4, 2019 at 1:53 AM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
>
> BPF_LDX_MEM is used to load the least significant byte of the retrieved
> test_val.index, however, on big-endian machines it ends up retrieving
> the most significant byte.
>
> Use the correct least significant byte offset on big-endian machines.
>
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> ---
>
> v1->v2:
> - use __BYTE_ORDER instead of __BYTE_ORDER__.
>
>  tools/testing/selftests/bpf/verifier/value_ptr_arith.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/verifier/value_ptr_arith.c b/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
> index c3de1a2c9dc5..e5940c4e8b8f 100644
> --- a/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
> +++ b/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
> @@ -183,7 +183,11 @@
>         BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
>         BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
>         BPF_EXIT_INSN(),
> +#if __BYTE_ORDER == __LITTLE_ENDIAN
>         BPF_LDX_MEM(BPF_B, BPF_REG_1, BPF_REG_0, 0),
> +#else
> +       BPF_LDX_MEM(BPF_B, BPF_REG_1, BPF_REG_0, sizeof(int) - 1),
> +#endif

I think tests should be arch and endian independent where possible.
In this case test_val.index is 4 byte and 4 byte load should work just as well.
