Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF56B5BB38B
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 22:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbiIPUdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 16:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbiIPUdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 16:33:02 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB3BB8F34
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 13:32:57 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id x23-20020a056830409700b00655c6dace73so13342247ott.11
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 13:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=pnH8rAyxbku61mBev6Jx8gS65j3hOthJPRKsdFuYagI=;
        b=nao/rFeM0ITgf1gOLYPFwOOhKVqAozDkZZeXtit5XFRkiajZcvR40dJ88lDRaJILj9
         G9QBr1v3SEom3/S0wUf9YdGFuTu5ryr6mscNhateVzFGoKiLzc4PwBg+IXU49r0ks3aq
         W3InY5EQxNgx9vV5ByEzE8XzGf1eR2Wcy0MouYOQoVjvvaQqeordI7vY5fnOUAoabb4f
         V9bX71SY5d0YDBxrSRWQteVJuKAkLYS8/g+Ctlhe0rQtsZe1D/FQBJn9M13y9SyGlcPy
         A9aPHEQMULvZTyHMwxLY1vwmyBlhDi3tnuDM5r+YqrpeAKK6D2hS+kDMJ3BskO4KMrfN
         IWKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=pnH8rAyxbku61mBev6Jx8gS65j3hOthJPRKsdFuYagI=;
        b=aYkfy/bvbX3Fd7LfIj2d/3z8W0krTmDFwliLKG1UwytCZgkqYluMN6Cih6BleKEx4A
         gRRgOzp7xB5RY1B5eUWIMi8kXWLUo/dTq0Y9kj06HGe/BLonmaIyPK+ZCjN8t7pArN+E
         cdZAonFlXSJEqEjbtnxLU/2Zlxf7oYDiP0LMAVbllG/vi8t9u5LNwDuINyc9eeVdPFKz
         ev2W6BT4TOUfLbHfk2wZxfFshWrELY3FQ2O3ayfBjpU+yH4uProV7apMHG128OWlcUNp
         14i+A3AlnJeyqBP9H0Df1+MmD6phhbBJujOBCnA0MMvUpyUZ0TEdBcSeq6LHkLAfqIqD
         Hedg==
X-Gm-Message-State: ACrzQf2ZAjg+pN1uo0IHGpg4dmB0ZCqQsGdmYFH+raEVOOSwx2pGdXDV
        ml9ZNFcicVMd1/504D/NwSNSbQOulDRDXeMFEl2yXg==
X-Google-Smtp-Source: AMsMyM4QOUkbJ0H5MRmucA1btE7d2BDT7rvI417cAMCqkMhZjzPeeI4Bz/txnwkODhBDt+HZeyf3TEq/UL/TZNMVsrw=
X-Received: by 2002:a05:6830:2b28:b0:657:7798:2eda with SMTP id
 l40-20020a0568302b2800b0065777982edamr3112364otv.153.1663360377153; Fri, 16
 Sep 2022 13:32:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220916030544.228274-1-shaozhengchao@huawei.com> <20220916030544.228274-4-shaozhengchao@huawei.com>
In-Reply-To: <20220916030544.228274-4-shaozhengchao@huawei.com>
From:   Victor Nogueira <victor@mojatatu.com>
Date:   Fri, 16 Sep 2022 17:32:46 -0300
Message-ID: <CA+NMeC935wcGnHGQ=-PmSuLjUOx+r5g2LVJ5-8t-8o_V5hjrNQ@mail.gmail.com>
Subject: Re: [PATCH net-next 03/18] selftests/tc-testings: add selftests for
 cake qdisc
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
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 16, 2022 at 12:04 AM Zhengchao Shao
<shaozhengchao@huawei.com> wrote:
>
> Test 1212: Create CAKE with default setting
> Test 3241: Create CAKE with bandwidth limit
> Test c940: Create CAKE with autorate-ingress flag
> Test 2310: Create CAKE with rtt time
> Test 2385: Create CAKE with besteffort flag
> Test a032: Create CAKE with diffserv8 flag
> Test 2349: Create CAKE with diffserv4 flag
> Test 8472: Create CAKE with flowblind flag
> Test 2341: Create CAKE with dsthost and nat flag
> Test 5134: Create CAKE with wash flag
> Test 2302: Create CAKE with flowblind and no-split-gso flag
> Test 0768: Create CAKE with dual-srchost and ack-filter flag
> Test 0238: Create CAKE with dual-dsthost and ack-filter-aggressive flag
> Test 6573: Create CAKE with memlimit and ptm flag
> Test 2436: Create CAKE with fwmark and atm flag
> Test 3984: Create CAKE with overhead and mpu
> Test 2342: Create CAKE with conservative and ingress flag
> Test 2313: Change CAKE with mpu
> Test 4365: Show CAKE class
>
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  .../tc-testing/tc-tests/qdiscs/cake.json      | 488 ++++++++++++++++++
>  1 file changed, 488 insertions(+)
>  create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/cake.json
>
> diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/cake.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/cake.json
> new file mode 100644
> index 000000000000..11ca18bab721
> --- /dev/null
> +++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/cake.json
> @@ -0,0 +1,488 @@
> +[
> +    {
> +        "id": "1212",
> +        "name": "Create CAKE with default setting",
> +        "category": [
> +            "qdisc",
> +            "cake"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cake",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc cake 1: root refcnt [0-9]+ bandwidth unlimited diffserv3 triple-isolate nonat nowash no-ack-filter split-gso rtt 100ms raw overhead",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "3241",
> +        "name": "Create CAKE with bandwidth limit",
> +        "category": [
> +            "qdisc",
> +            "cake"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cake bandwidth 1000",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc cake 1: root refcnt [0-9]+ bandwidth 1Kbit diffserv3 triple-isolate nonat nowash no-ack-filter split-gso rtt 100ms raw overhead",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "c940",
> +        "name": "Create CAKE with autorate-ingress flag",
> +        "category": [
> +            "qdisc",
> +            "cake"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cake autorate-ingress",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc cake 1: root refcnt [0-9]+ bandwidth unlimited autorate-ingress diffserv3 triple-isolate nonat nowash no-ack-filter split-gso rtt 100ms raw overhead",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "2310",
> +        "name": "Create CAKE with rtt time",
> +        "category": [
> +            "qdisc",
> +            "cake"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cake rtt 200",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc cake 1: root refcnt [0-9]+ bandwidth unlimited diffserv3 triple-isolate nonat nowash no-ack-filter split-gso rtt 200us raw overhead",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "2385",
> +        "name": "Create CAKE with besteffort flag",
> +        "category": [
> +            "qdisc",
> +            "cake"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cake besteffort",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc cake 1: root refcnt [0-9]+ bandwidth unlimited besteffort triple-isolate nonat nowash no-ack-filter split-gso rtt 100ms raw overhead",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "a032",
> +        "name": "Create CAKE with diffserv8 flag",
> +        "category": [
> +            "qdisc",
> +            "cake"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cake diffserv8",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc cake 1: root refcnt [0-9]+ bandwidth unlimited diffserv8 triple-isolate nonat nowash no-ack-filter split-gso rtt 100ms raw overhead",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "2349",
> +        "name": "Create CAKE with diffserv4 flag",
> +        "category": [
> +            "qdisc",
> +            "cake"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cake diffserv4",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc cake 1: root refcnt [0-9]+ bandwidth unlimited diffserv4 triple-isolate nonat nowash no-ack-filter split-gso rtt 100ms raw overhead",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "8472",
> +        "name": "Create CAKE with flowblind flag",
> +        "category": [
> +            "qdisc",
> +            "cake"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cake flowblind",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc cake 1: root refcnt [0-9]+ bandwidth unlimited diffserv3 flowblind nonat nowash no-ack-filter split-gso rtt 100ms raw overhead",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "2341",
> +        "name": "Create CAKE with dsthost and nat flag",
> +        "category": [
> +            "qdisc",
> +            "cake"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cake dsthost nat",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc cake 1: root refcnt [0-9]+ bandwidth unlimited diffserv3 dsthost nat nowash no-ack-filter split-gso rtt 100ms raw overhead",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "5134",
> +        "name": "Create CAKE with wash flag",
> +        "category": [
> +            "qdisc",
> +            "cake"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cake hosts wash",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc cake 1: root refcnt [0-9]+ bandwidth unlimited diffserv3 hosts nonat wash no-ack-filter split-gso rtt 100ms raw overhead",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "2302",
> +        "name": "Create CAKE with flowblind and no-split-gso flag",
> +        "category": [
> +            "qdisc",
> +            "cake"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cake flowblind no-split-gso",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc cake 1: root refcnt [0-9]+ bandwidth unlimited diffserv3 flowblind nonat nowash no-ack-filter no-split-gso rtt 100ms raw overhead",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "0768",
> +        "name": "Create CAKE with dual-srchost and ack-filter flag",
> +        "category": [
> +            "qdisc",
> +            "cake"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cake dual-srchost ack-filter",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc cake 1: root refcnt [0-9]+ bandwidth unlimited diffserv3 dual-srchost nonat nowash ack-filter split-gso rtt 100ms raw overhead",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "0238",
> +        "name": "Create CAKE with dual-dsthost and ack-filter-aggressive flag",
> +        "category": [
> +            "qdisc",
> +            "cake"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cake dual-dsthost ack-filter-aggressive",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc cake 1: root refcnt [0-9]+ bandwidth unlimited diffserv3 dual-dsthost nonat nowash ack-filter-aggressive split-gso rtt 100ms raw overhead",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "6573",
> +        "name": "Create CAKE with memlimit and ptm flag",
> +        "category": [
> +            "qdisc",
> +            "cake"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cake memlimit 10000 ptm",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc cake 1: root refcnt [0-9]+ bandwidth unlimited diffserv3 triple-isolate nonat nowash no-ack-filter split-gso rtt 100ms raw ptm overhead 0 memlimit 10000b",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "2436",
> +        "name": "Create CAKE with fwmark and atm flag",
> +        "category": [
> +            "qdisc",
> +            "cake"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cake fwmark 8 atm",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc cake 1: root refcnt [0-9]+ bandwidth unlimited diffserv3 triple-isolate nonat nowash no-ack-filter split-gso rtt 100ms raw atm overhead 0 fwmark 0x8",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "3984",
> +        "name": "Create CAKE with overhead and mpu",
> +        "category": [
> +            "qdisc",
> +            "cake"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cake overhead 128 mpu 256",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc cake 1: root refcnt [0-9]+ bandwidth unlimited diffserv3 triple-isolate nonat nowash no-ack-filter split-gso rtt 100ms noatm overhead 128 mpu 256",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "2342",
> +        "name": "Create CAKE with conservative and ingress flag",
> +        "category": [
> +            "qdisc",
> +            "cake"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cake conservative ingress",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc cake 1: root refcnt [0-9]+ bandwidth unlimited diffserv3 triple-isolate nonat nowash ingress no-ack-filter split-gso rtt 100ms atm overhead 48",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "2342",

Be careful, you are using ID 2342 for 3 test cases in this file.
Each test case must have a unique ID.



> +        "name": "Delete CAKE with conservative and ingress flag",
> +        "category": [
> +            "qdisc",
> +            "cake"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true",
> +            "$TC qdisc add dev $DUMMY handle 1: root cake conservative ingress"
> +        ],
> +        "cmdUnderTest": "$TC qdisc del dev $DUMMY handle 1: root",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc cake 1: root refcnt [0-9]+ bandwidth unlimited diffserv3 triple-isolate nonat nowash ingress no-ack-filter split-gso rtt 100ms atm overhead 48",
> +        "matchCount": "0",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "2342",
> +        "name": "Replace CAKE with mpu",
> +        "category": [
> +            "qdisc",
> +            "cake"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true",
> +            "$TC qdisc add dev $DUMMY handle 1: root cake overhead 128 mpu 256"
> +        ],
> +        "cmdUnderTest": "$TC qdisc replace dev $DUMMY handle 1: root cake mpu 128",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc cake 1: root refcnt [0-9]+ bandwidth unlimited diffserv3 triple-isolate nonat nowash no-ack-filter split-gso rtt 100ms noatm overhead 128 mpu 128",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "2313",
> +        "name": "Change CAKE with mpu",
> +        "category": [
> +            "qdisc",
> +            "cake"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true",
> +            "$TC qdisc add dev $DUMMY handle 1: root cake overhead 128 mpu 256"
> +        ],
> +        "cmdUnderTest": "$TC qdisc change dev $DUMMY handle 1: root cake mpu 128",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc cake 1: root refcnt [0-9]+ bandwidth unlimited diffserv3 triple-isolate nonat nowash no-ack-filter split-gso rtt 100ms noatm overhead 128 mpu 128",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "4365",
> +        "name": "Show CAKE class",
> +        "category": [
> +            "qdisc",
> +            "cake"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cake",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC class show dev $DUMMY",
> +        "matchPattern": "class cake",
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
