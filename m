Return-Path: <netdev+bounces-4350-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D0FC70C28B
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 17:36:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F2391C20AAB
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 15:36:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C6EC14AB5;
	Mon, 22 May 2023 15:36:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF1F14AAD
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 15:36:22 +0000 (UTC)
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0770ABB;
	Mon, 22 May 2023 08:36:21 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-64d604cc0aaso1223482b3a.2;
        Mon, 22 May 2023 08:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684769780; x=1687361780;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DenES0KQSjrCWYfYQgXjcF0k/ImoCZJgCineCmXx+NE=;
        b=jASfy9rNHOxQwklay2dl4HeJfqhrXM71IqRNK25gCbRc8zhxHX1xrhfX0geOpAgTJq
         XyeDtcJk8UZYGfNrZqN3ijB11s5Bs3QsX5Cv7MfFgQfd+ZVuVwIaAgVpxGwwMRyxMW8F
         oADHQ2s5A/1zr8r6IibKMoSQcwpoNg269LCdwzHdvFaG5qGo2tlwycSFg5f5ru/NQpOb
         /XYub7ZNNyeD3mRl9rob1nesDHRLBnbOA3qJ9aid+EX9zCmLJCpjYAyGpI2FquCdRra0
         24IZnWPrM6RzIpBfsgga0JOYD7LoBkVv2dTgyP9TUXgKVpbUTYOpnXmhYjI8NIO1Gsv3
         Gjpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684769780; x=1687361780;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DenES0KQSjrCWYfYQgXjcF0k/ImoCZJgCineCmXx+NE=;
        b=Ur2Ft1EZHT8KN14d9iGOo7XlLchzMuD1i9RKkDK2ZLbGQcIqyr/yssSslLqERQ53hX
         WBd6JHixU4YNSA+Of2V2dQ/pvNNi7nyX/uGqkoaBjzAKZ28vkAXq84ouwhj6J6fjmZiR
         7C0A08lAgzEkNrkNZjU0GoHog0RZ2yS1U2btn/N/6aoMJFAnpxsVVv+7T0UOiEtW5hTi
         nF30WjIr9L2bx325C0uDo8y3IgbJzfLCLNnSecuMob6tkWZ4vZf64tfKa4JrUYmKpl1u
         eRK9pU91XOWW6vhGzuixTbTIj8vmicnJHU+RJjf7q36da0fKRju+5nghnsJvtLh/Jtg6
         tPuw==
X-Gm-Message-State: AC+VfDy+S9EgwBR5JjovDIW6DCHkGsVTANmUes2ZbcDs07UB9hLQjnXv
	wriJJmRW/l6D7kEXoVL3eX4=
X-Google-Smtp-Source: ACHHUZ5kMw3+1b6tLTszJJvFqHHI3vChTGvGuyKIosGush/AiROF93kKWL+uNb5ZHIVOgEby3Ng5/A==
X-Received: by 2002:a05:6a00:248a:b0:64d:5b4b:8429 with SMTP id c10-20020a056a00248a00b0064d5b4b8429mr8042391pfv.18.1684769780446;
        Mon, 22 May 2023 08:36:20 -0700 (PDT)
Received: from ubuntu777.domain.name (36-228-81-153.dynamic-ip.hinet.net. [36.228.81.153])
        by smtp.gmail.com with ESMTPSA id w17-20020aa78591000000b006414c3ba8a3sm4447849pfn.177.2023.05.22.08.36.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 08:36:19 -0700 (PDT)
From: Min-Hua Chen <minhuadotchen@gmail.com>
To: ecree.xilinx@gmail.com
Cc: alexandre.torgue@foss.st.com,
	davem@davemloft.net,
	edumazet@google.com,
	joabreu@synopsys.com,
	kuba@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	mcoquelin.stm32@gmail.com,
	minhuadotchen@gmail.com,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	peppe.cavallaro@st.com,
	simon.horman@corigine.com
Subject: Re: [PATCH v3] net: stmmac: compare p->des0 and p->des1 with __le32 type values
Date: Mon, 22 May 2023 23:36:15 +0800
Message-Id: <20230522153615.247577-1-minhuadotchen@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <9e6b813a-bc1a-6a39-904d-5c45f983cd23@gmail.com>
References: <9e6b813a-bc1a-6a39-904d-5c45f983cd23@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

hi Edward,

>>> On Fri, 19 May 2023 19:50:28 +0800 Min-Hua Chen wrote:
>>>> -		if ((p->des0 == 0xffffffff) && (p->des1 == 0xffffffff))
>>>> +		if (p->des0 == cpu_to_le32(0xffffffff) &&
>>>> +		    p->des1 == cpu_to_le32(0xffffffff))
>>>
>>> Can you try to fix the sparse tool instead? I believe it already
>>> ignores such errors for the constant of 0, maybe it can be taught 
>>> to ignore all "isomorphic" values?
>>>
>> 
>> I downloaded the source code of sparse and I'm afraid that I cannot make
>> 0xFFFFFFFF ignored easily. I've tried ~0 instead of 0xFFFFFF,
>> but it did not work with current sparse.
>> 
>> 0 is a special case mentioned in [1].
>
>I believe you can do something like
>    if ((p->des0 == ~(__le32)0) && (p->des1 == ~(__le32)0))
> and sparse will accept that, because the cast is allowed under the
> special case.
>HTH,
>-ed

I tested ~(__le32)0 and it worked: sparse accpets this.
Thanks for sharing this.

cheers,
Min-Hua

