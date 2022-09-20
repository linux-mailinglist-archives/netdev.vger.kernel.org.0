Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 005615BEAA3
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 18:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbiITQAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 12:00:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbiITQAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 12:00:02 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64C4414085
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 09:00:00 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-3457bc84d53so33094877b3.0
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 09:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=16rXn9G6e+vzicFuly3W1zcOBEo+YQGYAw+kgXgqvTY=;
        b=JulG5+8FYssKEV3UjOlxsbhuR+H3zTPHXzwbJ8fWhdBNyZ7mARaew2XIFgZSN1JHPE
         XRYW8z5HH7i/phg3JINjBbEndMxSTCjkATkMWNgh6LYoWShDBQNo/p6la21e941PO+/R
         FwA9szzTCOjtntjSZpxeEhhJE4b64I8ydHPFTe1g2PPZXPtnK1/284v2WBUhJ0G7jNFg
         8Dh/Y7fIV+F1IDg+HMDjt1r5AypmS9/B9pQ3ff9Vvjx17ThaDrLisykzSFom31lxkkK6
         lTAFmIKAxm6/O8AfTdWyKRXQSIyYN9z2U1LBXSb3HtLG9pctHxu8Bt7lnEHi4V05Bxnk
         Sa5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=16rXn9G6e+vzicFuly3W1zcOBEo+YQGYAw+kgXgqvTY=;
        b=rSpaocD/gV0tjhoLyfaQaU1SbhqBLJT1d8MYIs4JdgO2bMazldSlXqMQczZjAIcp+c
         hpO/MO307hOcj7Eh6eDxtaOrExrqurMfuxmGLskyiOOfQ09TSqjVPARSQH+pBHM0K6uN
         xlMBQzEDJj3rOO99TewAXsB2nwQkGL4ofFpUEHBmyUQDwVTiJQSvSBg4hUYflnwxY8ZQ
         qqr4Lz869LZFcLqq0LnTig0cIq4+ApZXWOItR64fLAZmuiKNIeS2CLqa2AvMWIBMO+2d
         JLIDwSFARzNyS86ItLMmQrznFN0pMIG6b9y8u+LrudkYyFB0Zwg9qibxZTI0Vzq30KMC
         Jb3A==
X-Gm-Message-State: ACrzQf0SEg+RhdfrC8CJcDkRFWqzRNQW6wqY/cTsQUGi2N14a17t5Y3F
        5D++p0lauBAaLfjwoduBENBD9GVmGjoKtXVt89KijwcmGjw=
X-Google-Smtp-Source: AMsMyM6nZ/IrGw3W3z/XPOIhCtYqKsDRqGaE/nQcpedW0Y2khjGiygpQYVwrXz4yI0wBHKVuHP6uJcrCAMlybj4hQXw=
X-Received: by 2002:a81:7986:0:b0:349:853d:d165 with SMTP id
 u128-20020a817986000000b00349853dd165mr20287586ywc.467.1663689599302; Tue, 20
 Sep 2022 08:59:59 -0700 (PDT)
MIME-Version: 1.0
References: <202209201359.3f33d97f-oliver.sang@intel.com>
In-Reply-To: <202209201359.3f33d97f-oliver.sang@intel.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 20 Sep 2022 08:59:48 -0700
Message-ID: <CANn89iJn554zCtkG9d556kgC4010yfgc4X+GAnoQQW+5Z_sNpg@mail.gmail.com>
Subject: Re: [tcp] 4bfe744ff1: packetdrill.packetdrill/gtests/net/tcp/epoll/epoll_out_edge_default_notsent_lowat_ipv4-mapped-v6.fail
To:     kernel test robot <oliver.sang@intel.com>
Cc:     lkp@lists.01.org, kbuild test robot <lkp@intel.com>,
        "David S. Miller" <davem@davemloft.net>, Doug Porter <dsp@fb.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 19, 2022 at 10:22 PM kernel test robot
<oliver.sang@intel.com> wrote:
>
>
> Greeting,
>
> FYI, we noticed the following commit (built with gcc-11):
>
> commit: 4bfe744ff1644fbc0a991a2677dc874475dd6776 ("tcp: fix potential xmit stalls caused by TCP_NOTSENT_LOWAT")
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
>
> in testcase: packetdrill
> version: packetdrill-x86_64-329d89e-1_20220824
> with following parameters:
>
>
>
> on test machine: 8 threads 1 sockets Intel(R) Core(TM) i7-7700 CPU @ 3.60GHz (Kaby Lake) with 32G memory
>
> caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):
>
>
> If you fix the issue, kindly add following tag
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Link: https://lore.kernel.org/r/202209201359.3f33d97f-oliver.sang@intel.com
>
>
> we actually also observed other tests failed on this commit but pass on parent:
> (more details are in attached dmesg and 'packetdrill' file)
>
> =========================================================================================
> tbox_group/testcase/rootfs/kconfig/compiler:
>   lkp-kbl-d01/packetdrill/debian-11.1-x86_64-20220510.cgz/x86_64-rhel-8.3-func/gcc-11
>
> 1fcb8fb3522f5b0f 4bfe744ff1644fbc0a991a2677d
> ---------------- ---------------------------
>        fail:runs  %reproduction    fail:runs
>            |             |             |
>            :30         100%          30:30    packetdrill.packetdrill/gtests/net/tcp/epoll/epoll_out_edge_default_notsent_lowat_ipv4-mapped-v6.fail
>            :30         100%          30:30    packetdrill.packetdrill/gtests/net/tcp/epoll/epoll_out_edge_default_notsent_lowat_ipv4.fail
>            :30         100%          30:30    packetdrill.packetdrill/gtests/net/tcp/epoll/epoll_out_edge_ipv4-mapped-v6.fail
>            :30         100%          30:30    packetdrill.packetdrill/gtests/net/tcp/epoll/epoll_out_edge_ipv4.fail
>            :30         100%          30:30    packetdrill.packetdrill/gtests/net/tcp/epoll/epoll_out_edge_notsent_lowat_ipv4-mapped-v6.fail
>            :30         100%          30:30    packetdrill.packetdrill/gtests/net/tcp/epoll/epoll_out_edge_notsent_lowat_ipv4.fail
>
>
> stdout:
> stderr:
> FAIL [/lkp/benchmarks/packetdrill/gtests/net/tcp/epoll/epoll_out_edge.pkt (ipv4)]
> stdout:
> stderr:
> FAIL [/lkp/benchmarks/packetdrill/gtests/net/tcp/epoll/epoll_out_edge_default_notsent_lowat.pkt (ipv4-mapped-v6)]
>
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

Sure, these (out of tree) packetdrill tests need to account for the
new kernel behavior.

I am not sure who is responsible for these tests, but this is not the
kernel maintainers.
