Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C43C216165
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 00:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgGFWSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 18:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726583AbgGFWSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 18:18:09 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE16FC061755;
        Mon,  6 Jul 2020 15:18:08 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id b4so36371843qkn.11;
        Mon, 06 Jul 2020 15:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BAKFmZIs1G8CtS7wHOv+MKY/i5HK754lis1gMlux8dg=;
        b=eYsAlaKs4wLd8NNHQicr6SHL7gZHeNmIGGIq3mhLQYLEClWclb+hXlgcvyQ0jK0RPx
         wUAo+rswEAUonsS04Y2PdQ54ofwloXf9k0mc+VTDPzHJmrE52Zmw9uidqfTU7yJ1kEYH
         eKY4MMsJU05dHMyduQPBqC6QGLf4Les4QXDsrVB2l5nyigFo/q/EKVUMKNxJZCRhtN+J
         M5VjNK++Lmx0yH8/zYW2aeOVMtJQAEV6ttdGdX5S8/J4ntFQq9Jrh9v9+zU1mom7IRJQ
         ybXffiBKVU/QA+OiZK4vlNWbCkMr+PrFXF/udeMEE9oiqHl2fuUnU/YqDfcUUn4yhSs6
         jXGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BAKFmZIs1G8CtS7wHOv+MKY/i5HK754lis1gMlux8dg=;
        b=Lqls8uPRrVP/yb2SqsnqD6Wv0Y+T6MJF2ETNo6rcUmguFbLPcbEvv5g61Bcdb5youU
         ADawUik8t6SmOjEbk4W7/Ty7S3nbh0GLifv5yiByEx2mMi60nZsjkzK+wcWDxmXQnZ1R
         4liNR1YvsMEz/itSnyE1lJmY+hfDVBT2iVEqIL/HtCjwqObIKe5xEdt1bTqQR8DzbJAT
         FyZEnpTXC+QO48mI6FZrYWKf+yxhdP2TzW9DeSppEtZm2AbCljEaBhec6yhw0kjRWkKy
         LpSFz7HRTnYilyHgIeA30q4MfsN6zzXdHAvsn+r9eWP/BxN2ZiUM03kDqxQaXImJGunh
         IbSQ==
X-Gm-Message-State: AOAM5307Jxy+8aCEQf1UZo9a0/AMr6QxrTbWSWNBq2lLks7fZOPlwf4P
        o0kbCw6XXiC/UWqGnMl9rOKZdV5tv63NTmIUNw0AYA4z
X-Google-Smtp-Source: ABdhPJxKOC8A13HZEDlQ878ADrOy3eAA5+QZcmuP48JPxVLjR4wDcsMcgWbmSJvgOypelf2HbEzzDyAUpDhfi3gwPpQ=
X-Received: by 2002:a37:270e:: with SMTP id n14mr47279362qkn.92.1594073888185;
 Mon, 06 Jul 2020 15:18:08 -0700 (PDT)
MIME-Version: 1.0
References: <159405478968.1091613.16934652228902650021.stgit@firesoul> <159405481655.1091613.6475075949369245359.stgit@firesoul>
In-Reply-To: <159405481655.1091613.6475075949369245359.stgit@firesoul>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 6 Jul 2020 15:17:57 -0700
Message-ID: <CAEf4BzZ=v1fMxfxP9XdtEOmQV97XdwJ+Ago++VyVN19-TmeF3A@mail.gmail.com>
Subject: Re: [PATCH bpf-next V2 2/2] selftests/bpf: test_progs avoid minus
 shell exit codes
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>, Hangbin Liu <haliu@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Veronika Kabatova <vkabatov@redhat.com>,
        Jiri Benc <jbenc@redhat.com>, Yonghong Song <yhs@fb.com>,
        Martin Lau <kafai@fb.com>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 6, 2020 at 10:00 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> There are a number of places in test_progs that use minus-1 as the argument
> to exit(). This improper use as a process exit status is masked to be a
> number between 0 and 255 as defined in man exit(3).

nit: I wouldn't call it improper use, as it's a well defined behavior
(lower byte of returned integer).

>
> This patch use two different positive exit codes instead, to allow a shell

typo: uses

> script to tell the two error cases apart.
>
> Fixes: fd27b1835e70 ("selftests/bpf: Reset process and thread affinity after each test/sub-test")
> Fixes: 811d7e375d08 ("bpf: selftests: Restore netns after each test")
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  tools/testing/selftests/bpf/test_progs.c |   12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
> index e8f7cd5dbae4..50803b080593 100644
> --- a/tools/testing/selftests/bpf/test_progs.c
> +++ b/tools/testing/selftests/bpf/test_progs.c
> @@ -12,7 +12,9 @@
>  #include <string.h>
>  #include <execinfo.h> /* backtrace */
>
> -#define EXIT_NO_TEST 2
> +#define EXIT_NO_TEST           2
> +#define EXIT_ERR_NETNS         3
> +#define EXIT_ERR_RESET_AFFINITY        4

Let's not overdo this with too granular error codes? All of those seem
to be just a failure, is there any practical need to differentiate
between NETNS vs RESET_AFFINITY failure?

I'd go with 3 values:

1 - at least one test failed
2 - no tests were selected
3 - "infra" (not a test-specific failure) error (like netns or affinity failed).

Thoughts?


[...]
