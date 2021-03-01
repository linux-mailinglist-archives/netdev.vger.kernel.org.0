Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD5FF3283CD
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 17:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232132AbhCAQY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 11:24:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237577AbhCAQWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 11:22:23 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93988C06178B;
        Mon,  1 Mar 2021 08:21:41 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id o38so11892147pgm.9;
        Mon, 01 Mar 2021 08:21:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nAKyn3bbJ2e2Np3T3RRoME/8+DrtqnaJzTBb2u34x6M=;
        b=TMeEpeZTLo6HRYujk8PBneLGc2y147GZ/ksJNcuMO9S7ibrJNliVkb+UVawC+AV9mD
         TOigQMYkQMLoLvl4VCfqKjgLGHSIFiFitf0dzhut23N6eADCkbF7Rm6xr2OuismTftil
         qvvP7lWd1fvH6HFJNla7+hfz60R4CuM2TDIIXkXJWKKI85TP1nprBFKhnk4geUPzvb2y
         W1LZTAE/jL9qQWZEn6vjodzDlENRjO21LGTVSg04JN6FcKP0f/xv+e8/rscEUqZKF0kF
         jX2nLkkf1g1Z269WaPpbg3krjLidZNn3qdVeQqD9/GhdAP8oX4pyFdPFu7m2/cFmTDpf
         BnCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nAKyn3bbJ2e2Np3T3RRoME/8+DrtqnaJzTBb2u34x6M=;
        b=VWcq/DWUBM81q8/arqyMnomKyfrxD0ZmKNFUJs42UOX/b+1IychgPBtbTzVnZkbKFF
         fcIOc4TalCO9cH1GGKMKzL+bJ4V6sqmAvShc02nrYBALw1glh9LC/ClOwvGII4T6II96
         ZidH6Sdt/9z9tLvKIagWp6bvoMldvuqcuRN1fJPNPblN+4jI2bhIk7sxFl3kMGcEFWhw
         QWhGnK8w17WsclaYp7NLf/1a1TMFHcp4YAiMb8sejWBz+d0ZKDXePX1Gkk9EGT7lHoUz
         JgDGGdOdJTT43gs4JNV/5cMCrWftGm9l8lMNFBPlSUP098+Osyp0fGpPiQ4Dg/vmS/bb
         FCfA==
X-Gm-Message-State: AOAM533I0ydSBZ0iphtwTzKhP20DgxWZqGqHU0vlTnXy+odRua8QHZtV
        B5RrlNaecsv7QuUbuWrL6zU=
X-Google-Smtp-Source: ABdhPJz/9vJH0D7oCD0gvcN15JwVpe6nu6ezSu/irxMjX9Zo5zpRZYsAxWXobc5gW6fKPnvHOnaBAg==
X-Received: by 2002:a63:f913:: with SMTP id h19mr14480486pgi.413.1614615701065;
        Mon, 01 Mar 2021 08:21:41 -0800 (PST)
Received: from nuc10 (104.36.148.139.aurocloud.com. [104.36.148.139])
        by smtp.gmail.com with ESMTPSA id p7sm16470671pgg.2.2021.03.01.08.21.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 08:21:40 -0800 (PST)
Date:   Mon, 1 Mar 2021 08:21:33 -0800
From:   Rustam Kovhaev <rkovhaev@gmail.com>
To:     syzbot <syzbot+f3694595248708227d35@syzkaller.appspotmail.com>
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@chromium.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com, dvyukov@google.com,
        gregkh@linuxfoundation.org
Subject: Re: memory leak in bpf
Message-ID: <YD0UjWjQmYgY4Qgh@nuc10>
References: <000000000000911d3905b459824c@google.com>
 <000000000000e56a2605b616b2d9@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000e56a2605b616b2d9@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 09, 2020 at 10:58:10PM -0800, syzbot wrote:
> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    a68a0262 mm/madvise: remove racy mm ownership check
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=11facf17500000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=4305fa9ea70c7a9f
> dashboard link: https://syzkaller.appspot.com/bug?extid=f3694595248708227d35
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=159a9613500000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11bf7123500000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+f3694595248708227d35@syzkaller.appspotmail.com
> 
> Debian GNU/Linux 9 syzkaller ttyS0
> Warning: Permanently added '10.128.0.9' (ECDSA) to the list of known hosts.
> executing program
> executing program
> executing program
> BUG: memory leak
> unreferenced object 0xffff88810efccc80 (size 64):
>   comm "syz-executor334", pid 8460, jiffies 4294945724 (age 13.850s)
>   hex dump (first 32 bytes):
>     c0 cb 14 04 00 ea ff ff c0 c2 11 04 00 ea ff ff  ................
>     c0 56 3f 04 00 ea ff ff 40 18 38 04 00 ea ff ff  .V?.....@.8.....
>   backtrace:
>     [<0000000036ae98a7>] kmalloc_node include/linux/slab.h:575 [inline]
>     [<0000000036ae98a7>] bpf_ringbuf_area_alloc kernel/bpf/ringbuf.c:94 [inline]
>     [<0000000036ae98a7>] bpf_ringbuf_alloc kernel/bpf/ringbuf.c:135 [inline]
>     [<0000000036ae98a7>] ringbuf_map_alloc kernel/bpf/ringbuf.c:183 [inline]
>     [<0000000036ae98a7>] ringbuf_map_alloc+0x1be/0x410 kernel/bpf/ringbuf.c:150
>     [<00000000d2cb93ae>] find_and_alloc_map kernel/bpf/syscall.c:122 [inline]
>     [<00000000d2cb93ae>] map_create kernel/bpf/syscall.c:825 [inline]
>     [<00000000d2cb93ae>] __do_sys_bpf+0x7d0/0x30a0 kernel/bpf/syscall.c:4381
>     [<000000008feaf393>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>     [<00000000e1f53cfd>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> 

i am pretty sure that this one is a false positive
the problem with reproducer is that it does not terminate all of the
child processes that it spawns

i confirmed that it is a false positive by tracing __fput() and
bpf_map_release(), i ran reproducer, got kmemleak report, then i
manually killed those running leftover processes from reproducer and
then both functions were executed and memory was freed

i am marking this one as:
#syz invalid

