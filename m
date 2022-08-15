Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE4D5592ED6
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 14:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240419AbiHOMXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 08:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbiHOMXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 08:23:42 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA24252BF;
        Mon, 15 Aug 2022 05:23:41 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id m17-20020a7bce11000000b003a5bedec07bso5959107wmc.0;
        Mon, 15 Aug 2022 05:23:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=RI5hnf1TAwkc3S+fgwqlw38otSxnfU0/sQ0HDGYGmaU=;
        b=bcLD1pixTStPUb7I0rtZBbSFgTRwmG5I5blGpzHWCnF1bRijf9dkcFZ2e5LjqhZKzq
         pCmziI/argmXUSDr/uhV0pPg/KGVTVA12ApRP+MxTYFyHFl+4BQuDooti8D/sveGOGXU
         a6mebbwY2j+UgfesrqcfvfJibT94ZbZYEilWV8pp/ETNOYtP4ok9ltaxa7mH7Qn05Y12
         7+fAj8+W+otaaPcPXUfgH61CRh5kB2FFD8W/77Oh2vvy5LaS4brU9SXSkpD9PqVvvvu5
         T2sp1af5+CfSXCZ6VonyiUmCHIvLxdDZC2Arb51t0dlW3rAsd/CcLmhTsAiFMPX85s7h
         urkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=RI5hnf1TAwkc3S+fgwqlw38otSxnfU0/sQ0HDGYGmaU=;
        b=Puct8zMg0XnMinziZ4jilBwpuCuJisg7vEg68HANC0LcDQ1WkGPuNsyfXuY1vkBI3r
         /RjZxyEReOJC1EfNR00jzy8cWpDdmbbDhjlHZuUygQGO0SuxPKzdcapoIH44JsxMee2s
         fTy02G6a8fU1LkpLESIFZ7sjocKwUeyfhqi0IN8XFQLom/n2P2iC9kcr4HP2oWxy1QuY
         g07CxZZ6j2jawrQKiBNGvs+/skgkkF05Ds894Oz7nePVtPiqlEUtvy0VLKuWqJ5L1dQg
         xb+Fj4zvizME/uSz/bWlFJQOxW6lh5t4fcc2oGYQgrav25CNhMytdCAZ75heuT6Xq72G
         Bzrg==
X-Gm-Message-State: ACgBeo0Z5GeVeFDJrr41EQh16oUnnKSnejieCU1dpHcL3y2qTL9BBQfw
        k968vni7hRIjjjMuZHXJBHI=
X-Google-Smtp-Source: AA6agR4VriqJyklz5wPXbkcc6NhQwq8U19k6jMgOV8rUCdG6V2dL6KdB4PTOiSH306eNHywUCYT+Ww==
X-Received: by 2002:a7b:cb44:0:b0:3a4:e8c7:59a2 with SMTP id v4-20020a7bcb44000000b003a4e8c759a2mr10110369wmj.67.1660566219594;
        Mon, 15 Aug 2022 05:23:39 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::22ef? ([2620:10d:c092:600::2:5fc6])
        by smtp.gmail.com with ESMTPSA id h22-20020a05600c351600b003a2f2bb72d5sm12373152wmq.45.2022.08.15.05.23.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Aug 2022 05:23:39 -0700 (PDT)
Message-ID: <9edd5970-504c-b088-d2b1-3a2b7ad9b345@gmail.com>
Date:   Mon, 15 Aug 2022 13:19:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC net-next v3 23/29] io_uring: allow to pass addr into sendzc
Content-Language: en-US
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com
References: <cover.1653992701.git.asml.silence@gmail.com>
 <228d4841af5eeb9a4b73955136559f18cb7e43a0.1653992701.git.asml.silence@gmail.com>
 <cccec667-d762-9bfd-f5a5-1c9fb46df5af@samba.org>
 <56631a36-fec8-9c41-712b-195ad7e4cb9f@gmail.com>
 <4eb0adae-660a-3582-df27-d6c254b97adb@samba.org>
 <db7bbfcd-fdd0-ed8e-3d8e-78d76f278af8@gmail.com>
 <246ef163-5711-01d6-feac-396fc176e14e@samba.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <246ef163-5711-01d6-feac-396fc176e14e@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/15/22 12:40, Stefan Metzmacher wrote:
> Hi Pavel,
> 
>> Thanks for giving a thought about the API, are you trying
>> to use it in samba?
> 
> Yes, but I'd need SENDMSGZC and then I'd like to test,
> which variant gives the best performance. It also depends
> on the configured samba vfs module stack.

I can send you a branch this week if you would be
willing to try it out as I'll be sending the "msg" variant
only for 5.21

> My current prototype uses IO_SENDMSG for the header < 250 bytes
> followed by up to 8MBytes via IO_SPLICE if the storage backend also
> supports splice, otherwise I'd try to use IO_SENDMSGZC for header + 8 MBytes payload
> together. If there's encryption turned actice on the connection we would
> most likely always use a bounce buffer and hit the IO_SENDMSGZC case.
> So all in all I'd say we'll use it.

Perfect

> I guess it would be useful for userspace to notice if zero was possible or not.
> 
> __msg_zerocopy_callback() sets SO_EE_CODE_ZEROCOPY_COPIED, maybe
> io_uring_tx_zerocopy_callback() should have something like:
> 
> if (!success)
>      notif->cqe.res = SO_EE_CODE_ZEROCOPY_COPIED;
> 
> This would make it a bit easier to judge if SENDZC is useful for the
> application or not. Or at least have debug message, which would explain
> be able to explain degraded performance to the admin/developer.

Ok, let me think about it


>>>>> Given that this fills in msg almost completely can we also have
>>>>> a version of SENDMSGZC, it would be very useful to also allow
>>>>> msg_control to be passed and as well as an iovec.
>>>>>
>>>>> Would that be possible?
>>>>
>>>> Right, I left it to follow ups as the series is already too long.
>>>>
>>>> fwiw, I'm going to also add addr to IORING_OP_SEND.
>>>
>>>
>>> Given the minimal differences, which were left between
>>> IORING_OP_SENDZC and IORING_OP_SEND, wouldn't it be better
>>> to merge things to IORING_OP_SEND using a IORING_RECVSEND_ZC_NOTIF
>>> as indication to use the notif slot.
>>
>> And will be even more similar in for-next, but with notifications
>> I'd still prefer different opcodes to get a little bit more
>> flexibility and not making the normal io_uring send path messier.
> 
> Ok, we should just remember the opcode is only u8
> and we already have ~ 50 out of ~250 allocated in ~3 years
> time.
> 
>>> It would means we don't need to waste two opcodes for
>>> IORING_OP_SENDZC and IORING_OP_SENDMSGZC (and maybe more)
>>>
>>>
>>> I also noticed a problem in io_notif_update()
>>>
>>>          for (; idx < idx_end; idx++) {
>>>                  struct io_notif_slot *slot = &ctx->notif_slots[idx];
>>>
>>>                  if (!slot->notif)
>>>                          continue;
>>>                  if (up->arg)
>>>                          slot->tag = up->arg;
>>>                  io_notif_slot_flush_submit(slot, issue_flags);
>>>          }
>>>
>>>   slot->tag = up->arg is skipped if there is no notif already.
>>>
>>> So you can't just use a 2 linked sqe's with
>>>
>>> IORING_RSRC_UPDATE_NOTIF followed by IORING_OP_SENDZC(with IORING_RECVSEND_NOTIF_FLUSH)
>>
>> slot->notif is lazily initialised with the first send attached to it,
>> so in your example IORING_OP_SENDZC will first create a notification
>> to execute the send and then will flush it.
>>
>> This "if" is there is only to have a more reliable API. We can
>> go over the range and allocate all empty slots and then flush
>> all of them, but allocation failures should be propagated to the
>> userspace when currently the function it can't fail.
>>
>>> I think the if (!slot->notif) should be moved down a bit.
>>
>> Not sure what you mean
> 
> I think it should be:
> 
>                    if (up->arg)
>                            slot->tag = up->arg;
>                    if (!slot->notif)
>                            continue;
>                    io_notif_slot_flush_submit(slot, issue_flags);
> 
> or even:
> 
>                    slot->tag = up->arg;
>                    if (!slot->notif)
>                            continue;
>                    io_notif_slot_flush_submit(slot, issue_flags);
> 
> otherwise IORING_RSRC_UPDATE_NOTIF would not be able to reset the tag,
> if notif was never created or already be flushed.

Ah, you want to update it for later. The idea was to affect only
those notifiers that are flushed by this update.
...

>>> It would somehow be nice to avoid the notif slots at all and somehow
>>> use some kind of multishot request in order to generate two qces.
>>
>> It is there first to ammortise overhead of zerocopy infra and bits
>> for second CQE posting. But more importantly, without it for TCP
>> the send payload size would need to be large enough or performance
>> would suffer, but all depends on the use case. TL;DR; it would be
>> forced to create a new SKB for each new send.
>>
>> For something simpler, I'll push another zc variant that doesn't
>> have notifiers and posts only one CQE and only after the buffers
>> are no more in use by the kernel. This works well for UDP and for
>> some TCP scenarios, but doesn't cover all cases.
> 
> I think (at least for stream sockets) it would be more useful to
> get two CQEs:
> 1. The first signals userspace that it can
>     issue the next send-like operation (SEND,SENDZC,SENDMSG,SPLICE)
>     on the stream without the risk of byte ordering problem within the stream
>     and avoid too high latency (which would happen, if we wait for a send to
>     leave the hardware nic, before sending the next PDU).
> 2. The 2nd signals userspace that the buffer can be reused or released.
> 
> In that case it would be useful to also provide a separate 'user_data' element
> for the 2nd CQE.

...

I had a similar chat with Dylan last week. I'd rather not rob SQE of
additional u64 as there is only addr3 left and then we're fully packed,
but there is another option we were thinking about based on OVERRIDE_TAG
feature I scrapped from the final version of zerocopy patches.

Long story short, the idea is to copy req->cqe.user_data of a
send(+flush) request into the notification CQE, so you'll get 2 CQEs
with identical user_data but they can be distinguished by looking at
cqe->flags.

What do you think? Would it work for you?


>>> I'm also wondering what will happen if a notif will be referenced by the net layer
>>> but the io_uring instance is already closed, wouldn't
>>> io_uring_tx_zerocopy_callback() or __io_notif_complete_tw() crash
>>> because notif->ctx is a stale pointer, of notif itself is already gone...
>>
>> io_uring will flush all slots and wait for all notifications
>> to fire, i.e. io_uring_tx_zerocopy_callback(), so it's not a
>> problem.
> 
> I can't follow :-(
> 
> What I see is that io_notif_unregister():
> 
>                  nd = io_notif_to_data(notif);
>                  slot->notif = NULL;
>                  if (!refcount_dec_and_test(&nd->uarg.refcnt))
>                          continue;
> 
> So if the net layer still has a reference we just go on.
> 
> Only a wild guess, is it something of:
> 
> io_alloc_notif():
>          ...
>          notif->task = current;
>          io_get_task_refs(1);
>          notif->rsrc_node = NULL;
>          io_req_set_rsrc_node(notif, ctx, 0);
>          ...
> 
> and
> 
> __io_req_complete_put():
>                  ...
>                  io_req_put_rsrc(req);
>                  /*
>                   * Selected buffer deallocation in io_clean_op() assumes that
>                   * we don't hold ->completion_lock. Clean them here to avoid
>                   * deadlocks.
>                   */
>                  io_put_kbuf_comp(req);
>                  io_dismantle_req(req);
>                  io_put_task(req->task, 1);
>                  ...
> 
> that causes io_ring_exit_work() to wait for it.> It would be great if you or someone else could explain this in detail
> and maybe adding some comments into the code.

Almost, the mechanism is absolutely the same as with requests,
and notifiers are actually requests for internal purposes.

In __io_alloc_req_refill() we grab ctx->refs, which are waited
for in io_ring_exit_work(). We usually put requests into a cache,
so when a request is complete we don't put the ref and therefore
in io_ring_exit_work() we also have a call to io_req_caches_free(),
which puts ctx->refs.

-- 
Pavel Begunkov
