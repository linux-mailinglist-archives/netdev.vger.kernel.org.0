Return-Path: <netdev+bounces-5675-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A27E712683
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 14:23:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AFD611C21037
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 12:23:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35DB7171BD;
	Fri, 26 May 2023 12:23:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B798156C9
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 12:23:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04440D8
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 05:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685103806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2Bwg3T31bZ+IgI/U7aTrux02yFikGDvD9aeFeEQO12U=;
	b=g5xMl70yxvI+ucCkpiZvnpR2tWF90I8dkoVmC+EqOSHmWetzuQOJ1mIoQMObrX4jMOEsxL
	WlszjTmewf2D5x3JVSiPKJjREzuxHZ24aJj8OK5a2I5m6GhQxcgFHt8OGV330DZImkyQ9X
	UJhBClkeoUkB4cRDl/L/FOLJ85PvxIw=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-630-E1xv5ZHdMGWP6AjjytgrxA-1; Fri, 26 May 2023 08:23:22 -0400
X-MC-Unique: E1xv5ZHdMGWP6AjjytgrxA-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-96f5157aca5so86849666b.0
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 05:23:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685103801; x=1687695801;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2Bwg3T31bZ+IgI/U7aTrux02yFikGDvD9aeFeEQO12U=;
        b=Jw3SZsWS+KQPjBorsMdLx03LAO4m7GbZufGcqSuNpH97RUpMpTBzfhCAkyJwCnDg+2
         7l0yrrbLx4DILRYD+j2laC7StzIu1m0YvwrqDTAiSwTweRZ2HdVbTbYDGff43UxFR5OH
         DMPd6wSl8qbbz4Fw1A66qid800YUwYaW0JeUUZKl5dqMMs2dT65Q+lBhXDOWsbmnQpG3
         EYv4m13KC2QrkTMOIwrrRrCmRod7bZXBw/RU61S8yvk0L9Q+ER/WluFlC/UowUh2E3gS
         ZKYKvcOt8Vtg0/Lsh49QBY0hdvqL/mOOa9sQoXkdVRn6zSFofCklGrCpHRxFp7SsJLjf
         Yozg==
X-Gm-Message-State: AC+VfDwT+X/rPnUS4A+tJt0JbGXYrUu0EjIVFiS4NMpmHKl0ewLwiaIF
	5bPtoa/RvsfyJvDwCarWAt7CE8N5STL5VxfABoBjuDurEH36/LE0vBc38crSBQTif/OLSJt42My
	EdbbLg2lCAimUS/JK
X-Received: by 2002:a17:906:9753:b0:96f:f50b:9b15 with SMTP id o19-20020a170906975300b0096ff50b9b15mr2168453ejy.35.1685103801345;
        Fri, 26 May 2023 05:23:21 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4p68NtoZoWsrla18nN4jigUwF5uKUcnp+Gb5FRHBIJzNJpRjw7/voNOUwf2ky2tlI7n7Dq4Q==
X-Received: by 2002:a17:906:9753:b0:96f:f50b:9b15 with SMTP id o19-20020a170906975300b0096ff50b9b15mr2168425ejy.35.1685103801031;
        Fri, 26 May 2023 05:23:21 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-25-16.business.telecomitalia.it. [87.12.25.16])
        by smtp.gmail.com with ESMTPSA id lz13-20020a170906fb0d00b0094f67ea6598sm2096292ejb.193.2023.05.26.05.23.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 05:23:20 -0700 (PDT)
Date: Fri, 26 May 2023 14:23:18 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Arseniy Krasnov <avkrasnov@sberdevices.ru>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Bobby Eshleman <bobby.eshleman@bytedance.com>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel@sberdevices.ru, 
	oxffffaa@gmail.com
Subject: Re: [RFC PATCH v3 00/17] vsock: MSG_ZEROCOPY flag support
Message-ID: <sdm43ibxqzdylwxaai4mjj2ucqpduc74ucyg3yrn75dxu2kix5@jynppv7kxyjz>
References: <20230522073950.3574171-1-AVKrasnov@sberdevices.ru>
 <76270fab-8af7-7597-9193-64cb553a543e@sberdevices.ru>
 <y5tgyj5awrd4hvlrsxsvrern6pd2sby2mdtskah2qp5hemmo2a@72nhcpilg7v2>
 <4baf786b-afe5-371d-9bc4-90226e5df3af@sberdevices.ru>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <4baf786b-afe5-371d-9bc4-90226e5df3af@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 02:36:17PM +0300, Arseniy Krasnov wrote:
>
>
>On 26.05.2023 13:30, Stefano Garzarella wrote:
>> On Thu, May 25, 2023 at 06:56:42PM +0300, Arseniy Krasnov wrote:
>>>
>>>
>>> On 22.05.2023 10:39, Arseniy Krasnov wrote:
>>>
>>> This patchset is unstable with SOCK_SEQPACKET. I'll fix it.
>>
>> Thanks for let us know!
>>
>> I'm thinking if we should start split this series in two, because it
>> becomes too big.
>>
>> But let keep this for RFC, we can decide later. An idea is to send
>> the first 7 patches with a preparation series, and the next ones with a
>> second series.
>
>Hello, ok! So i'll split patchset in the following way:
>1) Patches which adds new fields/flags and checks. But all of this is not used,
>   as it is preparation.
>2) Second part starts to use it and also carries tests.

As long as they're RFCs, maybe you can keep them together if they're
related, possibly specifying in the cover letter where you'd like to
split them. When we agree that we are in good shape, we can split it.

Thanks,
Stefano


