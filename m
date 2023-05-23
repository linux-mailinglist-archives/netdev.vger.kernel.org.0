Return-Path: <netdev+bounces-4692-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2E8E70DF06
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 16:17:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7CF46281352
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 14:17:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 129711F17A;
	Tue, 23 May 2023 14:17:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3391F177;
	Tue, 23 May 2023 14:17:35 +0000 (UTC)
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FCC0E9;
	Tue, 23 May 2023 07:17:34 -0700 (PDT)
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2af2c35fb85so44291051fa.3;
        Tue, 23 May 2023 07:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684851393; x=1687443393;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2x0J40jVoPlEDJ92hmP4ooz3zQmmJDfgf/IWZhxOlAo=;
        b=CrJyFN7Yh/XNTnmJ9jt4hYCmkhJJmHtn1cLqv380B97qIFUkcb4gchhaA9g0ddBREx
         JwdxstRDIgJ+5u/OtZLgO1ziFmRiQWbro1LXn+6+NXyjwR1wcuacduc4en6EkGuTtDBq
         lSD+OCfTlJbhDLZD25orC7raqICKbIf69mg4wS9tJ+YL19HNZTfUBoMUtfABmKYfspg3
         KafBgbpROfAbLPSmr6nXgmU57n0u5T02DSpIUXTlcioIoh0h8ZCYDqJxJTiKqj22zbTq
         zNM5BScTAGzoAA25GkmYuZOs0/Kiw8a7I2QiMpaK7EtPsTWGHzIm35emu99IsZZJCALJ
         Pziw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684851393; x=1687443393;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2x0J40jVoPlEDJ92hmP4ooz3zQmmJDfgf/IWZhxOlAo=;
        b=UIsY1arsYjdLN7Zx+Dn6O3++QbOQ/+3B431GVlNVId0F2jglJoB7HHpRYoKDKq2j72
         t5dk1OYKGOp0VaKlWP910sZxD/wND+ARhcdZzEFuI+J7pg9jtsq/d9pECl9Jj6HkXiFx
         QN7IhBBLsln2usRUAx/S71IjBafVmvbe0LuUpEnQTYW+kW3Xz1weFyYG5SsuTXYTRqfx
         Bj1kM66JY3hki27RX+vaysL+jhsgOqhJnZP4orI4iev1nCmLzfLJTuwYQKxA57yf+S5w
         Hw3P9V7EknRbcPsOC1mGmgQ7XemkzVifsQKtybYlIuI3xUWhy+n4pdwbZESpgDtCCX8s
         yc8A==
X-Gm-Message-State: AC+VfDye7SNPQH54irf1VDxVqBu0CgP7ZBLL0r9rrJuGB0MNBFsvfkOb
	kGSP1cATOImjQhD0cuYJ5fuXivSs5BN6D9I=
X-Google-Smtp-Source: ACHHUZ6o4GiojOXqr8dHeQxFcIzAfgPIuVh2dfEfZqOu+9qH8T1DcnqB4JnNPrMzPTP0ia2JA/NRbg==
X-Received: by 2002:a2e:a40d:0:b0:2a7:7055:97f5 with SMTP id p13-20020a2ea40d000000b002a7705597f5mr5210441ljn.0.1684851392444;
        Tue, 23 May 2023 07:16:32 -0700 (PDT)
Received: from ?IPV6:2001:14bb:112:9108:f097:2b17:be35:a808? (dyfllccjtw81vssv11yfy-4.rev.dnainternet.fi. [2001:14bb:112:9108:f097:2b17:be35:a808])
        by smtp.gmail.com with ESMTPSA id a6-20020a2e8606000000b002ac7c9d2806sm1646357lji.50.2023.05.23.07.16.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 May 2023 07:16:31 -0700 (PDT)
Message-ID: <740999b7-1995-384c-41af-866df05c4a2a@gmail.com>
Date: Tue, 23 May 2023 17:16:30 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH bpf-next] selftests/bpf: add xdp_feature selftest for bond
 device
Content-Language: en-US
To: Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org
Cc: lorenzo.bianconi@redhat.com, ast@kernel.org, daniel@iogearbox.net,
 andrii@kernel.org, martin.lau@linux.dev, netdev@vger.kernel.org
References: <64cb8f20e6491f5b971f8d3129335093c359aad7.1684329998.git.lorenzo@kernel.org>
From: Jussi Maki <joamaki@gmail.com>
In-Reply-To: <64cb8f20e6491f5b971f8d3129335093c359aad7.1684329998.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


On 17/05/2023 16:41, Lorenzo Bianconi wrote:
> Introduce selftests to check xdp_feature support for bond driver.
>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>   .../selftests/bpf/prog_tests/xdp_bonding.c    | 121 ++++++++++++++++++
>   1 file changed, 121 insertions(+)

Reviewed-by: Jussi Maki <joamaki@gmail.com>


