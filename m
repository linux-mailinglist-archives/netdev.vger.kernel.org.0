Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4336C227A
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 21:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbjCTUWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 16:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231213AbjCTUWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 16:22:45 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5E834018;
        Mon, 20 Mar 2023 13:22:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1679343755; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=WabEYtxg0GhcVUg+ZQ8OJStGRt0hW2LMwdx6Skk7zlnlAQjEcxjcc4bgZ/nGpafDTX
    XiHVeG0SyM2RM8oW9VGrvRW3AFYw7TwQoVPexHGz9k1X/iLaudUkhfS26A6d4kj3PQcA
    GBvd2V0wtqHe5UMT6Dc4TeFpKTC8L2WzN4Tf2UQ5U9wxN/5O6bjhwLnqA2OWsCS5avqo
    XocDEu3jjRPMe6Oq6+/CnWG+ICiYmGg4aZ18WdvfLhsF1inaqKR2o/vaeb6uZXsB4cur
    nWkqu2R43SPws1k4lTwsgh64/cz7enDnxU9O1prymZdulGahQ36AGSJ3b6+q75usGDVt
    NM7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1679343755;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=fFqiOgGa9vKnUU9LvZri6TcGJQy+wwvmK0goIayR468=;
    b=PcnN/Cp5vWZ4b/DVn8q6l1z+oIA+i5Q+Mh+rmN/stP7STEAUcI4iR9Dgqdf+eUFmP+
    Hjj6BdbrdrqdBaaWHi8gB6iLYVTH5fRpa1oAeCaYj2Izs2qXOvKIfzMlN9B/d78H7+Rp
    2Ebzyg3Tjv3fExAXDacAEsOc1DY1ZEN3HCLwHVmwblG3NgV2BRGYa8QhjnsPjyhw6Mjl
    brfs1Wl8VXmVen4Ca+6OWOLUUYEBEDI3foGM4F/m8d/oK+jyFXeFQecKmSJ916FTnU00
    uOY2AalXo1owzQsjSx0654Cvzk28qoIiYG2rZMe8BVcdB2cFZW/onGKwwxT/uNDi/zeo
    ffPw==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1679343755;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=fFqiOgGa9vKnUU9LvZri6TcGJQy+wwvmK0goIayR468=;
    b=EI3g7CY+vUOBK4IP8WknJBVa2sn4Q/wRwtY4dhbgG/doliFJqxzM8ZIF8Zh39RXV5m
    fFlPHTN7l7MW4jRY84+cLXOV/boM4XljJhiNfO6CCvqty99/Np4dtFsXtX6shvZ0sO0r
    fDNsIsn9DrSk2h1t5o+K/NmjPNZ6vE13VYzdlckD+OaRW0QmQJCQ28ZJ7xecvz//ce9o
    mi1GqzPHxarVRevQUhazHRba1biOeS3VvjtZ5V2Qd9Ys/+DP/436k2DIQanqfegvwBg4
    TyAwAMqg0GwmLcHa8YrPTZpEW7Z070AXaSh6uVFAAVxXRdjIQImPJTzsFNj+S9iBd7fG
    pT0w==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusl129OHEdFq0USEbDUQnQ=="
Received: from [IPV6:2a00:6020:4a8e:5000::923]
    by smtp.strato.de (RZmta 49.3.1 AUTH)
    with ESMTPSA id n9397fz2KKMYBmb
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 20 Mar 2023 21:22:34 +0100 (CET)
Message-ID: <b5c30cb9-f35f-01b1-21b8-4658d46a5c1d@hartkopp.net>
Date:   Mon, 20 Mar 2023 21:22:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] FS, NET: Fix KMSAN uninit-value in vfs_write
Content-Language: en-US
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Ivan Orlov <ivan.orlov0322@gmail.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, himadrispandya@gmail.com,
        skhan@linuxfoundation.org,
        syzbot+c9bfd85eca611ebf5db1@syzkaller.appspotmail.com
References: <20230314120445.12407-1-ivan.orlov0322@gmail.com>
 <0e7090c4-ca9b-156f-5922-fd7ddb55fee4@hartkopp.net>
 <ff0a4ed4-9fde-7a9f-da39-d799dfb946f1@gmail.com>
 <b4abefa2-16d0-a18c-4614-1786eb94ffab@hartkopp.net>
 <20230320154053.x3h54b2s3r7iclby@pengutronix.de>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20230320154053.x3h54b2s3r7iclby@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 20.03.23 16:40, Marc Kleine-Budde wrote:
> On 14.03.2023 20:23:47, Oliver Hartkopp wrote:
>>
>>
>> On 14.03.23 16:37, Ivan Orlov wrote:
>>> On 3/14/23 18:38, Oliver Hartkopp wrote:
>>>> Hello Ivan,
>>>>
>>>> besides the fact that we would read some uninitialized value the
>>>> outcome of the original implementation would have been an error and
>>>> a termination of the copy process too. Maybe throwing a different
>>>> error number.
>>>>
>>>> But it is really interesting to see what KMSAN is able to detect
>>>> these days! Many thanks for the finding and your effort to
>>>> contribute this fix!
>>>>
>>>> Best regards,
>>>> Oliver
>>>>
>>>>
>>>> On 14.03.23 13:04, Ivan Orlov wrote:
>>>>> Syzkaller reported the following issue:
>>>>
>>>> (..)
>>>>
>>>>>
>>>>> Reported-by: syzbot+c9bfd85eca611ebf5db1@syzkaller.appspotmail.com
>>>>> Link: https://syzkaller.appspot.com/bug?id=47f897f8ad958bbde5790ebf389b5e7e0a345089
>>>>> Signed-off-by: Ivan Orlov <ivan.orlov0322@gmail.com>
>>>>
>>>> Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
>>>>
>>>>
>>>>> ---
>>>>>    net/can/bcm.c | 16 ++++++++++------
>>>>>    1 file changed, 10 insertions(+), 6 deletions(-)
>>>>>
>>>>> diff --git a/net/can/bcm.c b/net/can/bcm.c
>>>>> index 27706f6ace34..a962ec2b8ba5 100644
>>>>> --- a/net/can/bcm.c
>>>>> +++ b/net/can/bcm.c
>>>>> @@ -941,6 +941,8 @@ static int bcm_tx_setup(struct bcm_msg_head
>>>>> *msg_head, struct msghdr *msg,
>>>>>                cf = op->frames + op->cfsiz * i;
>>>>>                err = memcpy_from_msg((u8 *)cf, msg, op->cfsiz);
>>>>> +            if (err < 0)
>>>>> +                goto free_op;
>>>>>                if (op->flags & CAN_FD_FRAME) {
>>>>>                    if (cf->len > 64)
>>>>> @@ -950,12 +952,8 @@ static int bcm_tx_setup(struct bcm_msg_head
>>>>> *msg_head, struct msghdr *msg,
>>>>>                        err = -EINVAL;
>>>>>                }
>>>>> -            if (err < 0) {
>>>>> -                if (op->frames != &op->sframe)
>>>>> -                    kfree(op->frames);
>>>>> -                kfree(op);
>>>>> -                return err;
>>>>> -            }
>>>>> +            if (err < 0)
>>>>> +                goto free_op;
>>>>>                if (msg_head->flags & TX_CP_CAN_ID) {
>>>>>                    /* copy can_id into frame */
>>>>> @@ -1026,6 +1024,12 @@ static int bcm_tx_setup(struct
>>>>> bcm_msg_head *msg_head, struct msghdr *msg,
>>>>>            bcm_tx_start_timer(op);
>>>>>        return msg_head->nframes * op->cfsiz + MHSIZ;
>>>>> +
>>>>> +free_op:
>>>>> +    if (op->frames != &op->sframe)
>>>>> +        kfree(op->frames);
>>>>> +    kfree(op);
>>>>> +    return err;
>>>>>    }
>>>>>    /*
>>>
>>> Thank you for the quick answer! I totally agree that this patch will not
>>> change the behavior a lot. However, I think a little bit more error
>>> processing will not be bad (considering this will not bring any
>>> performance overhead). If someone in the future tries to use the "cf"
>>> object right after "memcpy_from_msg" call without proper error
>>> processing it will lead to a bug (which will be hard to trigger). Maybe
>>> fixing it now to avoid possible future mistakes in the future makes
>>> sense?
>>
>> Yes! Definitely!
>>
>> Therefore I added my Acked-by: tag. Marc will likely pick this patch for
>> upstream.
> 
> Can you create a proper Fixes tag?

Fixes: 6f3b911d5f29b ("can: bcm: add support for CAN FD frames")

Btw. do you really think this is a candidate for stable?

IMHO it is just a KMSAN hit that should be fixed for future releases ...

Best regards,
Oliver
