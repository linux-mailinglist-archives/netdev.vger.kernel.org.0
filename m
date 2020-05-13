Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBD531D2236
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 00:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731438AbgEMWmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 18:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726383AbgEMWmT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 18:42:19 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC5EC061A0C;
        Wed, 13 May 2020 15:42:18 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id e25so1378296ljg.5;
        Wed, 13 May 2020 15:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wA6jZuXwICsYr7vyMmHFp883bAiAKNAsoU07JSFSjQA=;
        b=Cn7ZesKDFyD2sDfKkn/E9p01q3qP3QI2wun4qAgXtVR1WncRnSanohwVJyenAGwECz
         nX4TIOEpdfp2iQaKs4XaXIYiXzmWaQEC3IlnwU0qxbYryR8fgqptfWbf9IzpUUKfTgfP
         YpX2ks6zBc/ZUlSUI3rSimDRWXwdptuhrzRALzjoo6Nt+h3InGDnGGZBu/y5PEPSrrh5
         qPYuauYzW8aZcVyyfafb8hF8ZnJ0wh4kQdJJ+WBe/6vx5Xr7q6JuHY54q0aEZNhczb1M
         bta6acTKjLTEFAgh0jjA7mATTWn8DalkdMeAPzJ/VHxhQ2Hqs86W6j8n+3TuQhwlsWNc
         2wJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wA6jZuXwICsYr7vyMmHFp883bAiAKNAsoU07JSFSjQA=;
        b=klnWMdNUi0au3gqSbhuB6mJKqyGJtUmo4YPd9n7O2p0YaQ6y9CPOYizCt4ZoT/qwEb
         GL9rSeC/RAWwBNs1SrQ4Gz0bBYkcFXbQTk01EU5hlUJ/KVDNjABRaC6h5GcSjJpLBZ6b
         bUCfgPIJZ6WOrVwOMY0hXGx3MSlS2l/rT+YH5+tv7vEhTMr8YCGUZ+hvNwikMFP9F/LO
         vfDJuvlZXtTrs6QGJZj1xkJcHZShTaegF5o8hYEG3KlghorZXCJPDFuhAJ9fS+0chsRd
         J2u1JUI4dzcjYOoZ8xGCQ0F4ffKNjvADkT3AKNKHP3nvyhxHFMcQBQGNzcplA4BvAL2E
         LZEg==
X-Gm-Message-State: AOAM532LwYQcYCLLsiXwbqs/xnTCmZbOyEOQd14i9LWdoF6Nh90CHUR0
        oi3pE5daDt+UD8ODAEBh0TlUhDsdPqGLA/u1LeQ=
X-Google-Smtp-Source: ABdhPJybsgxwISFKw2am8eRhMIUvqnM7LOTqXOD0XGTOB7CfjzakjqZZzZG8YAA44vGJZEgEhKs6Cossp1UgQUJZ1so=
X-Received: by 2002:a2e:7508:: with SMTP id q8mr814203ljc.234.1589409737339;
 Wed, 13 May 2020 15:42:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200513212057.147133-1-andriin@fb.com>
In-Reply-To: <20200513212057.147133-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 13 May 2020 15:42:05 -0700
Message-ID: <CAADnVQJoU__8UrOE8Nm5R4W3qsV=YfCaWwYjNDKGaQrYPw2Wzg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: fix bpf_iter's task iterator logic
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 2:23 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> task_seq_get_next might stop prematurely if get_pid_task() fails to get
> task_struct. Failure to do so doesn't mean that there are no more tasks w=
ith
> higher pids. Procfs's iteration algorithm (see next_tgid in fs/proc/base.=
c)
> does a retry in such case. After this fix, instead of stopping prematurel=
y
> after about 300 tasks on my server, bpf_iter program now returns >4000, w=
hich
> sounds much closer to reality.
>
> Cc: Yonghong Song <yhs@fb.com>
> Fixes: eaaacd23910f ("bpf: Add task and task/file iterator targets")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  kernel/bpf/task_iter.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
> index a9b7264dda08..e1836def6738 100644
> --- a/kernel/bpf/task_iter.c
> +++ b/kernel/bpf/task_iter.c
> @@ -27,9 +27,15 @@ static struct task_struct *task_seq_get_next(struct pi=
d_namespace *ns,
>         struct pid *pid;
>
>         rcu_read_lock();
> +retry:
>         pid =3D idr_get_next(&ns->idr, tid);
> -       if (pid)
> +       if (pid) {
>                 task =3D get_pid_task(pid, PIDTYPE_PID);
> +               if (!task) {
> +                       *tid++;

../kernel/bpf/task_iter.c: In function =E2=80=98task_seq_get_next=E2=80=99:
../kernel/bpf/task_iter.c:35:4: warning: value computed is not used
[-Wunused-value]
   35 |    *tid++;
      |    ^~~~~~
