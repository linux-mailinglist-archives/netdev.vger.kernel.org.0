Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43E2A46B11C
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 03:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbhLGC7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 21:59:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbhLGC7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 21:59:16 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DE75C061746;
        Mon,  6 Dec 2021 18:55:47 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id d10so37112847ybn.0;
        Mon, 06 Dec 2021 18:55:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZCtOCyGOYA2xwhMK8wszxpR3DunjyEVRQwp0RJOKkWk=;
        b=E5cDIf9yUnHBsOQ5CokB8OF/+5i0LUthk1uI208iCOl3puYNzrNd1JKp1vRaE9bgd9
         EiLqrOslz5C45cdgecnF2PBNZMP1snsRLUdtnvQY63TJ1hv3FwpjyOTIu9Vxnx0KaO4U
         dku+hhjFCdRu+N5KCn2SaF6J5hhLJowQkBHg1tgbh8cFr55a6/vdX7dPcfv3RBjZEKaD
         i9dQgzpD5PZawO921ZMlm/SzVAeW8cDFKKlPXqlODLmzA1JLAMehnv0T3DH5+Q0htReG
         XeThrcTKmpXOdEjgQ9xFdkxSYxbSFHxvpY5tlXXABeh8oewJ4/XhHo+NWGEVMZG4A2Vp
         Xjpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZCtOCyGOYA2xwhMK8wszxpR3DunjyEVRQwp0RJOKkWk=;
        b=EbpGlukcXgqM7sP/L2laDj+TgD4CwvXIpUENuXQUCOwo4AivwYabxZdhB8BCYzjJC+
         xvZkJPgLUwtsoh44YgjXxEzuqYrGgI8MlqmJmE3bX5Jjij1Evi1+QblGWAZ1bFIyc7U1
         MdqekJJ4H47AqWMUbrIA9qse2bkECsgwnbykF97PwBPjmRrO+foDxnKRNNrpqjfIg/iz
         32j0BS+IvTAubIKHlTz3vG4o7EctC83VnqDN3X1LkCFmBoaOMxZXSEGL7yHznL/pMN5b
         0DecwJglmOznR5Tere/B3bwJfsDgPpsr3sg8GBUtsCd6gj1Lro8xCoUveIOzEyoU+hRa
         8L8A==
X-Gm-Message-State: AOAM533N9Zk5SnfQhJbgFhUnEDzFuBWgThQXN+kE9NrurkQqQXeShtaZ
        XbcEKrJCpaULtBvALPHHSanGcB3A09+O8LS4CS8=
X-Google-Smtp-Source: ABdhPJyeChx9ojTWWwVGcl1nWTnkSRbhC+XsN5HsIdfgAJV6o/FFyd7RbG0wFX9J8B0emq5We8YREZjoY21K0unN0gs=
X-Received: by 2002:a25:abaa:: with SMTP id v39mr47346320ybi.367.1638845746416;
 Mon, 06 Dec 2021 18:55:46 -0800 (PST)
MIME-Version: 1.0
References: <20211130142215.1237217-1-houtao1@huawei.com> <20211130142215.1237217-4-houtao1@huawei.com>
In-Reply-To: <20211130142215.1237217-4-houtao1@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 6 Dec 2021 18:55:35 -0800
Message-ID: <CAEf4BzaODof7fHFLp79Knx4=QGMY0B3ODCnayAgOvOmWG6dr=g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/5] selftests/bpf: factor out common helpers for benchmarks
To:     Hou Tao <houtao1@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 30, 2021 at 6:07 AM Hou Tao <houtao1@huawei.com> wrote:
>
> Five helpers are factored out to reduce boilerplate for
> benchmark tests: do_getpgid(), getpgid_loop_producer(),
> assert_single_consumer(), assert_single_producer() and
> noop_consumer().
>
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---

Please drop this patch. All the stuff you are extracting into
"reusable" helpers is so trivial that it's not worth it. It just makes
it harder to follow each individual benchmark's setup.

>  tools/testing/selftests/bpf/bench.c           | 13 +++++
>  tools/testing/selftests/bpf/bench.h           | 25 +++++++++
>  .../bpf/benchs/bench_bloom_filter_map.c       | 44 ++++-----------
>  .../selftests/bpf/benchs/bench_count.c        | 14 +----
>  .../selftests/bpf/benchs/bench_rename.c       | 27 +++------
>  .../selftests/bpf/benchs/bench_ringbufs.c     |  7 +--
>  .../selftests/bpf/benchs/bench_trigger.c      | 55 +++++++------------
>  7 files changed, 81 insertions(+), 104 deletions(-)
>

[...]
