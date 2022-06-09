Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E249E54465E
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 10:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242298AbiFIIoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 04:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242739AbiFIInz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 04:43:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6751D4553E
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 01:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654764123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hbvCaL1wOfOFrYCFWGLThfbo1GLwl4GEM9yi4TGDwQo=;
        b=Rb9BD6SI2VyFlmArRQCTYYOlI8/8OuGmrUStlrcLKbOCqUnBkCK/UPHU6VFohwAGyKmKsT
        z1oUqLkqep/W6/p4xlJuwP51CObTuHiEz1zJuos2ew7IPuz3jSXLPZ0QRwLWq5yv52pIeb
        dEYpThvoUIguQMWAQecUWuX2Nb0f5po=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-404-t3mWrajVOHqNtnZm75RLEQ-1; Thu, 09 Jun 2022 04:42:02 -0400
X-MC-Unique: t3mWrajVOHqNtnZm75RLEQ-1
Received: by mail-wm1-f71.google.com with SMTP id be12-20020a05600c1e8c00b0039c506b52a4so396163wmb.1
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 01:42:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hbvCaL1wOfOFrYCFWGLThfbo1GLwl4GEM9yi4TGDwQo=;
        b=vXxx3b7g64zRSzFoxXrbsboSqSacaQICFgh5wbFXzY6c/PQeZ5YAuEQxzIZN37dGa5
         wQ2bB0TCkVpAIz84jCs+lRVSDrb0gtEbNo1aYJtEveFZXm6qCCc32CRGamVzVIs+iCuB
         GiU+Gv5M9aNdcgCv5s8GTvYIxqQsOnVBMj65CTnO49A0PqhEF07Wmx1E2iWKi0misT0W
         accV23sh87PCW9kdocED+6FrlAHTKFkNM6AZAuqCJhQU91ORhkYyom789OSjZcPqkgFM
         JtRQVyrQI1bhXV4Y8Pps7TRfcPqSEJm5eC5qXHKHibcH2FSxAaupA0IqezfA7ZClX8I3
         WT+g==
X-Gm-Message-State: AOAM533uI9Mp3ncy8/C7udj0QWclZb7RzuOMCz9nFT+SI9GTAwt+wx8N
        5n7k2XKKYSXJ3mkg+BlnJ8y6HDQr/aZNuEaz2t61hyFso13MU6hdnRIJTYeLpqR0zhvsJoY4xhS
        e9p/4Zihj6V47Ieto
X-Received: by 2002:adf:e189:0:b0:218:45f0:5c0a with SMTP id az9-20020adfe189000000b0021845f05c0amr17559330wrb.683.1654764118262;
        Thu, 09 Jun 2022 01:41:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJysiPURDeTjXE66ZO6ZgkFeDnfAlmBehDg4QQ8l/XXYzqjWiblxWAsfpyM1NHDhusMQyK9a/Q==
X-Received: by 2002:adf:e189:0:b0:218:45f0:5c0a with SMTP id az9-20020adfe189000000b0021845f05c0amr17559297wrb.683.1654764117949;
        Thu, 09 Jun 2022 01:41:57 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-40.retail.telecomitalia.it. [79.46.200.40])
        by smtp.gmail.com with ESMTPSA id p9-20020a5d4589000000b0020fcf070f61sm23705284wrq.59.2022.06.09.01.41.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 01:41:57 -0700 (PDT)
Date:   Thu, 9 Jun 2022 10:41:54 +0200
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
Subject: Re: [RFC PATCH v2 4/8] virtio/vsock: add transport zerocopy callback
Message-ID: <20220609084154.kvkkc2iax456lvud@sgarzare-redhat>
References: <e37fdf9b-be80-35e1-ae7b-c9dfeae3e3db@sberdevices.ru>
 <6f76eed7-decc-68d1-6ae7-7bafb09fdad3@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <6f76eed7-decc-68d1-6ae7-7bafb09fdad3@sberdevices.ru>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 03, 2022 at 05:37:48AM +0000, Arseniy Krasnov wrote:
>This adds transport callback which processes rx
>queue of socket and instead of copying data to
>user provided buffer, it inserts data pages of
>each packet to user's vm area.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> include/linux/virtio_vsock.h            |   4 +
> include/uapi/linux/virtio_vsock.h       |   6 +
> net/vmw_vsock/virtio_transport_common.c | 208 +++++++++++++++++++++++-
> 3 files changed, 215 insertions(+), 3 deletions(-)
>
>diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>index d02cb7aa922f..47a68a2ea838 100644
>--- a/include/linux/virtio_vsock.h
>+++ b/include/linux/virtio_vsock.h
>@@ -51,6 +51,7 @@ struct virtio_vsock_pkt {
> 	bool reply;
> 	bool tap_delivered;
> 	bool slab_buf;
>+	bool split;
> };
>
> struct virtio_vsock_pkt_info {
>@@ -131,6 +132,9 @@ int virtio_transport_dgram_bind(struct vsock_sock *vsk,
> 				struct sockaddr_vm *addr);
> bool virtio_transport_dgram_allow(u32 cid, u32 port);
>
>+int virtio_transport_zerocopy_dequeue(struct vsock_sock *vsk,
>+				      struct vm_area_struct *vma,
>+				      unsigned long addr);
> int virtio_transport_connect(struct vsock_sock *vsk);
>
> int virtio_transport_shutdown(struct vsock_sock *vsk, int mode);
>diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
>index 64738838bee5..6775c6c44b5b 100644
>--- a/include/uapi/linux/virtio_vsock.h
>+++ b/include/uapi/linux/virtio_vsock.h
>@@ -66,6 +66,12 @@ struct virtio_vsock_hdr {
> 	__le32	fwd_cnt;
> } __attribute__((packed));
>
>+struct virtio_vsock_usr_hdr {
>+	u32 flags;
>+	u32 len;
>+	u32 copy_len;
>+} __attribute__((packed));
>+
> enum virtio_vsock_type {
> 	VIRTIO_VSOCK_TYPE_STREAM = 1,
> 	VIRTIO_VSOCK_TYPE_SEQPACKET = 2,
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 278567f748f2..3a3e84176c75 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -12,6 +12,7 @@
> #include <linux/ctype.h>
> #include <linux/list.h>
> #include <linux/virtio_vsock.h>
>+#include <linux/mm.h>
> #include <uapi/linux/vsockmon.h>
>
> #include <net/sock.h>
>@@ -347,6 +348,196 @@ virtio_transport_stream_do_peek(struct vsock_sock *vsk,
> 	return err;
> }
>
>+#define MAX_PAGES_TO_MAP 256
>+
>+int virtio_transport_zerocopy_dequeue(struct vsock_sock *vsk,
>+				      struct vm_area_struct *vma,
>+				      unsigned long addr)
>+{
>+	struct virtio_vsock_sock *vvs = vsk->trans;
>+	struct virtio_vsock_usr_hdr *usr_hdr_buffer;
>+	unsigned long max_pages_to_insert;
>+	unsigned long tmp_pages_inserted;
>+	unsigned long pages_to_insert;
>+	struct page *usr_hdr_page;
>+	unsigned long vma_size;
>+	struct page **pages;
>+	int max_vma_pages;
>+	int max_usr_hdrs;
>+	int res;
>+	int err;
>+	int i;
>+
>+	/* Only use VMA from first page. */
>+	if (vma->vm_start != addr)
>+		return -EFAULT;
>+
>+	vma_size = vma->vm_end - vma->vm_start;
>+
>+	/* Too small vma(at least one page for headers
>+	 * and one page for data).
>+	 */
>+	if (vma_size < 2 * PAGE_SIZE)
>+		return -EFAULT;
>+
>+	/* Page for meta data. */
>+	usr_hdr_page = alloc_page(GFP_KERNEL);

I think all these checks should be done in af_vsock.c.

It would be nice to avoid that every transport reimplements the same 
thing and especially that all transports have the same behavior.

If you can would be nice to have the transports to return an array of 
pages to map, and af_vsock will handle it and the usr_hdr_page.

Do you think it's doable?

>+
>+	if (!usr_hdr_page)
>+		return -EFAULT;
>+
>+	pages = kmalloc_array(MAX_PAGES_TO_MAP, sizeof(pages[0]), GFP_KERNEL);
>+
>+	if (!pages)
>+		return -EFAULT;
>+
>+	pages[pages_to_insert++] = usr_hdr_page;
>+
>+	usr_hdr_buffer = page_to_virt(usr_hdr_page);
>+
>+	err = 0;
>+
>+	/* As we use first page for headers, so total number of
>+	 * pages for user is min between number of headers in
>+	 * first page and size of vma(in pages, except first page).
>+	 */
>+	max_usr_hdrs = PAGE_SIZE / sizeof(*usr_hdr_buffer);
>+	max_vma_pages = (vma_size / PAGE_SIZE) - 1;
>+	max_pages_to_insert = min(max_usr_hdrs, max_vma_pages);
>+
>+	if (max_pages_to_insert > MAX_PAGES_TO_MAP)
>+		max_pages_to_insert = MAX_PAGES_TO_MAP;
>+
>+	spin_lock_bh(&vvs->rx_lock);
>+
>+	while (!list_empty(&vvs->rx_queue) &&
>+	       pages_to_insert < max_pages_to_insert) {
>+		struct virtio_vsock_pkt *pkt;
>+		ssize_t rest_data_bytes;
>+		size_t moved_data_bytes;
>+		unsigned long pg_offs;
>+
>+		pkt = list_first_entry(&vvs->rx_queue,
>+				       struct virtio_vsock_pkt, list);
>+
>+		/* Buffer was allocated by 'kmalloc()'. This could
>+		 * happen, when zerocopy was enabled, but we still
>+		 * have pending packet which was created before it.
>+		 */
>+		if (pkt->slab_buf) {
>+			usr_hdr_buffer->flags = le32_to_cpu(pkt->hdr.flags);
>+			usr_hdr_buffer->len = 0;
>+			usr_hdr_buffer->copy_len = le32_to_cpu(pkt->hdr.len);
>+			/* Report user to read it using copy. */

Is it a "to do"?

>+			break;
>+		}
>+
>+		/* This could happen, when packet was dequeued before
>+		 * by an ordinary 'read()' call. We can't handle such
>+		 * packet. Drop it.

We can't drop packets.
I think we should allow to enable/disable this new feature before the 
connection.

>+		 */
>+		if (pkt->off % PAGE_SIZE) {
>+			list_del(&pkt->list);
>+			virtio_transport_dec_rx_pkt(vvs, pkt);
>+			virtio_transport_free_pkt(pkt);
>+			continue;
>+		}
>+
>+		rest_data_bytes = le32_to_cpu(pkt->hdr.len) - pkt->off;
>+
>+		/* For packets, bigger than one page, split it's
>+		 * high order allocated buffer to 0 order pages.
>+		 * Otherwise 'vm_insert_pages()' will fail, for
>+		 * all pages except first.
>+		 */
>+		if (rest_data_bytes > PAGE_SIZE) {
>+			/* High order buffer not split yet. */
>+			if (!pkt->split) {
>+				split_page(virt_to_page(pkt->buf),
>+					   get_order(le32_to_cpu(pkt->hdr.len)));
>+				pkt->split = true;
>+			}
>+		}
>+
>+		pg_offs = pkt->off;
>+		moved_data_bytes = 0;
>+
>+		while (rest_data_bytes &&
>+		       pages_to_insert < max_pages_to_insert) {
>+			struct page *buf_page;
>+
>+			buf_page = virt_to_page(pkt->buf + pg_offs);
>+
>+			pages[pages_to_insert++] = buf_page;
>+			/* Get reference to prevent this page being
>+			 * returned to page allocator when packet will
>+			 * be freed. Ref count will be 2.
>+			 */
>+			get_page(buf_page);
>+			pg_offs += PAGE_SIZE;
>+
>+			if (rest_data_bytes >= PAGE_SIZE) {
>+				moved_data_bytes += PAGE_SIZE;
>+				rest_data_bytes -= PAGE_SIZE;
>+			} else {
>+				moved_data_bytes += rest_data_bytes;
>+				rest_data_bytes = 0;
>+			}
>+		}
>+
>+		usr_hdr_buffer->flags = le32_to_cpu(pkt->hdr.flags);
>+		usr_hdr_buffer->len = moved_data_bytes;
>+		usr_hdr_buffer->copy_len = 0;
>+		usr_hdr_buffer++;
>+
>+		pkt->off = pg_offs;
>+
>+		if (rest_data_bytes == 0) {
>+			list_del(&pkt->list);
>+			virtio_transport_dec_rx_pkt(vvs, pkt);
>+			virtio_transport_free_pkt(pkt);
>+		}
>+
>+		/* Now ref count for all pages of packet is 1. */
>+	}
>+
>+	/* Set last buffer empty(if we have one). */
>+	if (pages_to_insert - 1 < max_usr_hdrs)
>+		usr_hdr_buffer->len = 0;
>+
>+	spin_unlock_bh(&vvs->rx_lock);
>+
>+	tmp_pages_inserted = pages_to_insert;
>+
>+	res = vm_insert_pages(vma, addr, pages, &tmp_pages_inserted);
>+
>+	if (res || tmp_pages_inserted) {
>+		/* Failed to insert some pages, we have "partially"
>+		 * mapped vma. Do not return, set error code. This
>+		 * code will be returned to user. User needs to call
>+		 * 'madvise()/mmap()' to clear this vma. Anyway,
>+		 * references to all pages will to be dropped below.
>+		 */
>+		err = -EFAULT;
>+	}
>+
>+	/* Put reference for every page. */
>+	for (i = 0; i < pages_to_insert; i++) {
>+		/* Ref count is 2 ('get_page()' + 'vm_insert_pages()' above).
>+		 * Put reference once, page will be returned to allocator
>+		 * after user's 'madvice()/munmap()' call(or it wasn't mapped
>+		 * if 'vm_insert_pages()' failed).
>+		 */
>+		put_page(pages[i]);
>+	}
>+
>+	virtio_transport_send_credit_update(vsk);
>+	kfree(pages);
>+
>+	return err;
>+}
>+EXPORT_SYMBOL_GPL(virtio_transport_zerocopy_dequeue);
>+
> static ssize_t
> virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
> 				   struct msghdr *msg,
>@@ -1344,10 +1535,21 @@ EXPORT_SYMBOL_GPL(virtio_transport_recv_pkt);
> void virtio_transport_free_pkt(struct virtio_vsock_pkt *pkt)
> {
> 	if (pkt->buf_len) {
>-		if (pkt->slab_buf)
>+		if (pkt->slab_buf) {
> 			kfree(pkt->buf);
>-		else
>-			free_pages(buf, get_order(pkt->buf_len));
>+		} else {
>+			unsigned int order = get_order(pkt->buf_len);
>+			unsigned long buf = (unsigned long)pkt->buf;
>+
>+			if (pkt->split) {
>+				int i;
>+
>+				for (i = 0; i < (1 << order); i++)
>+					free_page(buf + i * PAGE_SIZE);
>+			} else {
>+				free_pages(buf, order);
>+			}
>+		}
> 	}
>
> 	kfree(pkt);
>-- 2.25.1

