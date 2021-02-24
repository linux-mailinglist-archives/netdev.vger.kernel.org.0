Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC5203238AE
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 09:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233594AbhBXIdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 03:33:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54435 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234377AbhBXIdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 03:33:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614155497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l0HrWwkL16o0meAWImXIYrDByJmCFS+wi7i0wF+mFwY=;
        b=JPBPEE2RdaAqu2fvTnyU1QyldDvtJeoJa5qsKbdg5QscSCavL7TFoX49tt4Joqse4YvFru
        DbAnvyV/wti3IjSKIPWAx8ua99xVnTYexaQ6f/OlOHbLy8HYPRY+cHk/JScAhQ5Xeo+Rt2
        l4LivE9SUw7hPY6BdY0h37SRgMUBgP4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-465-XQR8g8yrNGavVK57wxYzZw-1; Wed, 24 Feb 2021 03:31:35 -0500
X-MC-Unique: XQR8g8yrNGavVK57wxYzZw-1
Received: by mail-wr1-f71.google.com with SMTP id e29so709745wra.12
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 00:31:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=l0HrWwkL16o0meAWImXIYrDByJmCFS+wi7i0wF+mFwY=;
        b=JWT6KhUcFoxtdrAwrtWBbG972uSLluZkMFyi89dbeR6/xl4TVlmycOmyCDlqEPHWxE
         P8GOGUS7L5A5vFcLK+hSfczlCIWBJh3rESM8Hg8w8MGxtjMqT4g+jvMgdUEeAtxrLaQh
         vjpR8SRt3xuasqXb/H/UePFOUkoKyWvgwnXydRPAy21uUPqy6Y3sXn/fLuLkXDt9+0z0
         Zw0ZXtuMvSEM2qAKJyEB36DNlU5KUdxw3Yadj8D1gPWmm3A93r1ozNVQgfuXfrlxJeV4
         BoNf/Ff6UTDiZ+kUSpzMB42/hJ542s3fNvhXIx8YLK9Q/KWex2oIST7BKEJKj+ne0zHY
         zl0w==
X-Gm-Message-State: AOAM532rPVOEbIebkZex0u7byre1n2VC6DkMYvPJMCSmDTyaafhbVx+R
        KP50DZqDzmhHF3sgK7zAu6EkJfQQz8bs8XRAKd+4W/9Rljwdy1DCQSLae8Ei0YYt0DS1z30qwjd
        qvLM7ph6GH+MkNUBx
X-Received: by 2002:a1c:6441:: with SMTP id y62mr2585327wmb.97.1614155494007;
        Wed, 24 Feb 2021 00:31:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxsQGoIzVSWP5+5g7spt3MNrQhWmx+1VxmR4CjO/smQx8f4YhGjMFMPDtLZDQYXU0xVPDBNJQ==
X-Received: by 2002:a1c:6441:: with SMTP id y62mr2585305wmb.97.1614155493814;
        Wed, 24 Feb 2021 00:31:33 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id v6sm2063310wrx.32.2021.02.24.00.31.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 00:31:33 -0800 (PST)
Date:   Wed, 24 Feb 2021 09:31:30 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v5 11/19] virtio/vsock: dequeue callback for
 SOCK_SEQPACKET
Message-ID: <20210224083130.j5ik4ndk3afmb73y@steredhat>
References: <20210218053347.1066159-1-arseny.krasnov@kaspersky.com>
 <20210218053940.1068164-1-arseny.krasnov@kaspersky.com>
 <20210223091536-mutt-send-email-mst@kernel.org>
 <661fd81f-daf5-a3eb-6946-8f4e83d1ee54@kaspersky.com>
 <20210224002315-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210224002315-mutt-send-email-mst@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 24, 2021 at 01:41:56AM -0500, Michael S. Tsirkin wrote:
>On Wed, Feb 24, 2021 at 08:07:48AM +0300, Arseny Krasnov wrote:
>>
>> On 23.02.2021 17:17, Michael S. Tsirkin wrote:
>> > On Thu, Feb 18, 2021 at 08:39:37AM +0300, Arseny Krasnov wrote:
>> >> This adds transport callback and it's logic for SEQPACKET dequeue.
>> >> Callback fetches RW packets from rx queue of socket until whole record
>> >> is copied(if user's buffer is full, user is not woken up). This is done
>> >> to not stall sender, because if we wake up user and it leaves syscall,
>> >> nobody will send credit update for rest of record, and sender will wait
>> >> for next enter of read syscall at receiver's side. So if user buffer is
>> >> full, we just send credit update and drop data. If during copy SEQ_BEGIN
>> >> was found(and not all data was copied), copying is restarted by reset
>> >> user's iov iterator(previous unfinished data is dropped).
>> >>
>> >> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>> >> ---
>> >>  include/linux/virtio_vsock.h            |  10 +++
>> >>  include/uapi/linux/virtio_vsock.h       |  16 ++++
>> >>  net/vmw_vsock/virtio_transport_common.c | 114 ++++++++++++++++++++++++
>> >>  3 files changed, 140 insertions(+)
>> >>
>> >> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>> >> index dc636b727179..003d06ae4a85 100644
>> >> --- a/include/linux/virtio_vsock.h
>> >> +++ b/include/linux/virtio_vsock.h
>> >> @@ -36,6 +36,11 @@ struct virtio_vsock_sock {
>> >>  	u32 rx_bytes;
>> >>  	u32 buf_alloc;
>> >>  	struct list_head rx_queue;
>> >> +
>> >> +	/* For SOCK_SEQPACKET */
>> >> +	u32 user_read_seq_len;
>> >> +	u32 user_read_copied;
>> >> +	u32 curr_rx_msg_cnt;
>> >
>> > wrap these in a struct to make it's clearer they
>> > are related?
>> Ack
>> >
>> >>  };
>> >>
>> >>  struct virtio_vsock_pkt {
>> >> @@ -80,6 +85,11 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
>> >>  			       struct msghdr *msg,
>> >>  			       size_t len, int flags);
>> >>
>> >> +int
>> >> +virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
>> >> +				   struct msghdr *msg,
>> >> +				   int flags,
>> >> +				   bool *msg_ready);
>> >>  s64 virtio_transport_stream_has_data(struct vsock_sock *vsk);
>> >>  s64 virtio_transport_stream_has_space(struct vsock_sock *vsk);
>> >>
>> >> diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
>> >> index 1d57ed3d84d2..cf9c165e5cca 100644
>> >> --- a/include/uapi/linux/virtio_vsock.h
>> >> +++ b/include/uapi/linux/virtio_vsock.h
>> >> @@ -63,8 +63,14 @@ struct virtio_vsock_hdr {
>> >>  	__le32	fwd_cnt;
>> >>  } __attribute__((packed));
>> >>
>> >> +struct virtio_vsock_seq_hdr {
>> >> +	__le32  msg_cnt;
>> >> +	__le32  msg_len;
>> >> +} __attribute__((packed));
>> >> +
>> >>  enum virtio_vsock_type {
>> >>  	VIRTIO_VSOCK_TYPE_STREAM = 1,
>> >> +	VIRTIO_VSOCK_TYPE_SEQPACKET = 2,
>> >>  };
>> >>
>> >>  enum virtio_vsock_op {
>> >> @@ -83,6 +89,11 @@ enum virtio_vsock_op {
>> >>  	VIRTIO_VSOCK_OP_CREDIT_UPDATE = 6,
>> >>  	/* Request the peer to send the credit info to us */
>> >>  	VIRTIO_VSOCK_OP_CREDIT_REQUEST = 7,
>> >> +
>> >> +	/* Record begin for SOCK_SEQPACKET */
>> >> +	VIRTIO_VSOCK_OP_SEQ_BEGIN = 8,
>> >> +	/* Record end for SOCK_SEQPACKET */
>> >> +	VIRTIO_VSOCK_OP_SEQ_END = 9,
>> >>  };
>> >>
>> >>  /* VIRTIO_VSOCK_OP_SHUTDOWN flags values */
>> >> @@ -91,4 +102,9 @@ enum virtio_vsock_shutdown {
>> >>  	VIRTIO_VSOCK_SHUTDOWN_SEND = 2,
>> >>  };
>> >>
>> >> +/* VIRTIO_VSOCK_OP_RW flags values */
>> >> +enum virtio_vsock_rw {
>> >> +	VIRTIO_VSOCK_RW_EOR = 1,
>> >> +};
>> >> +
>> >>  #endif /* _UAPI_LINUX_VIRTIO_VSOCK_H */
>> > Probably a good idea to also have a feature bit gating
>> > this functionality.
>>
>> IIUC this also requires some qemu patch, because in current
>>
>> implementation of vsock device in qemu, there is no 'set_features'
>>
>> callback for such device. This callback will handle guest's write
>>
>> to feature register, by calling vhost kernel backend, where this
>>
>> bit will be processed by host.
>
>Well patching userspace to make use of a kernel feature
>is par for the course, isn't it?
>
>>
>> IMHO I'm not sure that SEQPACKET support needs feature
>>
>> bit - it is just two new ops for virtio vsock protocol, and from point
>>
>> of view of virtio device it is same as STREAM. May be it is needed
>>
>> for cases when client tries to connect to server which doesn't support
>>
>> SEQPACKET, so without bit result will be "Connection reset by peer",
>>
>> and with such bit client will know that server doesn't support it and
>>
>> 'socket(SOCK_SEQPACKET)' will return error?
>
>Yes, a better error handling would be one reason to do it like this.

Agree, in this way we could implement a 'seqpacket_allow' callback 
(similar to 'stream_allow'), and we can return 'true' if the feature is 
negotiated.

So instead of checking all the seqpacket callbacks, we can use only this 
callback to understand if the transport support it.
We can implement it also for other transports (vmci, hyperv) and return 
always false for now.

Thanks,
Stefano

