Return-Path: <netdev+bounces-9244-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CAF67282DC
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 16:37:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6C3041C20A5B
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 14:37:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F3BA1118F;
	Thu,  8 Jun 2023 14:37:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2426528F3
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 14:37:30 +0000 (UTC)
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5B0273A
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 07:37:28 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id 5614622812f47-39a3f2668d5so482512b6e.1
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 07:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1686235047; x=1688827047;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wkp11mGb7Y6Wz5I0W/WSpFxDQu84gcRYJNkM5DBTCVo=;
        b=PqCk0/um1V9YbdSUxSlKPYPemv5fpxy3njVZOYlvJ2iUpiIXdToN4GoWp5nvnpdKb3
         O2cM6Rl7598kOscoWt9Qs1ZQxcLnLBWOL+bLwx9Il1r9N12fAIhb7FOTrAOuIF2mwkOl
         vv9VguCEHFoCk5KtURTfj3UEtjVnaua7Pt/mMbMKur2Y79wfHwrSVSZVf1mqGyw+mmKM
         s4u/MyQd9jcrzh97QZPdFMM95klWruvTVGSUnu525xdQG4zyw8oimNDPpV8oanXoupdT
         7qHu876oBgozkbgJrX7B7NK4WDB3biz8DI8g693qaM58TsxU12nyGBHlLjREhjv3URXI
         Oc3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686235047; x=1688827047;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wkp11mGb7Y6Wz5I0W/WSpFxDQu84gcRYJNkM5DBTCVo=;
        b=QG8Wogrj+gSS21VLP0E+vEV/Z2T9py5zMU/YqW3BIY4gnwgC/+dfQEx532G2YPJnp5
         WAE4pjEx4OIqPuVMbek63K0XsBZezb/fLTCKrpIDG6X/Vw+b6HSpbF9PUFUKtIMY/BlU
         cAYdv8KUpmALinnjij26pPkyjDUESJZYTZugev/HVwxutJJmezXGgPlpxb06oRzuosb2
         9AMGfR63pijdkthSA1mht9F1Y1G2WoI9lDnXmQOL2dehZV76BDUNio/8NDTGz8k15f48
         Rlf0bvL8RSxz424MNbskLZmpOjyJExQzYDWT4KyxwlvyzDsfF1XRm84Vp7DNuWTdMviO
         yEmw==
X-Gm-Message-State: AC+VfDyjvZh1+A/fec+LhQISvrAcsyxVpzRDtmqdD21jTAizXf+HKZ7i
	zZ/4zSNM5toM56QfjUZH/6tAlQ==
X-Google-Smtp-Source: ACHHUZ4J3AFGTu/bJU7e4t/xvlV3P5k9aTl87g6TKaQaasrbQ1nS3MOt0NOGdCh4noHJB46Qq0bJKQ==
X-Received: by 2002:aca:1a0b:0:b0:39a:9e6e:9a9d with SMTP id a11-20020aca1a0b000000b0039a9e6e9a9dmr5666744oia.8.1686235047614;
        Thu, 08 Jun 2023 07:37:27 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:44fb:bbfb:717f:472:7a01? ([2804:14d:5c5e:44fb:bbfb:717f:472:7a01])
        by smtp.gmail.com with ESMTPSA id z2-20020aca3302000000b0038ee0c3b38esm495764oiz.44.2023.06.08.07.37.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jun 2023 07:37:27 -0700 (PDT)
Message-ID: <a25ab68b-0256-97b3-842e-0840bf2c0013@mojatatu.com>
Date: Thu, 8 Jun 2023 11:37:22 -0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net,v2] net/sched: taprio: fix slab-out-of-bounds Read in
 taprio_dequeue_from_txq
Content-Language: en-US
To: Zhengchao Shao <shaozhengchao@huawei.com>, netdev@vger.kernel.org,
 vinicius.gomes@intel.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
 jiri@resnulli.us, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com
Cc: vladimir.oltean@nxp.com, weiyongjun1@huawei.com, yuehaibing@huawei.com
References: <20230608062756.3626573-1-shaozhengchao@huawei.com>
From: Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <20230608062756.3626573-1-shaozhengchao@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 08/06/2023 03:27, Zhengchao Shao wrote:
> As shown in [1], out-of-bounds access occurs in two cases:
> 1)when the qdisc of the taprio type is used to replace the previously
> configured taprio, count and offset in tc_to_txq can be set to 0. In this
> case, the value of *txq in taprio_next_tc_txq() will increases
> continuously. When the number of accessed queues exceeds the number of
> queues on the device, out-of-bounds access occurs.
> 2)When packets are dequeued, taprio can be deleted. In this case, the tc
> rule of dev is cleared. The count and offset values are also set to 0. In
> this case, out-of-bounds access is also caused.
> 
> Now the restriction on the queue number is added.
> 
> [1] https://groups.google.com/g/syzkaller-bugs/c/_lYOKgkBVMg
> Fixes: 2f530df76c8c ("net/sched: taprio: give higher priority to higher TCs in software dequeue mode")
> Reported-by: syzbot+04afcb3d2c840447559a@syzkaller.appspotmail.com
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>

Tested-by: Pedro Tammela <pctammela@mojatatu.com>

> ---
> v2: set q->cur_txq[tc] to prevent out-of-bounds access during next dequeue
> ---
>   net/sched/sch_taprio.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index 3c4c2c334878..82983a6eb8f8 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -799,6 +799,9 @@ static struct sk_buff *taprio_dequeue_tc_priority(struct Qdisc *sch,
>   
>   			taprio_next_tc_txq(dev, tc, &q->cur_txq[tc]);
>   
> +			if (q->cur_txq[tc] >= dev->num_tx_queues)
> +				q->cur_txq[tc] = first_txq;
> +
>   			if (skb)
>   				return skb;
>   		} while (q->cur_txq[tc] != first_txq);


