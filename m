Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00B566B2EC9
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 21:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbjCIUhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 15:37:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjCIUhO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 15:37:14 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 924F7F754;
        Thu,  9 Mar 2023 12:37:12 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id ECD315FD1B;
        Thu,  9 Mar 2023 23:37:10 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1678394231;
        bh=zJE1vZBgaWt5hdK5QnQB7pg0IiP1OR6zG7/Pzz6u6Fg=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=Vco/M2x5ANgKuY/MvK77bjXFzRFdPrx/GTUUlDVpCwjNpwDGiirc5eZtL8XQGtmWK
         89bifpB1uJu9DQ9k+7EBNNTDYG0DajqS+8p997G6l/J3MuFspj/7pedSQz7rI+ZDzP
         F+aalf1V77snd1VSM1bOW+HEAbGm4FpZAaFxIJh4WOh3SkUVy764hK7c49Ky1UG+qA
         R43oYTqJdu2dMHlFhrpdgnmD7IlCHieXGyKQzQY4BFNAO4JiXDHEliIyEOmtOR9wdQ
         1LSf13SNXaVmcOwABHdPemh6RTqRYmHrtlhsY+XvyzVVvflkYqk7F1o1ZrSaj74uoy
         h77FxkFmemzbg==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Thu,  9 Mar 2023 23:37:10 +0300 (MSK)
Message-ID: <b0fe0f25-42d0-f51b-423d-0d1fb724b53d@sberdevices.ru>
Date:   Thu, 9 Mar 2023 23:34:09 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v3 0/4] several updates to virtio/vsock
Content-Language: en-US
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@sberdevices.ru>, <oxffffaa@gmail.com>
References: <0abeec42-a11d-3a51-453b-6acf76604f2e@sberdevices.ru>
 <20230309162150.qqrlqmqghi5muucx@sgarzare-redhat>
 <a1788ed6-89d4-27da-a049-99e29edea4cb@sberdevices.ru>
 <20230309163200.lq6dzop724diafpf@sgarzare-redhat>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
In-Reply-To: <20230309163200.lq6dzop724diafpf@sgarzare-redhat>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH01.sberdevices.ru (172.16.1.4) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/09 18:14:00 #20929517
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 09.03.2023 19:32, Stefano Garzarella wrote:
> On Thu, Mar 09, 2023 at 07:20:20PM +0300, Arseniy Krasnov wrote:
>>
>>
>> On 09.03.2023 19:21, Stefano Garzarella wrote:
>>> On Thu, Mar 09, 2023 at 01:10:36PM +0300, Arseniy Krasnov wrote:
>>>> Hello,
>>>>
>>>> this patchset evolved from previous v2 version (see link below). It does
>>>> several updates to virtio/vsock:
>>>> 1) Changes 'virtio_transport_inc/dec_rx_pkt()' interface. Now instead of
>>>>   using skbuff state ('head' and 'data' pointers) to update 'fwd_cnt'
>>>>   and 'rx_bytes', integer value is passed as an input argument. This
>>>>   makes code more simple, because in this case we don't need to udpate
>>>>   skbuff state before calling 'virtio_transport_inc/dec_rx_pkt()'. In
>>>>   more common words - we don't need to change skbuff state to update
>>>>   'rx_bytes' and 'fwd_cnt' correctly.
>>>> 2) For SOCK_STREAM, when copying data to user fails, current skbuff is
>>>>   not dropped. Next read attempt will use same skbuff and last offset.
>>>>   Instead of 'skb_dequeue()', 'skb_peek()' + '__skb_unlink()' are used.
>>>>   This behaviour was implemented before skbuff support.
>>>> 3) For SOCK_SEQPACKET it removes unneeded 'skb_pull()' call, because for
>>>>   this type of socket each skbuff is used only once: after removing it
>>>>   from socket's queue, it will be freed anyway.
>>>>
>>>> Test for 2) also added:
>>>> Test tries to 'recv()' data to NULL buffer, then does 'recv()' with valid
>>>> buffer. For SOCK_STREAM second 'recv()' must return data, because skbuff
>>>> must not be dropped, but for SOCK_SEQPACKET skbuff will be dropped by
>>>> kernel, and 'recv()' will return EAGAIN.
>>>>
>>>> Link to v1 on lore:
>>>> https://lore.kernel.org/netdev/c2d3e204-89d9-88e9-8a15-3fe027e56b4b@sberdevices.ru/
>>>>
>>>> Link to v2 on lore:
>>>> https://lore.kernel.org/netdev/a7ab414b-5e41-c7b6-250b-e8401f335859@sberdevices.ru/
>>>>
>>>> Change log:
>>>>
>>>> v1 -> v2:
>>>> - For SOCK_SEQPACKET call 'skb_pull()' also in case of copy failure or
>>>>   dropping skbuff (when we just waiting message end).
>>>> - Handle copy failure for SOCK_STREAM in the same manner (plus free
>>>>   current skbuff).
>>>> - Replace bug repdroducer with new test in vsock_test.c
>>>>
>>>> v2 -> v3:
>>>> - Replace patch which removes 'skb->len' subtraction from function
>>>>   'virtio_transport_dec_rx_pkt()' with patch which updates functions
>>>>   'virtio_transport_inc/dec_rx_pkt()' by passing integer argument
>>>>   instead of skbuff pointer.
>>>> - Replace patch which drops skbuff when copying to user fails with
>>>>   patch which changes this behaviour by keeping skbuff in queue until
>>>>   it has no data.
>>>> - Add patch for SOCK_SEQPACKET which removes redundant 'skb_pull()'
>>>>   call on read.
>>>> - I remove "Fixes" tag from all patches, because all of them now change
>>>>   code logic, not only fix something.
>>>
>>> Yes, but they solve the problem, so we should use the tag (I think at
>>> least in patch 1 and 3).
>>>
>>> We usually use the tag when we are fixing a problem introduced by a
>>> previous change. So we need to backport the patch to the stable branches
>>> as well, and we need the tag to figure out which branches have the patch
>>> or not.
>> Ahh, sorry. Ok. I see now :)
> 
> No problem at all :-)
> 
> I think also patch 2 can have the Fixes tag.
> 
Done, fixed everything in v4.

Thanks, Arseniy

> Thanks,
> Stefano
> 
>>
>> Thanks, Arseniy
>>>
>>> Thanks,
>>> Stefano
>>>
>>>>
>>>> Arseniy Krasnov (4):
>>>>  virtio/vsock: don't use skbuff state to account credit
>>>>  virtio/vsock: remove redundant 'skb_pull()' call
>>>>  virtio/vsock: don't drop skbuff on copy failure
>>>>  test/vsock: copy to user failure test
>>>>
>>>> net/vmw_vsock/virtio_transport_common.c |  29 +++---
>>>> tools/testing/vsock/vsock_test.c        | 118 ++++++++++++++++++++++++
>>>> 2 files changed, 131 insertions(+), 16 deletions(-)
>>>>
>>>> -- 
>>>> 2.25.1
>>>>
>>>
>>
> 
