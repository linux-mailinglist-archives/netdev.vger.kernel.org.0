Return-Path: <netdev+bounces-7085-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 33491719C3E
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 14:35:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 65141281794
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 12:35:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95A8723423;
	Thu,  1 Jun 2023 12:35:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3391C2E
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 12:35:20 +0000 (UTC)
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A98129
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 05:35:18 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-19f22575d89so478464fac.0
        for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 05:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1685622918; x=1688214918;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ik2+mR4fS3dyHRfq9L02szHNt9KX9zHrkteyOimVbHk=;
        b=1qEcAN3a6Q/DauGVl1YiD2cIxaYLEGYr9XYtQbOXYzD/g+TLATcHGkiPS3+3H/nCnN
         Y2Cz8FxRakFmjtrscZ1KzRPn6OyOk8M7h2T6aGVNdB4qSdv28wjQxts6ebGKUr5QPXuu
         55R6et9K5tNWv02JScjeVdHejnzXOEb07KlJFoQfJhVOcUs8G8P7xvS1xxrNQtLzluij
         77lbm2qH0UvoWIM8yvlw6Q1Pfy+4GXakJkIISoz2W5h4kDYvsOEIupUXRr7N/FAVjLiJ
         5YoLwhsTu6zRiaXxas1BuuzSWduINBd3PxMyWfYl/qbchIoBvOZsW/ICzsk7krqWgKJ+
         JftQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685622918; x=1688214918;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ik2+mR4fS3dyHRfq9L02szHNt9KX9zHrkteyOimVbHk=;
        b=aG5XwHZURMDj+2JCCtd8CQOAHw0Q/xLZ9nl/Cw2W+qUReB2P59k1d7cltJ3rSFyP7A
         C/VpeSXZX5IzH3XXLNzGXiHBzFp3GZTUduRmMfcdWUKmybaFLJaAUKN95FnLGhJhkTG3
         MlpYChKbiZBf968jOecY1DJ25L+UtesLZd034v2ZzU3ATzf4sN0cHUnKGO1CnQ5fK0fv
         ksYyDMrw59cfhTgwws7qBMvQnsb6pO9BAn2Wfgy+c6GV8DFc85CDht8aa6PxZKQHolet
         F8qPN7i93C9So+lbX/CDhBlF1bPZRuAzUcUODWeSA/CEyCiIRlY5PrnEbIc5xGC5a2mK
         iecQ==
X-Gm-Message-State: AC+VfDwfjYPTLGDsYYN6x7Xc//pP2Gi8n24FsXxtYSCbeDh5G5Gt7W2R
	fHl2V4DToHwJRDptqmB87ADajw==
X-Google-Smtp-Source: ACHHUZ51uuvRKwSt89JYp1to9Rytyflm9R6jYGGkJumt07w2H7f+Op3aMTT9AL2BhIvf54/G2iWr6Q==
X-Received: by 2002:a05:6871:c10d:b0:196:87c5:8881 with SMTP id yq13-20020a056871c10d00b0019687c58881mr4225010oab.10.1685622917842;
        Thu, 01 Jun 2023 05:35:17 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:44fb:6aab:7933:6a5a:53d6? ([2804:14d:5c5e:44fb:6aab:7933:6a5a:53d6])
        by smtp.gmail.com with ESMTPSA id h43-20020a056870172b00b0019e9dd601c1sm1614690oae.55.2023.06.01.05.35.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jun 2023 05:35:17 -0700 (PDT)
Message-ID: <4cea8b20-52dd-887e-88ce-f2af5ae95d74@mojatatu.com>
Date: Thu, 1 Jun 2023 09:35:12 -0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next,v2] selftests/tc-testing: replace mq with invalid
 parent ID
Content-Language: en-US
To: Zhengchao Shao <shaozhengchao@huawei.com>, netdev@vger.kernel.org,
 linux-kselftest@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
 jiri@resnulli.us, shuah@kernel.org
Cc: kuba@kernel.org, victor@mojatatu.com, peilin.ye@bytedance.com,
 weiyongjun1@huawei.com, yuehaibing@huawei.com
References: <20230601012250.52738-1-shaozhengchao@huawei.com>
From: Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <20230601012250.52738-1-shaozhengchao@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 31/05/2023 22:22, Zhengchao Shao wrote:
> The test case shown in [1] triggers the kernel to access the null pointer.
> Therefore, add related test cases to mq.
> The test results are as follows:
> 
> ./tdc.py -e 0531
> 1..1
> ok 1 0531 - Replace mq with invalid parent ID
> 
> ./tdc.py -c mq
> 1..8
> ok 1 ce7d - Add mq Qdisc to multi-queue device (4 queues)
> ok 2 2f82 - Add mq Qdisc to multi-queue device (256 queues)
> ok 3 c525 - Add duplicate mq Qdisc
> ok 4 128a - Delete nonexistent mq Qdisc
> ok 5 03a9 - Delete mq Qdisc twice
> ok 6 be0f - Add mq Qdisc to single-queue device
> ok 7 1023 - Show mq class
> ok 8 0531 - Replace mq with invalid parent ID
> 
> [1] https://lore.kernel.org/all/20230527093747.3583502-1-shaozhengchao@huawei.com/
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>

LGTM,

Reviewed-by: Pedro Tammela <pctammela@mojatatu.com>

> ---
>   .../tc-testing/tc-tests/qdiscs/mq.json        | 25 ++++++++++++++++++-
>   1 file changed, 24 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/mq.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/mq.json
> index 44fbfc6caec7..e3d2de5c184f 100644
> --- a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/mq.json
> +++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/mq.json
> @@ -155,5 +155,28 @@
>               "teardown": [
>                   "echo \"1\" > /sys/bus/netdevsim/del_device"
>               ]
> -        }
> +	},
> +	{
> +		"id": "0531",
> +		"name": "Replace mq with invalid parent ID",
> +		"category": [
> +			"qdisc",
> +			"mq"
> +		],
> +		"plugins": {
> +			"requires": "nsPlugin"
> +		},
> +		"setup": [
> +			"echo \"1 1 16\" > /sys/bus/netdevsim/new_device",
> +			"$TC qdisc add dev $ETH root handle ffff: mq"
> +		],
> +		"cmdUnderTest": "$TC qdisc replace dev $ETH parent ffff:fff1 handle ffff: mq",
> +		"expExitCode": "2",
> +		"verifyCmd": "$TC qdisc show dev $ETH",
> +		"matchPattern": "qdisc [a-zA-Z0-9_]+ 0: parent ffff",
> +		"matchCount": "16",
> +		"teardown": [
> +			"echo \"1\" > /sys/bus/netdevsim/del_device"
> +		]
> +	}
>   ]


