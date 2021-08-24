Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2E2D3F5B96
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 12:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236247AbhHXKB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 06:01:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23466 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235968AbhHXKBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 06:01:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629799259;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AsfgonFEhHbtRW9+iWzj2iDpJcwnghT7FgzSm7rVr3I=;
        b=OWntaB+NXPrlDtpTakkoZitch+/NkZHvciZ1tMnzCLzbrTa6cv+akeAekm7k6zWvFYnEKj
        gfZSvdHp1qVRCQa+ZhG9ROXqwIeKPj2Ga3hBk6zZv/jK+0/3I7++oIYcJPPEL7kEwNf3TQ
        Im9JBqzCxKEKAtIqmBBPLzAeapdAvsE=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-231-n0II486LMm6cMgZiR3zSFA-1; Tue, 24 Aug 2021 06:00:58 -0400
X-MC-Unique: n0II486LMm6cMgZiR3zSFA-1
Received: by mail-ej1-f72.google.com with SMTP id ak17-20020a170906889100b005c5d1e5e707so2092275ejc.16
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 03:00:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AsfgonFEhHbtRW9+iWzj2iDpJcwnghT7FgzSm7rVr3I=;
        b=hqRCfL3b9EeW+VqqiSGcLjGJ5aphudsN04GJXpRBBTOeSuH3bftpW8zc1iP+VkdMf2
         jxRU4pUJ3Xb48wjaFL51nHEjDrVe0MJxrU9u2oQ9co8eB9fRlroiOX8FwSzWmUe/DiKD
         Xoa22fITJYkooPcWNGXiVKiyBuOM0EC0erRCt567v0xNyRtdZsaLy8JY8Mht1U89x1pa
         qMGyCwpcVALz+9QmmJCS1gGp6YAqmeAJs33RpXRRqhbt2/qsHeqPD8P/gXQflLVFt3GX
         jFZ0TxTP6WZAe1GUpjH1nKRc+cIU++v4nvN94Ctj0aZs50YvLJM9vR4VypzTvnKPmvlP
         YO1A==
X-Gm-Message-State: AOAM531z2fRN0Rg/SmpmJWUAoR1PAI0MRBK84EeQdtZIb0b1lIX3UQ0y
        7OwtprYG9Uc40H3Oyo3A+36wprBOoe9BWIPmkVrtoGdPW2E+ZIsa8WlCBamWHvJ63/IPvZnoCgR
        7mSSVJShft5x+igx8
X-Received: by 2002:a17:906:a0ce:: with SMTP id bh14mr38811932ejb.434.1629799257231;
        Tue, 24 Aug 2021 03:00:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz1OFEVEhnIhV9jwM2SN934WwXV2gbD7ZeMHy2q4u+7FfCSG2W+EV79uua+jleY+7NYrWEmuQ==
X-Received: by 2002:a17:906:a0ce:: with SMTP id bh14mr38811918ejb.434.1629799257043;
        Tue, 24 Aug 2021 03:00:57 -0700 (PDT)
Received: from steredhat (host-79-45-8-152.retail.telecomitalia.it. [79.45.8.152])
        by smtp.gmail.com with ESMTPSA id f30sm3469843ejl.78.2021.08.24.03.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 03:00:56 -0700 (PDT)
Date:   Tue, 24 Aug 2021 12:00:53 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.co
Subject: Re: [RFC PATCH v3 3/6] vhost/vsock: support MSG_EOR bit processing
Message-ID: <20210824100053.jc2pgttgwq5sujvu@steredhat>
References: <20210816085036.4173627-1-arseny.krasnov@kaspersky.com>
 <20210816085143.4174099-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210816085143.4174099-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 11:51:40AM +0300, Arseny Krasnov wrote:
>'MSG_EOR' handling has same logic as 'MSG_EOM' - if bit present

s/same/similar

>in packet's header, reset it to 0. Then restore it back if packet
>processing wasn't completed. Instead of bool variable for each
>flag, bit mask variable was added: it has logical OR of 'MSG_EOR'
>and 'MSG_EOM' if needed, to restore flags, this variable is ORed
>with flags field of packet.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> drivers/vhost/vsock.c | 12 ++++++++----
> 1 file changed, 8 insertions(+), 4 deletions(-)
>
>diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>index feaf650affbe..d217955bbcd4 100644
>--- a/drivers/vhost/vsock.c
>+++ b/drivers/vhost/vsock.c
>@@ -114,7 +114,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> 		size_t nbytes;
> 		size_t iov_len, payload_len;
> 		int head;
>-		bool restore_flag = false;
>+		uint32_t flags_to_restore = 0;

checkpatch.pl suggest the following:
CHECK: Prefer kernel type 'u32' over 'uint32_t'

Sorry, I suggested that, I forgot that u32 is preferable :-)

>
> 		spin_lock_bh(&vsock->send_pkt_list_lock);
> 		if (list_empty(&vsock->send_pkt_list)) {
>@@ -187,7 +187,12 @@ vhost_transport_do_send_pkt(struct vhost_vsock 
>*vsock,
> 			 */

Please also update the comment above with the new flag handled.

> 			if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOM) {
> 				pkt->hdr.flags &= ~cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
>-				restore_flag = true;
>+				flags_to_restore |= VIRTIO_VSOCK_SEQ_EOM;
>+
>+				if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR) {
>+					pkt->hdr.flags &= ~cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
>+					flags_to_restore |= VIRTIO_VSOCK_SEQ_EOR;
>+				}
> 			}
> 		}
>
>@@ -224,8 +229,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> 		 * to send it with the next available buffer.
> 		 */
> 		if (pkt->off < pkt->len) {
>-			if (restore_flag)
>-				pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
>+			pkt->hdr.flags |= cpu_to_le32(flags_to_restore);
>
> 			/* We are queueing the same virtio_vsock_pkt to handle
> 			 * the remaining bytes, and we want to deliver it
>-- 
>2.25.1
>

The rest LGTM.

Stefano

