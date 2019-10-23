Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13BDFE0FB6
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 03:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733232AbfJWBfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 21:35:16 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36164 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732328AbfJWBfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 21:35:16 -0400
Received: by mail-pf1-f196.google.com with SMTP id y22so11832097pfr.3;
        Tue, 22 Oct 2019 18:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=sVxBR4j3UbPCGxSucg6YKBL4mZZkWsBKL7S+CBlzoj4=;
        b=UNwzboz1mUdLpVOtkcq9tNY6KSjXVug3okwsDTDIySbu8dQTtsxxqn50agPXUqaR3S
         OZhQ0G40mtQAWQLbM0EIMUPd7rT7MELl51wjxQOsbI2hqV+rZwwdA0+kq9Bq1W6R7h2J
         i6XU1IhzGh5zvVV0rc24v+eAA+RMW9E03zInWgQjBwhub2AodCWdbQyolK6JzBaMZMld
         Ku8m9AYhFnO+c+KR1npe96ROsYAHLQ79+6IZKqRCjxJye0fLar7Tldjv3TO5al4mVNLC
         sFbdC+TKrATW1l/S9QxhH0hkMZxAHi8cqQEiU4cdtOUoMvmobPZikzaPtzLx7GFyVL8T
         ggbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=sVxBR4j3UbPCGxSucg6YKBL4mZZkWsBKL7S+CBlzoj4=;
        b=FteSLRwlR8c0X/hUBr1G7U+TEB2GgJfBhSYoMoyvjcyeB+mEdafXwqkM1G9EG8mUlC
         Q14IkjXLxitQ5r32OupObTjnrc6wxPQ2E1R1XNCxLqH6tpxK0w9E3MMhtzf74RMRid+x
         ReQeqjUz7VLP/xAaOHk1zCg4dge6hBaAh2QXy7bp+ZIf8e3NtrmsJLcLzH3aTcBQzSJx
         GGps5sRSBDXvwnV4juKNXHDssKkuVnHz+9f+P9InemihhH0ocyMIghDS7HxuHnqnJOeR
         GKKBO7Ki1QOxTt96KUzzXlogxLfl4FNOvqKjh0mgRotM+fOHxqglBkev7beMVmzoVsD2
         oCSQ==
X-Gm-Message-State: APjAAAUqhcaS8I9ECOlalA4RoZziTDZyokTMdmpEkHMlDZ0CJhoN6P2s
        zpomfHejbgq4M98aVIJlQi8Lwdte
X-Google-Smtp-Source: APXvYqxWdU7vwCZTpqi4gKdDzclKCvarcZjw+RngLyJixn/yMXyttLyD/cnOJSl42MwV+53qWKeIIw==
X-Received: by 2002:a17:90a:24ab:: with SMTP id i40mr8320800pje.121.1571794515106;
        Tue, 22 Oct 2019 18:35:15 -0700 (PDT)
Received: from [192.168.31.113] ([43.224.157.60])
        by smtp.gmail.com with ESMTPSA id q2sm29867893pfg.144.2019.10.22.18.35.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Oct 2019 18:35:14 -0700 (PDT)
To:     yhs@fb.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
From:   Prabhakar Kushwaha <prabhakar.pkin@gmail.com>
Subject: Linux-5.4: bpf: test_core_reloc_arrays.o: Segmentation fault with llc
 -march=bpf
Message-ID: <8080a9a2-82f1-20b5-8d5d-778536f91780@gmail.com>
Date:   Wed, 23 Oct 2019 07:05:05 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


 Adding other mailing list, folks...

Hi All,

I am trying to build kselftest on Linux-5.4 on ubuntu 18.04. I installed
LLVM-9.0.0 and Clang-9.0.0 from below links after following steps from
[1] because of discussion [2]

 https://releases.llvm.org/9.0.0/llvm-9.0.0.src.tar.xz
 https://releases.llvm.org/9.0.0/clang-tools-extra-9.0.0.src.tar.xz
 https://releases.llvm.org/9.0.0/cfe-9.0.0.src.tar.xz

Now, i am trying with llc -march=bpf, with this segmentation fault is
coming as below:

gcc -g -Wall -O2 -I../../../include/uapi -I../../../lib
-I../../../lib/bpf -I../../../../include/generated -DHAVE_GENHDR
-I../../../include -Dbpf_prog_load=bpf_prog_test_load
-Dbpf_load_program=bpf_test_load_program    test_flow_dissector.c
/usr/src/tovards/linux/tools/testing/selftests/bpf/test_stub.o
/usr/src/tovards/linux/tools/testing/selftests/bpf/libbpf.a -lcap -lelf
-lrt -lpthread -o
/usr/src/tovards/linux/tools/testing/selftests/bpf/test_flow_dissector
gcc -g -Wall -O2 -I../../../include/uapi -I../../../lib
-I../../../lib/bpf -I../../../../include/generated -DHAVE_GENHDR
-I../../../include -Dbpf_prog_load=bpf_prog_test_load
-Dbpf_load_program=bpf_test_load_program
test_tcp_check_syncookie_user.c
/usr/src/tovards/linux/tools/testing/selftests/bpf/test_stub.o
/usr/src/tovards/linux/tools/testing/selftests/bpf/libbpf.a -lcap -lelf
-lrt -lpthread -o
/usr/src/tovards/linux/tools/testing/selftests/bpf/test_tcp_check_syncookie_user
gcc -g -Wall -O2 -I../../../include/uapi -I../../../lib
-I../../../lib/bpf -I../../../../include/generated -DHAVE_GENHDR
-I../../../include -Dbpf_prog_load=bpf_prog_test_load
-Dbpf_load_program=bpf_test_load_program    test_lirc_mode2_user.c
/usr/src/tovards/linux/tools/testing/selftests/bpf/test_stub.o
/usr/src/tovards/linux/tools/testing/selftests/bpf/libbpf.a -lcap -lelf
-lrt -lpthread -o
/usr/src/tovards/linux/tools/testing/selftests/bpf/test_lirc_mode2_user
(clang -I. -I./include/uapi -I../../../include/uapi
-I/usr/src/tovards/linux/tools/testing/selftests/bpf/../usr/include
-D__TARGET_ARCH_arm64 -g -idirafter /usr/local/include -idirafter
/usr/local/lib/clang/9.0.0/include -idirafter
/usr/include/aarch64-linux-gnu -idirafter /usr/include
-Wno-compare-distinct-pointer-types -O2 -target bpf -emit-llvm \
-c progs/test_core_reloc_arrays.c -o - || echo "clang failed") | \
llc -march=bpf -mcpu=probe  -filetype=obj -o
/usr/src/tovards/linux/tools/testing/selftests/bpf/test_core_reloc_arrays.o
Stack dump:
0. Program arguments: llc -march=bpf -mcpu=probe -filetype=obj -o
/usr/src/tovards/linux/tools/testing/selftests/bpf/test_core_reloc_arrays.o
1. Running pass 'Function Pass Manager' on module '<stdin>'.
2. Running pass 'BPF Assembly Printer' on function '@test_core_arrays'
#0 0x0000aaaac618db08 llvm::sys::PrintStackTrace(llvm::raw_ostream&)
(/usr/local/bin/llc+0x152eb08)
Segmentation fault
Makefile:260: recipe for target
'/usr/src/tovards/linux/tools/testing/selftests/bpf/test_core_reloc_arrays.o'
failed
make[1]: ***
[/usr/src/tovards/linux/tools/testing/selftests/bpf/test_core_reloc_arrays.o]
Error 139

To add more details,
Commenting following lines in bpf/progs/test_core_reloc_arrays.c
removes the segmentation fault.

--- a/tools/testing/selftests/bpf/progs/test_core_reloc_arrays.c
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_arrays.c
@@ -41,15 +41,14 @@ int test_core_arrays(void *ctx)
        if (BPF_CORE_READ(&out->a2, &in->a[2]))
                return 1;
        /* in->b[1][2][3] */
-       if (BPF_CORE_READ(&out->b123, &in->b[1][2][3]))
-               return 1;
+//     if (BPF_CORE_READ(&out->b123, &in->b[1][2][3]))
+//             return 1;
        /* in->c[1].c */
        if (BPF_CORE_READ(&out->c1c, &in->c[1].c))
                return 1;
        /* in->d[0][0].d */
-       if (BPF_CORE_READ(&out->d00d, &in->d[0][0].d))
-               return 1;
-
+//     if (BPF_CORE_READ(&out->d00d, &in->d[0][0].d))
+//             return 1;
        return 0;
 }

It looks to be something related llc and more than 1 dimension array.
has anyone faced such error.

Please suggest!!

--prabhakar(pk)

[1]
https://stackoverflow.com/questions/47255526/how-to-build-the-latest-clang-tidy

[2] https://www.mail-archive.com/netdev@vger.kernel.org/msg315096.html


Linux top-commit
----------------
commit bc88f85c6c09306bd21917e1ae28205e9cd775a7 (HEAD -> master,
origin/master, origin/HEAD)
Author: Ben Dooks <ben.dooks@codethink.co.uk>
Date:   Wed Oct 16 12:24:58 2019 +0100

    kthread: make __kthread_queue_delayed_work static

    The __kthread_queue_delayed_work is not exported so
    make it static, to avoid the following sparse warning:

      kernel/kthread.c:869:6: warning: symbol
'__kthread_queue_delayed_work' was not declared. Should it be static?

    Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

