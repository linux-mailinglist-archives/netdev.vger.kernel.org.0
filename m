Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5C1A1DA334
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 23:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgESVIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 17:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725998AbgESVIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 17:08:39 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3470BC08C5C0;
        Tue, 19 May 2020 14:08:38 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id ci21so213959pjb.3;
        Tue, 19 May 2020 14:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1TvuyYgl/pm4FrzfOZgJIZd2F9r8nmDKxF1tL9hcxOM=;
        b=CGGi/qTDb6uu8NLb7YrJi1BtkEu+qOdPcZWlJ4hKivKyw50AzeM7bUYPZA9aokn3CR
         8EQcBhUCIbbi+xejP8cpwaieT8JPWuDO6OZQ3Ofqj+jZNdOueXusQszq9ktpTolB6knU
         FMyk+Uk17pTnEYabXh/pUZo3Ad3fvYU+NKRa/Ymhhw1pM+MBBPnA6rikm3J80tKx2uSj
         7qtgfY3cYE0t1WvEsWoxrVAZsgE1rO/jomHeHGS4V3LkTym3+fxrgpoBZpl28NxZ9t8Y
         GtknOUnUZ9D7mhCvjkMQsclJKupvxF0Hi+mExeARP3D1eWC4lX8tl7AefcbKN5AhgAKe
         Diaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1TvuyYgl/pm4FrzfOZgJIZd2F9r8nmDKxF1tL9hcxOM=;
        b=F2ExmaUtmWfRLRaXv64ZCSJuQGJwlBAX95hjzAFqSZwnA3hCZhMi42tpb16cL7fb7W
         ESP4XKrO5wxnxgbORd1xi2ppxrAlL3+psmIBwHwU9+WQgFDX6T/2W6bq1e+dV1cLGWo2
         KSuk5ph5+Kn9XAHogXQ0brNp5i0ro8DsF6Dpe4o5e52ojAY9aokKwNcsUdvK1jgWUxKM
         V0RZn+ZxK5ljeD8Prtm3xi28bTGH0qbvHLtY2Xba9Hca7ROqKsgM7IFOu3KkSblYti2Z
         jbKpsr44KxchLVrWodBjisqPPYYPhpz3alFyptvPe9X7pmUTCrFzV/SxDu4jhm+UULxH
         e5Ew==
X-Gm-Message-State: AOAM531htdp8awml76xxpWkH4AFduaU8iWozxbzueziQn/16tSNr2ZmH
        5s/ERD6xIIHTVP1gejAMmrk=
X-Google-Smtp-Source: ABdhPJxfR7s2AE3UGiAtXDpeOiSxY1VNpzzoJ7hCBzxxoPukRG4OI7BhM+8fSW7f3dH7a/2rYNLzUA==
X-Received: by 2002:a17:90a:fb8e:: with SMTP id cp14mr1475305pjb.56.1589922517662;
        Tue, 19 May 2020 14:08:37 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:8135])
        by smtp.gmail.com with ESMTPSA id u17sm287924pgo.90.2020.05.19.14.08.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 14:08:36 -0700 (PDT)
Date:   Tue, 19 May 2020 14:08:34 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH bpf-next] selftests/bpf: convert
 bpf_iter_test_kern{3,4}.c to define own bpf_iter_meta
Message-ID: <20200519210834.qwfrhq2ixgy6l3oy@ast-mbp.dhcp.thefacebook.com>
References: <20200519192341.134360-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200519192341.134360-1-andriin@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 19, 2020 at 12:23:41PM -0700, Andrii Nakryiko wrote:
> b9f4c01f3e0b ("selftest/bpf: Make bpf_iter selftest compilable against old vmlinux.h")
> missed the fact that bpf_iter_test_kern{3,4}.c are not just including
> bpf_iter_test_kern_common.h and need similar bpf_iter_meta re-definition
> explicitly.
> 
> Fixes: b9f4c01f3e0b ("selftest/bpf: Make bpf_iter selftest compilable against old vmlinux.h")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  .../selftests/bpf/progs/bpf_iter_test_kern3.c     | 15 +++++++++++++++
>  .../selftests/bpf/progs/bpf_iter_test_kern4.c     | 15 +++++++++++++++
>  2 files changed, 30 insertions(+)
> 
> diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_test_kern3.c b/tools/testing/selftests/bpf/progs/bpf_iter_test_kern3.c
> index 636a00fa074d..13c2c90c835f 100644
> --- a/tools/testing/selftests/bpf/progs/bpf_iter_test_kern3.c
> +++ b/tools/testing/selftests/bpf/progs/bpf_iter_test_kern3.c
> @@ -1,10 +1,25 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /* Copyright (c) 2020 Facebook */
> +#define bpf_iter_meta bpf_iter_meta___not_used
> +#define bpf_iter__task bpf_iter__task___not_used
>  #include "vmlinux.h"
> +#undef bpf_iter_meta
> +#undef bpf_iter__task
>  #include <bpf/bpf_helpers.h>
>  
>  char _license[] SEC("license") = "GPL";
>  
> +struct bpf_iter_meta {
> +	struct seq_file *seq;
> +	__u64 session_id;
> +	__u64 seq_num;
> +} __attribute__((preserve_access_index));
> +
> +struct bpf_iter__task {
> +	struct bpf_iter_meta *meta;
> +	struct task_struct *task;
> +} __attribute__((preserve_access_index));

Applied, but I was wondering whether all these structs can be placed
in a single header file like bpf_iters.h ?
struct bpf_iter_meta is common across all of them.
What if next iter patch changes the name in there?
We'd need to patch 10 tests? It's unstable api, so it's fine,
but considering the churn it seems common header would be good.
That .h would include struct bpf_iter__bpf_map, bpf_iter__task,
bpf_iter__task_file, etc
wdyt?
