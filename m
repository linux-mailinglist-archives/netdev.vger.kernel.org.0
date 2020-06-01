Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2775F1EB1BB
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 00:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728746AbgFAWbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 18:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbgFAWbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 18:31:17 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA9E0C061A0E;
        Mon,  1 Jun 2020 15:31:17 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id w90so9105093qtd.8;
        Mon, 01 Jun 2020 15:31:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g+bb5Fv8m97eYaCXwELhIZijqdlPHbFSsMGVucGIDBc=;
        b=ikQIObI7BsertJDB0m8+hQEyCGLVfDH25f7EeW0TAfqSqpfVvKJIG1fYlUOsVHM/8Q
         09dtGgWx4VEQsXgfH4UPtTUjRZSVqTAyb8zQNophWI2JP2PFlFrhPfKtPNiHfp7H9QPR
         +Y4DKpyzq2zyDpRNg4nO5Zo7iVZ6I5OOZBmQNbbHqPPkcizDy77xEbfRjtIeZTZ7sHkG
         172y5il3W9WxU5l+ipa+cy5KKAZkAQbOkzCLLiwViIN/zrrRrInVZ2wE+1TUYFvzwmcP
         I8Nn0aSo82Itae/bn+igJqPlu2xzgHZ/d5axWG+lsgLMo0XMmEv6QYysTanxb0Aetnyr
         ddgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g+bb5Fv8m97eYaCXwELhIZijqdlPHbFSsMGVucGIDBc=;
        b=G6LG0khofI8WMJ4oY6mr/lzcESyzqoF8kNG2sONu5QEdIIIzY649fWuy5dJD0voNCT
         zXjEbOIkra3TZIcPXSmFRKnzOZvRFEI1bwKDW+IlFqkLm8rhIW9AsdWGJjI1ebEnlVZv
         fxJEnRwozQhE/Ghk2/2FO7KJQ56XPb1krtZS6lYSIPiCFe2UL7wt6Cb/kZ/uMU1RXG4e
         FOIltWBEfCYebn1C2TihmxYlNp8lFr/huZq8jN35zK1Nobrk0/01jZao/yFPvGXR5eYZ
         raiErL6Do0Gl1HbLZIV/7AQmKrI/ukO4ZZDoSRaMzuLixyubga//KprkSwzpdhtXJ7tu
         LMuQ==
X-Gm-Message-State: AOAM533dvpPA69WzOpZrNPCWRBK+pFdZtPmy5suLZ1PtSpmbegbPrdKQ
        K2Y7Vv5Vbb5uznFoUanTv3DTeNNC1bpNsEvB6uhe/wX1
X-Google-Smtp-Source: ABdhPJwtRPd/ecs/xIqCQh7zIulmE4Egq2y0kb0QEG6UNCyXUGRoOQvw8gsWLxeDg+YdAjOYf7mIk74xAhlZcZZdBG0=
X-Received: by 2002:ac8:42ce:: with SMTP id g14mr24125771qtm.117.1591050676996;
 Mon, 01 Jun 2020 15:31:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200531082846.2117903-1-jakub@cloudflare.com> <20200531082846.2117903-6-jakub@cloudflare.com>
In-Reply-To: <20200531082846.2117903-6-jakub@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 1 Jun 2020 15:31:05 -0700
Message-ID: <CAEf4BzbRpTrbFWDRD8TfWBDO6_4jZyseX08Q8emZz4qPDA4QqA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 05/12] bpf, cgroup: Return ENOLINK for
 auto-detached links on update
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 31, 2020 at 1:29 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> Failure to update a bpf_link because it has been auto-detached by a dying
> cgroup currently results in EINVAL error, even though the arguments passed
> to bpf() syscall are not wrong.
>
> bpf_links attaching to netns in this case will return ENOLINK, which
> carries the message that the link is no longer attached to anything.
>
> Change cgroup bpf_links to do the same to keep the uAPI errors consistent.
>
> Fixes: 0c991ebc8c69 ("bpf: Implement bpf_prog replacement for an active bpf_cgroup_link")
> Suggested-by: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---

Looks good, thanks!

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  kernel/bpf/cgroup.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index 5c0e964105ac..fdf7836750a3 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -595,7 +595,7 @@ static int cgroup_bpf_replace(struct bpf_link *link, struct bpf_prog *new_prog,
>         mutex_lock(&cgroup_mutex);
>         /* link might have been auto-released by dying cgroup, so fail */
>         if (!cg_link->cgroup) {
> -               ret = -EINVAL;
> +               ret = -ENOLINK;
>                 goto out_unlock;
>         }
>         if (old_prog && link->prog != old_prog) {
> --
> 2.25.4
>
