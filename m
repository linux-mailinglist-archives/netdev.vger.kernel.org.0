Return-Path: <netdev+bounces-11137-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F4158731AB5
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 16:00:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ADC1828159C
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 14:00:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9F53171A2;
	Thu, 15 Jun 2023 14:00:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D26F168C6
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 14:00:31 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B1D2943
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 07:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686837625;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iY9+jzWeLLrhR3zsPgELSfNoWOXUeIAPez3AsCnmyUE=;
	b=dHN2J9ivrvJPQdsQb+K3i1MOYBQbNYJHySyxRoxavbR9d/yrANWh2lYGH3QSglcX+pLyaM
	lEq4wMMvIjWU+NQnEOQeKXOYk28qbop0lPdWMluPGjBifCHjUfg08QYibphpWAhqmkIz72
	jSN+Ltz2VbkKc2FeqxwiwnEpqH0YGZc=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-jW4Uotw5N8edrCYAMlFxMg-1; Thu, 15 Jun 2023 10:00:23 -0400
X-MC-Unique: jW4Uotw5N8edrCYAMlFxMg-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-514b8d2b21fso6782282a12.1
        for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 07:00:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686837616; x=1689429616;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iY9+jzWeLLrhR3zsPgELSfNoWOXUeIAPez3AsCnmyUE=;
        b=GdcaYdxykbSx5FDQqTzp9cxksV77Li79gcX8ovKlEU9WLhe2/WIL06sB94peTZhsep
         Slj2z1DM7MVeSW4v9EzDVDaz/BBlI6UhvoBmJ9zJeHGIp+w+es0m/RmA4gqmahTD7sfI
         7E2mlzl5LYQ++6YE6KvewoeqzQ3bKJSutbVRAokh0IGoAu2GMhEKRuj+cogtK0O2pFgQ
         9UKLo3gLtLuO3dleDj6zpzk/d2NMl1WOycbKpbv+rv24cuOneICVJQyQ343BhdHNwwQS
         VDCZWoT5IRDAc2BTuDO/T0bYycxTxmLzT2UuyITdTbs8lEK8buI32LAPl5Htup10PEsg
         7UHw==
X-Gm-Message-State: AC+VfDx4ohkkIFsFPE+CsK4UItiK7FOBT44aT0dPhFukBfJCVPED+STb
	ppsnHABUYOeZMRblLkVanpbbHWTumi4QO6gpKHhyP+fHnQAFZattxOUnqWtpWVdqacSqA4Eaq5S
	Y2MT4H/+q9Xxvt3/gmdHj303o
X-Received: by 2002:a05:6402:1252:b0:518:82c4:cc7e with SMTP id l18-20020a056402125200b0051882c4cc7emr3651692edw.17.1686837616422;
        Thu, 15 Jun 2023 07:00:16 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ58ICTUk9qzBYW9m2U3cHL0vpsVIWAJ3qpjhMUfMNM+LxWyP8r4apEo2Pcp5+Wa7vwiB9elyA==
X-Received: by 2002:a05:6402:1252:b0:518:82c4:cc7e with SMTP id l18-20020a056402125200b0051882c4cc7emr3651672edw.17.1686837616076;
        Thu, 15 Jun 2023 07:00:16 -0700 (PDT)
Received: from [192.168.42.222] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id ba7-20020a0564021ac700b0050bc6983041sm8920929edb.96.2023.06.15.07.00.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jun 2023 07:00:15 -0700 (PDT)
From: Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <b28b0e3e-87e4-5a02-c172-2d1424405a5a@redhat.com>
Date: Thu, 15 Jun 2023 16:00:13 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Cc: brouer@redhat.com, hawk@kernel.org, ilias.apalodimas@linaro.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net,
 edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net-next] page pool: not return page to alloc cache during
 pool destruction
Content-Language: en-US
To: Jakub Kicinski <kuba@kernel.org>, Liang Chen <liangchen.linux@gmail.com>
References: <20230615013645.7297-1-liangchen.linux@gmail.com>
 <20230614212031.7e1b6893@kernel.org>
In-Reply-To: <20230614212031.7e1b6893@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 15/06/2023 06.20, Jakub Kicinski wrote:
> On Thu, 15 Jun 2023 09:36:45 +0800 Liang Chen wrote:
>> When destroying a page pool, the alloc cache and recycle ring are emptied.
>> If there are inflight pages, the retry process will periodically check the
>> recycle ring for recently returned pages, but not the alloc cache (alloc
>> cache is only emptied once). As a result, any pages returned to the alloc
>> cache after the page pool destruction will be stuck there and cause the
>> retry process to continuously look for inflight pages and report warnings.
>>
>> To safeguard against this situation, any pages returning to the alloc cache
>> after pool destruction should be prevented.
> 
> Let's hear from the page pool maintainers but I think the driver
> is supposed to prevent allocations while pool is getting destroyed.

Yes, this is a driver API violation. Direct returns (allow_direct) can
only happen from drivers RX path, e.g while driver is active processing
packets (in NAPI).  When driver is shutting down a page_pool, it MUST
have stopped RX path and NAPI (napi_disable()) before calling
page_pool_destroy()  Thus, this situation cannot happen and if it does
it is a driver bug.

> Perhaps we can add DEBUG_NET_WARN_ON_ONCE() for this condition to
> prevent wasting cycles in production builds?
> 

For this page_pool code path ("allow_direct") it is extremely important
we avoid wasting cycles in production.  As this is used for XDP_DROP
use-cases for 100Gbit/s NICs.

At 100Gbit/s with 64 bytes Ethernet frames (84 on wire), the wirespeed
is 148.8Mpps which gives CPU 6.72 nanosec to process each packet.
The microbench[1] shows (below signature) that page_pool_alloc_pages() +
page_pool_recycle_direct() cost 4.041 ns (or 14 cycles(tsc)).
Thus, for this code fast-path every cycle counts.

In practice PCIe transactions/sec seems limit total system to 108Mpps
(with multiple RX-queues + descriptor compression) thus 9.26 nanosec to
process each packet. Individual hardware RX queues seems be limited to
around 36Mpps thus 27.77 nanosec to process each packet.

Adding a DEBUG_NET_WARN_ON_ONCE will be annoying as I like to run my
testlab kernels with CONFIG_DEBUG_NET, which will change this extreme
fash-path slightly (adding some unlikely's affecting code layout to the
mix).

Question to Liang Chen: Did you hit this bug in practice?

--Jesper

CPU E5-1650 v4 @ 3.60GHz
  tasklet_page_pool01_fast_path Per elem:  14 cycles(tsc)  4.041 ns
  tasklet_page_pool02_ptr_ring  Per elem:  49 cycles(tsc) 13.622 ns
  tasklet_page_pool03_slow      Per elem: 162 cycles(tsc) 45.198 ns

[1] 
https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/lib/bench_page_pool_simple.c


