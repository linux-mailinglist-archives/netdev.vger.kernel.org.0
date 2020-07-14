Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 920B721E76C
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 07:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgGNFV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 01:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgGNFV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 01:21:58 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73F69C061755;
        Mon, 13 Jul 2020 22:21:58 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id c30so14517516qka.10;
        Mon, 13 Jul 2020 22:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eM6mnm+7ClRhKfOMWy1bioR1vc3aLslaUsjGxpj/AWY=;
        b=dLqfI6koj0cnA89he5hROH2se3eEnlJpaXMtJSloHp9uwIy4rjXVsijA6eYaE6aqc/
         p31Ey8rO0QI7gUNeQR5diYD1vnm7CntgqjDf6cFiPJ8Mg8C3RHkLad+doDme3LL8a8Fb
         fw7h3ByliBSA9c4EzNpZD2P0BPW0XYPRllAiMkz9wkykceWNOy5c5FBDp9KxjxuBruE8
         9b5GzzJuX42NluV1bODafbIBF8b725iXmFnEpUmxVi8Ms9TVihDK3QG/h2byntjZf9fR
         rF2OXmGVy2tkgS995AD6JYS/J/lTs5x37vEZ7T0xpdbRXajW700EYD/dFdgDGfF3/nM0
         y+ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eM6mnm+7ClRhKfOMWy1bioR1vc3aLslaUsjGxpj/AWY=;
        b=ZKF1GUWnh6Ar63AU/50YnDOq/k36I0va1uRHFZzM6khgDdxTwKSasLJMtr9o5occ11
         jkPdf8r78lnKEZkYDeKUc+hRx2Cst+IfP6soypzsfsZNYIWnHWbPAz7mS0qmwchnvQzh
         JZVIzPbP8jp9B8Y9bjcHbyVuNp6HdwJ2Gtymi7nguZtEbaqfcZJb9y03wL9nMFgP88Tb
         EYX73ZRfWAbywoltXZjUwUfdIeMCTP9AvqJvH2W6j0cCJgeyB+73E4fxFbQWqSMpljoL
         eYM4Y+71P3bu02PQEAcdd0Bf1xmCQXePIOShsHB9CraaqEQXLAwhHTn20tGj6nnJCKqY
         oxNw==
X-Gm-Message-State: AOAM531lUruwzpfdaBDprVSscIigiELrsGK4hy7h2wNOkfDiBuQ/H2dn
        DTFk7eTKiF7Fp0gZFSYVLc+safMxK63ZLGZy4w5b9IBl
X-Google-Smtp-Source: ABdhPJyzqoHf0bBMYfS1MXdz1rPg2o2UxYWBbSX/EFCb7PcsCVUN/uP6hfhO2YjkE7iu/gX1Trh2Zh4FzZeeV67SXrc=
X-Received: by 2002:a37:270e:: with SMTP id n14mr2941310qkn.92.1594704117492;
 Mon, 13 Jul 2020 22:21:57 -0700 (PDT)
MIME-Version: 1.0
References: <159467113970.370286.17656404860101110795.stgit@toke.dk> <159467114405.370286.1690821122507970067.stgit@toke.dk>
In-Reply-To: <159467114405.370286.1690821122507970067.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 13 Jul 2020 22:21:46 -0700
Message-ID: <CAEf4BzZ_-vXP_3hSEjuceW10VX_H+EeuXMiV=_meBPZn7izK8A@mail.gmail.com>
Subject: BPF logging infrastructure. Was: [PATCH bpf-next 4/6] tools: add new
 members to bpf_attr.raw_tracepoint in bpf.h
To:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 1:13 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> Sync addition of new members from main kernel tree.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  tools/include/uapi/linux/bpf.h |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
> index da9bf35a26f8..662a15e4a1a1 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -573,8 +573,13 @@ union bpf_attr {
>         } query;
>
>         struct { /* anonymous struct used by BPF_RAW_TRACEPOINT_OPEN comm=
and */
> -               __u64 name;
> -               __u32 prog_fd;
> +               __u64           name;
> +               __u32           prog_fd;
> +               __u32           log_level;      /* verbosity level of log=
 */
> +               __u32           log_size;       /* size of user buffer */
> +               __aligned_u64   log_buf;        /* user supplied buffer *=
/
> +               __u32           tgt_prog_fd;
> +               __u32           tgt_btf_id;
>         } raw_tracepoint;
>
>         struct { /* anonymous struct for BPF_BTF_LOAD */
>

I think BPF syscall would benefit from common/generalized log support
across all commands, given how powerful/complex it already is.
Sometimes it's literally impossible to understand why one gets -EINVAL
without adding printk()s in the kernel.

But it feels wrong to add log_level/log_size/log_buf fields to every
section of bpf_attr and require the user to specify it differently for
each command. So before we go and start adding per-command fields,
let's discuss how we can do this more generically. I wonder if we can
come up with a good way to do it in one common way and then gradually
support that way throughout all BPF commands.

Unfortunately it's too late to just add a few common fields to
bpf_attr in front of all other per-command fields, but here's two more
ideas just to start discussion. I hope someone can come up with
something nicer.

1. Currently bpf syscall accepts 3 input arguments (cmd, uattr, size).
We can extend it with two more optional arguments: one for pointer to
log-defining attr (for log_buf pointer, log_size, log_level, maybe
something more later) and another for the size of that log attr.
Beyond that we'd need some way to specify that the user actually meant
to provide those 2 optional args. The most straightforward way would
be to use the highest bit of cmd argument. So instead of calling bpf()
with BPF_MAP_CREATE command, you'd call it with BPF_MAP_CREATE |
BPF_LOGGED, where BPF_LOGGED =3D 1<<31.

2. A more "stateful" approach, would be to have an extra BPF command
to set log buffer (and level) per thread. And if such a log is set, it
would be overwritten with content on each bpf() syscall invocation
(i.e., log position would be reset to 0 on each BPF syscall).

Of course, the existing BPF_LOAD_PROG command would keep working with
existing log, but could fall back to the "common one", if
BPF_LOAD_PROG-specific one is not set.

It also doesn't seem to be all that critical to signal when the log
buffer is overflown. It's pretty easy to detect from user-space:
- either last byte would be non-zero, if we don't care about
guaranteeing zero-termination for truncated log;
- of second-to-last byte would be non-zero, if BPF syscall will always
zero-terminate the log.

Of course, if user code cares about such detection of log truncation,
it will need to set last/second-to-last bytes to zero before each
syscall.

Both approaches have their pros/cons, we can dig into those later, but
I'd like to start this discussion and see what other people think. I
also wonder if there are other syscalls with similarly advanced input
arguments (like bpf_attr) and common logging, we could learn from
those.

Thoughts?
