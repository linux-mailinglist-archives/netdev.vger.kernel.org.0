Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79B9037F73F
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 13:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbhEML7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 07:59:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55978 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231251AbhEML7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 07:59:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620907101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mHdwZTL+pvK8Zg99tTdQKEFKw4APO+UMqyfXLBZ12cw=;
        b=TPMz123/QZJ05xlKbDrNfcIqcQSPuXup8htC57gdVMxtB+bJxTmnHIJH5qeLpUB7/AF8bX
        Eog3D78Ujqnoetz2REFl9u1Z9jOCtvlU9sn8u18sU6+UFBGUXOcNstIe5Gf36pRZHqEUxF
        jMpdfhnRaWgtU+drUa2LeIgDy0ztPIA=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-p4xWfy7oOBeZWQuFJ0Uo5w-1; Thu, 13 May 2021 07:58:20 -0400
X-MC-Unique: p4xWfy7oOBeZWQuFJ0Uo5w-1
Received: by mail-ej1-f71.google.com with SMTP id z1-20020a1709068141b02903cd421d7803so2862707ejw.22
        for <netdev@vger.kernel.org>; Thu, 13 May 2021 04:58:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mHdwZTL+pvK8Zg99tTdQKEFKw4APO+UMqyfXLBZ12cw=;
        b=RH0ejFJLHIHx0napeemLBJJOVTni3y7JMuvk5mOgl8mREr21mNgfl2reS27JVTM/es
         SWZbAx4XZ9HIadlW42Ff93kKF7SSCrkec53zVKjad8DojKDtJOest01YyvPA2E7nHwyA
         a0CmPwB5ybrB4RkwEjzRdIru6fwSelnQTMPCz+E/erFJBj7SDiMInHc5KPi60GtZuECs
         O4r+whoUzVGxkR7r3rQwP0t1PCV4+s0aSrLpeyzEcQWOXd4m9Gq78fRqY0Zsz+XerYwR
         sS5Y0gtpq+2hu07zRe24GiyaqFtJHYaXoilR7FzX6xvBKtj7p63xGU8UrUo4DtFGEtmt
         D9bA==
X-Gm-Message-State: AOAM531VmHUTmbObU0qgs2wCw5VPY2osVzxT8bSse1QtAotrtGT2BbX7
        a4NOYz0DHQXJQgA2bRssK6gnLWVQbddgwwK8TBzwVT62Pm75vmdNbG35kCCROIDgRNO+3O68bZS
        uODl6FWdc5A9nGl4a
X-Received: by 2002:a17:906:3952:: with SMTP id g18mr8710571eje.138.1620907099239;
        Thu, 13 May 2021 04:58:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJytzhY86+D4jQaq9WMVx+063wiEyhp56IsRtO0CBtMRCrX7Xse2B2ObmWARquFYRp5Ry0+5mg==
X-Received: by 2002:a17:906:3952:: with SMTP id g18mr8710552eje.138.1620907099070;
        Thu, 13 May 2021 04:58:19 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id b25sm2288552edv.9.2021.05.13.04.58.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 04:58:18 -0700 (PDT)
Date:   Thu, 13 May 2021 13:58:16 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v9 11/19] virtio/vsock: dequeue callback for
 SOCK_SEQPACKET
Message-ID: <20210513115816.332nfej4jyra7vrh@steredhat>
References: <20210508163027.3430238-1-arseny.krasnov@kaspersky.com>
 <20210508163523.3431999-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210508163523.3431999-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 08, 2021 at 07:35:20PM +0300, Arseny Krasnov wrote:
>This adds transport callback and it's logic for SEQPACKET dequeue.
>Callback fetches RW packets from rx queue of socket until whole record
>is copied(if user's buffer is full, user is not woken up). This is done
>to not stall sender, because if we wake up user and it leaves syscall,
>nobody will send credit update for rest of record, and sender will wait
>for next enter of read syscall at receiver's side. So if user buffer is
>full, we just send credit update and drop data.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> v8 -> v9:
> 1) Check for RW packet type is removed from loop(all packet now
>    considered RW).
> 2) Locking in loop is fixed.
> 3) cpu_to_le32()/le32_to_cpu() now used.
> 4) MSG_TRUNC handling removed from transport.
>
> include/linux/virtio_vsock.h            |  5 ++
> net/vmw_vsock/virtio_transport_common.c | 64 +++++++++++++++++++++++++
> 2 files changed, 69 insertions(+)
>
>diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>index dc636b727179..02acf6e9ae04 100644
>--- a/include/linux/virtio_vsock.h
>+++ b/include/linux/virtio_vsock.h
>@@ -80,6 +80,11 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
> 			       struct msghdr *msg,
> 			       size_t len, int flags);
>
>+ssize_t
>+virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
>+				   struct msghdr *msg,
>+				   int flags,
>+				   bool *msg_ready);
> s64 virtio_transport_stream_has_data(struct vsock_sock *vsk);
> s64 virtio_transport_stream_has_space(struct vsock_sock *vsk);
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index ad0d34d41444..f649a21dd23b 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -393,6 +393,58 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
> 	return err;
> }
>
>+static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
>+						 struct msghdr *msg,
>+						 int flags,
>+						 bool *msg_ready)
>+{
>+	struct virtio_vsock_sock *vvs = vsk->trans;
>+	struct virtio_vsock_pkt *pkt;
>+	int err = 0;
>+	size_t user_buf_len = msg->msg_iter.count;
>+
>+	*msg_ready = false;
>+	spin_lock_bh(&vvs->rx_lock);
>+
>+	while (!*msg_ready && !list_empty(&vvs->rx_queue) && err >= 0) {
>+		size_t bytes_to_copy;
>+		size_t pkt_len;
>+
>+		pkt = list_first_entry(&vvs->rx_queue, struct virtio_vsock_pkt, list);
>+		pkt_len = (size_t)le32_to_cpu(pkt->hdr.len);
>+		bytes_to_copy = min(user_buf_len, pkt_len);
>+
>+		if (bytes_to_copy) {
>+			/* sk_lock is held by caller so no one else can dequeue.
>+			 * Unlock rx_lock since memcpy_to_msg() may sleep.
>+			 */
>+			spin_unlock_bh(&vvs->rx_lock);
>+
>+			if (memcpy_to_msg(msg, pkt->buf, bytes_to_copy)) 
>{
>+				err = -EINVAL;
>+			} else {
>+				err += pkt_len;

If `bytes_to_copy == 0` we are not increasing the real length.

Anyway is a bit confusing increase a variable called `err`, I think is 
better to have another variable to store this information that we return 
if there aren't errors.

