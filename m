Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB1391DDA1F
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 00:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730510AbgEUWVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 18:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728701AbgEUWVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 18:21:43 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12878C061A0E;
        Thu, 21 May 2020 15:21:43 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id p12so6824480qtn.13;
        Thu, 21 May 2020 15:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4ExJ8zG+3yownQ1C1Z/v0GfG38lhL5koimygAjnW6Uw=;
        b=QWJmup82LzizQOUt4JscayViaZVhrY6c94Vac7XNljHRzxY0LJfzpOOoXyQV2xo66k
         1vFDxToYGVCAG3TFnbcN2Co03E0kCrB4jkiAAa/PhplAZFP3/Vo+1Q9BAr7kbZWoMDvs
         41KxPiOQ0oNHgiR7JzN8PcwiMjI6m5xqX5rtlfrZ08W7zUc1B1rj0OtXZRgKsGYKbjVe
         yMs/otjNiJ0sACVfOcnkVlEZi8GB9vx9chnbPIo2uD75wF+lAR1XzUsAwBCNd9vZfXlL
         FOEnAkLo0jrlBaQiDyD7Vh/ffG2zyro7rDARgSlv/MOR9anOjGiJJ2LvhfIAvNAH1yas
         97lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4ExJ8zG+3yownQ1C1Z/v0GfG38lhL5koimygAjnW6Uw=;
        b=RF+6efgLG5pXySh7I3Q3qZreMuNU2WJTzQwEbDGqwfVn5LJYYsJxHYr4bh/v9Xcv/x
         NNft/J10BeZkW/zJFRvoshAf3W5CNwd2PQg1rNcSlV8wkHCE8ZHgfW8AQhjn1qO9SemM
         G9THEw+gzJMq2Z70DdiXH3qTaQlb28WlznOstmAMYdvnOj/EHrVQv/byIETPcRNgGR/o
         30S34CMIXlyEjxteS1k5jAyEJNXgx7DJEOXZYGH/Q2xl+jq6bGoEoceIVHrTVZWgTZkN
         gmxB/rzKlq9lX5znXyxImDS8Idad7CU9p3VSoT+yNZAHnnqHO/dksLaS+NbDY3fBFCPE
         SGJw==
X-Gm-Message-State: AOAM532MJVOqbQU3KdefcWbmG3FfSvzWzEyWp88pNavmDehRHAMCYd9v
        PBpFhiGJ4/RGal/hGRvUrJJ6yuv2PA5P2BVBgRvfOFub
X-Google-Smtp-Source: ABdhPJy1lCmM0t3UQPWNn9quTXTER2FdLi5/36375i7MaaTW2QtmJfWBXprO5mcxN51CCU/CZGCJyI4F+p0GQe9cE3w=
X-Received: by 2002:ac8:1ae7:: with SMTP id h36mr12829406qtk.59.1590099702291;
 Thu, 21 May 2020 15:21:42 -0700 (PDT)
MIME-Version: 1.0
References: <159009128301.6313.11384218513010252427.stgit@john-Precision-5820-Tower>
In-Reply-To: <159009128301.6313.11384218513010252427.stgit@john-Precision-5820-Tower>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 21 May 2020 15:21:31 -0700
Message-ID: <CAEf4BzbZmy0A0xmHD64+G3db+4a15yXjhA8SAEebWB3iUqpJLA@mail.gmail.com>
Subject: Re: [bpf-next PATCH v2 0/4] ] verifier, improve ptr is_branch_taken logic
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 1:07 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> This series adds logic to the verifier to handle the case where a
> pointer is known to be non-null but then the verifier encountesr a
> instruction, such as 'if ptr == 0 goto X' or 'if ptr != 0 goto X',
> where the pointer is compared against 0. Because the verifier tracks
> if a pointer may be null in many cases we can improve the branch
> tracking by following the case known to be true.
>
> The first patch adds the verifier logic and patches 2-4 add the
> test cases.
>
> v1->v2: fix verifier logic to return -1 indicating both paths must
> still be walked if value is not zero. Move mark_precision skip for
> this case into caller of mark_precision to ensure mark_precision can
> still catch other misuses. And add PTR_TYPE_BTF_ID to our list of
> supported types. Finally add one more test to catch the value not
> equal zero case. Thanks to Andrii for original review.
>
> Also fixed up commit messages hopefully its better now.
>

Yeah, much better, thanks! Few typos don't count ;)

For the series:

Acked-by: Andrii Nakryiko <andriin@fb.com>

> ---
>
> John Fastabend (4):
>       bpf: verifier track null pointer branch_taken with JNE and JEQ
>       bpf: selftests, verifier case for non null pointer check branch taken
>       bpf: selftests, verifier case for non null pointer map value branch
>       bpf: selftests, add printk to test_sk_lookup_kern to encode null ptr check
>
>
>  kernel/bpf/verifier.c                              |   36 ++++++++++++++++++--
>  .../selftests/bpf/progs/test_sk_lookup_kern.c      |    1 +
>  .../testing/selftests/bpf/verifier/ref_tracking.c  |   33 ++++++++++++++++++
>  .../testing/selftests/bpf/verifier/value_or_null.c |   19 +++++++++++
>  4 files changed, 86 insertions(+), 3 deletions(-)
>
> --
> Signature
