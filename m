Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E093451D32C
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 10:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390001AbiEFITo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 04:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390047AbiEFITi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 04:19:38 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5EA6352A
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 01:15:52 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id f38so11646722ybi.3
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 01:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8500E8Rxld5vc9dYZybFYeJrffHl6XGxHFSG1DGjm8s=;
        b=KkiGGGSLjep1WCk/ooDR5pFmX0A/xIFZN87VFDJyaTjni7Lfl5S3buUNmbgsRX34Ku
         uZFlkCUw2kpWP5WaabD+mw928GPtF4mpGkbVGkhrGSb6lf8IkYLk3V65dsWy1gM5tOGS
         vt6qCN+R7m5Y1lgd6Bd96quyOluVixMDuX/jeGPQ2qurB68WNp0VlbZE42XRnskuPFJ5
         8UeRpfdY99YDUokSscSvEVY/kvCSXpClhnCxwjuDScxFM7n+AamLhcWOS8odsFDVrZQU
         VEd7n8Xht791ggDtmnzcJAkUD6EVVt/nzRK7zI8cacmnof72fnOqjVNdVa6tEyd5AnJp
         Bthg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8500E8Rxld5vc9dYZybFYeJrffHl6XGxHFSG1DGjm8s=;
        b=XsVZMN+DaDiztAcVZOPK/c0XH45WnMO+farq8gJTqI4DaozAsjbNHaBJbiT+O2tVhQ
         hGbLoOSoEJam0Egtb+T5X1EzAj8A1Pr1pqYZ2j5cuxb5wY7yucENosgqVJta76LNV0fh
         ljKoc2k5zfgI8Uv7G3kQ7gsNH7/BWZeLDbDF1Hdg7XEvEkA7MdntCqX8EbjlnSmfNWER
         JeU7N7LHtAueQIW6Hmx+nC2lQK905EfydmBCB9U+UUbYEiPn24nyIEtF+JNg6dAnAbko
         C7fZg3SJZt0AL0w5T5CHLbROgGB10xSd6DaX3Hkcm/BUDlssvRnmEQrp+dhJBsfIDb1A
         ksbw==
X-Gm-Message-State: AOAM532bqylbdKdGK+PqryvT2toNbAzE/9WpsxP+PaBPbEheYh+JqQz0
        K4pbNdJUvKm+n0ZKxuC/mNOvbN7K2un05LG6a2gCbg==
X-Google-Smtp-Source: ABdhPJy9rrYVGbPd5JwMJvqCG1oarxVuTcxnNidKGWecfEABTxKqkiQ3ibOUc4k4ZWG37qriREtNXRJQMEloqYiE8+0=
X-Received: by 2002:a25:3157:0:b0:649:b216:bb4e with SMTP id
 x84-20020a253157000000b00649b216bb4emr1460369ybx.387.1651824951606; Fri, 06
 May 2022 01:15:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220422201237.416238-1-eric.dumazet@gmail.com> <20220506064439.GC23061@xsang-OptiPlex-9020>
In-Reply-To: <20220506064439.GC23061@xsang-OptiPlex-9020>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 6 May 2022 01:15:40 -0700
Message-ID: <CANn89iLkpsri3CxxP3Xc-jLJ_9V4K5pCHPRhdWEL69Z78VWCjw@mail.gmail.com>
Subject: Re: [net] 72fd55c0db: invoked_oom-killer:gfp_mask=0x
To:     kernel test robot <oliver.sang@intel.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, 0day robot <lkp@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@lists.01.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 5, 2022 at 11:44 PM kernel test robot <oliver.sang@intel.com> wrote:
>
>
>
> Greeting,
>
> FYI, we noticed the following commit (built with gcc-11):
>
> commit: 72fd55c0dbb1ad5ba283ca80abc9546702815a33 ("[PATCH v2 net-next] net: generalize skb freeing deferral to per-cpu lists")
> url: https://github.com/intel-lab-lkp/linux/commits/Eric-Dumazet/net-generalize-skb-freeing-deferral-to-per-cpu-lists/20220423-060710
> base: https://git.kernel.org/cgit/linux/kernel/git/davem/net-next.git c78c5a660439d4d341a03b651541fda3ebe76160
> patch link: https://lore.kernel.org/netdev/20220422201237.416238-1-eric.dumazet@gmail.com
>

I think this commit had two follow up fixes.
Make sure to test the tree after the fixes are included, otherwise
this is adding unneeded noise.
Thank you.

commit f3412b3879b4f7c4313b186b03940d4791345534
Author: Eric Dumazet <edumazet@google.com>
Date:   Wed Apr 27 13:41:47 2022 -0700

    net: make sure net_rx_action() calls skb_defer_free_flush()

And:

commit 783d108dd71d97e4cac5fe8ce70ca43ed7dc7bb7
Author: Eric Dumazet <edumazet@google.com>
Date:   Fri Apr 29 18:15:23 2022 -0700

    tcp: drop skb dst in tcp_rcv_established()


> in testcase: xfstests
> version: xfstests-x86_64-46e1b83-1_20220414
> with following parameters:
>
>         disk: 4HDD
>         fs: ext4
>         fs2: smbv3
>         test: generic-group-10
>         ucode: 0xec
>
> test-description: xfstests is a regression test suite for xfs and other files ystems.
> test-url: git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git
>
>
> on test machine: 8 threads Intel(R) Core(TM) i7-6700 CPU @ 3.40GHz with 16G memory
>
> caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):
>
>
>
> If you fix the issue, kindly add following tag
> Reported-by: kernel test robot <oliver.sang@intel.com>
>
>
>
> [   80.428226][ T1836] Attempt to set a LOCK_MAND lock via flock(2). This support has been removed and the request ignored.
> [   80.739189][  T370] generic/207       0s
> [   80.739198][  T370]
> [   80.785302][ T1696] run fstests generic/208 at 2022-05-06 02:42:26
> [   81.143444][ T1836] Attempt to set a LOCK_MAND lock via flock(2). This support has been removed and the request ignored.
> [   89.609627][   T58] kworker/u16:5 invoked oom-killer: gfp_mask=0xcd0(GFP_KERNEL|__GFP_RECLAIMABLE), order=0, oom_score_adj=0
> [   89.620805][   T58] CPU: 0 PID: 58 Comm: kworker/u16:5 Not tainted 5.18.0-rc3-00568-g72fd55c0dbb1 #1
> [   89.629899][   T58] Hardware name: HP HP Z240 SFF Workstation/802E, BIOS N51 Ver. 01.63 10/05/2017
> [   89.638822][   T58] Workqueue: writeback wb_workfn (flush-8:16)
> [   89.644727][   T58] Call Trace:
> [   89.647863][   T58]  <TASK>
> [ 89.650649][ T58] dump_stack_lvl (kbuild/src/consumer/lib/dump_stack.c:107 (discriminator 1))
> [ 89.654992][ T58] dump_header (kbuild/src/consumer/mm/oom_kill.c:73 kbuild/src/consumer/mm/oom_kill.c:461)
> [ 89.659250][ T58] oom_kill_process.cold (kbuild/src/consumer/mm/oom_kill.c:979)
> [ 89.664110][ T58] out_of_memory (kbuild/src/consumer/mm/oom_kill.c:1119 (discriminator 4))
>
>
> To reproduce:
>
>         git clone https://github.com/intel/lkp-tests.git
>         cd lkp-tests
>         sudo bin/lkp install job.yaml           # job file is attached in this email
>         bin/lkp split-job --compatible job.yaml # generate the yaml file for lkp run
>         sudo bin/lkp run generated-yaml-file
>
>         # if come across any failure that blocks the test,
>         # please remove ~/.lkp and /lkp dir to run from a clean state.
>
>
>
> --
> 0-DAY CI Kernel Test Service
> https://01.org/lkp
>
>
