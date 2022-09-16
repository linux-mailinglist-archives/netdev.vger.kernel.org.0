Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC6D45BB398
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 22:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiIPUjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 16:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbiIPUjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 16:39:02 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71846BA165
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 13:39:00 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id x23-20020a056830409700b00655c6dace73so13352189ott.11
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 13:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=kyztAHqHuXiSURiu7DOqq1qRn6lQaXfCzteSotmFNvA=;
        b=ktlj8++dwdauzOkfjhOrnCWWfAOJ90lKMHch11rGPjIhvy2DZR8h4HcuVIWKhey/vL
         xjzHtE2kOQagRisqOMYFWWEes+McrsjtWDJmB9LZ8obyppFoZsaI7ZYeE+3fITxNwC1Y
         SdQYnCfzLz1ySPL4em2skkm5jClkQN0oTjMYcX5liT5tCJ4PiX9C3lkjYxxAuiyiLkDn
         IWA1IDR90jD7OVb/W9jyKzPLhjYxSrAtee8Rq0A9UUm0XPJT7YEHAARzagYuoZgZ8pJf
         ogdi4Swp22xtFYVbg9WbVHcIl8USoueUJabf18GwjYm3ELv2PFCQHkjDVDq2/OshbC0P
         34QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=kyztAHqHuXiSURiu7DOqq1qRn6lQaXfCzteSotmFNvA=;
        b=hTj5peQfDTbqFB6CUOhLggrGZ1kDhATo16qv+PtwRBH3M7I7wrxrXgrRPwpWsM8xX8
         pZELlI7FaYDInsyezSw6q98fwvmns5pRVKAaa09wBIfvU/nsU536SN1kDbXEjtI9wCl1
         9tM2G2FMXcalQuFnRLryv48rtnYAmEhkoXdcb1Kury1lV9D2xJQSBdFVqsieiQFeF54x
         JfXctTbNpy2xohmevFxpZ4/Ok9LtFbmwr8toNVNcCia5vfiJhwmMIiIPI/8HTXFMlt6Z
         n/AGE16WpQJafI2aORQIkvyP2cTUdJsjhoGr2TzzNALoTdQJOxBAEkVc7QMQi3kPWSqQ
         0miA==
X-Gm-Message-State: ACrzQf3pwguwYMCNWWMbi25XTCy8BR8viTqLirDtMG/NlE/IKa9NWVEQ
        zn3+gu52D6l8ZzjVDDNwaDlc3PS9A4PmnqmHO5+Ueg==
X-Google-Smtp-Source: AMsMyM6nBjHd9gKr+PBK2mnCGpDt8Uecxe+vY5rSFRZnE1+hDOax1UK9V4PqE7FOHlqn4KHhKHL3wm+IPuZV2VwdXAU=
X-Received: by 2002:a05:6830:2b28:b0:657:7798:2eda with SMTP id
 l40-20020a0568302b2800b0065777982edamr3121799otv.153.1663360739768; Fri, 16
 Sep 2022 13:38:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220916030544.228274-1-shaozhengchao@huawei.com> <20220916030544.228274-9-shaozhengchao@huawei.com>
In-Reply-To: <20220916030544.228274-9-shaozhengchao@huawei.com>
From:   Victor Nogueira <victor@mojatatu.com>
Date:   Fri, 16 Sep 2022 17:38:48 -0300
Message-ID: <CA+NMeC8syNuBGcFUtGEmxigsuh+pkWgT+hDVkioLye07vLHiiw@mail.gmail.com>
Subject: Re: [PATCH net-next 08/18] selftests/tc-testings: add selftests for
 fq_codel qdisc
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, toke@toke.dk, vinicius.gomes@intel.com,
        stephen@networkplumber.org, shuah@kernel.org,
        zhijianx.li@intel.com, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 16, 2022 at 12:04 AM Zhengchao Shao
<shaozhengchao@huawei.com> wrote:
>
> Test 4957: Create FQ_CODEL with default setting
> Test 7621: Create FQ_CODEL with limit setting
> Test 6872: Create FQ_CODEL with memory_limit setting
> Test 5636: Create FQ_CODEL with target setting
> Test 630a: Create FQ_CODEL with interval setting
> Test 4324: Create FQ_CODEL with quantum setting
> Test b190: Create FQ_CODEL with noecn flag
> Test c9d2: Create FQ_CODEL with ce_threshold setting
> Test 523b: Create FQ_CODEL with multiple setting
> Test 9283: Replace FQ_CODEL with noecn setting
> Test 3459: Change FQ_CODEL with limit setting
> Test 0128: Delete FQ_CODEL with handle
> Test 0435: Show FQ_CODEL class
>
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  .../tc-testing/tc-tests/qdiscs/fq_codel.json  | 326 ++++++++++++++++++
>  1 file changed, 326 insertions(+)
>  create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq_codel.json
>
> diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq_codel.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq_codel.json
> new file mode 100644
> index 000000000000..09608677cfee
> --- /dev/null
> +++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq_codel.json
> @@ -0,0 +1,326 @@
> +[
> +    {
> +        "id": "4957",
> +        "name": "Create FQ_CODEL with default setting",
> +        "category": [
> +            "qdisc",
> +            "fq_codel"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root fq_codel",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc fq_codel 1: root refcnt [0-9]+ limit 10240p flows 1024 quantum.*target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "7621",
> +        "name": "Create FQ_CODEL with limit setting",
> +        "category": [
> +            "qdisc",
> +            "fq_codel"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root fq_codel limit 1000",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc fq_codel 1: root refcnt [0-9]+ limit 1000p flows 1024 quantum.*target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "6872",
> +        "name": "Create FQ_CODEL with memory_limit setting",
> +        "category": [
> +            "qdisc",
> +            "fq_codel"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root fq_codel memory_limit 100000",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc fq_codel 1: root refcnt [0-9]+ limit 10240p flows 1024 quantum.*target 5ms interval 100ms memory_limit 100000b ecn drop_batch 64",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "5636",
> +        "name": "Create FQ_CODEL with target setting",
> +        "category": [
> +            "qdisc",
> +            "fq_codel"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root fq_codel target 2000",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc fq_codel 1: root refcnt [0-9]+ limit 10240p flows 1024 quantum.*target 2ms interval 100ms memory_limit 32Mb ecn drop_batch 64",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "630a",
> +        "name": "Create FQ_CODEL with interval setting",
> +        "category": [
> +            "qdisc",
> +            "fq_codel"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root fq_codel interval 5000",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc fq_codel 1: root refcnt [0-9]+ limit 10240p flows 1024 quantum.*target 5ms interval 5ms memory_limit 32Mb ecn drop_batch 64",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "4324",
> +        "name": "Create FQ_CODEL with quantum setting",
> +        "category": [
> +            "qdisc",
> +            "fq_codel"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root fq_codel quantum 9000",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc fq_codel 1: root refcnt [0-9]+ limit 10240p flows 1024 quantum 9000 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "b190",
> +        "name": "Create FQ_CODEL with noecn flag",
> +        "category": [
> +            "qdisc",
> +            "fq_codel"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root fq_codel noecn",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc fq_codel 1: root refcnt [0-9]+ limit 10240p flows 1024 quantum.*target 5ms interval 100ms memory_limit 32Mb drop_batch 64",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "c9d2",
> +        "name": "Create FQ_CODEL with ce_threshold setting",
> +        "category": [
> +            "qdisc",
> +            "fq_codel"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root fq_codel ce_threshold 1024000",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc fq_codel 1: root refcnt [0-9]+ limit 10240p flows 1024 quantum.*target 5ms ce_threshold 1.02s interval 100ms memory_limit 32Mb ecn drop_batch 64",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "c9d2",

Be careful, you are using ID c9d2 in the previous test case.

> +        "name": "Create FQ_CODEL with drop_batch setting",
> +        "category": [
> +            "qdisc",
> +            "fq_codel"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root fq_codel drop_batch 100",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc fq_codel 1: root refcnt [0-9]+ limit 10240p flows 1024 quantum.*target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 100",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "523b",
> +        "name": "Create FQ_CODEL with multiple setting",
> +        "category": [
> +            "qdisc",
> +            "fq_codel"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root fq_codel limit 1000 flows 256 drop_batch 100",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc fq_codel 1: root refcnt [0-9]+ limit 1000p flows 256 quantum.*target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 100",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "9283",
> +        "name": "Replace FQ_CODEL with noecn setting",
> +        "category": [
> +            "qdisc",
> +            "fq_codel"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true",
> +            "$TC qdisc add dev $DUMMY handle 1: root fq_codel limit 1000 flows 256 drop_batch 100"
> +        ],
> +        "cmdUnderTest": "$TC qdisc replace dev $DUMMY handle 1: root fq_codel noecn",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc fq_codel 1: root refcnt [0-9]+ limit 1000p flows 256 quantum.*target 5ms interval 100ms memory_limit 32Mb drop_batch 100",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "3459",
> +        "name": "Change FQ_CODEL with limit setting",
> +        "category": [
> +            "qdisc",
> +            "fq_codel"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true",
> +            "$TC qdisc add dev $DUMMY handle 1: root fq_codel limit 1000 flows 256 drop_batch 100"
> +        ],
> +        "cmdUnderTest": "$TC qdisc change dev $DUMMY handle 1: root fq_codel limit 2000",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc fq_codel 1: root refcnt [0-9]+ limit 2000p flows 256 quantum.*target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 100",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "0128",
> +        "name": "Delete FQ_CODEL with handle",
> +        "category": [
> +            "qdisc",
> +            "fq_codel"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true",
> +            "$TC qdisc add dev $DUMMY handle 1: root fq_codel limit 1000 flows 256 drop_batch 100"
> +        ],
> +        "cmdUnderTest": "$TC qdisc del dev $DUMMY handle 1: root",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc fq_codel 1: root refcnt [0-9]+ limit 1000p flows 256 quantum.*target 5ms interval 100ms memory_limit 32Mb noecn drop_batch 100",
> +        "matchCount": "0",
> +        "teardown": [
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "0435",
> +        "name": "Show FQ_CODEL class",
> +        "category": [
> +            "qdisc",
> +            "fq_codel"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root fq_codel",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC class show dev $DUMMY",
> +        "matchPattern": "class fq_codel 1:",
> +        "matchCount": "0",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    }
> +]
> --
> 2.17.1
>
