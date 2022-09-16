Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08C905BB393
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 22:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbiIPUgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 16:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiIPUgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 16:36:35 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B666DB99CD
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 13:36:34 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id o184so7526749oif.13
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 13:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=qNgM/TndfAax0dsoj6SwDLTXPGx8d6rJAaaKl5p2/kw=;
        b=ooLBY1DSSf9K7dL6b3oMD5uEzb0uJJ2GvQsgBDt2WCXd3Yx06a6OMnvetEC6UaHboN
         /TdrworwDydXsY7b5JWIemPNDoz8XkTxdlZTm9wLGDOz2vSnf0DhqCIxxkGRDFpoV7Ja
         1fgnlRlmSBg09/hshXA0WjDM0VwmBZOx85Tia+vPnahzf+SaUIEjn+gxejIOEZ3+Z4y7
         Ax+/LA4vkGyn7b4Y1z2b4gCebem88gzv1WT7BtPGuaZFilpA/rgacxZvoesO33xoFHFj
         1FoFw54ro9VTjZIHPk9kSyd+WEqJC4Bui/Txx0GtBk5wwYQv5DbJkitHyyzrhl0IgEif
         5umA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=qNgM/TndfAax0dsoj6SwDLTXPGx8d6rJAaaKl5p2/kw=;
        b=klKKm33xWGJ5SVohWzLKHMhLfGrCJ5mcnRCthM5dzLtpmefLvIiN4BFaZX2ZJcWClb
         ehiXaAVQ4gntmk/o9xkHEIAHtmSYdd1F71qKGVy3IlRiPNPi82kIatFh3Gb/MNA+4yy/
         U2bqpY/OlHX0T3SI1GpO3Nc8AoZ0FNawJyVD/G0AWpfYVZYOG6PmKqf4+JSkUFyMeQJN
         P0AotggsxxjfBpYU7Dnqw8zdynjsH6c84eanNMm3KscBA+a8TwkgNKwR5/wlyIQtVqAN
         vrCWrjHhq58BY5W1exdHTE4vpj0411JARfliGV3niBu07AZToqrXtccb0rq4KoXtu8NL
         6SlQ==
X-Gm-Message-State: ACgBeo233xjnb1u8Z42iLOZHQ/4z8Xbhn20KS4h/b9opj+KGyUpG2Kpj
        N6ZgJslIDBydBoI9/Cpyc45qSZNC3z2n4Us4BdAZbA==
X-Google-Smtp-Source: AA6agR4jov8ggoW1khyzlCggpeVUjMO4l/iM7JVO0N/AG6wmNBHtmMcyAWSpEj787L08i+VW4oziGdOM5BxOZh8ZoJ0=
X-Received: by 2002:a05:6808:1a8d:b0:34f:dbe0:5bf5 with SMTP id
 bm13-20020a0568081a8d00b0034fdbe05bf5mr7516269oib.147.1663360593990; Fri, 16
 Sep 2022 13:36:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220916030544.228274-1-shaozhengchao@huawei.com> <20220916030544.228274-6-shaozhengchao@huawei.com>
In-Reply-To: <20220916030544.228274-6-shaozhengchao@huawei.com>
From:   Victor Nogueira <victor@mojatatu.com>
Date:   Fri, 16 Sep 2022 17:36:23 -0300
Message-ID: <CA+NMeC97ehoQAM4_Kh9mxw1aWob0KZLOxof_-dHQ-wMes9jOEQ@mail.gmail.com>
Subject: Re: [PATCH net-next 05/18] selftests/tc-testings: add selftests for
 cbs qdisc
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
> Test 1820: Create CBS with default setting
> Test 1532: Create CBS with hicredit setting
> Test 2078: Create CBS with locredit setting
> Test 0482: Create CBS with sendslope setting
> Test e8f3: Create CBS with multiple setting
> Test 23c9: Replace CBS with sendslope setting
> Test a07a: Change CBS with idleslope setting
> Test 43b3: Delete CBS with handle
> Test 9472: Show CBS class
>
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  .../tc-testing/tc-tests/qdiscs/cbs.json       | 234 ++++++++++++++++++
>  1 file changed, 234 insertions(+)
>  create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/cbs.json
>
> diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/cbs.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/cbs.json
> new file mode 100644
> index 000000000000..06618d2c3700
> --- /dev/null
> +++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/cbs.json
> @@ -0,0 +1,234 @@
> +[
> +    {
> +        "id": "1820",
> +        "name": "Create CBS with default setting",
> +        "category": [
> +            "qdisc",
> +            "cbs"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cbs",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc cbs 1: root refcnt [0-9]+ hicredit 0 locredit 0 sendslope 0 idleslope 0 offload 0.*qdisc pfifo 0: parent 1: limit 1000p",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "1532",
> +        "name": "Create CBS with hicredit setting",
> +        "category": [
> +            "qdisc",
> +            "cbs"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cbs hicredit 64",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc cbs 1: root refcnt [0-9]+ hicredit 64 locredit 0 sendslope 0 idleslope 0 offload 0.*qdisc pfifo 0: parent 1: limit 1000p",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "2078",
> +        "name": "Create CBS with locredit setting",
> +        "category": [
> +            "qdisc",
> +            "cbs"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cbs locredit 10",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc cbs 1: root refcnt [0-9]+ hicredit 0 locredit 10 sendslope 0 idleslope 0 offload 0.*qdisc pfifo 0: parent 1: limit 1000p",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "0482",
> +        "name": "Create CBS with sendslope setting",
> +        "category": [
> +            "qdisc",
> +            "cbs"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cbs sendslope 888",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc cbs 1: root refcnt [0-9]+ hicredit 0 locredit 0 sendslope 888 idleslope 0 offload 0.*qdisc pfifo 0: parent 1: limit 1000p",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "0482",

Be careful, you are using ID 0482 in the previous test case.

> +        "name": "Create CBS with idleslope setting",
> +        "category": [
> +            "qdisc",
> +            "cbs"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cbs idleslope 666",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc cbs 1: root refcnt [0-9]+ hicredit 0 locredit 0 sendslope 0 idleslope 666 offload 0.*qdisc pfifo 0: parent 1: limit 1000p",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "e8f3",
> +        "name": "Create CBS with multiple setting",
> +        "category": [
> +            "qdisc",
> +            "cbs"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cbs hicredit 10 locredit 75 sendslope 2 idleslope 666",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc cbs 1: root refcnt [0-9]+ hicredit 10 locredit 75 sendslope 2 idleslope 666 offload 0.*qdisc pfifo 0: parent 1: limit 1000p",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "23c9",
> +        "name": "Replace CBS with sendslope setting",
> +        "category": [
> +            "qdisc",
> +            "cbs"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true",
> +            "$TC qdisc add dev $DUMMY handle 1: root cbs idleslope 666"
> +        ],
> +        "cmdUnderTest": "$TC qdisc replace dev $DUMMY handle 1: root cbs sendslope 10",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc cbs 1: root refcnt [0-9]+ hicredit 0 locredit 0 sendslope 10 idleslope 0 offload 0.*qdisc pfifo 0: parent 1: limit 1000p",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "a07a",
> +        "name": "Change CBS with idleslope setting",
> +        "category": [
> +            "qdisc",
> +            "cbs"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true",
> +            "$TC qdisc add dev $DUMMY handle 1: root cbs idleslope 666"
> +        ],
> +        "cmdUnderTest": "$TC qdisc change dev $DUMMY handle 1: root cbs idleslope 1",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc cbs 1: root refcnt [0-9]+ hicredit 0 locredit 0 sendslope 0 idleslope 1 offload 0.*qdisc pfifo 0: parent 1: limit 1000p",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "43b3",
> +        "name": "Delete CBS with handle",
> +        "category": [
> +            "qdisc",
> +            "cbs"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true",
> +            "$TC qdisc add dev $DUMMY handle 1: root cbs idleslope 666"
> +        ],
> +        "cmdUnderTest": "$TC qdisc del dev $DUMMY handle 1: root",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc cbs 1: root refcnt [0-9]+ hicredit 0 locredit 0 sendslope 0 idleslope 1 offload 0.*qdisc pfifo 0: parent 1: limit 1000p",
> +        "matchCount": "0",
> +        "teardown": [
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "9472",
> +        "name": "Show CBS class",
> +        "category": [
> +            "qdisc",
> +            "cbs"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cbs",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC class show dev $DUMMY",
> +        "matchPattern": "class cbs 1:[0-9]+ parent 1:",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    }
> +]
> --
> 2.17.1
>
