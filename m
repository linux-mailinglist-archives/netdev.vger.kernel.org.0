Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14D7827D5B7
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 20:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbgI2SYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 14:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727605AbgI2SYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 14:24:21 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E57A0C061755;
        Tue, 29 Sep 2020 11:24:19 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id b22so6627549lfs.13;
        Tue, 29 Sep 2020 11:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9IJ2N7Pkm2rRXP52Jxie87cMm3z3cYwKxTSBfLl7CZ0=;
        b=N7LBkxs7uCSKldLHsw5UMtiStWNngj8ej1aq2AhQ+5IePlXEPf5oY7VlhGFEdWOLsI
         3Z11TW8p88O8A7pM7LxMezB4jPQF2xphD3X0HPncmm2ZQzcqwGwv/eK2HIFvKmVhTY3V
         iIEWftyPA3ZdIvlmw5rzltl9LxRFHCyYtDOMxO30jO3lR4x2lqCwdTPNxpxMj4/4lHKz
         dWdG/gj3yyqvIaxkVzvyrB3RPvDmk8OqZiHSPxkA9FXhEbJjuhFpVwqpLYQ82ZvapgPM
         8Lt7p1Ous3WmryOEU+wcR1Qcdi/TQuJfxOeF3f8h4vC73TRQV/UkPx4syZE4hk+ZImln
         saKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9IJ2N7Pkm2rRXP52Jxie87cMm3z3cYwKxTSBfLl7CZ0=;
        b=aXRybR/5w4+D35z7OkeVNZn+eCfm7TEA6Q3eHEsIaULNzcbYJgQUdeVeasX34Pc0md
         dVZGSkJHogqepdEtQgVQHfoNwVvB+Oj1pGRT6QEGpovddJH4K7EYM2lqPnnzuVLI3Gnb
         reogSgmw9xEf1pzJKjynu50BPcnW+DDBS0qq2Gs5dV6/qUN6JYbbit0cwvO5mv4P6Nea
         uEV31Dv3buX7i3MC3yWGJiu2IWt+8/uTOlsBiont9g60safJxHZF2bBCe4zna9VKJaTP
         QXB5Ym30p2bpwyIJPxkfKVwibyfr2EHRrEEqHelQqddq2Gv+BcaFeVEqrRxAOANlkHG6
         +wIw==
X-Gm-Message-State: AOAM530X0BjFB8z9wFBG4woNEKQJbH5JcJhfb+IJ132hYj1etOIBWp+l
        uCdVKSkhtQFc41ovTYQABaFX1lnEBwto5g8GuggskeaFPBw=
X-Google-Smtp-Source: ABdhPJyP//9Zr/WoY7d+28xyBF6gb1NSztyhMrjW5rKozo1Q3iCAm3Dh811sR0M9m0KKhM0mQDe6VXru8WZhBcvrarQ=
X-Received: by 2002:a19:9141:: with SMTP id y1mr1572264lfj.554.1601403858264;
 Tue, 29 Sep 2020 11:24:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200925205432.1777-1-songliubraving@fb.com> <20200925205432.1777-2-songliubraving@fb.com>
In-Reply-To: <20200925205432.1777-2-songliubraving@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 29 Sep 2020 11:24:06 -0700
Message-ID: <CAADnVQ+ZMOxjUDCdLfwRGPbjG8YV8kHVu2kM1+JzSffJZ9=W_w@mail.gmail.com>
Subject: Re: [PATCH v6 bpf-next 1/3] bpf: enable BPF_PROG_TEST_RUN for raw_tracepoint
To:     Song Liu <songliubraving@fb.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 25, 2020 at 1:55 PM Song Liu <songliubraving@fb.com> wrote:
> +
> +       if ((kattr->test.flags & BPF_F_TEST_RUN_ON_CPU) == 0 ||
> +           cpu == smp_processor_id()) {
> +               __bpf_prog_test_run_raw_tp(&info);

That's broken:
[   35.874974] BUG: using smp_processor_id() in preemptible [00000000]
code: new_name/87
[   35.893983] caller is bpf_prog_test_run_raw_tp+0xd4/0x1b0
[   35.900124] CPU: 1 PID: 87 Comm: new_name Not tainted 5.9.0-rc6-g615bd02bf #1
[   35.907358] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.10.2-1ubuntu1 04/01/2014
[   35.916941] Call Trace:
[   35.919660]  dump_stack+0x77/0x9b
[   35.923273]  check_preemption_disabled+0xb4/0xc0
[   35.928376]  bpf_prog_test_run_raw_tp+0xd4/0x1b0
[   35.933872]  ? selinux_bpf+0xd/0x70
[   35.937532]  __do_sys_bpf+0x6bb/0x21e0
[   35.941570]  ? find_held_lock+0x2d/0x90
[   35.945687]  ? vfs_write+0x150/0x220
[   35.949586]  do_syscall_64+0x2d/0x40
[   35.953443]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Please fix and add debug flags to your .config.
