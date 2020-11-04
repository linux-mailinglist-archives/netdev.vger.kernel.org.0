Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2C672A6F27
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 21:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732342AbgKDUqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 15:46:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730383AbgKDUqC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 15:46:02 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE82CC0613D3;
        Wed,  4 Nov 2020 12:46:01 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id f140so32252ybg.3;
        Wed, 04 Nov 2020 12:46:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xeC3eavaM2yNhTls+Kq7UzrspacL6oZ/uq/pDoYl6Xw=;
        b=Z+ToEU+X0ph2r5Jxy+5hi7KZCTa50JzJRBnyuHbbxrifWe3iCLGdDelPNnYZaVqS6w
         /AFIZuQlHPlxcQRqC/T2gXBuHZJUuB4o+njYFsUxPyyMDVOdRt/Poo3V+PjkidL1Jryl
         cJ5nLizZPcXVnrtaayJzj4QNDbznZ98KDYsFjKME1WPt3dLJm8F5OCkQjDWGOESK2r6e
         s42X7VQxNHxy5oE+sePZSasI6EQRnZv5RDG2yT3GMhgyz+Qh0sMWElzuvCxaKEYRLkqZ
         W9ei7lzv21EzuBT0IpKXn2YZ4xiVdYMG8nAKcv8o5+4VZnSV6deNqU91a84pigvlaKLr
         bdGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xeC3eavaM2yNhTls+Kq7UzrspacL6oZ/uq/pDoYl6Xw=;
        b=tLVX6pWw9mDxRpRhdgq/TS78+sG9tLP3eCvTyocouVjXd6NbqD0MyJIvbAcQ+u8IoN
         oIRpCX+lNZ+2WrP1KsUng9fjr42A7K3X0yQEgb4x+aQOVroKezpap23eMVBc5hPMJ/oJ
         muwjLbBj9qWntt+TmfEP12v/koy5uWBOd/KD0O9KTpAqv4hZ3rj2bn9aScXkOxgDN9HT
         WrkgBVcgijBBz2lFcl9HnZ8/ap0RIP3uUPHKWRTY+Lf4IZfSBqTRyNOTjC1awnYAjDDS
         QObx5ao+tMgmpBrQu2aAjaYhk7LyG6hjRIWyARGNaCeDYpl5Yi7MVoBDw6wF8vemWr5n
         4OWg==
X-Gm-Message-State: AOAM533IaLJSKeVH447FR4jq/mS1bjHTwkohnG+Q/H7L/4MvE++jGyBf
        8MZt4AOjopBH7NpY0WOWeMfyJKM8pUXWuCiWqAg=
X-Google-Smtp-Source: ABdhPJwbOHF/k2mngURR4oGNmkM1WGT8naCIo8V34wTp1Kg7Dsk1+GoWC4jw1T8ZL5d7KCXrjfcIyH5RDQlOt5TJTnA=
X-Received: by 2002:a25:3443:: with SMTP id b64mr37146820yba.510.1604522761227;
 Wed, 04 Nov 2020 12:46:01 -0800 (PST)
MIME-Version: 1.0
References: <20201103154738.29809-1-david.verbeiren@tessares.net> <20201104112332.15191-1-david.verbeiren@tessares.net>
In-Reply-To: <20201104112332.15191-1-david.verbeiren@tessares.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 4 Nov 2020 12:45:50 -0800
Message-ID: <CAEf4BzaK4Lbac=A8dsRyCLCbdwTbXEJFXFU113kYv1UVCV9TyQ@mail.gmail.com>
Subject: Re: [PATCH bpf v4] bpf: zero-fill re-used per-cpu map element
To:     David Verbeiren <david.verbeiren@tessares.net>
Cc:     bpf <bpf@vger.kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 4, 2020 at 3:26 AM David Verbeiren
<david.verbeiren@tessares.net> wrote:
>
> Zero-fill element values for all other cpus than current, just as
> when not using prealloc. This is the only way the bpf program can
> ensure known initial values for all cpus ('onallcpus' cannot be
> set when coming from the bpf program).
>
> The scenario is: bpf program inserts some elements in a per-cpu
> map, then deletes some (or userspace does). When later adding
> new elements using bpf_map_update_elem(), the bpf program can
> only set the value of the new elements for the current cpu.
> When prealloc is enabled, previously deleted elements are re-used.
> Without the fix, values for other cpus remain whatever they were
> when the re-used entry was previously freed.
>
> A selftest is added to validate correct operation in above
> scenario as well as in case of LRU per-cpu map element re-use.
>
> Fixes: 6c9059817432 ("bpf: pre-allocate hash map elements")
> Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Signed-off-by: David Verbeiren <david.verbeiren@tessares.net>
> ---
>
> Notes:
>     v4:
>       - Replaced racy "once" test by getpgid syscall with
>         check on pid. (Andrii)
>       - Copyright lines use /* */ (Andrii)

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>
>     v3:
>       - Added selftest that was initially provided as separate
>         patch, and reworked to
>         * use skeleton (Andrii, Song Liu)
>         * skip test if <=1 CPU (Song Liu)
>
>     v2:
>       - Moved memset() to separate pcpu_init_value() function,
>         which replaces pcpu_copy_value() but delegates to it
>         for the cases where no memset() is needed (Andrii).
>       - This function now also avoids doing the memset() for
>         the current cpu for which the value must be set
>         anyhow (Andrii).
>       - Same pcpu_init_value() used for per-cpu LRU map
>         (Andrii).
>
>  kernel/bpf/hashtab.c                          |  30 ++-
>  .../selftests/bpf/prog_tests/map_init.c       | 214 ++++++++++++++++++
>  .../selftests/bpf/progs/test_map_init.c       |  33 +++
>  3 files changed, 275 insertions(+), 2 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/map_init.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_map_init.c
>

[...]
