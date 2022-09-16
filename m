Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7570B5BB3A2
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 22:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbiIPUoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 16:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbiIPUoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 16:44:15 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A627FF90
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 13:44:13 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id m130so7542202oif.6
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 13:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=qaqaEny/sBPOd8+H9ejVkeT0pJ935p7TgqoAVrkLtAA=;
        b=sTWPE3exqk4jUDtHu/Cn7kRBLUQSV7g56RWxn1YZCAXbpPVuM5aWnCt57tKV9Q9iLa
         IyAPIQq3Prwu+8i8sXSOY3+z9xtXVeBibSm5XyUQh4MFwYCC+fP5o6K99yVAbthCIvkD
         XtutQuFMVROePQ2j4LT/vAGr8HSlPOjXGxdxrStzH70SVJB8DiYr6nQSEQPN6v/4HCa3
         CxfC8UuT7d6YGLJTzaBc28uqwaWeO7UWCrxToX1XvThjxpqzNBpxbD3ns/LNDR+elSt7
         huOuoZ/n4c1kB3msk8XYrjjtWpxxEOZYGPfamxSxp2OvciZ6Yrpnzu8+WqA6AxKThhuF
         5B8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=qaqaEny/sBPOd8+H9ejVkeT0pJ935p7TgqoAVrkLtAA=;
        b=kuRlQT1NZTgGzbCT9SrqtGnTNolsQ5Rfc51D4bv0zjJnhtE5AkYCelK5APi0BPS3FC
         yQiH5rLPvGObLewfyLH3QesbZqjTF9EoeIM4kVOsKPL0WSFb3oQGCPMsFDJbWOt8HIR6
         feGuhgsaLSCZvQ6GleN+Qma2KGOYpbfu6P6Ihwg0EDd8vXLNU2E77k2aCaUFbZqlRc77
         GPQCt3wXyRaQuFogC+SnFCcusjd6/GS0Ig2GDgyXUJNX2EiEMnKjvqTqwvqranC8nGuP
         VEVSdMKG/Ko610CX+0YepLzvxbL+jKHLiNgO1LajoTZQha+19xl7XhVN7kryUsnuzCXy
         1sZA==
X-Gm-Message-State: ACrzQf0Bfru7ZFOH4Hignu1+y1rwazZrdEiX53rJjokINNJo4bF0jf5C
        zFmAo8s8D5fPk9G3fVhtSBbtO41aiewR3kAeFaHASA==
X-Google-Smtp-Source: AMsMyM4yZdDj6SY4GY95qBGV1CZ7ysOz2AHSb6E8E6gzVuyU3ARh8P4KVgiCA8iRMSGQGUXTkgfgy8psJviemq+aP9Q=
X-Received: by 2002:a05:6808:21a3:b0:345:3202:e2a1 with SMTP id
 be35-20020a05680821a300b003453202e2a1mr3256163oib.268.1663361053225; Fri, 16
 Sep 2022 13:44:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220916030544.228274-1-shaozhengchao@huawei.com> <20220916030544.228274-14-shaozhengchao@huawei.com>
In-Reply-To: <20220916030544.228274-14-shaozhengchao@huawei.com>
From:   Victor Nogueira <victor@mojatatu.com>
Date:   Fri, 16 Sep 2022 17:44:02 -0300
Message-ID: <CA+NMeC852sL-PRYvtEZEe463Y-uBxLKEbAZuJE8XesW3A7_wog@mail.gmail.com>
Subject: Re: [PATCH net-next 13/18] selftests/tc-testings: add selftests for
 netem qdisc
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, cake@lists.bufferbloat.net,
        linux-kselftest@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        toke@toke.dk, vinicius.gomes@intel.com, stephen@networkplumber.org,
        shuah@kernel.org, zhijianx.li@intel.com, weiyongjun1@huawei.com,
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
> Test cb28: Create NETEM with default setting
> Test a089: Create NETEM with limit flag
> Test 3449: Create NETEM with delay time
> Test 3782: Create NETEM with distribution and corrupt flag
> Test a932: Create NETEM with distribution and duplicate flag
> Test e01a: Create NETEM with distribution and loss state flag
> Test ba29: Create NETEM with loss gemodel flag
> Test 0492: Create NETEM with reorder flag
> Test 7862: Create NETEM with rate limit
> Test 7235: Create NETEM with multiple slot rate
> Test 5439: Create NETEM with multiple slot setting
> Test 5029: Change NETEM with loss state
> Test 3785: Replace NETEM with delay time
> Test 4502: Delete NETEM with handle
> Test 0785: Show NETEM class
>
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  .../tc-testing/tc-tests/qdiscs/netem.json     | 372 ++++++++++++++++++
>  1 file changed, 372 insertions(+)
>  create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/netem.json
>
> diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/netem.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/netem.json
> new file mode 100644
> index 000000000000..c8ce7883bd9f
> --- /dev/null
> +++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/netem.json
> @@ -0,0 +1,372 @@
> +[
> +    {
> +        "id": "cb28",
> +        "name": "Create NETEM with default setting",
> +        "category": [
> +            "qdisc",
> +            "netem"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root netem",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc netem 1: root refcnt [0-9]+ limit",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "a089",
> +        "name": "Create NETEM with limit flag",
> +        "category": [
> +            "qdisc",
> +            "netem"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root netem limit 200",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc netem 1: root refcnt [0-9]+ limit 200",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "3449",
> +        "name": "Create NETEM with delay time",
> +        "category": [
> +            "qdisc",
> +            "netem"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root netem delay 100ms",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc netem 1: root refcnt [0-9]+ .*delay 100ms",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "3782",
> +        "name": "Create NETEM with distribution and corrupt flag",
> +        "category": [
> +            "qdisc",
> +            "netem"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root netem delay 100ms 10ms distribution normal corrupt 1%",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc netem 1: root refcnt [0-9]+ .*delay 100ms  10ms corrupt 1%",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "a932",
> +        "name": "Create NETEM with distribution and duplicate flag",
> +        "category": [
> +            "qdisc",
> +            "netem"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root netem delay 100ms 10ms distribution normal duplicate 1%",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc netem 1: root refcnt [0-9]+ .*delay 100ms  10ms duplicate 1%",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "a932",

Be careful, you are using ID a932 in the previous test case.

> +        "name": "Create NETEM with distribution and loss flag",
> +        "category": [
> +            "qdisc",
> +            "netem"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root netem delay 100ms 10ms distribution pareto loss 1%",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc netem 1: root refcnt [0-9]+ .*delay 100ms  10ms loss 1%",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "e01a",
> +        "name": "Create NETEM with distribution and loss state flag",
> +        "category": [
> +            "qdisc",
> +            "netem"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root netem delay 100ms 10ms distribution paretonormal loss state 1",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc netem 1: root refcnt [0-9]+ .*delay 100ms  10ms loss state p13 1% p31 99% p32 0% p23 100% p14 0%",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "ba29",
> +        "name": "Create NETEM with loss gemodel flag",
> +        "category": [
> +            "qdisc",
> +            "netem"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root netem loss gemodel 1%",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc netem 1: root refcnt [0-9]+ .*loss gemodel p 1%",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "0492",
> +        "name": "Create NETEM with reorder flag",
> +        "category": [
> +            "qdisc",
> +            "netem"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root netem delay 100ms 10ms reorder 2% gap 100",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc netem 1: root refcnt [0-9]+ .*reorder 2%",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "7862",
> +        "name": "Create NETEM with rate limit",
> +        "category": [
> +            "qdisc",
> +            "netem"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root netem rate 20000",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc netem 1: root refcnt [0-9]+ .*rate 20Kbit",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "7235",
> +        "name": "Create NETEM with multiple slot rate",
> +        "category": [
> +            "qdisc",
> +            "netem"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root netem slot 10 200 packets 2000 bytes 9000",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc netem 1: root refcnt [0-9]+ .*slot 10ns 200ns packets 2000 bytes 9000",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "5439",
> +        "name": "Create NETEM with multiple slot setting",
> +        "category": [
> +            "qdisc",
> +            "netem"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root netem slot distribution pareto 1ms 0.1ms",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc netem 1: root refcnt [0-9]+ .*slot distribution 1ms 100us",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "5029",
> +        "name": "Change NETEM with loss state",
> +        "category": [
> +            "qdisc",
> +            "netem"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true",
> +            "$TC qdisc add dev $DUMMY handle 1: root netem delay 100ms 10ms distribution normal loss 1%"
> +        ],
> +        "cmdUnderTest": "$TC qdisc change dev $DUMMY handle 1: root netem delay 100ms 10ms distribution normal loss 2%",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc netem 1: root refcnt [0-9]+ .*loss 2%",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "3785",
> +        "name": "Replace NETEM with delay time",
> +        "category": [
> +            "qdisc",
> +            "netem"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true",
> +            "$TC qdisc add dev $DUMMY handle 1: root netem delay 100ms 10ms distribution normal loss 1%"
> +        ],
> +        "cmdUnderTest": "$TC qdisc replace dev $DUMMY handle 1: root netem delay 200ms 10ms",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc netem 1: root refcnt [0-9]+ .*delay 200ms  10ms",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "4502",
> +        "name": "Delete NETEM with handle",
> +        "category": [
> +            "qdisc",
> +            "netem"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true",
> +            "$TC qdisc add dev $DUMMY handle 1: root netem delay 100ms 10ms distribution normal"
> +        ],
> +        "cmdUnderTest": "$TC qdisc del dev $DUMMY handle 1: root",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc netem 1: root refcnt [0-9]+ .*delay 100ms  10ms",
> +        "matchCount": "0",
> +        "teardown": [
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "0785",
> +        "name": "Show NETEM class",
> +        "category": [
> +            "qdisc",
> +            "netem"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root netem",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC class show dev $DUMMY",
> +        "matchPattern": "class netem 1:",
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
