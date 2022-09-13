Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 889315B79C6
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 20:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232298AbiIMSjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 14:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232274AbiIMSjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 14:39:03 -0400
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E83871BC2
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 11:07:08 -0700 (PDT)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-12803ac8113so34303678fac.8
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 11:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=MQi9Bbfw9XnFHVcPd1bQsDiK62+GFLRxOqhN7Y+6wg4=;
        b=vjSffPyxalxpMxX0CFCxtY8fxSRkVZmON6EZzOz6/ytMl28PKXdJIftvvJSoSf9qjq
         pohdRdH/5hrccebA77of60HpU+0yZc1uLwhr6is3I2N09cV8FUE9djQDycgLpcvgxpQQ
         Z1ZbbamYsjecA43Evl/QgctRxTBJ6Nd+30rizoCDZADZeNsiplhJtWMWHq/Tjo/3Hi5H
         sah/TMDBApRT92Zn0hpzBcVNkRnIKLIirL+jYQdA0DPCq0dBqO9KnH1a5YcPNJmQaz7V
         4GjxWavCzNPzH3hwJ7i2FPVrZoynXrh7elLU5A2jiFuyjFFmX8ackmtIqAd/FI4Gjj7e
         dqLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=MQi9Bbfw9XnFHVcPd1bQsDiK62+GFLRxOqhN7Y+6wg4=;
        b=K45cQmUwOBfsr4kaH2MtMANtci4tsG+HgBmDjZNcM3CA/m4b++FYsWoJJNt3R50piS
         kUuw8EUENBXZS+Hhv4Sap7F0o5yDidw3H9V6y2Y78PoeQSYboJpC+Sfr2J1+0Lm1/IvX
         xePGtekua8BgJVc5LDYv6RN0IeAjQbsHM2JHJw2gw3KwVs7zN22erww2qS4iaEenUZ8W
         lbq22MrsvjccI/i+G0DTRVzv5wQNMYtQblCx0hmAAlTsq6iRfMfpWDLn6q1bDSk634sc
         3GBAZJCwzhtY91gE696SXV3/7KQ63LqGKCdku6GmUKqKnkyySdpRDAHH+c56+gJ6+QYG
         wbhA==
X-Gm-Message-State: ACgBeo0nB1ZzsBE7FLOw/JxovjGhSduIFC4MeTdASB3xWY3Jjit0KG2Y
        ZZg4drezrm+kNOWyXkW1J2IglngqitVdbLy6Offshg==
X-Google-Smtp-Source: AA6agR5HSuvCldagVq7W2t0mq2lWmgvPK5Afh5sxg8QZTHyJYc/MoHEPP5lPBikilMaz6/f2Nl7THvyiQumnSTBbONU=
X-Received: by 2002:a05:6870:1490:b0:126:e07:2a4a with SMTP id
 k16-20020a056870149000b001260e072a4amr315107oab.2.1663092427842; Tue, 13 Sep
 2022 11:07:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220913042135.58342-1-shaozhengchao@huawei.com>
In-Reply-To: <20220913042135.58342-1-shaozhengchao@huawei.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Tue, 13 Sep 2022 14:06:57 -0400
Message-ID: <CAM0EoM=U-9NCpBa9dxJ81+o7C1m=s=P55Ae7vawtu38b-XZKVQ@mail.gmail.com>
Subject: Re: [PATCH net-next 0/9] refactor duplicate codes in the tc cls walk function
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, shuah@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the effort you are putting into this.
The patches look good to me - and i think you got what Cong was asking for
last time with 2/9. I will wait for Victor to review and even run the
tdc tests first before putting my ack.
For now:
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal



On Tue, Sep 13, 2022 at 12:20 AM Zhengchao Shao
<shaozhengchao@huawei.com> wrote:
>
> The walk implementation of most tc cls modules is basically the same.
> That is, the values of count and skip are checked first. If count is
> greater than or equal to skip, the registered fn function is executed.
> Otherwise, increase the value of count. So the code can be refactored.
> Then use helper function to replace the code of each cls module in
> alphabetical order.
>
> The walk function is invoked during dump. Therefore, test cases related
>  to the tdc filter need to be added.
>
> Add test cases locally and perform the test. The test results are listed
> below:
>
> ./tdc.py -e 0811
> ok 1 0811 - Add multiple basic filter with cmp ematch u8/link layer and
> default action and dump them
>
> ./tdc.py -e 5129
> ok 1 5129 - List basic filters
>
> ./tdc.py -c filters bpf
> ok 13 23c3 - Add cBPF filter with valid bytecode
> ok 14 1563 - Add cBPF filter with invalid bytecode
> ok 15 2334 - Add eBPF filter with valid object-file
> ok 16 2373 - Add eBPF filter with invalid object-file
> ok 17 4423 - Replace cBPF bytecode
> ok 18 5122 - Delete cBPF filter
> ok 19 e0a9 - List cBPF filters
>
> ./tdc.py -c filters cgroup
> ok 1 6273 - Add cgroup filter with cmp ematch u8/link layer and drop
> action
> ok 2 4721 - Add cgroup filter with cmp ematch u8/link layer with trans
> flag and pass action
> ok 3 d392 - Add cgroup filter with cmp ematch u16/link layer and pipe
> action
> ok 4 0234 - Add cgroup filter with cmp ematch u32/link layer and miltiple
> actions
> ok 5 8499 - Add cgroup filter with cmp ematch u8/network layer and pass
> action
> ok 6 b273 - Add cgroup filter with cmp ematch u8/network layer with trans
> flag and drop action
> ok 7 1934 - Add cgroup filter with cmp ematch u16/network layer and pipe
> action
> ok 8 2733 - Add cgroup filter with cmp ematch u32/network layer and
> miltiple actions
> ok 9 3271 - Add cgroup filter with NOT cmp ematch rule and pass action
> ok 10 2362 - Add cgroup filter with two ANDed cmp ematch rules and single
> action
> ok 11 9993 - Add cgroup filter with two ORed cmp ematch rules and single
> action
> ok 12 2331 - Add cgroup filter with two ANDed cmp ematch rules and one
> ORed ematch rule and single action
> ok 13 3645 - Add cgroup filter with two ANDed cmp ematch rules and one
> NOT ORed ematch rule and single action
> ok 14 b124 - Add cgroup filter with u32 ematch u8/zero offset and drop
> action
> ok 15 7381 - Add cgroup filter with u32 ematch u8/zero offset and invalid
> value >0xFF
> ok 16 2231 - Add cgroup filter with u32 ematch u8/positive offset and
> drop action
> ok 17 1882 - Add cgroup filter with u32 ematch u8/invalid mask >0xFF
> ok 18 1237 - Add cgroup filter with u32 ematch u8/missing offset
> ok 19 3812 - Add cgroup filter with u32 ematch u8/missing AT keyword
> ok 20 1112 - Add cgroup filter with u32 ematch u8/missing value
> ok 21 3241 - Add cgroup filter with u32 ematch u8/non-numeric value
> ok 22 e231 - Add cgroup filter with u32 ematch u8/non-numeric mask
> ok 23 4652 - Add cgroup filter with u32 ematch u8/negative offset and
> pass action
> ok 24 1331 - Add cgroup filter with u32 ematch u16/zero offset and pipe
> action
> ok 25 e354 - Add cgroup filter with u32 ematch u16/zero offset and
> invalid value >0xFFFF
> ok 26 3538 - Add cgroup filter with u32 ematch u16/positive offset and
> drop action
> ok 27 4576 - Add cgroup filter with u32 ematch u16/invalid mask >0xFFFF
> ok 28 b842 - Add cgroup filter with u32 ematch u16/missing offset
> ok 29 c924 - Add cgroup filter with u32 ematch u16/missing AT keyword
> ok 30 cc93 - Add cgroup filter with u32 ematch u16/missing value
> ok 31 123c - Add cgroup filter with u32 ematch u16/non-numeric value
> ok 32 3675 - Add cgroup filter with u32 ematch u16/non-numeric mask
> ok 33 1123 - Add cgroup filter with u32 ematch u16/negative offset and
> drop action
> ok 34 4234 - Add cgroup filter with u32 ematch u16/nexthdr+ offset and
> pass action
> ok 35 e912 - Add cgroup filter with u32 ematch u32/zero offset and pipe
> action
> ok 36 1435 - Add cgroup filter with u32 ematch u32/positive offset and
> drop action
> ok 37 1282 - Add cgroup filter with u32 ematch u32/missing offset
> ok 38 6456 - Add cgroup filter with u32 ematch u32/missing AT keyword
> ok 39 4231 - Add cgroup filter with u32 ematch u32/missing value
> ok 40 2131 - Add cgroup filter with u32 ematch u32/non-numeric value
> ok 41 f125 - Add cgroup filter with u32 ematch u32/non-numeric mask
> ok 42 4316 - Add cgroup filter with u32 ematch u32/negative offset and
> drop action
> ok 43 23ae - Add cgroup filter with u32 ematch u32/nexthdr+ offset and
> pipe action
> ok 44 23a1 - Add cgroup filter with canid ematch and single SFF
> ok 45 324f - Add cgroup filter with canid ematch and single SFF with mask
> ok 46 2576 - Add cgroup filter with canid ematch and multiple SFF
> ok 47 4839 - Add cgroup filter with canid ematch and multiple SFF with
> masks
> ok 48 6713 - Add cgroup filter with canid ematch and single EFF
> ok 49 4572 - Add cgroup filter with canid ematch and single EFF with mask
> ok 50 8031 - Add cgroup filter with canid ematch and multiple EFF
> ok 51 ab9d - Add cgroup filter with canid ematch and multiple EFF with
> masks
> ok 52 5349 - Add cgroup filter with canid ematch and a combination of
> SFF/EFF
> ok 53 c934 - Add cgroup filter with canid ematch and a combination of
> SFF/EFF with masks
> ok 54 4319 - Replace cgroup filter with diffferent match
> ok 55 4636 - Detele cgroup filter
>
> ./tdc.py -c filters flow
> ok 1 5294 - Add flow filter with map key and ops
> ok 2 3514 - Add flow filter with map key or ops
> ok 3 7534 - Add flow filter with map key xor ops
> ok 4 4524 - Add flow filter with map key rshift ops
> ok 5 0230 - Add flow filter with map key addend ops
> ok 6 2344 - Add flow filter with src map key
> ok 7 9304 - Add flow filter with proto map key
> ok 8 9038 - Add flow filter with proto-src map key
> ok 9 2a03 - Add flow filter with proto-dst map key
> ok 10 a073 - Add flow filter with iif map key
> ok 11 3b20 - Add flow filter with priority map key
> ok 12 8945 - Add flow filter with mark map key
> ok 13 c034 - Add flow filter with nfct map key
> ok 14 0205 - Add flow filter with nfct-src map key
> ok 15 5315 - Add flow filter with nfct-src map key
> ok 16 7849 - Add flow filter with nfct-proto-src map key
> ok 17 9902 - Add flow filter with nfct-proto-dst map key
> ok 18 6742 - Add flow filter with rt-classid map key
> ok 19 5432 - Add flow filter with sk-uid map key
> ok 20 4234 - Add flow filter with sk-gid map key
> ok 21 4522 - Add flow filter with vlan-tag map key
> ok 22 4253 - Add flow filter with rxhash map key
> ok 23 4452 - Add flow filter with hash key list
> ok 24 4341 - Add flow filter with muliple ops
> ok 25 4322 - List flow filters
> ok 26 2320 - Replace flow filter with map key num
> ok 27 3213 - Delete flow filter with map key num
>
> ./tdc.py -c filters route
> ok 1 e122 - Add route filter with from and to tag
> ok 2 6573 - Add route filter with fromif and to tag
> ok 3 1362 - Add route filter with to flag and reclassify action
> ok 4 4720 - Add route filter with from flag and continue actions
> ok 5 2812 - Add route filter with form tag and pipe action
> ok 6 7994 - Add route filter with miltiple actions
> ok 7 4312 - List route filters
> ok 8 2634 - Delete route filters with pipe action
>
> ./tdc.py -c filters rsvp
> ok 1 2141 - Add rsvp filter with tcp proto and specific IP address
> ok 2 5267 - Add rsvp filter with udp proto and specific IP address
> ok 3 2819 - Add rsvp filter with src ip and src port
> ok 4 c967 - Add rsvp filter with tunnelid and continue action
> ok 5 5463 - Add rsvp filter with tunnel and pipe action
> ok 6 2332 - Add rsvp filter with miltiple actions
> ok 7 8879 - Add rsvp filter with tunnel and skp flag
> ok 8 8261 - List rsvp filters
> ok 9 8989 - Delete rsvp filters
>
> ./tdc.py -c filters tcindex
> ok 1 8293 - Add tcindex filter with default action
> ok 2 7281 - Add tcindex filter with hash size and pass action
> ok 3 b294 - Add tcindex filter with mask shift and reclassify action
> ok 4 0532 - Add tcindex filter with pass_on and continue actions
> ok 5 d473 - Add tcindex filter with pipe action
> ok 6 2940 - Add tcindex filter with miltiple actions
> ok 7 1893 - List tcindex filters
> ok 8 2041 - Change tcindex filters with pass action
> ok 9 9203 - Replace tcindex filters with pass action
> ok 10 7957 - Delete tcindex filters with drop action
>
> Zhengchao Shao (9):
>   net/sched: cls_api: add helper for tc cls walker stats updating
>   net/sched: use tc_cls_stats_update() in filter
>   selftests/tc-testings: add selftests for bpf filter
>   selftests/tc-testings: add selftests for cgroup filter
>   selftests/tc-testings: add selftests for flow filter
>   selftests/tc-testings: add selftests for route filter
>   selftests/tc-testings: add selftests for rsvp filter
>   selftests/tc-testings: add selftests for tcindex filter
>   selftests/tc-testings: add list case for basic filter
>
>  include/net/pkt_cls.h                         |   13 +
>  net/sched/cls_basic.c                         |    9 +-
>  net/sched/cls_bpf.c                           |    8 +-
>  net/sched/cls_flow.c                          |    8 +-
>  net/sched/cls_fw.c                            |    9 +-
>  net/sched/cls_route.c                         |    9 +-
>  net/sched/cls_rsvp.h                          |    9 +-
>  net/sched/cls_tcindex.c                       |   18 +-
>  net/sched/cls_u32.c                           |   20 +-
>  .../tc-testing/tc-tests/filters/basic.json    |   47 +
>  .../tc-testing/tc-tests/filters/bpf.json      |  171 +++
>  .../tc-testing/tc-tests/filters/cgroup.json   | 1236 +++++++++++++++++
>  .../tc-testing/tc-tests/filters/flow.json     |  623 +++++++++
>  .../tc-testing/tc-tests/filters/route.json    |  181 +++
>  .../tc-testing/tc-tests/filters/rsvp.json     |  203 +++
>  .../tc-testing/tc-tests/filters/tcindex.json  |  227 +++
>  16 files changed, 2716 insertions(+), 75 deletions(-)
>  create mode 100644 tools/testing/selftests/tc-testing/tc-tests/filters/bpf.json
>  create mode 100644 tools/testing/selftests/tc-testing/tc-tests/filters/cgroup.json
>  create mode 100644 tools/testing/selftests/tc-testing/tc-tests/filters/flow.json
>  create mode 100644 tools/testing/selftests/tc-testing/tc-tests/filters/route.json
>  create mode 100644 tools/testing/selftests/tc-testing/tc-tests/filters/rsvp.json
>  create mode 100644 tools/testing/selftests/tc-testing/tc-tests/filters/tcindex.json
>
> --
> 2.17.1
>
