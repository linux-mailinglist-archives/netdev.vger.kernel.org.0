Return-Path: <netdev+bounces-166-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 020986F5944
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 15:48:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6127281598
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 13:48:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8938ED539;
	Wed,  3 May 2023 13:48:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7396F9479
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 13:48:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E68F59F2
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 06:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683121678;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ie41DSOUJAU9sN0ZbQyLZdZyXhPxd7Tk89Rx+HAMiRc=;
	b=c3dvYglSYz1RTANnHSY8UbKhB1fUeisnTlOdUopxcZPA+7zpUO6KvkpSN2KPQ+/yB5gW6g
	ohwjuvc+iSEZJrK5eQxlJeQgP8DLInhwd99J690nJ4N3C/LABYOSnfK2KyMzDlpWa9RNiK
	iEOb9sEJc9O4wOqF7OJ9QrBrvNujWXU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-553-_6633N8dOWuZ8e2TGLxnaQ-1; Wed, 03 May 2023 09:47:57 -0400
X-MC-Unique: _6633N8dOWuZ8e2TGLxnaQ-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-30633990a69so960677f8f.3
        for <netdev@vger.kernel.org>; Wed, 03 May 2023 06:47:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683121676; x=1685713676;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ie41DSOUJAU9sN0ZbQyLZdZyXhPxd7Tk89Rx+HAMiRc=;
        b=j8/Hu/5PQS/ZUD7X2+mjcRZyOwy1eTzkEXmIV35YM2Fcqu0MuQ+UCD0X9pB69CB8+l
         aj0EWO27JRu3s9MPyOAoDeZsWzuc5HBbSLFvtjb8gLZ5GCqTrsSDmGuRkUx1zQC00AjG
         leSa12XVhUDx3DgP4BemeEyduSfmyrqpkibQuc61rTRQSWynx8O0XODSFu40sBYaEyLd
         lTW5lv7HdKy2sooEYgQAODxh1rG9dnllMJNr2gXJxiHDCUIN80B6910bqYy7OgfmN6aP
         qGULL3khxooVrnp8XwtZwjoF9cizcZbAhmbT2T5aHxN+4W4v1mEcWRj8ND7H9cEIzY48
         O0tA==
X-Gm-Message-State: AC+VfDxaADfiUWSnD/BxLbwEWFw6CG1XJr94nZ0FjpdCXmdKdjlat5cd
	XuhoNhMImbxKStmn4bfP44weaWbMSPe8ionveQA05J/RyghPMSpjLl7+vv9YDYPN3dvXGxzd4Mk
	dP4ajYeIH0CNibVPi
X-Received: by 2002:adf:f785:0:b0:306:36e7:db27 with SMTP id q5-20020adff785000000b0030636e7db27mr134484wrp.16.1683121676562;
        Wed, 03 May 2023 06:47:56 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6cZH0F+HvzDAV395wIYuXVRV3XvIp16M0hpF34ErYZx+dia96NntoSQ7QRSdTpZboHIQzbpQ==
X-Received: by 2002:adf:f785:0:b0:306:36e7:db27 with SMTP id q5-20020adff785000000b0030636e7db27mr134471wrp.16.1683121676209;
        Wed, 03 May 2023 06:47:56 -0700 (PDT)
Received: from sgarzare-redhat ([185.29.96.107])
        by smtp.gmail.com with ESMTPSA id a13-20020a056000100d00b003063c130ef1sm2966147wrx.112.2023.05.03.06.47.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 06:47:55 -0700 (PDT)
Date: Wed, 3 May 2023 15:47:51 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Arseniy Krasnov <avkrasnov@sberdevices.ru>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Bobby Eshleman <bobby.eshleman@bytedance.com>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel@sberdevices.ru, 
	oxffffaa@gmail.com
Subject: Re: [RFC PATCH v2 00/15] vsock: MSG_ZEROCOPY flag support
Message-ID: <23guh3txkghxpgcrcjx7h62qsoj3xgjhfzgtbmqp2slrz3rxr4@zya2z7kwt75l>
References: <20230423192643.1537470-1-AVKrasnov@sberdevices.ru>
 <i6swadylt57hrtxhpl5ag7s3dks536wg3vxoa7nuu2x37gxsbi@uj7od5ueq6yp>
 <a9ee9ef5-e707-65ff-3128-41d09fbe8655@sberdevices.ru>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a9ee9ef5-e707-65ff-3128-41d09fbe8655@sberdevices.ru>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 03, 2023 at 04:11:59PM +0300, Arseniy Krasnov wrote:
>
>
>On 03.05.2023 15:52, Stefano Garzarella wrote:
>> Hi Arseniy,
>> Sorry for the delay, but I have been very busy.
>
>Hello, no problem!
>
>>
>> I can't apply this series on master or net-next, can you share with me
>> the base commit?
>
>Here is my base:
>https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=b103bab0944be030954e5de23851b37980218f54
>

Thanks, it worked!

>>
>> On Sun, Apr 23, 2023 at 10:26:28PM +0300, Arseniy Krasnov wrote:
>>> Hello,
>>>
>>>                           DESCRIPTION
>>>
>>> this is MSG_ZEROCOPY feature support for virtio/vsock. I tried to follow
>>> current implementation for TCP as much as possible:
>>>
>>> 1) Sender must enable SO_ZEROCOPY flag to use this feature. Without this
>>>   flag, data will be sent in "classic" copy manner and MSG_ZEROCOPY
>>>   flag will be ignored (e.g. without completion).
>>>
>>> 2) Kernel uses completions from socket's error queue. Single completion
>>>   for single tx syscall (or it can merge several completions to single
>>>   one). I used already implemented logic for MSG_ZEROCOPY support:
>>>   'msg_zerocopy_realloc()' etc.
>>>
>>> Difference with copy way is not significant. During packet allocation,
>>> non-linear skb is created, then I call 'pin_user_pages()' for each page
>>> from user's iov iterator and add each returned page to the skb as fragment.
>>> There are also some updates for vhost and guest parts of transport - in
>>> both cases i've added handling of non-linear skb for virtio part. vhost
>>> copies data from such skb to the guest's rx virtio buffers. In the guest,
>>> virtio transport fills tx virtio queue with pages from skb.
>>>
>>> This version has several limits/problems:
>>>
>>> 1) As this feature totally depends on transport, there is no way (or it
>>>   is difficult) to check whether transport is able to handle it or not
>>>   during SO_ZEROCOPY setting. Seems I need to call AF_VSOCK specific
>>>   setsockopt callback from setsockopt callback for SOL_SOCKET, but this
>>>   leads to lock problem, because both AF_VSOCK and SOL_SOCKET callback
>>>   are not considered to be called from each other. So in current version
>>>   SO_ZEROCOPY is set successfully to any type (e.g. transport) of
>>>   AF_VSOCK socket, but if transport does not support MSG_ZEROCOPY,
>>>   tx routine will fail with EOPNOTSUPP.
>>
>> Do you plan to fix this in the next versions?
>>
>> If it is too complicated, I think we can have this limitation until we
>> find a good solution.
>>
>
>I'll try to fix it again, but just didn't pay attention on it in v2.
>
>>>
>>> 2) When MSG_ZEROCOPY is used, for each tx system call we need to enqueue
>>>   one completion. In each completion there is flag which shows how tx
>>>   was performed: zerocopy or copy. This leads that whole message must
>>>   be send in zerocopy or copy way - we can't send part of message with
>>>   copying and rest of message with zerocopy mode (or vice versa). Now,
>>>   we need to account vsock credit logic, e.g. we can't send whole data
>>>   once - only allowed number of bytes could sent at any moment. In case
>>>   of copying way there is no problem as in worst case we can send single
>>>   bytes, but zerocopy is more complex because smallest transmission
>>>   unit is single page. So if there is not enough space at peer's side
>>>   to send integer number of pages (at least one) - we will wait, thus
>>>   stalling tx side. To overcome this problem i've added simple rule -
>>>   zerocopy is possible only when there is enough space at another side
>>>   for whole message (to check, that current 'msghdr' was already used
>>>   in previous tx iterations i use 'iov_offset' field of it's iov iter).
>>
>> So, IIUC if MSG_ZEROCOPY is set, but there isn't enough space in the
>> destination we temporarily disable zerocopy, also if MSG_ZEROCOPY is set.
>> Right?
>
>Exactly, user still needs to get completion (because SO_ZEROCOPY is enabled and
>MSG_ZEROCOPY flag as used). But completion structure contains information that
>there was copying instead of zerocopying.

Got it.

>
>>
>> If it is the case it seems reasonable to me.
>>
>>>
>>> 3) loopback transport is not supported, because it requires to implement
>>>   non-linear skb handling in dequeue logic (as we "send" fragged skb
>>>   and "receive" it from the same queue). I'm going to implement it in
>>>   next versions.
>>>
>>>   ^^^ fixed in v2
>>>
>>> 4) Current implementation sets max length of packet to 64KB. IIUC this
>>>   is due to 'kmalloc()' allocated data buffers. I think, in case of
>>>   MSG_ZEROCOPY this value could be increased, because 'kmalloc()' is
>>>   not touched for data - user space pages are used as buffers. Also
>>>   this limit trims every message which is > 64KB, thus such messages
>>>   will be send in copy mode due to 'iov_offset' check in 2).
>>>
>>>   ^^^ fixed in v2
>>>
>>>                         PATCHSET STRUCTURE
>>>
>>> Patchset has the following structure:
>>> 1) Handle non-linear skbuff on receive in virtio/vhost.
>>> 2) Handle non-linear skbuff on send in virtio/vhost.
>>> 3) Updates for AF_VSOCK.
>>> 4) Enable MSG_ZEROCOPY support on transports.
>>> 5) Tests/tools/docs updates.
>>>
>>>                            PERFORMANCE
>>>
>>> Performance: it is a little bit tricky to compare performance between
>>> copy and zerocopy transmissions. In zerocopy way we need to wait when
>>> user buffers will be released by kernel, so it something like synchronous
>>> path (wait until device driver will process it), while in copy way we
>>> can feed data to kernel as many as we want, don't care about device
>>> driver. So I compared only time which we spend in the 'send()' syscall.
>>> Then if this value will be combined with total number of transmitted
>>> bytes, we can get Gbit/s parameter. Also to avoid tx stalls due to not
>>> enough credit, receiver allocates same amount of space as sender needs.
>>>
>>> Sender:
>>> ./vsock_perf --sender <CID> --buf-size <buf size> --bytes 256M [--zc]
>>>
>>> Receiver:
>>> ./vsock_perf --vsk-size 256M
>>>
>>> G2H transmission (values are Gbit/s):
>>>
>>> *-------------------------------*
>>> |          |         |          |
>>> | buf size |   copy  | zerocopy |
>>> |          |         |          |
>>> *-------------------------------*
>>> |   4KB    |    3    |    10    |
>>> *-------------------------------*
>>> |   32KB   |    9    |    45    |
>>> *-------------------------------*
>>> |   256KB  |    24   |    195   |
>>> *-------------------------------*
>>> |    1M    |    27   |    270   |
>>> *-------------------------------*
>>> |    8M    |    22   |    277   |
>>> *-------------------------------*
>>>
>>> H2G:
>>>
>>> *-------------------------------*
>>> |          |         |          |
>>> | buf size |   copy  | zerocopy |
>>> |          |         |          |
>>> *-------------------------------*
>>> |   4KB    |    17   |    11    |
>>
>> Do you know why in this case zerocopy is slower in this case?
>> Could be the cost of pin/unpin pages?
>May be, i think i need to analyze such enormous difference more. Also about
>pin/unpin: i found that there is already implemented function to fill non-linear
>skb with pages from user's iov: __zerocopy_sg_from_iter() in net/core/datagram.c.
>It uses 'get_user_pages()' instead of 'pin_user_pages()'. May be in my case it
>is also valid to user 'get_XXX()' instead of 'pin_XXX()', because it is used by
>TCP MSG_ZEROCOPY and iouring MSG_ZEROCOPY.

If we can reuse them, it will be great!

>
>>
>>> *-------------------------------*
>>> |   32KB   |    30   |    66    |
>>> *-------------------------------*
>>> |   256KB  |    38   |    179   |
>>> *-------------------------------*
>>> |    1M    |    38   |    234   |
>>> *-------------------------------*
>>> |    8M    |    28   |    279   |
>>> *-------------------------------*
>>>
>>> Loopback:
>>>
>>> *-------------------------------*
>>> |          |         |          |
>>> | buf size |   copy  | zerocopy |
>>> |          |         |          |
>>> *-------------------------------*
>>> |   4KB    |    8    |    7     |
>>> *-------------------------------*
>>> |   32KB   |    34   |    42    |
>>> *-------------------------------*
>>> |   256KB  |    43   |    83    |
>>> *-------------------------------*
>>> |    1M    |    40   |    109   |
>>> *-------------------------------*
>>> |    8M    |    40   |    171   |
>>> *-------------------------------*
>>>
>>> I suppose that huge difference above between both modes has two reasons:
>>> 1) We don't need to copy data.
>>> 2) We don't need to allocate buffer for data, only for header.
>>>
>>> Zerocopy is faster than classic copy mode, but of course it requires
>>> specific architecture of application due to user pages pinning, buffer
>>> size and alignment.
>>>
>>> If host fails to send data with "Cannot allocate memory", check value
>>> /proc/sys/net/core/optmem_max - it is accounted during completion skb
>>> allocation.
>>
>> What the user needs to do? Increase it?
>>
>Yes, i'll update it.
>>>
>>>                            TESTING
>>>
>>> This patchset includes set of tests for MSG_ZEROCOPY feature. I tried to
>>> cover new code as much as possible so there are different cases for
>>> MSG_ZEROCOPY transmissions: with disabled SO_ZEROCOPY and several io
>>> vector types (different sizes, alignments, with unmapped pages). I also
>>> run tests with loopback transport and running vsockmon.
>>
>> Thanks for the test again :-)
>>
>> This cover letter is very good, with a lot of details, but please add
>> more details in each single patch, explaining the reason of the changes,
>> otherwise it is very difficult to review, because it is a very big
>> change.
>>
>> I'll do a per-patch review in the next days.
>
>Sure, thanks! In v3 i'm also working on io_uring test, because this thing also
>supports MSG_ZEROCOPY, so we can do virtio/vsock + MSG_ZEROCOPY + io_uring.

That would be cool!

Do you want to me to review these patches or it is better to wait for 
v3?

Thanks,
Stefano


