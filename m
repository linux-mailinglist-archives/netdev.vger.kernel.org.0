Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBEAF34A0AC
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 05:47:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbhCZEob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 00:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbhCZEn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 00:43:56 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FDABC06174A;
        Thu, 25 Mar 2021 21:43:56 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id x189so4618408ybg.5;
        Thu, 25 Mar 2021 21:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Sw9BDf+hR43G+R1lh14tnMhWbnTkjTfdJgCPvhzZ4o8=;
        b=iyK9uYmhxkjHoIov7qtMNmCgyPrxsoPlhAg6TDjRV08uQXBFxP1AXs2MdEkwibhfEW
         S22koi0Pf8++J+GztsNU/n7G6ppTTLcqEWFwdJx5FF/aEe1GjPbT+Lc2bCQokij5dkBJ
         OWxkjrfQGRB2w76dzlF6M5+4PAJEtFxVWlcBVPNqYB2V2larGRCfOHt3dNnzlhzR7sMF
         4+ElbL1BXSgUADIMcmKn3M1p1eYuH2XnbIOBcXv5xitFq+jmdrdzt5jYN8KWW3ayfyvq
         PXr8k19LKsw9ILYEXYJ2cVFTgf26UE0U0STifbnInvMFelRtvIz19SnMcfmWea7ZVtHc
         vfdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Sw9BDf+hR43G+R1lh14tnMhWbnTkjTfdJgCPvhzZ4o8=;
        b=Bv5Sw8QrTjnqUJLg5W27VHevws2jU4aDqGt9VgYveSLvfBBF4v7DTfTQ0BKm82htsQ
         MDjTtv367mwAL3LI8Te4/vzVcxL657uHuoIY1mtJ+6WAcbFy8IzjcByvXQZAjoiwUN5V
         Vt/rURc4xf/4hWTVk2S7PH5xUlnyN303IJoiwTl5YUmJRldPygy7cKLzSgI0J0A/bk12
         3pjJB+hb88NROsg/3dXUT9flKU6FPSf0bUKDvnXEt8uRHOHq4vtUFLJ6B9QN0MDBAgVc
         sAxfn3esu3I0RFLI3nZLi2LEMi3u5I3OjL/wcs9i86/dBnO7QWOlN+C1IKsAHi/LaPCx
         sNUg==
X-Gm-Message-State: AOAM532zMIV4WSCVwbGj0at4GpO6rHtBhUakRLTY+yfExdkJoQobLH0o
        7ok80s9Of5tOOHcDWdNLbpwZspuorNJompf8PHU=
X-Google-Smtp-Source: ABdhPJzSBa1oJZ2rP+wsQPyWurp+ReZ2TejZxyGBO5aN/eKS95vA3LAxneznOZXzc8pcYnesGEkoiQyng1cz/n5DGl0=
X-Received: by 2002:a25:ab03:: with SMTP id u3mr10728317ybi.347.1616733835474;
 Thu, 25 Mar 2021 21:43:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210325152146.188654-1-lmb@cloudflare.com>
In-Reply-To: <20210325152146.188654-1-lmb@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 25 Mar 2021 21:43:44 -0700
Message-ID: <CAEf4BzbC75N2xHW0kB76AZCbnD+01LA5T+tn4XfBPL=b=xNS4A@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: link: refuse non-zero file_flags in BPF_OBJ_GET
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 8:22 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> Invoking BPF_OBJ_GET on a pinned bpf_link checks the path access
> permissions based on file_flags, but the returned fd ignores flags.
> This means that any user can acquire a "read-write" fd for a pinned
> link with mode 0664 by invoking BPF_OBJ_GET with BPF_F_RDONLY in
> file_flags. The fd can be used to invoke BPF_LINK_DETACH, etc.
>
> Fix this by refusing non-zero flags in BPF_OBJ_GET. Since zero flags
> imply O_RDWR this requires users to have read-write access to the
> pinned file, which matches the behaviour of the link primitive.
>
> libbpf doesn't expose a way to set file_flags for links, so this
> change is unlikely to break users.
>
> Fixes: 70ed506c3bbc ("bpf: Introduce pinnable bpf_link abstraction")
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---

Makes sense, but see below about details.

Also, should we do the same for BPF programs as well? I guess they
don't have a "write operation", once loaded, but still...

>  kernel/bpf/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
> index 1576ff331ee4..2f9e8115ad58 100644
> --- a/kernel/bpf/inode.c
> +++ b/kernel/bpf/inode.c
> @@ -547,7 +547,7 @@ int bpf_obj_get_user(const char __user *pathname, int flags)
>         else if (type == BPF_TYPE_MAP)
>                 ret = bpf_map_new_fd(raw, f_flags);
>         else if (type == BPF_TYPE_LINK)
> -               ret = bpf_link_new_fd(raw);
> +               ret = (flags) ? -EINVAL : bpf_link_new_fd(raw);

nit: unnecessary ()


I wonder if EACCESS would make more sense here? And check f_flags, not flags:

if (f_flags != O_RDWR)
    ret = -EACCESS;
else
    ret = bpf_link_new_fd(raw);

?

>         else
>                 return -ENOENT;
>
> --
> 2.27.0
>
