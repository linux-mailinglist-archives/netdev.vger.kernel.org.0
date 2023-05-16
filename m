Return-Path: <netdev+bounces-2985-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86E21704DBD
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 14:28:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27CE62815B9
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 12:28:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71DFC261D2;
	Tue, 16 May 2023 12:28:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665C71DDDA
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 12:28:03 +0000 (UTC)
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 615F76192
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 05:27:56 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id ffacd0b85a97d-307a8386946so5860633f8f.2
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 05:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684240075; x=1686832075;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4Qfc3iSypOrLo6n5tZhwXLqgeaoH+WMS+egxpy4CirU=;
        b=WKdMUpn/tgBLZmI5ApqUdq5ZaUSGX7DnO/r674oskIR8UGQDKm1lE5GlVWtTHSOZNX
         3a4uD0MaoSDdFcHMvo8a0QvpKLyOmyP3e6V0Ieryvr2ZfQaj2zG+A7+hLDUpwcIJdPLP
         EK9tjTjFdvQukVlTHQizDodlsF3K5s0zxbC0THfgzrnKN6bAC37dwmpEJIZfyo/l0Egm
         vHQd7RdV+fAczRztNyeFeMNRN68OiG9nxVoW+ndDiDHMW+V058sGEHzWbWr6bMhJVxrq
         O/mpsyzD0jzEESGXKLCBrzbeohmxJDk4uve+GyNSXvzS/yy5r11NHL9sEsMQZF0pWUuV
         SBLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684240075; x=1686832075;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4Qfc3iSypOrLo6n5tZhwXLqgeaoH+WMS+egxpy4CirU=;
        b=eROrK1U1GL21rpzsIOcTDpfsGIMYlbg68MrVRNni83ShrjFEqgaDxTVoQCNtbputPt
         oz5PhP6UJ4Cft5d2U3trzupjTZKJ1TGK6kUTlANVRTcFC6i+4+BorvV09vltEUvWs0qQ
         LPnxnS9b+P6uft+SSVHF932deJV1JFLrHrcBQ7gzpDZwm6FQs5ED5m2AQCQlXVr1IhHX
         n+v3Xjhs1wV8aq/stiC3nNGjeoGquAr5OVSz1w9A/+BQyYzaiFhuQ5K/HgBpuwSWj3r2
         7tc4xIsmk8BpmHkcBKvcPjxLtwY0R+0UvBERyVLcNofmXkht19e1zhJKWZsXyOBb9Qt6
         brMA==
X-Gm-Message-State: AC+VfDz5+6jUoDeBoz4ahLZnaGCcu/o3r0QL3AkCzwNNAbmDBBg+Mx4Q
	Z9vhHh6Dzvg2Z9EV08jF/BgQt/0ogxM=
X-Google-Smtp-Source: ACHHUZ4W9IcnYgiM/d+2dPFg+VsXNR1Xtkax9SWvOCThcwKTOA79KRslFqPWzeYc2iRSm46vLRn0Dg==
X-Received: by 2002:adf:ffd2:0:b0:306:3b62:d3be with SMTP id x18-20020adfffd2000000b003063b62d3bemr24883447wrs.41.1684240074594;
        Tue, 16 May 2023 05:27:54 -0700 (PDT)
Received: from [192.168.0.103] ([77.124.4.213])
        by smtp.gmail.com with ESMTPSA id z5-20020a1cf405000000b003f50e88ffc1sm2270831wma.0.2023.05.16.05.27.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 May 2023 05:27:54 -0700 (PDT)
Message-ID: <939fd42c-d451-0927-abd8-877c867958bb@gmail.com>
Date: Tue, 16 May 2023 15:27:51 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [RFC / RFT net 0/7] tls: rx: strp: fix inline crypto offload
Content-Language: en-US
To: Tariq Toukan <tariqt@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, drort@nvidia.com, samiram@nvidia.com,
 Gal Pressman <gal@nvidia.com>
References: <20230511012034.902782-1-kuba@kernel.org>
 <271c4388-cbb2-7d4f-22dd-9c73a4becf09@nvidia.com>
From: Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <271c4388-cbb2-7d4f-22dd-9c73a4becf09@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 11/05/2023 13:17, Tariq Toukan wrote:
> 
> 
> On 11/05/2023 4:20, Jakub Kicinski wrote:
>> Tariq, here are the fixes for the bug you reported.
>> I managed to test with mlx5 (and selftest, obviously).
>> I hacked things up for testing to trigger the copy and
>> reencrypt paths.
>>
>> Could you run it thru your tests and LMK if there are
>> any more regressions?
>>
> 
> Hi Jakub,
> 
> Thanks for your patches!
> I see that several changes were needed.
> 
> I tested your series with the repro I had, it seems to be resolved.
> 
> We are going to run more intensive and comprehensive tests during the 
> weekend, and we'll update on status on Sunday/Monday.
> 

Hi Jakub,

Here's an updated testing status:

1. Reported issue is resolved.
2. All device-offload TLS RX/TX tests passed, except for the one issue 
below.

Nothing indicates that this issue is new or related directly to your 
fixes series. It might have been there for some time, hiding behind the 
existing bugs.

Issue description:
TlsDecryptError / TlsEncryptError increase when simultaneously creating 
a bond interface.
It doesn't happen each and every time. It reproduced several times in 
different runs.
The strange part is that the bond is created and attached to a different 
interface, not the one running the TLS traffic!

I think we should progress with the fixes:
Tested-by: Shai Amiram <samiram@nvidia.com>

Regards,
Tariq

