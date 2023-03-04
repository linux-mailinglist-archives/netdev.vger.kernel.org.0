Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1E06AA95A
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 12:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbjCDL4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Mar 2023 06:56:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjCDL4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Mar 2023 06:56:46 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C5E51CF63;
        Sat,  4 Mar 2023 03:56:43 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id E0B4C5FD06;
        Sat,  4 Mar 2023 14:56:40 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1677931000;
        bh=7qfzvVdKEr4IJNXGP2dAPhrdfNxpE3d77PssvtlsIyQ=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=MNd4X+TMrfwgC0uGm4bwk5UJot2vPhp5C49vKksPRrlxBYsKx5hdwRxLBTZANICCH
         4DdxjTVfitQxrsPVaRZ5HK1dSbsACP0Ndusg3RG7Os5Z0bVzM4TRGDvgpuvvqX9/Dc
         G7NxveTwSIX69IvM0+JEMCBnMuF3/jxEFcrE+0K5JYBAt3W7GgQ/ulUSKZ3WZHYO0v
         YVuBmWjuTX2fRfM2ziay9iVbS/1QLBrPqDjIZaGYEiOysznDn5UwyEHM+R+zRg7mxJ
         uXaTGbfkugD7Ruc/ToYt9jlxZWMflp0/DtpODft3Nhdc40zQUkjZq4D+EVJMmAIP/4
         MVNvuMXsC51YQ==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sat,  4 Mar 2023 14:56:35 +0300 (MSK)
Message-ID: <f7ce6794-c7c8-5f83-f63e-381a1e3a5bf7@sberdevices.ru>
Date:   Sat, 4 Mar 2023 14:53:44 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [External] [RFC PATCH v1 3/3] virtio/vsock: remove all data from
 sk_buff
Content-Language: en-US
To:     "Robert Eshleman ." <bobby.eshleman@bytedance.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@sberdevices.ru>, <oxffffaa@gmail.com>
References: <c2d3e204-89d9-88e9-8a15-3fe027e56b4b@sberdevices.ru>
 <b6fe000f-5638-28d0-525f-ce38cc2cb036@sberdevices.ru>
 <CALa-AnCu8g+jt1m_rY0QJFcRUhtWJ64Txro69j9KsnK7hyuBMg@mail.gmail.com>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
In-Reply-To: <CALa-AnCu8g+jt1m_rY0QJFcRUhtWJ64Txro69j9KsnK7hyuBMg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH02.sberdevices.ru (172.16.1.5) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/04 07:52:00 #20914547
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 04.03.2023 02:00, Robert Eshleman . wrote:
> On Fri, Mar 3, 2023 at 2:05 PM Arseniy Krasnov <avkrasnov@sberdevices.ru>
> wrote:
> 
>> In case of SOCK_SEQPACKET all sk_buffs are used once - after read some
>> data from it, it will be removed, so user will never read rest of the
>> data. Thus we need to update credit parameters of the socket like whole
>> sk_buff is read - so call 'skb_pull()' for the whole buffer.
>>
>> Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")
>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>> ---
>>  net/vmw_vsock/virtio_transport_common.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/vmw_vsock/virtio_transport_common.c
>> b/net/vmw_vsock/virtio_transport_common.c
>> index d80075e1db42..bbcf331b6ad6 100644
>> --- a/net/vmw_vsock/virtio_transport_common.c
>> +++ b/net/vmw_vsock/virtio_transport_common.c
>> @@ -470,7 +470,7 @@ static int
>> virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
>>                                         dequeued_len = err;
>>                                 } else {
>>                                         user_buf_len -= bytes_to_copy;
>> -                                       skb_pull(skb, bytes_to_copy);
>> +                                       skb_pull(skb, skb->len);
>>                                 }
>>
>>
> I believe this may also need to be done when memcpy_to_msg() returns an
> error.
Hello! Thanks for quick reply. Yes, moreover  in case of SEQPACKET 'skb_pull()' must be called
every time when skbuff was removed from queue - it doesn't matter did we copy data from, get
error on memcpy_to_msg(), or just drop it - otherwise we get leak of 'rx_bytes'.

Also in case of STREAM, skb_pull() must be called for the rest of data in skbuff in case of error,
because again - 'rx_bytes' will leak.

I think, i'll prepare fixes and tests for this case in the next week

Thanks, Arseniy
> 
> Best,
> Bobby
> 
