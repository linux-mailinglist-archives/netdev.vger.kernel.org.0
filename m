Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7F0F37F8F9
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 15:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234139AbhEMNp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 09:45:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23525 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234131AbhEMNpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 09:45:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620913483;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oWoRXdPQG5Lp8dZ+UX0wcCkUvkRtLC4RqeaSswn2gS0=;
        b=ZQ2lg/wjV2nHBxdRoxUaHcCdWVLSJURuR3m9YxYK5kf0uRvZReb8E6DRr480EJZ0fIhsh9
        qbys8VE0qNbToalTA5dmM2Kk77P/BkQVYgjVhPSVZHeyeBuOTFfTf/5TjSCrGkrY9o/7jI
        +syiCavOVomupzYjObtDSEyabnTDrR8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-603-s57CHzsyMr-d-NmSn_rwCQ-1; Thu, 13 May 2021 09:44:41 -0400
X-MC-Unique: s57CHzsyMr-d-NmSn_rwCQ-1
Received: by mail-ed1-f72.google.com with SMTP id y17-20020a0564023591b02903886c26ada4so14679633edc.5
        for <netdev@vger.kernel.org>; Thu, 13 May 2021 06:44:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oWoRXdPQG5Lp8dZ+UX0wcCkUvkRtLC4RqeaSswn2gS0=;
        b=XhfdiM/B7YW9+lSyM0TOYQut6xlP+U6nAaxoYeHVBRkPnSiI4Mxah+h1iPmfv09lu/
         jxl3kwJRDI3CG7oLMjSMLKichdsO0+raYKXBsEssxDVu28NVqF0unSC08XO9kL4RoUB5
         dKtsb3yFjRei6ceej7DRPlrWtX3DXuYhgFS8rD4BJglwClugtkVA2+/laxaPtu62njF3
         P56EfegKSqe4q5lBKTYaEUrtWbePqwLKp1IKdoK3IaiDEHYPve8r2JWWNVhcNF0Q74e9
         7dMNZU1Tg0SddUagCiLDw5Ofk5vtzC+mYFMkoa4qsKhU/fv0yFieALYckT2ODmCCRjFP
         LW5A==
X-Gm-Message-State: AOAM530Ztz14Ux6OrQvaQnjrqPpooSHqaGSVjY+UVU3LPy4xfNS74HUZ
        3y+6JLcauQyy6fNchBGqYY+//T8jgnKmjxxHynHC1VpPSJPIQa7P+ghgaLX75UNPSgUM4fiXhzp
        GLEzq2DJMk743xMKa
X-Received: by 2002:a17:906:f28a:: with SMTP id gu10mr9366305ejb.135.1620913480730;
        Thu, 13 May 2021 06:44:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyRgeZlJQmydhRmOxSudfdDEFokEqUOqWxM5HwrKX/tQlm/Hr03jIduTjjqf7mT/0OjHrCwUQ==
X-Received: by 2002:a17:906:f28a:: with SMTP id gu10mr9366276ejb.135.1620913480499;
        Thu, 13 May 2021 06:44:40 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id q25sm1863114ejd.9.2021.05.13.06.44.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 06:44:40 -0700 (PDT)
Date:   Thu, 13 May 2021 15:44:37 +0200
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
Subject: Re: [RFC PATCH v9 15/19] vhost/vsock: enable SEQPACKET for transport
Message-ID: <20210513134437.xwz5gaulse4jqcmm@steredhat>
References: <20210508163027.3430238-1-arseny.krasnov@kaspersky.com>
 <20210508163634.3432505-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210508163634.3432505-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 08, 2021 at 07:36:31PM +0300, Arseny Krasnov wrote:
>This removes:
>1) Ignore of non-stream type of packets.
>This adds:
>1) Handling of SEQPACKET bit: if guest sets features with this bit cleared,
>   then SOCK_SEQPACKET support will be disabled.
>2) 'seqpacket_allow()' callback.
>3) Handling of SEQ_EOR bit: when vhost places data in buffers of guest's
>   rx queue, keep this bit set only when last piece of data is copied.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> v8 -> v9:
> 1) Move 'seqpacket_allow' to 'struct vhost_vsock'.
> 2) Use cpu_to_le32()/le32_to_cpu() to work with 'flags' of packet.
>
> drivers/vhost/vsock.c | 42 +++++++++++++++++++++++++++++++++++++++---
> 1 file changed, 39 insertions(+), 3 deletions(-)
>
>diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>index 5e78fb719602..3395b25d4a35 100644
>--- a/drivers/vhost/vsock.c
>+++ b/drivers/vhost/vsock.c
>@@ -31,7 +31,8 @@
>
> enum {
> 	VHOST_VSOCK_FEATURES = VHOST_FEATURES |
>-			       (1ULL << VIRTIO_F_ACCESS_PLATFORM)
>+			       (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
>+			       (1ULL << VIRTIO_VSOCK_F_SEQPACKET)
> };
>
> enum {
>@@ -56,6 +57,7 @@ struct vhost_vsock {
> 	atomic_t queued_replies;
>
> 	u32 guest_cid;
>+	bool seqpacket_allow;
> };
>
> static u32 vhost_transport_get_local_cid(void)
>@@ -112,6 +114,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> 		size_t nbytes;
> 		size_t iov_len, payload_len;
> 		int head;
>+		bool restore_flag = false;
>
> 		spin_lock_bh(&vsock->send_pkt_list_lock);
> 		if (list_empty(&vsock->send_pkt_list)) {
>@@ -174,6 +177,12 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> 		/* Set the correct length in the header */
> 		pkt->hdr.len = cpu_to_le32(payload_len);
>
>+		if (pkt->off + payload_len < pkt->len &&
>+		    le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR) {
>+			pkt->hdr.flags &= ~cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
>+			restore_flag = true;
>+		}

I think is better to move this code in the same block when we limit
payload_len, something like this (not tested):

		/* If the packet is greater than the space available in the
		 * buffer, we split it using multiple buffers.
		 */
		if (payload_len > iov_len - sizeof(pkt->hdr)) {
			payload_len = iov_len - sizeof(pkt->hdr);

			if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR) {
				pkt->hdr.flags &= ~cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
				restore_flag = true;
			}
		}

The rest LGTM.

