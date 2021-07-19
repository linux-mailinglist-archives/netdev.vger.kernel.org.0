Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE1A3CF03D
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 01:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241517AbhGSXJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 19:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1441829AbhGSWN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 18:13:59 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E84DC0613E2;
        Mon, 19 Jul 2021 15:38:44 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id i18so30064313yba.13;
        Mon, 19 Jul 2021 15:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u/XSG6dq9OeEcEy+GhvGwryPQ+F5MJvOFL55kd1WEkw=;
        b=OS5ilh6+BPNDLSzV/Axz463Dm0cYBb8ezVU2yJDdLZuOWEkaH0olJ2N9c9A0key2Jk
         uRPhKz2eu4J+4aSDOX/CFoswVemidnU+FCyuQQWcA+U18H8rtl1QTT8/5LjUoMAX4y2p
         Dn1S+dc4fS9NSMGaWeu7o2ww+7l/Rqj+nn1QLflS5bbRnQKzVJ2OJxFZ++OQ51CP9Zb8
         eBhAbudEcs+6n9pB5pkdYNkdX8VY1V6W1FuHOrBoIId/qgK5a5Mij9yK/9SlZUDH75Rv
         Ps1rofSa4yTPl6qQgQgC/+kiCQBgoAzWih8oMu1MKhezwN9DRv2wCfkID9riQQqv98RJ
         PHrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u/XSG6dq9OeEcEy+GhvGwryPQ+F5MJvOFL55kd1WEkw=;
        b=l66/grW5pm6OT6wYhYcc+AZVgUBqKxhloGqO3O83Wg7IDKi+R00MhmZmdeTWrerreP
         r5tzyi/NrZcv7iQeePecyGU+FKanp6BSQGUOXGqLpxOJaBaG7HJf166txSNgT48Wiq+c
         4I4+B78DyGkThq2EvEZXpv5AmUNKfV1K/kDAb8WBZu3LZls7xcVkJFeviBUEaNCFbnif
         Ck2hB44xU5xbVgQmvZj0xqp7Z3V59g2V6ZtwFBPkxmk9h1hP8FvmQt6gXnkFqAKyJFvC
         JOw+DFab9BZBsqWT+SFU0urcsFveFWUhO1ddZjglS7MkbxOZyJNzcfNdeYY/kGqkWbtA
         7oDA==
X-Gm-Message-State: AOAM533YN0MMdqXF9SrDqCZNKHow0dqk/ObzxgWBIUjoHO51x+/aOK2+
        RMvpWtZla/2tdsVzPOWgZxgGZxnXvlmRhz+3XLA=
X-Google-Smtp-Source: ABdhPJxvL0X9TE5c2NqGpr/D3oSc9/WcqLpQuNzoTbeV3CrU803dXo3/4+cHEe/IAXT6uwR3bcTrtErUiiYaxs6BQME=
X-Received: by 2002:a25:1ec4:: with SMTP id e187mr33893473ybe.425.1626734323512;
 Mon, 19 Jul 2021 15:38:43 -0700 (PDT)
MIME-Version: 1.0
References: <1626730889-5658-1-git-send-email-alan.maguire@oracle.com> <1626730889-5658-2-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1626730889-5658-2-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 19 Jul 2021 15:38:32 -0700
Message-ID: <CAEf4BzYUf_zgmJQ_3z=oYAiGOypYsAhvoaePQMB34P==4EOLbg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] libbpf: avoid use of __int128 in typed dump display
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Bill Wendling <morbo@google.com>,
        Shuah Khan <shuah@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 19, 2021 at 2:41 PM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> __int128 is not supported for some 32-bit platforms (arm and i386).
> __int128 was used in carrying out computations on bitfields which
> aid display, but the same calculations could be done with __u64
> with the small effect of not supporting 128-bit bitfields.
>
> With these changes, a big-endian issue with casting 128-bit integers
> to 64-bit for enum bitfields is solved also, as we now use 64-bit
> integers for bitfield calculations.
>
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---

Changes look good to me, thanks. But they didn't appear in patchworks
yet so I can't easily test and apply them. It might be because of
patchworks delay or due to a very long CC list. Try trimming the cc
list down and re-submit?

Also, while I agree that supporting 128-bit bitfields isn't important,
I wonder if we should warn/error on that (instead of shifting by
negative amount and reporting some garbage value), what do you think?
Is there one place in the code where we can error out early if the
type actually has bitfield with > 64 bits? I'd prefer to keep
btf_dump_bitfield_get_data() itself non-failing though.


>  tools/lib/bpf/btf_dump.c | 62 +++++++++++++++++++++++++++---------------------
>  1 file changed, 35 insertions(+), 27 deletions(-)
>

[...]
