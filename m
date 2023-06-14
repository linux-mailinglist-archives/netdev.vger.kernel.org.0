Return-Path: <netdev+bounces-10793-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E1E7730552
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 18:44:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D78C1C20AC1
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 16:44:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DD412EC0D;
	Wed, 14 Jun 2023 16:44:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF57E7F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 16:44:17 +0000 (UTC)
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5321E2683
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 09:44:16 -0700 (PDT)
Received: by mail-oo1-xc2c.google.com with SMTP id 006d021491bc7-558a79941c6so709044eaf.3
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 09:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1686761055; x=1689353055;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eW98Ee4r1mG1kWTj0StXi/qELeSfpc9yO8OERuzyI3M=;
        b=uEqlUerN8HSYli1RVOqAqqUZNeInvQdJ/+q219nQsEmws2EZzNRtB/3nFpiaBGuCE8
         YO4AVUlkY+OhQ0R8iYtW8m95lIqIvdZDFPdNJa9LvBY5lQjx9nqSRkS5cGdLbZm4wG1E
         4BI+4kWmWqfndU2vxidVRTOZznZ6lp2rKYtbKYj3Kq8PHj6QLZKy41eJlk08b3k2+Pq4
         z20xFg7ePk+lwVQC1eCb3HYhGTiu+DZ+LpS7l51oJoM8/li5jKfCClhCDNQdGsiqAl7g
         k0vnevhYlvBVKkLkFBJnt1FohohBwIehDvi0+28MMeyWds4wRN6zWU9d67piONZUqEqW
         zaTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686761055; x=1689353055;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eW98Ee4r1mG1kWTj0StXi/qELeSfpc9yO8OERuzyI3M=;
        b=EXb2bYHKSKWXdDSIU/tXCiI4eXgunofovkLvV/ZI1tp1cryDICkaxKoCkw1mDGI7qj
         2fCYSLBvH/FBfOfivkdkCBicfeMaHn208xoGd7j44C3jKqI0ASQJAprU9mFFZ4L8ixSe
         7vcBiRAmxuxpVGqzc4bDjeKqF/OeGA08Vsw4G2trSX+sM3cBJ+IxkpH8b2iLept5MNeT
         DDUTW8hyFzecqVsS2Jx91DhF9fc+GpeCkFkrovJqIqHkWd1VevUcCOlQgNDtCIKwvpnr
         XxWW3FJFfSZeBLoqnDGxz4Wn1RWMJfxkaD6k3LC0khNSK6CqP/+3YADH8jxuDZjexrK8
         E8BQ==
X-Gm-Message-State: AC+VfDw/baddsYqLeo/6ISYf5A6J9vnMtLKEM1xdpZGfWD7IfRbHlwYh
	/h3xglRNJDuSLPUL7Ks+SV3n5Q==
X-Google-Smtp-Source: ACHHUZ5PjeBHHykPcFovNV0N4IrezoWKnEU/yL61N0/nH9sOECRq+oEd/S9d7k6BrAlpXfGX1jnn9A==
X-Received: by 2002:a4a:d542:0:b0:55a:7bfe:2df3 with SMTP id q2-20020a4ad542000000b0055a7bfe2df3mr9438859oos.8.1686761055610;
        Wed, 14 Jun 2023 09:44:15 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:44fb:90ea:5d38:822c:1759? ([2804:14d:5c5e:44fb:90ea:5d38:822c:1759])
        by smtp.gmail.com with ESMTPSA id s7-20020a4ac807000000b005421d52de9csm5170724ooq.45.2023.06.14.09.44.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jun 2023 09:44:15 -0700 (PDT)
Message-ID: <55cfe0a4-3874-5683-320e-0dec70bd2034@mojatatu.com>
Date: Wed, 14 Jun 2023 13:44:09 -0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2 net-next 8/9] selftests/tc-testing: test that taprio
 can only be attached as root
To: Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Jamal Hadi Salim <jhs@mojatatu.com>,
 Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
 Vinicius Costa Gomes <vinicius.gomes@intel.com>,
 linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
 Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
 Peilin Ye <yepeilin.cs@gmail.com>, Richard Cochran
 <richardcochran@gmail.com>, Zhengchao Shao <shaozhengchao@huawei.com>,
 Maxim Georgiev <glipus@gmail.com>
References: <20230613215440.2465708-1-vladimir.oltean@nxp.com>
 <20230613215440.2465708-9-vladimir.oltean@nxp.com>
Content-Language: en-US
From: Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <20230613215440.2465708-9-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 13/06/2023 18:54, Vladimir Oltean wrote:
> Check that the "Can only be attached as root qdisc" error message from
> taprio is effective by attempting to attach it to a class of another
> taprio qdisc. That operation should fail.
> 
> In the bug that was squashed by change "net/sched: taprio: try again to
> report q->qdiscs[] to qdisc_leaf()", grafting a child taprio to a root
> software taprio would be misinterpreted as a change() to the root
> taprio. Catch this by looking at whether the base-time of the root
> taprio has changed to follow the base-time of the child taprio,
> something which should have absolutely never happened assuming correct
> semantics.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Pedro Tammela <pctammela@mojatatu.com>

> ---
> v1->v2: patch is new
> 
>   .../tc-testing/tc-tests/qdiscs/taprio.json    | 48 +++++++++++++++++++
>   1 file changed, 48 insertions(+)
> 
> diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/taprio.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/taprio.json
> index a44455372646..58d4d97f4499 100644
> --- a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/taprio.json
> +++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/taprio.json
> @@ -131,5 +131,53 @@
>           "teardown": [
>               "echo \"1\" > /sys/bus/netdevsim/del_device"
>           ]
> +    },
> +    {
> +        "id": "39b4",
> +        "name": "Reject grafting taprio as child qdisc of software taprio",
> +        "category": [
> +            "qdisc",
> +            "taprio"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "echo \"1 1 8\" > /sys/bus/netdevsim/new_device",
> +            "$TC qdisc replace dev $ETH handle 8001: parent root stab overhead 24 taprio num_tc 8 map 0 1 2 3 4 5 6 7 queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 base-time 0 sched-entry S ff 20000000 clockid CLOCK_TAI"
> +        ],
> +        "cmdUnderTest": "$TC qdisc replace dev $ETH parent 8001:7 taprio num_tc 8 map 0 1 2 3 4 5 6 7 queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 base-time 200 sched-entry S ff 20000000 clockid CLOCK_TAI",
> +        "expExitCode": "2",
> +        "verifyCmd": "$TC -j qdisc show dev $ETH root | jq '.[].options.base_time'",
> +        "matchPattern": "0",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $ETH root",
> +            "echo \"1\" > /sys/bus/netdevsim/del_device"
> +        ]
> +    },
> +    {
> +        "id": "e8a1",
> +        "name": "Reject grafting taprio as child qdisc of offloaded taprio",
> +        "category": [
> +            "qdisc",
> +            "taprio"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "echo \"1 1 8\" > /sys/bus/netdevsim/new_device",
> +            "$TC qdisc replace dev $ETH handle 8001: parent root stab overhead 24 taprio num_tc 8 map 0 1 2 3 4 5 6 7 queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 base-time 0 sched-entry S ff 20000000 flags 0x2"
> +        ],
> +        "cmdUnderTest": "$TC qdisc replace dev $ETH parent 8001:7 taprio num_tc 8 map 0 1 2 3 4 5 6 7 queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 base-time 200 sched-entry S ff 20000000 flags 0x2",
> +        "expExitCode": "2",
> +        "verifyCmd": "$TC -j qdisc show dev $ETH root | jq '.[].options.base_time'",
> +        "matchPattern": "0",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $ETH root",
> +            "echo \"1\" > /sys/bus/netdevsim/del_device"
> +        ]
>       }
>   ]


