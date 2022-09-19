Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8823E5BD4C0
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 20:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiISSb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 14:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiISSbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 14:31:55 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9562B61F
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 11:31:53 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id 102-20020a9d0bef000000b0065a08449ab3so156595oth.2
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 11:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=Em2VYxT/ljZDxqf2wDCOYhHhJePUbe7CNMlkX8FZrB0=;
        b=awMhCX4JzDA5f2iOHZL76wV7SUzScn/pmrF2TgI/y6AkL9rYSmME+4mj74/pdB/TSu
         HT2Aaf9gkmXOmeiQ+KzcArQ+CLR/gmBXdwbd6INsf5BT7p8ZM8Rv+Yai4iXfv2jcf4hY
         Br+zhK9klNk8H/6rrmYemRiEYCRAygGBCRQULjJ7RWqrI493K3AsyfN9YtTrTsls5c0n
         Eo5ruu8pHqYpFVbRhWj3QdG5i/NaIVbU4Nt1D6a6ongog/RtwIfNMKAa/v9U+Dk/m93y
         8vK4CqkJU7V2ScXM3p7+nPnKB8ja9iiqRZZn7mnhoj375rUcc9UFVzIj+25r1s4Uxb5d
         pdjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Em2VYxT/ljZDxqf2wDCOYhHhJePUbe7CNMlkX8FZrB0=;
        b=tAsCc/RmDiH8i1XSR5jVDqUW+Ik+SA6u47Ghnh5uKgJ3oIzZ4J362XZP9eODBgUO/C
         jiZDJf2k1RL8rYZU/QV3pJqRTDfm+XvHy4wYpDyz00BMzRhevSmkXxyn4dREolKQGs74
         UWR5g/BAMLdMMQQv2JnqhgVDecyBCYDOZEnGdT7F9pk1iWN45p5HlQk8NuCpnQn4FFLP
         XUgBup2GhY4UrHe74Uvx/+KAE/lGYedJ4YHU5b0O6QdJvVgJjEUjmYWHCWbQ64hYIbbX
         U9rnPP/YYn+M5Jp53xPV5CBofULx11RlTjDi9F1+xtuDP1gZYlWTtYRpU9/cCxcqE/eB
         rHXQ==
X-Gm-Message-State: ACrzQf0V1f6S43Woqgq38ATNCKEHwWvnyiMgkUxIxlfI975obzQcCi79
        gxihxc0EWixJsMpR1mtbeZBrCg==
X-Google-Smtp-Source: AMsMyM5Ob6QFO3j59nOdCJrbcf2aMPr/niJ2jdaXlfnM+SfaASfsnGwdl0YIqPl8j5bHW7YESMKKZw==
X-Received: by 2002:a05:6830:4489:b0:65a:16d7:648a with SMTP id r9-20020a056830448900b0065a16d7648amr1686016otv.160.1663612313084;
        Mon, 19 Sep 2022 11:31:53 -0700 (PDT)
Received: from ?IPV6:2804:1b3:7001:2c5:8b07:2c04:e4b7:4d82? ([2804:1b3:7001:2c5:8b07:2c04:e4b7:4d82])
        by smtp.gmail.com with ESMTPSA id x18-20020a4a4112000000b00448aff53822sm12688885ooa.40.2022.09.19.11.31.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Sep 2022 11:31:52 -0700 (PDT)
Message-ID: <fd1948e0-6cd9-677e-ac82-e2254cb80f60@mojatatu.com>
Date:   Mon, 19 Sep 2022 15:31:46 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH net-next,v2 00/18] refactor duplicate codes in the qdisc
 class walk function
Content-Language: en-US
To:     Zhengchao Shao <shaozhengchao@huawei.com>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        toke@toke.dk, vinicius.gomes@intel.com, stephen@networkplumber.org,
        shuah@kernel.org
Cc:     zhijianx.li@intel.com, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
References: <20220917050204.127191-1-shaozhengchao@huawei.com>
From:   Victor Nogueira <victor@mojatatu.com>
In-Reply-To: <20220917050204.127191-1-shaozhengchao@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/09/2022 02:02, Zhengchao Shao wrote:

> The walk implementation of most qdisc class modules is basically the
> same. That is, the values of count and skip are checked first. If count
> is greater than or equal to skip, the registered fn function is
> executed. Otherwise, increase the value of count. So the code can be
> refactored.
>
> The walk function is invoked during dump. Therefore, test cases related
>   to the tdc filter need to be added.
>
> Last, thanks to Victor for his review.
>
> Add test cases locally and perform the test. The test results are listed
> below:
>
> ./tdc.py -c cake
> ok 1 1212 - Create CAKE with default setting
> ok 2 3281 - Create CAKE with bandwidth limit
> ok 3 c940 - Create CAKE with autorate-ingress flag
> ok 4 2310 - Create CAKE with rtt time
> ok 5 2385 - Create CAKE with besteffort flag
> ok 6 a032 - Create CAKE with diffserv8 flag
> ok 7 2349 - Create CAKE with diffserv4 flag
> ok 8 8472 - Create CAKE with flowblind flag
> ok 9 2341 - Create CAKE with dsthost and nat flag
> ok 10 5134 - Create CAKE with wash flag
> ok 11 2302 - Create CAKE with flowblind and no-split-gso flag
> ok 12 0768 - Create CAKE with dual-srchost and ack-filter flag
> ok 13 0238 - Create CAKE with dual-dsthost and ack-filter-aggressive flag
> ok 14 6572 - Create CAKE with memlimit and ptm flag
> ok 15 2436 - Create CAKE with fwmark and atm flag
> ok 16 3984 - Create CAKE with overhead and mpu
> ok 17 5421 - Create CAKE with conservative and ingress flag
> ok 18 6854 - Delete CAKE with conservative and ingress flag
> ok 19 2342 - Replace CAKE with mpu
> ok 20 2313 - Change CAKE with mpu
> ok 21 4365 - Show CAKE class
>
> ./tdc.py -c cbq
> ok 1 3460 - Create CBQ with default setting
> ok 2 0592 - Create CBQ with mpu
> ok 3 4684 - Create CBQ with valid cell num
> ok 4 4345 - Create CBQ with invalid cell num
> ok 5 4525 - Create CBQ with valid ewma
> ok 6 6784 - Create CBQ with invalid ewma
> ok 7 5468 - Delete CBQ with handle
> ok 8 492a - Show CBQ class
>
> ./tdc.py -c cbs
> ok 1 1820 - Create CBS with default setting
> ok 2 1532 - Create CBS with hicredit setting
> ok 3 2078 - Create CBS with locredit setting
> ok 4 9271 - Create CBS with sendslope setting
> ok 5 0482 - Create CBS with idleslope setting
> ok 6 e8f3 - Create CBS with multiple setting
> ok 7 23c9 - Replace CBS with sendslope setting
> ok 8 a07a - Change CBS with idleslope setting
> ok 9 43b3 - Delete CBS with handle
> ok 10 9472 - Show CBS class
>
> ./tdc.py -c drr
> ok 1 0385 - Create DRR with default setting
> ok 2 2375 - Delete DRR with handle
> ok 3 3092 - Show DRR class
>
> ./tdc.py -c dsmark
> ok 1 6345 - Create DSMARK with default setting
> ok 2 3462 - Create DSMARK with default_index setting
> ok 3 ca95 - Create DSMARK with set_tc_index flag
> ok 4 a950 - Create DSMARK with multiple setting
> ok 5 4092 - Delete DSMARK with handle
> ok 6 5930 - Show DSMARK class
>
> ./tdc.py -c fq_codel
> ok 1 4957 - Create FQ_CODEL with default setting
> ok 2 7621 - Create FQ_CODEL with limit setting
> ok 3 6871 - Create FQ_CODEL with memory_limit setting
> ok 4 5636 - Create FQ_CODEL with target setting
> ok 5 630a - Create FQ_CODEL with interval setting
> ok 6 4324 - Create FQ_CODEL with quantum setting
> ok 7 b190 - Create FQ_CODEL with noecn flag
> ok 8 5381 - Create FQ_CODEL with ce_threshold setting
> ok 9 c9d2 - Create FQ_CODEL with drop_batch setting
> ok 10 523b - Create FQ_CODEL with multiple setting
> ok 11 9283 - Replace FQ_CODEL with noecn setting
> ok 12 3459 - Change FQ_CODEL with limit setting
> ok 13 0128 - Delete FQ_CODEL with handle
> ok 14 0435 - Show FQ_CODEL class
>
> ./tdc.py -c hfsc
> ok 1 3254 - Create HFSC with default setting
> ok 2 0289 - Create HFSC with class sc and ul rate setting
> ok 3 846a - Create HFSC with class sc umax and dmax setting
> ok 4 5413 - Create HFSC with class rt and ls rate setting
> ok 5 9312 - Create HFSC with class rt umax and dmax setting
> ok 6 6931 - Delete HFSC with handle
> ok 7 8436 - Show HFSC class
>
> ./tdc.py -c htb
> ok 1 0904 - Create HTB with default setting
> ok 2 3906 - Create HTB with default-N setting
> ok 3 8492 - Create HTB with r2q setting
> ok 4 9502 - Create HTB with direct_qlen setting
> ok 5 b924 - Create HTB with class rate and burst setting
> ok 6 4359 - Create HTB with class mpu setting
> ok 7 9048 - Create HTB with class prio setting
> ok 8 4994 - Create HTB with class ceil setting
> ok 9 9523 - Create HTB with class cburst setting
> ok 10 5353 - Create HTB with class mtu setting
> ok 11 346a - Create HTB with class quantum setting
> ok 12 303a - Delete HTB with handle
>
> ./tdc.py -c mqprio
> ok 1 9903 - Add mqprio Qdisc to multi-queue device (8 queues)
> ok 2 453a - Delete nonexistent mqprio Qdisc
> ok 3 5292 - Delete mqprio Qdisc twice
> ok 4 45a9 - Add mqprio Qdisc to single-queue device
> ok 5 2ba9 - Show mqprio class
>
> ./tdc.py -c multiq
> ok 1 20ba - Add multiq Qdisc to multi-queue device (8 queues)
> ok 2 4301 - List multiq Class
> ok 3 7832 - Delete nonexistent multiq Qdisc
> ok 4 2891 - Delete multiq Qdisc twice
> ok 5 1329 - Add multiq Qdisc to single-queue device
>
> ./tdc.py -c netem
> ok 1 cb28 - Create NETEM with default setting
> ok 2 a089 - Create NETEM with limit flag
> ok 3 3449 - Create NETEM with delay time
> ok 4 3782 - Create NETEM with distribution and corrupt flag
> ok 5 2b82 - Create NETEM with distribution and duplicate flag
> ok 6 a932 - Create NETEM with distribution and loss flag
> ok 7 e01a - Create NETEM with distribution and loss state flag
> ok 8 ba29 - Create NETEM with loss gemodel flag
> ok 9 0492 - Create NETEM with reorder flag
> ok 10 7862 - Create NETEM with rate limit
> ok 11 7235 - Create NETEM with multiple slot rate
> ok 12 5439 - Create NETEM with multiple slot setting
> ok 13 5029 - Change NETEM with loss state
> ok 14 3785 - Replace NETEM with delay time
> ok 15 4502 - Delete NETEM with handle
> ok 16 0785 - Show NETEM class
>
> ./tdc.py -c qfq
> ok 1 0582 - Create QFQ with default setting
> ok 2 c9a3 - Create QFQ with class weight setting
> ok 3 8452 - Create QFQ with class maxpkt setting
> ok 4 d920 - Create QFQ with multiple class setting
> ok 5 0548 - Delete QFQ with handle
> ok 6 5901 - Show QFQ class
>
> ./tdc.py -e 0521
> ok 1 0521 - Show ingress class
>
> ./tdc.py -e 1023
> ok 1 1023 - Show mq class
>
> ./tdc.py -e 2410
> ok 1 2410 - Show prio class
>
> ./tdc.py -e 290a
> ok 1 290a - Show RED class
>
> Zhengchao Shao (18):
>    net/sched: sch_api: add helper for tc qdisc walker stats dump
>    net/sched: use tc_qdisc_stats_dump() in qdisc
>    selftests/tc-testings: add selftests for cake qdisc
>    selftests/tc-testings: add selftests for cbq qdisc
>    selftests/tc-testings: add selftests for cbs qdisc
>    selftests/tc-testings: add selftests for drr qdisc
>    selftests/tc-testings: add selftests for dsmark qdisc
>    selftests/tc-testings: add selftests for fq_codel qdisc
>    selftests/tc-testings: add selftests for hfsc qdisc
>    selftests/tc-testings: add selftests for htb qdisc
>    selftests/tc-testings: add selftests for mqprio qdisc
>    selftests/tc-testings: add selftests for multiq qdisc
>    selftests/tc-testings: add selftests for netem qdisc
>    selftests/tc-testings: add selftests for qfq qdisc
>    selftests/tc-testings: add show class case for ingress qdisc
>    selftests/tc-testings: add show class case for mq qdisc
>    selftests/tc-testings: add show class case for prio qdisc
>    selftests/tc-testings: add show class case for red qdisc
>
>   include/net/pkt_sched.h                       |  13 +
>   net/sched/sch_atm.c                           |   6 +-
>   net/sched/sch_cake.c                          |   9 +-
>   net/sched/sch_cbq.c                           |   9 +-
>   net/sched/sch_cbs.c                           |   8 +-
>   net/sched/sch_drr.c                           |   9 +-
>   net/sched/sch_dsmark.c                        |  14 +-
>   net/sched/sch_ets.c                           |   9 +-
>   net/sched/sch_fq_codel.c                      |   8 +-
>   net/sched/sch_hfsc.c                          |   9 +-
>   net/sched/sch_htb.c                           |   9 +-
>   net/sched/sch_mq.c                            |   5 +-
>   net/sched/sch_mqprio.c                        |   5 +-
>   net/sched/sch_multiq.c                        |   9 +-
>   net/sched/sch_netem.c                         |   8 +-
>   net/sched/sch_prio.c                          |   9 +-
>   net/sched/sch_qfq.c                           |   9 +-
>   net/sched/sch_red.c                           |   7 +-
>   net/sched/sch_sfb.c                           |   7 +-
>   net/sched/sch_sfq.c                           |   8 +-
>   net/sched/sch_skbprio.c                       |   9 +-
>   net/sched/sch_taprio.c                        |   5 +-
>   net/sched/sch_tbf.c                           |   7 +-
>   .../tc-testing/tc-tests/qdiscs/cake.json      | 487 ++++++++++++++++++
>   .../tc-testing/tc-tests/qdiscs/cbq.json       | 184 +++++++
>   .../tc-testing/tc-tests/qdiscs/cbs.json       | 234 +++++++++
>   .../tc-testing/tc-tests/qdiscs/drr.json       |  71 +++
>   .../tc-testing/tc-tests/qdiscs/dsmark.json    | 140 +++++
>   .../tc-testing/tc-tests/qdiscs/fq_codel.json  | 326 ++++++++++++
>   .../tc-testing/tc-tests/qdiscs/hfsc.json      | 167 ++++++
>   .../tc-testing/tc-tests/qdiscs/htb.json       | 285 ++++++++++
>   .../tc-testing/tc-tests/qdiscs/ingress.json   |  20 +
>   .../tc-testing/tc-tests/qdiscs/mq.json        |  24 +-
>   .../tc-testing/tc-tests/qdiscs/mqprio.json    | 114 ++++
>   .../tc-testing/tc-tests/qdiscs/multiq.json    | 114 ++++
>   .../tc-testing/tc-tests/qdiscs/netem.json     | 372 +++++++++++++
>   .../tc-testing/tc-tests/qdiscs/prio.json      |  20 +
>   .../tc-testing/tc-tests/qdiscs/qfq.json       | 145 ++++++
>   .../tc-testing/tc-tests/qdiscs/red.json       |  23 +
>   39 files changed, 2769 insertions(+), 148 deletions(-)
>   create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/cake.json
>   create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/cbq.json
>   create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/cbs.json
>   create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/drr.json
>   create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/dsmark.json
>   create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq_codel.json
>   create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/hfsc.json
>   create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/htb.json
>   create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/mqprio.json
>   create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/multiq.json
>   create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/netem.json
>   create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/qfq.json


Reviewed-by: Victor Nogueira <victor@mojatatu.com>
Tested-by: Victor Nogueira <victor@mojatatu.com>

