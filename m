Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECA645B9F53
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 18:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbiIOQAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 12:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbiIOQA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 12:00:29 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D174BA76
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 09:00:27 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id n83so2769481oif.11
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 09:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=X9/FP3VBJRq8TtJfMVb96DGTxGgvouChIEWCiVKx+Cc=;
        b=tlXobdp5w6HhdgCBq9e6RQhoInFe2vYAKDl/BflsgKdeRee7L2Y2k+WEhl0HkJ5xm3
         MJ6fI39/Z7+8HOC05PzhXTqIfymXVGznaUbmOH9+deDyiEIMkWtblNZe55wPKW4xq128
         SQkiPcfY/8ulO79oHxmJzug1kW8j4BZc1+vV5co23ccyULVNTRxhWh1P99SCpPMJZnFR
         2SEVO1CZMl36PTebDbHbkpX3OmJcucKfbF2NnrWCZ2EcJwtjT7Ouzn0Pf25m75YDoGje
         HbH0ujTUtaqhi+TWRq1fR1q90IXbMCxBabh5VvIDBDaAqPkgeR+SrTrbNcxCJC69KaIE
         IPaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=X9/FP3VBJRq8TtJfMVb96DGTxGgvouChIEWCiVKx+Cc=;
        b=BH5ozlyRo9Z86dQyGbEgdSstN//QGPPdQh3DCNpueYNCMxQOQrx1FpoevTlz4KbSiH
         BgehaKrzLO8M+ve5LPvR62M2dqHmKg95SDwlJBidQgeEPqDJGaRVVkBjpwrNRnVHRGVC
         BALdLpXgVG9wgdrnNOmCDCLFK2fdbpeTNBnlONVf1dsPBDV0ul+aZ2ih/6EfnvhVYQs7
         MiRNdjIlTtHDF/ChxKlqVGxo7WGmOKGVDjY8p6l+xwVzFwhIcJ4FSXtj7erFRS/syVTj
         3AAJKdEOMM5J9IBzCsgMy/V8QQAgxv2C3Btm8AMxbyM50ECJv5r3FKLvRlWqvX8Gzgcw
         0L7Q==
X-Gm-Message-State: ACgBeo2jn8FiBtN7HVElq8+mg3zEvUyVhDpD0PZZDoGoBUAD90Ipovfh
        TkMdkcRw1s7pfLbFIEjU+tsRTA==
X-Google-Smtp-Source: AA6agR7sKStDeo0t1HhVbBFSs83Bz4lSOFh/W6UH7W5fz3eOj2mZh8/wIZC7dv5OyBJUALbMypC1lQ==
X-Received: by 2002:a05:6808:2387:b0:350:28c5:335 with SMTP id bp7-20020a056808238700b0035028c50335mr2890860oib.18.1663257627009;
        Thu, 15 Sep 2022 09:00:27 -0700 (PDT)
Received: from ?IPV6:2804:1b3:7000:d095:41f2:210c:b643:8576? ([2804:1b3:7000:d095:41f2:210c:b643:8576])
        by smtp.gmail.com with ESMTPSA id p22-20020a4a8156000000b00448985f1f17sm7956443oog.9.2022.09.15.09.00.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Sep 2022 09:00:26 -0700 (PDT)
Message-ID: <7c5d6f5f-9fc9-a184-1412-182106bb7a77@mojatatu.com>
Date:   Thu, 15 Sep 2022 13:00:20 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH net-next,v3 3/9] selftests/tc-testings: add selftests for
 bpf filter
Content-Language: en-US
To:     Zhengchao Shao <shaozhengchao@huawei.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, shuah@kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
References: <20220915063038.20010-1-shaozhengchao@huawei.com>
 <20220915063038.20010-4-shaozhengchao@huawei.com>
From:   Victor Nogueira <victor@mojatatu.com>
In-Reply-To: <20220915063038.20010-4-shaozhengchao@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/09/2022 03:30, Zhengchao Shao wrote:
> Test 23c3: Add cBPF filter with valid bytecode
> Test 1563: Add cBPF filter with invalid bytecode
> Test 2334: Add eBPF filter with valid object-file
> Test 2373: Add eBPF filter with invalid object-file
> Test 4423: Replace cBPF bytecode
> Test 5122: Delete cBPF filter
> Test e0a9: List cBPF filters
> 
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
> ---
>   .../tc-testing/tc-tests/filters/bpf.json      | 171 ++++++++++++++++++
>   1 file changed, 171 insertions(+)
>   create mode 100644 tools/testing/selftests/tc-testing/tc-tests/filters/bpf.json
> 
> diff --git a/tools/testing/selftests/tc-testing/tc-tests/filters/bpf.json b/tools/testing/selftests/tc-testing/tc-tests/filters/bpf.json
> new file mode 100644
> index 000000000000..4c8e1fd8faab
> --- /dev/null
> +++ b/tools/testing/selftests/tc-testing/tc-tests/filters/bpf.json
> @@ -0,0 +1,171 @@
> +[
> +    {
> +        "id": "23c3",
> +        "name": "Add cBPF filter with valid bytecode",
> +        "category": [
> +            "filter",
> +            "bpf-filter"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$TC qdisc add dev $DEV1 ingress"
> +        ],
> +        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 100 bpf bytecode '4,40 0 0 12,21 0 1 2048,6 0 0 262144,6 0 0 0'",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 protocol ip prio 100 bpf",
> +        "matchPattern": "filter parent ffff: protocol ip pref 100 bpf chain [0-9]+ handle 0x1.*bytecode '4,40 0 0 12,21 0 1 2048,6 0 0 262144,6 0 0 0'",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DEV1 ingress"
> +        ]
> +    },
> +    {
> +        "id": "1563",
> +        "name": "Add cBPF filter with invalid bytecode",
> +        "category": [
> +            "filter",
> +            "bpf-filter"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$TC qdisc add dev $DEV1 ingress"
> +	],

Sorry for the nit-picking, you are still using tabs in some places.
Like in the line above.

> +        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 100 bpf bytecode '4,40 0 0 12,31 0 1 2048,6 0 0 262144,6 0 0 0'",
> +        "expExitCode": "2",
> +        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 protocol ip prio 100 bpf",
> +        "matchPattern": "filter parent ffff: protocol ip pref 100 bpf chain [0-9]+ handle 0x1.*bytecode '4,40 0 0 12,21 0 1 2048,6 0 0 262144,6 0 0 0'",
> +        "matchCount": "0",
> +        "teardown": [
> +            "$TC qdisc del dev $DEV1 ingress"
> +        ]
> +    },
> +    {
> +        "id": "2334",
> +        "name": "Add eBPF filter with valid object-file",
> +        "category": [
> +            "filter",
> +            "bpf-filter"
> +        ],
> +        "plugins": {
> +            "requires": "buildebpfPlugin"
> +        },
> +        "setup": [
> +            "$TC qdisc add dev $DEV1 ingress"
> +	],
> +        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 100 bpf object-file $EBPFDIR/action.o section action-ok",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 protocol ip prio 100 bpf",
> +        "matchPattern": "filter parent ffff: protocol ip pref 100 bpf chain [0-9]+ handle 0x1 action.o:\\[action-ok\\].*tag [0-9a-f]{16}( jited)?",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DEV1 ingress"
> +        ]
> +    },
> +    {
> +        "id": "2373",
> +        "name": "Add eBPF filter with invalid object-file",
> +        "category": [
> +            "filter",
> +            "bpf-filter"
> +        ],
> +        "plugins": {
> +            "requires": "buildebpfPlugin"
> +        },
> +        "setup": [
> +            "$TC qdisc add dev $DEV1 ingress"
> +	],
> +        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 100 bpf object-file $EBPFDIR/action.o section action-ko",
> +        "expExitCode": "1",
> +        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 protocol ip prio 100 bpf",
> +        "matchPattern": "filter parent ffff: protocol ip pref 100 bpf chain [0-9]+ handle 0x1 action.o:\\[action-ko\\].*tag [0-9a-f]{16}( jited)?",
> +        "matchCount": "0",
> +        "teardown": [
> +            "$TC qdisc del dev $DEV1 ingress"
> +	]
> +    },
> +    {
> +        "id": "4423",
> +        "name": "Replace cBPF bytecode",
> +        "category": [
> +            "filter",
> +            "bpf-filter"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$TC qdisc add dev $DEV1 ingress",
> +            [
> +                "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 100 bpf bytecode '4,40 0 0 12,21 0 1 2048,6 0 0 262144,6 0 0 0'",
> +                0,
> +                1,
> +                255
> +            ]
> +        ],
> +        "cmdUnderTest": "$TC filter replace dev $DEV1 parent ffff: handle 1 protocol ip prio 100 bpf bytecode '4,40 0 0 12,21 0 1 2054,6 0 0 262144,6 0 0 0'",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 protocol ip prio 100 bpf",
> +        "matchPattern": "filter parent ffff: protocol ip pref 100 bpf chain [0-9]+ handle 0x1.*bytecode '4,40 0 0 12,21 0 1 2054,6 0 0 262144,6 0 0 0'",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DEV1 ingress"
> +	]
> +    },
> +    {
> +        "id": "5122",
> +        "name": "Delete cBPF filter",
> +        "category": [
> +            "filter",
> +            "bpf-filter"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$TC qdisc add dev $DEV1 ingress",
> +	    [
> +                "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 100 bpf bytecode '4,40 0 0 12,21 0 1 2048,6 0 0 262144,6 0 0 0'",
> +                0,
> +                1,
> +                255
> +            ]
> +        ],
> +        "cmdUnderTest": "$TC filter del dev $DEV1 parent ffff: handle 1 protocol ip prio 100 bpf",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 protocol ip prio 100 bpf",
> +        "matchPattern": "filter parent ffff: protocol ip pref 100 bpf chain [0-9]+ handle 0x1.*bytecode '4,40 0 0 12,21 0 1 2048,6 0 0 262144,6 0 0 0'",
> +        "matchCount": "0",
> +        "teardown": [
> +            "$TC qdisc del dev $DEV1 ingress"
> +	]
> +    },
> +    {
> +        "id": "e0a9",
> +        "name": "List cBPF filters",
> +        "category": [
> +            "filter",
> +            "bpf-filter"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$TC qdisc add dev $DEV1 ingress",
> +	    "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 100 bpf bytecode '4,40 0 0 12,21 0 1 2048,6 0 0 262144,6 0 0 0'",
> +            "$TC filter add dev $DEV1 parent ffff: handle 2 protocol ip prio 100 bpf bytecode '4,40 0 0 12,21 0 1 2054,6 0 0 262144,6 0 0 0'",
> +            "$TC filter add dev $DEV1 parent ffff: handle 100 protocol ip prio 100 bpf bytecode '4,40 0 0 12,21 0 1 33024,6 0 0 262144,6 0 0 0'"
> +        ],
> +        "cmdUnderTest": "$TC filter show dev $DEV1 parent ffff:",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
> +	"matchPattern": "filter protocol ip pref 100 bpf chain [0-9]+ handle",
> +        "matchCount": "3",
> +        "teardown": [
> +            "$TC qdisc del dev $DEV1 ingress"
> +        ]
> +    }
> +]

