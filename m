Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 290891EC245
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 21:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgFBTAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 15:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbgFBTAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 15:00:25 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD522C08C5C0;
        Tue,  2 Jun 2020 12:00:23 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id z9so3264399ljh.13;
        Tue, 02 Jun 2020 12:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yat/Aky85YNgrWEeCGdTP3vQQX75KX5ytsot2hrgsCI=;
        b=FtVSNzeBZW96IGZKJ6cAxbvq6wXcwHjKNm9xd3DMPmQi+sdolEqd9ZVjAc4myYto7A
         1rLfJwssRGbi76jBvwkyr50O95Q2xPgsgt+SAa+EJbljGUff6QzdQEZVE4yv5e0ISnaZ
         J2Mv3zQuaScIiWAllmtl10DGXg1pV8oI1ZW8104LNQGw+lk5cIPOZRCIdmkN3zqTQUFX
         RL2DN6DhzAF6bN86qRNFM5YGyshyLTLSn8gL/7YDyakcIeVDPPzjioUk8nHD9eFuwppg
         Db3J3SJ+0OElkU0yB4tFjRq2PDcLOjxxeDt6jChlFotA7D0nxqXFSRygaRdkWkkzUukn
         QrRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yat/Aky85YNgrWEeCGdTP3vQQX75KX5ytsot2hrgsCI=;
        b=Zg+lRul1xcSLecnf0K6AfDL1H5LnXiK9v44ssJH9KUQ62BDFZP/Hfoa+3F2dZTrhVB
         SFH1j/c8lG2lAcBK4wY6BOQRpUcX6/tgKhCGxQb7oEK1apAfjgDQQjob9pVl0BhVq9qD
         +X5FEfV/7w+OGnsEtwApUQssVsrGja3bgTw7iLA7tKWFbKhT22bueQUPuwkvFoy6wYjT
         WMdiyL4EzjOtDqgvtNAV43aq+9hC6I/19Vz7gFeW+A+BeIde1AXOoJhxJwz7MmDAIGW9
         yVR/R/BrkoHxagAxRlvAKWyRNHJKeMZip/5fOCgbUWo9cqKfZKNM1RABMgXyq/mL8991
         TS8Q==
X-Gm-Message-State: AOAM531sO0a+8XEuD+rfp++hgeDhXTUgXQZjA/koIFPu0hl7ZrB69ACZ
        +/eMswXFeNnZxIyqjUEsNUknHw1YafTfP/edkMg=
X-Google-Smtp-Source: ABdhPJyfxpdE+xTeimPsFR7wp9fd2+yuX3q9JVQtaflOhoGPK8t/SzN4ORWSM3L4igOuhnEq1DAFNtaEDcFA+wwsuBk=
X-Received: by 2002:a2e:150e:: with SMTP id s14mr245961ljd.290.1591124422271;
 Tue, 02 Jun 2020 12:00:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200602050349.215037-1-andriin@fb.com> <CAPhsuW5OH9paDZpG-KfYK3EkwpaQWPOcD6c0kyLQ7+ePs9Xd8g@mail.gmail.com>
In-Reply-To: <CAPhsuW5OH9paDZpG-KfYK3EkwpaQWPOcD6c0kyLQ7+ePs9Xd8g@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 2 Jun 2020 12:00:07 -0700
Message-ID: <CAADnVQL9CYGyFM-hpi4=jSA6gp3vs_0i5+bVJ5sduPtO_cPsZg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: fix sample_cnt shared between two threads
To:     Song Liu <song@kernel.org>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 2, 2020 at 9:22 AM Song Liu <song@kernel.org> wrote:
>
> On Mon, Jun 1, 2020 at 10:04 PM Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > Make sample_cnt volatile to fix possible selftests failure due to compiler
> > optimization preventing latest sample_cnt value to be visible to main thread.
> > sample_cnt is incremented in background thread, which is then joined into main
> > thread. So in terms of visibility sample_cnt update is ok. But because it's
> > not volatile, compiler might make optimizations that would prevent main thread
> > to see latest updated value. Fix this by marking global variable volatile.
> >
> > Fixes: cb1c9ddd5525 ("selftests/bpf: Add BPF ringbuf selftests")
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> Acked-by: Song Liu <songliubraving@fb.com>

Applied. Thanks.

I also pushed trivial commit to fix test_verifier.
