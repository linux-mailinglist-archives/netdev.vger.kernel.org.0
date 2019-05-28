Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC3852C1E2
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 10:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbfE1I5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 04:57:32 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:59818 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbfE1I5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 04:57:31 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 91DE460769; Tue, 28 May 2019 08:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559033850;
        bh=TgsQrhlAr8+HGUCtRPh+X0roiBK76Jmwa9FHWZ3CYwk=;
        h=From:To:Subject:Date:From;
        b=jWQLv7/yIfMOCqIB7OYFqqD7NWH9ddNquMMJM7BfEVn51RUPPd8B6HT2Ia3+tBZz3
         Dd6guQPiEPcCWLRiOpohiSms4UzdpfQ7F4Kqv6l3hdDyPprGSwzX5dQ5G0WaE6CPYA
         Z45N6/HRBg/5DrrU7x0Qifq4qapZCJgHRBI0spYs=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from [10.204.79.132] (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: sramana@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E163960388;
        Tue, 28 May 2019 08:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559033849;
        bh=TgsQrhlAr8+HGUCtRPh+X0roiBK76Jmwa9FHWZ3CYwk=;
        h=From:To:Subject:Date:From;
        b=oe/dIn+8/UU6B1YK8E2iohtQVRl0V6O3zajEK2Cpp70PgWnUCVMtSiNEs7fvXtl9v
         +WwgNbZDMMgXVxBt6+iu6yGQ1zxLJJbWrGAz2uM5asnK1PUmRwyxfnCc6vNiVWHj+E
         xxLd+gkcvMg6tZpbmfWTiENruooo/R368IT9mM0o=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E163960388
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=sramana@codeaurora.org
From:   Srinivas Ramana <sramana@codeaurora.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: samples/bpf compilation failures - 5.2.0
Message-ID: <faaf8b1c-9552-a0ae-3088-2f4255dff857@codeaurora.org>
Date:   Tue, 28 May 2019 14:27:25 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I am trying to build samples/bpf in kernel(5.2.0-rc1) but unsuccessful 
with below errors. Can you help to point what i am missing or if there 
is some known issue?

==============================8<===================================
$ make samples/bpf/ 
LLC=/local/mnt/workspace/tools/clang_ubuntu/clang/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/llc 
CLANG=/local/mnt/workspace/tools/clang_ubuntu/clang/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/clang 
V=1
make -C /local/mnt/workspace/sramana/kdev_torvalds/kdev/kernel -f 
/local/mnt/workspace/sramana/kdev_torvalds/kdev/kernel/Makefile samples/bpf/
................
................
................
make KBUILD_MODULES=1 -f ./scripts/Makefile.build obj=samples/bpf
(cat /dev/null; ) > samples/bpf/modules.order
make -C 
/local/mnt/workspace/sramana/kdev_torvalds/kdev/kernel/samples/bpf/../../tools/lib/bpf/ 
RM='rm -rf' LDFLAGS= 
srctree=/local/mnt/workspace/sramana/kdev_torvalds/kdev/kernel/samples/bpf/../../ 
O=

Auto-detecting system features:
...                        libelf: [ on  ]
...                           bpf: [ on  ]

make -C 
/local/mnt/workspace/sramana/kdev_torvalds/kdev/kernel/samples/bpf/../..//tools/build 
CFLAGS= LDFLAGS= fixdep
make -f 
/local/mnt/workspace/sramana/kdev_torvalds/kdev/kernel/samples/bpf/../..//tools/build/Makefile.build 
dir=. obj=fixdep
    ld -r -o fixdep-in.o  fixdep.o
ld: fixdep.o: Relocations in generic ELF (EM: 183)
ld: fixdep.o: Relocations in generic ELF (EM: 183)
fixdep.o: error adding symbols: File in wrong format
make[5]: *** [fixdep-in.o] Error 1
make[4]: *** [fixdep-in.o] Error 2
make[3]: *** [fixdep] Error 2
make[2]: *** 
[/local/mnt/workspace/sramana/kdev_torvalds/kdev/kernel/samples/bpf/../../tools/lib/bpf/libbpf.a] 
Error 2
make[1]: *** [samples/bpf/] Error 2
make: *** [sub-make] Error 2
==============================>8=======================================


I am using the below commands to build:
========================================================
export ARCH=arm64
export CROSS_COMPILE=<path>linaro-toolchain/5.1/bin/aarch64-linux-gnu-
export CLANG_TRIPLE=arm64-linux-gnu-

make 
CC=<path>/clang_ubuntu/clang/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/clang 
defconfig

make 
CC=<path>/clang_ubuntu/clang/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/clang 
-j8

make 
CC=<path>/clang_ubuntu/clang/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/clang 
headers_install INSTALL_HDR_PATH=./usr

make samples/bpf/ 
LLC=<path>/clang_ubuntu/clang/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/llc 
CLANG=<path>/clang_ubuntu/clang/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/clang 
V=1 
CC=<path>/clang_ubuntu/clang/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/clang
========================================================

Thanks,
-- Srinivas R

-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation
Center, Inc., is a member of Code Aurora Forum, a Linux Foundation
Collaborative Project
