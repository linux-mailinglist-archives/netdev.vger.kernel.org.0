Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FEA92C99F6
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 09:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728932AbgLAIvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 03:51:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727555AbgLAIvY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 03:51:24 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CFE5C0613D3
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 00:50:43 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id 7so2540329ejm.0
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 00:50:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=pJxU4SXRvsoqyteUAGrx+U2C/0Zrh4T45v5nWGZ20Q4=;
        b=Kkn/sEG2xW82hVX6uQAqieqy3lXKnE7aFS1KB8IhzEwLZl63KvzLr1L6a7o3DIhUst
         s1/uInwt1WB1xF7e7o+sO+X7usnScBkG9dGpWm3SJwko6J2jqXe49kVS37r0In++SWih
         EwnvHiiTsgusIr25PyuAD04n3MHvnD283jKzef+MOHlKIsSUzpkYS7hE6Ih4P10Ijhs5
         R3lcMDeSpIJ1Y58UaZjgsUfoR5bs7M13LUcBu9BcUfC3Cnr7SZ0svJt1Ss9MowmKwjDd
         10oinjmA8SbcU7JtQFUzIA8X/3m5e6bV0Pr2QGqm1ElE1XhIMwtztnzKGLuEz9nsfswK
         1HEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=pJxU4SXRvsoqyteUAGrx+U2C/0Zrh4T45v5nWGZ20Q4=;
        b=pn/ssjlaOWo2fZqQOsf+VbtepbYW0n3gauQ4Y1PEzAAnec320BlqFgfg7SCxz8bvBT
         iNeFh/z7WU324xdPy5kLuysEjTP6eesaSRqPL6qHyGGLcpBfTIPSErLbohrVSmYv+AsD
         Elhk168d8r4vVuEB7QkvIXSHYYNq7eaP6VHozcJkZFsrLgv96IN/HMqi7BJiEq6xRLwg
         7gpLf31kX3yxhROoepUYydBdZiaELV4NiVuG8TyE3diyawM0g1V3XAxpdcf73F6mSc15
         WC29vVWdNWoETgRMB4K1iALQT8GgfgKh0oaAYCPo3KvanNZRpu+FgWVv7AhuWFXEhii5
         LXhw==
X-Gm-Message-State: AOAM532xBs7B3XHtTCcLB2d8+FHpsdUFcSEN69ZidDoTPeDdjI6cLxFo
        olQczKkn7UMJb5OfoBdYwy/6SnjLTICqlKfzZxLWRw==
X-Google-Smtp-Source: ABdhPJyBqm66PdRJOkmpoBoCjp6pGDeNzyVzEiI5lcsP/EGfSAwa4+b5OkxXDT9McvjyIXeh0Xey7vyflBT8zRQImFI=
X-Received: by 2002:a17:906:4d0c:: with SMTP id r12mr1987564eju.25.1606812641761;
 Tue, 01 Dec 2020 00:50:41 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a54:3cc7:0:0:0:0:0 with HTTP; Tue, 1 Dec 2020 00:50:41 -0800 (PST)
X-Originating-IP: [5.35.99.104]
In-Reply-To: <20201201052809.GB25891@xsang-OptiPlex-9020>
References: <20201130132747.29332-1-kda@linux-powerpc.org> <20201201052809.GB25891@xsang-OptiPlex-9020>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Tue, 1 Dec 2020 11:50:41 +0300
Message-ID: <CAOJe8K3w3Ngs3FWRjN0O5YAUsanCt4xK1fHaq2dskM-QVQvzwg@mail.gmail.com>
Subject: Re: [net/af_unix] 556d816147: WARNING:lock_held_when_returning_to_user_space
To:     kernel test robot <oliver.sang@intel.com>
Cc:     0day robot <lkp@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@lists.01.org, netdev@vger.kernel.org, kuba@kernel.org,
        davem@davemloft.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/1/20, kernel test robot <oliver.sang@intel.com> wrote:
>
> Greeting,
>
> FYI, we noticed the following commit (built with gcc-9):
>
> commit: 556d816147c0037356a73ecd04b56f7f88f8fd6c ("[PATCH v2] net/af_unix:
> don't create a path for a binded socket")

goto label after unix_mknod() should be fixed as well. I'll send a
next version shortly.

Thanks!


> url:
> https://github.com/0day-ci/linux/commits/Denis-Kirjanov/net-af_unix-don-t-create-a-path-for-a-binded-socket/20201130-213012
> base: https://git.kernel.org/cgit/linux/kernel/git/davem/net.git
> 4d521943f76bd0d1e68ea5e02df7aadd30b2838a
>
> in testcase: trinity
> version: trinity-static-i386-x86_64-f93256fb_2019-08-28
> with following parameters:
>
> 	runtime: 300s
>
> test-description: Trinity is a linux system call fuzz tester.
> test-url: http://codemonkey.org.uk/projects/trinity/
>
>
> on test machine: qemu-system-i386 -enable-kvm -cpu SandyBridge -smp 2 -m 8G
>
> caused below changes (please refer to attached dmesg/kmsg for entire
> log/backtrace):
>
>
> +------------------------------------------------+------------+------------+
> |                                                | 4d521943f7 | 556d816147
> |
> +------------------------------------------------+------------+------------+
> | WARNING:lock_held_when_returning_to_user_space | 0          | 6
> |
> | is_leaving_the_kernel_with_locks_still_held    | 0          | 6
> |
> +------------------------------------------------+------------+------------+
>
>
> If you fix the issue, kindly add following tag
> Reported-by: kernel test robot <oliver.sang@intel.com>
>
>
> [  168.905018] WARNING: lock held when returning to user space!
> [  168.905959] 5.10.0-rc5-00345-g556d816147c0 #2 Not tainted
> [  168.906832] ------------------------------------------------
> [  168.907688] trinity-c2/2496 is leaving the kernel with locks still held!
> [  168.908760] 1 lock held by trinity-c2/2496:
> [  168.909447]  #0: 421dc410 (&u->bindlock){....}-{3:3}, at:
> unix_bind+0xed/0x4c7
> [  176.087761] init: tty4 main process (2507) terminated with status 1
> [  176.090757] init: tty4 main process ended, respawning
> [  176.183929] init: tty5 main process (2510) terminated with status 1
> [  176.185225] init: tty5 main process ended, respawning
> [  176.197560] init: tty2 main process (2511) terminated with status 1
> [  176.198808] init: tty2 main process ended, respawning
> [  176.313912] init: tty3 main process (2517) terminated with status 1
> [  176.315179] init: tty3 main process ended, respawning
> [  176.343943] init: tty6 main process (2518) terminated with status 1
> [  176.345145] init: tty6 main process ended, respawning
> [  177.775764] [main] 116496 iterations. [F:86641 S:29411 HI:6256]
> [  177.775774]
> [  186.109795] init: tty4 main process (2702) terminated with status 1
> [  186.112880] init: tty4 main process ended, respawning
> [  186.207775] init: tty5 main process (2703) terminated with status 1
> [  186.208931] init: tty5 main process ended, respawning
> [  186.220373] init: tty2 main process (2704) terminated with status 1
> [  186.221503] init: tty2 main process ended, respawning
> [  186.337715] init: tty3 main process (2705) terminated with status 1
> [  186.339086] init: tty3 main process ended, respawning
> [  186.357629] init: tty6 main process (2706) terminated with status 1
> [  186.358989] init: tty6 main process ended, respawning
> [  191.008519] futex_wake_op: trinity-c3 tries to shift op by -1607; fix
> this program
> [  191.929811] [main] 126550 iterations. [F:94187 S:31885 HI:6256]
> [  191.929822]
> [  196.134002] init: tty4 main process (2825) terminated with status 1
> [  196.135420] init: tty4 main process ended, respawning
> [  196.244209] init: tty5 main process (2829) terminated with status 1
> [  196.245619] init: tty5 main process ended, respawning
> [  196.251326] init: tty2 main process (2830) terminated with status 1
> [  196.252673] init: tty2 main process ended, respawning
> [  196.357686] init: tty3 main process (2831) terminated with status 1
> [  196.359087] init: tty3 main process ended, respawning
> [  196.387854] init: tty6 main process (2832) terminated with status 1
> [  196.389207] init: tty6 main process ended, respawning
> [  202.998987] [main] 136876 iterations. [F:101871 S:34499 HI:6256]
> [  202.999000]
> [  206.157463] init: tty4 main process (2962) terminated with status 1
> [  206.163696] init: tty4 main process ended, respawning
> [  206.278220] init: tty5 main process (2963) terminated with status 1
> [  206.278928] init: tty5 main process ended, respawning
> [  206.280981] init: tty2 main process (2964) terminated with status 1
> [  206.281659] init: tty2 main process ended, respawning
> [  206.387845] init: tty3 main process (2966) terminated with status 1
> [  206.388527] init: tty3 main process ended, respawning
> [  206.427813] init: tty6 main process (2971) terminated with status 1
> [  206.428470] init: tty6 main process ended, respawning
> [  212.579273] [main] 147488 iterations. [F:109823 S:37124 HI:6607]
> [  212.579281]
> [  216.183874] init: tty4 main process (3142) terminated with status 1
> [  216.185161] init: tty4 main process ended, respawning
> [  216.293768] init: tty5 main process (3143) terminated with status 1
> [  216.294828] init: tty5 main process ended, respawning
> [  216.299943] init: tty2 main process (3144) terminated with status 1
> [  216.300976] init: tty2 main process ended, respawning
> [  216.397783] init: tty3 main process (3147) terminated with status 1
> [  216.399510] init: tty3 main process ended, respawning
> [  216.443459] init: tty6 main process (3148) terminated with status 1
> [  216.444113] init: tty6 main process ended, respawning
> [  219.779234] [main] 157599 iterations. [F:117378 S:39654 HI:7346]
> [  219.779243]
> [  226.207416] init: tty4 main process (3391) terminated with status 1
> [  226.208093] init: tty4 main process ended, respawning
> [  226.317687] init: tty5 main process (3392) terminated with status 1
> [  226.318384] init: tty5 main process ended, respawning
> [  226.320583] init: tty2 main process (3393) terminated with status 1
> [  226.321232] init: tty2 main process ended, respawning
> [  226.417465] init: tty3 main process (3395) terminated with status 1
> [  226.418163] init: tty3 main process ended, respawning
> [  226.457388] init: tty6 main process (3396) terminated with status 1
> [  226.458074] init: tty6 main process ended, respawning
> [  231.591603] [main] 168030 iterations. [F:125172 S:42250 HI:7346]
> [  231.591610]
> [  236.224759] init: tty4 main process (3549) terminated with status 1
> [  236.237822] init: tty4 main process ended, respawning
> [  236.343557] init: tty5 main process (3550) terminated with status 1
> [  236.344269] init: tty5 main process ended, respawning
> [  236.349639] init: tty2 main process (3551) terminated with status 1
> [  236.350290] init: tty2 main process ended, respawning
> [  236.443704] init: tty3 main process (3552) terminated with status 1
> [  236.444426] init: tty3 main process ended, respawning
> [  236.473608] init: tty6 main process (3553) terminated with status 1
> [  236.474288] init: tty6 main process ended, respawning
> [  240.424978] [main] 179511 iterations. [F:133832 S:45042 HI:7346]
> [  240.424985]
> [  246.249597] init: tty4 main process (3729) terminated with status 1
> [  246.251721] init: tty4 main process ended, respawning
> [  246.358025] init: tty5 main process (3740) terminated with status 1
> [  246.358733] init: tty5 main process ended, respawning
> [  246.368360] init: tty2 main process (3741) terminated with status 1
> [  246.369005] init: tty2 main process ended, respawning
> [  246.458022] init: tty3 main process (3742) terminated with status 1
> [  246.460142] init: tty3 main process ended, respawning
> [  246.487940] init: tty6 main process (3743) terminated with status 1
> [  246.488606] init: tty6 main process ended, respawning
>
>
> To reproduce:
>
>         # build kernel
> 	cd linux
> 	cp config-5.10.0-rc5-00345-g556d816147c0 .config
> 	make HOSTCC=gcc-9 CC=gcc-9 ARCH=i386 olddefconfig prepare modules_prepare
> bzImage
>
>         git clone https://github.com/intel/lkp-tests.git
>         cd lkp-tests
>         bin/lkp qemu -k <bzImage> job-script # job-script is attached in
> this email
>
>
>
> Thanks,
> Oliver Sang
>
>
