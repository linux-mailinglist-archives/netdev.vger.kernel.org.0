Return-Path: <netdev+bounces-146-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB7516F570B
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 13:19:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C912281522
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 11:18:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBD11D506;
	Wed,  3 May 2023 11:18:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB98A1870
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 11:18:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 982661B0
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 04:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683112733;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O5KcQFxt1OwjVipvmc6YpAr7EIfZDFTMkByui1W8njA=;
	b=UOLFM/fIbUdOxroY87HhK0IudCIsItx32+XkL7u5TN4qCuQkFxy0raJje51SQAuTWtYujL
	Haxcw8CFliFRD/t7dSvH4ezc5+jFEhoQn2KMYyo8P9aYKl4kPME7CCcQhjLkkLMRc5yP9Z
	uH1pjFQORZ/JDXsjCC5SOdoYVBrrz/w=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-528-UjDt1-dQPBGOnFfn1L5BrQ-1; Wed, 03 May 2023 07:18:51 -0400
X-MC-Unique: UjDt1-dQPBGOnFfn1L5BrQ-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-94f734c6cf8so476149366b.3
        for <netdev@vger.kernel.org>; Wed, 03 May 2023 04:18:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683112730; x=1685704730;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O5KcQFxt1OwjVipvmc6YpAr7EIfZDFTMkByui1W8njA=;
        b=j+G+2NXBMx8s08ymUUCSLApynHiewq1NaXmEPl+ooHdiJYfaGDPCSC/WQvFF12atdW
         ddH4EA/1j5N6SU2sXgj8gpnFj0oxSNnKaN0Qv1j9h2Od835HwWVGyk7dtmsKLRWBmxKU
         PhJkJvmTTH9mulfdqBINISDmP+1FNDyilOCIWD26jIlA6q2Oefh0lmoQowPs0RWHeQ5r
         i1Kny/k6RBoEpqzWvMljtN5c/9SILkYJr/5uEY7YJTHVI8hmv6YcU4W3HTs/4dHsubnC
         FE0oXQUxm8MxdxA30v8vHc08GdZOS7WaRUQHi3XpOPzU4KDrEgLCtB0ztIuqlQsY+IyG
         O0gQ==
X-Gm-Message-State: AC+VfDxg/m2gWVrefGXMC+S1lRRsMgY+Bc3OoV1PwNUX/wRInebqR73N
	QXM90+1yQhcTwmeWJsb9SuOzZcP4nmyKLhjKpj4zD8glgxT6W6PQptMOfqx+VmKvHzudRj9eNlO
	648AVsJEjTQ/viEsx
X-Received: by 2002:a17:907:3205:b0:965:6d21:48bc with SMTP id xg5-20020a170907320500b009656d2148bcmr818754ejb.75.1683112730247;
        Wed, 03 May 2023 04:18:50 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6GAzfkY9LoIBGnjCpEUkjKgp2s37A98qN1w9G1olO5/gt5rwcw+5Pt8NlF11zSV/CThvGVFA==
X-Received: by 2002:a17:907:3205:b0:965:6d21:48bc with SMTP id xg5-20020a170907320500b009656d2148bcmr818701ejb.75.1683112729351;
        Wed, 03 May 2023 04:18:49 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id i10-20020a05640200ca00b0050bd9d3ddf3sm595879edu.42.2023.05.03.04.18.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 04:18:48 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id E64B7AFC7B0; Wed,  3 May 2023 13:18:47 +0200 (CEST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To: Jakub Kicinski <kuba@kernel.org>, Jesper Dangaard Brouer
 <brouer@redhat.com>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>, netdev@vger.kernel.org,
 Eric Dumazet <eric.dumazet@gmail.com>, linux-mm@kvack.org, Mel Gorman
 <mgorman@techsingularity.net>, lorenzo@kernel.org, linyunsheng@huawei.com,
 bpf@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Paolo Abeni
 <pabeni@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
 willy@infradead.org
Subject: Re: [PATCH RFC net-next/mm V3 1/2] page_pool: Remove workqueue in
 new shutdown scheme
In-Reply-To: <20230502193309.382af41e@kernel.org>
References: <168269854650.2191653.8465259808498269815.stgit@firesoul>
 <168269857929.2191653.13267688321246766547.stgit@firesoul>
 <20230502193309.382af41e@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date: Wed, 03 May 2023 13:18:47 +0200
Message-ID: <87ednxbr3c.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Jakub Kicinski <kuba@kernel.org> writes:

> On Fri, 28 Apr 2023 18:16:19 +0200 Jesper Dangaard Brouer wrote:
>> This removes the workqueue scheme that periodically tests when
>> inflight reach zero such that page_pool memory can be freed.
>> 
>> This change adds code to fast-path free checking for a shutdown flags
>> bit after returning PP pages.
>
> We can remove the warning without removing the entire delayed freeing
> scheme. I definitely like the SHUTDOWN flag and patch 2 but I'm a bit
> less clear on why the complexity of datapath freeing is justified.
> Can you explain?

You mean just let the workqueue keep rescheduling itself every minute
for the (potentially) hours that skbs will stick around? Seems a bit
wasteful, doesn't it? :)

We did see an issue where creating and tearing down lots of page pools
in a short period of time caused significant slowdowns due to the
workqueue mechanism. Lots being "thousands per second". This is possible
using the live packet mode of bpf_prog_run() for XDP, which will setup
and destroy a page pool for each syscall...

-Toke


