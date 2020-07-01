Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B76B2113EE
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 21:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbgGATzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 15:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725771AbgGATzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 15:55:48 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4595AC08C5C1;
        Wed,  1 Jul 2020 12:55:48 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id e13so23436237qkg.5;
        Wed, 01 Jul 2020 12:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=204Z8SCKBHDXt3DvKOYxwVxQkY6yC7+XwE10WZf+lI4=;
        b=AjW1ipIlLo42Xv7enmuMw4YS7CSvtyEnELzruW5ReDEmEFkWl8NbNVzcCAX+R25MVg
         DguGPh2fJiK82gADxXdUc+069u+cr9Z0lHd1FIt3lQTnoC1ZZ6JaZO1fBMY4we/6IwP4
         KFGCJ/ksBT1mI7GTzpcU3Ch0sklkBz/XwL2yelhyLz1H4fIr2KXQJhOjW1rPhWWW8Qhv
         0vun/3y9nVnCRZP1mNChIqLSD/Zr9vd8fboPqJW0wLvQsz1gu14YADVRIkz01jTo9Uq9
         scrLUSf9iUQlXVpwPNFQEjA53z4AsMuUAKRUOciSmfI8n22ed6XO4Hx8mGrYkiQQEDgq
         ADTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=204Z8SCKBHDXt3DvKOYxwVxQkY6yC7+XwE10WZf+lI4=;
        b=CL7LQlTzARpykMrCCJYKh5CcchpddndCrFeUhAAZ0Fhz6cvyE1eaq/hOQIosVlYTty
         xuM1O+DfPpALtXbjox375NqZJCq26AbWmn1wBPfoiUdnSnwZ3an5et0nGQvKKP3PfVy4
         01aCd7qiTKj0nlPo2Z438ooy5JKrbpqeCtgfgMiS3PXnftZnGU47H2AnLlcrbOUFlvFs
         pG82M4KIiuj6cW4Z1VLU2oZ3bROkUWbQrl0H2iCGjQFU03mJ/fAZMGWhBZx394hlD3dG
         iobS5iT6/m3GGl73Xw416vBqQhY/HjyE8DmU4m8Ni6BCZ3A3E0/qZgPmZnzDQYpk6rzQ
         PzDg==
X-Gm-Message-State: AOAM533wLFh+3LFhRq13t8AZZRYPBYs04H6nl0O5N4oluh+vgxU0dqoy
        Ci3K+RebjGcEGKMjQWsz00HQsDThEGU5KTI1cwY=
X-Google-Smtp-Source: ABdhPJz3LimDv2AYM3dSalEg8gwxtEhMHQx1NTJ66XClXOvzYp+KtDPcou9Mo2/TSWzNEJ7+dNTsgWwSSJNAF4orciM=
X-Received: by 2002:a37:270e:: with SMTP id n14mr25548495qkn.92.1593633347460;
 Wed, 01 Jul 2020 12:55:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200701194600.948847-1-kafai@fb.com> <20200701194613.949560-1-kafai@fb.com>
In-Reply-To: <20200701194613.949560-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 1 Jul 2020 12:55:36 -0700
Message-ID: <CAEf4BzYUV4ay6STtaGWQWcR1PQsD3w6HYpQjdXpSxdCOU56Gog@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] bpf: selftests: Restore netns after each test
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 1, 2020 at 12:48 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> It is common for networking tests creating its netns and making its own
> setting under this new netns (e.g. changing tcp sysctl).  If the test
> forgot to restore to the original netns, it would affect the
> result of other tests.
>
> This patch saves the original netns at the beginning and then restores it
> after every test.  Since the restore "setns()" is not expensive, it does it
> on all tests without tracking if a test has created a new netns or not.
>
> The new restore_netns() could also be done in test__end_subtest() such
> that each subtest will get an automatic netns reset.  However,
> the individual test would lose flexibility to have total control
> on netns for its own subtests.  In some cases, forcing a test to do
> unnecessary netns re-configure for each subtest is time consuming.
> e.g. In my vm, forcing netns re-configure on each subtest in sk_assign.c
> increased the runtime from 1s to 8s.  On top of that,  test_progs.c
> is also doing per-test (instead of per-subtest) cleanup for cgroup.
> Thus, this patch also does per-test restore_netns().  The only existing
> per-subtest cleanup is reset_affinity() and no test is depending on this.
> Thus, it is removed from test__end_subtest() to give a consistent
> expectation to the individual tests.  test_progs.c only ensures
> any affinity/netns/cgroup change made by an earlier test does not
> affect the following tests.
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---

LGTM, thanks.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/testing/selftests/bpf/test_progs.c | 23 +++++++++++++++++++++--
>  tools/testing/selftests/bpf/test_progs.h |  2 ++
>  2 files changed, 23 insertions(+), 2 deletions(-)
>

[...]
