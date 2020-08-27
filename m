Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB571253D3A
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 07:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgH0F0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 01:26:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726058AbgH0F0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 01:26:08 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14863C061240;
        Wed, 26 Aug 2020 22:26:08 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id q3so2276684ybp.7;
        Wed, 26 Aug 2020 22:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oY4EUnOEDju3tja4wkLjWLLZvYjMGT3vB9eb0pCpq7o=;
        b=l/oxaKglaB9lSsSwQ0lPu3+uiqwpzArlKqIbAb9MFjsbBC6tV9ozmgfoYNbEtzUcbB
         reYA6O8v8d+O3il6G9eWCUSibi1tk8l2CzlO8yOwlMUjwJpzSeki4v1H3mV6HLmMQWlK
         eiOTWfNP3MNqjeja4mvCPIefJjF4hFnw77jn13klS5AqAst3Td19YlJa9nZ/6OG4wTgj
         0CToRL7cxeaT0f2kpiyw5i7T9PR3xCQQ5Edyo81yrdBxeJFqru3LF03S2e5b/cUMafjg
         KVrt/HdtyGqyDSsV+qXrN+pMikw/1gD47iR5FXZnHpJvPzyokhsYc/AktWH//BQCc2Yu
         Ky/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oY4EUnOEDju3tja4wkLjWLLZvYjMGT3vB9eb0pCpq7o=;
        b=EZvJ7Ruq/G4GDkpLGYjLlXsXsS2dhwRRAJmZ6bYmJ0OKVgZC4ltvHLyFcKJLGqG+CM
         g/jM3LUfnmwlzwOv6ZJD3k79OcA6gaWnQLUs3nj8l114+kwzQoDQCJ8vEdIeY3wxW+9x
         hbP7AAhiWFXO3w9dkxwjrhRMtWuahkJ8PoGaMCho5cKD7TsVtb3mkSTAb1bYJcOX+3mA
         lAtxcAbN3I2fCNmdhPIhFwDJasmygbnr2mr5ru9l8eIMSw49jRC6hizTby6EBgzMDIrm
         i2to8u5V8pBsoLmmTxGvLWZ41azQCWpRBqiCZ26T06zdIkb3YIUReVJaX0S+tVNwP18j
         I6sw==
X-Gm-Message-State: AOAM531ssuKXyFeJ+dnclTlV4Y9ayneJxSf1uVeiWCBcrPy6h1B0c9fn
        3TkEt5qM7PiuUy0hk4f63KFo1ERpRiCjyPii084=
X-Google-Smtp-Source: ABdhPJw4CnXJE5XdzTv9U9a4RZQ23gT5fERpmBOFlaEcDhu3ZqesEcc2gCcqFm2Na/lwudsOkoowNbj+p2ii3rf+9u4=
X-Received: by 2002:a25:ad5a:: with SMTP id l26mr25086554ybe.510.1598505967092;
 Wed, 26 Aug 2020 22:26:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200826160424.14131-1-cneirabustos@gmail.com>
In-Reply-To: <20200826160424.14131-1-cneirabustos@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 26 Aug 2020 22:25:55 -0700
Message-ID: <CAEf4BzYt3Wt5ABivJKifoW3XLL-U0B_KgXim0pUtqJUapo7raw@mail.gmail.com>
Subject: Re: [PATCH v1 bpf-next] bpf: new helper bpf_get_current_pcomm
To:     Carlos Neira <cneirabustos@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>, Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 26, 2020 at 9:06 AM Carlos Neira <cneirabustos@gmail.com> wrote:
>
> In multi-threaded applications bpf_get_current_comm is returning per-thread
> names, this helper will return comm from real_parent.
> This makes a difference for some Java applications, where get_current_comm is
> returning per-thread names, but get_current_pcomm will return "java".
>

Why not bpf_probe_read_kernel_str(dst, 16, task->real_parent->comm)
for fentry/fexit/tp_btf/etc BTF-aware BPF programs or
BPF_CORE_READ_STR_INTO(dst, task, real_parent, comm) for any BPF
program that has bpf_probe_read_kernel[_str]() (which is pretty much
every BPF program nowadays, I think)?

Yes, CONFIG_DEBUG_INFO_BTF=y Kconfig is a requirement, but it's a good
idea to have that if you are using BPF anyways.

> Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
> ---
>  include/linux/bpf.h                           |  1 +
>  include/uapi/linux/bpf.h                      | 15 ++++-
>  kernel/bpf/core.c                             |  1 +
>  kernel/bpf/helpers.c                          | 28 +++++++++
>  kernel/trace/bpf_trace.c                      |  2 +
>  tools/include/uapi/linux/bpf.h                | 15 ++++-
>  .../selftests/bpf/prog_tests/current_pcomm.c  | 57 +++++++++++++++++++
>  .../selftests/bpf/progs/test_current_pcomm.c  | 17 ++++++
>  8 files changed, 134 insertions(+), 2 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/current_pcomm.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_current_pcomm.c
>

[...]
