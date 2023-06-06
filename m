Return-Path: <netdev+bounces-8526-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 275EC72474D
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 17:11:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8CFAF1C20A71
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:10:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E32B2A71F;
	Tue,  6 Jun 2023 15:10:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8403021068
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 15:10:54 +0000 (UTC)
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38A4912D
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 08:10:53 -0700 (PDT)
Received: by mail-oo1-xc2a.google.com with SMTP id 006d021491bc7-55b069a7cf4so612664eaf.3
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 08:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1686064252; x=1688656252;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0ztWUo2qAnuEbAX7JBpQb1NBQjbP42juncghtisi8G4=;
        b=kQCXKq9ej4THlDophbNx+vren72BSLPqkas8fS6gRK6PCtx9oFOO76DNu3PQ7DX1Fs
         2nhuDUpwFXmB4bs93KJMz4uK8CyBn+UbB8ShZ23TUXMa3Piz7k+BT27TWCBRXOvdegSR
         WiEQ/Q9ge78hnEPuC78wfxQC7Y2e1lq2vmGqJN9w4+1Huyh3gOFXj4UtkquO7M1zgbWn
         yC0kZmtzDmBYDqErlhG3th/FoD1lXJKSLaT3do/6cdhkYNMyK32irym+Lqs5CkhGHAWX
         cf/ikw8voZnQZUF3upkBDm4JmU1/02PKFqeT8MvFcHBZac9vv38z5P1J6GAu/ZtFH8/7
         TmAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686064252; x=1688656252;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0ztWUo2qAnuEbAX7JBpQb1NBQjbP42juncghtisi8G4=;
        b=l8iugbu9JXeTW0Mtx9JuaoSp8Pbw40EYTlU2XM8bxidDepEAwdKztKC5FzmhKLlWOY
         HKJeaHxFbMrAwxnfuR5dZP0hkyuARjjIIQ81FxuEZozd+GkVJJTdtAXldvlU+tlJFav5
         6cCpuyaHDk8RJ6BvldPNWEzDUsit2Kwk7rusuCBdzo0u7OBaS5W/Qa9UQ9Uqat/EToSd
         lNkogkzh2ttyDPwOqZzSNt1VLGdGKG0DSwXKVx3920i48BE+6xvZUVBEgXpzlEoYNZaX
         16v9pDmctoCpXsIkdkJ3W40YbLaQmYEpdd7Di8cW5l14RC3Xv4DxzoVN+DyJ1gfMZBrY
         xeeA==
X-Gm-Message-State: AC+VfDwGFHshLJvs0VvMeZXNMYnbMiFta5dTeWDDd4UJDyXF3fo4n8OY
	bZPisBaJNyVbNsGgUfWpgv+aig==
X-Google-Smtp-Source: ACHHUZ5KcwV6nfikGkER+e5gTq2841eFPTxjWjxAPZCho2h1t54u9V05pHkgcIHbcWHPZbJEXHOIPQ==
X-Received: by 2002:a4a:c60a:0:b0:558:ab27:ad28 with SMTP id l10-20020a4ac60a000000b00558ab27ad28mr1832800ooq.5.1686064252521;
        Tue, 06 Jun 2023 08:10:52 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:44fb:6508:b231:8301:40a9? ([2804:14d:5c5e:44fb:6508:b231:8301:40a9])
        by smtp.gmail.com with ESMTPSA id v18-20020a4aa512000000b0055975f57993sm1840711ook.42.2023.06.06.08.10.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jun 2023 08:10:52 -0700 (PDT)
Message-ID: <e1e8a050-f6da-beb3-c93e-e2568bf0df05@mojatatu.com>
Date: Tue, 6 Jun 2023 12:10:46 -0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net] net/sched: taprio: fix slab-out-of-bounds Read in
 taprio_dequeue_from_txq
To: Zhengchao Shao <shaozhengchao@huawei.com>, netdev@vger.kernel.org,
 vinicius.gomes@intel.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
 jiri@resnulli.us, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com
Cc: vladimir.oltean@nxp.com, weiyongjun1@huawei.com, yuehaibing@huawei.com
References: <20230606121009.1942606-1-shaozhengchao@huawei.com>
Content-Language: en-US
From: Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <20230606121009.1942606-1-shaozhengchao@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 06/06/2023 09:10, Zhengchao Shao wrote:
> As shown in [1], when qdisc of the taprio type is set, count and offset in
> tc_to_txq can be set to 0. In this case, the value of *txq in
> taprio_next_tc_txq() will increases continuously. When the number of
> accessed queues exceeds the number of queues on the device, out-of-bounds
> access occurs. Now the restriction on the queue number is added.
> 
> [1] https://groups.google.com/g/syzkaller-bugs/c/_lYOKgkBVMg
> Fixes: 2f530df76c8c ("net/sched: taprio: give higher priority to higher TCs in software dequeue mode")
> Reported-by: syzbot+04afcb3d2c840447559a@syzkaller.appspotmail.com
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>   net/sched/sch_taprio.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index 3c4c2c334878..dccb64425852 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -801,7 +801,7 @@ static struct sk_buff *taprio_dequeue_tc_priority(struct Qdisc *sch,
>   
>   			if (skb)
>   				return skb;
> -		} while (q->cur_txq[tc] != first_txq);
> +		} while (q->cur_txq[tc] != first_txq && q->cur_txq[tc] < dev->num_tx_queues);

I'm not sure this is the correct fix.
If q->cur_txg[tc] == dev->num_tx_queues the next call to 
taprio_dequeue_tc_priority() for the same tc index will have
first_txq set to dev->num_tx_queues (no wrap around to first_txq happens).
If count and offset are 0 it will increment q->cur_txg[tc] and then bail 
on the while condition but still growing unbounded (just slower than 
before).

>   	}
>   taprio_dequeue_tc_priority
>   	return NULL;


