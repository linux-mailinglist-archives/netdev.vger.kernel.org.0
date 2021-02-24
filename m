Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00EB732377B
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 07:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233506AbhBXGnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 01:43:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35185 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232328AbhBXGnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 01:43:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614148924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s55ilkit8AyvB8H+EC0E/iht8b+fHdOebNn3zsK85Zo=;
        b=OrSR0MvT01Po2p14zuxWNYX6xxZAUYUamAgS7q02BQhOakV0ONjXAN2Ia6AU8Rh59tdybA
        yP2eltlaNrteeq8mOdajiBrgN+LMujGySOtaje3sIig69g+NhNp1awx1hnj63oGTWrZmdS
        pKCc2jEogE/bzz+/MHmmBHnooHw84wk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-uchx_F82P8q-0MgZgm1Fyg-1; Wed, 24 Feb 2021 01:42:02 -0500
X-MC-Unique: uchx_F82P8q-0MgZgm1Fyg-1
Received: by mail-wr1-f70.google.com with SMTP id v18so598602wrr.8
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 22:42:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=s55ilkit8AyvB8H+EC0E/iht8b+fHdOebNn3zsK85Zo=;
        b=S8CJOG8YTCA7nUOA46aS1hAmZhyYiDrSjmauQu1uMWtWZNq5omRhiu39alGqpAvQNb
         uqSHc3czCTI+4S07FAouiLIXfBZyFJGb55lQYyAkmtibqTb8EayQxOqYH3alPR9v7shA
         A6VTY4Z/Sc3id2MiCUhmyp5UtjleTIYlzpCufr5LhEPAruWL+ggWxD3V3C1Rux5ddorV
         rPgj9BskzdyNglpacrQly8yB9XMYPiDiMeRONq7eS63fv1Xt9V4TQ1zY2syZCL7udzVv
         mby7hmGWvg45XY/EJz6Qjda/1oDLG82deBu7uUap72JpPPUPc1dfPmDGoF5JDpUwU69o
         6fNA==
X-Gm-Message-State: AOAM5308T5Gq/7ajXh3yEjiz0ZxhWY1NjSgLlO3PxIf1c0FBqnaURuy7
        WyDfoseyKhK6uiCeaKU13Jr+NFJIXntvMcV4Lp7sI8EjFJfG+D+nprBOgxcNbQiJyKHKf3wZ+2U
        rU1VguxPRVNvU+qaQ
X-Received: by 2002:a05:6000:1542:: with SMTP id 2mr30358435wry.356.1614148921351;
        Tue, 23 Feb 2021 22:42:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwEyzdsr3Ow3I/chOE2lEJ38C0hLHhjGkBn0ZJ3D6ow25zrmvo6OLG2W707+P84HiKWMouE/g==
X-Received: by 2002:a05:6000:1542:: with SMTP id 2mr30358406wry.356.1614148921120;
        Tue, 23 Feb 2021 22:42:01 -0800 (PST)
Received: from redhat.com (bzq-79-180-2-31.red.bezeqint.net. [79.180.2.31])
        by smtp.gmail.com with ESMTPSA id n5sm1172955wmq.7.2021.02.23.22.41.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 22:42:00 -0800 (PST)
Date:   Wed, 24 Feb 2021 01:41:56 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
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
Message-ID: <20210224002315-mutt-send-email-mst@kernel.org>
References: <20210218053347.1066159-1-arseny.krasnov@kaspersky.com>
 <20210218053940.1068164-1-arseny.krasnov@kaspersky.com>
 <20210223091536-mutt-send-email-mst@kernel.org>
 <661fd81f-daf5-a3eb-6946-8f4e83d1ee54@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <661fd81f-daf5-a3eb-6946-8f4e83d1ee54@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 24, 2021 at 08:07:48AM +0300, Arseny Krasnov wrote:
> 
> On 23.02.2021 17:17, Michael S. Tsirkin wrote:
> > On Thu, Feb 18, 2021 at 08:39:37AM +0300, Arseny Krasnov wrote:
> >> This adds transport callback and it's logic for SEQPACKET dequeue.
> >> Callback fetches RW packets from rx queue of socket until whole record
> >> is copied(if user's buffer is full, user is not woken up). This is done
> >> to not stall sender, because if we wake up user and it leaves syscall,
> >> nobody will send credit update for rest of record, and sender will wait
> >> for next enter of read syscall at receiver's side. So if user buffer is
> >> full, we just send credit update and drop data. If during copy SEQ_BEGIN
> >> was found(and not all data was copied), copying is restarted by reset
> >> user's iov iterator(previous unfinished data is dropped).
> >>
> >> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
> >> ---
> >>  include/linux/virtio_vsock.h            |  10 +++
> >>  include/uapi/linux/virtio_vsock.h       |  16 ++++
> >>  net/vmw_vsock/virtio_transport_common.c | 114 ++++++++++++++++++++++++
> >>  3 files changed, 140 insertions(+)
> >>
> >> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
> >> index dc636b727179..003d06ae4a85 100644
> >> --- a/include/linux/virtio_vsock.h
> >> +++ b/include/linux/virtio_vsock.h
> >> @@ -36,6 +36,11 @@ struct virtio_vsock_sock {
> >>  	u32 rx_bytes;
> >>  	u32 buf_alloc;
> >>  	struct list_head rx_queue;
> >> +
> >> +	/* For SOCK_SEQPACKET */
> >> +	u32 user_read_seq_len;
> >> +	u32 user_read_copied;
> >> +	u32 curr_rx_msg_cnt;
> >
> > wrap these in a struct to make it's clearer they
> > are related?
> Ack
> >
> >>  };
> >>  
> >>  struct virtio_vsock_pkt {
> >> @@ -80,6 +85,11 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
> >>  			       struct msghdr *msg,
> >>  			       size_t len, int flags);
> >>  
> >> +int
> >> +virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
> >> +				   struct msghdr *msg,
> >> +				   int flags,
> >> +				   bool *msg_ready);
> >>  s64 virtio_transport_stream_has_data(struct vsock_sock *vsk);
> >>  s64 virtio_transport_stream_has_space(struct vsock_sock *vsk);
> >>  
> >> diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
> >> index 1d57ed3d84d2..cf9c165e5cca 100644
> >> --- a/include/uapi/linux/virtio_vsock.h
> >> +++ b/include/uapi/linux/virtio_vsock.h
> >> @@ -63,8 +63,14 @@ struct virtio_vsock_hdr {
> >>  	__le32	fwd_cnt;
> >>  } __attribute__((packed));
> >>  
> >> +struct virtio_vsock_seq_hdr {
> >> +	__le32  msg_cnt;
> >> +	__le32  msg_len;
> >> +} __attribute__((packed));
> >> +
> >>  enum virtio_vsock_type {
> >>  	VIRTIO_VSOCK_TYPE_STREAM = 1,
> >> +	VIRTIO_VSOCK_TYPE_SEQPACKET = 2,
> >>  };
> >>  
> >>  enum virtio_vsock_op {
> >> @@ -83,6 +89,11 @@ enum virtio_vsock_op {
> >>  	VIRTIO_VSOCK_OP_CREDIT_UPDATE = 6,
> >>  	/* Request the peer to send the credit info to us */
> >>  	VIRTIO_VSOCK_OP_CREDIT_REQUEST = 7,
> >> +
> >> +	/* Record begin for SOCK_SEQPACKET */
> >> +	VIRTIO_VSOCK_OP_SEQ_BEGIN = 8,
> >> +	/* Record end for SOCK_SEQPACKET */
> >> +	VIRTIO_VSOCK_OP_SEQ_END = 9,
> >>  };
> >>  
> >>  /* VIRTIO_VSOCK_OP_SHUTDOWN flags values */
> >> @@ -91,4 +102,9 @@ enum virtio_vsock_shutdown {
> >>  	VIRTIO_VSOCK_SHUTDOWN_SEND = 2,
> >>  };
> >>  
> >> +/* VIRTIO_VSOCK_OP_RW flags values */
> >> +enum virtio_vsock_rw {
> >> +	VIRTIO_VSOCK_RW_EOR = 1,
> >> +};
> >> +
> >>  #endif /* _UAPI_LINUX_VIRTIO_VSOCK_H */
> > Probably a good idea to also have a feature bit gating
> > this functionality.
> 
> IIUC this also requires some qemu patch, because in current
> 
> implementation of vsock device in qemu, there is no 'set_features'
> 
> callback for such device. This callback will handle guest's write
> 
> to feature register, by calling vhost kernel backend, where this
> 
> bit will be processed by host.

Well patching userspace to make use of a kernel feature
is par for the course, isn't it?

> 
> IMHO I'm not sure that SEQPACKET support needs feature
> 
> bit - it is just two new ops for virtio vsock protocol, and from point
> 
> of view of virtio device it is same as STREAM. May be it is needed
> 
> for cases when client tries to connect to server which doesn't support
> 
> SEQPACKET, so without bit result will be "Connection reset by peer",
> 
> and with such bit client will know that server doesn't support it and
> 
> 'socket(SOCK_SEQPACKET)' will return error?

Yes, a better error handling would be one reason to do it like this.

-- 
MST

