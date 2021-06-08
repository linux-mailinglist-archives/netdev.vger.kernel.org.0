Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62B0539F3C1
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 12:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbhFHKmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 06:42:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55634 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230321AbhFHKl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 06:41:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623148804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nYNCs3JrvkX8VAnIEcTWaVkYHbhrJx9YKWDfXBQ1+cM=;
        b=TWPwvKYSGixwMeu/0zRoWV7tV8HTU52Q2W7PIswov44LJ4lwmIQgeMXAJtzOmHqkqnomlF
        2MHvjmDm5IwX/oZWIMgN12wtJZbJwBXsoWtRnYGK+pxXf8De0ML2i2z96VT3lUy5mjZPgo
        YspubmuInlbt3OD51mPhDGkqP2uK+WA=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-521-UZDGBTGsN9K0ZbKB24SUhA-1; Tue, 08 Jun 2021 06:40:03 -0400
X-MC-Unique: UZDGBTGsN9K0ZbKB24SUhA-1
Received: by mail-ej1-f71.google.com with SMTP id k1-20020a17090666c1b029041c273a883dso1995085ejp.3
        for <netdev@vger.kernel.org>; Tue, 08 Jun 2021 03:40:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=nYNCs3JrvkX8VAnIEcTWaVkYHbhrJx9YKWDfXBQ1+cM=;
        b=J9uV2NA9zHgrsMB5SY/joZSXY+2Bj0jiJ0teksezh4o2KWmjlbtuaR4kE3ZTUjPTp/
         4Xu0wjH0YjHwCoXn+6YVDu9OXOjj+yL4zm+SUOVi97z3hCs9IDvCepb09DkZuulO1iL/
         GM00bZeQaY4XIwDi8yOC8fAEBUgLovYXsHT5qvMBrgoQER3nhuBQo/R888kjrmumq6LV
         c+dkF1lSbHKs2H8y22vVHh5wjO6Ib8b3XqqJCggR4Ykbpq21p8HZPPmRHld8CAleaM59
         TjawWryWBOqtvVteP4CeEuQvASOICvd5oV/Wc1LUj5Yfl8kNDv7ow4H90Cii/oEa4rCs
         wNcA==
X-Gm-Message-State: AOAM531xlpEMCzp+EksP5vBnYS+DnkTihAWSFD5g76MCtp3Uae8Qxg18
        yHFRe2JNDF9HWqqyUIw1rxWS3kWJfyY4ui3P80b0dwssvMZGKr3xcpdJmWP0CG+YUogQ8UndMfl
        rbMHhnmaG60U/U7qc
X-Received: by 2002:aa7:d590:: with SMTP id r16mr25088231edq.355.1623148801777;
        Tue, 08 Jun 2021 03:40:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwlQjlTOLOUv+CTcpQo85ShyVO8Hm6Jf6YQcKP01+YfXsWs3sS1DIB86mFlcYsubeJp29IuCA==
X-Received: by 2002:aa7:d590:: with SMTP id r16mr25088212edq.355.1623148801544;
        Tue, 08 Jun 2021 03:40:01 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id g11sm8789689edt.85.2021.06.08.03.40.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 03:40:01 -0700 (PDT)
Date:   Tue, 8 Jun 2021 12:39:58 +0200
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
Message-ID: <20210608103958.5oqkqr2ydanfxx2s@steredhat>
References: <20210603144513.ryjzauq7abnjogu3@steredhat>
 <6b833ccf-ea93-db6a-4743-463ac1cfe817@kaspersky.com>
 <20210604150324.winiikx5h3p6gsyy@steredhat>
 <a81ae3cb-439f-7621-4ae6-bccd2c25b7e4@kaspersky.com>
 <20210607110421.wkx4dj7wipwsqztj@steredhat>
 <8e2eb802-7c5d-70b0-82b5-ec8de4fdc046@kaspersky.com>
 <20210608082320.vs2tzgpxgr2dhxye@steredhat>
 <3c35f04a-8406-d26f-27d0-becbd3c43c1b@kaspersky.com>
 <20210608101952.6meiasy7zqp474sf@steredhat>
 <8ca7fe68-81b7-8984-bf0f-db2384985988@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8ca7fe68-81b7-8984-bf0f-db2384985988@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 08, 2021 at 01:24:58PM +0300, Arseny Krasnov wrote:
>
>On 08.06.2021 13:19, Stefano Garzarella wrote:
>> On Tue, Jun 08, 2021 at 12:40:39PM +0300, Arseny Krasnov wrote:
>>> On 08.06.2021 11:23, Stefano Garzarella wrote:
>>>> On Mon, Jun 07, 2021 at 04:18:38PM +0300, Arseny Krasnov wrote:
>>>>> On 07.06.2021 14:04, Stefano Garzarella wrote:
>>>>>> On Fri, Jun 04, 2021 at 09:03:26PM +0300, Arseny Krasnov wrote:
>>>>>>> On 04.06.2021 18:03, Stefano Garzarella wrote:
>>>>>>>> On Fri, Jun 04, 2021 at 04:12:23PM +0300, Arseny Krasnov wrote:
>>>>>>>>> On 03.06.2021 17:45, Stefano Garzarella wrote:
>>>>>>>>>> On Thu, May 20, 2021 at 10:17:58PM +0300, Arseny Krasnov wrote:
>>>>>>>>>>> Callback fetches RW packets from rx queue of socket until whole record
>>>>>>>>>>> is copied(if user's buffer is full, user is not woken up). This is done
>>>>>>>>>>> to not stall sender, because if we wake up user and it leaves syscall,
>>>>>>>>>>> nobody will send credit update for rest of record, and sender will wait
>>>>>>>>>>> for next enter of read syscall at receiver's side. So if user buffer is
>>>>>>>>>>> full, we just send credit update and drop data.
>>>>>>>>>>>
>>>>>>>>>>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>>>>>>>>>>> ---
>>>>>>>>>>> v9 -> v10:
>>>>>>>>>>> 1) Number of dequeued bytes incremented even in case when
>>>>>>>>>>>    user's buffer is full.
>>>>>>>>>>> 2) Use 'msg_data_left()' instead of direct access to 'msg_hdr'.
>>>>>>>>>>> 3) Rename variable 'err' to 'dequeued_len', in case of error
>>>>>>>>>>>    it has negative value.
>>>>>>>>>>>
>>>>>>>>>>> include/linux/virtio_vsock.h            |  5 ++
>>>>>>>>>>> net/vmw_vsock/virtio_transport_common.c | 65 +++++++++++++++++++++++++
>>>>>>>>>>> 2 files changed, 70 insertions(+)
>>>>>>>>>>>
>>>>>>>>>>> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>>>>>>>>>>> index dc636b727179..02acf6e9ae04 100644
>>>>>>>>>>> --- a/include/linux/virtio_vsock.h
>>>>>>>>>>> +++ b/include/linux/virtio_vsock.h
>>>>>>>>>>> @@ -80,6 +80,11 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
>>>>>>>>>>> 			       struct msghdr *msg,
>>>>>>>>>>> 			       size_t len, int flags);
>>>>>>>>>>>
>>>>>>>>>>> +ssize_t
>>>>>>>>>>> +virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
>>>>>>>>>>> +				   struct msghdr *msg,
>>>>>>>>>>> +				   int flags,
>>>>>>>>>>> +				   bool *msg_ready);
>>>>>>>>>>> s64 virtio_transport_stream_has_data(struct vsock_sock *vsk);
>>>>>>>>>>> s64 virtio_transport_stream_has_space(struct vsock_sock *vsk);
>>>>>>>>>>>
>>>>>>>>>>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>>>>>>>>>>> index ad0d34d41444..61349b2ea7fe 100644
>>>>>>>>>>> --- a/net/vmw_vsock/virtio_transport_common.c
>>>>>>>>>>> +++ b/net/vmw_vsock/virtio_transport_common.c
>>>>>>>>>>> @@ -393,6 +393,59 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>>>>>>>>>>> 	return err;
>>>>>>>>>>> }
>>>>>>>>>>>
>>>>>>>>>>> +static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
>>>>>>>>>>> +						 struct msghdr *msg,
>>>>>>>>>>> +						 int flags,
>>>>>>>>>>> +						 bool *msg_ready)
>>>>>>>>>>> +{
>>>>>>>>>>> +	struct virtio_vsock_sock *vvs = vsk->trans;
>>>>>>>>>>> +	struct virtio_vsock_pkt *pkt;
>>>>>>>>>>> +	int dequeued_len = 0;
>>>>>>>>>>> +	size_t user_buf_len = msg_data_left(msg);
>>>>>>>>>>> +
>>>>>>>>>>> +	*msg_ready = false;
>>>>>>>>>>> +	spin_lock_bh(&vvs->rx_lock);
>>>>>>>>>>> +
>>>>>>>>>>> +	while (!*msg_ready && !list_empty(&vvs->rx_queue) && dequeued_len >= 0) {
>>>>>>>>>> I'
>>>>>>>>>>
>>>>>>>>>>> +		size_t bytes_to_copy;
>>>>>>>>>>> +		size_t pkt_len;
>>>>>>>>>>> +
>>>>>>>>>>> +		pkt = list_first_entry(&vvs->rx_queue, struct virtio_vsock_pkt, list);
>>>>>>>>>>> +		pkt_len = (size_t)le32_to_cpu(pkt->hdr.len);
>>>>>>>>>>> +		bytes_to_copy = min(user_buf_len, pkt_len);
>>>>>>>>>>> +
>>>>>>>>>>> +		if (bytes_to_copy) {
>>>>>>>>>>> +			/* sk_lock is held by caller so no one else can dequeue.
>>>>>>>>>>> +			 * Unlock rx_lock since memcpy_to_msg() may sleep.
>>>>>>>>>>> +			 */
>>>>>>>>>>> +			spin_unlock_bh(&vvs->rx_lock);
>>>>>>>>>>> +
>>>>>>>>>>> +			if (memcpy_to_msg(msg, pkt->buf, bytes_to_copy))
>>>>>>>>>>> +				dequeued_len = -EINVAL;
>>>>>>>>>> I think here is better to return the error returned by memcpy_to_msg(),
>>>>>>>>>> as we do in the other place where we use memcpy_to_msg().
>>>>>>>>>>
>>>>>>>>>> I mean something like this:
>>>>>>>>>> 			err = memcpy_to_msgmsg, pkt->buf, bytes_to_copy);
>>>>>>>>>> 			if (err)
>>>>>>>>>> 				dequeued_len = err;
>>>>>>>>> Ack
>>>>>>>>>>> +			else
>>>>>>>>>>> +				user_buf_len -= bytes_to_copy;
>>>>>>>>>>> +
>>>>>>>>>>> +			spin_lock_bh(&vvs->rx_lock);
>>>>>>>>>>> +		}
>>>>>>>>>>> +
>>>>>>>>>> Maybe here we can simply break the cycle if we have an error:
>>>>>>>>>> 		if (dequeued_len < 0)
>>>>>>>>>> 			break;
>>>>>>>>>>
>>>>>>>>>> Or we can refactor a bit, simplifying the while() condition and also the
>>>>>>>>>> code in this way (not tested):
>>>>>>>>>>
>>>>>>>>>> 	while (!*msg_ready && !list_empty(&vvs->rx_queue)) {
>>>>>>>>>> 		...
>>>>>>>>>>
>>>>>>>>>> 		if (bytes_to_copy) {
>>>>>>>>>> 			int err;
>>>>>>>>>>
>>>>>>>>>> 			/* ...
>>>>>>>>>> 			*/
>>>>>>>>>> 			spin_unlock_bh(&vvs->rx_lock);
>>>>>>>>>> 			err = memcpy_to_msgmsg, pkt->buf, bytes_to_copy);
>>>>>>>>>> 			if (err) {
>>>>>>>>>> 				dequeued_len = err;
>>>>>>>>>> 				goto out;
>>>>>>>>>> 			}
>>>>>>>>>> 			spin_lock_bh(&vvs->rx_lock);
>>>>>>>>>>
>>>>>>>>>> 			user_buf_len -= bytes_to_copy;
>>>>>>>>>> 		}
>>>>>>>>>>
>>>>>>>>>> 		dequeued_len += pkt_len;
>>>>>>>>>>
>>>>>>>>>> 		if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR)
>>>>>>>>>> 			*msg_ready = true;
>>>>>>>>>>
>>>>>>>>>> 		virtio_transport_dec_rx_pkt(vvs, pkt);
>>>>>>>>>> 		list_del(&pkt->list);
>>>>>>>>>> 		virtio_transport_free_pkt(pkt);
>>>>>>>>>> 	}
>>>>>>>>>>
>>>>>>>>>> out:
>>>>>>>>>> 	spin_unlock_bh(&vvs->rx_lock);
>>>>>>>>>>
>>>>>>>>>> 	virtio_transport_send_credit_update(vsk);
>>>>>>>>>>
>>>>>>>>>> 	return dequeued_len;
>>>>>>>>>> }
>>>>>>>>> I think we can't do 'goto out' or break, because in case of error,
>>>>>>>>> we still need
>>>>>>>>> to free packet.
>>>>>>>> Didn't we have code that remove packets from a previous message?
>>>>>>>> I don't see it anymore.
>>>>>>>>
>>>>>>>> For example if we have 10 packets queued for a message (the 10th
>>>>>>>> packet
>>>>>>>> has the EOR flag) and the memcpy_to_msg() fails on the 2nd packet, with
>>>>>>>> you proposal we are freeing only the first 2 packets, the rest is there
>>>>>>>> and should be freed when reading the next message, but I don't see that
>>>>>>>> code.
>>>>>>>>
>>>>>>>> The same can happen if the recvmsg syscall is interrupted. In that case
>>>>>>>> we report that nothing was copied, but we freed the first N packets, so
>>>>>>>> they are lost but the other packets are still in the queue.
>>>>>>>>
>>>>>>>> Please check also the patch where we implemented
>>>>>>>> __vsock_seqpacket_recvmsg().
>>>>>>>>
>>>>>>>> I thinks we should free packets only when we are sure we copied them to
>>>>>>>> the user space.
>>>>>>> Hm, yes, this is problem. To solve it i can restore previous approach
>>>>>>> with seqbegin/seqend. In that case i can detect unfinished record and
>>>>>>> drop it's packets. Seems seqbegin will be a bit like
>>>>>>> VIRTIO_VSOCK_SEQ_EOR in flags
>>>>>>> field of header(e.g. VIRTIO_VSOCK_SEQ_BEGIN). Message id and length are
>>>>>>> unneeded,
>>>>>>> as channel considedered lossless. What do You think?
>>>>>>>
>>>>>> I think VIRTIO_VSOCK_SEQ_BEGIN is redundant, using only EOR should be
>>>>>> fine.
>>>>>>
>>>>>> When we receive EOR we know that this is the last packet on this message
>>>>>> and the next packet will be the first of a new message.
>>>>>>
>>>>>> What we should do is check that we have all the fragments of a packet
>>>>>> and return them all together, otherwise we have to say we have nothing.
>>>>>>
>>>>>> For example as we process packets from the vitqueue and queue them in
>>>>>> the rx_queue we could use a counter of how many EORs are in the
>>>>>> rx_queue, which we decrease in virtio_transport_seqpacket_do_dequeue()
>>>>>> when we copied all the fragments.
>>>>>>
>>>>>> If the counter is 0, we don't remove anything from the queue and
>>>>>> virtio_transport_seqpacket_do_dequeue() returns 0.
>>>>>>
>>>>>> So .seqpacket_dequeue should return 0 if there is not at least one
>>>>>> complete message, or return the entire message. A partial message should
>>>>>> never return.
>>>>>>
>>>>>> What do you think?
>>>>> I like it, i've implemented this approach in some early pre v1 versions.
>>>>>
>>>>> But in this case, credit update logic will be changed - in current implementation
>>>>>
>>>>> (both seqpacket and stream) credit update reply is sent when data is copied
>>>>>
>>>>> to user's buffer(e.g. we copy data somewhere, free packet and ready to process
>>>>>
>>>>> new packet). But if we don't touch user's buffer and keeping incoming packet in rx queue
>>>>>
>>>>> until whole record is ready, when to send credit update?
>>>> I think the best approach could be to send credit updates when we remove
>>>> them from the rx_queue.
>>> In that case, it will be impossible to send message bigger than size of rx buffer
>>>
>>> (e.g. credit allowed size), because packet will be queued without credit update
>>>
>>> reply until credit allowed reach 0.
>>>
>> Yep, but I think it is a reasonable limit for a datagram socket.
>>
>> Maybe we can add a check on the TX side, since we know this value and
>> return an error to the user.
>
>E.g., to before sending message  using SEQPACKET socket,
>
>i need to call setsockopt with SO_VM_SOCKETS_BUFFER_MAX_SIZE/
>
>SO_VM_SOCKETS_BUFFER_SIZE params to setup maximum message size,
>
>if user tries to send message bigger than it, return -EMSGSIZE ?
>

Yep, I mean the receiver side must set it (IIRC default is 256K).

In the transmitter side we can check it using `vvs->peer_buf_alloc` and 
return the error.

Stefano

