Return-Path: <netdev+bounces-12232-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CCA86736DC6
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 15:49:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C26128128F
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 13:49:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 864261640D;
	Tue, 20 Jun 2023 13:49:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC62154B5
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 13:49:13 +0000 (UTC)
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C601718
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 06:48:46 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id 5614622812f47-3942c6584f0so3092587b6e.3
        for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 06:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1687268922; x=1689860922;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+jt+SNzQ8YIqdLszSLIQQyO/8zI8n98Rb2yilfjw5wo=;
        b=jduEXgKYsNDsu2ckNG79TINq2X4lSM7gPrBzARw0VICuNXmyAotvfddwp0q0zEtotQ
         C1Mdff2m3PWr89pG8I3LIr2mT+tq4x5MkKqsJ/zU8ZmqgEQnU/2J1+ARrxXaOYmpIS1D
         KBU4sPWGLervVqZzr44+cVBBCvm767aobmTKAGjdpQF1+27LGg/alyOiouiS3aGVgyIc
         tJsD/ymJ7JhXcN6OFJqGt3VHTDGcR6nFjA559CJHGViymtxY924WaxpAkMYt3oK9EaXR
         cKXMwkbyuRnCSFc11Cru7rJ7TgInUYt/drgDdnMUgRLS0Ok+LOjUU63jQupCXCrOK7od
         dQrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687268922; x=1689860922;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+jt+SNzQ8YIqdLszSLIQQyO/8zI8n98Rb2yilfjw5wo=;
        b=hv0QzMIXp1NQDRzTTUA0s5VxIEQWEM5C3AkCkt3TlD7anKJnJcLRT75UljgoLMyxwX
         VMmpo0rIkTrIFYwfXsBe+fHIEGCyhvAW88gtVW8E2kSxEd7x5fR9QE/Xe7yJwcKjX6Qt
         XnmOy+7aLQl7hcduCSh905G8rhacbF0tWZGhLQu+2EA7KCvwF0y1H1ZSrOS/DEdBnvRf
         xKhmQiecogLV5l5yT1vpzh6UQHPOGpFLxiGhi4u/wEfHwrS11pIpfry4jhPq0T0E8tJB
         FqHEZ5+9oj8VAxyaTeKpV4fL6I+LXHXn+8xIqG2bw+tZcw5YBSYxnQeTqh4hfo+C0zZp
         6wPg==
X-Gm-Message-State: AC+VfDzKUxhZXRlzTVg82DveYYSO1RD3NHIzjyINk9Yxkc5UY4yTy9bn
	1/AGTFWRNEDsk5oscoQBQTYkxw==
X-Google-Smtp-Source: ACHHUZ6+No+cDZa9+m5diqZQ/9ogy+uAoZXkrMwEDwbgEmrstvSYDeA8mmmDvB3/hFrEr+0KWrbEeA==
X-Received: by 2002:aca:1115:0:b0:39e:cdb4:c469 with SMTP id 21-20020aca1115000000b0039ecdb4c469mr8541279oir.32.1687268922396;
        Tue, 20 Jun 2023 06:48:42 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:44fb:687e:840c:e7bd:8b4a? ([2804:14d:5c5e:44fb:687e:840c:e7bd:8b4a])
        by smtp.gmail.com with ESMTPSA id t3-20020a05680800c300b0039a41b57e07sm1058660oic.39.2023.06.20.06.48.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jun 2023 06:48:42 -0700 (PDT)
Message-ID: <d893715c-2eea-6dc3-ca27-b19535194a60@mojatatu.com>
Date: Tue, 20 Jun 2023 10:48:36 -0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2] selftests: tc-testing: add one test for flushing
 explicitly created chain
Content-Language: en-US
To: renmingshuai <renmingshuai@huawei.com>, vladbu@nvidia.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jhs@mojatatu.com,
 xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc: liaichun@huawei.com, caowangbao@huawei.com, yanan@huawei.com,
 liubo335@huawei.com
References: <20230620014939.2034054-1-renmingshuai@huawei.com>
From: Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <20230620014939.2034054-1-renmingshuai@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 19/06/2023 22:49, renmingshuai wrote:
> Add the test for additional reference to chains that are explicitly created
>   by RTM_NEWCHAIN message.
> The test result:
> 1..1
> ok 1 c2b4 - soft lockup alarm will be not generated after delete the prio 0
>   filter of the chain
> 
> commit c9a82bec02c3 ("net/sched: cls_api: Fix lockup on flushing explicitly
>   created chain")
> Signed-off-by: Mingshuai Ren <renmingshuai@huawei.com>

Acked-by: Pedro Tammela <pctammela@mojatatu.com>

> 
> ---
> V1 -> V2
>    * add the test result
> ---
>   .../tc-testing/tc-tests/infra/filter.json     | 25 +++++++++++++++++++
>   1 file changed, 25 insertions(+)
>   create mode 100644 tools/testing/selftests/tc-testing/tc-tests/infra/filter.json
> 
> diff --git a/tools/testing/selftests/tc-testing/tc-tests/infra/filter.json b/tools/testing/selftests/tc-testing/tc-tests/infra/filter.json
> new file mode 100644
> index 000000000000..c4c778e83da2
> --- /dev/null
> +++ b/tools/testing/selftests/tc-testing/tc-tests/infra/filter.json
> @@ -0,0 +1,25 @@
> +[
> +    {
> +        "id": "c2b4",
> +        "name": "soft lockup alarm will be not generated after delete the prio 0 filter of the chain",
> +        "category": [
> +            "filter",
> +            "chain"
> +        ],
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true",
> +            "$TC qdisc add dev $DUMMY root handle 1: htb default 1",
> +            "$TC chain add dev $DUMMY",
> +            "$TC filter del dev $DUMMY chain 0 parent 1: prio 0"
> +        ],
> +        "cmdUnderTest": "$TC filter add dev $DUMMY chain 0 parent 1:",
> +        "expExitCode": "2",
> +        "verifyCmd": "$TC chain ls dev $DUMMY",
> +        "matchPattern": "chain parent 1: chain 0",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY root handle 1: htb default 1",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    }
> +]


