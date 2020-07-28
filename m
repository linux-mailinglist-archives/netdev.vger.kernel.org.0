Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9336230238
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 08:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbgG1GAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 02:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726857AbgG1GAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 02:00:49 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C1CDC061794;
        Mon, 27 Jul 2020 23:00:49 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id s15so4197461qvv.7;
        Mon, 27 Jul 2020 23:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BE6SS10lfsQtZlsbH6eTAUSCgCje4KornwWwzZylYrA=;
        b=f2yGdb0MIYCqjngaPYjPgclMP3jXg1zdeo8u9Xo80GhMCISW4/fasrYBqXbTfR/3Ui
         2fn1EAWRQUJ6Qy6JBMfUM5NfOGF40XCV6NFkk5pO4l4w7+VMLIRE5TwtRIfsQSAt86N5
         7vbty2J3uyqxNy/aE6c7HZBCUlIpU6ozOOTa3K5/6ObeRZBvZeHkIgU1/VfdNP3sxXXs
         TbjDIhCT6vhy+IHPKVxnxFo0AoPokMqWvzmAkeMdvf8yaYmR895w34knaIoMMdgTOWAC
         LwKZ+IaKkgs/t7Fgl0Z2/g80ByiQvb5k6AfP9QueGn8Vpwp4hzGxZjQqsrvhTRDdOCZt
         Mi+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BE6SS10lfsQtZlsbH6eTAUSCgCje4KornwWwzZylYrA=;
        b=sjEnXaBz+JbG7g3GHFyDX8d02bmibr1gVQjl5IVhZ+k7NgBlNM4s7Vr5zMLlOAPJq+
         aVcJ48Gc5jvmNj0hHvgQ64ZQwq62CQSIhSi1HZ/tvPALwUart6SPAakho7a5XvQMJpTa
         TWwUJ+yG9vIHwB1uXpbwf6M7TbL4dxAvI+xalWRlhy2shejF6XGwyUIAHVQDeB9KCNLn
         o6cGLOdSnyzuffnsbRxr0SyzoRX3DDYCfo/gLaoUJuV6wUQcTJW6hd+9BF9XIwWJD31g
         lSD7iUDFUMf9DapaS9vqxDGEGHYOm6NNo67Kr81eqRQwXJJHwxTOPYnPpszly4z7yKP5
         yxOg==
X-Gm-Message-State: AOAM530FvHF3Lu5zckB9zuiR/3J9Eom+/TRqdXvkYl32H5LuKUMqccwa
        APBh+mmAmy4QS9oCiz1Q7RJAxt29kIfYNcanokg=
X-Google-Smtp-Source: ABdhPJxHFRuThMoEQPwU895IhChAvgDRBpA4P+uWXtgKabpFJ7dzY3KbtrBTnFQdyLr9MaL7kPSb+oTbHwp7/sZmhCQ=
X-Received: by 2002:a05:6214:8f4:: with SMTP id dr20mr24691534qvb.228.1595916048616;
 Mon, 27 Jul 2020 23:00:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200727184506.2279656-1-guro@fb.com> <20200727184506.2279656-31-guro@fb.com>
In-Reply-To: <20200727184506.2279656-31-guro@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 27 Jul 2020 23:00:37 -0700
Message-ID: <CAEf4BzYrN=SJDZ4DC-H7yCBn41p+RgMeWC8KMpkoMpeaRscbUA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 30/35] bpf: bpftool: do not touch RLIMIT_MEMLOCK
To:     Roman Gushchin <guro@fb.com>
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
> there is no more reason for bpftool to alter its own limits.
>
> Signed-off-by: Roman Gushchin <guro@fb.com>
> ---

This can't be removed either, due to old kernel support. We probably
should have a helper function to probe RLIMIT_MEMLOCK use by BPF
subsystem, though, and not call set_max_rlimit() is not necessary.

>  tools/bpf/bpftool/common.c     | 7 -------
>  tools/bpf/bpftool/feature.c    | 2 --
>  tools/bpf/bpftool/main.h       | 2 --
>  tools/bpf/bpftool/map.c        | 2 --
>  tools/bpf/bpftool/pids.c       | 1 -
>  tools/bpf/bpftool/prog.c       | 3 ---
>  tools/bpf/bpftool/struct_ops.c | 2 --
>  7 files changed, 19 deletions(-)
>

[...]
