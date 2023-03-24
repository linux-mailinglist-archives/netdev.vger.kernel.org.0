Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B44D6C7ADF
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 10:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231654AbjCXJKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 05:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231282AbjCXJKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 05:10:19 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC5AB1D92F;
        Fri, 24 Mar 2023 02:10:15 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 5BDFC5FD1D;
        Fri, 24 Mar 2023 12:10:12 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1679649012;
        bh=hc4KthXSfnFDS34hFLlimKi1eV0GiOnrGO7YkZq4pX4=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=I7A6NbwM5sEpic0w1ouIQSv7nf61x2WL4ZofE6xnf9qPllsyIa0WuYQKnvfZBJi6U
         Hl0/OGGwjLFB+GDAmlUyGLnaMnt6S6CF5WlBZyGOtSMEGVd90oOPobrLazW0kc9G6f
         cO3kVvojmvMQJA505JMtrvAfJy/tw5FXoCNUuVdGtccbv72g8/w0h3oTjZPAZFeVKz
         XXpI0WA7/T8Vkuhhbv99qK20hvW9y3YX75eMXIxMSoHg12ferKLSkeLSS4GqufjywV
         nLtlGF4P6mocDdxxDT+ZwZIj/WUczpka5kK2nYyBjjiJ314D9wOQhubvOsI8N2kBg6
         FwMw0+YBGZlag==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Fri, 24 Mar 2023 12:10:07 +0300 (MSK)
Message-ID: <46ba9b55-c6ff-925c-d51a-8da9d1abd2f2@sberdevices.ru>
Date:   Fri, 24 Mar 2023 12:06:54 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [syzbot] [kvm?] [net?] [virt?] general protection fault in
 virtio_transport_purge_skbs
Content-Language: en-US
To:     Stefano Garzarella <sgarzare@redhat.com>,
        syzbot <syzbot+befff0a9536049e7902e@syzkaller.appspotmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Bobby Eshleman <bobby.eshleman@gmail.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <stefanha@redhat.com>, <syzkaller-bugs@googlegroups.com>,
        <virtualization@lists.linux-foundation.org>,
        Krasnov Arseniy <oxffffaa@gmail.com>
References: <000000000000708b1005f79acf5c@google.com>
 <CAGxU2F4ZiNEyrZzEJnYjYDz6CxniPGNW7AwyMLPLTxA2UbBWhA@mail.gmail.com>
 <CAGxU2F6m4KWXwOF8StjWbb=S6HRx=GhV_ONDcZxCZsDkvuaeUg@mail.gmail.com>
 <CAGxU2F7XjdKgdKwfZMT-sdJ+JK10p_2zNdaQeGBwm3jpEe1Xaw@mail.gmail.com>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
In-Reply-To: <CAGxU2F7XjdKgdKwfZMT-sdJ+JK10p_2zNdaQeGBwm3jpEe1Xaw@mail.gmail.com>
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
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/24 06:52:00 #21002836
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 24.03.2023 12:06, Stefano Garzarella wrote:
> On Fri, Mar 24, 2023 at 9:55 AM Stefano Garzarella <sgarzare@redhat.com> wrote:
>>
>> On Fri, Mar 24, 2023 at 9:31 AM Stefano Garzarella <sgarzare@redhat.com> wrote:
>>>
>>> Hi Bobby,
>>> can you take a look at this report?
>>>
>>> It seems related to the changes we made to support skbuff.
>>
>> Could it be a problem of concurrent access to pkt_queue ?
>>
>> IIUC we should hold pkt_queue.lock when we call skb_queue_splice_init()
>> and remove pkt_list_lock. (or hold pkt_list_lock when calling
>> virtio_transport_purge_skbs, but pkt_list_lock seems useless now that
>> we use skbuff)
>>
> 
> In the previous patch was missing a hunk, new one attached:
> 
> #syz test https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git fff5a5e7f528
> 
> --- a/net/vmw_vsock/vsock_loopback.c
> +++ b/net/vmw_vsock/vsock_loopback.c
> @@ -15,7 +15,6 @@
>  struct vsock_loopback {
>         struct workqueue_struct *workqueue;
> 
> -       spinlock_t pkt_list_lock; /* protects pkt_list */
>         struct sk_buff_head pkt_queue;
>         struct work_struct pkt_work;
>  };
> @@ -32,9 +31,7 @@ static int vsock_loopback_send_pkt(struct sk_buff *skb)
>         struct vsock_loopback *vsock = &the_vsock_loopback;
>         int len = skb->len;
> 
> -       spin_lock_bh(&vsock->pkt_list_lock);
>         skb_queue_tail(&vsock->pkt_queue, skb);
Hello Stefano and Bobby,

Small remark, may be here we can use virtio_vsock_skb_queue_tail() instead of skb_queue_tail().
skb_queue_tail() disables irqs during spinlock access, while  virtio_vsock_skb_queue_tail()
uses spin_lock_bh(). vhost and virtio transports use virtio_vsock_skb_queue_tail().

Thanks, Arseniy
> -       spin_unlock_bh(&vsock->pkt_list_lock);
> 
>         queue_work(vsock->workqueue, &vsock->pkt_work);
> 
> @@ -113,9 +110,9 @@ static void vsock_loopback_work(struct work_struct *work)
> 
>         skb_queue_head_init(&pkts);
> 
> -       spin_lock_bh(&vsock->pkt_list_lock);
> +       spin_lock_bh(&vsock->pkt_queue.lock);
>         skb_queue_splice_init(&vsock->pkt_queue, &pkts);
> -       spin_unlock_bh(&vsock->pkt_list_lock);
> +       spin_unlock_bh(&vsock->pkt_queue.lock);
> 
>         while ((skb = __skb_dequeue(&pkts))) {
>                 virtio_transport_deliver_tap_pkt(skb);
> @@ -132,7 +129,6 @@ static int __init vsock_loopback_init(void)
>         if (!vsock->workqueue)
>                 return -ENOMEM;
> 
> -       spin_lock_init(&vsock->pkt_list_lock);
>         skb_queue_head_init(&vsock->pkt_queue);
>         INIT_WORK(&vsock->pkt_work, vsock_loopback_work);
> 
> @@ -156,9 +152,7 @@ static void __exit vsock_loopback_exit(void)
> 
>         flush_work(&vsock->pkt_work);
> 
> -       spin_lock_bh(&vsock->pkt_list_lock);
>         virtio_vsock_skb_queue_purge(&vsock->pkt_queue);
> -       spin_unlock_bh(&vsock->pkt_list_lock);
> 
>         destroy_workqueue(vsock->workqueue);
>  }
> 
