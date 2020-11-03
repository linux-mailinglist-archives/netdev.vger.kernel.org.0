Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94C5D2A4F1B
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 19:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728471AbgKCSlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 13:41:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbgKCSlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 13:41:04 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA41C0613D1;
        Tue,  3 Nov 2020 10:41:04 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id b138so15720529yba.5;
        Tue, 03 Nov 2020 10:41:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PHtbkDaFpmjOguwR6Xzv6Zd2CD3JNPGfIdYHddxRRoM=;
        b=lzvogpoyyfcIoiOMFli8IZjh3b+/qv8Y2X6Khkk9LLzQhwxy1nRqCMEgRcBruGrvU/
         XMlI9DbF4oFcsisUdrxEoBe/r2Zmnqe9+OvLOR42neueGwcj/kuu0fpIGiL0TD6XsOeU
         GubhediEA43wxbRyeW0uhqAdKu43oy34Qr3v0p8qbRKA6ehqsAJjnw9VEY0mtJOK6O0n
         /BZbfx4ePmj4p2+tg53y3o7z9BtJv9jMXXCogVgrzJDuOyKER0Kp0RjgqzBplGDDj0ig
         F1B2JlVJMJ18/Ct7ES96VR/E6OeWzD94D3R0AZ7iruw0ctq8o5gtirjitChWX+BISe/j
         i3Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PHtbkDaFpmjOguwR6Xzv6Zd2CD3JNPGfIdYHddxRRoM=;
        b=lzMbtCyx5PxwxWp/XkesIHpFwWsVjxyQokPpfHNrTe8GMkY6+8yIM2+TS3s+ZHCHoU
         n3ju6Ie82OLqFbvumE8sRcyZnGgnYUJj2GP/Bc8vShonvgqAnfeX8C8VQFTOIKq6SbvB
         S6ojOKOpkM6SPQ0rreAygrrYxyhn1cpwARLrcBmyzSXKbNHyQkSJyl95msEAeOsgaF7n
         hgDsXKM+4dtrqzaU7YTDIjODvBWpMP9USzbEfAPKcEQyxdQ0cml8C8zGp5R32LAFTmvI
         hE5QU8yUOCml3Mq+pztLu/MA2AcnCAcSCKcSjsqJLu/JCD16YvO57q6NVp9gez4hFIqj
         1l1w==
X-Gm-Message-State: AOAM531wltpuEuTf7ilJAcE46yI2jTgWgC+CTmzyLzT5P0qMz1WAH94O
        MF2t7FjsnoljkrxRbMKzGm+au5Z2UGm9kzLTG/YOezK+y+s=
X-Google-Smtp-Source: ABdhPJzlLRKwEnltNFB6LjjkczNazIf0yGySf0sYQJmb07rwpLMPZ+pENHzv91Ptocu8SmqV+n/4rjTk0t7a52U4nTY=
X-Received: by 2002:a25:c001:: with SMTP id c1mr28523174ybf.27.1604428863522;
 Tue, 03 Nov 2020 10:41:03 -0800 (PST)
MIME-Version: 1.0
References: <160416890683.710453.7723265174628409401.stgit@localhost.localdomain>
 <160417035730.2823.6697632421519908152.stgit@localhost.localdomain>
In-Reply-To: <160417035730.2823.6697632421519908152.stgit@localhost.localdomain>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 3 Nov 2020 10:40:52 -0800
Message-ID: <CAEf4BzYAYsnM6yoYgx7cr0DSRdks=KiPhY-cBKGyi4P1CQUA7A@mail.gmail.com>
Subject: Re: [bpf-next PATCH v2 5/5] selftest/bpf: Use global variables
 instead of maps for test_tcpbpf_kern
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Lawrence Brakmo <brakmo@fb.com>, alexanderduyck@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 31, 2020 at 11:52 AM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> From: Alexander Duyck <alexanderduyck@fb.com>
>
> Use global variables instead of global_map and sockopt_results_map to track
> test data. Doing this greatly simplifies the code as there is not need to
> take the extra steps of updating the maps or looking up elements.
>
> Suggested-by: Martin KaFai Lau <kafai@fb.com>
> Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
> ---
>  .../testing/selftests/bpf/prog_tests/tcpbpf_user.c |   53 ++++--------
>  .../testing/selftests/bpf/progs/test_tcpbpf_kern.c |   86 +++-----------------
>  tools/testing/selftests/bpf/test_tcpbpf.h          |    2
>  3 files changed, 31 insertions(+), 110 deletions(-)

[...]

> -}
> -
> +struct tcpbpf_globals global = { 0 };

nit: = {0} notation is misleading, just = {}; is equivalent and IMO better.

But don't bother if it's the only change you need to do for the next version.

>  int _version SEC("version") = 1;
>

[...]
