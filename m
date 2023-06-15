Return-Path: <netdev+bounces-11159-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CD9EB731CB8
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 17:31:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 88728281409
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 15:31:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6F1D17748;
	Thu, 15 Jun 2023 15:31:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA94D17723
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 15:31:12 +0000 (UTC)
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E702962
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 08:30:53 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id ffacd0b85a97d-31110aea814so1308304f8f.2
        for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 08:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1686843051; x=1689435051;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SyGMF8+HtCyfqjkf2xIkvXLskCg/yArd1BF3qc60+kw=;
        b=zgv0INE8Z2tpPOlMo7VO2DZ6OVKRxYKr2xH4H3oc41nqbMqPStrL3xPv7tGYXs3rto
         t5NrHtjD2EC4UxnZgJfomD2LZQtaDh7L8Hhmk5woFZD9MNd1x3yI/NQzZcBMlK5hhV62
         3N9dI0I8iuv2U69EAhXo8YYduk1ZfqhEQFscXHOk9o5sLlr1yi9kHJiWDnxQgzNXVdvF
         wBNZe9AMS5v9lPTt2sSIvz4PFOdENKviwVCJb9e4yslTalrE/04WfGrEaPCKwLzbt3c0
         bmvqLjoB9xWhyj9FTmVlHzxj/zK/7SmGQCVWjDNjBmvE2g/uVd6wL/1oyJFnbtFfAiJd
         M5JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686843051; x=1689435051;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SyGMF8+HtCyfqjkf2xIkvXLskCg/yArd1BF3qc60+kw=;
        b=HvCvEzFD43qlf0bh+e8nJEty7XXsmF62WfcPaLy4TwmXVXQO3ahvJ11z9kmNkJzjg+
         4szMB16gyYjREGmLCdN18Pdyd4ueI7DNtIzG8tt7VmBm3b7SQb0o49ymzFasr0jnQy9E
         bSvnRh2bl7Sk2fmfk4WpHGc3GIltMIt6geRIh+DTuYrxulYSN1RrWGSb0Zocdb3h7xk/
         8tOVGt1LuQyAKOzr07riAfVHeSRM0HBYMuKk3ET6b/DBo+bbzYQuLtbpUnSYQxqib5RD
         Fsq6mZKdByBA13mrS9167uZTIxmHXNB541lKSeAZMxjm/D3q0SVhtXJ/jEgaMDGXDaG5
         gx4Q==
X-Gm-Message-State: AC+VfDzrGWNEfe/egWeVYVSqb7SsGKTUwFK1+WRa+ohAxfx5JtSE/Ym3
	OMjxLJLj5JgmCwgOGsVFERitdw==
X-Google-Smtp-Source: ACHHUZ6ISyzehiFWYn6cl4rypJE5rlQnvkY5cKgTooLnDoXIIUL/pXCC6YO6Gubc2pA/v0/wEckMKw==
X-Received: by 2002:a5d:42c7:0:b0:30f:ca58:cb10 with SMTP id t7-20020a5d42c7000000b0030fca58cb10mr7356789wrr.22.1686843051177;
        Thu, 15 Jun 2023 08:30:51 -0700 (PDT)
Received: from [10.124.6.73] ([195.181.172.155])
        by smtp.gmail.com with ESMTPSA id b14-20020a056000054e00b0030c2e3c7fb3sm21102095wrf.101.2023.06.15.08.30.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jun 2023 08:30:50 -0700 (PDT)
Message-ID: <964937b8-a7a1-71ad-5e12-8d4a854504a1@tessares.net>
Date: Thu, 15 Jun 2023 17:30:49 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
Content-Language: en-GB
To: Jakub Kicinski <kuba@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
 David Miller <davem@davemloft.net>, Networking <netdev@vger.kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux Next Mailing List <linux-next@vger.kernel.org>,
 Mat Martineau <martineau@kernel.org>, Paolo Abeni <pabeni@redhat.com>
References: <20230614111752.74207e28@canb.auug.org.au>
 <c473ffea-49c3-1c9c-b35c-cd3978369d0f@tessares.net>
 <20230614104133.55c93a32@kernel.org>
From: Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <20230614104133.55c93a32@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Jakub,

On 14/06/2023 19:41, Jakub Kicinski wrote:
> On Wed, 14 Jun 2023 10:51:16 +0200 Matthieu Baerts wrote:
>> I added a note about the conflicts on the cover-letter:
>>
>> https://lore.kernel.org/netdev/20230609-upstream-net-20230610-mptcp-selftests-support-old-kernels-part-3-v1-0-2896fe2ee8a3@tessares.net/
>>
>> Maybe it was not a good place? I didn't know where to put it as there
>> were multiple patches that were conflicting with each others even if the
>> major conflicts were between 47867f0a7e83 ("selftests: mptcp: join: skip
>> check if MIB counter not supported") and 0639fa230a21 ("selftests:
>> mptcp: add explicit check for new mibs"). I guess next time I should add
>> a comment referring to the cover-letter in the patches creating conflicts.
> 
> Hm, yeah, I think the cover letter may not be the best way.
> Looks like Stephen didn't use it, anyway, and it confused patchwork.
> No better idea where to put it tho :(
> 
> Maybe a link to a git rerere resolution uploaded somewhere we can wget
> from easily?

Good idea, I didn't think about git rerere! I will try to remember about
that next time :)

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net

