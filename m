Return-Path: <netdev+bounces-12257-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E1E4736E3B
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 16:03:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B414A1C20DDD
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 14:03:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE7F21643B;
	Tue, 20 Jun 2023 14:01:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30EB16415
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 14:01:54 +0000 (UTC)
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7E6A4
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 07:01:53 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-1a9ae7cc01dso3045083fac.3
        for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 07:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1687269712; x=1689861712;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qx3qfL1HirgTWsDZoyHLwa93o/yW8jsX8U+IWQ0e3Y0=;
        b=enKkH0FCZcorpKltMOB20n0FvN5LLEFsbMaVIGUqG5TToTfKcJmnNieJpTSfc2afDd
         JA7BxyfSAX65FpwlSgnoRlrQUTxxhFbW+UcBgoRt885temGFPGs+2N8Vr1ENEAQPadoU
         V0wpC3ipjCglQMJIUp62ia9p0IAbYhqt80Chi/40Sgfi/zz/84ItjvsjdtLPeHkkXl6A
         rRy2xzh2NGFFMGEAUCpd02HwHfXDqmRS95EFZP1CjNC+HuFt9kKNI0qNDeymNQYQQQHy
         P1+4d5WaurGprjJ4L1ovYLHx/VMOei0a4JWYWu504prtp06O7Uf6nk5Au1N6kbuTrUWd
         ckoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687269712; x=1689861712;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qx3qfL1HirgTWsDZoyHLwa93o/yW8jsX8U+IWQ0e3Y0=;
        b=bRPLcDPfQRovnznq8ZBydBm3EI+t0TjbrWbotk+koZxxgyhAsBAO1s3k+F9doFsWPl
         4qGGxdYx/qrUtea2+YTKfyXijzr6m4SFH5+VYSqGhDP6ohLzm9Iwg3PTfO2GQi4KM649
         Wlvtna+vcjLEJh9EHfSEQmpjkAAazVaAPyJA17jARByRkrZAULIMC8bgKV3R+uooJYox
         1yLjvNrxz4+Nmj1LhqFfTET+5vwfldFnxfwUAiJWFn4/yfdNU0G6gX8JrMuOovZK9ZUz
         51ibF/AvlsEwXfVP81bMOwT28Toz2soBH11dPO55OMGG9FNTi1ZKjtyyODHGn6gasjdQ
         Y++g==
X-Gm-Message-State: AC+VfDyC4R4IJhB7QmxV+U5aFEynjJWHuOzOCMtJLtTbiHhnOTRtH2gG
	IbAtxiktXxxh79cyDSeu3AFw8A==
X-Google-Smtp-Source: ACHHUZ7FJmRMKN5jjKhxSSZBZ8Uv+0ViaW+8j2ErxOb0LMrJKnqdwpE85uU4ZR/rMWd6hGdp7Te34A==
X-Received: by 2002:a05:6871:894:b0:187:7b68:2521 with SMTP id r20-20020a056871089400b001877b682521mr8720152oaq.36.1687269712395;
        Tue, 20 Jun 2023 07:01:52 -0700 (PDT)
Received: from ?IPV6:2804:7f1:e2c0:b50c:7c92:ef70:fa89:e82d? ([2804:7f1:e2c0:b50c:7c92:ef70:fa89:e82d])
        by smtp.gmail.com with ESMTPSA id fp43-20020a05687065ab00b001a371aec1b9sm1340216oab.31.2023.06.20.07.01.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jun 2023 07:01:51 -0700 (PDT)
Message-ID: <fd0fcdb3-6fc7-2eef-52c1-28fbc9eef295@mojatatu.com>
Date: Tue, 20 Jun 2023 11:01:46 -0300
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
To: renmingshuai <renmingshuai@huawei.com>, pctammela@mojatatu.com,
 vladbu@nvidia.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc: liaichun@huawei.com, caowangbao@huawei.com, yanan@huawei.com,
 liubo335@huawei.com
References: <20230620014939.2034054-1-renmingshuai@huawei.com>
From: Victor Nogueira <victor@mojatatu.com>
In-Reply-To: <20230620014939.2034054-1-renmingshuai@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

Acked-by: Victor Nogueira <victor@mojatatu.com>

