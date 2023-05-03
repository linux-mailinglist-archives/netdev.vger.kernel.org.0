Return-Path: <netdev+bounces-184-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31E0B6F5B7F
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 17:49:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 527DE28169A
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 15:49:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 872BE107B9;
	Wed,  3 May 2023 15:49:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE86D523
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 15:49:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA6E66EB3
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 08:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683128979;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O4VP89Zv90qrgsob/vJ4a462qWannnDrJro4rCmwa5M=;
	b=Sln4Meck3wZl9xDXzZjqNARUMKjAMEV1n3snFP+qEtLlUBXtYABCtKk89yQF4W3gM1XQxM
	PQw4XppS5BS4WzdekMB4+DUu/fRhBVUQeimkq2/R5fBVIXUwG9uuAT8XjlMtI+jPk/wYLO
	h+2i+b3tO/jgxQOC8t4vACZERG+4ilA=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-451-ouy9KP5vMWuIxd5VAj9Xug-1; Wed, 03 May 2023 11:49:38 -0400
X-MC-Unique: ouy9KP5vMWuIxd5VAj9Xug-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-9532170e7d3so518401466b.0
        for <netdev@vger.kernel.org>; Wed, 03 May 2023 08:49:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683128977; x=1685720977;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O4VP89Zv90qrgsob/vJ4a462qWannnDrJro4rCmwa5M=;
        b=LxsBiZ2K2n/PyA4eLBLQVzLe6vwILJWyNIAe0nX+g27CakEqUMv4pyhK0A106F0ZvL
         /OprdpH/22PGiBEq2PjKWBjMxsBSKF7C30MAJMsnibrhhLV/lobQGFTIUhBKZ9EG9Z3k
         3r3joUNUfN0bDXE1S3siNBsUiDBSJLTp2z45vNBskv1szhp2Jc/kAhpFGXelbdP5A3BE
         flB78oFK+gG9wf7t8rSoOV1o7uoHBRUJwDUQqEWIuIH2TbJez1/IMAteVuZUOy4ITau9
         PgwyKSAs+YfQTxaaSNWvhfO2mPeTMZS8f2UC5hCDn4O8VDc5MVyb0hOYp+ebmAFh+klv
         khvw==
X-Gm-Message-State: AC+VfDwkA/wYnVEo6307G+5YXPOV93FBcdjht3OAP0YhJuhSdUVx1ES+
	Eh+iHG1j94QHJUnHI/MwxqhHbxxlfQq7rTVVeHJuTwNjWpBaYeV8JrAxqZOYegwFUjqNGhi/rDY
	JL2o/e19gOQ5+XcQ7
X-Received: by 2002:a17:907:c21:b0:933:3814:e0f4 with SMTP id ga33-20020a1709070c2100b009333814e0f4mr4712170ejc.16.1683128977012;
        Wed, 03 May 2023 08:49:37 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6e5zv7cZWE/jkHWJTvri6PxUa3jx686lEP7V5PP9ooaEOwZDZGGsjXhQil4vBJmqj+KSXbvg==
X-Received: by 2002:a17:907:c21:b0:933:3814:e0f4 with SMTP id ga33-20020a1709070c2100b009333814e0f4mr4712134ejc.16.1683128976703;
        Wed, 03 May 2023 08:49:36 -0700 (PDT)
Received: from [192.168.42.222] (cgn-cgn9-185-107-14-3.static.kviknet.net. [185.107.14.3])
        by smtp.gmail.com with ESMTPSA id th7-20020a1709078e0700b009596e7e0dbasm13598187ejc.162.2023.05.03.08.49.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 May 2023 08:49:36 -0700 (PDT)
From: Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <3a5a28c4-01a3-793c-6969-475aba3ff3b5@redhat.com>
Date: Wed, 3 May 2023 17:49:34 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Cc: brouer@redhat.com, Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
 linux-mm@kvack.org, Mel Gorman <mgorman@techsingularity.net>,
 lorenzo@kernel.org, linyunsheng@huawei.com, bpf@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org
Subject: Re: [PATCH RFC net-next/mm V3 1/2] page_pool: Remove workqueue in new
 shutdown scheme
Content-Language: en-US
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
 Jakub Kicinski <kuba@kernel.org>
References: <168269854650.2191653.8465259808498269815.stgit@firesoul>
 <168269857929.2191653.13267688321246766547.stgit@firesoul>
 <20230502193309.382af41e@kernel.org> <87ednxbr3c.fsf@toke.dk>
In-Reply-To: <87ednxbr3c.fsf@toke.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 03/05/2023 13.18, Toke Høiland-Jørgensen wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
> 
>> On Fri, 28 Apr 2023 18:16:19 +0200 Jesper Dangaard Brouer wrote:
>>> This removes the workqueue scheme that periodically tests when
>>> inflight reach zero such that page_pool memory can be freed.
>>>
>>> This change adds code to fast-path free checking for a shutdown flags
>>> bit after returning PP pages.
>>
>> We can remove the warning without removing the entire delayed freeing
>> scheme. I definitely like the SHUTDOWN flag and patch 2 but I'm a bit
>> less clear on why the complexity of datapath freeing is justified.
>> Can you explain?
> 
> You mean just let the workqueue keep rescheduling itself every minute
> for the (potentially) hours that skbs will stick around? Seems a bit
> wasteful, doesn't it? :)

I agree that this workqueue that keeps rescheduling is wasteful.
It actually reschedules every second, even more wasteful.
NIC drivers will have many HW RX-queues, with separate PP instances, 
that each can start a workqueue that resched every sec.

Eric have convinced me that SKBs can "stick around" for longer than the
assumptions in PP.  The old PP assumptions came from XDP-return path.
It is time to cleanup.

> 
> We did see an issue where creating and tearing down lots of page pools
> in a short period of time caused significant slowdowns due to the
> workqueue mechanism. Lots being "thousands per second". This is possible
> using the live packet mode of bpf_prog_run() for XDP, which will setup
> and destroy a page pool for each syscall...

Yes, the XDP live packet mode of bpf_prog_run is IMHO abusing the
page_pool API.  We should fix that somehow, at least the case where live
packet mode is only injecting a single packet, but still creates a PP
instance. The PP in live packet mode IMHO only makes sense when
repeatedly sending packets that gets recycles and are pre-inited by PP.

This use of PP does exemplify why is it problematic to keep the workqueue.

I have considered (and could be convinced) delaying the free via
call_rcu, but it also create an unfortunate backlog of work in the case
of live packet mode of bpf_prog_run.

--Jesper


