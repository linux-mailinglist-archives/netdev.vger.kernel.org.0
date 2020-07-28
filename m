Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA0C8230266
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 08:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbgG1GJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 02:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726407AbgG1GJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 02:09:55 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A728C061794;
        Mon, 27 Jul 2020 23:09:55 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id d27so14092291qtg.4;
        Mon, 27 Jul 2020 23:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yxCID3w4uSY/X2DD2GHKAyRoLJ0CfPIN7trHBjhDJLY=;
        b=neTudZrDwa0UCrpO5vA+9WvC/rc0aKwY6FWm4dE2mOq7JSQOyihPOzQBe/CxIcMqjr
         gZmIwlzE7vx5EYh3pc25vcszDXzp2R7KmCzYBt8hSmRvat4gseUsx0HMMUKPUKwEgJBr
         r44ypVcMWlqPkTUq2PSyUQnITsDB4k3Nz63FdEbswmVUipLwfKswlAap/I3mkW0ldVv7
         Sf3zBRf+rS8cPqL456w4ys08mDZwaY/U5bxOPyop42epNugtz9k3UOTzJQ+txNLQQTWd
         +W5lqsy1P8LM2IVqi49i/7Zdqe4pponE1zzw5XMR8ECH/HmzbBgf1gjtjK6bJ1xZoHPj
         n/Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yxCID3w4uSY/X2DD2GHKAyRoLJ0CfPIN7trHBjhDJLY=;
        b=UZk4A9ziMkpi2SBKK4P1L+GcWY7s2Y7EFKSSCM3t2vQF9BITrNNgS+du4nqRapCwSL
         cKC+B9oOrsliA3H2v+Te9fEdFUFFVrI8aU+Q/zZYpmnXhhfBNXP7hM1yHLZ631V1pOnD
         TKQXYMnChlD72D0xNozYX//S3QBBz5Pa3PTmXy01MO7lKQ0HoWcXnCxxK6ZCKU5Joj56
         UyP0PlK1ESfQI2OGXbTMx3CTwz+De85Z+VkKVq4fjq4JTyryceBAoycHjIqjV0SDborv
         6/2lt8KFgjwyjAkoZy3osAwuPkkA7+i0XkmGeRZa3d8vlKvOMUWaSdjPMfKkSFNUghrd
         DQnA==
X-Gm-Message-State: AOAM532Ah3b1cqroYZdg2r6zA7wmF83QiINBLI7GiH/1XZQkL2exaxk/
        8exQwoyfnKRA7NGgTh6LoIxGJPNGa/GGinLyB7M=
X-Google-Smtp-Source: ABdhPJzWqlbyBxFF1iONPZ1lzPmDHEi3KIr0x4HReNWCYegoLqT+FbLC3QKeKYj32OYg+oeMyWKDBuU6EbYWnlBtigM=
X-Received: by 2002:ac8:4511:: with SMTP id q17mr18384092qtn.117.1595916594441;
 Mon, 27 Jul 2020 23:09:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200727184506.2279656-1-guro@fb.com> <20200727184506.2279656-36-guro@fb.com>
In-Reply-To: <20200727184506.2279656-36-guro@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 27 Jul 2020 23:09:43 -0700
Message-ID: <CAEf4BzYUhybiSz2S-jtuv5+KcaHSxCLoY=nq1g597bvwpUemZw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 35/35] perf: don't touch RLIMIT_MEMLOCK
To:     Roman Gushchin <guro@fb.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 12:21 PM Roman Gushchin <guro@fb.com> wrote:
>
> Since bpf stopped using memlock rlimit to limit the memory usage,
> there is no more reason for perf to alter its own limit.
>
> Signed-off-by: Roman Gushchin <guro@fb.com>
> ---

Cc'd Armaldo, but I'm guessing it's a similar situation that latest
perf might be running on older kernel and should keep working.

>  tools/perf/builtin-trace.c      | 10 ----------
>  tools/perf/tests/builtin-test.c |  6 ------
>  tools/perf/util/Build           |  1 -
>  tools/perf/util/rlimit.c        | 29 -----------------------------
>  tools/perf/util/rlimit.h        |  6 ------
>  5 files changed, 52 deletions(-)
>  delete mode 100644 tools/perf/util/rlimit.c
>  delete mode 100644 tools/perf/util/rlimit.h
>

[...]
