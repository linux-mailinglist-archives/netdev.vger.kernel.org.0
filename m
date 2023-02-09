Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1200690457
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 10:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbjBIJ6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 04:58:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbjBIJ6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 04:58:33 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E58DB1ADF6
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 01:58:23 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id j29-20020a05600c1c1d00b003dc52fed235so1087387wms.1
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 01:58:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1JLivp4ypXMDs8jTE5UbLS0uuJmQRxMGUE/7Djq2AI4=;
        b=IYJnSdEl2jlrIoyIEeyVAVmqHC9vGspSHe+C7oIaajCW8kjQrPjGEtbNRd24nK66I3
         xhjpLClkaCS4x/tGcnd4JZwFQqWNQvrmUQTcusPzKQxKosg4uBlbcCqenHkeRWSoCnyF
         01UNH/iqA58NqBLQ50kSvUvRIJ7Jv9XNuLd2tWdtXXHm0lXDLRTUSU9rTwEu9hnqsRxB
         zZqHhNFc6376TkdFSODZsuzFbNuO6U0QDj3MJvTORvcK+wiyTwbQWMe/IvPvj0EOFpwo
         +M1h2vuzeRI1+zOfOTe0717R/z4wdrr0mHoiEYoDCkPgNIa/T1ERvmqqSj2HQoJ83QJd
         Hi6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1JLivp4ypXMDs8jTE5UbLS0uuJmQRxMGUE/7Djq2AI4=;
        b=70XFDskXTIfqxW1voDoPbJZjTFC/Ekx2HgPZzIlAzgpzjxaasnwA1hMryqOrma6LbC
         t1y+pbADs/8jeSy9k0BjMJcAjMy+K5x4qSEoA98H2CxXcQZouJ22l1kEabfoNXG5p0I5
         pGrEqPVkn+TjpK9IXQ+7JpggP+RH+iOUxFi6kIHabcn/SSTuR/81LffSdpQzKrxxrAOy
         8QeH8SGFTQpErNeQBzxuwoKyYKqaKWL9hkhpRhYDp0goS9Zf4dLJDjFR9asPeQ/gw7tz
         DUqRBB3+wPnxVEnUiL94zs7eTEG7VS/ArD4+kCBjHe11XxEnqr4GMpOP3F1837HNwdU0
         EMIw==
X-Gm-Message-State: AO0yUKW0F1NwyXAw+7+lbmQn+3BNMCk8QHj6ODsg4utZClOz/YA+GkFe
        PCR/iVwr0b41C8InXoRO9LUinGASsv2Ftv0bugUORA==
X-Google-Smtp-Source: AK7set/3Tbq2Y49XMuFoMGaomx4H2xnhAPKdOKGCg/gSB4pXQFbOTNHRLMO7JBZutEXTesWAUQN4/AUAhBmfp/wi2MM=
X-Received: by 2002:a7b:cb8b:0:b0:3df:dc12:9684 with SMTP id
 m11-20020a7bcb8b000000b003dfdc129684mr403282wmi.22.1675936702329; Thu, 09 Feb
 2023 01:58:22 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYs-i-c2KTSA7Ai4ES_ZESY1ZnM=Zuo8P1jN00oed6KHMA@mail.gmail.com>
In-Reply-To: <CA+G9fYs-i-c2KTSA7Ai4ES_ZESY1ZnM=Zuo8P1jN00oed6KHMA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 9 Feb 2023 10:58:10 +0100
Message-ID: <CANn89iLaWZhrfyn8NBzdN1zQC0d47WC4_jvpwKQPoHwyCVueVQ@mail.gmail.com>
Subject: Re: next: arm64: boot: kernel BUG at mm/usercopy.c:102 - pc : usercopy_abort
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Netdev <netdev@vger.kernel.org>,
        lkft-triage@lists.linaro.org, Thomas Gleixner <tglx@linutronix.de>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Christian Brauner <brauner@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 9, 2023 at 9:57 AM Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> Following kernel crash noticed while booting arm64 devices and qemu-arm64 with
> kselftest merge configs enabled.
>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> crash log:
> ----------
> usercopy: Kernel memory exposure attempt detected from SLUB object
> 'skbuff_small_head' (offset 130, size 12)!
> ..
> [   24.673364] ------------[ cut here ]------------
> [   24.673812] kernel BUG at mm/usercopy.c:102!
> [   24.674631] Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
> [   24.675389] Modules linked in:
> [   24.676231] CPU: 3 PID: 1 Comm: systemd Not tainted
> 6.2.0-rc7-next-20230209 #1
> [   24.676779] Hardware name: linux,dummy-virt (DT)
> [   24.677256] pstate: 61400005 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
> [   24.677695] pc : usercopy_abort (mm/usercopy.c:102 (discriminator 24))
> [   24.678470] lr : usercopy_abort (mm/usercopy.c:102 (discriminator 24))
> [   24.678717] sp : ffff80000803bab0
> [   24.678949] x29: ffff80000803bac0 x28: ffff0000c0838040 x27: ffff80000803bc70
> [   24.679618] x26: 0000000000000000 x25: ffff0000c0fe4040 x24: ffff0000c4752000
> [   24.680050] x23: 0000000000000000 x22: 0000000000000020 x21: 0000000000000000
> [   24.680484] x20: ffffc94cf339ac70 x19: ffffc94cf31861b8 x18: 0000000000000000
> [   24.680929] x17: 63656a626f204255 x16: 4c53206f74206465 x15: 7463657465642074
> [   24.681372] x14: 706d657474612065 x13: 2129323320657a69 x12: 0000000000000001
> [   24.681810] x11: ffffc94cf372ba24 x10: 65685f6c6c616d73 x9 : ffffc94cf1184028
> [   24.682299] x8 : ffff80000803b7b8 x7 : ffffc94cf4207170 x6 : 0000000000000001
> [   24.682742] x5 : 0000000000000001 x4 : ffffc94cf4165000 x3 : 0000000000000000
> [   24.683216] x2 : 0000000000000000 x1 : ffff0000c0838040 x0 : 000000000000006a
> [   24.683788] Call trace:
> [   24.684019] usercopy_abort (mm/usercopy.c:102 (discriminator 24))
> [   24.684346] __check_heap_object (mm/slub.c:4739)
> [   24.684621] __check_object_size (mm/usercopy.c:196
> mm/usercopy.c:251 mm/usercopy.c:213)
> [   24.684883] netlink_sendmsg (include/linux/uio.h:177
> include/linux/uio.h:184 include/linux/skbuff.h:3977
> net/netlink/af_netlink.c:1927)
> [   24.685161] __sys_sendto (net/socket.c:722 net/socket.c:745
> net/socket.c:2142)
> [   24.685397] __arm64_sys_sendto (net/socket.c:2150)
> [   24.685644] invoke_syscall (arch/arm64/include/asm/current.h:19
> arch/arm64/kernel/syscall.c:57)
> [   24.685891] el0_svc_common.constprop.0
> (arch/arm64/include/asm/daifflags.h:28
> arch/arm64/kernel/syscall.c:150)
> [   24.686164] do_el0_svc (arch/arm64/kernel/syscall.c:194)
> [   24.686401] el0_svc (arch/arm64/include/asm/daifflags.h:28
> arch/arm64/kernel/entry-common.c:133
> arch/arm64/kernel/entry-common.c:142
> arch/arm64/kernel/entry-common.c:638)
> [   24.686602] el0t_64_sync_handler (arch/arm64/kernel/entry-common.c:656)
> [   24.686862] el0t_64_sync (arch/arm64/kernel/entry.S:591)
> [ 24.687307] Code: aa1303e3 9000ea60 91300000 97f49682 (d4210000)
> All code
> ========
>    0:* e3 03                jrcxz  0x5 <-- trapping instruction
>    2: 13 aa 60 ea 00 90    adc    -0x6fff15a0(%rdx),%ebp
>    8: 00 00                add    %al,(%rax)
>    a: 30 91 82 96 f4 97    xor    %dl,-0x680b697e(%rcx)
>   10: 00 00                add    %al,(%rax)
>   12: 21 d4                and    %edx,%esp
>
> Code starting with the faulting instruction
> ===========================================
>    0: 00 00                add    %al,(%rax)
>    2: 21 d4                and    %edx,%esp
> [   24.688236] ---[ end trace 0000000000000000 ]---
> [   24.688722] note: systemd[1] exited with irqs disabled
> [   24.689588] note: systemd[1] exited with preempt_count 1
> [   24.690331] Kernel panic - not syncing: Attempted to kill init!
> exitcode=0x0000000b
> [   24.690875] SMP: stopping secondary CPUs
> [   24.691749] Kernel Offset: 0x494ce9000000 from 0xffff800008000000
> [   24.692103] PHYS_OFFSET: 0x40000000
> [   24.692349] CPU features: 0x000000,0068c25f,3326773f
> [   24.692924] Memory Limit: none
> [   24.693422] ---[ end Kernel panic - not syncing: Attempted to kill
> init! exitcode=0x0000000b ]---
>
>
> detailed boot logs:
> https://lkft.validation.linaro.org/scheduler/job/6145112#L778
> https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20230209/testrun/14667540/suite/log-parser-test/tests/
> https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20230209/testrun/14667540/suite/log-parser-test/test/check-kernel-bug/log
>
>
> metadata:
>   git_ref: master
>   git_repo: https://gitlab.com/Linaro/lkft/mirrors/next/linux-next
>   git_sha: 20f513df926fac0594a3b65f79d856bd64251861
>   git_describe: next-20230209
>   kernel_version: 6.2.0-rc7
>   kernel-config:
> https://storage.tuxsuite.com/public/linaro/lkft/builds/2LUB6A6xC34mySgwQ3vPa6kHKJS/config
>   artifact-location:
> https://storage.tuxsuite.com/public/linaro/lkft/builds/2LUB6A6xC34mySgwQ3vPa6kHKJS/
>   toolchain: gcc-11
>   build_name: gcc-11-lkftconfig-kselftest
>
>
> --
> Linaro LKFT
> https://lkft.linaro.org

This should be fixed when this patch is accepted/merged.

https://patchwork.kernel.org/project/netdevbpf/patch/20230208142508.3278406-1-edumazet@google.com/

Thanks.
