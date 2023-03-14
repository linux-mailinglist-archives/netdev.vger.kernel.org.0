Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDEF76B9F88
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 20:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbjCNTYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 15:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbjCNTYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 15:24:09 -0400
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [85.215.255.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B14A31CF68;
        Tue, 14 Mar 2023 12:24:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1678821837; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=cgpa1hHRmB2GcA7y37ZZLPaGP8pCjPDIN/vZqNgPAlIyN3dJRQ0V60sredRj5a2diT
    Q03E1xlhQ0RyczFlpgN95JI2ibHdS1oqu5kz+yKAujUd6awYxipnm8Zpr7cLTt1eI1db
    OJYIsBlWuHjcKVPQBWeKvoPIoq8qwbmMA7hX6+UqFy5PDBmrkylwyFBQFnfTanpaIStX
    FmigV5ehomP3xJi52Pfv8oxZ4JrqadD0ro9Qu+PjJp8bVAqv5OUpdL6fMnrdLRR/3M15
    hNSjdanvmCcypesLmfdvhICp9uPL3pkvMjOj8ltPwr83W77obvpdXOoT6E6YS/bxL07+
    Sq+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1678821837;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=2AzoYQ1JYVVdIGEaF3ODRQ5x41qh1tTsxnfbr9fi88k=;
    b=Jkhly8iieckW4NiWRGGXK/eWoHt+1obhLt0F9ASaVU/sDiQHSCE4RsiAH0wNCD8unH
    emMGPe6jisA0cBKjuoCOs5MiLrGHeGMoM/1qY2wtuRiAh9ArZ3dosAeOMiCief5EIY5j
    NmL4gKnKye8qf9Pln/VPC7wNW1ZCdmHdHlk9Y/rQUmGpRNBddwiyEqdElUFXFY0tQptr
    KvOlpnEb0nKfiXZeAXTdWm5k1/46yRmpQKIyxSFfFf2Oxghj/i4sDHUsB9cbFKKD6xj1
    jfFRw0uX2ryxC1bNwuTLdRWXb9IZCnqumv98a8foy42LYOwTG4q8n3CPahMLcqVJNgxC
    jLQQ==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1678821837;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=2AzoYQ1JYVVdIGEaF3ODRQ5x41qh1tTsxnfbr9fi88k=;
    b=rF0hgBFuNvnVlPhfupTVgz++6WqvmchT+ONcZ3EuaMUdK29fFrj9wExreP8NvaPHaP
    KXLbGCdd7mAOKGuEKLnT0wBgWdHVcArpgJ3yutUqsBz8cbJAwVBeEVJV+BgcvgWExEAx
    cR6AHw4sE4LX8MjgInKnVgIPMsKXFBk2EGAIufXXEsKtIwbapro8Q34QbzUJ4Hx3Oliv
    NaVVNU7uHsma4Y1eG6Fb11O9sThe3WEMp3/iaWaKGIBh/Hj7orZ4Bj7428DaPsXcKrfo
    cQGsaPiiJgqBdd3rCaTF6mJobfFsqMBOvBbQZRIqOj150v+i2KZgUEm8oJqnnU71uc60
    Miyg==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusl129OHEdFq0USEbDUQnQ=="
Received: from [IPV6:2a00:6020:4a8e:5000::923]
    by smtp.strato.de (RZmta 49.3.0 AUTH)
    with ESMTPSA id c675b3z2EJNufLt
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 14 Mar 2023 20:23:56 +0100 (CET)
Message-ID: <b4abefa2-16d0-a18c-4614-1786eb94ffab@hartkopp.net>
Date:   Tue, 14 Mar 2023 20:23:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] FS, NET: Fix KMSAN uninit-value in vfs_write
To:     Ivan Orlov <ivan.orlov0322@gmail.com>, mkl@pengutronix.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, himadrispandya@gmail.com,
        skhan@linuxfoundation.org,
        syzbot+c9bfd85eca611ebf5db1@syzkaller.appspotmail.com
References: <20230314120445.12407-1-ivan.orlov0322@gmail.com>
 <0e7090c4-ca9b-156f-5922-fd7ddb55fee4@hartkopp.net>
 <ff0a4ed4-9fde-7a9f-da39-d799dfb946f1@gmail.com>
Content-Language: en-US
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <ff0a4ed4-9fde-7a9f-da39-d799dfb946f1@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 14.03.23 16:37, Ivan Orlov wrote:
> On 3/14/23 18:38, Oliver Hartkopp wrote:
>> Hello Ivan,
>>
>> besides the fact that we would read some uninitialized value the 
>> outcome of the original implementation would have been an error and a 
>> termination of the copy process too. Maybe throwing a different error 
>> number.
>>
>> But it is really interesting to see what KMSAN is able to detect these 
>> days! Many thanks for the finding and your effort to contribute this fix!
>>
>> Best regards,
>> Oliver
>>
>>
>> On 14.03.23 13:04, Ivan Orlov wrote:
>>> Syzkaller reported the following issue:
>>
>> (..)
>>
>>>
>>> Reported-by: syzbot+c9bfd85eca611ebf5db1@syzkaller.appspotmail.com
>>> Link: 
>>> https://syzkaller.appspot.com/bug?id=47f897f8ad958bbde5790ebf389b5e7e0a345089
>>> Signed-off-by: Ivan Orlov <ivan.orlov0322@gmail.com>
>>
>> Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
>>
>>
>>> ---
>>>   net/can/bcm.c | 16 ++++++++++------
>>>   1 file changed, 10 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/net/can/bcm.c b/net/can/bcm.c
>>> index 27706f6ace34..a962ec2b8ba5 100644
>>> --- a/net/can/bcm.c
>>> +++ b/net/can/bcm.c
>>> @@ -941,6 +941,8 @@ static int bcm_tx_setup(struct bcm_msg_head 
>>> *msg_head, struct msghdr *msg,
>>>               cf = op->frames + op->cfsiz * i;
>>>               err = memcpy_from_msg((u8 *)cf, msg, op->cfsiz);
>>> +            if (err < 0)
>>> +                goto free_op;
>>>               if (op->flags & CAN_FD_FRAME) {
>>>                   if (cf->len > 64)
>>> @@ -950,12 +952,8 @@ static int bcm_tx_setup(struct bcm_msg_head 
>>> *msg_head, struct msghdr *msg,
>>>                       err = -EINVAL;
>>>               }
>>> -            if (err < 0) {
>>> -                if (op->frames != &op->sframe)
>>> -                    kfree(op->frames);
>>> -                kfree(op);
>>> -                return err;
>>> -            }
>>> +            if (err < 0)
>>> +                goto free_op;
>>>               if (msg_head->flags & TX_CP_CAN_ID) {
>>>                   /* copy can_id into frame */
>>> @@ -1026,6 +1024,12 @@ static int bcm_tx_setup(struct bcm_msg_head 
>>> *msg_head, struct msghdr *msg,
>>>           bcm_tx_start_timer(op);
>>>       return msg_head->nframes * op->cfsiz + MHSIZ;
>>> +
>>> +free_op:
>>> +    if (op->frames != &op->sframe)
>>> +        kfree(op->frames);
>>> +    kfree(op);
>>> +    return err;
>>>   }
>>>   /*
> 
> Thank you for the quick answer! I totally agree that this patch will not 
> change the behavior a lot. However, I think a little bit more error 
> processing will not be bad (considering this will not bring any 
> performance overhead). If someone in the future tries to use the "cf" 
> object right after "memcpy_from_msg" call without proper error 
> processing it will lead to a bug (which will be hard to trigger). Maybe 
> fixing it now to avoid possible future mistakes in the future makes sense?

Yes! Definitely!

Therefore I added my Acked-by: tag. Marc will likely pick this patch for 
upstream.

Best regards,
Oliver
