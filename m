Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 619752DB47C
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 20:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbgLOTaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 14:30:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727199AbgLOT3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 14:29:50 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11EA1C06179C;
        Tue, 15 Dec 2020 11:29:10 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id y128so386015ybf.10;
        Tue, 15 Dec 2020 11:29:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/qsYOHIpMIapAWI1ihiBPHU3oXMAex5g4eqFkY7vyEY=;
        b=C8HwMlWLxWrcxYGct1iVf2LmuMTycLsQ6ReM9VimyjUopAvhYf0+lfY+xjLvl6DJeG
         6XaP6g2skCwzudmp3bv0VCtk4eqfBIVRj0qxQ4XzmugwgkEdyw1YWMnUmet3i8hxGC/3
         PgWhDU3QBSRRULU8bRPYsmsDk2QrzvfUOhjc/MXYC9haniODEbt06DEs/+YyUn/oEaNX
         wKqg2Z8/MJLyCG09bl4vOQgT2JqerXVx98gazBt7L2Z5fFBkNRZmt9v+/TC1iEb5foho
         5F2eh3s2qlqfUSTB+7aLDflRjWkqm6Py0XUXKmsOKZIO21oaC5n6JlZRlMjvn6I0wKIS
         VC9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/qsYOHIpMIapAWI1ihiBPHU3oXMAex5g4eqFkY7vyEY=;
        b=S37fq2d9fDEt76BGAseOhLZTG0gnO6GNhRG+op+5LFKO+Nu7xNbYp2/QKM3ftEnix2
         wqv2jeOoGj76k5NNp24MQv/B3dAIc8k0OjyUNrYOJ7PR23plU2vtGUVwZ0MsIjuha1sH
         4MS/IvFgs1y3gNS0JbKz+dsNgJnEKJkpbLpm9aWeNPa99GcT8CXR2Xa+LbK4x+708gV+
         /IeaLL8jn6GfxX/WnANC7uHo/my2VvTNH+AViSbiGVBi3bYbnF6P0jFavzEILxmNeMaN
         VlMNMatZZA+v6uU9Vzp1eAZ/JopA1GKEj1CDdibXk0PtdeIDZxRO5wizbruUcikW+6qI
         r06Q==
X-Gm-Message-State: AOAM531/zOpe/3lb94cLAr6NKADoZ+sfLCHmi389lyg2t768u/0+hYdX
        Ruy22CeXhtfA2S7g2o/1WLLVcEPHzUwrwmqry3U=
X-Google-Smtp-Source: ABdhPJy9sRCqcapbEtUxNXjcneKgy2Wxe86mX+WfrcQW4nKII+jQ7TMbekQSVEEg7y2nm3lyGbt2aYvEs2+gZv45m4Y=
X-Received: by 2002:a25:d6d0:: with SMTP id n199mr43644128ybg.27.1608060548553;
 Tue, 15 Dec 2020 11:29:08 -0800 (PST)
MIME-Version: 1.0
References: <20201214201118.148126-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20201214201118.148126-1-xiyou.wangcong@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 15 Dec 2020 11:28:57 -0800
Message-ID: <CAEf4Bza1tAnAMVw8g4z2UviYqWxgarOXZX2JDTShYyk-NLAo6A@mail.gmail.com>
Subject: Re: [Patch bpf-next v2 0/5] bpf: introduce timeout map
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 14, 2020 at 12:13 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> From: Cong Wang <cong.wang@bytedance.com>
>
> This patchset introduces a new bpf hash map which has timeout.

It's a bit too short a cover letter for a pretty major new type of
hash maps. Please expand on the problem it's trying to solve, how you
tested and benchmarked it, etc.

> Patch 1 is a preparation, patch 2 is the implementation of timeout
> map, patch 3 updates an existing hash map ptr test, patch 4 and
> patch 5 contain two test cases for timeout map.
>
> Please check each patch description for more details.
>
> ---
> v2: fix hashmap ptr test
>     add a test case in map ptr test
>     factor out htab_timeout_map_alloc()
>
> Cong Wang (5):
>   bpf: use index instead of hash for map_locked[]
>   bpf: introduce timeout map
>   selftests/bpf: update elem_size check in map ptr test
>   selftests/bpf: add a test case for bpf timeout map
>   selftests/bpf: add timeout map check in map_ptr tests
>
>  include/linux/bpf_types.h                     |   1 +
>  include/uapi/linux/bpf.h                      |   3 +-
>  kernel/bpf/hashtab.c                          | 301 ++++++++++++++++--
>  kernel/bpf/syscall.c                          |   3 +-
>  tools/include/uapi/linux/bpf.h                |   1 +
>  .../selftests/bpf/progs/map_ptr_kern.c        |  22 +-
>  tools/testing/selftests/bpf/test_maps.c       |  41 +++
>  7 files changed, 340 insertions(+), 32 deletions(-)
>
> --
> 2.25.1
>
