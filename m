Return-Path: <netdev+bounces-5048-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37FCC70F8C2
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 16:32:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E73142813D7
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:32:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 363AA60862;
	Wed, 24 May 2023 14:32:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286D018C11
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 14:32:06 +0000 (UTC)
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FFDB12F
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 07:32:04 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-19eb0841830so269592fac.2
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 07:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1684938723; x=1687530723;
        h=content-transfer-encoding:in-reply-to:from:content-language:subject
         :references:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IDyGaU5vY520HnRjaMujkkWoZrPH9Gy1gshhTzYah3M=;
        b=FfTgFnJkkoNOzvnk6oEE9OPOuc8tf6bsjZ9BjuQ6mCdPMyGsAzpYo7OE4+isfzgzY1
         pEfY++1lTgtDnpl5xPZ2qdf9djm0iwGAMzLTIvITVu7pAQpyE0xh2aPkuLSRoowRXeLx
         L7R165r7QeGBPbhuwFBrr6ThCdviuhTQ9bXCxn6O0ypDoDF2YkQdx2bHveTHpHpv8x1O
         NeUCVyJEnXyZKEYnTXPjelAbnpeETChz5KzihEjpnpGZONEPf/BGAUS5blax2LQdJc7h
         7QPjUWVn7wVz+WxqzYt1OOFIkZH1Fh7lvcGnb5UcdwvKI0JAFB9gxH5p5gx2Td8N5fG2
         fsQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684938723; x=1687530723;
        h=content-transfer-encoding:in-reply-to:from:content-language:subject
         :references:cc:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IDyGaU5vY520HnRjaMujkkWoZrPH9Gy1gshhTzYah3M=;
        b=GMRF7Ht3ddK/xAf8nZOzbHYh8a2ewq5RzypTEz2eA558H+BaBzPQxvzwjHFKxfj4Zq
         xXfhTZuUc9F88+eyN39+PCTh0y5RrjB4FxlqF436ngAzUz0edoYX+Eo+jwZohOeJAWKX
         t0yUgVKFiHMb4x+pM8T+OREhzRSEzitzZGwu+APEmJVNlxImIyC2DTA3rj+PAcSWdAfK
         DkEYiQZWaOsGGa59rosLN15Wi1Tm21EaUH83iCvers5AomZr7pCfLdV5iDihdEJmP2Cj
         bcsR+IArTLyC0c4D//iF7FQEXCMl+s3vZ7DM8kJS2jhkDSbsqQcnHRwbWsFsnAHUOfgZ
         et8w==
X-Gm-Message-State: AC+VfDzj9gu2v0/VJiDuhfDhndvd0KnbCMVDHpLiSpmZYp0OnyuG07fK
	EFNyU0r0v48kfJWWMAJaEMMWIA==
X-Google-Smtp-Source: ACHHUZ5FsadYXL4czxLL/bHmeVCASD9xFCcwU6J9Jb8HfL+5NU91k63PTMY1pBl3/JZ1F7qDeLMBdg==
X-Received: by 2002:a05:6870:e493:b0:199:a8cc:13dc with SMTP id v19-20020a056870e49300b00199a8cc13dcmr20766oag.9.1684938723334;
        Wed, 24 May 2023 07:32:03 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:44fb:522c:f73f:493b:2b5? ([2804:14d:5c5e:44fb:522c:f73f:493b:2b5])
        by smtp.gmail.com with ESMTPSA id dt40-20020a0568705aa800b001968dd2e1fesm2814oab.3.2023.05.24.07.32.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 May 2023 07:32:02 -0700 (PDT)
Message-ID: <f309f841-3997-93cf-3f30-fa2b06560fc0@mojatatu.com>
Date: Wed, 24 May 2023 11:31:58 -0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
To: syzbot+b53a9c0d1ea4ad62da8b@syzkaller.appspotmail.com
Cc: davem@davemloft.net, edumazet@google.com, jhs@mojatatu.com,
 jiri@resnulli.us, kuba@kernel.org, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
 xiyou.wangcong@gmail.com
References: <0000000000006cf87705f79acf1a@google.com>
Subject: Re: [syzbot] [net?] KASAN: slab-use-after-free Write in
 mini_qdisc_pair_swap
Content-Language: en-US
From: Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <0000000000006cf87705f79acf1a@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

#syz test: git://gitlab.com/tammela/net.git peilin-patches

Double checking with syzbot

