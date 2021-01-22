Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3690A2FFF40
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 10:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727550AbhAVJdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 04:33:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727380AbhAVJRd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 04:17:33 -0500
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B44BC0613D6
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 01:16:53 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id 22so4456059qkf.9
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 01:16:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=67L9Crd/oIwia7vIEWq6/rITMkBbZPjZY1IPTq9s3Pk=;
        b=p08rAvJ86NU4ZvtR0BYy2ewvzYzpjrOXmomiC7tOLjZ6A323QGmIYzg8K6KLtlyaKk
         FrTWLAkN8Gs0yOeV71LUSRGvE0czDCmpbj/t+7YjPbToaXj3U5Ia/0Pw21m6emuZG1ST
         WMHLCI4RAHAKiSOiCBsRaxxSRN7QxjHrC+vSB7gr8plL8D9PIcN4YCGk3JLsE3IlPP6Z
         xfcdjUSNOaKHqQnPDoK8dQW6NS6mE55loh2Jejn6ntwjg+2CDlF8kfvKYXg6L3UMK8Lo
         Xlj79tEacW5UtWqAZGXF4gf4rLrHJPmO+Mt/GySvGqkOKwMRZguzUZJZk4XxhXAIZptF
         CCeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=67L9Crd/oIwia7vIEWq6/rITMkBbZPjZY1IPTq9s3Pk=;
        b=kBpCPyLcGptWyC6eM4HNzQ6kZPMfe5f2iCxESeX+s3nU6jCTTwk253KB1zPUrHyYvg
         7ZmUXfdBzVRPW9HOfHQAeMK9mo4BoRwyoMrNzvF4kg5kcXpF+ZZn0iJe+tYaAaUvlx43
         R9KRXBbywYbzOnPTuCwHBWmPyMYGlaCjDoQi6bH7T+vFuDXVTdBMWUJOZeLF+rOsGWa9
         7XNMPdRsZS1E+pJc14UPVi2/rNBXtNCFIp3RXJnQiNINeNPbalMtaKtElFopSV0ufeMk
         K12ZvcWC7AU2c1S5HRvu8Yg3qPLa7vGsrzCmsom7TJklNT/atZZM62N/L3NdlqfN1Tzm
         QiRw==
X-Gm-Message-State: AOAM532RfIOKb3kZZIjvjGMEdbUwKOAburu6HyipA0LVApkcUMpyun38
        tlI/UY0XL/ppya5o0qATCExeVrezAp5UZvb4MwEyDQ==
X-Google-Smtp-Source: ABdhPJyO0XB8TGH+D1zIq6Xv5lKVmmBSERohr9MZkD9JO2YDpHpcKvRX2UTFwQEtTHTZ81MIBa2CfqFTrKS48ShhtC4=
X-Received: by 2002:a37:4285:: with SMTP id p127mr3705502qka.501.1611307011934;
 Fri, 22 Jan 2021 01:16:51 -0800 (PST)
MIME-Version: 1.0
References: <c099ad52-0c2c-b886-bae2-c64bd8626452@ozlabs.ru>
In-Reply-To: <c099ad52-0c2c-b886-bae2-c64bd8626452@ozlabs.ru>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Fri, 22 Jan 2021 10:16:40 +0100
Message-ID: <CACT4Y+Z+kwPM=WUzJ-e359PWeLLqmF0w4Yxp1spzZ=+J0ekrag@mail.gmail.com>
Subject: Re: BUG: MAX_LOCKDEP_KEYS too low!
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        syzkaller <syzkaller@googlegroups.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 4:43 AM Alexey Kardashevskiy <aik@ozlabs.ru> wrote:
>
> Hi!
>
> Syzkaller found this bug and it has a repro (below). I googled a similar
> bug in 2019 which was fixed so this seems new.
>
> The repro takes about a half a minute to produce the message,  "grep
> lock-classes /proc/lockdep_stats" reports 8177 of 8192, before running
> the repro it is 702. It is a POWER8 box.
>
> The offender is htab->lockdep_key. If I run repro at the slow rate, no
> problems appears, traces show lockdep_unregister_key() is called and the
> leak is quite slow.
>
> Is this something known? Any hints how to debug this further? I'd give
> it a try since I have an easy reproducer. Thanks,

+netdev as it discusses net namespaces as well

Hi Alexey,

The reproducer only does 2 bpf syscalls, so something is slowly leaking in bpf.
My first suspect would be one of these. Since workqueue is async, it
may cause such slow drain that happens only when tasks are spawned
fast. I don't know if there is a procfs/debugfs introspection file to
monitor workqueue lengths to verify this hypothesis.

$ grep INIT_WORK kernel/bpf/*.c
kernel/bpf/arraymap.c: INIT_WORK(&aux->work, prog_array_map_clear_deferred);
kernel/bpf/cgroup.c: INIT_WORK(&cgrp->bpf.release_work, cgroup_bpf_release);
kernel/bpf/core.c: INIT_WORK(&aux->work, bpf_prog_free_deferred);
kernel/bpf/cpumap.c: INIT_WORK(&old_rcpu->kthread_stop_wq,
cpu_map_kthread_stop);
kernel/bpf/syscall.c: INIT_WORK(&map->work, bpf_map_free_deferred);
kernel/bpf/syscall.c: INIT_WORK(&link->work, bpf_link_put_deferred);

However, if it's indeed one of the workqueues, I am not sure how it
should be fixed.
We are having a similar (even worser) problem with async destruction
of network namespaces. These are way slower and take lots of mutexes.
I suspect that lots of hangs on net mutexes on syzbot dashboard are
related to that.

Unbounded async queueing is never a good idea. The classical solution
to this is to make the queue bounded and put back pressure on
producers. In this case it would limit the speed at which new
processes are created and make resource consumption (including # of
lockdep entries) bounded.
The restriction probably needs to be per-callback type, at least for
global workqueues.
However, I suspect that lots of callers of schedule_work can't block
(the reason for moving the work to background in the first place?). So
potentially the back pressure may be need to be applied at a different
point, which makes things a bit more complicated.


> root@le-dbg:~# egrep "BD.*htab->lockdep_key" /proc/lockdep | wc -l
> 7449
> root@le-dbg:~# egrep "BD.*htab->lockdep_key" /proc/lockdep | tail -n 3
> (____ptrval____) FD:    1 BD:    1 ....: &htab->lockdep_key#9531
> (____ptrval____) FD:    1 BD:    1 ....: &htab->lockdep_key#9532
> (____ptrval____) FD:    1 BD:    1 ....: &htab->lockdep_key#9533
>
>
> // autogenerated by syzkaller (https://github.com/google/syzkaller)
>
> #define __unix__ 1
> #define __gnu_linux__ 1
> #define __linux__ 1
>
> #define _GNU_SOURCE
>
> #include <dirent.h>
> #include <endian.h>
> #include <errno.h>
> #include <fcntl.h>
> #include <signal.h>
> #include <stdarg.h>
> #include <stdbool.h>
> #include <stdint.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <sys/prctl.h>
> #include <sys/stat.h>
> #include <sys/syscall.h>
> #include <sys/types.h>
> #include <sys/wait.h>
> #include <time.h>
> #include <unistd.h>
>
> static unsigned long long procid;
>
> static void sleep_ms(uint64_t ms)
> {
>         usleep(ms * 1000);
> }
>
> static uint64_t current_time_ms(void)
> {
>         struct timespec ts;
>         if (clock_gettime(CLOCK_MONOTONIC, &ts))
>         exit(1);
>         return (uint64_t)ts.tv_sec * 1000 + (uint64_t)ts.tv_nsec / 1000000;
> }
>
> static bool write_file(const char* file, const char* what, ...)
> {
>         char buf[1024];
>         va_list args;
>         va_start(args, what);
>         vsnprintf(buf, sizeof(buf), what, args);
>         va_end(args);
>         buf[sizeof(buf) - 1] = 0;
>         int len = strlen(buf);
>         int fd = open(file, O_WRONLY | O_CLOEXEC);
>         if (fd == -1)
>                 return false;
>         if (write(fd, buf, len) != len) {
>                 int err = errno;
>                 close(fd);
>                 errno = err;
>                 return false;
>         }
>         close(fd);
>         return true;
> }
>
> static void kill_and_wait(int pid, int* status)
> {
>         kill(-pid, SIGKILL);
>         kill(pid, SIGKILL);
>         for (int i = 0; i < 100; i++) {
>                 if (waitpid(-1, status, WNOHANG | __WALL) == pid)
>                         return;
>                 usleep(1000);
>         }
>         DIR* dir = opendir("/sys/fs/fuse/connections");
>         if (dir) {
>                 for (;;) {
>                         struct dirent* ent = readdir(dir);
>                         if (!ent)
>                                 break;
>                         if (strcmp(ent->d_name, ".") == 0 || strcmp(ent->d_name, "..") == 0)
>                                 continue;
>                         char abort[300];
>                         snprintf(abort, sizeof(abort), "/sys/fs/fuse/connections/%s/abort",
> ent->d_name);
>                         int fd = open(abort, O_WRONLY);
>                         if (fd == -1) {
>                                 continue;
>                         }
>                         if (write(fd, abort, 1) < 0) {
>                         }
>                         close(fd);
>                 }
>                 closedir(dir);
>         } else {
>         }
>         while (waitpid(-1, status, __WALL) != pid) {
>         }
> }
>
> static void setup_test()
> {
>         prctl(PR_SET_PDEATHSIG, SIGKILL, 0, 0, 0);
>         setpgrp();
>         write_file("/proc/self/oom_score_adj", "1000");
> }
>
> static void execute_one(void);
>
> #define WAIT_FLAGS __WALL
>
> static void loop(void)
> {
>         int iter = 0;
>         for (;; iter++) {
>                 int pid = fork();
>                 if (pid < 0)
>         exit(1);
>                 if (pid == 0) {
>                         setup_test();
>                         execute_one();
>                         exit(0);
>                 }
>                 int status = 0;
>                 uint64_t start = current_time_ms();
>                 for (;;) {
>                         if (waitpid(-1, &status, WNOHANG | WAIT_FLAGS) == pid)
>                                 break;
>                         sleep_ms(1);
>                 if (current_time_ms() - start < 5000) {
>                         continue;
>                 }
>                         kill_and_wait(pid, &status);
>                         break;
>                 }
>         }
> }
>
> #ifndef __NR_bpf
> #define __NR_bpf 361
> #endif
> #ifndef __NR_mmap
> #define __NR_mmap 90
> #endif
>
> uint64_t r[1] = {0xffffffffffffffff};
>
> void execute_one(void)
> {
>                 intptr_t res = 0;
> *(uint32_t*)0x20000280 = 9;
> *(uint32_t*)0x20000284 = 1;
> *(uint32_t*)0x20000288 = 6;
> *(uint32_t*)0x2000028c = 5;
> *(uint32_t*)0x20000290 = 0;
> *(uint32_t*)0x20000294 = -1;
> *(uint32_t*)0x20000298 = 0;
> *(uint8_t*)0x2000029c = 0;
> *(uint8_t*)0x2000029d = 0;
> *(uint8_t*)0x2000029e = 0;
> *(uint8_t*)0x2000029f = 0;
> *(uint8_t*)0x200002a0 = 0;
> *(uint8_t*)0x200002a1 = 0;
> *(uint8_t*)0x200002a2 = 0;
> *(uint8_t*)0x200002a3 = 0;
> *(uint8_t*)0x200002a4 = 0;
> *(uint8_t*)0x200002a5 = 0;
> *(uint8_t*)0x200002a6 = 0;
> *(uint8_t*)0x200002a7 = 0;
> *(uint8_t*)0x200002a8 = 0;
> *(uint8_t*)0x200002a9 = 0;
> *(uint8_t*)0x200002aa = 0;
> *(uint8_t*)0x200002ab = 0;
> *(uint32_t*)0x200002ac = 0;
> *(uint32_t*)0x200002b0 = -1;
> *(uint32_t*)0x200002b4 = 0;
> *(uint32_t*)0x200002b8 = 0;
> *(uint32_t*)0x200002bc = 0;
>         res = syscall(__NR_bpf, 0ul, 0x20000280ul, 0x40ul);
>         if (res != -1)
>                 r[0] = res;
> *(uint64_t*)0x20000100 = 0;
> *(uint64_t*)0x20000108 = 0;
> *(uint64_t*)0x20000110 = 0x200002c0;
> *(uint64_t*)0x20000118 = 0x20000000;
> *(uint32_t*)0x20000120 = 0x1000;
> *(uint32_t*)0x20000124 = r[0];
> *(uint64_t*)0x20000128 = 0;
> *(uint64_t*)0x20000130 = 0;
>         syscall(__NR_bpf, 0x1aul, 0x20000100ul, 0x38ul);
>
> }
> int main(void)
> {
>                 syscall(__NR_mmap, 0x1fff0000ul, 0x10000ul, 0ul, 0x32ul, -1, 0ul);
>         syscall(__NR_mmap, 0x20000000ul, 0x1000000ul, 7ul, 0x32ul, -1, 0ul);
>         syscall(__NR_mmap, 0x21000000ul, 0x10000ul, 0ul, 0x32ul, -1, 0ul);
>         for (procid = 0; procid < 16; procid++) {
>                 if (fork() == 0) {
>                         loop();
>                 }
>         }
>         sleep(1000000);
>         return 0;
> }
>
>
>
>
> --
> Alexey
