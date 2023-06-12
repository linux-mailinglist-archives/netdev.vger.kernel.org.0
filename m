Return-Path: <netdev+bounces-10133-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79CB872C6E9
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 16:06:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3665F28110F
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 14:06:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 917AB19E79;
	Mon, 12 Jun 2023 14:06:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838E910797
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 14:06:52 +0000 (UTC)
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2CD11AC
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 07:06:50 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id 5614622812f47-39ce0ab782fso511364b6e.2
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 07:06:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1686578810; x=1689170810;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xsdmhjpRGSdJy8duW0cRu2kSL+sqBWoPxLjE/v0NwQk=;
        b=BcEWUpFlcjBdCg+7ziTnKPi5jt3GkLD/rl6s+mFIrszgGhQUcI//ea6nQUNOh5nLaA
         MeUcVS1d+lS0STpkR+s6QQG9xR+yksQBBJ7YqsZV7HpmIK3fKcgy5Tqy6sPZusKdUVYI
         sbnHYJzJsKei3+eZb5ejKdEEBHRR7FIYQZQswsVDqW+roL+pqh57hgGkBvhoF58muIsG
         SJy98B8EPBeyg0nXRuBc/fSqtBmImDbNA8KqzEeIZVH28sW0YkP90eqxquGJrD4driWm
         XXb+ecUPix5TQZ0DGha8z1ZBFKlzOHZzb0+KgkKCn+pqby4pmv9ALWgpGG5Q0bJ+CVRz
         F5bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686578810; x=1689170810;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xsdmhjpRGSdJy8duW0cRu2kSL+sqBWoPxLjE/v0NwQk=;
        b=hUAjnPgNmDd1VTmm79Pn6Frq+eOeAIW+S1HlZm17DqAqyYCxHXTZCMTiBxZDalTv+I
         YSxLcRb84IkER3LkGdmhZ/H6vn/82VO/Iz3kE8nFeNEyHDL9mdSoHxCx+58uTKIGUO0/
         rEXVGeqjC09Z5Gdrl0646alpEwGTnoDynjsJN/GUmzpxKsHf7q+Y7racXb24tZiblqJF
         DZAb2hj3WOkCsqHCdNGIwPEpbf1pK8oT9XZ1t+gGXyki6hfQJ8N5FOkwLqbQzFMwPMP7
         2YW2pSQ/aZL/SOuX1L3sZ5U57Ty6Pp1Pe+LfrED49y9Sk4w/5ew/R7oj+zcWFoPt4Lnu
         Vgng==
X-Gm-Message-State: AC+VfDyZpEiMuSp041qKfb5n/RdbeijlToaW0kaBuArpQc6RN/TZKucR
	4b7MdzbeSmdKr7hSNL5y4jvkOg==
X-Google-Smtp-Source: ACHHUZ5EqLLjPRnWfXRrp4f0OkP1I+TLvWkE0y771rdFRvlL1LJn86Zpe+tj1iISi4tKlqFH6SjO6w==
X-Received: by 2002:a05:6808:19a5:b0:398:342a:f491 with SMTP id bj37-20020a05680819a500b00398342af491mr4939869oib.34.1686578810354;
        Mon, 12 Jun 2023 07:06:50 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:44fb:5ac6:7609:9e55:394c? ([2804:14d:5c5e:44fb:5ac6:7609:9e55:394c])
        by smtp.gmail.com with ESMTPSA id m65-20020acabc44000000b00397be3b2e3asm4309619oif.0.2023.06.12.07.06.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jun 2023 07:06:49 -0700 (PDT)
Message-ID: <0c8f33c6-bac0-7f02-aa02-bcef278f148f@mojatatu.com>
Date: Mon, 12 Jun 2023 11:06:45 -0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net 0/4] Fix small bugs and annoyances in tc-testing
Content-Language: en-US
To: Vlad Buslov <vladbu@nvidia.com>, pabeni@redhat.com, davem@davemloft.net,
 kuba@kernel.org, shuah@kernel.org, jhs@mojatatu.com,
 xiyou.wangcong@gmail.com, jiri@resnulli.us
Cc: netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
 marcelo.leitner@gmail.com, shaozhengchao@huawei.com, victor@mojatatu.com
References: <20230612075712.2861848-1-vladbu@nvidia.com>
From: Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <20230612075712.2861848-1-vladbu@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 12/06/2023 04:57, Vlad Buslov wrote:
> Vlad Buslov (4):
>    selftests/tc-testing: Fix Error: Specified qdisc kind is unknown.
>    selftests/tc-testing: Fix Error: failed to find target LOG
>    selftests/tc-testing: Fix SFB db test
>    selftests/tc-testing: Remove configs that no longer exist
> 
>   tools/testing/selftests/tc-testing/config                   | 6 +-----
>   tools/testing/selftests/tc-testing/tc-tests/qdiscs/sfb.json | 4 ++--
>   tools/testing/selftests/tc-testing/tdc.sh                   | 1 +
>   3 files changed, 4 insertions(+), 7 deletions(-)
> 

LGTM,

Reviewed-by: Pedro Tammela <pctammela@mojatatu.com>

