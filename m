Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 305DC61FE69
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 20:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232217AbiKGTPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 14:15:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231846AbiKGTO7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 14:14:59 -0500
Received: from new4-smtp.messagingengine.com (new4-smtp.messagingengine.com [66.111.4.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA5702793E;
        Mon,  7 Nov 2022 11:14:57 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id C830D58037F;
        Mon,  7 Nov 2022 14:14:55 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 07 Nov 2022 14:14:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=devkernel.io; h=
        cc:cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1667848495; x=1667852095; bh=YZpEq+0O77
        Abl1TBni6p7v76zFG4z1xLXaG8LusV8uE=; b=SycPB/Wf+xSV8WaLxpJyZgWEyR
        TypW2XHtAqulvxgvFvqWwRNJO5HrEDvWHrQgCfki8dfWFuWbxc/HeterM/REcKNG
        /FwTF1f+6TKzqyV6LCwGBXcR7yI1LG1Y01Fp6ULCl4ZXJ5VXj3OtsrD0ZUFGe0Wo
        8weyMuvERA2RwCBWq6+rStT3yjPfOXdkMoRFQQLoiOMfmKznM3wBbJIXQPTWBAGV
        soW6ZIc2F0AxOJgtNTBzWYKYobhimi33g36DLPnFgkcB3gFd3098TZnY8z7TxlDq
        /OpAj2Zqoo+acNJWGfDbmGw4d57TsusheK+ehpYar4mukAGq69x5IH7Hem2g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1667848495; x=1667852095; bh=YZpEq+0O77Abl1TBni6p7v76zFG4
        z1xLXaG8LusV8uE=; b=k0t3x8rKy0a+Q27xKoI6lm1CI/5JLrGZti3eLKEg1KWu
        bZ9MoIkqjUysDWNSc6/UdusV9fXlWpl1KULwT6uzFsR0gkWuUJIrexXVdsmVJ3gX
        9+v00welLjF8J7EHbKWakvAMZFCZHeuBEeXRmM0KUDdjmlbZxIQYjGWxxfOrUPwK
        Zu8wZ3SjNE5HJxJSKzYsoZsln6NQt5i9a1hZDUywPvImN7zSbIqtDIHdyhK9XN+A
        OGowS9MiHCiW9OOgFB87frX8qjSIozocd0YaQ0tkmvokUQPW4wcM5Oh7zzuOxSt3
        U/5bY76lNW1ij2yIQ5v8C3/vSlGVYqnHYGm4m216vQ==
X-ME-Sender: <xms:L1lpY7M0H-VooPjHddLHNTO1kKB9E6FFkF_sUWTTYxYXTqPZik_EsQ>
    <xme:L1lpY19enK55qTK9ObXcf4Fcr7AIPYg2onCvT19M8gsIyJYdvELwC9pw6bP40T9g3
    W_d9x9amiIh2sabFy0>
X-ME-Received: <xmr:L1lpY6TgUS4EjSXl0_tTUK-nKJTrw9Bypn211LP3JLxRNY7sRV0rw2pOAOuznXGHVwtrxa-a-709FEmvNvfgoaIR6yReiPVvFF9a3_iC_A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrvdekgdduvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfhgfhffvvefuffgjkfggtgesthdtofdttdertdenucfhrhhomhepufhtvghf
    rghnucftohgvshgthhcuoehshhhrseguvghvkhgvrhhnvghlrdhioheqnecuggftrfgrth
    htvghrnhepfeeludefhfegvdffieeuhfdvudetvdetfefgieegffduhfegffeuudevkeei
    uedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsh
    hhrhesuggvvhhkvghrnhgvlhdrihho
X-ME-Proxy: <xmx:L1lpY_tpw9wnE_v6wlWwnaPA3439MPaKeB1FglzJ8AgVX1aQugZVAA>
    <xmx:L1lpYzdmEyprW4dARmuZJ_mpAf_qU6rS7L6E5gN8u1khMvM8j3u1kA>
    <xmx:L1lpY72LssW3aREHI3ThQa6lfPRXC7U9VM2fiPybTYJTln2g6Dib1Q>
    <xmx:L1lpY0GqAhiRZVDQjEGfLmNMl_HYSLh3d9SMbp2KEScClXcThPxrlA>
Feedback-ID: i84614614:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 7 Nov 2022 14:14:54 -0500 (EST)
References: <20221107175240.2725952-1-shr@devkernel.io>
 <20221107175240.2725952-2-shr@devkernel.io>
 <0099021f-9185-69c1-3e63-64afdba988cf@gmail.com>
User-agent: mu4e 1.6.11; emacs 28.2.50
From:   Stefan Roesch <shr@devkernel.io>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     kernel-team@fb.com, axboe@kernel.dk, olivier@trillion01.com,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org
Subject: Re: [RFC PATCH v2 1/2] io_uring: add napi busy polling support
Date:   Mon, 07 Nov 2022 11:08:48 -0800
In-reply-to: <0099021f-9185-69c1-3e63-64afdba988cf@gmail.com>
Message-ID: <qvqwsfiulgpk.fsf@dev0134.prn3.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,URIBL_BLACK autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Eric Dumazet <eric.dumazet@gmail.com> writes:

> On 11/7/22 09:52, Stefan Roesch wrote:
>> This adds the napi busy polling support in io_uring.c. It adds a new
>> napi_list to the io_ring_ctx structure. This list contains the list of
>> napi_id's that are currently enabled for busy polling. The list is
>> synchronized by the new napi_lock spin lock. The current default napi
>> busy polling time is stored in napi_busy_poll_to. If napi busy polling
>> is not enabled, the value is 0.
>>
>> The busy poll timeout is also stored as part of the io_wait_queue. This
>> is necessary as for sq polling the poll interval needs to be adjusted
>> and the napi callback allows only to pass in one value.
>>
>> Testing has shown that the round-trip times are reduced to 38us from
>> 55us by enabling napi busy polling with a busy poll timeout of 100us.
>>
>> Signed-off-by: Stefan Roesch <shr@devkernel.io>
>> Suggested-by: Olivier Langlois <olivier@trillion01.com>
>> ---
>>   include/linux/io_uring_types.h |   6 +
>>   io_uring/io_uring.c            | 240 +++++++++++++++++++++++++++++++++
>>   io_uring/napi.h                |  22 +++
>>   io_uring/poll.c                |   3 +
>>   io_uring/sqpoll.c              |   9 ++
>>   5 files changed, 280 insertions(+)
>>   create mode 100644 io_uring/napi.h
>>
>> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>> index f5b687a787a3..84b446b0d215 100644
>> --- a/include/linux/io_uring_types.h
>> +++ b/include/linux/io_uring_types.h
>> @@ -270,6 +270,12 @@ struct io_ring_ctx {
>>   	struct xarray		personalities;
>>   	u32			pers_next;
>>   +#ifdef CONFIG_NET_RX_BUSY_POLL
>> +	struct list_head	napi_list;	/* track busy poll napi_id */
>> +	spinlock_t		napi_lock;	/* napi_list lock */
>> +	unsigned int		napi_busy_poll_to; /* napi busy poll default timeout */
>> +#endif
>> +
>>   	struct {
>>   		/*
>>   		 * We cache a range of free CQEs we can use, once exhausted it
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index ac8c488e3077..b02bba4ebcbf 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -90,6 +90,7 @@
>>   #include "rsrc.h"
>>   #include "cancel.h"
>>   #include "net.h"
>> +#include "napi.h"
>>   #include "notif.h"
>>     #include "timeout.h"
>> @@ -327,6 +328,13 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
>>   	INIT_WQ_LIST(&ctx->locked_free_list);
>>   	INIT_DELAYED_WORK(&ctx->fallback_work, io_fallback_req_func);
>>   	INIT_WQ_LIST(&ctx->submit_state.compl_reqs);
>> +
>> +#ifdef CONFIG_NET_RX_BUSY_POLL
>> +	INIT_LIST_HEAD(&ctx->napi_list);
>> +	spin_lock_init(&ctx->napi_lock);
>> +	ctx->napi_busy_poll_to = READ_ONCE(sysctl_net_busy_poll);
>> +#endif
>> +
>>   	return ctx;
>>   err:
>>   	kfree(ctx->dummy_ubuf);
>> @@ -2303,6 +2311,10 @@ struct io_wait_queue {
>>   	struct io_ring_ctx *ctx;
>>   	unsigned cq_tail;
>>   	unsigned nr_timeouts;
>> +
>> +#ifdef CONFIG_NET_RX_BUSY_POLL
>> +	unsigned int busy_poll_to;
>> +#endif
>>   };
>>     static inline bool io_has_work(struct io_ring_ctx *ctx)
>> @@ -2376,6 +2388,198 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
>>   	return 1;
>>   }
>>   +#ifdef CONFIG_NET_RX_BUSY_POLL
>> +#define NAPI_TIMEOUT		(60 * SEC_CONVERSION)
>> +
>> +struct io_napi_entry {
>> +	struct list_head	list;
>> +	unsigned int		napi_id;
>> +	unsigned long		timeout;
>> +};
>> +
>> +static bool io_napi_busy_loop_on(struct io_ring_ctx *ctx)
>> +{
>> +	return READ_ONCE(ctx->napi_busy_poll_to);
>> +}
>> +
>> +/*
>> + * io_napi_add() - Add napi id to the busy poll list
>> + * @file: file pointer for socket
>> + * @ctx:  io-uring context
>> + *
>> + * Add the napi id of the socket to the napi busy poll list.
>> + */
>> +void io_napi_add(struct file *file, struct io_ring_ctx *ctx)
>> +{
>> +	unsigned int napi_id;
>> +	struct socket *sock;
>> +	struct sock *sk;
>> +	struct io_napi_entry *ne;
>> +
>> +	if (!io_napi_busy_loop_on(ctx))
>> +		return;
>> +
>> +	sock = sock_from_file(file);
>> +	if (!sock)
>> +		return;
>> +
>> +	sk = sock->sk;
>> +	if (!sk)
>> +		return;
>> +
>> +	napi_id = READ_ONCE(sk->sk_napi_id);
>> +
>> +	/* Non-NAPI IDs can be rejected */
>> +	if (napi_id < MIN_NAPI_ID)
>> +		return;
>> +
>> +	spin_lock(&ctx->napi_lock);
>> +	list_for_each_entry(ne, &ctx->napi_list, list) {
>> +		if (ne->napi_id == napi_id) {
>> +			ne->timeout = jiffies + NAPI_TIMEOUT;
>> +			goto out;
>> +		}
>
> This list could become very big, if you do not remove stale napi_id from it.
>
> Device reconfiguration do not recycle napi_id, it creates new ones.
>
>

The timeout is specified by NAPI_TIMEOUT (which is likely too high). The
timeout of an entry is checked in io_napi_check_entry_timeout and might
get deleted if the timeout expired. This function is called from the
busy loop functions.

Are you referring to the fact that the timeout is too high or that device
reconfiguration needs to make changes to the napi list.

>> +	}
>> +
>> +	ne = kmalloc(sizeof(*ne), GFP_NOWAIT);
>> +	if (!ne)
>> +		goto out;
>> +
>> +	ne->napi_id = napi_id;
>> +	ne->timeout = jiffies + NAPI_TIMEOUT;
>> +	list_add_tail(&ne->list, &ctx->napi_list);
>> +
>> +out:
>> +	spin_unlock(&ctx->napi_lock);
>> +}
>> +
>> +
