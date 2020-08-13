Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24AAC2435F0
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 10:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgHMI1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 04:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgHMI1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 04:27:19 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED17C061757
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 01:27:19 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id h22so4144334otq.11
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 01:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=u1xn8UpsZMkA1fV4YHdXKJuRl8t4d1zVqka+PMvAPEA=;
        b=bxPfP4cACCpTvvvJVFKZaeecGgU3Jro0TnuoqDKJlVsMLc2iZVOTml4+ykluiKm8zt
         eT5iumckvE0OruFF1YQzgcSYbTsXEEUatVSc29IO0AE/u7oP5bI7i+5xuk4+HhaVdyty
         xd0g8z3X46b4lcyYi7RcRSTAoW1pg0WQRIlBrDxW1C4BALWbHr1ls0oSdNnUNHqfrnRS
         8dDWWaOSfRyxysJHRU1e76PyTg2/MKX1QIHPOcLLUuNBcB85MS+mqdpScZnxFYQSNtZS
         8t3qz8543Z72K7KBModDVeyw3/uXsNpfA1nhsBvEL62xM1JDBYa4xUPast+jjF9hDIk9
         0efA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=u1xn8UpsZMkA1fV4YHdXKJuRl8t4d1zVqka+PMvAPEA=;
        b=jjmvbdkKAK9v70Lh/voe+xDdBbXU4Xg9eXNY7Nep4l2z6DTZPFtTegE2TpW7nmYPQx
         Q/Y5Un3TVa2eWIisnj7fJExP7MyIo8neAnNohk8MxGidiLI6wGKr0inKxHrtWlfaNRhz
         08sNjV2/Q7LIZG4sWQVSPRgc7SUrWi/Uar/KpLlFHCYu0iBZ2EwWUJVSwPvcl9JlmmbY
         KBefHQRXxwz7UxAuPiydQV8TDOJBbWiUEK8uVoMgRb3F986NE4X2K357pkX93+VDDCJl
         Cyyr36BiMgH4V+DSafjJyW2yTEVRGXXUyWDPjgJR+OZJrCv/nUgnCHrI8JtEi+KRB7k5
         OoQQ==
X-Gm-Message-State: AOAM533C49sSFfuwazC6BLVM/tTBe38RxGX91ufVvQZ/s1ori8eC84uG
        JBsbrMXShxWYztoOMNsrHeQhAbcb5zFo4K+jlqQ=
X-Google-Smtp-Source: ABdhPJxpDvdjqUh9ZNeFBpG8dviojzUmJNUT2qML3OQXzs0cdgfv6saF/g3TQKfvc63wypJMg8+x6wH7MCS79D+14oo=
X-Received: by 2002:a9d:7997:: with SMTP id h23mr3470604otm.28.1597307235773;
 Thu, 13 Aug 2020 01:27:15 -0700 (PDT)
MIME-Version: 1.0
References: <CA+icZUVnsmf1kXPYFYufStQ_MxnLuxL+EWfDS2wQy1VbAEMwkA@mail.gmail.com>
 <20200809235412.GD25124@SDF.ORG> <20200810034948.GB8262@1wt.eu>
 <20200811053455.GH25124@SDF.ORG> <20200811054328.GD9456@1wt.eu>
 <20200811062814.GI25124@SDF.ORG> <20200811074538.GA9523@1wt.eu>
 <CA+icZUVkaKorjHb4PSh1pKnYVF7696cfqH_Q87HsNpy9Qx9mxQ@mail.gmail.com>
 <20200812032139.GA10119@1wt.eu> <CA+icZUXS2OPFuEkDC2oHDd344efkbAoq_oP0agqrvWD5FHDXGA@mail.gmail.com>
 <20200813080646.GB10907@1wt.eu> <CA+icZUWiXyP-s+=V9xy00ZwjaSQKZ9GOG_cvkCetNTVYHNipGg@mail.gmail.com>
In-Reply-To: <CA+icZUWiXyP-s+=V9xy00ZwjaSQKZ9GOG_cvkCetNTVYHNipGg@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Thu, 13 Aug 2020 10:27:04 +0200
Message-ID: <CA+icZUUdtRm7uHPT=TtT1BEE0dQU3pFP-nvqwBE7ES1F_kvXSA@mail.gmail.com>
Subject: Re: [DRAFT PATCH] random32: make prandom_u32() output unpredictable
To:     George Spelvin <lkml@sdf.org>
Cc:     Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, Willy Tarreau <w@1wt.eu>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I run a perf session looks like this in my KDE/Plasma desktop-environment:

[ PERF SESSION ]

 1016  2020-08-13 09:57:24 echo 1 > /proc/sys/kernel/sched_schedstats
 1017  2020-08-13 09:57:24 echo prandom_u32 >>
/sys/kernel/debug/tracing/set_event
 1018  2020-08-13 09:57:24 echo traceon >
/sys/kernel/debug/tracing/events/random/prandom_u32/trigger
 1019  2020-08-13 09:57:25 echo 1 > /sys/kernel/debug/tracing/events/enable

 1020  2020-08-13 09:57:32 sysctl -n kernel.sched_schedstats
 1021  2020-08-13 09:57:32 cat /sys/kernel/debug/tracing/events/enable
 1022  2020-08-13 09:57:32 grep prandom_u32 /sys/kernel/debug/tracing/set_event
 1023  2020-08-13 09:57:33 cat
/sys/kernel/debug/tracing/events/random/prandom_u32/trigger

root# /home/dileks/bin/perf record -a -g -e random:prandom_u32 sleep 5

Simple-Test: Press F5 in Firefox in each opened tab (5 tabs in total)

root# /home/dileks/bin/perf report --no-children --stdio > /tmp/perf-report.txt

- Sedat -

[ perf-report.txt ]

# To display the perf.data header info, please use
--header/--header-only options.
#
#
# Total Lost Samples: 0
#
# Samples: 273  of event 'random:prandom_u32'
# Event count (approx.): 273
#
# Overhead  Command          Shared Object      Symbol
# ........  ...............  .................  ...............
#
    27.47%  firefox-esr      [kernel.kallsyms]  [k] prandom_u32
            |
            ---prandom_u32
               prandom_u32
               shmem_get_inode
               shmem_mknod
               path_openat
               do_filp_open
               do_sys_openat2
               __x64_sys_openat
               do_syscall_64
               entry_SYSCALL_64_after_hwframe
               __open64
               0x7a6f6d2e67726f2f

    13.19%  DNS Resolver #9  [kernel.kallsyms]  [k] prandom_u32
            |
            ---prandom_u32
               prandom_u32
               |
               |--5.86%--__ip4_datagram_connect
               |          ip4_datagram_connect
               |          __sys_connect
               |          __x64_sys_connect
               |          do_syscall_64
               |          entry_SYSCALL_64_after_hwframe
               |          |
               |          |--4.40%--__libc_connect
               |          |          0x2c1
               |          |
               |           --1.47%--connect
               |                     PR_GetAddrInfoByName
               |
               |--2.93%--udp_lib_get_port
               |          inet_dgram_connect
               |          __sys_connect
               |          __x64_sys_connect
               |          do_syscall_64
               |          entry_SYSCALL_64_after_hwframe
               |          |
               |          |--2.20%--__libc_connect
               |          |          0x2c1
               |          |
               |           --0.73%--connect
               |                     PR_GetAddrInfoByName
               |
               |--2.20%--__ip_select_ident
               |          __ip_make_skb
               |          ip_make_skb
               |          udp_sendmsg
               |          __sys_sendto
               |          __x64_sys_sendto
               |          do_syscall_64
               |          entry_SYSCALL_64_after_hwframe
               |          __libc_send
               |
                --2.20%--netlink_autobind
                          netlink_bind
                          __sys_bind
                          __x64_sys_bind
                          do_syscall_64
                          entry_SYSCALL_64_after_hwframe
                          bind
                          getaddrinfo
                          PR_GetAddrInfoByName

    12.45%  FS Broker 7060   [kernel.kallsyms]  [k] prandom_u32
            |
            ---prandom_u32
               prandom_u32
               shmem_get_inode
               shmem_mknod
               path_openat
               do_filp_open
               do_sys_openat2
               __x64_sys_openat
               do_syscall_64
               entry_SYSCALL_64_after_hwframe
               __open64
               0x7a6f6d2e67726f2f

     8.79%  FS Broker 6334   [kernel.kallsyms]  [k] prandom_u32
            |
            ---prandom_u32
               prandom_u32
               shmem_get_inode
               shmem_mknod
               path_openat
               do_filp_open
               do_sys_openat2
               __x64_sys_openat
               do_syscall_64
               entry_SYSCALL_64_after_hwframe
               __open64
               0x7a6f6d2e67726f2f

     8.06%  FS Broker 7161   [kernel.kallsyms]  [k] prandom_u32
            |
            ---prandom_u32
               prandom_u32
               shmem_get_inode
               shmem_mknod
               path_openat
               do_filp_open
               do_sys_openat2
               __x64_sys_openat
               do_syscall_64
               entry_SYSCALL_64_after_hwframe
               __open64
               0x7a6f6d2e67726f2f

     8.06%  FS Broker 7195   [kernel.kallsyms]  [k] prandom_u32
            |
            ---prandom_u32
               prandom_u32
               shmem_get_inode
               shmem_mknod
               path_openat
               do_filp_open
               do_sys_openat2
               __x64_sys_openat
               do_syscall_64
               entry_SYSCALL_64_after_hwframe
               __open64
               0x7a6f6d2e67726f2f

     7.33%  FS Broker 7126   [kernel.kallsyms]  [k] prandom_u32
            |
            ---prandom_u32
               prandom_u32
               shmem_get_inode
               shmem_mknod
               path_openat
               do_filp_open
               do_sys_openat2
               __x64_sys_openat
               do_syscall_64
               entry_SYSCALL_64_after_hwframe
               __open64
               0x7a6f6d2e67726f2f

     7.33%  Socket Thread    [kernel.kallsyms]  [k] prandom_u32
            |
            ---prandom_u32
               prandom_u32
               tcp_v4_connect
               __inet_stream_connect
               inet_stream_connect
               __sys_connect
               __x64_sys_connect
               do_syscall_64
               entry_SYSCALL_64_after_hwframe
               __libc_connect

     4.40%  Cache2 I/O       [kernel.kallsyms]  [k] prandom_u32
            |
            ---prandom_u32
               prandom_u32
               __ext4_new_inode
               ext4_create
               path_openat
               do_filp_open
               do_sys_openat2
               __x64_sys_openat
               do_syscall_64
               entry_SYSCALL_64_after_hwframe
               __open64
               0x61632e2f736b656c

     1.10%  Xorg             [kernel.kallsyms]  [k] prandom_u32
            |
            ---prandom_u32
               prandom_u32
               shmem_get_inode
               __shmem_file_setup
               create_shmem
               i915_gem_object_create_region
               i915_gem_create_ioctl
               drm_ioctl_kernel
               drm_ioctl
               __se_sys_ioctl
               do_syscall_64
               entry_SYSCALL_64_after_hwframe
               ioctl

     0.73%  QSGRenderThread  [kernel.kallsyms]  [k] prandom_u32
            |
            ---prandom_u32
               prandom_u32
               shmem_get_inode
               __shmem_file_setup
               create_shmem
               i915_gem_object_create_region
               i915_gem_create_ioctl
               drm_ioctl_kernel
               drm_ioctl
               __se_sys_ioctl
               do_syscall_64
               entry_SYSCALL_64_after_hwframe
               ioctl

     0.37%  DOM Worker       [kernel.kallsyms]  [k] prandom_u32
            |
            ---prandom_u32
               prandom_u32
               __ext4_new_inode
               ext4_create
               path_openat
               do_filp_open
               do_sys_openat2
               __x64_sys_openat
               do_syscall_64
               entry_SYSCALL_64_after_hwframe
               __open64
               0x6f6d2e2f736b656c

     0.37%  cupsd            [kernel.kallsyms]  [k] prandom_u32
            |
            ---prandom_u32
               prandom_u32
               __ext4_new_inode
               ext4_create
               path_openat
               do_filp_open
               do_sys_openat2
               __x64_sys_openat
               do_syscall_64
               entry_SYSCALL_64_after_hwframe
               __open64
               0x7263736275732f73

     0.37%  mozStorage #8    [kernel.kallsyms]  [k] prandom_u32
            |
            ---prandom_u32
               prandom_u32
               __ext4_new_inode
               ext4_create
               path_openat
               do_filp_open
               do_sys_openat2
               __x64_sys_openat
               do_syscall_64
               entry_SYSCALL_64_after_hwframe
               __open64
               0x6f6d2e2f736b656c



# Samples: 0  of event 'dummy:HG'
# Event count (approx.): 0
#
# Overhead  Command  Shared Object  Symbol
# ........  .......  .............  ......
#


#
# (Tip: Print event counts in CSV format with: perf stat -x,)
#

- EOF -
