Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E64623E8CDD
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 11:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbhHKJJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 05:09:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23887 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235902AbhHKJJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 05:09:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628672951;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JLjNDQUWebauLItmfnlQ+Tjthn4pJvLabefx75OaW6Y=;
        b=evXYGzkWFr9b1xNWdBBhK86hvPDsYFEvD9d59qd1nc/rx10ael+WyEOweJxD+vduzcyM4v
        wtrqZ/7+/kAufYDC2qwF0Rw/v7ba9R8s3J3rfpAxgE0G0yCRUJVLxchGqKGDPmNyQBdK+f
        0S26dpmXZ7NFG1kaOfoqLP9pNoKUTzQ=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-552-JTNJhD6dMk2spF-56Vln1g-1; Wed, 11 Aug 2021 05:09:07 -0400
X-MC-Unique: JTNJhD6dMk2spF-56Vln1g-1
Received: by mail-ed1-f70.google.com with SMTP id l18-20020a0564021252b02903be7bdd65ccso903425edw.12
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 02:09:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JLjNDQUWebauLItmfnlQ+Tjthn4pJvLabefx75OaW6Y=;
        b=RYDuFGuc9BzAj0zHjeyt/ecXOgyk+yKVHPV+bbgNduyZKdSa2X8ZS2I0WaLL7J0Zoi
         I9ZaV3p8orpfCBavt0AgrA4ZdRb1skSBcQGBhX84GaFI7Tx5A/PpNJCWjCA5tWtnu8qS
         TXq5Hdlv0cNHJk69nVKZU9vsLqGZo2wEQahS5EtXnymEk3uJc3WppHnibxyXeS0UGCxl
         cx/SBihO0wxplpqXaKWY8I435HvHNjY9QAbBPtLENql+cqTe1g+o+nGIid0/fh6ds3Le
         ASX0+soDAuba2Eiyw07XhxCTInlsnDqWAcEZ3ROESN0weedF2qs/UXUn2uhjgGjo4Sp7
         ddEg==
X-Gm-Message-State: AOAM531hnt5U4DD+M9AnhGpxnbWY7qBgEUCQL39DcLxeRct/Uw38dO6V
        xcGNIIlac/LFReFvGigkxyjdnv+FBzMwegdX1p8JVGVSKc2jsy7DL4bkTEeRz4WDuLunj9+GRNM
        e8k7wCN0N38lwBLmE
X-Received: by 2002:a17:907:35d0:: with SMTP id ap16mr2641392ejc.456.1628672946561;
        Wed, 11 Aug 2021 02:09:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw62doxoYPXhN9D22tEpGdIMeHAaw1IFlIKoYlluOKCXwbBvIxBAtg09tZOA20KjkBX0c0KiA==
X-Received: by 2002:a17:907:35d0:: with SMTP id ap16mr2641373ejc.456.1628672946373;
        Wed, 11 Aug 2021 02:09:06 -0700 (PDT)
Received: from steredhat (a-nu5-14.tin.it. [212.216.181.13])
        by smtp.gmail.com with ESMTPSA id p23sm11040297edw.94.2021.08.11.02.09.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 02:09:06 -0700 (PDT)
Date:   Wed, 11 Aug 2021 11:09:03 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v2 3/5] virito/vsock: support MSG_EOR bit processing
Message-ID: <20210811090903.27tcokpqofujhhgp@steredhat>
References: <20210810113901.1214116-1-arseny.krasnov@kaspersky.com>
 <20210810114035.1214740-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210810114035.1214740-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 02:40:32PM +0300, Arseny Krasnov wrote:
>If packet has 'EOR' bit - set MSG_EOR in 'recvmsg()' flags.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> net/vmw_vsock/virtio_transport_common.c | 9 ++++++++-
> 1 file changed, 8 insertions(+), 1 deletion(-)
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 4d5a93beceb0..59ee1be5a6dd 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -76,8 +76,12 @@ virtio_transport_alloc_pkt(struct virtio_vsock_pkt_info *info,
> 			goto out;
>
> 		if (msg_data_left(info->msg) == 0 &&
>-		    info->type == VIRTIO_VSOCK_TYPE_SEQPACKET)
>+		    info->type == VIRTIO_VSOCK_TYPE_SEQPACKET) {
> 			pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
>+
>+			if (info->msg->msg_flags & MSG_EOR)
>+				pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
>+		}
> 	}
>
> 	trace_virtio_transport_alloc_pkt(src_cid, src_port,
>@@ -460,6 +464,9 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
> 		if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOM) {
> 			msg_ready = true;
> 			vvs->msg_count--;
>+
>+			if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR)
>+				msg->msg_flags |= MSG_EOR;
> 		}
>
> 		virtio_transport_dec_rx_pkt(vvs, pkt);
>-- 
>2.25.1
>

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

