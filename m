Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9BC2049D1
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 08:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730669AbgFWGXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 02:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730395AbgFWGXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 02:23:41 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2FE3C061573;
        Mon, 22 Jun 2020 23:23:41 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id g13so4216205qtv.8;
        Mon, 22 Jun 2020 23:23:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=olzpN9gUdjpLZ+I1YPrEhXflXcShM1HKbIaLXKany2c=;
        b=hZ5vHn9Qe+irkXPEycJ4i211GWfYgIRTgU/+fD4LNL6RSMiKiTmREbDgzsp5ToBihK
         VOmm+CVhteijJx6g1CGeSwt4NhzE3XYXPJ4bUdBjUxucYOQpb2ULiII7DbLVrcaOQooL
         GvCHCVa5dN+33aUbF3fwhC4NwnzE7T7RSxSskLxiCvvN2QkNS+GuDIj20yiT/JHOucK+
         s8/qyigF011/20DkWMI8dBn+Dhz5tmBf4iF5Lmql4Q7bBqxHxP1bzE4g7P/BaJBF8FDc
         lOlqPX85D25Sidgh94FMx/00Q9VCZpm5Q3VYJ3Yd198fH589dnoTYmAmpAYW81Ogws3O
         G63Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=olzpN9gUdjpLZ+I1YPrEhXflXcShM1HKbIaLXKany2c=;
        b=nCy/Bc2YR2qUTjoXEwFCLcJ+C+W9hHvTf1wHYUwejxVaXTVFyNzEa6/jlGFB7cGPID
         Gf5MPvWCS5WIovZNNVx36+m9l3BmVzxgFpBCuYdByoD90F6sgXgbzxg7BNqi1IpnAHA3
         6fsD65hjcmpdz7EFCQPnfYSEHMuXLZmDsTBaD3CKrWnroffS3EE2jkbxzppz3zqTv8rz
         ZLy2BHLOlsP9dlO7UXNyKgtwLld/6b+CFstd8nyb40DaLVwcAZoTYmxx1XfM6IFkl5Lb
         UtEvYjKppf8RtSiuy0DwI6hrzyXnigZHFg+14lOLBEO28IyN826Qs8JJg74vGmqFsdm6
         td1A==
X-Gm-Message-State: AOAM5325Vt5dfGqvGs6LTIuuV4u5ET+AR7dH3jqpLYdafzrAhDex2smI
        AVmmkwzx2lgWVssT0WZX3uzJgF3VjS02KyxBghGlwA==
X-Google-Smtp-Source: ABdhPJwXFopE4UQRIULHIqzQsjZ35VZnEDjhoZJbUKgIte/BZsSoWC/GjC09mK73lm/jXqyJD+j29o0eXZ0JKBrSDaM=
X-Received: by 2002:ac8:2bba:: with SMTP id m55mr19811610qtm.171.1592893420920;
 Mon, 22 Jun 2020 23:23:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200622160300.636567-1-jakub@cloudflare.com> <20200622160300.636567-3-jakub@cloudflare.com>
In-Reply-To: <20200622160300.636567-3-jakub@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 22 Jun 2020 23:23:30 -0700
Message-ID: <CAEf4BzYY8NcmprF-V3SxBgiF0mqNpK-qrymt=wvz6iCON=geiw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/3] bpf, netns: Keep attached programs in bpf_prog_array
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 22, 2020 at 9:04 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> Prepare for having multi-prog attachments for new netns attach types by
> storing programs to run in a bpf_prog_array, which is well suited for
> iterating over programs and running them in sequence.
>
> Because bpf_prog_array is dynamically resized, after this change a
> potentially blocking memory allocation in bpf(PROG_QUERY) callback can
> happen, in order to collect program IDs before copying the values to
> user-space supplied buffer. This forces us to adapt how we protect access
> to the attached program in the callback. As bpf_prog_array_copy_to_user()
> helper can sleep, we switch from an RCU read lock to holding a mutex that
> serializes updaters.
>
> To handle bpf(PROG_ATTACH) scenario when we are replacing an already
> attached program, we introduce a new bpf_prog_array helper called
> bpf_prog_array_replace_item that will exchange the old program with a new
> one. bpf-cgroup does away with such helper by computing an index into the
> array based on program position in an external list of attached
> programs/links. Such approach seems fragile, however, when dummy progs can
> be left in the array after a memory allocation failure on link release.

bpf-cgroup can have the same BPF program present multiple times in the
effective prog array due to inheritance. It also has strict
guarantee/requirement about relative order of programs in parent
cgroup vs child cgroups. For such cases, replacing a BPF program based
on its pointer is not going to work correctly.

We do need to make sure that cgroup detachment never fails by falling
back to replacing BPF prog with dummy prog, though. If you are
interested in a challenge, you are very welcome to do that! :)

>
> No functional changes intended.
>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  include/linux/bpf.h        |   3 +
>  include/net/netns/bpf.h    |   5 +-
>  kernel/bpf/core.c          |  19 +++--
>  kernel/bpf/net_namespace.c | 137 +++++++++++++++++++++++++++----------
>  net/core/flow_dissector.c  |  21 +++---
>  5 files changed, 131 insertions(+), 54 deletions(-)
>

[...]

> +
> +void bpf_prog_array_delete_safe(struct bpf_prog_array *array,
> +                               struct bpf_prog *old_prog)
> +{
> +       bpf_prog_array_replace_item(array, old_prog, &dummy_bpf_prog.prog);

nit: (void) cast to show we don't care about return code?

[...]
