Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43DEB3AD052
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 18:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235336AbhFRQ1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 12:27:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56064 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232990AbhFRQ1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 12:27:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624033524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fPUXuwIIMubJnCMUYIbK/KDXv25S7tj9NL4K7WirAU0=;
        b=chGdVdw2joN0P4bx/QL9HimcoERVS2Lbp2O1jlBshYoitZwRmO0vWzyGoiGQO5u0zQT6/p
        VMdKDMhLnviMeIeIlAawKFpeTJnL+oRyDoJsWJ3eKBJeSTWBgJy/LcP2dqBabwAr59njt0
        blxgcr//8yLb4YnSUg/jlQu5i9+9jZ8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-337-fF9H6lWQMn2LPo9-5Q9QCA-1; Fri, 18 Jun 2021 12:25:20 -0400
X-MC-Unique: fF9H6lWQMn2LPo9-5Q9QCA-1
Received: by mail-wm1-f69.google.com with SMTP id m33-20020a05600c3b21b02901a44b1d2d87so3970730wms.3
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 09:25:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=fPUXuwIIMubJnCMUYIbK/KDXv25S7tj9NL4K7WirAU0=;
        b=FDvALFQuEIE4Sl9AyLTL233yFq8TwVMhtb8dIBTrz9vZpYs4d4UKyciT0Qb5BbOE5e
         BMrF6GxfWsWo+wSS9C305W43k4D88JU8QdQCTKFaAZ6zpwT0eVsFK9T2mAGkFj9W16WY
         gPpqOvGi6NtUhauDlpp1I3skvEDu3kd3dqQOovJ5XFf7MbmtdHl/OOaHC6mX6szdxX58
         uC59yWOZFt2KxAqpOHxwiGJrqVxp52YdyDG9p4+sM7+AwKa3TxBxvqX273rYYClRGqCN
         pqZF5ZoKkWg5zZuAyXMPnmBE38++4PE5QCJ6pdSZZ66wRbTALw7GdRLNtx+vCEA/0tel
         VIRA==
X-Gm-Message-State: AOAM533Sub1RGsI5vdljjkO8VgRbn4r9WT2sYqiOdJAp+8mi6EmtoHaD
        dp/mQXvBa5GuNkKGifI/OqJ7UG44CDXawTxl+ckT7my4t/97JJOeV3KN8LjvuZYd9Aq4IhxQkZx
        LH2kI+sh9Aj6cXcTD
X-Received: by 2002:a7b:c24a:: with SMTP id b10mr12434112wmj.25.1624033519685;
        Fri, 18 Jun 2021 09:25:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwypvvAg3317DbyVnwhInIuaBYNfidXY9XCDlEhFKWAq87Ip2EXKAD5iESujtcowWxg2zw+hQ==
X-Received: by 2002:a7b:c24a:: with SMTP id b10mr12434092wmj.25.1624033519510;
        Fri, 18 Jun 2021 09:25:19 -0700 (PDT)
Received: from steredhat.lan ([5.170.128.175])
        by smtp.gmail.com with ESMTPSA id z12sm9045409wmc.5.2021.06.18.09.25.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 09:25:19 -0700 (PDT)
Date:   Fri, 18 Jun 2021 18:25:09 +0200
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
Message-ID: <20210618162509.yppkajmvcbzvidy4@steredhat.lan>
References: <20210611110744.3650456-1-arseny.krasnov@kaspersky.com>
 <20210611111241.3652274-1-arseny.krasnov@kaspersky.com>
 <20210618134423.mksgnbmchmow4sgh@steredhat.lan>
 <bb323125-f802-1d16-7530-6e4f4abb00a6@kaspersky.com>
 <20210618155555.j5p4v6j5gk2dboj3@steredhat.lan>
 <650673dc-8b29-657e-5bbd-2cc974628ec9@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <650673dc-8b29-657e-5bbd-2cc974628ec9@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 18, 2021 at 07:08:30PM +0300, Arseny Krasnov wrote:
>
>On 18.06.2021 18:55, Stefano Garzarella wrote:
>> On Fri, Jun 18, 2021 at 06:04:37PM +0300, Arseny Krasnov wrote:
>>> On 18.06.2021 16:44, Stefano Garzarella wrote:
>>>> Hi Arseny,
>>>> the series looks great, I have just a question below about
>>>> seqpacket_dequeue.
>>>>
>>>> I also sent a couple a simple fixes, it would be great if you can review
>>>> them:
>>>> https://lore.kernel.org/netdev/20210618133526.300347-1-sgarzare@redhat.com/
>>>>
>>>>
>>>> On Fri, Jun 11, 2021 at 02:12:38PM +0300, Arseny Krasnov wrote:
>>>>> Callback fetches RW packets from rx queue of socket until whole record
>>>>> is copied(if user's buffer is full, user is not woken up). This is done
>>>>> to not stall sender, because if we wake up user and it leaves syscall,
>>>>> nobody will send credit update for rest of record, and sender will wait
>>>>> for next enter of read syscall at receiver's side. So if user buffer is
>>>>> full, we just send credit update and drop data.
>>>>>
>>>>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>>>>> ---
>>>>> v10 -> v11:
>>>>> 1) 'msg_count' field added to count current number of EORs.
>>>>> 2) 'msg_ready' argument removed from callback.
>>>>> 3) If 'memcpy_to_msg()' failed during copy loop, there will be
>>>>>    no next attempts to copy data, rest of record will be freed.
>>>>>
>>>>> include/linux/virtio_vsock.h            |  5 ++
>>>>> net/vmw_vsock/virtio_transport_common.c | 84 +++++++++++++++++++++++++
>>>>> 2 files changed, 89 insertions(+)
>>>>>
>>>>> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>>>>> index dc636b727179..1d9a302cb91d 100644
>>>>> --- a/include/linux/virtio_vsock.h
>>>>> +++ b/include/linux/virtio_vsock.h
>>>>> @@ -36,6 +36,7 @@ struct virtio_vsock_sock {
>>>>> 	u32 rx_bytes;
>>>>> 	u32 buf_alloc;
>>>>> 	struct list_head rx_queue;
>>>>> +	u32 msg_count;
>>>>> };
>>>>>
>>>>> struct virtio_vsock_pkt {
>>>>> @@ -80,6 +81,10 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
>>>>> 			       struct msghdr *msg,
>>>>> 			       size_t len, int flags);
>>>>>
>>>>> +ssize_t
>>>>> +virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
>>>>> +				   struct msghdr *msg,
>>>>> +				   int flags);
>>>>> s64 virtio_transport_stream_has_data(struct vsock_sock *vsk);
>>>>> s64 virtio_transport_stream_has_space(struct vsock_sock *vsk);
>>>>>
>>>>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>>>>> index ad0d34d41444..1e1df19ec164 100644
>>>>> --- a/net/vmw_vsock/virtio_transport_common.c
>>>>> +++ b/net/vmw_vsock/virtio_transport_common.c
>>>>> @@ -393,6 +393,78 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>>>>> 	return err;
>>>>> }
>>>>>
>>>>> +static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
>>>>> +						 struct msghdr *msg,
>>>>> +						 int flags)
>>>>> +{
>>>>> +	struct virtio_vsock_sock *vvs = vsk->trans;
>>>>> +	struct virtio_vsock_pkt *pkt;
>>>>> +	int dequeued_len = 0;
>>>>> +	size_t user_buf_len = msg_data_left(msg);
>>>>> +	bool copy_failed = false;
>>>>> +	bool msg_ready = false;
>>>>> +
>>>>> +	spin_lock_bh(&vvs->rx_lock);
>>>>> +
>>>>> +	if (vvs->msg_count == 0) {
>>>>> +		spin_unlock_bh(&vvs->rx_lock);
>>>>> +		return 0;
>>>>> +	}
>>>>> +
>>>>> +	while (!msg_ready) {
>>>>> +		pkt = list_first_entry(&vvs->rx_queue, struct virtio_vsock_pkt, list);
>>>>> +
>>>>> +		if (!copy_failed) {
>>>>> +			size_t pkt_len;
>>>>> +			size_t bytes_to_copy;
>>>>> +
>>>>> +			pkt_len = (size_t)le32_to_cpu(pkt->hdr.len);
>>>>> +			bytes_to_copy = min(user_buf_len, pkt_len);
>>>>> +
>>>>> +			if (bytes_to_copy) {
>>>>> +				int err;
>>>>> +
>>>>> +				/* sk_lock is held by caller so no one else can dequeue.
>>>>> +				 * Unlock rx_lock since memcpy_to_msg() may sleep.
>>>>> +				 */
>>>>> +				spin_unlock_bh(&vvs->rx_lock);
>>>>> +
>>>>> +				err = memcpy_to_msg(msg, pkt->buf, bytes_to_copy);
>>>>> +				if (err) {
>>>>> +					/* Copy of message failed, set flag to skip
>>>>> +					 * copy path for rest of fragments. Rest of
>>>>> +					 * fragments will be freed without copy.
>>>>> +					 */
>>>>> +					copy_failed = true;
>>>>> +					dequeued_len = err;
>>>> If we fail to copy the message we will discard the entire packet.
>>>> Is it acceptable for the user point of view, or we should leave the
>>>> packet in the queue and the user can retry, maybe with a different
>>>> buffer?
>>>>
>>>> Then we can remove the packets only when we successfully copied all the
>>>> fragments.
>>>>
>>>> I'm not sure make sense, maybe better to check also other
>>>> implementations :-)
>>>>
>>>> Thanks,
>>>> Stefano
>>> Understand, i'll check it on weekend, anyway I think it is
>>> not critical for implementation.
>> Yep, I agree.
>>
>>>
>>> I have another question: may be it is useful to research for
>>> approach where packets are not queued until whole message
>>> is received, but copied to user's buffer thus freeing memory.
>>> (like previous implementation, of course with solution of problem
>>> where part of message still in queue, while reader was woken
>>> by timeout or signal).
>>>
>>> I think it is better, because  in current version, sender may set
>>> 'peer_alloc_buf' to  for example 1MB, so at receiver we get
>>> 1MB of 'kmalloc()' memory allocated, while having user's buffer
>>> to copy data there or drop it(if user's buffer is full). This way
>>> won't change spec(e.g. no message id or SEQ_BEGIN will be added).
>>>
>>> What do You think?
>> Yep, I see your point and it would be great, but I think the main issues
>> to fix is how to handle a signal while we are waiting other fragments
>> since the other peer can take unspecified time to send them.
>
>What about transport callback, something like 'seqpacket_drain()' or
>
>'seqpacket_drop_curr()' - when we got signal or timeout, notify transport
>
>to drop current message. In virtio case this will set special flag in transport,
>
>so on next dequeue, this flag is checked and if it is set - we drop all packets
>
>until EOR found. Then we can copy untouched new record.
>

But in this way, we will lose the entire message.

Is it acceptable for seqpacket?

Stefano

