Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BED42DEAB2
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 22:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbgLRVDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 16:03:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725778AbgLRVDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 16:03:01 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E9EC0617A7;
        Fri, 18 Dec 2020 13:02:21 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id d37so3137098ybi.4;
        Fri, 18 Dec 2020 13:02:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=47vveCYCVpthvHmKjVidfRBrMv4CgoZqAi5d0tl2Cos=;
        b=XtCtwzQ+h11D7UFAoi3ICRNh21XpjfVsLQhKHtKE5iuXoN8prq/7NPSPTzzTdC9V2u
         IF3lr0G0JRSG7rNYtON4nkoI5y6w3SjUoVKOof5Q4YCFi7V+I0Dt2LRs/Ynu2Zf2StNj
         ld9qC/LFcH5ToZBjA1MRu62ggju5ufdz8PHdbpdYY/usbYdYao9FJVIkhpARsRDejEIu
         0T2E2QOXxoxS+c7x317TNe0ZYdCe78xfLjCI7leJOal3oKChOYPHXt1p86WUVh2tihvj
         s4UK6FB7vdBFGJvxzXdY42xoDfUCDZF4QK31/x/W05ZMG5pi7S0swq5clNJOCsQUUoGY
         k4Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=47vveCYCVpthvHmKjVidfRBrMv4CgoZqAi5d0tl2Cos=;
        b=OqaQEWP8sin07vAHbqv2PQHHrTmesKhtnofTgl2mYF6gH2HDyVJDXR0DxTXaH3Fbi1
         2YjzCQkV9kVaY4SVvyOLsQHXTI4bWG1vMAtsvKPSbasy+oTulL9zonpsqd9t4OhoedXf
         hUB+NA45xPnPiDGk6dPBF9fm1yYu/ohfvsFnGbCjyBzvoyGFsZASATvq5UYTMXth60+0
         FRovz9SAm0S2fDiL3DHQBrFduJ52L0bJ+5V0s6ZXm1f8+1FTBwP19K+Hdr2CHkecX12M
         n85vIzavKefPYjL3cHpd0HS0ayIV+o0saTaMc0iIaIZl1pKOuhp63RFa5T5D1rqBxlv8
         R3bg==
X-Gm-Message-State: AOAM532ryyLmWVY9QHiylQ7gdgijIs82T2GeKFWBappkHBKC/429qRFP
        v/FBYBXVtT4YRq6bQ5KqJ/89WjFsUZci5WXsMgiiGNhdzS9bXQ==
X-Google-Smtp-Source: ABdhPJzBgMlm072gAVrdjohI/+hpToRVyiTWOyroNg6+1ZV3zwU96R+xEYyces14KuflWU2B6dalESZ2SFukyhV7RZo=
X-Received: by 2002:a25:c089:: with SMTP id c131mr8115190ybf.510.1608325340765;
 Fri, 18 Dec 2020 13:02:20 -0800 (PST)
MIME-Version: 1.0
References: <20201218185032.2464558-1-jonathan.lemon@gmail.com> <20201218185032.2464558-3-jonathan.lemon@gmail.com>
In-Reply-To: <20201218185032.2464558-3-jonathan.lemon@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 18 Dec 2020 13:02:09 -0800
Message-ID: <CAEf4BzY8ePP7PoOpeU1uS1AFicGzY-w28KM2DMhjPqz4Tuh7bA@mail.gmail.com>
Subject: Re: [PATCH 2/3 v4 bpf-next] bpf: Use thread_group_leader()
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 18, 2020 at 12:47 PM Jonathan Lemon
<jonathan.lemon@gmail.com> wrote:
>
> From: Jonathan Lemon <bsd@fb.com>
>
> Instead of directly comparing task->tgid and task->pid, use the
> thread_group_leader() helper.  This helps with readability, and
> there should be no functional change.
>
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  kernel/bpf/task_iter.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
> index 8033ab19138a..dc4007f1843b 100644
> --- a/kernel/bpf/task_iter.c
> +++ b/kernel/bpf/task_iter.c
> @@ -37,7 +37,7 @@ static struct task_struct *task_seq_get_next(struct pid_namespace *ns,
>                 if (!task) {
>                         ++*tid;
>                         goto retry;
> -               } else if (skip_if_dup_files && task->tgid != task->pid &&
> +               } else if (skip_if_dup_files && !thread_group_leader(task) &&
>                            task->files == task->group_leader->files) {
>                         put_task_struct(task);
>                         task = NULL;
> --
> 2.24.1
>
