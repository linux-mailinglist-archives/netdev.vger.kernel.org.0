Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B493234F94D
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 08:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233883AbhCaGyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 02:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233905AbhCaGyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 02:54:07 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8938C061574;
        Tue, 30 Mar 2021 23:54:06 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id w8so20105516ybt.3;
        Tue, 30 Mar 2021 23:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qZ3SKuaY+ZUKX6y7erBmTFWnYGpQCsQub2RCDZGga5U=;
        b=geyO7kmocph0iXRsk2wYAghlsnGnYkewakhWdv9RM3Ci7iHpN8Zw6pOwI/R1hw9FSC
         A2n7E1Bxl7Y1lB+xkahWq97WJ65rOQFE9CRtMFL9Cjara8/0Ua8ZTlaXW9XHNfzJp0Fz
         zVx8gCUxgo5LNUqgbCuBQVbyQZX0qhWTdzwGWnkvogS6LdWc+qYWhNB99qlgkFv/TjqK
         KlstQtQWIqeNxpXBbIQGKMzY+vQkpMBX/a6yd1JHGQ04Wk1BqmflD6jW22BdjL/GGHQZ
         HG1lt8xmcMDQ4cbj8VWUfP7mihACHQEbyrhqcSshq010XudPKtqfYBEfvAAK3TEfXu6r
         L1hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qZ3SKuaY+ZUKX6y7erBmTFWnYGpQCsQub2RCDZGga5U=;
        b=Ov3V/4Uwh38iletyGf/uiChw5m3BHbXJBSMT37fScsVvlT8hlfzj2zuYiGWhXDbNLs
         UMrmWzVyKD6NeTmYgkF9UEIGWTOW5NaxOUeGRqejcp7FEBBt33dazMgwA0tuAK39KD2e
         GIHTG1szXyEW6ZKQ0itBIOF2aUmCbI3TUwGjAy8j9YpGnQBjjSjHZ2U6XI18aVxhUe4R
         2x2oNTtQWJN3pxgwBMSzak7AlNZrARITGrd+sQoKdVE4tYJ4dDL9M7s7rjCshISOa12/
         wXVzhISyho0tVHaGyXbQIvIwZ9GyanKiUFsoDN9SQIsRulCBWGvRB2oAeTxtFUR7XGUi
         BXzw==
X-Gm-Message-State: AOAM532SKJr/rwODvt9zeuqjlIhvkDthF2d/fhj/aA3deXtyG3vAQgxZ
        hM+82zffFg2+eEBTsZwkEs3GvMAxte6RsMuVr7gkZSxT
X-Google-Smtp-Source: ABdhPJzr4pOWU/8+Mpx1X7D++8c9QS82eHyWmaso7p+feT0R8sgxxeQ0IHuWjnYRWYUhecHpBGMjQ+3JeAEhKFd18dU=
X-Received: by 2002:a25:6d83:: with SMTP id i125mr2629842ybc.27.1617173646186;
 Tue, 30 Mar 2021 23:54:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210328161055.257504-1-pctammela@mojatatu.com>
In-Reply-To: <20210328161055.257504-1-pctammela@mojatatu.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 30 Mar 2021 23:53:55 -0700
Message-ID: <CAEf4BzZ+O3x9AksV6MGuicDQO+gObFCQQR7t6UK=RBhuSbOiZg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: add 'BPF_RB_MAY_WAKEUP' flag
To:     Pedro Tammela <pctammela@gmail.com>
Cc:     Pedro Tammela <pctammela@mojatatu.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Joe Stringer <joe@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>,
        Yang Li <yang.lee@linux.alibaba.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 28, 2021 at 9:11 AM Pedro Tammela <pctammela@gmail.com> wrote:
>
> The current way to provide a no-op flag to 'bpf_ringbuf_submit()',
> 'bpf_ringbuf_discard()' and 'bpf_ringbuf_output()' is to provide a '0'
> value.
>
> A '0' value might notify the consumer if it already caught up in processing,
> so let's provide a more descriptive notation for this value.
>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> ---

flags == 0 means "no extra modifiers of behavior". That's default
adaptive notification. If you want to adjust default behavior, only
then you specify non-zero flags. I don't think anyone will bother
typing BPF_RB_MAY_WAKEUP for this, nor I think it's really needed. The
documentation update is nice (if no flags are specified notification
will be sent if needed), but the new "pseudo-flag" seems like an
overkill to me.

>  include/uapi/linux/bpf.h                               | 8 ++++++++
>  tools/include/uapi/linux/bpf.h                         | 8 ++++++++
>  tools/testing/selftests/bpf/progs/ima.c                | 2 +-
>  tools/testing/selftests/bpf/progs/ringbuf_bench.c      | 2 +-
>  tools/testing/selftests/bpf/progs/test_ringbuf.c       | 2 +-
>  tools/testing/selftests/bpf/progs/test_ringbuf_multi.c | 2 +-
>  6 files changed, 20 insertions(+), 4 deletions(-)
>

[...]
