Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 117BF39F355
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 12:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbhFHKVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 06:21:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21002 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229626AbhFHKVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 06:21:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623147599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LXIgbsKcwmgL9PLadPLYMZ2Gr+lpa7CAtfsyCgK+hX8=;
        b=HtK7dgyy8kT70un37ipB8JbHT28SxcIuaCOjRVlSMeX9xsZIY2Tc4DJ8+wMk1YPaDP+dIP
        zYSAPj8v5HIBTOhioPcVJA7B76yh8wmfu+8qqvVZE6/LbShgHIEDEXMVHhsDVKm0zbFVTk
        0ml49qTzY+d3/tWymQ7RnoTG8RhjIQs=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-c-127m1JMimK0tq4-lE5kg-1; Tue, 08 Jun 2021 06:19:57 -0400
X-MC-Unique: c-127m1JMimK0tq4-lE5kg-1
Received: by mail-ed1-f69.google.com with SMTP id v8-20020a0564023488b0290393873961f6so3212887edc.17
        for <netdev@vger.kernel.org>; Tue, 08 Jun 2021 03:19:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LXIgbsKcwmgL9PLadPLYMZ2Gr+lpa7CAtfsyCgK+hX8=;
        b=QDt4fUdwRHoT2VFJuAqwL/s0Vl7YdYVaLsjBgrsbNLueIw8bXhQBo7fUZUsn/8i1y4
         Vjho7oN8wZNHpSM9xGK6Cht32YXKx/Ncyh/V4haAYIv2qE/gS+fsnttVZ96bML6ev47A
         pu5NZWk1zoKyA00jgxVDG/wupVUobdMK1SO3jja5mCgQWDcePeqNmM7Ys/gZkPRyGnB2
         mlB4P01nfeAfjYPG4IYc7rddv+UvlyOXSDAY/CK7AD/uXEruapeFYSQsqvHbrN2xDT4o
         RRraFUsGNGPHdRPLZwuORRSG02U4JGPC5FJSiy/MnedLxHGecPp0PjFyj2uXbfErX4lf
         t4VA==
X-Gm-Message-State: AOAM532F5xuuly63nqO7RE0tp+b84WT0jyrEJcRiZq3eox+7Wi2TLkXr
        iGjxi2WSVqibLG/ylIiBtJptY4oKX3tduzlSJ/yYdivoObzMI4o7Xd3r2dyi7vqXzmC+pKTYSeD
        Tb77o/iXiiZkZIjJT
X-Received: by 2002:a17:906:95c8:: with SMTP id n8mr23089763ejy.357.1623147596543;
        Tue, 08 Jun 2021 03:19:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz5wUbbDlIIvweICzCwTjiG7Tm9kIGjtWOLfZujQmHi0Zvn0GOo+Xu2PM623Z/LmpT6XzkaXg==
X-Received: by 2002:a17:906:95c8:: with SMTP id n8mr23089743ejy.357.1623147596314;
        Tue, 08 Jun 2021 03:19:56 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id f6sm7548251eja.108.2021.06.08.03.19.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 03:19:55 -0700 (PDT)
Date:   Tue, 8 Jun 2021 12:19:52 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
Subject: Re: [PATCH v10 11/18] virtio/vsock: dequeue callback for
 SOCK_SEQPACKET
Message-ID: <20210608101952.6meiasy7zqp474sf@steredhat>
References: <20210520191357.1270473-1-arseny.krasnov@kaspersky.com>
 <20210520191801.1272027-1-arseny.krasnov@kaspersky.com>
 <20210603144513.ryjzauq7abnjogu3@steredhat>
 <6b833ccf-ea93-db6a-4743-463ac1cfe817@kaspersky.com>
 <20210604150324.winiikx5h3p6gsyy@steredhat>
 <a81ae3cb-439f-7621-4ae6-bccd2c25b7e4@kaspersky.com>
 <20210607110421.wkx4dj7wipwsqztj@steredhat>
 <8e2eb802-7c5d-70b0-82b5-ec8de4fdc046@kaspersky.com>
 <20210608082320.vs2tzgpxgr2dhxye@steredhat>
 <3c35f04a-8406-d26f-27d0-becbd3c43c1b@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <3c35f04a-8406-d26f-27d0-becbd3c43c1b@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 08, 2021 at 12:40:39PM +0300, Arseny Krasnov wrote:
>
>On 08.06.2021 11:23, Stefano Garzarella wrote:
>> On Mon, Jun 07, 2021 at 04:18:38PM +0300, Arseny Krasnov wrote:
>>> On 07.06.2021 14:04, Stefano Garzarella wrote:
>>>> On Fri, Jun 04, 2021 at 09:03:26PM +0300, Arseny Krasnov wrote:
>>>>> On 04.06.2021 18:03, Stefano Garzarella wrote:
>>>>>> On Fri, Jun 04, 2021 at 04:12:23PM +0300, Arseny Krasnov wrote:
>>>>>>> On 03.06.2021 17:45, Stefano Garzarella wrote:
>>>>>>>> On Thu, May 20, 2021 at 10:17:58PM +0300, Arseny Krasnov wrote:
>>>>>>>>> Callback fetches RW packets from rx queue of socket until whole record
>>>>>>>>> is copied(if user's buffer is full, user is not woken up). This is done
>>>>>>>>> to not stall sender, because if we wake up user and it leaves syscall,
>>>>>>>>> nobody will send credit update for rest of record, and sender will wait
>>>>>>>>> for next enter of read syscall at receiver's side. So if user buffer is
>>>>>>>>> full, we just send credit update and drop data.
>>>>>>>>>
>>>>>>>>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>>>>>>>>> ---
>>>>>>>>> v9 -> v10:
>>>>>>>>> 1) Number of dequeued bytes incremented even in case when
>>>>>>>>>    user's buffer is full.
>>>>>>>>> 2) Use 'msg_data_left()' instead of direct access to 'msg_hdr'.
>>>>>>>>> 3) Rename variable 'err' to 'dequeued_len', in case of error
>>>>>>>>>    it has negative value.
>>>>>>>>>
>>>>>>>>> include/linux/virtio_vsock.h            |  5 ++
>>>>>>>>> net/vmw_vsock/virtio_transport_common.c | 65 +++++++++++++++++++++++++
>>>>>>>>> 2 files changed, 70 insertions(+)
>>>>>>>>>
>>>>>>>>> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>>>>>>>>> index dc636b727179..02acf6e9ae04 100644
>>>>>>>>> --- a/include/linux/virtio_vsock.h
>>>>>>>>> +++ b/include/linux/virtio_vsock.h
>>>>>>>>> @@ -80,6 +80,11 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
>>>>>>>>> 			       struct msghdr *msg,
>>>>>>>>> 			       size_t len, int flags);
>>>>>>>>>
>>>>>>>>> +ssize_t
>>>>>>>>> +virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
>>>>>>>>> +				   struct msghdr *msg,
>>>>>>>>> +				   int flags,
>>>>>>>>> +				   bool *msg_ready);
>>>>>>>>> s64 virtio_transport_stream_has_data(struct vsock_sock *vsk);
>>>>>>>>> s64 virtio_transport_stream_has_space(struct vsock_sock *vsk);
>>>>>>>>>
>>>>>>>>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>>>>>>>>> index ad0d34d41444..61349b2ea7fe 100644
>>>>>>>>> --- a/net/vmw_vsock/virtio_transport_common.c
>>>>>>>>> +++ b/net/vmw_vsock/virtio_transport_common.c
>>>>>>>>> @@ -393,6 +393,59 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>>>>>>>>> 	return err;
>>>>>>>>> }
>>>>>>>>>
>>>>>>>>> +static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
>>>>>>>>> +						 struct msghdr *msg,
>>>>>>>>> +						 int flags,
>>>>>>>>> +						 bool *msg_ready)
>>>>>>>>> +{
>>>>>>>>> +	struct virtio_vsock_sock *vvs = vsk->trans;
>>>>>>>>> +	struct virtio_vsock_pkt *pkt;
>>>>>>>>> +	int dequeued_len = 0;
>>>>>>>>> +	size_t user_buf_len = msg_data_left(msg);
>>>>>>>>> +
>>>>>>>>> +	*msg_ready = false;
>>>>>>>>> +	spin_lock_bh(&vvs->rx_lock);
>>>>>>>>> +
>>>>>>>>> +	while (!*msg_ready && !list_empty(&vvs->rx_queue) && dequeued_len >= 0) {
>>>>>>>> I'
>>>>>>>>
>>>>>>>>> +		size_t bytes_to_copy;
>>>>>>>>> +		size_t pkt_len;
>>>>>>>>> +
>>>>>>>>> +		pkt = list_first_entry(&vvs->rx_queue, struct virtio_vsock_pkt, list);
>>>>>>>>> +		pkt_len = (size_t)le32_to_cpu(pkt->hdr.len);
>>>>>>>>> +		bytes_to_copy = min(user_buf_len, pkt_len);
>>>>>>>>> +
>>>>>>>>> +		if (bytes_to_copy) {
>>>>>>>>> +			/* sk_lock is held by caller so no one else can dequeue.
>>>>>>>>> +			 * Unlock rx_lock since memcpy_to_msg() may sleep.
>>>>>>>>> +			 */
>>>>>>>>> +			spin_unlock_bh(&vvs->rx_lock);
>>>>>>>>> +
>>>>>>>>> +			if (memcpy_to_msg(msg, pkt->buf, bytes_to_copy))
>>>>>>>>> +				dequeued_len = -EINVAL;
>>>>>>>> I think here is better to return the error returned by memcpy_to_msg(),
>>>>>>>> as we do in the other place where we use memcpy_to_msg().
>>>>>>>>
>>>>>>>> I mean something like this:
>>>>>>>> 			err = memcpy_to_msgmsg, pkt->buf, bytes_to_copy);
>>>>>>>> 			if (err)
>>>>>>>> 				dequeued_len = err;
>>>>>>> Ack
>>>>>>>>> +			else
>>>>>>>>> +				user_buf_len -= bytes_to_copy;
>>>>>>>>> +
>>>>>>>>> +			spin_lock_bh(&vvs->rx_lock);
>>>>>>>>> +		}
>>>>>>>>> +
>>>>>>>> Maybe here we can simply break the cycle if we have an error:
>>>>>>>> 		if (dequeued_len < 0)
>>>>>>>> 			break;
>>>>>>>>
>>>>>>>> Or we can refactor a bit, simplifying the while() condition and also the
>>>>>>>> code in this way (not tested):
>>>>>>>>
>>>>>>>> 	while (!*msg_ready && !list_empty(&vvs->rx_queue)) {
>>>>>>>> 		...
>>>>>>>>
>>>>>>>> 		if (bytes_to_copy) {
>>>>>>>> 			int err;
>>>>>>>>
>>>>>>>> 			/* ...
>>>>>>>> 			*/
>>>>>>>> 			spin_unlock_bh(&vvs->rx_lock);
>>>>>>>> 			err = memcpy_to_msgmsg, pkt->buf, bytes_to_copy);
>>>>>>>> 			if (err) {
>>>>>>>> 				dequeued_len = err;
>>>>>>>> 				goto out;
>>>>>>>> 			}
>>>>>>>> 			spin_lock_bh(&vvs->rx_lock);
>>>>>>>>
>>>>>>>> 			user_buf_len -= bytes_to_copy;
>>>>>>>> 		}
>>>>>>>>
>>>>>>>> 		dequeued_len += pkt_len;
>>>>>>>>
>>>>>>>> 		if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR)
>>>>>>>> 			*msg_ready = true;
>>>>>>>>
>>>>>>>> 		virtio_transport_dec_rx_pkt(vvs, pkt);
>>>>>>>> 		list_del(&pkt->list);
>>>>>>>> 		virtio_transport_free_pkt(pkt);
>>>>>>>> 	}
>>>>>>>>
>>>>>>>> out:
>>>>>>>> 	spin_unlock_bh(&vvs->rx_lock);
>>>>>>>>
>>>>>>>> 	virtio_transport_send_credit_update(vsk);
>>>>>>>>
>>>>>>>> 	return dequeued_len;
>>>>>>>> }
>>>>>>> I think we can't do 'goto out' or break, because in case of error,
>>>>>>> we still need
>>>>>>> to free packet.
>>>>>> Didn't we have code that remove packets from a previous message?
>>>>>> I don't see it anymore.
>>>>>>
>>>>>> For example if we have 10 packets queued for a message (the 10th
>>>>>> packet
>>>>>> has the EOR flag) and the memcpy_to_msg() fails on the 2nd packet, with
>>>>>> you proposal we are freeing only the first 2 packets, the rest is there
>>>>>> and should be freed when reading the next message, but I don't see that
>>>>>> code.
>>>>>>
>>>>>> The same can happen if the recvmsg syscall is interrupted. In that case
>>>>>> we report that nothing was copied, but we freed the first N packets, so
>>>>>> they are lost but the other packets are still in the queue.
>>>>>>
>>>>>> Please check also the patch where we implemented
>>>>>> __vsock_seqpacket_recvmsg().
>>>>>>
>>>>>> I thinks we should free packets only when we are sure we copied them to
>>>>>> the user space.
>>>>> Hm, yes, this is problem. To solve it i can restore previous approach
>>>>> with seqbegin/seqend. In that case i can detect unfinished record and
>>>>> drop it's packets. Seems seqbegin will be a bit like
>>>>> VIRTIO_VSOCK_SEQ_EOR in flags
>>>>> field of header(e.g. VIRTIO_VSOCK_SEQ_BEGIN). Message id and length are
>>>>> unneeded,
>>>>> as channel considedered lossless. What do You think?
>>>>>
>>>> I think VIRTIO_VSOCK_SEQ_BEGIN is redundant, using only EOR should be
>>>> fine.
>>>>
>>>> When we receive EOR we know that this is the last packet on this message
>>>> and the next packet will be the first of a new message.
>>>>
>>>> What we should do is check that we have all the fragments of a packet
>>>> and return them all together, otherwise we have to say we have nothing.
>>>>
>>>> For example as we process packets from the vitqueue and queue them in
>>>> the rx_queue we could use a counter of how many EORs are in the
>>>> rx_queue, which we decrease in virtio_transport_seqpacket_do_dequeue()
>>>> when we copied all the fragments.
>>>>
>>>> If the counter is 0, we don't remove anything from the queue and
>>>> virtio_transport_seqpacket_do_dequeue() returns 0.
>>>>
>>>> So .seqpacket_dequeue should return 0 if there is not at least one
>>>> complete message, or return the entire message. A partial message should
>>>> never return.
>>>>
>>>> What do you think?
>>> I like it, i've implemented this approach in some early pre v1 versions.
>>>
>>> But in this case, credit update logic will be changed - in current implementation
>>>
>>> (both seqpacket and stream) credit update reply is sent when data is copied
>>>
>>> to user's buffer(e.g. we copy data somewhere, free packet and ready to process
>>>
>>> new packet). But if we don't touch user's buffer and keeping incoming packet in rx queue
>>>
>>> until whole record is ready, when to send credit update?
>> I think the best approach could be to send credit updates when we remove
>> them from the rx_queue.
>
>In that case, it will be impossible to send message bigger than size of rx buffer
>
>(e.g. credit allowed size), because packet will be queued without credit update
>
>reply until credit allowed reach 0.
>

Yep, but I think it is a reasonable limit for a datagram socket.

Maybe we can add a check on the TX side, since we know this value and 
return an error to the user.

Thanks,
Stefano

