Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25D3F6076B4
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 14:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbiJUMKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 08:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiJUMKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 08:10:43 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDA1F2112A3;
        Fri, 21 Oct 2022 05:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=nUxwDjmQZFDmqopuW/cyPC3LxSsMIIgXqtPnaDKVD0s=; b=uvaYuXFcBbRaZyjByrM/jsba3Z
        dvtWm4wkOUQA/PIYGS1eiCsbhMAzgFWwsLKkak9wXGqnWct78GygrstUXMOPQx7N7wW0MplpZLsmF
        aaN27lO2CQuQwRXOZtt98kLjePR9MG2Y5op/oiic6GkIUiBpI3aTt7tpWfCoEjD9WOMsmrD2rSHrq
        Ei3WU8cIbMfxsml1JGW4g52SnILsx/W8KKfxjTXLR1bWfhAiC6ycP55TpgCtmnZWr4XedMSDIzibx
        rvkrKJTIb2SCf4SlSvzGE89derlHpDemDd479RVZo5e4HeP9LTR2gOlC9jDrQHOzDT7uxKM/OgU2m
        CDChHgUrNT3vb554/r96oeKwtAPbcOeuk//b18tlWB7wF6vlfd2ojQssJ3VydGecOsX5wiXLm4dl/
        EdJFYgFsFBrNav4cp3oqV9w6mIEdIe4579iiNSneeDs5RmVHFXEQozHJ/SXHROzov9Ue6SroDtGaN
        98rNtEzFXWK2hQB+nWjA33kK;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1olqrF-0059fa-7Z; Fri, 21 Oct 2022 12:10:37 +0000
Message-ID: <43d3dad4-2158-dbcc-1c62-5b4021b95376@samba.org>
Date:   Fri, 21 Oct 2022 14:10:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Content-Language: en-US
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
 <3e7b7606-c655-2d10-f2ae-12aba9abbc76@samba.org>
 <ae88cd67-906a-7c89-eaf8-7ae190c4674b@gmail.com>
 <86763cf2-72ed-2d05-99c3-237ce4905611@samba.org>
 <fc3967d3-ef72-7940-2436-3d8aa329151e@gmail.com>
 <a5bf4d77-0fad-1d3f-159f-b97128f58af2@samba.org>
 <2092f2db-d847-dd78-1690-359ed9bb7f14@gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: IORING_SEND_NOTIF_USER_DATA (was Re: IORING_CQE_F_COPIED)
In-Reply-To: <2092f2db-d847-dd78-1690-359ed9bb7f14@gmail.com>
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

Am 21.10.22 um 13:20 schrieb Pavel Begunkov:
> On 10/21/22 10:45, Stefan Metzmacher wrote:
>> Am 21.10.22 um 11:27 schrieb Pavel Begunkov:
>>> On 10/21/22 09:32, Stefan Metzmacher wrote:
>>>> Hi Pavel,
>>>>
>>>>>>>> Experimenting with this stuff lets me wish to have a way to
>>>>>>>> have a different 'user_data' field for the notif cqe,
>>>>>>>> maybe based on a IORING_RECVSEND_ flag, it may make my life
>>>>>>>> easier and would avoid some complexity in userspace...
>>>>>>>> As I need to handle retry on short writes even with MSG_WAITALL
>>>>>>>> as EINTR and other errors could cause them.
>>>>>>>>
>>>>>>>> What do you think?
>>>>>>
>>>>>> Any comment on this?
>>>>>>
>>>>>> IORING_SEND_NOTIF_USER_DATA could let us use
>>>>>> notif->cqe.user_data = sqe->addr3;
>>>>>
>>>>> I'd rather not use the last available u64, tbh, that was the
>>>>> reason for not adding a second user_data in the first place.
>>>>
>>>> As far as I can see io_send_zc_prep has this:
>>>>
>>>>          if (unlikely(READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3)))
>>>>                  return -EINVAL;
>>>>
>>>> both are u64...
>>>
>>> Hah, true, completely forgot about that one
>>
>> So would a commit like below be fine for you?
>>
>> Do you have anything in mind for SEND[MSG]_ZC that could possibly use
>> another u64 in future?
> 
> It'll most likely be taken in the future, some features are planned
> some I can imagine.

Can give examples? As I can't imagine any possible feature.

> The question is how necessary this one is and/or
> how much simpler it would make it considering that CQEs are ordered
> and apps still need to check for F_MORE. It shouldn't even require
> refcounting. Can you elaborate on the simplifying userspace part?
> 
It's not critical, it would just make it easier to dispatch
a different callback functions for the two cases.

The current problem I'm facing is that I have a structure
holding the state of an response and that has a single embedded
completion structure:

(simplified) struct completion {
    uint32_t generation;
    void (*callback_fn)(void *callback_private, const struct io_uring_cqe *cqe);
    void *callback_private;
};

I use the memory address of the completion structure glued with the lower bits of the generation
as 'user_data'. Imagine that I got a short write from SENDMSG_ZC/WAITALL
because EINTR was generated, then I need to retry from userspace, which
I'd try immediately without waiting for the NOTIF cqe to arrive.

For each incoming cqe I get the completion address and the generation
out of user_data and then verify the generation against the one stored in
the completion in order to detect bugs, before passing over to callback_fn().

Because I still need to handle the NOTIF cqe from the first try
I can't change the generation for the next try.

I thought about using two completion structures, one for the main SENDMSG_ZC result
(which gets its generation incremented with each retry) and one for the NOTIF cqes
just keeping generation stable having a simple callback_fn just waiting for a
refcount to get 0.

Most likely I just need to sit down concentrated to get the
recounting and similar things sorted out.

If there are really useful things we will do with addr3 and __pad2[0],
I can try to cope with it... It would just be sad if they wouldn't be used anyway.

metze
