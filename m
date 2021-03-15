Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68FB933B094
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 12:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbhCOLCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 07:02:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44539 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229732AbhCOLCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 07:02:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615806135;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S/oWGawpXGhyQCD9KmbcPNHKcWmsnOSDhuC/sNGQZGI=;
        b=CrnWFDtveGdiLUbmvbydLmBN6TLTE7QMgQOJ12yZT8Vt6lkPCeWQZKw9Uo56yX3EiQOJaM
        6seAr11sAfbiAXgrs4UluURXSFstinoxjQjqDztwldNQ4DI0kNUMSahBp27aoaIfYqCiqs
        s8GYxEosPmumVk9z97/dJLNzjBiXlHg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-KE3nhldVOsmw2fax0fa01w-1; Mon, 15 Mar 2021 07:02:13 -0400
X-MC-Unique: KE3nhldVOsmw2fax0fa01w-1
Received: by mail-wr1-f69.google.com with SMTP id p12so12343998wrn.18
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 04:02:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S/oWGawpXGhyQCD9KmbcPNHKcWmsnOSDhuC/sNGQZGI=;
        b=asLLF6vpl2yzwZPCLNwemHXl1guDRBIGm8GBjI2cOwTi+342LtIKZJY2kRlURxSXPx
         RbLQv+KaeFmfjeD5YcN6NdG/eC6alNp8q9KqiIbWP6hgx6ucuGfJtDsqL7xwxixfOBs9
         OUEyZJl+rOSLtRHZxrcCVxUCbozGDCEwrwksQXXnrEsesERmYhY4pGxO4mHhIeX3k79j
         rFWrZ/QzclQcn9XvyuPY77xNQRFJ+AyXDigkWmWtlQvQ3MHed4RbS6V5IzZn0LvkFWqN
         q+GhWpdamXaeZC5VHiQDwuvuAgdY3pSiykg25FcqjaiXoMTi+UQdKvrvrpnpXoRd66g3
         mY0g==
X-Gm-Message-State: AOAM533yQS9vkE274NsINb9adgnjcLWzNmn8Z2k/1Yo7p2B1GA+Njo7z
        YXpQhT9ULgUhxZfZ0idBCc62sVAL5YYKRaLK3J3BLIozhuUzY9QrAkhF6uBQHmwZRbPxjnvgRAq
        ONVyHURUnOT16RuQI
X-Received: by 2002:a05:6000:24b:: with SMTP id m11mr26777652wrz.393.1615806132209;
        Mon, 15 Mar 2021 04:02:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzxngqoRvyImvtrS1gTlOBvENXh/6EdwVXEpl38+sSZZ8VElzUNwwM/9wN8W829CrCnbUyofg==
X-Received: by 2002:a05:6000:24b:: with SMTP id m11mr26777627wrz.393.1615806132028;
        Mon, 15 Mar 2021 04:02:12 -0700 (PDT)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id a13sm16170382wrp.31.2021.03.15.04.02.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 04:02:11 -0700 (PDT)
Date:   Mon, 15 Mar 2021 12:02:09 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v6 11/22] virtio/vsock: dequeue callback for
 SOCK_SEQPACKET
Message-ID: <20210315110209.xuaq5q3a2zp4u3g5@steredhat>
References: <20210307175722.3464068-1-arseny.krasnov@kaspersky.com>
 <20210307180204.3465806-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210307180204.3465806-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 07, 2021 at 09:02:01PM +0300, Arseny Krasnov wrote:
>This adds transport callback and it's logic for SEQPACKET dequeue.
>Callback fetches RW packets from rx queue of socket until whole record
>is copied(if user's buffer is full, user is not woken up). This is done
>to not stall sender, because if we wake up user and it leaves syscall,
>nobody will send credit update for rest of record, and sender will wait
>for next enter of read syscall at receiver's side. So if user buffer is
>full, we just send credit update and drop data. If during copy SEQ_BEGIN
>was found(and not all data was copied), copying is restarted by reset
>user's iov iterator(previous unfinished data is dropped).
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> include/linux/virtio_vsock.h            |  13 +++
> include/uapi/linux/virtio_vsock.h       |  16 ++++
> net/vmw_vsock/virtio_transport_common.c | 116 ++++++++++++++++++++++++
> 3 files changed, 145 insertions(+)
>
>diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>index dc636b727179..466a5832d2f5 100644
>--- a/include/linux/virtio_vsock.h
>+++ b/include/linux/virtio_vsock.h
>@@ -18,6 +18,12 @@ enum {
> 	VSOCK_VQ_MAX    = 3,
> };
>
>+struct virtio_vsock_seqpack_state {
>+	u32 user_read_seq_len;
>+	u32 user_read_copied;
>+	u32 curr_rx_msg_id;
>+};
>+
> /* Per-socket state (accessed via vsk->trans) */
> struct virtio_vsock_sock {
> 	struct vsock_sock *vsk;
>@@ -36,6 +42,8 @@ struct virtio_vsock_sock {
> 	u32 rx_bytes;
> 	u32 buf_alloc;
> 	struct list_head rx_queue;
>+
>+	struct virtio_vsock_seqpack_state seqpacket_state;

Following 'virtio_vsock_seq_hdr', maybe we can shorten in:

         struct virtio_vsock_seq_state seq_state;

The rest LGTM.

