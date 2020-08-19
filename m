Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81E7A249252
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 03:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbgHSBZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 21:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726367AbgHSBZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 21:25:17 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BBF3C061389;
        Tue, 18 Aug 2020 18:25:17 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id g6so23489508ljn.11;
        Tue, 18 Aug 2020 18:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AidZcby2UmdfSc8qIr6w6RsJ0Rgc1buvH2/EryuFxlA=;
        b=rqnlagxkUJSYix8O9vAfpy78GGR+ec7IT0OfVRNTpdgccRsYb7cassEzuVgNkFX33G
         Xm3n2ThXFeF+GlHg8Cw3QUH5XVlG5S/Iuskh1X/GisKSOOwF+c3VJQCuFNKqY5CDmjSK
         7Kk8FLXhzpmPFxkT3E4pQE282xaPMmne9CzG6EJIMDjJDz7z3IwMcUkNKGxtaqzySmRR
         AwhdjenRAgSxUTxTt0rfWidMMZx4YK3fTROysE+e4KglZ1i8NEnkrV/o5ZFIRNsDZFyK
         Jc/We/ZHyjyRzW8m2T9FG60NN8um3FzwwGtaiDDtlvGf7P+MwOdL9HVHjf8C28z3bh0C
         sojw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AidZcby2UmdfSc8qIr6w6RsJ0Rgc1buvH2/EryuFxlA=;
        b=BywpBtN7cb8XNtFkJELZxjg1eqiGxtagkntoPDKyMeKe8r7xEy5LWTkXIPMJ7aDKBA
         kp4TZgqDUrKGTu+TzOdz62K13ol1OEA1hJTTZ/CA6/bN/i4bflMCzfJod/4AUWokTPze
         UK2CCLE7WUAGorbuzlVFME4ia4pXEBAVgsLwRvu0Uk5RPqIjd73MdU5BnZw2z/ePuqH0
         xQgl4DFjx+SeIbkaOdA11yX8ixt9DNKP9sjZV8YEkUOD1fVfX6Vnnrzx0TtCqQ65+5xv
         tGCMFLp+GTXKbjs5W5tXhlPL3a8x4no6neT8BTFourGL6hR2WDEdICRHMggCnazEbnJ0
         Lvrg==
X-Gm-Message-State: AOAM5329+0JPdSmPWLpoN6M5Mun6/HWZj5MCoX0+C2EZWTneEiVHXa1B
        d3MaUP7rpucltRZj4//p0w+uKMzS9DY9LvkGvF4+ho1O
X-Google-Smtp-Source: ABdhPJx7reXIpg8jEN3+lbL9q5zKWg3Vcn/V9Eij5FuxW+l0EP5y4XbGuoKBKcO7+2IXaTQ0MZq2DObhRm9hBYyVd50=
X-Received: by 2002:a2e:4e09:: with SMTP id c9mr11453397ljb.283.1597800315671;
 Tue, 18 Aug 2020 18:25:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200819012156.3525852-1-andriin@fb.com>
In-Reply-To: <20200819012156.3525852-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 18 Aug 2020 18:25:03 -0700
Message-ID: <CAADnVQLw6a7VKWVhUhNtYWjaOKUhAhLT8nzqHnFAm4nnCUzQkA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 0/4] libbpf: minimize feature detection
 (reallocarray, libelf-mmap)
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 6:24 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Get rid of two feature detectors: reallocarray and libelf-mmap. Optional
> feature detections complicate libbpf Makefile and cause more troubles for
> various applications that want to integrate libbpf as part of their build.
>
> Patch #1 replaces all reallocarray() uses into libbpf-internal reallocarray()
> implementation. Patches #2 and #3 makes sure we won't re-introduce
> reallocarray() accidentally. Patch #2 also removes last use of
> libbpf_internal.h header inside bpftool. There is still nlattr.h that's used
> by both libbpf and bpftool, but that's left for a follow up patch to split.
> Patch #4 removed libelf-mmap feature detector and all its uses, as it's
> trivial to handle missing mmap support in libbpf, the way objtool has been
> doing it for a while.
>
> v1->v2:
>   - rebase to latest bpf-next (Alexei).

still no good. pls rebase again.
