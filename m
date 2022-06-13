Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97D34548242
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 10:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240288AbiFMIvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 04:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240176AbiFMIvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 04:51:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 911A3B1DD
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 01:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655110258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mpNKgbpx+78NLRf26/oOXOkBqasMpEHURTXeLdxK0yI=;
        b=EDQ/yHqsg+Cr5cFKZyuK/hbct2b7htcOintF36AVoXlcSFN0hU0gTs9VKddQ14vfe9dneS
        z/UONkvWaKrLJQO6jFG/ADUZE281FcgQO+zUpwqOnPp06H3b5N3nq6lZxkFvzt7OGKjfo9
        tzcf56QzgszvIMB/3c/Y+ud20j+lfyA=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-363-FvacA7Y8NsSrjLLQSMMmsg-1; Mon, 13 Jun 2022 04:50:57 -0400
X-MC-Unique: FvacA7Y8NsSrjLLQSMMmsg-1
Received: by mail-qk1-f200.google.com with SMTP id bl27-20020a05620a1a9b00b0069994eeb30cso4513498qkb.11
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 01:50:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=mpNKgbpx+78NLRf26/oOXOkBqasMpEHURTXeLdxK0yI=;
        b=1D0fOFa/LYtirAEtjlIfHpyOnf0txj9v9m8aYFACwrQKdWIrXSi8aerr1KOdZNHt7n
         hhZovRTwB21u+5RCBcxkU7BgtvRHZ4+dsFK7FiHwLcbIbj48eGZ50DzOMaBkRkd6K2bH
         mbSMg/ICqAqJwaYEkZFMhvg7uaQZkR172VcjimUi5jgEHLS+jegakYHjh9XNdPJcmn3A
         QIME6LVM31iMrn3RkUpOzk0fZ7zXoXCURewxyy9b2Oh99WNCHXCFnUajRM49h2ji0HdR
         ar9kF+M8jUUWxpVt4DC9IA5u7rfcw5V9JoSSds9YdoZpcxQcgZlIptmgeeg38qpPCJhD
         smeA==
X-Gm-Message-State: AOAM532KAb6pM5EFVvxnvMWmlWCSIkWd5OhDC4A7xdZTrd0Gu+WOvnSc
        qzmu7g5jVSzPjkV1oJfK47gkQSVp+kebw7GYsDKKMXpzBuyo/VfRWu69vL9lxQZBv7cU6WJeAcO
        KS9wCcWwJHK6fRocS
X-Received: by 2002:ac8:5904:0:b0:304:f0d0:ed16 with SMTP id 4-20020ac85904000000b00304f0d0ed16mr28949945qty.475.1655110257058;
        Mon, 13 Jun 2022 01:50:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwccVKGRgAaqpV1votdrIxrBJEruzT8HwAeGhXCKLdk7lNXAQV1g1JTpnyocJYZ53WI0waY1Q==
X-Received: by 2002:ac8:5904:0:b0:304:f0d0:ed16 with SMTP id 4-20020ac85904000000b00304f0d0ed16mr28949936qty.475.1655110256772;
        Mon, 13 Jun 2022 01:50:56 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-40.retail.telecomitalia.it. [79.46.200.40])
        by smtp.gmail.com with ESMTPSA id w18-20020ac87192000000b002f9114d2ebcsm4592355qto.17.2022.06.13.01.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 01:50:56 -0700 (PDT)
Date:   Mon, 13 Jun 2022 10:50:46 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>,
        Krasnov Arseniy <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v2 3/8] af_vsock: add zerocopy receive logic
Message-ID: <20220613085046.ee7cb2ye5yq5cbfo@sgarzare-redhat>
References: <e37fdf9b-be80-35e1-ae7b-c9dfeae3e3db@sberdevices.ru>
 <129aa328-ad4d-cb2c-4a51-4a2bf9c9be37@sberdevices.ru>
 <20220609083929.5k37tajo3qli4kr2@sgarzare-redhat>
 <204f5bc4-987e-a1ff-71e2-e51343e13f24@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <204f5bc4-987e-a1ff-71e2-e51343e13f24@sberdevices.ru>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 09, 2022 at 12:20:22PM +0000, Arseniy Krasnov wrote:
>On 09.06.2022 11:39, Stefano Garzarella wrote:
>> On Fri, Jun 03, 2022 at 05:35:48AM +0000, Arseniy Krasnov wrote:
>>> This:
>>> 1) Adds callback for 'mmap()' call on socket. It checks vm
>>>   area flags and sets vm area ops.
>>> 2) Adds special 'getsockopt()' case which calls transport
>>>   zerocopy callback. Input argument is vm area address.
>>> 3) Adds 'getsockopt()/setsockopt()' for switching on/off rx
>>>   zerocopy mode.
>>>
>>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>>> ---
>>> include/net/af_vsock.h          |   7 +++
>>> include/uapi/linux/vm_sockets.h |   3 +
>>> net/vmw_vsock/af_vsock.c        | 100 ++++++++++++++++++++++++++++++++
>>> 3 files changed, 110 insertions(+)
>>>
>>> diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>>> index f742e50207fb..f15f84c648ff 100644
>>> --- a/include/net/af_vsock.h
>>> +++ b/include/net/af_vsock.h
>>> @@ -135,6 +135,13 @@ struct vsock_transport {
>>>     bool (*stream_is_active)(struct vsock_sock *);
>>>     bool (*stream_allow)(u32 cid, u32 port);
>>>
>>> +    int (*rx_zerocopy_set)(struct vsock_sock *vsk,
>>> +                   bool enable);
>>> +    int (*rx_zerocopy_get)(struct vsock_sock *vsk);
>>> +    int (*zerocopy_dequeue)(struct vsock_sock *vsk,
>>> +                struct vm_area_struct *vma,
>>> +                unsigned long addr);
>>> +
>>>     /* SEQ_PACKET. */
>>>     ssize_t (*seqpacket_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
>>>                      int flags);
>>> diff --git a/include/uapi/linux/vm_sockets.h b/include/uapi/linux/vm_sockets.h
>>> index c60ca33eac59..d1f792bed1a7 100644
>>> --- a/include/uapi/linux/vm_sockets.h
>>> +++ b/include/uapi/linux/vm_sockets.h
>>> @@ -83,6 +83,9 @@
>>>
>>> #define SO_VM_SOCKETS_CONNECT_TIMEOUT_NEW 8
>>>
>>> +#define SO_VM_SOCKETS_MAP_RX 9
>>> +#define SO_VM_SOCKETS_ZEROCOPY 10
>>> +
>>> #if !defined(__KERNEL__)
>>> #if __BITS_PER_LONG == 64 || (defined(__x86_64__) && defined(__ILP32__))
>>> #define SO_VM_SOCKETS_CONNECT_TIMEOUT SO_VM_SOCKETS_CONNECT_TIMEOUT_OLD
>>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>>> index f04abf662ec6..10061ef21730 100644
>>> --- a/net/vmw_vsock/af_vsock.c
>>> +++ b/net/vmw_vsock/af_vsock.c
>>> @@ -1644,6 +1644,17 @@ static int vsock_connectible_setsockopt(struct socket *sock,
>>>         }
>>>         break;
>>>     }
>>> +    case SO_VM_SOCKETS_ZEROCOPY: {
>>> +        if (!transport || !transport->rx_zerocopy_set) {
>>> +            err = -EOPNOTSUPP;
>>> +        } else {
>>> +            COPY_IN(val);
>>> +
>>> +            if (transport->rx_zerocopy_set(vsk, val))
>>> +                err = -EINVAL;
>>> +        }
>>> +        break;
>>> +    }
>>>
>>>     default:
>>>         err = -ENOPROTOOPT;
>>> @@ -1657,6 +1668,48 @@ static int vsock_connectible_setsockopt(struct socket *sock,
>>>     return err;
>>> }
>>>
>>> +static const struct vm_operations_struct afvsock_vm_ops = {
>>> +};
>>> +
>>> +static int vsock_recv_zerocopy(struct socket *sock,
>>> +                   unsigned long address)
>>> +{
>>> +    struct sock *sk = sock->sk;
>>> +    struct vsock_sock *vsk = vsock_sk(sk);
>>> +    struct vm_area_struct *vma;
>>> +    const struct vsock_transport *transport;
>>> +    int res;
>>> +
>>> +    transport = vsk->transport;
>>> +
>>> +    if (!transport->rx_zerocopy_get)
>>> +        return -EOPNOTSUPP;
>>> +
>>> +    if (!transport->rx_zerocopy_get(vsk))
>>> +        return -EOPNOTSUPP;
>>
>> Maybe we can merge in
>>         if (!transport->rx_zerocopy_get ||
>>             !transport->rx_zerocopy_get(vsk)}
>>                 return -EOPNOTSUPP;
>>
>>> +
>>> +    if (!transport->zerocopy_dequeue)
>>> +        return -EOPNOTSUPP;
>>> +
>>> +    lock_sock(sk);
>>> +    mmap_write_lock(current->mm);
>>
>> So, multiple threads using different sockets are serialized if they use zero-copy?
>>
>> IIUC this is necessary because the callback calls vm_insert_page().
>>
>> At this point I think it's better not to do this in every transport, but have the callback return an array of pages to map and we map them here trying to limit as much as possible the critical section to protect with mmap_write_lock().
>
>Yes, it will be easy to return array of pages by transport callback,
>
>>
>>> +
>>> +    vma = vma_lookup(current->mm, address);
>>> +
>>> +    if (!vma || vma->vm_ops != &afvsock_vm_ops) {
>>> +        mmap_write_unlock(current->mm);
>>> +        release_sock(sk);
>>> +        return -EINVAL;
>>> +    }
>>> +
>>> +    res = transport->zerocopy_dequeue(vsk, vma, address);
>>> +
>>> +    mmap_write_unlock(current->mm);
>>> +    release_sock(sk);
>>> +
>>> +    return res;
>>> +}
>>> +
>>> static int vsock_connectible_getsockopt(struct socket *sock,
>>>                     int level, int optname,
>>>                     char __user *optval,
>>> @@ -1701,6 +1754,39 @@ static int vsock_connectible_getsockopt(struct socket *sock,
>>>         lv = sock_get_timeout(vsk->connect_timeout, &v,
>>>                       optname == SO_VM_SOCKETS_CONNECT_TIMEOUT_OLD);
>>>         break;
>>> +    case SO_VM_SOCKETS_ZEROCOPY: {
>>> +        const struct vsock_transport *transport;
>>> +        int res;
>>> +
>>> +        transport = vsk->transport;
>>> +
>>> +        if (!transport->rx_zerocopy_get)
>>> +            return -EOPNOTSUPP;
>>> +
>>> +        lock_sock(sk);
>>
>> I think we should call lock_sock() before reading the transport to avoid races and we should check if it is assigned.
>>
>> At that point I think is better to store this info in vsock_sock and not in the transport.
>You mean to store flag that zerocopy is enabled in 'vsock_sock', just reading it here, without touching transport?

Yep.

Thanks,
Stefano

