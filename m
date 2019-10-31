Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EECF8EACD6
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 10:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbfJaJtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 05:49:03 -0400
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:34600 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbfJaJtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 05:49:03 -0400
Received: from [192.168.42.210] ([93.23.12.90])
        by mwinf5d66 with ME
        id L9ox2100X1waAWt039oxcA; Thu, 31 Oct 2019 10:49:01 +0100
X-ME-Helo: [192.168.42.210]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 31 Oct 2019 10:49:01 +0100
X-ME-IP: 93.23.12.90
Subject: Re: [PATCH] vsock: Simplify '__vsock_release()'
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        davem@davemloft.net, sunilmut@microsoft.com, willemb@google.com,
        sgarzare@redhat.com, stefanha@redhat.com, ytht.net@gmail.com,
        arnd@arndb.de, tglx@linutronix.de, decui@microsoft.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <20191031064741.4567-1-christophe.jaillet@wanadoo.fr>
 <c7a0b6b0-96cd-1fd3-3d98-94a3692bda38@cogentembedded.com>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <1b33ca33-a02b-1923-cbee-814e520b9700@wanadoo.fr>
Date:   Thu, 31 Oct 2019 10:48:53 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <c7a0b6b0-96cd-1fd3-3d98-94a3692bda38@cogentembedded.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 31/10/2019 à 10:36, Sergei Shtylyov a écrit :
> Hello!
>
> On 31.10.2019 9:47, Christophe JAILLET wrote:
>
>> Use '__skb_queue_purge()' instead of re-implementing it.
>
>    In don't see that double underscore below...
This is a typo in the commit message.

There is no need for __ because skb_dequeue was used.

Could you fix it directly in the commit message (preferred solution for 
me) or should I send a V2?

CJ

>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>> ---
>>   net/vmw_vsock/af_vsock.c | 4 +---
>>   1 file changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>> index 2ab43b2bba31..2983dc92ca63 100644
>> --- a/net/vmw_vsock/af_vsock.c
>> +++ b/net/vmw_vsock/af_vsock.c
> [...]
>> @@ -662,8 +661,7 @@ static void __vsock_release(struct sock *sk, int 
>> level)
>>           sock_orphan(sk);
>>           sk->sk_shutdown = SHUTDOWN_MASK;
>>   -        while ((skb = skb_dequeue(&sk->sk_receive_queue)))
>> -            kfree_skb(skb);
>> +        skb_queue_purge(&sk->sk_receive_queue);
>>             /* Clean up any sockets that never were accepted. */
>>           while ((pending = vsock_dequeue_accept(sk)) != NULL) {
>
> MBR, Sergei
>

