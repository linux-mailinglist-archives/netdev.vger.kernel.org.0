Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE43561CC
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 07:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbfFZFln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 01:41:43 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:58740 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbfFZFln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 01:41:43 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 8B0EA60A44; Wed, 26 Jun 2019 05:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561527702;
        bh=rOANm5p9pKCQ2t+c5PR83Bj3wh6eUweI1Pjq/QmmtpA=;
        h=Subject:From:To:References:Date:In-Reply-To:From;
        b=BMrDpYAppRirCBGRyLDQrz4jAvRFoTIy8mNSyfwQzl1E8tDTIatvg/B9ide5DYbBQ
         7WfCmdWP1Ks6ZfDOxHyTT+1U6IJ1jdqf2BzD6FIjey1YybzaHPe/mBfs2IcMHqQeAM
         Nta7NuYUdenpCz3mwmFjZIGbxEVr0c5rpZmbUv4c=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9FC586085C;
        Wed, 26 Jun 2019 05:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561527701;
        bh=rOANm5p9pKCQ2t+c5PR83Bj3wh6eUweI1Pjq/QmmtpA=;
        h=Subject:From:To:References:Date:In-Reply-To:From;
        b=mjrFU13eOcPHmFNZKRUWY/THAftJo//TyUSDdUM9V4cDJWT3geaiUoCHzzTvxflDt
         pck+eIJjFaaSryy0rjdRUpAk1Pt3Vn9Kfk0GRy7S+SEmDtcWyjCyiFJotob1axLITX
         UlPx7MZc1hC80dHdWyS+klVDmkKSACsxj9AhDUXU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9FC586085C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=sramana@codeaurora.org
Subject: Re: samples/bpf compilation failures - 5.2.0
From:   Srinivas Ramana <sramana@codeaurora.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Joel Fernandes <joelaf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
References: <faaf8b1c-9552-a0ae-3088-2f4255dff857@codeaurora.org>
Message-ID: <0bcdd38c-5cdb-0510-573a-9a6098ab2105@codeaurora.org>
Date:   Wed, 26 Jun 2019 11:11:37 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <faaf8b1c-9552-a0ae-3088-2f4255dff857@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ Joel if he has seen this issue.

On 5/28/2019 2:27 PM, Srinivas Ramana wrote:
> Hello,
> 
> I am trying to build samples/bpf in kernel(5.2.0-rc1) but unsuccessful 
> with below errors. Can you help to point what i am missing or if there 
> is some known issue?
> 
> ==============================8<===================================
> $ make samples/bpf/ 
> LLC=/local/mnt/workspace/tools/clang_ubuntu/clang/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/llc 
> CLANG=/local/mnt/workspace/tools/clang_ubuntu/clang/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/clang 
> V=1
> make -C /local/mnt/workspace/sramana/kdev_torvalds/kdev/kernel -f 
> /local/mnt/workspace/sramana/kdev_torvalds/kdev/kernel/Makefile 
> samples/bpf/
> ................
> ................
> ................
> make KBUILD_MODULES=1 -f ./scripts/Makefile.build obj=samples/bpf
> (cat /dev/null; ) > samples/bpf/modules.order
> make -C 
> /local/mnt/workspace/sramana/kdev_torvalds/kdev/kernel/samples/bpf/../../tools/lib/bpf/ 
> RM='rm -rf' LDFLAGS= 
> srctree=/local/mnt/workspace/sramana/kdev_torvalds/kdev/kernel/samples/bpf/../../ 
> O=
> 
> Auto-detecting system features:
> ...                        libelf: [ on  ]
> ...                           bpf: [ on  ]
> 
> make -C 
> /local/mnt/workspace/sramana/kdev_torvalds/kdev/kernel/samples/bpf/../..//tools/build 
> CFLAGS= LDFLAGS= fixdep
> make -f 
> /local/mnt/workspace/sramana/kdev_torvalds/kdev/kernel/samples/bpf/../..//tools/build/Makefile.build 
> dir=. obj=fixdep
>     ld -r -o fixdep-in.o  fixdep.o
> ld: fixdep.o: Relocations in generic ELF (EM: 183)
> ld: fixdep.o: Relocations in generic ELF (EM: 183)
> fixdep.o: error adding symbols: File in wrong format
> make[5]: *** [fixdep-in.o] Error 1
> make[4]: *** [fixdep-in.o] Error 2
> make[3]: *** [fixdep] Error 2
> make[2]: *** 
> [/local/mnt/workspace/sramana/kdev_torvalds/kdev/kernel/samples/bpf/../../tools/lib/bpf/libbpf.a] 
> Error 2
> make[1]: *** [samples/bpf/] Error 2
> make: *** [sub-make] Error 2
> ==============================>8=======================================
> 
> 
> I am using the below commands to build:
> ========================================================
> export ARCH=arm64
> export CROSS_COMPILE=<path>linaro-toolchain/5.1/bin/aarch64-linux-gnu-
> export CLANG_TRIPLE=arm64-linux-gnu-
> 
> make 
> CC=<path>/clang_ubuntu/clang/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/clang 
> defconfig
> 
> make 
> CC=<path>/clang_ubuntu/clang/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/clang 
> -j8
> 
> make 
> CC=<path>/clang_ubuntu/clang/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/clang 
> headers_install INSTALL_HDR_PATH=./usr
> 
> make samples/bpf/ 
> LLC=<path>/clang_ubuntu/clang/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/llc 
> CLANG=<path>/clang_ubuntu/clang/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/clang 
> V=1 
> CC=<path>/clang_ubuntu/clang/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/clang 
> 
> ========================================================
> 
> Thanks,
> -- Srinivas R
> 


-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation
Center, Inc., is a member of Code Aurora Forum, a Linux Foundation
Collaborative Project
