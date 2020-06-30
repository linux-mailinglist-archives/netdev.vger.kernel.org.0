Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09F3920EA8E
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 02:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgF3A6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 20:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbgF3A6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 20:58:50 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3804DC061755;
        Mon, 29 Jun 2020 17:58:50 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id h23so14446945qtr.0;
        Mon, 29 Jun 2020 17:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k8JPo/MRdDtQmsz/fwYcyAAt5f70n0S8x1+bnn70EMc=;
        b=AGCzq5ScGJKEZa0pAhrXN+4oRqcY/tDqrJNThwziEDxbIwTKX895Gmk36T/vOl77NQ
         F/Qk0MOlcMge8TzVAwmu3AkJJnWTyK3ikJtNGZD0c5i1WwYkBKyCFSpgAES/LFfbn+tZ
         jlLq1gxqBcgbS0jG41BTOZHc86faMjr/7rQi+TiWx4p4QRE74HqzZpX2B3dn62ndEBf/
         Hjjg96cPwDFItSsIRigYdUhTX2WmJJM362yfXfgJ66u6UvbHPDFpx/Q5OWC/w/WO6eXO
         yfJcoVYQQoFPUKaJFVj9BPpvmOUVRb0AsnBVPnvZT/jmAtJJ3m90tDMFySKKnUVv/fcq
         gDXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k8JPo/MRdDtQmsz/fwYcyAAt5f70n0S8x1+bnn70EMc=;
        b=BvFj9TWs+I64tu7/0tZqzoho4blxyRmuFd4vBvVDJyuacmbEYgja3f1xvSYnbSY9zM
         Wab2LehpafRI/hg+uoa6jPtVQwj9flXGSCR5izQEjUFSR5NdN0i8OjGoATPcFkrZQJ7Q
         VlKu1kdmOSlM6i9yF4MHrDB6c+W8WQtWkDlu7miG4HarQfQqfgYBXiA40kVDiM3zDUPi
         eg69x6rUEmdeSeWW3Q8NyxH32O9Yir4WG1pEtQzwVpIQ8AEeB5zAxQ1u/xzWLnsmdI8v
         iwhEU9/lYVXAR2AF3z0xVnbBiGI/QidUH36utHnh5enxNSIcyzh8qpu0yOZZIwHmrZXl
         2Wmg==
X-Gm-Message-State: AOAM532ZyLjyQcNA4yWYBSiEjwZ8n0gvq7drcVT2sLwrYpgmsL3VrJhY
        Hra3R1PU4+AVgw4LVvIJERCDHAMLnk0Y4B15D/B7g6UT
X-Google-Smtp-Source: ABdhPJyj2tlK4BHxtQNdgkkHACBQbL8CsdI8VFvbVoDT0vScG2ZadtRPa8Rf9zeoXSwgXMl/drqX2Uhtm6rPQz7jTrs=
X-Received: by 2002:ac8:1991:: with SMTP id u17mr17805577qtj.93.1593478729427;
 Mon, 29 Jun 2020 17:58:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200630003441.42616-1-alexei.starovoitov@gmail.com> <20200630003441.42616-2-alexei.starovoitov@gmail.com>
In-Reply-To: <20200630003441.42616-2-alexei.starovoitov@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 29 Jun 2020 17:58:38 -0700
Message-ID: <CAEf4BzaLJ619mcN9pBQkupkJOcFfXWiuM8oy0Qjezy65Rpd_vA@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 1/5] bpf: Remove redundant synchronize_rcu.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 5:35 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> From: Alexei Starovoitov <ast@kernel.org>
>
> bpf_free_used_maps() or close(map_fd) will trigger map_free callback.
> bpf_free_used_maps() is called after bpf prog is no longer executing:
> bpf_prog_put->call_rcu->bpf_prog_free->bpf_free_used_maps.
> Hence there is no need to call synchronize_rcu() to protect map elements.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

Seems correct. And nice that maps don't have to care about this anymore.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  kernel/bpf/arraymap.c         | 9 ---------
>  kernel/bpf/hashtab.c          | 8 +++-----
>  kernel/bpf/lpm_trie.c         | 5 -----
>  kernel/bpf/queue_stack_maps.c | 7 -------
>  kernel/bpf/reuseport_array.c  | 2 --
>  kernel/bpf/ringbuf.c          | 7 -------
>  kernel/bpf/stackmap.c         | 3 ---
>  7 files changed, 3 insertions(+), 38 deletions(-)
>
