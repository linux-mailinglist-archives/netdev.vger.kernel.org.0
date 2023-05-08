Return-Path: <netdev+bounces-872-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B43D6FB250
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 16:12:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C6CBE1C20998
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 14:12:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53C021361;
	Mon,  8 May 2023 14:12:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4880C15CC
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 14:12:03 +0000 (UTC)
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B826826E82
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 07:12:01 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-192a0aab7dfso3636735fac.3
        for <netdev@vger.kernel.org>; Mon, 08 May 2023 07:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1683555120; x=1686147120;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h773zB7L3Z4YOeGFM9KPDGaeyVeWxA0sAUEnP9BjGoE=;
        b=CDLnus2hjYndcrrc2sdHBBtORtAE00i4C5k9ZdE25vTcxpQE/qmvJKLAo5/2eKGIzQ
         nTf/00fL9cwSjcgyl4FVTSr8S4A3l/Ep7dGPOi/3PFKt2Ur/cLxQuO1rMCjlRpD9cLHI
         3gSDkdSs9Ml3hwjSl2HHA9ogFj99yD9DaImMDi1rNMtBXH4/JUSCFmmOfWRcxtGj2TMi
         8Jy3rnzij55sda6h4wQvtX518daTYiCXJnZ4v9RRV3R70kuv0JY528eYyBMY8MwbAldB
         SS0cOSrLUniwLYSvhyRCLQd4L28jrW7xVFVXFaYDkbEhkDX1qyCpeumA5GfMqbFB/kX9
         c7Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683555120; x=1686147120;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h773zB7L3Z4YOeGFM9KPDGaeyVeWxA0sAUEnP9BjGoE=;
        b=WvNHbAXKwvnqxpd3GgAEOywAKms8Cn6bpVTmXoogiTV+WB3D6vZ2Ml3/DSsjWEDnux
         xNaFs27MbtJxQjvCiENzGOmvBLEM6LWIZtLw4zGRlnhdk55elYUYEQc5Pl59ouF165PT
         FCeNOtUBiRlAvVfjn7osxMjDW/C+tNZ98Cutaffx1kslXbhz0q0j4QpWRtp1H2DMjG6z
         6xoEJA8yaAqN0ZbEEraa0GBza3bzwowUh4XUdVYua7mzAfv1tsD8bBXxmpM1U6crgtOi
         q90C0iuqm1delFgCdeviA0+11jUwvBSUKUpmecsgQEn0NcjZ9T6ueoqKhyT0TkJgeA8Q
         Ktkw==
X-Gm-Message-State: AC+VfDz5q0ggN2itGGKj2ag1AyUd3u8st4iodBMkze/5MLUaOqBVd7fY
	VZld3nGSr/MfyPkP4eth5j/Z5Q==
X-Google-Smtp-Source: ACHHUZ67qRlkLtWr8G9OfppsLqQ2Ov1KWi2/SdSwXWbif3KYd1ifgeDUO4L40YRcsQ7oqc1CoQNPyg==
X-Received: by 2002:a05:6808:317:b0:386:a643:1576 with SMTP id i23-20020a056808031700b00386a6431576mr4903529oie.46.1683555120164;
        Mon, 08 May 2023 07:12:00 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:44fb:d672:f891:23e9:e156? ([2804:14d:5c5e:44fb:d672:f891:23e9:e156])
        by smtp.gmail.com with ESMTPSA id k203-20020aca3dd4000000b0039232a8a1a3sm30925oia.13.2023.05.08.07.11.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 May 2023 07:11:59 -0700 (PDT)
Message-ID: <58261cfa-7cba-5cc6-92ac-de155a813df7@mojatatu.com>
Date: Mon, 8 May 2023 11:11:53 -0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net 5/6] net/sched: Refactor qdisc_graft() for ingress and
 clsact Qdiscs
To: Peilin Ye <yepeilin.cs@gmail.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Jamal Hadi Salim <jhs@mojatatu.com>, Cong Wang <xiyou.wangcong@gmail.com>,
 Jiri Pirko <jiri@resnulli.us>
Cc: Peilin Ye <peilin.ye@bytedance.com>,
 Daniel Borkmann <daniel@iogearbox.net>,
 John Fastabend <john.r.fastabend@intel.com>,
 Vlad Buslov <vladbu@mellanox.com>, Hillf Danton <hdanton@sina.com>,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 Cong Wang <cong.wang@bytedance.com>
References: <cover.1683326865.git.peilin.ye@bytedance.com>
 <1cd15c879d51e38f6b189d41553e67a8a1de0250.1683326865.git.peilin.ye@bytedance.com>
Content-Language: en-US
From: Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <1cd15c879d51e38f6b189d41553e67a8a1de0250.1683326865.git.peilin.ye@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 05/05/2023 21:15, Peilin Ye wrote:
> Grafting ingress and clsact Qdiscs does not need a for-loop in
> qdisc_graft().  Refactor it.  No functional changes intended.
> 
> Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>

Just a FYI:
If you decide to keep this refactoring, it will need to be back ported
together with the subsequent fix.
I would personally leave it to net-next.

Thanks for chasing this!

Tested-by: Pedro Tammela <pctammela@mojatatu.com>

> ---
>   net/sched/sch_api.c | 20 ++++++++++----------
>   1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
> index 49b9c1bbfdd9..f72a581666a2 100644
> --- a/net/sched/sch_api.c
> +++ b/net/sched/sch_api.c
> @@ -1073,12 +1073,12 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
>   
>   	if (parent == NULL) {
>   		unsigned int i, num_q, ingress;
> +		struct netdev_queue *dev_queue;
>   
>   		ingress = 0;
>   		num_q = dev->num_tx_queues;
>   		if ((q && q->flags & TCQ_F_INGRESS) ||
>   		    (new && new->flags & TCQ_F_INGRESS)) {
> -			num_q = 1;
>   			ingress = 1;
>   			if (!dev_ingress_queue(dev)) {
>   				NL_SET_ERR_MSG(extack, "Device does not have an ingress queue");
> @@ -1094,18 +1094,18 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
>   		if (new && new->ops->attach && !ingress)
>   			goto skip;
>   
> -		for (i = 0; i < num_q; i++) {
> -			struct netdev_queue *dev_queue = dev_ingress_queue(dev);
> -
> -			if (!ingress)
> +		if (!ingress) {
> +			for (i = 0; i < num_q; i++) {
>   				dev_queue = netdev_get_tx_queue(dev, i);
> +				old = dev_graft_qdisc(dev_queue, new);
>   
> -			old = dev_graft_qdisc(dev_queue, new);
> -			if (new && i > 0)
> -				qdisc_refcount_inc(new);
> -
> -			if (!ingress)
> +				if (new && i > 0)
> +					qdisc_refcount_inc(new);
>   				qdisc_put(old);
> +			}
> +		} else {
> +			dev_queue = dev_ingress_queue(dev);
> +			old = dev_graft_qdisc(dev_queue, new);
>   		}
>   
>   skip:


