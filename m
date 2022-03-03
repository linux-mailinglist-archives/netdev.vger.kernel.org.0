Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 797874CB692
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 06:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiCCFt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 00:49:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiCCFt2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 00:49:28 -0500
Received: from smtp.smtpout.orange.fr (smtp08.smtpout.orange.fr [80.12.242.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C903119F04
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 21:48:41 -0800 (PST)
Received: from [192.168.1.18] ([90.126.236.122])
        by smtp.orange.fr with ESMTPA
        id PeKLnokkrxHdTPeKLneDHk; Thu, 03 Mar 2022 06:48:39 +0100
X-ME-Helo: [192.168.1.18]
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Thu, 03 Mar 2022 06:48:39 +0100
X-ME-IP: 90.126.236.122
Message-ID: <3bf9dbf1-74fc-5cc9-b6fc-c3267be0a4ac@wanadoo.fr>
Date:   Thu, 3 Mar 2022 06:48:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] Bluetooth: Don't assign twice the same value
Content-Language: en-US
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
References: <e2c2fe36c226529c99595370003d3cb1b7133c47.1646252285.git.christophe.jaillet@wanadoo.fr>
 <CABBYNZKpZ+tA0YuBFzwug-W3Bcx9GuL4hcrPSfSQt0VnbZi58A@mail.gmail.com>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-bluetooth@vger.kernel.org,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
In-Reply-To: <CABBYNZKpZ+tA0YuBFzwug-W3Bcx9GuL4hcrPSfSQt0VnbZi58A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 02/03/2022 à 22:36, Luiz Augusto von Dentz a écrit :
> Hi Christophe,
> 
> On Wed, Mar 2, 2022 at 12:18 PM Christophe JAILLET
> <christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org> wrote:
>>
>> data.pid is set twice with the same value. Remove one of these redundant
>> calls.
>>
>> Signed-off-by: Christophe JAILLET <christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>
>> ---
>>   net/bluetooth/l2cap_core.c | 1 -
>>   1 file changed, 1 deletion(-)
>>
>> diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
>> index e817ff0607a0..0d460cb7f965 100644
>> --- a/net/bluetooth/l2cap_core.c
>> +++ b/net/bluetooth/l2cap_core.c
>> @@ -1443,7 +1443,6 @@ static void l2cap_ecred_connect(struct l2cap_chan *chan)
>>          data.pdu.scid[0]     = cpu_to_le16(chan->scid);
>>
>>          chan->ident = l2cap_get_ident(conn);
>> -       data.pid = chan->ops->get_peer_pid(chan);
> 
> Perhaps we should do if (!data->pid) then since afaik one can do
> connect without bind.

Not sure to follow you.
'data' is local to this function. data->pid is undefined at this point.


If your comment is about the end of the function that should be 
conditional, I don't know the bluetooth stack at all and can't have any 
opinion about it.

If it is relevant, s.o. else will need to provide a patch for it.

CJ

> 
>>          data.count = 1;
>>          data.chan = chan;
>> --
>> 2.32.0
>>
> 
> 

