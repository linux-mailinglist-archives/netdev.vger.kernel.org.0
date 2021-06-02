Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7F9A399513
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 23:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbhFBVFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 17:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbhFBVFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 17:05:15 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE83C06174A;
        Wed,  2 Jun 2021 14:03:31 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id g38so5701076ybi.12;
        Wed, 02 Jun 2021 14:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uU7aLR/xeMz6rilKfBPme4Le2hgzvGNI13F4vfMfQk4=;
        b=Nh/x2Ghu13c9wGtwUlOKUoBCbXlpDbjSZ0xtSvXCROwUl6lY2vlFOCOwyR7I/kVtL5
         yJaIaADjvuy5/yHzGK0jzkjrV6icqLEZhgjhUrGgv1xMa7wBlnw2LrbveQbLx64Kylnl
         TEPlx6x8EEpBSRhZ/zD0tBRuWjrsu5jV1LMB5JXNjPg0dypF/dAvchl/6soVkQNiVee1
         r6Xy7RRGHxhvJqzqjUi7v5rIvZWT/JTX5757wf6MpDLcx7VAfNPew8+1hnVdQ1Pg9b/R
         6HGPUOrRZXvbgFVW3DLKq0vCXlKehOf4L9XKQ4ZewK4+0LB4f18Hrg6QLTOIF/re03zI
         N9jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uU7aLR/xeMz6rilKfBPme4Le2hgzvGNI13F4vfMfQk4=;
        b=CtO6Nght3xSLl9/fValkKJ6pG31m7KxHuxoyvvREFh+NQZxkdx9ZfOywvp1nnl17Rx
         9B6wRLMrziPdlBFpXd8axRe+VSS6Y/Gif+U3fvnVsjUQ7LfkX8C4/Tuz1ynM01aeCWLS
         0wukXLcAvJPz8Sq/WJv1nU1TFp5VmFd/JUSCl6o3DIpEtxlu/V+QHMKypjWqAhUIVp9s
         UJDc9+iFT+Yfv13w7nUWVyyhF8zCBxOD133HHQcBb4Co9eFGY9DHJLc6px3ohU8pwyF0
         HPMlOx16U9VXqGWcVrldZEJ7MNocEqUdn3E8M2GpaBt/oRLY5HIHPpzYqvkjqHxUSU5n
         bI0A==
X-Gm-Message-State: AOAM530AJ1G+EDgRh3gtryjLtG6bmw0SfGdNNA0f9+jGuhANP1Kr/AfZ
        NXRO0LSy6wCDUDnqxyhZ5B5nher3LByw+SulPxg=
X-Google-Smtp-Source: ABdhPJwVNWhv0oEXlijxiU11L9rrHDgHvdd6ZEt14HvOuDwN4H0g/TAdLPpgd864ZhzxYLBOnUVj6uHwjfpJ2dA964M=
X-Received: by 2002:a5b:f05:: with SMTP id x5mr48877647ybr.425.1622667811282;
 Wed, 02 Jun 2021 14:03:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210528195946.2375109-1-memxor@gmail.com> <20210528195946.2375109-7-memxor@gmail.com>
In-Reply-To: <20210528195946.2375109-7-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 2 Jun 2021 14:03:19 -0700
Message-ID: <CAEf4BzZP-2U25dOQvPbMtF7A1KXw5DEs9FjmCyW8BCJAcCF46Q@mail.gmail.com>
Subject: Re: [PATCH RFC bpf-next 6/7] libbpf: add bpf_link based TC-BPF
 management API
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Joe Stringer <joe@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 28, 2021 at 1:01 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> This adds userspace TC-BPF management API based on bpf_link.
>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  tools/lib/bpf/bpf.c      |  5 ++++
>  tools/lib/bpf/bpf.h      |  8 +++++-
>  tools/lib/bpf/libbpf.c   | 59 ++++++++++++++++++++++++++++++++++++++--
>  tools/lib/bpf/libbpf.h   | 17 ++++++++++++
>  tools/lib/bpf/libbpf.map |  1 +
>  tools/lib/bpf/netlink.c  |  5 ++--
>  tools/lib/bpf/netlink.h  |  8 ++++++
>  7 files changed, 98 insertions(+), 5 deletions(-)
>  create mode 100644 tools/lib/bpf/netlink.h
>
> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index 86dcac44f32f..ab2e2e9ccc5e 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -28,6 +28,7 @@
>  #include <asm/unistd.h>
>  #include <errno.h>
>  #include <linux/bpf.h>
> +#include <arpa/inet.h>
>  #include "bpf.h"
>  #include "libbpf.h"
>  #include "libbpf_internal.h"
> @@ -692,6 +693,10 @@ int bpf_link_create(int prog_fd, int target_fd,
>         attr.link_create.target_fd = target_fd;
>         attr.link_create.attach_type = attach_type;
>         attr.link_create.flags = OPTS_GET(opts, flags, 0);
> +       attr.link_create.tc.parent = OPTS_GET(opts, tc.parent, 0);
> +       attr.link_create.tc.handle = OPTS_GET(opts, tc.handle, 0);
> +       attr.link_create.tc.priority = OPTS_GET(opts, tc.priority, 0);
> +       attr.link_create.tc.gen_flags = OPTS_GET(opts, tc.gen_flags, 0);

you can't do filling out link_create.tc unless you know it's TC
bpf_link that is being created, right? link_create.tc is part of a
union, so you might be overwriting bpf_iter link data, for instance.


>
>         if (iter_info_len) {
>                 attr.link_create.iter_info =

[...]
