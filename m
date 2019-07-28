Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C309A77D4A
	for <lists+netdev@lfdr.de>; Sun, 28 Jul 2019 04:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725880AbfG1C5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 22:57:44 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:44177 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbfG1C5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 22:57:44 -0400
Received: by mail-qk1-f193.google.com with SMTP id d79so41835815qke.11;
        Sat, 27 Jul 2019 19:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vl0H5Akj+AnqTG4PJIB2mW2Ld8XZ/TMehKH6IhQhQlY=;
        b=dWST1bqB9qk426oiWul+8wB6e6qA8Mj7+vzFaD4n2zYub+mOJt49foNBNrmMPcOuiW
         Dv1TqaNNxVn8O3EK4wDuBDaubz1uPB/3lK4wzFugnXyc9AHORPDa564SgopU11BZQq0F
         l/HN7JecqWx2Oxm9mX/VGXL88N0aPwlLedTCaTN8CMxTKYBoVGOaeyPQIrbeMajilRr7
         9lOX758+qqtEgM27satk8urDeUWvdf79fNuq6VtaKsPhR6zGcgnSHAs2/OsQ8Un5TCpF
         iTm1zlC5rJe9lcslckjr8e8WJwxDla/nhk6BWTCkiowfkIK3SdsuFJ+lZSZuDZwMI6ha
         Ofww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vl0H5Akj+AnqTG4PJIB2mW2Ld8XZ/TMehKH6IhQhQlY=;
        b=O9twxJyn0YIPYD6v11vgIxlDpib8uh8Hcizg+3Jdr5fvgXCDrYFcDWB90PSPq+2L8s
         3/gDY6goklGU6Ua6u8gIf/ncflDm/IZzbE8wUu+aCU5Xx7pdGTOdz81Pka53zBfCDQ+I
         zY/vz4ipMW6UcvO8C4qjn5AJte8FszeZEmVa/aheBSjrBqHoOLGrTfr1dYmYD4xN9Gco
         IMK6FyYf4PWt+ODfq1ccM/yaIIA+qQ2OyZ2KVW7AyBXpogvhkEUZI9VlG+wmv6bH1t0e
         O46hw0olWPgAYIowMFAXGzBnXTR3lvby+9B7k/N2gvcqo00vC68Y2noEg335IF8UG/oc
         fe6Q==
X-Gm-Message-State: APjAAAUa+z2zSexcgU+x9eOXLHtowdqI9PE6Sw3DAC/nkSYPXGCzrOAw
        unfaPSFcf/Xr4Pb7pz4fjUSu2ovKZARFOyM0S9yXeNMG
X-Google-Smtp-Source: APXvYqz41T7jPTpXMaGP72gHU/jQgfnvfbnKlZZZPkjC/ad2J24HqTePyLHUh8dcSKVM/5Xlw3wQU1z+EZZgBSZsOho=
X-Received: by 2002:a37:9b48:: with SMTP id d69mr72131191qke.449.1564282662836;
 Sat, 27 Jul 2019 19:57:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190727190150.649137-1-andriin@fb.com> <CAADnVQJoS8Yjt-qFHg4XEkiF_3H8nRx15xZfJDSy8YcRT_UKrg@mail.gmail.com>
 <CAEf4BzY3snLh5=qhFo6RNL1RQMcmVhkCiB2s4p57jQcovp5TWw@mail.gmail.com>
In-Reply-To: <CAEf4BzY3snLh5=qhFo6RNL1RQMcmVhkCiB2s4p57jQcovp5TWw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 27 Jul 2019 19:57:31 -0700
Message-ID: <CAEf4BzYoKDxHpLg_rcUrVbU1u2mVFDu7vDoNbSeZrLnKSh=n_w@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 0/9] Revamp test_progs as a test running framework
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 27, 2019 at 7:16 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Sat, Jul 27, 2019 at 6:12 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Sat, Jul 27, 2019 at 12:02 PM Andrii Nakryiko <andriin@fb.com> wrote:
> > >
> > > This patch set makes a number of changes to test_progs selftest, which is
> > > a collection of many other tests (and sometimes sub-tests as well), to provide
> > > better testing experience and allow to start convering many individual test
> > > programs under selftests/bpf into a single and convenient test runner.
> >
> > I really like the patches, but something isn't right:
>
> Argh... Uninitialized `int ret` in test__vprintf(). Should be
> initialized to zero, otherwise in some corner cases when log buffer is
> completely full and ret's initial value is sufficiently large negative
> number, it can underflow env.log_cnt, silently skipping one log
> output, and then crashing on next one. You've somehow encountered a
> fascinating series of conditions that I've never stumbled upon running
> my code dozens of times. Fixing, sorry about that!

Ok, I doubt it was that specific bug (even though it is a bug). Turns
out that you can't call vprintf with the same va_list twice, as it
consumes it, so I have to do va_copy() if I might call vprintf
multiple times. So fixing that now.

>
> > #16 raw_tp_writable_reject_nbd_invalid:OK
> > #17 raw_tp_writable_test_run:OK
> > #18 reference_tracking:OK
> > [   87.715996] test_progs[2200]: segfault at 2f ip 00007f56aeea347b sp
> > 00007ffce9720980 error 4 in libc-2.23.so[7f56aee5b000+198000]
> > [   87.717316] Code: ff ff 44 89 8d 30 fb ff ff e8 01 74 fd ff 44 8b
> > 8d 30 fb ff ff 4c 8b 85 28 fb ff ff e9 fd eb ff ff 31 c0 48 83 c9 ff
> > 4c 89 df <f2> ae c7 85 28 fb ff ff 00 00 00 00 48 89 c8 48 f7 d0 4c 8f
> > [   87.719493] audit: type=1701 audit(1564276195.971:5): auid=0 uid=0
> > gid=0 ses=1 subj=kernel pid=2200 comm="test_progs"
> > exe="/data/users/ast/net-next/tools/testing/selftests/bpf/test_progs"
> > sig=11 res=1
> > Segmentation fault (core dumped)
> >
> > Under gdb fault is different:
> > #23 stacktrace_build_id:OK
> > Detaching after fork from child process 2276.
> > Detaching after fork from child process 2278.
> > [  149.013116] perf: interrupt took too long (6799 > 6713), lowering
> > kernel.perf_event_max_sample_rate to 29000
> > [  149.014634] perf: interrupt took too long (8511 > 8498), lowering
> > kernel.perf_event_max_sample_rate to 23000
> > [  149.017038] perf: interrupt took too long (10649 > 10638), lowering
> > kernel.perf_event_max_sample_rate to 18000
> > [  149.021901] perf: interrupt took too long (13322 > 13311), lowering
> > kernel.perf_event_max_sample_rate to 15000
> > [  149.042946] perf: interrupt took too long (16660 > 16652), lowering
> > kernel.perf_event_max_sample_rate to 12000
> > Detaching after fork from child process 2279.
> > #24 stacktrace_build_id_nmi:OK
> > #25 stacktrace_map:OK
> > #26 stacktrace_map_raw_tp:OK
> >
> > Program received signal SIGSEGV, Segmentation fault.
> > 0x00007ffff723f47b in vfprintf () from /usr/lib/libc.so.6
> > (gdb) bt
> > #0  0x00007ffff723f47b in vfprintf () from /usr/lib/libc.so.6
> > #1  0x00007ffff72655a9 in vsnprintf () from /usr/lib/libc.so.6
> > #2  0x0000000000403100 in test__vprintf (fmt=0x426754 "%s:PASS:%s %d
> > nsec\n", args=0x7fffffffe878) at test_progs.c:114
> > #3  0x000000000040325c in test__printf (fmt=fmt@entry=0x426754
> > "%s:PASS:%s %d nsec\n") at test_progs.c:147
> > #4  0x000000000042222d in test_task_fd_query_rawtp () at
> > prog_tests/task_fd_query_rawtp.c:19
> > #5  0x0000000000402c76 in main (argc=<optimized out>, argv=<optimized
> > out>) at test_progs.c:501
> > (gdb) info threads
> >   Id   Target Id         Frame
> > * 1    Thread 0x7ffff7fea700 (LWP 2245) "test_progs"
> > 0x00007ffff723f47b in vfprintf () from /usr/lib/libc.so.6
