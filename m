Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3E3C4380C8
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 01:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbhJVX7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 19:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbhJVX7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 19:59:45 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7A7C061764;
        Fri, 22 Oct 2021 16:57:27 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id v200so10401854ybe.11;
        Fri, 22 Oct 2021 16:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E1hJFb0a/JTLxp+/u2xdeMRkqcRPUQ8kWdEcMjBaLu0=;
        b=HjmIEpXQVLnoDaOc2kFmD7nD+1JYk0TyNPiyLLfHpFSlnJQEqWRuXJup+W2YVm8C7+
         eJyaquRypBHTmpfIwHThaHiGfiijkNJaGW/PKzI0lpxTg0fZBdodf9RIrDQ/bRNJHcww
         dTyZL9EOpkNq3+Z8zhv9sPI/x0MDAASLJToC89aTI6jgqRSDeojtNYuSKFshfuwLdlMz
         EYinEhgvZexBiyFhY9AQL3orW+3J2TE8ULD9ukuU9xDCAhr9dg8Pb8kfvHbf/B9ox6+D
         dCO+ae285aMHe6w43C5MnYWNEsf4wPjPV8PfQ/m5J3JC3Z0T7h/ZFlBNvm+sZxb5Fa1y
         dubg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E1hJFb0a/JTLxp+/u2xdeMRkqcRPUQ8kWdEcMjBaLu0=;
        b=hmAqI0/04tALj4O8VbRMZTfVTI1XCbuW6SckADw5QftjI5v9fV2jpByFdL6cLuKw7c
         BbeUjr7e00Ja83MMzjgYnzfpkO6jE5Cj7irJiMF9aNx6NTuvqQbeTXzDQWEsT3xtJHu8
         XgTd+n28AS91b2glw9z1I9te2AA9c9lFFhnSeCrnjf/AikXUi6R6KRexR403VSEvf7aR
         DnqvMsSb/Fy4DxUEAwpJYC84PSAWT8PJlRY5/pqG+qGUv91/4oB8Kn8vt+frQjgvV94w
         Vg74bCEO8Xl1fLaDHTyHfqmPRShd/WttWKQBf+N4arGy/SU9iuaxs6six2n+seHGnZjU
         2fmQ==
X-Gm-Message-State: AOAM531a2IQQytKWB9j1H8KAVwTZy3bE4cppkIEgpaY76wXgjEHU/j7i
        k575jow0jYbl7HExp789MLxgulLwBEFlxm4TaaM=
X-Google-Smtp-Source: ABdhPJzOxY2WPV1Epz2wQbUx7VoGFlpnRC9S4zR6beBI2Rvtdoy7Qp1WYUgk0RrL7JyqNSRvjGUOWaaYM71L7IyhnQU=
X-Received: by 2002:a05:6902:154d:: with SMTP id r13mr3410674ybu.114.1634947046356;
 Fri, 22 Oct 2021 16:57:26 -0700 (PDT)
MIME-Version: 1.0
References: <20211021214814.1236114-1-sdf@google.com>
In-Reply-To: <20211021214814.1236114-1-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 22 Oct 2021 16:57:15 -0700
Message-ID: <CAEf4BzabNUTWPWgxFhCdmuERRqVomuWMMReD1xQ0ma2i98uqRg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 0/3] libbpf: use func name when pinning
 programs with LIBBPF_STRICT_SEC_NAME
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 21, 2021 at 2:48 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> Commit 15669e1dcd75 ("selftests/bpf: Normalize all the rest SEC() uses")
> broke flow dissector tests. With the strict section names, bpftool isn't
> able to pin all programs of the objects (all section names are the
> same now). To bring it back to life let's do the following:
>
> - teach libbpf to pin by func name with LIBBPF_STRICT_SEC_NAME
> - enable strict mode in bpftool (breaking cli change)
> - fix custom flow_dissector loader to use strict mode
> - fix flow_dissector tests to use new pin names (func vs sec)
>
> v5:
> - get rid of error when retrying with '/' (Quentin Monnet)
>
> v4:
> - fix comment spelling (Quentin Monnet)
> - retry progtype without / (Quentin Monnet)
>
> v3:
> - clarify program pinning in LIBBPF_STRICT_SEC_NAME,
>   for real this time (Andrii Nakryiko)
> - fix possible segfault in __bpf_program__pin_name (Andrii Nakryiko)
>
> v2:
> - add github issue (Andrii Nakryiko)
> - remove sec_name from bpf_program.pin_name comment (Andrii Nakryiko)
> - add cover letter (Andrii Nakryiko)
>
> Stanislav Fomichev (3):
>   libbpf: use func name when pinning programs with
>     LIBBPF_STRICT_SEC_NAME
>   bpftool: conditionally append / to the progtype
>   selftests/bpf: fix flow dissector tests

I've applied patches #1 and #3, as they have to happen regardless of
how bpftool incompatibility is going to be handled. Please see
comments from John about bpftool. I think we should try to preserve
bpftool's backwards compatibility, or at the very least give users
some way to fall back to non-strict mode during the transition period.
I trust you, John and Quentin will figure out the best way forward
there.

Also, please move this flow_dissector_load selftest into test_progs,
so that we exercise it regularly.

>
>  tools/bpf/bpftool/main.c                      |  4 +++
>  tools/bpf/bpftool/prog.c                      | 35 ++++++++++---------
>  tools/lib/bpf/libbpf.c                        | 13 +++++--
>  tools/lib/bpf/libbpf_legacy.h                 |  3 ++
>  .../selftests/bpf/flow_dissector_load.c       | 18 ++++++----
>  .../selftests/bpf/flow_dissector_load.h       | 10 ++----
>  .../selftests/bpf/test_flow_dissector.sh      | 10 +++---
>  7 files changed, 55 insertions(+), 38 deletions(-)
>
> --
> 2.33.0.1079.g6e70778dc9-goog
>
