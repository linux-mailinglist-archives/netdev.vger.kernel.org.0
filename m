Return-Path: <netdev+bounces-11168-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AD30731D94
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 18:19:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8582E1C20EEA
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 16:19:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84B8618AE6;
	Thu, 15 Jun 2023 16:19:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C96156C0
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 16:19:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E79521FFA
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 09:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686845960;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jdyRYox4ez58cOxucW/gKoUBvS+2+yUof+u/Mb1E798=;
	b=DIW0giPVWxr7pvzaQ7aRDGk4zzZpcr8eux/vW9f/MH3/bQgwgrcrwecsY2wdWZve7gV+dI
	BuFDOD2nPgb+oOFy9e8INHiQHaUUfphaSluuSyckU1pxTiXwL1QMjjBNRCJzyTNzUklnw9
	Pkp0IKh4JMYD5PtaRlIF4A6YUsUIpBE=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-Aqf7cItrOpidRK8GOq3qnA-1; Thu, 15 Jun 2023 12:19:18 -0400
X-MC-Unique: Aqf7cItrOpidRK8GOq3qnA-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-9829a080268so94516466b.3
        for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 09:19:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686845957; x=1689437957;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jdyRYox4ez58cOxucW/gKoUBvS+2+yUof+u/Mb1E798=;
        b=E0ZtSZX2b9LQvRypFoBiJQDb7xntDV86TgaHvZTQsbLFs83vcMaqk8KibiQLxA+5E2
         iGNtf7ZnYjgKDgqu7G/D5gPyt9XfA5sRaxu0jda2tUgi9GtlBie6LOYa9GX2ZK6kYroO
         +8T4gfcUAIFmwNftQJ/cVFLb/ArN4dqC2yOes4jdGMYfGC7eQHjg5dIWx8eGxr/nYVgA
         QiEH5evZpvpUdDzljCJ7pgav+8jJknxTeaBN8vbcHVMjjPAUwJ5pjHFNhmBrGUr8Gz+3
         SERUSp4sllCpjYDDZD+ArXtOxhA7EF1uhzxt7tAZdQi5R/PeUKkieO3yIlyBMYYQcbpW
         92cQ==
X-Gm-Message-State: AC+VfDzORHeEA9JVucC2/daBKxCaCLt//6LbyO7QkHp2bZmu4OLwlqP4
	2Ksc4Xc6q1afLfMoxDGoknfNspf39lz4ijbCLgixKTXUE9xWSLlOy4YNRgldFpK9BwOaLfJx51h
	OTVHDmOgnYGAAm55d
X-Received: by 2002:a17:907:970a:b0:961:69a2:c8d6 with SMTP id jg10-20020a170907970a00b0096169a2c8d6mr21673384ejc.69.1686845957604;
        Thu, 15 Jun 2023 09:19:17 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4wE25SZBquEw19ouy6JqTjsnj0Hsl0l67V3udSD3DC3NcZDIIvy5Y+0os9fyBaLhwHkEIpsg==
X-Received: by 2002:a17:907:970a:b0:961:69a2:c8d6 with SMTP id jg10-20020a170907970a00b0096169a2c8d6mr21673365ejc.69.1686845957203;
        Thu, 15 Jun 2023 09:19:17 -0700 (PDT)
Received: from [192.168.42.222] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id b16-20020a170906491000b0095342bfb701sm9776088ejq.16.2023.06.15.09.19.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jun 2023 09:19:16 -0700 (PDT)
From: Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <0ba1bf9c-2e45-cd44-60d3-66feeb3268f3@redhat.com>
Date: Thu, 15 Jun 2023 18:19:15 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Cc: brouer@redhat.com, davem@davemloft.net, kuba@kernel.org,
 pabeni@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 Lorenzo Bianconi <lorenzo@kernel.org>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Eric Dumazet <edumazet@google.com>, Maryam Tahhan <mtahhan@redhat.com>,
 bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH net-next v3 3/4] page_pool: introduce page_pool_alloc()
 API
Content-Language: en-US
To: Alexander Duyck <alexander.duyck@gmail.com>,
 Yunsheng Lin <linyunsheng@huawei.com>
References: <20230609131740.7496-1-linyunsheng@huawei.com>
 <20230609131740.7496-4-linyunsheng@huawei.com>
 <CAKgT0UfVwQ=ri7ZDNnsATH2RQpEz+zDBBb6YprvniMEWGdw+dQ@mail.gmail.com>
 <36366741-8df2-1137-0dd9-d498d0f770e4@huawei.com>
 <CAKgT0UdXTSv1fDHBX4UC6Ok9NXKMJ_9F88CEv5TK+mpzy0N21g@mail.gmail.com>
 <c06f6f59-6c35-4944-8f7a-7f6f0e076649@huawei.com>
 <CAKgT0UccmDe+CE6=zDYQHi1=3vXf5MptzDo+BsPrKdmP5j9kgQ@mail.gmail.com>
In-Reply-To: <CAKgT0UccmDe+CE6=zDYQHi1=3vXf5MptzDo+BsPrKdmP5j9kgQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


On 15/06/2023 16.45, Alexander Duyck wrote:
[..]
> 
> What concerns me is that you seem to be taking the page pool API in a
> direction other than what it was really intended for. For any physical
> device you aren't going to necessarily know what size fragment you are
> working with until you have already allocated the page and DMA has
> been performed. That is why drivers such as the Mellanox driver are
> fragmenting in the driver instead of allocated pre-fragmented pages.
> 

+1

I share concerns with Alexander Duyck here. As the inventor and
maintainer, I can say this is taking the page_pool API in a direction I
didn't intent or planned for. As Alex also says, the intent was for
fixed sized memory chunks that are DMA ready.  Use-case was the physical
device RX "early demux problem", where the size is not known before hand.

I need to be convinced this is a good direction to take the page_pool
design/architecture into... e.g. allocations with dynamic sizes.
Maybe it is a good idea, but as below "consumers" of the API is usually
the way to show this is the case.

[...]
> 
> What I was getting at is that if you are going to add an API you have
> to have a consumer for the API. That is rule #1 for kernel API
> development. You don't add API without a consumer for it. The changes
> you are making are to support some future implementation, and I see it
> breaking most of the existing implementation. That is my concern.
> 

You have mentioned veth as the use-case. I know I acked adding page_pool
use-case to veth, for when we need to convert an SKB into an
xdp_buff/xdp-frame, but maybe it was the wrong hammer(?).
In this case in veth, the size is known at the page allocation time.
Thus, using the page_pool API is wasting memory.  We did this for
performance reasons, but we are not using PP for what is was intended
for.  We mostly use page_pool, because it an existing recycle return
path, and we were too lazy to add another alloc-type (see enum
xdp_mem_type).

Maybe you/we can extend veth to use this dynamic size API, to show us
that this is API is a better approach.  I will signup for benchmarking
this (and coordinating with CC Maryam as she came with use-case we
improved on).

--Jesper


