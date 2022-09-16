Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E570D5BB39B
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 22:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiIPUlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 16:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiIPUlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 16:41:11 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46EB077548
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 13:41:10 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id j188so5187071oih.0
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 13:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=J2kyV1QeWmifhwdex3np+82YN4pfaKiop6G2W47DH2Y=;
        b=XfNB0wHMoUpkjDXE0KTqrsaJdFmFEaQdZdoDwM1O89P0fpd6jP4uJYyh1CHjdCwkC5
         CqOiryJBDg57Hz+pyx70XDATrOL1DLe4RY+LRnKBV19IzMZh6xCgUQM041y4b+tB3jxE
         Oke6dSSOEsz5zHtodq/Hv2sIo5k4AiKi69uF4O4BgIgjT4NJJ77RUG67rMLjcD/VjJ+w
         mV4C6eqho5y8UhHijDSqyGyMl0aa1j+3hcvC4b5APEfyZhn1fVKXE6LT2gX8XBLzkYss
         LTAvix6XpOvMzUbZmtaDCmbilne95OjbSWHW/EckhG68TIjhEFJ8g/jLnFEPU0MESdib
         SGDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=J2kyV1QeWmifhwdex3np+82YN4pfaKiop6G2W47DH2Y=;
        b=CxZh6361Nvsn/y9+aRCoZAK5Cs+yJ6ePyZKQ1hQszR9BHXdZyKxRlLuI6kW2zw3OxT
         0xgFYgYlDMqdGO7LexTTUc9soI72ylxZcNNeCU2jLU5xw1by8N+bknojjsi8ROeypZ4+
         Yg2Bn3YviVBHwzOLP3DHV2asUrcWWlEnx8kWdzrweXti5SG1zHsSY9N7bvjdtbu4KohK
         4fIN0tnEC+RnaWi7aqwkt6sQeu8grNSkilvm2n2Gq20y7kcVYlN8J3WIOuQNs6cbO8d3
         lQLRgdtJMnvW80yZ3V9Xy6tddEP/xBGb3Pn3k5nx68l7gsDYeNZc9y6ghZpZTjR797D+
         AZdQ==
X-Gm-Message-State: ACrzQf2dDs+7ESwBjeITrMFCraQwClnHg17TlQpHK1jHiKG1EBvPdmuZ
        X+qKhD2t7JQ32TS3GXE5iXlW0J5QA04qG/3tFkNrrQ==
X-Google-Smtp-Source: AMsMyM6aQDhSX+slRvXtLnsbRWGlkfTXFw7dTDYJdTRc73fLW2p/byHUdwljasLi2jfRMJBdCG2wEjkfhU0YEvXpbfY=
X-Received: by 2002:a05:6808:21a3:b0:345:3202:e2a1 with SMTP id
 be35-20020a05680821a300b003453202e2a1mr3251269oib.268.1663360869605; Fri, 16
 Sep 2022 13:41:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220916030544.228274-1-shaozhengchao@huawei.com> <20220916030544.228274-13-shaozhengchao@huawei.com>
In-Reply-To: <20220916030544.228274-13-shaozhengchao@huawei.com>
From:   Victor Nogueira <victor@mojatatu.com>
Date:   Fri, 16 Sep 2022 17:40:58 -0300
Message-ID: <CA+NMeC-bysQAMzNzmyDObVtgVzP8Kpeay517kkvHu_YsT7otzQ@mail.gmail.com>
Subject: Re: [PATCH net-next 12/18] selftests/tc-testings: add selftests for
 multiq qdisc
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
> Test 20ba: Add multiq Qdisc to multi-queue device (8 queues)
> Test 9903: List multiq Class
> Test 7832: Delete nonexistent multiq Qdisc
> Test 2891: Delete multiq Qdisc twice
> Test 1329: Add multiq Qdisc to single-queue device
>
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  .../tc-testing/tc-tests/qdiscs/multiq.json    | 114 ++++++++++++++++++
>  1 file changed, 114 insertions(+)
>  create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/multiq.json
>
> diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/multiq.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/multiq.json
> new file mode 100644
> index 000000000000..2ae813f676a5
> --- /dev/null
> +++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/multiq.json
> @@ -0,0 +1,114 @@
> +[
> +    {
> +        "id": "20ba",
> +        "name": "Add multiq Qdisc to multi-queue device (8 queues)",
> +        "category": [
> +            "qdisc",
> +            "multiq"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "echo \"1 1 8\" > /sys/bus/netdevsim/new_device"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $ETH root handle 1: multiq",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $ETH",
> +        "matchPattern": "qdisc multiq 1: root refcnt [0-9]+ bands 8",
> +        "matchCount": "1",
> +        "teardown": [
> +            "echo \"1\" > /sys/bus/netdevsim/del_device"
> +        ]
> +    },
> +    {
> +        "id": "9903",

Be careful, you are using ID 9903 in the mqprio test patch.

> +        "name": "List multiq Class",
> +        "category": [
> +            "qdisc",
> +            "multiq"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "echo \"1 1 8\" > /sys/bus/netdevsim/new_device"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $ETH root handle 1: multiq",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC class show dev $ETH",
> +        "matchPattern": "class multiq 1:[0-9]+ parent 1:",
> +        "matchCount": "8",
> +        "teardown": [
> +            "echo \"1\" > /sys/bus/netdevsim/del_device"
> +        ]
> +    },
> +    {
> +        "id": "7832",
> +        "name": "Delete nonexistent multiq Qdisc",
> +        "category": [
> +            "qdisc",
> +            "multiq"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "echo \"1 1 4\" > /sys/bus/netdevsim/new_device"
> +        ],
> +        "cmdUnderTest": "$TC qdisc del dev $ETH root handle 1: multiq",
> +        "expExitCode": "2",
> +        "verifyCmd": "$TC qdisc show dev $ETH",
> +        "matchPattern": "qdisc multiq 1: root",
> +        "matchCount": "0",
> +        "teardown": [
> +            "echo \"1\" > /sys/bus/netdevsim/del_device"
> +        ]
> +    },
> +    {
> +        "id": "2891",
> +        "name": "Delete multiq Qdisc twice",
> +        "category": [
> +            "qdisc",
> +            "multiq"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "echo \"1 1 8\" > /sys/bus/netdevsim/new_device",
> +            "$TC qdisc add dev $ETH root handle 1: multiq",
> +            "$TC qdisc del dev $ETH root handle 1:"
> +        ],
> +        "cmdUnderTest": "$TC qdisc del dev $ETH root handle 1:",
> +        "expExitCode": "2",
> +        "verifyCmd": "$TC qdisc show dev $ETH",
> +        "matchPattern": "qdisc mqprio 1: root",
> +        "matchCount": "0",
> +        "teardown": [
> +            "echo \"1\" > /sys/bus/netdevsim/del_device"
> +        ]
> +    },
> +    {
> +        "id": "1329",
> +        "name": "Add multiq Qdisc to single-queue device",
> +        "category": [
> +            "qdisc",
> +            "multiq"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "echo \"1 1\" > /sys/bus/netdevsim/new_device"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $ETH root handle 1: multiq",
> +        "expExitCode": "2",
> +        "verifyCmd": "$TC qdisc show dev $ETH",
> +        "matchPattern": "qdisc multiq 1: root",
> +        "matchCount": "0",
> +        "teardown": [
> +            "echo \"1\" > /sys/bus/netdevsim/del_device"
> +        ]
> +    }
> +]
> --
> 2.17.1
>
