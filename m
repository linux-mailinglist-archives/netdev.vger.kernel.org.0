Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 584D960742C
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 11:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiJUJgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 05:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiJUJgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 05:36:44 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1C4213479;
        Fri, 21 Oct 2022 02:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=6w2D4vQYyKhn28KDMzAPYWaU9B06/h8S8ogedWCQlYU=; b=VxF+9Hu3Vdi56ldk+SJpaCqSHC
        V4tEgDSuOue3mvRlsrNNmYMycgfDaG+zvV7P3SzRxgeAx7bPFBfICQefhaNBKBkBYdPG36ySxA51E
        nRkkblHe4gkwO4xPJcwNh/jGoINYTfdCBazl7Q8eiBBjNUkbx9Dr+HeZGwtiwTX1pXoKE7VeglQer
        je8Hw9aN2l0oRbg6LRdpSubl9wWJsuptu/foZ08WMl++VHrGubyed5p+noZV/OQovsAqrAXh9vPhE
        5exrG/ptdH8JOCgeSihoRw5p53jKZ5rBAZLNLM7KvtVnjfR8GryJ3Wxj3LchTcLGUTa2rahze8dVz
        f15XO0jjucUK/AqnfvdIav6mTGftgsSpWY+9m3iV9xjmbvKzNt4NBFZpEshKuVM4hTUfTbah0rhl2
        kMyAmFPi0O1ibW/f5XuQPHacxSDv3PI2wzLgNebOWIIx+IVRrZojRQzlrVmnU5dHtBYZcCzXDBSXF
        fJdTNHE7fC97+ig02Dy+XHFb;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oloSE-0058hc-NF; Fri, 21 Oct 2022 09:36:38 +0000
Message-ID: <3e56c92b-567c-7bb4-2644-dc1ad1d8c3ae@samba.org>
Date:   Fri, 21 Oct 2022 11:36:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Content-Language: en-US, de-DE
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        Dylan Yudaken <dylany@fb.com>
References: <4385ba84-55dd-6b08-0ca7-6b4a43f9d9a2@samba.org>
 <6f0a9137-2d2b-7294-f59f-0fcf9cdfc72d@gmail.com>
 <4bbf6bc1-ee4b-8758-7860-a06f57f35d14@samba.org>
 <cd87b6d0-a6d6-8f24-1af4-4b8845aa669c@gmail.com>
 <df47dbd0-75e4-5f39-58ad-ec28e50d0b9c@samba.org>
 <fb6a7599-8a9b-15e5-9b64-6cd9d01c6ff4@gmail.com>
 <acad81e4-c2ef-59cc-5f0c-33b99082d270@samba.org>
 <d05e9a24-c02b-5f0d-e206-9053a786179e@gmail.com>
 <e87610a6-27a6-6175-1c66-a8dcdc4c14cb@samba.org>
 <c7505b91-16c3-8f83-9782-a520e8b0f484@gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: IORING_SEND_NOTIF_REPORT_USAGE (was Re: IORING_CQE_F_COPIED)
In-Reply-To: <c7505b91-16c3-8f83-9782-a520e8b0f484@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pavel,

>>>> So far I came up with a IORING_SEND_NOTIF_REPORT_USAGE opt-in flag
>>>> and the reporting is done in cqe.res with IORING_NOTIF_USAGE_ZC_USED (0x00000001)
>>>> and/or IORING_NOTIF_USAGE_ZC_COPIED (0x8000000). So the caller is also
>>>> able to notice that some parts were able to use zero copy, while other
>>>> fragments were copied.
>>>
>>> Are we really interested in multihoming and probably some very edge cases?
>>> I'd argue we're not and it should be a single bool hint indicating whether
>>> zc is viable or not. It can do more complex calculations _if_ needed, e.g.
>>> looking inside skb's and figure out how many bytes were copied but as for me
>>> it should better be turned into a single bool in the end. Could also be the
>>> number of bytes copied, but I don't think we can't have the accuracy for
>>> that (e.g. what we're going to return if some protocol duplicates an skb
>>> and sends to 2 different devices or is processing it in a pipeline?)
>>>
>>> So the question is what is the use case for having 2 flags?
>>
>> It's mostly for debugging.
> 
> Ok, than it sounds like we don't need it.

Maybe I could add some trace points to the callback?

>>> btw, now we've got another example why the report flag is a good idea,
>>
>> I don't understand that line...
> 
> I'm just telling that IORING_SEND_NOTIF_* instead of unconditional reporting
> is more flexible and extendible from the uapi perspective.

ok

>>> we can't use cqe.res unconditionally because we want to have a "one CQE
>>> per request" mode, but it's fine if we make it and the report flag
>>> mutually exclusive.
>>
>> You mean we can add an optimized case where SEND[MSG]_ZC would not
>> generate F_MORE and skips F_NOTIF, because we copied or the transmission
>> path was really fast?
> 
> It is rather about optionally omitting the first (aka completion) cqe and
> posting only the notification cqe, which makes a lot of sense for UDP and
> some TCP use cases.

OK.

>> Then I'd move to IORING_CQE_F_COPIED again...
> [...]
>>>> -struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
>>>> +static void __io_notif_complete_tw_report_usage(struct io_kiocb *notif, bool *locked)
>>>
>>> Just shove all that into __io_notif_complete_tw().
>>
>> Ok, and then optimze later?
> 
> Right, I'm just tired of back porting patches by hand :)

ok, I just assumed it would be 6.1 only.

>> Otherwise we could have IORING_CQE_F_COPIED by default without opt-in
>> flag...

Do you still want an opt-in flag to get IORING_CQE_F_COPIED?
If so what name do you want it to be?

>>>> +static void io_uring_tx_zerocopy_callback_report_usage(struct sk_buff *skb,
>>>> +                            struct ubuf_info *uarg,
>>>> +                            bool success)
>>>> +{
>>>> +    struct io_notif_data *nd = container_of(uarg, struct io_notif_data, uarg);
>>>> +
>>>> +    if (success && !nd->zc_used && skb)
>>>> +        nd->zc_used = true;
>>>> +    else if (unlikely(!success && !nd->zc_copied))
>>>> +        nd->zc_copied = true;
>>>
>>> It's fine but racy, so let's WRITE_ONCE() to indicate it.
>>
>> I don't see how this could be a problem, but I can add it.
> 
> It's not a problem, but better to be a little be more explicit
> about parallel writes.

ok.

>>>> diff --git a/io_uring/notif.h b/io_uring/notif.h
>>>> index 5b4d710c8ca5..5ac7a2745e52 100644
>>>> --- a/io_uring/notif.h
>>>> +++ b/io_uring/notif.h
>>>> @@ -13,10 +13,12 @@ struct io_notif_data {
>>>>       struct file        *file;
>>>>       struct ubuf_info    uarg;
>>>>       unsigned long        account_pages;
>>>> +    bool            zc_used;
>>>> +    bool            zc_copied;
>>>
>>> IIRC io_notif_data is fully packed in 6.1, so placing zc_{used,copied}
>>> there might complicate backporting (if any). We can place them in io_kiocb
>>> directly and move in 6.2. Alternatively account_pages doesn't have to be
>>> long.
>>
>> As far as I can see kernel-dk-block/io_uring-6.1 alread has your
>> shrink patches included...
> 
> Sorry, I mean 6.0

So you want to backport to 6.0?

Find the current version below, sizeof(struct io_kiocb) will grow from
3*64 + 24 to 3*64 + 32 (on x64_64) to it stays within 4 cache lines.

I tried this first:

union {
   u8 iopoll_completed;
   struct {
     u8 zc_used:1;
     u8 zc_copied:1;
   };
};

But then WRITE_ONCE() complains about a bitfield write.

So let me now about the opt-in flag and I'll prepare real commits
including a patch that moves from struct io_kiocb to struct io_notif_data
on top.

metze

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index f5b687a787a3..189152ad78d6 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -515,6 +515,9 @@ struct io_kiocb {
  	u8				opcode;
  	/* polled IO has completed */
  	u8				iopoll_completed;
+	/* these will be moved to struct io_notif_data in 6.1 */
+	bool				zc_used;
+	bool				zc_copied;
  	/*
  	 * Can be either a fixed buffer index, or used with provided buffers.
  	 * For the latter, before issue it points to the buffer group ID,
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index ab7458033ee3..738d6234d1d9 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -350,6 +350,7 @@ struct io_uring_cqe {
  #define IORING_CQE_F_MORE		(1U << 1)
  #define IORING_CQE_F_SOCK_NONEMPTY	(1U << 2)
  #define IORING_CQE_F_NOTIF		(1U << 3)
+#define IORING_CQE_F_COPIED		(1U << 4)

  enum {
  	IORING_CQE_BUFFER_SHIFT		= 16,
diff --git a/io_uring/notif.c b/io_uring/notif.c
index e37c6569d82e..033aca064b10 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -18,6 +18,10 @@ static void __io_notif_complete_tw(struct io_kiocb *notif, bool *locked)
  		__io_unaccount_mem(ctx->user, nd->account_pages);
  		nd->account_pages = 0;
  	}
+
+	if (notif->zc_copied || !notif->zc_used)
+		notif->cqe.flags |= IORING_CQE_F_COPIED;
+
  	io_req_task_complete(notif, locked);
  }

@@ -28,6 +32,11 @@ static void io_uring_tx_zerocopy_callback(struct sk_buff *skb,
  	struct io_notif_data *nd = container_of(uarg, struct io_notif_data, uarg);
  	struct io_kiocb *notif = cmd_to_io_kiocb(nd);

+	if (success && !notif->zc_used && skb)
+		WRITE_ONCE(notif->zc_used, true);
+	else if (!success && !notif->zc_copied)
+		WRITE_ONCE(notif->zc_copied, true);
+
  	if (refcount_dec_and_test(&uarg->refcnt)) {
  		notif->io_task_work.func = __io_notif_complete_tw;
  		io_req_task_work_add(notif);
@@ -55,6 +64,7 @@ struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
  	nd->account_pages = 0;
  	nd->uarg.flags = SKBFL_ZEROCOPY_FRAG | SKBFL_DONT_ORPHAN;
  	nd->uarg.callback = io_uring_tx_zerocopy_callback;
+	notif->zc_used = notif->zc_copied = false;
  	refcount_set(&nd->uarg.refcnt, 1);
  	return notif;
  }

