Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDB6C4468B0
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 19:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbhKES5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 14:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbhKES5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 14:57:18 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5C30C061714;
        Fri,  5 Nov 2021 11:54:38 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id o12so25165185ybk.1;
        Fri, 05 Nov 2021 11:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OfPwx8khpfkruo5sm/keesa03eNkz1fJCURx4ZaZf88=;
        b=HJRQud+VDb5QhxdhznR7+6o6aS6p/7rz/XoO5FVQB5WUPV61cP9R7jI3GKNll1ELfb
         wJRQ5jieXF3YqNMV1QrsUxSmL/cw17a7JU8JbUjf/Y6zonc4Ydec5C2Q1e17kPUIowvX
         +XM4m5vUkLQh6hlPDPjI0tXrmO4vT6+nyR7QUB55CDKFBZwsucmkQPziY5H4uLZvo2QP
         URM79INm4uzTSo3pfIPA2qCX+GIph+HJ57y73lXKwYH9RLZqQQmMIp56aD2XH1cv/G3A
         1jOQoVLp8B2LAWDDIK2hk0ijCh7q6iw2qBZg+lDOhsMABMAg9RBTdLsuI049aTt/K9w1
         AXUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OfPwx8khpfkruo5sm/keesa03eNkz1fJCURx4ZaZf88=;
        b=cB0kUze33hK9S1vdCC/wE2l0mzpThSNX0Rlt8SLM1DTc8xUfUelamqsHQqrZhIxC8N
         lJ0P91jUuwzWCb3XU9zrCQemwWw2Qez81cWmCRaOU53w3NEvpyjzSnim0paW7eBiWcym
         Nrc8Y+oHtqFqiRPBANZEMOs62PxyoWmIhyC6UBsHRKdCkM8m2xebjvVAheO+juzObB47
         wOeyUvhb3HH2dcjAEIKiwJ3w3a2cLY0+II32YoAGmtzDd8/XEulzYT20w/i1Mh48+jVz
         oyGdJYmuAQ9efe9PuX33KT8W0QOriEZxKpAPH1ftMDijyojOi8ZNRas3lkKcJgpK3SAJ
         xBGA==
X-Gm-Message-State: AOAM531nSa962yCI41HohtvsWPLpWqAwnDMoxJQvF9aIbd6wU8kRBXPv
        ek3SIF6WnoxyLEK7CDp9icKgGwPkZNRQgsFLLcs=
X-Google-Smtp-Source: ABdhPJxb1WsvpZa4362is7/y7dGyqv18OXP0Jsm+r/VDp8slgw9XnOGTRjiFY/9rGGp6ZLyGWIWXhOwQIkQ5YnRs82E=
X-Received: by 2002:a25:d187:: with SMTP id i129mr53043971ybg.2.1636138477967;
 Fri, 05 Nov 2021 11:54:37 -0700 (PDT)
MIME-Version: 1.0
References: <1636131046-5982-1-git-send-email-alan.maguire@oracle.com> <1636131046-5982-3-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1636131046-5982-3-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 5 Nov 2021 11:54:27 -0700
Message-ID: <CAEf4BzaCmCM5zuSrtUDvR8Y+nf=3FF8+mSjQHytn=N5fBZV40w@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/2] selftests/bpf: add exception handling
 selftests for tp_bpf program
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     ardb@kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, andreyknvl@gmail.com,
        vincenzo.frascino@arm.com, Mark Rutland <mark.rutland@arm.com>,
        Sami Tolvanen <samitolvanen@google.com>, joey.gouly@arm.com,
        maz@kernel.org, daizhiyuan@phytium.com.cn, jthierry@redhat.com,
        Tian Tao <tiantao6@hisilicon.com>,
        Peter Collingbourne <pcc@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, rppt@kernel.org,
        Jisheng.Zhang@synaptics.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 5, 2021 at 10:11 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> Exception handling is triggered in BPF tracing programs when
> a NULL pointer is dereferenced; the exception handler zeroes the
> target register and execution of the BPF program progresses.
>
> To test exception handling then, we need to trigger a NULL pointer
> dereference for a field which should never be zero; if it is, the
> only explanation is the exception handler ran.  task->task_works
> is the NULL pointer chosen (for a new task from fork() no work
> is associated), and the task_works->func field should not be zero
> if task_works is non-NULL.  Test verifies task_works and
> task_works->func are 0.
>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---
>  tools/testing/selftests/bpf/prog_tests/exhandler.c | 43 ++++++++++++++++++++++
>  tools/testing/selftests/bpf/progs/exhandler_kern.c | 43 ++++++++++++++++++++++
>  2 files changed, 86 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/exhandler.c
>  create mode 100644 tools/testing/selftests/bpf/progs/exhandler_kern.c
>

The test looks good, thank you!

Acked-by: Andrii Nakryiko <andrii@kernel.org>

[...]
