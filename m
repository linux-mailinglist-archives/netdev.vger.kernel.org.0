Return-Path: <netdev+bounces-487-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DB676F7B69
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 05:20:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B26D01C215AD
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 03:20:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E24915A4;
	Fri,  5 May 2023 03:20:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0151376
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 03:20:45 +0000 (UTC)
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54D4983D9
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 20:20:43 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-63b5ce4f069so1431258b3a.1
        for <netdev@vger.kernel.org>; Thu, 04 May 2023 20:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1683256843; x=1685848843;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uab202Dnn1eDz/nkCMc9/SGSJeF/RNG3IPLG0FHPpw8=;
        b=YCMjZUIiDAdnuEBEXUnQSQDHdx4wWbeCnwCDg8iLh9HUR7ntN9nch50UknFKVbzOiD
         kckoNO9AJgAY4kVvTE2rcpTBWfZK1Z2/dXW7GSprkY/xxEpGaAyioyoHsGKG4nCrtgqg
         8YPZRvyrNlh9KKKjazPvJEeRxzF2J2S9WLH02PRzpltcDm+i0zE6u5f6PRZFep09No5a
         L45aZEHjZM7iDzi+EY+aHX/vzTYIv5gQrM8OjMCRiErzop2frYe1QpFdFzSXD/7mPdYP
         g1Cqwh+dfaYBl6sJHM30I0mdv2qAYE1p30VqXOEhj04fFQyIar5pYexfGu8qLZi579vL
         MiEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683256843; x=1685848843;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uab202Dnn1eDz/nkCMc9/SGSJeF/RNG3IPLG0FHPpw8=;
        b=WaSip1kn1SXQ1CPDAl6Uwp4Og4NJbZ1QAsMzFZE33MsiRfE9ieuAb40O6Tbtzy9tqI
         cnel+1kmqOFn4Kw8zitbdpSOvOHBUQMChCE6y/8XOQ1DUzTvAu27cYMQ7lWvjEtX4GpU
         NmLFOnRT1OhgIPRMjlafFTb5WBYYDcsVKJaVBGIoRxfJL38HsyBzPYamMHNDwkKicDaj
         lTX4eUQPUwnJQPDeU8JYU/+bVP1VjL+gFwH79NlYsNTKihi+srq2fQkET3VEJqZ9r00A
         uU2ZJ85tEsJK3BZQwj9lBhyqJhKIVG9p9eGWzo/eHzFrNj7wu4C+xqAcu7ynyDCwYsRr
         K79A==
X-Gm-Message-State: AC+VfDxosJ+h6G4FfMcqIdG3gDQGCzrF8y+05RmKvNUZYyEO7p1rOx3c
	tqk4D0ajpOgzDCrEe5vPNxw1GA==
X-Google-Smtp-Source: ACHHUZ53rIrj3+Txx+pQYi8n4x9Lolh+e+lbTw2OhE8kPCx9X7XF68GeoKW0zb+xh+zhbNBkTcXgKg==
X-Received: by 2002:a05:6a00:1346:b0:63b:4313:f8b5 with SMTP id k6-20020a056a00134600b0063b4313f8b5mr401131pfu.23.1683256842747;
        Thu, 04 May 2023 20:20:42 -0700 (PDT)
Received: from [10.71.57.173] ([139.177.225.254])
        by smtp.gmail.com with ESMTPSA id r16-20020a62e410000000b006258dd63a3fsm465264pfh.56.2023.05.04.20.20.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 May 2023 20:20:42 -0700 (PDT)
Message-ID: <1fd91fcf-f5b8-48af-f4d3-dfaf3a4f7c86@bytedance.com>
Date: Fri, 5 May 2023 11:20:32 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: Re: [PATCH bpf-next v5 1/2] bpf: Add bpf_task_under_cgroup()
 kfunc
To: Yonghong Song <yhs@meta.com>, martin.lau@linux.dev, ast@kernel.org,
 daniel@iogearbox.net, andrii@kernel.org, song@kernel.org, yhs@fb.com,
 john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
 haoluo@google.com, jolsa@kernel.org, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, mykolal@fb.com,
 shuah@kernel.org
Cc: bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
 yangzhenze@bytedance.com, wangdongdong.6@bytedance.com
References: <20230504031513.13749-1-zhoufeng.zf@bytedance.com>
 <20230504031513.13749-2-zhoufeng.zf@bytedance.com>
 <72f73a40-d793-11dd-af34-f1491312d3b5@meta.com>
From: Feng Zhou <zhoufeng.zf@bytedance.com>
In-Reply-To: <72f73a40-d793-11dd-af34-f1491312d3b5@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

在 2023/5/4 22:29, Yonghong Song 写道:
> 
> 
> On 5/3/23 8:15 PM, Feng zhou wrote:
>> From: Feng Zhou <zhoufeng.zf@bytedance.com>
>>
>> Add a kfunc that's similar to the bpf_current_task_under_cgroup.
>> The difference is that it is a designated task.
>>
>> When hook sched related functions, sometimes it is necessary to
>> specify a task instead of the current task.
>>
>> Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
> 
> You can carry my Ack from previous revision since there
> is no change to the patch.
> 
> Acked-by: Yonghong Song <yhs@fb.com>

Will do

