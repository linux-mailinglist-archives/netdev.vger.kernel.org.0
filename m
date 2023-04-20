Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C769C6E997C
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 18:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbjDTQZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 12:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbjDTQZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 12:25:42 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8017119
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 09:25:40 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id 46e09a7af769-6a5f03551fdso917052a34.0
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 09:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1682007940; x=1684599940;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j/oXVgu3K+FRDkiKWsf8XYvbLWkOIkjoYREeAbjP6jE=;
        b=BY5Z5a9wtOQCw6G2+OjAyzYt+LP2VUUPH3skvJKiljeDAa1y9mI1musT+BwXcBB7mS
         KetSmBKW3H/gfJjY+ueaiUV0rPRRrnYUQfGDC7OWnuA+XLyhUhTXrH2Ra+5rtKZ4mVZe
         xSeLGofbDk4Pm6gutgd/qW6UtBReCa4L0Vl6LNRnGYCyedupROA08jXWEE5evpq5Uk8C
         ooDiFmR+u7+Fw8M8uz04wDxbjJUFcWFwmMGv4cFf61LiyQJ5bwVYIWuyad17j0TaA9hQ
         M0Zt3KNDL6o+x/qc4yak+6deLtso5fW3BOl/WBwfLlQ/Z0pDAT6tNRzaR5HSj4WVyudp
         H6bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682007940; x=1684599940;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j/oXVgu3K+FRDkiKWsf8XYvbLWkOIkjoYREeAbjP6jE=;
        b=Q7fs/Fh0A1nxTpO4/Sil+c/iG/mPTAEt6Md/17GammuzVa6zhvwfUhaxCnsxHbOq1m
         JHiezvKpnI+lAOaLVyHneZv/XZfXJNJ+BunLSrv5X/J2qDQmKqUzpfzxtoJ+LRr+SuUK
         2uTPL9dYpjXjYde1JqnFR4weJHmox7K/hnU0nMjwb2gaeJjG4z6h7t4S9CAf0daWOJKi
         ShbrWJQPAoyUpZec/iMa2b6S7bymxyvJ0TOBp+DzoR9Eqn1uyyEPUEE7/cDPdDZPuAsI
         oD58aQkhuL8xJcOz1H+O3+dfv1LA6RBDbQWQok8j68MMwTn4VhA+lvAZhaV+JyEyNhiC
         GwuQ==
X-Gm-Message-State: AAQBX9fFmjbwx71kBSbKY2PLNsJ6Bv51bzGdZTSFNGM0SC+NUkn8aV+I
        aJvMpUWtQKgKwfAPRpjQsYsNGA==
X-Google-Smtp-Source: AKy350bMyAyA1AXcK2j7mqiAqqJd5UeaD3HbU+3PwhRAxXYF//nKVaJ3ILu4rhQafrpuS4MYt0xNGg==
X-Received: by 2002:a54:4388:0:b0:38d:fa26:3bc4 with SMTP id u8-20020a544388000000b0038dfa263bc4mr1299899oiv.10.1682007938609;
        Thu, 20 Apr 2023 09:25:38 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:44fb:7668:3bb3:e9e3:6d75? ([2804:14d:5c5e:44fb:7668:3bb3:e9e3:6d75])
        by smtp.gmail.com with ESMTPSA id x6-20020acae006000000b0037832f60518sm735209oig.14.2023.04.20.09.25.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Apr 2023 09:25:38 -0700 (PDT)
Message-ID: <4e8324cf-e6de-acff-5e30-373d015a3cb4@mojatatu.com>
Date:   Thu, 20 Apr 2023 13:25:33 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net v2] net/sched: sch_fq: fix integer overflow of
 "credit"
Content-Language: en-US
To:     Davide Caratti <dcaratti@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
References: <7b3a3c7e36d03068707a021760a194a8eb5ad41a.1682002300.git.dcaratti@redhat.com>
From:   Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <7b3a3c7e36d03068707a021760a194a8eb5ad41a.1682002300.git.dcaratti@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/04/2023 11:59, Davide Caratti wrote:
> if sch_fq is configured with "initial quantum" having values greater than
> INT_MAX, the first assignment of "credit" does signed integer overflow to
> a very negative value.
> In this situation, the syzkaller script provided by Cristoph triggers the
> CPU soft-lockup warning even with few sockets. It's not an infinite loop,
> but "credit" wasn't probably meant to be minus 2Gb for each new flow.
> Capping "initial quantum" to INT_MAX proved to fix the issue.
> 
> v2: validation of "initial quantum" is done in fq_policy, instead of open
>      coding in fq_change() _ suggested by Jakub Kicinski
> 
> Reported-by: Christoph Paasch <cpaasch@apple.com>
> Link: https://github.com/multipath-tcp/mptcp_net-next/issues/377
> Fixes: afe4fd062416 ("pkt_sched: fq: Fair Queue packet scheduler")
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---
>   net/sched/sch_fq.c                            |  6 ++++-
>   .../tc-testing/tc-tests/qdiscs/fq.json        | 22 +++++++++++++++++++
>   2 files changed, 27 insertions(+), 1 deletion(-)
> 
> diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
> index 48d14fb90ba0..f59a2cb2c803 100644
> --- a/net/sched/sch_fq.c
> +++ b/net/sched/sch_fq.c
> @@ -779,13 +779,17 @@ static int fq_resize(struct Qdisc *sch, u32 log)
>   	return 0;
>   }
>   
> +static struct netlink_range_validation iq_range = {
> +	.max = INT_MAX,
> +};
> +
>   static const struct nla_policy fq_policy[TCA_FQ_MAX + 1] = {
>   	[TCA_FQ_UNSPEC]			= { .strict_start_type = TCA_FQ_TIMER_SLACK },
>   
>   	[TCA_FQ_PLIMIT]			= { .type = NLA_U32 },
>   	[TCA_FQ_FLOW_PLIMIT]		= { .type = NLA_U32 },
>   	[TCA_FQ_QUANTUM]		= { .type = NLA_U32 },
> -	[TCA_FQ_INITIAL_QUANTUM]	= { .type = NLA_U32 },
> +	[TCA_FQ_INITIAL_QUANTUM]	= NLA_POLICY_FULL_RANGE(NLA_U32, &iq_range),
>   	[TCA_FQ_RATE_ENABLE]		= { .type = NLA_U32 },
>   	[TCA_FQ_FLOW_DEFAULT_RATE]	= { .type = NLA_U32 },
>   	[TCA_FQ_FLOW_MAX_RATE]		= { .type = NLA_U32 },
> diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq.json
> index 8acb904d1419..3593fb8f79ad 100644
> --- a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq.json
> +++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq.json
> @@ -114,6 +114,28 @@
>               "$IP link del dev $DUMMY type dummy"
>           ]
>       },
> +    {
> +        "id": "10f7",
> +        "name": "Create FQ with invalid initial_quantum setting",
> +        "category": [
> +            "qdisc",
> +            "fq"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root fq initial_quantum 0x80000000",
> +        "expExitCode": "2",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc fq 1: root.*initial_quantum 2048Mb",
> +        "matchCount": "0",
> +        "teardown": [
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
>       {
>           "id": "9398",
>           "name": "Create FQ with maxrate setting",

You probably don't want to backport the test as well? If so I would 
break this patch into two.
