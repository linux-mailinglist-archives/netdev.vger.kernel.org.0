Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF9743AE6F2
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 12:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbhFUKZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 06:25:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34767 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229621AbhFUKZk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 06:25:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624271006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=17jrUzT4jshvnBr/GQQE2JZlgBMr8a3t05HmI0DNTg4=;
        b=AJmnOAq+jmNmfyYJ72L0s8qgjDHwT7fxoD88WCbGIrcaLImbM84LHQa9rHWBs/y851XLRk
        6Al0WIssDlH2a3ar5R5ZLSoRlcpGHPIwF+kjuYuPXGqfxGAZ/0E87asJT8Ov0xVJUu7tZE
        u/kx/theVZWkp5PDYXWYAubhJcOfNTU=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-o4QlPwxZOZOBzF6XTFpbLw-1; Mon, 21 Jun 2021 06:23:24 -0400
X-MC-Unique: o4QlPwxZOZOBzF6XTFpbLw-1
Received: by mail-ej1-f70.google.com with SMTP id k1-20020a17090666c1b029041c273a883dso6181521ejp.3
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 03:23:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=17jrUzT4jshvnBr/GQQE2JZlgBMr8a3t05HmI0DNTg4=;
        b=gbkXbWWJm81UXXK8D4+ZoPQTAXnughSZYDhtF8syf3lqznGa5bRD9jyVtftHF/fFYx
         gQtpMzqL7h/ks+zhiF9F0vQ4cnD7yLMQsdvXZ2mrwZgKhOdUxoOruro5NNGsVwnoJFs8
         uaq+T0igoohXNBccpiVUe/93mrCq1Fsg2DRLuHlOjiYEIGAiN/35NcJhkmpd64jjWz1R
         J6yzr7t4gbrCbhxqbEGPDjCSObvIxH1Aw+emtm00bZZUmsZDrWP0ROQHZYS2fT9Lls/y
         kKkHicEX/vDuu6shklNoarXMW6IcckeNeQSTHN0fbAPKNunUzyR5ANz+vfevNQAx/eVW
         S5mA==
X-Gm-Message-State: AOAM533SfFMzKaRzUo+ETuAISoxVpkZA3TxsxSjtuvyBxXid/Q8xEh8o
        Mmea4KXapgfClIwtJAOJUBjlvHIhQDP5iaTzVt3cnRX9BiMSbECoj9/CeiyFuV3YoDWHw3xtfch
        xRjbSK+5vqW5/f+Dn
X-Received: by 2002:aa7:cd9a:: with SMTP id x26mr20286031edv.185.1624271003538;
        Mon, 21 Jun 2021 03:23:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwCpoPvlmrYqsoTqeuc70ych3y5ZMPCLAOlDvljTKxKtpookqp3Z/KFfPo8f0D5bYXz/2+t4w==
X-Received: by 2002:aa7:cd9a:: with SMTP id x26mr20286013edv.185.1624271003350;
        Mon, 21 Jun 2021 03:23:23 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id ch17sm10434983edb.42.2021.06.21.03.23.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 03:23:22 -0700 (PDT)
Date:   Mon, 21 Jun 2021 12:23:20 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
Subject: Re: [MASSMAIL KLMS] Re: [PATCH v11 11/18] virtio/vsock: dequeue
 callback for SOCK_SEQPACKET
Message-ID: <20210621102320.4uaqaee74yynnn2q@steredhat>
References: <20210611110744.3650456-1-arseny.krasnov@kaspersky.com>
 <20210611111241.3652274-1-arseny.krasnov@kaspersky.com>
 <20210618134423.mksgnbmchmow4sgh@steredhat.lan>
 <bb323125-f802-1d16-7530-6e4f4abb00a6@kaspersky.com>
 <20210618155555.j5p4v6j5gk2dboj3@steredhat.lan>
 <650673dc-8b29-657e-5bbd-2cc974628ec9@kaspersky.com>
 <20210618162509.yppkajmvcbzvidy4@steredhat.lan>
 <31f58b17-02e6-4246-5ad8-7e8d7892ecb7@kaspersky.com>
 <b27d3fd1-fa8a-97ff-9035-cf3f525d5866@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b27d3fd1-fa8a-97ff-9035-cf3f525d5866@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 21, 2021 at 09:55:13AM +0300, Arseny Krasnov wrote:
>
>On 18.06.2021 19:26, Arseny Krasnov wrote:
>> On 18.06.2021 19:25, Stefano Garzarella wrote:
>>> On Fri, Jun 18, 2021 at 07:08:30PM +0300, Arseny Krasnov wrote:
>>>> On 18.06.2021 18:55, Stefano Garzarella wrote:
>>>>> On Fri, Jun 18, 2021 at 06:04:37PM +0300, Arseny Krasnov wrote:
>>>>>> On 18.06.2021 16:44, Stefano Garzarella wrote:
>>>>>>> Hi Arseny,
>>>>>>> the series looks great, I have just a question below about
>>>>>>> seqpacket_dequeue.
>>>>>>>
>>>>>>> I also sent a couple a simple fixes, it would be great if you can review
>>>>>>> them:
>>>>>>> https://lore.kernel.org/netdev/20210618133526.300347-1-sgarzare@redhat.com/
>>>>>>>
>>>>>>>
>>>>>>> On Fri, Jun 11, 2021 at 02:12:38PM +0300, Arseny Krasnov wrote:
>>>>>>>> Callback fetches RW packets from rx queue of socket until whole record
>>>>>>>> is copied(if user's buffer is full, user is not woken up). This is done
>>>>>>>> to not stall sender, because if we wake up user and it leaves syscall,
>>>>>>>> nobody will send credit update for rest of record, and sender will wait
>>>>>>>> for next enter of read syscall at receiver's side. So if user buffer is
>>>>>>>> full, we just send credit update and drop data.
>>>>>>>>
>>>>>>>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>>>>>>>> ---
>>>>>>>> v10 -> v11:
>>>>>>>> 1) 'msg_count' field added to count current number of EORs.
>>>>>>>> 2) 'msg_ready' argument removed from callback.
>>>>>>>> 3) If 'memcpy_to_msg()' failed during copy loop, there will be
>>>>>>>>    no next attempts to copy data, rest of record will be freed.
>>>>>>>>
>>>>>>>> include/linux/virtio_vsock.h            |  5 ++
>>>>>>>> net/vmw_vsock/virtio_transport_common.c | 84 +++++++++++++++++++++++++
>>>>>>>> 2 files changed, 89 insertions(+)
>>>>>>>>
>>>>>>>> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>>>>>>>> index dc636b727179..1d9a302cb91d 100644
>>>>>>>> --- a/include/linux/virtio_vsock.h
>>>>>>>> +++ b/include/linux/virtio_vsock.h
>>>>>>>> @@ -36,6 +36,7 @@ struct virtio_vsock_sock {
>>>>>>>> 	u32 rx_bytes;
>>>>>>>> 	u32 buf_alloc;
>>>>>>>> 	struct list_head rx_queue;
>>>>>>>> +	u32 msg_count;
>>>>>>>> };
>>>>>>>>
>>>>>>>> struct virtio_vsock_pkt {
>>>>>>>> @@ -80,6 +81,10 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
>>>>>>>> 			       struct msghdr *msg,
>>>>>>>> 			       size_t len, int flags);
>>>>>>>>
>>>>>>>> +ssize_t
>>>>>>>> +virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
>>>>>>>> +				   struct msghdr *msg,
>>>>>>>> +				   int flags);
>>>>>>>> s64 virtio_transport_stream_has_data(struct vsock_sock *vsk);
>>>>>>>> s64 virtio_transport_stream_has_space(struct vsock_sock *vsk);
>>>>>>>>
>>>>>>>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>>>>>>>> index ad0d34d41444..1e1df19ec164 100644
>>>>>>>> --- a/net/vmw_vsock/virtio_transport_common.c
>>>>>>>> +++ b/net/vmw_vsock/virtio_transport_common.c
>>>>>>>> @@ -393,6 +393,78 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>>>>>>>> 	return err;
>>>>>>>> }
>>>>>>>>
>>>>>>>> +static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
>>>>>>>> +						 struct msghdr *msg,
>>>>>>>> +						 int flags)
>>>>>>>> +{
>>>>>>>> +	struct virtio_vsock_sock *vvs = vsk->trans;
>>>>>>>> +	struct virtio_vsock_pkt *pkt;
>>>>>>>> +	int dequeued_len = 0;
>>>>>>>> +	size_t user_buf_len = msg_data_left(msg);
>>>>>>>> +	bool copy_failed = false;
>>>>>>>> +	bool msg_ready = false;
>>>>>>>> +
>>>>>>>> +	spin_lock_bh(&vvs->rx_lock);
>>>>>>>> +
>>>>>>>> +	if (vvs->msg_count == 0) {
>>>>>>>> +		spin_unlock_bh(&vvs->rx_lock);
>>>>>>>> +		return 0;
>>>>>>>> +	}
>>>>>>>> +
>>>>>>>> +	while (!msg_ready) {
>>>>>>>> +		pkt = list_first_entry(&vvs->rx_queue, struct virtio_vsock_pkt, list);
>>>>>>>> +
>>>>>>>> +		if (!copy_failed) {
>>>>>>>> +			size_t pkt_len;
>>>>>>>> +			size_t bytes_to_copy;
>>>>>>>> +
>>>>>>>> +			pkt_len = (size_t)le32_to_cpu(pkt->hdr.len);
>>>>>>>> +			bytes_to_copy = min(user_buf_len, pkt_len);
>>>>>>>> +
>>>>>>>> +			if (bytes_to_copy) {
>>>>>>>> +				int err;
>>>>>>>> +
>>>>>>>> +				/* sk_lock is held by caller so no one else can dequeue.
>>>>>>>> +				 * Unlock rx_lock since memcpy_to_msg() may sleep.
>>>>>>>> +				 */
>>>>>>>> +				spin_unlock_bh(&vvs->rx_lock);
>>>>>>>> +
>>>>>>>> +				err = memcpy_to_msg(msg, pkt->buf, bytes_to_copy);
>>>>>>>> +				if (err) {
>>>>>>>> +					/* Copy of message failed, set flag to skip
>>>>>>>> +					 * copy path for rest of fragments. Rest of
>>>>>>>> +					 * fragments will be freed without copy.
>>>>>>>> +					 */
>>>>>>>> +					copy_failed = true;
>>>>>>>> +					dequeued_len = err;
>>>>>>> If we fail to copy the message we will discard the entire packet.
>>>>>>> Is it acceptable for the user point of view, or we should leave the
>>>>>>> packet in the queue and the user can retry, maybe with a different
>>>>>>> buffer?
>>>>>>>
>>>>>>> Then we can remove the packets only when we successfully copied all the
>>>>>>> fragments.
>>>>>>>
>>>>>>> I'm not sure make sense, maybe better to check also other
>>>>>>> implementations :-)
>>>>>>>
>>>>>>> Thanks,
>>>>>>> Stefano
>>>>>> Understand, i'll check it on weekend, anyway I think it is
>>>>>> not critical for implementation.
>>>>> Yep, I agree.
>>>>>
>>>>>> I have another question: may be it is useful to research for
>>>>>> approach where packets are not queued until whole message
>>>>>> is received, but copied to user's buffer thus freeing memory.
>>>>>> (like previous implementation, of course with solution of problem
>>>>>> where part of message still in queue, while reader was woken
>>>>>> by timeout or signal).
>>>>>>
>>>>>> I think it is better, because  in current version, sender may set
>>>>>> 'peer_alloc_buf' to  for example 1MB, so at receiver we get
>>>>>> 1MB of 'kmalloc()' memory allocated, while having user's buffer
>>>>>> to copy data there or drop it(if user's buffer is full). This way
>>>>>> won't change spec(e.g. no message id or SEQ_BEGIN will be added).
>>>>>>
>>>>>> What do You think?
>>>>> Yep, I see your point and it would be great, but I think the main issues
>>>>> to fix is how to handle a signal while we are waiting other fragments
>>>>> since the other peer can take unspecified time to send them.
>>>> What about transport callback, something like 'seqpacket_drain()' or
>>>>
>>>> 'seqpacket_drop_curr()' - when we got signal or timeout, notify transport
>>>>
>>>> to drop current message. In virtio case this will set special flag in transport,
>>>>
>>>> so on next dequeue, this flag is checked and if it is set - we drop all packets
>>>>
>>>> until EOR found. Then we can copy untouched new record.
>>>>
>>> But in this way, we will lose the entire message.
>>>
>>> Is it acceptable for seqpacket?
>>>
>>> Stefano
>> Hm, i'll check it. At least for unix domain sockets - it supports SEQPACKET
>
>Hello, i've checked AF_UNIX and AF_AX25 SEQPACKET implementations,

Great! Thanks for checking!

>
>in both cases:
>
>1) Datagram is dequeued first, then copied to user's buffer.
>
>2) Datagram is also freed when copying to user's buffer fail
>
>(it is not reinserted back).
>
>
>But, in case of virtio vsock, i've got the following concern in

>this approach: in cases of AF_UNIX or AF_AX25 there is maximum
>
>datagram size, strictly limited by spec, so no 'setsockopt()' call allows
>
>to exceed this. Also these limits are significantly smaller that current
>
>amounts of RAM. But, in our case, there is no such limit: peer could
>
>say 'i want to use 100MB datagram', and receiver just answer 'ok',

The receiver sets the limit of its receive buffer and tells the 
transmitter that it should not exceed it. The default should be 256 KB, 
so IIUC this scenario can happen only if the receiver do a 
'setsockopt()' increasing the limit to 100MB. Right?

Maybe we should limit it.

>
> as there is just variable assignment to setup new limit. Now, consider
>
>that there will be 10 peers, 100MB each(no one limit such request,
>
>because each socket doesn't know about each other). I think we get
>
>out-of-service in this case - all kmalloc() memory will be wasted for
>
>pending record.
>
>
>I still think, that approach when we copy data from packet to user's
>
>buffer without waiting EOR is better.

Okay, in this way we can remove the receive buffer limit and maybe if we 
receive a signal, we can set MSG_TRUNC, return the partially received 
packet to the user, but we must free any next fragments.

So, as you proposed, we need a `seqpacket_drop()` to tell to the 
transport that if we were copying an uncompleted message, then it should 
delete the queued fragments and any others until the next EOR.

>
>
>Also i'll rebase QEMU patch today or tomorrow.

Great, please CC me, this is something high priority to test 
SOCK_SEQPACKET with a guest.

>
>
>What do You Think?

I'm fine with both, but I slightly prefer the approach we implemented 
because it's easier to handle.

Thanks,
Stefano

