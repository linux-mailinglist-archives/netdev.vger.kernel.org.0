Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6455B6AC587
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 16:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbjCFPgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 10:36:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231313AbjCFPf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 10:35:58 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08DE337565;
        Mon,  6 Mar 2023 07:35:10 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 19F595FD14;
        Mon,  6 Mar 2023 18:34:18 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1678116858;
        bh=RSUKrXIb1U//ArYC4yt6V+3V6yJMpsLLUrAx18rhF+M=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=VSMXayR7DO53U2lKdaOW347JcfCLaYeZzL/C0IOS3fxQyDmr05ag2/xrlc9KKJMd9
         M2R1FyNF4qH3Iq8I5pHtGs3lPykJpJ+/qnDIeMvBLxZgUNuMAAKF4UeS3ICSGwYf+X
         c81UIUlKyt+pKGUvcm1Vm4jWYA+Vp8lEISDH83Y3oA5EICntrtjSmR6g6E3LaU4bZn
         +kAhEVWfodZXLrzc7o7HHa8Fq2STYXAXls+cghCquLUuML6r/CyS+fYHMO3EXj6xie
         eIU3AHWsNx48bF1h5U0JuRyGo7M2QELQqbFm5qLO/cdbl5TMuMGPWi7DOpQ6lKnGSe
         t1SITkYojgy0Q==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Mon,  6 Mar 2023 18:34:17 +0300 (MSK)
Message-ID: <b18e3b13-3386-e9ee-c817-59588e6d5fb6@sberdevices.ru>
Date:   Mon, 6 Mar 2023 18:31:22 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v2 2/4] virtio/vsock: remove all data from sk_buff
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
References: <a7ab414b-5e41-c7b6-250b-e8401f335859@sberdevices.ru>
 <dfadea17-a91e-105f-c213-a73f9731c8bd@sberdevices.ru>
 <20230306120857.6flftb3fftmsceyl@sgarzare-redhat>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
In-Reply-To: <20230306120857.6flftb3fftmsceyl@sgarzare-redhat>
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
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/06 11:48:00 #20919088
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 06.03.2023 15:08, Stefano Garzarella wrote:
> On Sun, Mar 05, 2023 at 11:07:37PM +0300, Arseniy Krasnov wrote:
>> In case of SOCK_SEQPACKET all sk_buffs are used once - after read some
>> data from it, it will be removed, so user will never read rest of the
>> data. Thus we need to update credit parameters of the socket like whole
>> sk_buff is read - so call 'skb_pull()' for the whole buffer.
>>
>> Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")
>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>> ---
>> net/vmw_vsock/virtio_transport_common.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Maybe we could avoid this patch if we directly use pkt_len as I
> suggested in the previous patch.
Hm, may be we can avoid calling 'skb_pull()' here if 'virtio_transport_dec_rx_pkt()'
will use integer argument? Just call 'virtio_transport_dec_rx_pkt(skb->len)'. skb
is never returned to queue to read it again, so i think may be there is no sense for
extra call 'skb_pull'?

Thanks, Arseniy
> 
> Thanks,
> Stefano
> 
>>
>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>> index 2e2a773df5c1..30b0539990ba 100644
>> --- a/net/vmw_vsock/virtio_transport_common.c
>> +++ b/net/vmw_vsock/virtio_transport_common.c
>> @@ -466,7 +466,6 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
>>                     dequeued_len = err;
>>                 } else {
>>                     user_buf_len -= bytes_to_copy;
>> -                    skb_pull(skb, bytes_to_copy);
>>                 }
>>
>>                 spin_lock_bh(&vvs->rx_lock);
>> @@ -484,6 +483,7 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
>>                 msg->msg_flags |= MSG_EOR;
>>         }
>>
>> +        skb_pull(skb, skb->len);
>>         virtio_transport_dec_rx_pkt(vvs, skb);
>>         kfree_skb(skb);
>>     }
>> -- 
>> 2.25.1
>>
> 
