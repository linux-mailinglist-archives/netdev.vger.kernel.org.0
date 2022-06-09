Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C19C54460E
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 10:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241957AbiFIIjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 04:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241986AbiFIIia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 04:38:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EC5A7FF8
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 01:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654763906;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HgVXSci/QOseQPVoykiPl1OOcwRCzNz17MjAcM9uq8w=;
        b=Ae24BzLDvu1s2hRcTqfN9U8lGQTyDYBBtmV/7+9ps2sNCsEnFBycEwOhuPzkRGP4CzHWh8
        v0L0E2a3KUtQAw1DLpmxSdKI66t6T/OTVcvcqA033k7cv94mx8WbFWj1nm/XuyX9Uf/rqq
        XvI0ACUNR2o/3PiAqbMlnDaaTmsahbg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-557-QivRxRl2NFKBXaSzPaSizw-1; Thu, 09 Jun 2022 04:38:17 -0400
X-MC-Unique: QivRxRl2NFKBXaSzPaSizw-1
Received: by mail-wm1-f71.google.com with SMTP id k5-20020a05600c0b4500b003941ca130f9so8014985wmr.0
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 01:38:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HgVXSci/QOseQPVoykiPl1OOcwRCzNz17MjAcM9uq8w=;
        b=TyCi6WWftf2CqHFkIs0L2uvOHba4XIDXjInSzbxg4un6imTLHQjv4StfhCr8fAOHk3
         hp5hv47Bu5StAbMtExMXmegcrA36RyUZK4CD+ApTMn5qfm8T8rYrd1gyLKHXgfWU+2KT
         2aC3vy7FJd8h0AL/jBghzxucYKL+soUJ+vf9ICEPfBuyeHs9MyLqhHAyUsJsyWXarf0S
         TjLtPDYOXIYnlG1gAcmpP+M2lKKJR7G8wC8BPLhF72/0QMUCf8usdSYyeIDDiHjLeznq
         lQBXawQ49CuERNZm3K9m8EhjR+beH+enRavVY484uFvihevDWMkdkxOxH5RYqKMyCIkV
         gNLw==
X-Gm-Message-State: AOAM531uPWxl2Ef+UY2tBcRtifpZvTHcjSAT23WV/QePh/FPaVzmofce
        GCEFpzvP2KHjl79Bh7XvjfekFAKnya8sguwe6Fy0q52XUA7A6JM50IYV8u/ry2bio83wxH5y9+i
        Ql4DiyCTNkZN5uLMr
X-Received: by 2002:a5d:5046:0:b0:210:20ba:843b with SMTP id h6-20020a5d5046000000b0021020ba843bmr36990358wrt.447.1654763896051;
        Thu, 09 Jun 2022 01:38:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz2I/pxTFn4lag98n3atuyy6yg43sEFm9gDOXjfWj6fo6AxS/nQEcBo9Zu5aQvJUCNQyNASrw==
X-Received: by 2002:a5d:5046:0:b0:210:20ba:843b with SMTP id h6-20020a5d5046000000b0021020ba843bmr36990340wrt.447.1654763895841;
        Thu, 09 Jun 2022 01:38:15 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-40.retail.telecomitalia.it. [79.46.200.40])
        by smtp.gmail.com with ESMTPSA id h7-20020a05600c350700b0039c3b05540fsm25002292wmq.27.2022.06.09.01.38.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 01:38:15 -0700 (PDT)
Date:   Thu, 9 Jun 2022 10:38:12 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>,
        Krasnov Arseniy <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v2 2/8] vhost/vsock: rework packet allocation logic
Message-ID: <20220609083812.kfsmteh6cm5v3ag2@sgarzare-redhat>
References: <e37fdf9b-be80-35e1-ae7b-c9dfeae3e3db@sberdevices.ru>
 <72ae7f76-ffee-3e64-d445-7a0f4261d891@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <72ae7f76-ffee-3e64-d445-7a0f4261d891@sberdevices.ru>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 03, 2022 at 05:33:04AM +0000, Arseniy Krasnov wrote:
>For packets received from virtio RX queue, use buddy
>allocator instead of 'kmalloc()' to be able to insert
>such pages to user provided vma. Single call to
>'copy_from_iter()' replaced with per-page loop.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> drivers/vhost/vsock.c | 81 ++++++++++++++++++++++++++++++++++++-------
> 1 file changed, 69 insertions(+), 12 deletions(-)
>
>diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>index e6c9d41db1de..0dc2229f18f7 100644
>--- a/drivers/vhost/vsock.c
>+++ b/drivers/vhost/vsock.c
>@@ -58,6 +58,7 @@ struct vhost_vsock {
>
> 	u32 guest_cid;
> 	bool seqpacket_allow;
>+	bool zerocopy_rx_on;

This is per-device, so a single socket can change the behaviour of all 
the sockets of this device.

Can we do something better?

Maybe we can allocate the header, copy it, find the socket and check if 
zero-copy is enabled or not for that socket.

Of course we should change or extend virtio_transport_recv_pkt() to 
avoid to find the socket again.


> };
>
> static u32 vhost_transport_get_local_cid(void)
>@@ -357,6 +358,7 @@ vhost_vsock_alloc_pkt(struct vhost_virtqueue *vq,
> 		      unsigned int out, unsigned int in)
> {
> 	struct virtio_vsock_pkt *pkt;
>+	struct vhost_vsock *vsock;
> 	struct iov_iter iov_iter;
> 	size_t nbytes;
> 	size_t len;
>@@ -393,20 +395,75 @@ vhost_vsock_alloc_pkt(struct vhost_virtqueue *vq,
> 		return NULL;
> 	}
>
>-	pkt->buf = kmalloc(pkt->len, GFP_KERNEL);
>-	if (!pkt->buf) {
>-		kfree(pkt);
>-		return NULL;
>-	}
>-
> 	pkt->buf_len = pkt->len;
>+	vsock = container_of(vq->dev, struct vhost_vsock, dev);
>
>-	nbytes = copy_from_iter(pkt->buf, pkt->len, &iov_iter);
>-	if (nbytes != pkt->len) {
>-		vq_err(vq, "Expected %u byte payload, got %zu bytes\n",
>-		       pkt->len, nbytes);
>-		virtio_transport_free_pkt(pkt);
>-		return NULL;
>+	if (!vsock->zerocopy_rx_on) {
>+		pkt->buf = kmalloc(pkt->len, GFP_KERNEL);
>+
>+		if (!pkt->buf) {
>+			kfree(pkt);
>+			return NULL;
>+		}
>+
>+		pkt->slab_buf = true;
>+		nbytes = copy_from_iter(pkt->buf, pkt->len, &iov_iter);
>+		if (nbytes != pkt->len) {
>+			vq_err(vq, "Expected %u byte payload, got %zu bytes\n",
>+				pkt->len, nbytes);
>+			virtio_transport_free_pkt(pkt);
>+			return NULL;
>+		}
>+	} else {
>+		struct page *buf_page;
>+		ssize_t pkt_len;
>+		int page_idx;
>+
>+		/* This creates memory overrun, as we allocate
>+		 * at least one page for each packet.
>+		 */
>+		buf_page = alloc_pages(GFP_KERNEL, get_order(pkt->len));
>+
>+		if (buf_page == NULL) {
>+			kfree(pkt);
>+			return NULL;
>+		}
>+
>+		pkt->buf = page_to_virt(buf_page);
>+
>+		page_idx = 0;
>+		pkt_len = pkt->len;
>+
>+		/* As allocated pages are not mapped, process
>+		 * pages one by one.
>+		 */
>+		while (pkt_len > 0) {
>+			void *mapped;
>+			size_t to_copy;
>+
>+			mapped = kmap(buf_page + page_idx);
>+
>+			if (mapped == NULL) {
>+				virtio_transport_free_pkt(pkt);
>+				return NULL;
>+			}
>+
>+			to_copy = min(pkt_len, ((ssize_t)PAGE_SIZE));
>+
>+			nbytes = copy_from_iter(mapped, to_copy, &iov_iter);
>+			if (nbytes != to_copy) {
>+				vq_err(vq, "Expected %zu byte payload, got %zu bytes\n",
>+				       to_copy, nbytes);
>+				kunmap(mapped);
>+				virtio_transport_free_pkt(pkt);
>+				return NULL;
>+			}
>+
>+			kunmap(mapped);
>+
>+			pkt_len -= to_copy;
>+			page_idx++;
>+		}
> 	}
>
> 	return pkt;
>-- 
>2.25.1

