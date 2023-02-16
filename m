Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB4FD699893
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 16:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbjBPPRl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 10:17:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbjBPPRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 10:17:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D2E4C3D8
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 07:16:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676560592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TfM1ZlXzKUkDCUxuJyuXPYY/56tUGy5zNcAq6nqBMRg=;
        b=OEst18RwNHnDaqFffmsSvdIJSM3FMmAua7FVCzSUZN6v+InsQHAwUr8RE+y1BsgjswiwMy
        29z8Qs7tl1fdwL659TCHrHfZ0HzZ1UgRPk+J/lKPfDjVlH2JakbYcEvWGYyubQwGK/mwNx
        lCk8O4ifs2OAOIKXQMdo3Sz2wCOEROM=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-510-KZ0d1OoTONyCVTw2P8zlYA-1; Thu, 16 Feb 2023 10:16:28 -0500
X-MC-Unique: KZ0d1OoTONyCVTw2P8zlYA-1
Received: by mail-qt1-f199.google.com with SMTP id p6-20020a05622a048600b003b9a3ab9153so1366004qtx.8
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 07:16:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TfM1ZlXzKUkDCUxuJyuXPYY/56tUGy5zNcAq6nqBMRg=;
        b=y3QXDN3IKUV60cyjvU5+xGnxIFoUxHk1nqAGwgf4+S+aJXg4ZAORxKZApU8k3Aw+Q3
         eqgPBQJoLp0575m/w6GVtaSX8KTbSshwao16wWPT3BeaFZFu7OKX2713KkarPEkYZeT0
         mScAUngZaTHEcT9vt4ubBTbhDdVnENnrYqV5kf1fgMw04DJc+gdTSJX129S/7kTHO/uf
         cbd7yMbsZM81wLwa41smvXas6zZU/DGOe5F93OqWabuja9C4GRc1XdaEdGhM5EfSsrt+
         z+fFhUfgFzJtA30jU5WnvxbVZCvaaBzCf9zGtfie/fuKFNFIwjShZ8X+ajuh0Q13FEj9
         dN4w==
X-Gm-Message-State: AO0yUKXfNlGOGsaAelAgZ0/qMh7bWtg1n7Pn0pg614YbFiybNRLjzTm/
        315hXH7onW+AuEJI38Lk3HZwIsbIDpo1iaM6L8W9PfqLdnlTr2KJFtZqfKjpUnqSWW8LafAKbY4
        Uu449UEWyz0WJvweg
X-Received: by 2002:a05:622a:1648:b0:3bc:f954:323b with SMTP id y8-20020a05622a164800b003bcf954323bmr8607793qtj.29.1676560588096;
        Thu, 16 Feb 2023 07:16:28 -0800 (PST)
X-Google-Smtp-Source: AK7set/dluYNqaywOvNSwlQKJZgy3rhaatZv5j5C/MDcRhW5QcV5jfGsrL1X9gJrCHlPcHul8bH8Ow==
X-Received: by 2002:a05:622a:1648:b0:3bc:f954:323b with SMTP id y8-20020a05622a164800b003bcf954323bmr8607754qtj.29.1676560587786;
        Thu, 16 Feb 2023 07:16:27 -0800 (PST)
Received: from sgarzare-redhat (host-82-57-51-167.retail.telecomitalia.it. [82.57.51.167])
        by smtp.gmail.com with ESMTPSA id a13-20020ac8720d000000b003b860983973sm1371958qtp.60.2023.02.16.07.16.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 07:16:27 -0800 (PST)
Date:   Thu, 16 Feb 2023 16:16:22 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v1 07/12] vsock/virtio: MGS_ZEROCOPY flag support
Message-ID: <20230216151622.xu5jhha3wvc3us2b@sgarzare-redhat>
References: <0e7c6fc4-b4a6-a27b-36e9-359597bba2b5@sberdevices.ru>
 <716333a1-d6d1-3dde-d04a-365d4a361bfe@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <716333a1-d6d1-3dde-d04a-365d4a361bfe@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 07:00:35AM +0000, Arseniy Krasnov wrote:
>This adds main logic of MSG_ZEROCOPY flag processing for packet
>creation. When this flag is set and user's iov iterator fits for
>zerocopy transmission, call 'get_user_pages()' and add returned
>pages to the newly created skb.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> net/vmw_vsock/virtio_transport_common.c | 212 ++++++++++++++++++++++--
> 1 file changed, 195 insertions(+), 17 deletions(-)
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 05ce97b967ad..69e37f8a68a6 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -37,6 +37,169 @@ virtio_transport_get_ops(struct vsock_sock *vsk)
> 	return container_of(t, struct virtio_transport, transport);
> }
>

I'd use bool if we don't need to return an error value in the following
new functions.

>+static int virtio_transport_can_zcopy(struct iov_iter *iov_iter,
>+				      size_t free_space)
>+{
>+	size_t pages;
>+	int i;
>+
>+	if (!iter_is_iovec(iov_iter))
>+		return -1;
>+
>+	if (iov_iter->iov_offset)
>+		return -1;
>+
>+	/* We can't send whole iov. */
>+	if (free_space < iov_iter->count)
>+		return -1;
>+
>+	for (pages = 0, i = 0; i < iov_iter->nr_segs; i++) {
>+		const struct iovec *iovec;
>+		int pages_in_elem;
>+
>+		iovec = &iov_iter->iov[i];
>+
>+		/* Base must be page aligned. */
>+		if (offset_in_page(iovec->iov_base))
>+			return -1;
>+
>+		/* Only last element could have not page aligned size.  */
>+		if (i != (iov_iter->nr_segs - 1)) {
>+			if (offset_in_page(iovec->iov_len))
>+				return -1;
>+
>+			pages_in_elem = iovec->iov_len >> PAGE_SHIFT;
>+		} else {
>+			pages_in_elem = round_up(iovec->iov_len, PAGE_SIZE);
>+			pages_in_elem >>= PAGE_SHIFT;
>+		}
>+
>+		/* In case of user's pages - one page is one frag. */
>+		if (pages + pages_in_elem > MAX_SKB_FRAGS)
>+			return -1;
>+
>+		pages += pages_in_elem;
>+	}
>+
>+	return 0;
>+}
>+
>+static int virtio_transport_init_zcopy_skb(struct vsock_sock *vsk,
>+					   struct sk_buff *skb,
>+					   struct iov_iter *iter,
>+					   bool zerocopy)
>+{
>+	struct ubuf_info_msgzc *uarg_zc;
>+	struct ubuf_info *uarg;
>+
>+	uarg = msg_zerocopy_realloc(sk_vsock(vsk),
>+				    iov_length(iter->iov, iter->nr_segs),
>+				    NULL);
>+
>+	if (!uarg)
>+		return -1;
>+
>+	uarg_zc = uarg_to_msgzc(uarg);
>+	uarg_zc->zerocopy = zerocopy ? 1 : 0;
>+
>+	skb_zcopy_init(skb, uarg);
>+
>+	return 0;
>+}
>+
>+static int virtio_transport_fill_nonlinear_skb(struct sk_buff *skb,
>+					       struct vsock_sock *vsk,
>+					       struct virtio_vsock_pkt_info *info)
>+{
>+	struct iov_iter *iter;
>+	int frag_idx;
>+	int seg_idx;
>+
>+	iter = &info->msg->msg_iter;
>+	frag_idx = 0;
>+	VIRTIO_VSOCK_SKB_CB(skb)->curr_frag = 0;
>+	VIRTIO_VSOCK_SKB_CB(skb)->frag_off = 0;
>+
>+	/* At this moment:
>+	 * 1) 'iov_offset' is zero.
>+	 * 2) Every 'iov_base' and 'iov_len' are also page aligned
>+	 *    (except length of the last element).
>+	 * 3) Number of pages in this iov <= MAX_SKB_FRAGS.
>+	 * 4) Length of the data fits in current credit space.
>+	 */
>+	for (seg_idx = 0; seg_idx < iter->nr_segs; seg_idx++) {
>+		struct page *user_pages[MAX_SKB_FRAGS];
>+		const struct iovec *iovec;
>+		size_t last_frag_len;
>+		size_t pages_in_seg;
>+		int page_idx;
>+
>+		iovec = &iter->iov[seg_idx];
>+		pages_in_seg = iovec->iov_len >> PAGE_SHIFT;
>+
>+		if (iovec->iov_len % PAGE_SIZE) {
>+			last_frag_len = iovec->iov_len % PAGE_SIZE;
>+			pages_in_seg++;
>+		} else {
>+			last_frag_len = PAGE_SIZE;
>+		}
>+
>+		if (get_user_pages((unsigned long)iovec->iov_base,
>+				   pages_in_seg, FOLL_GET, user_pages,
>+				   NULL) != pages_in_seg)
>+			return -1;

Reading the get_user_pages() documentation, this should pin the user
pages, so we should be fine if we then expose them in the virtqueue.

But reading Documentation/core-api/pin_user_pages.rst it seems that
drivers should use "pin_user_pages*() for DMA-pinned pages", so I'm not
sure what we should do.

Additional advice would be great!

Anyway, when we are done using the pages, we should call put_page() or
unpin_user_page() depending on how we pin them.

>+
>+		for (page_idx = 0; page_idx < pages_in_seg; page_idx++) {
>+			int frag_len = PAGE_SIZE;
>+
>+			if (page_idx == (pages_in_seg - 1))
>+				frag_len = last_frag_len;
>+
>+			skb_fill_page_desc(skb, frag_idx++,
>+					   user_pages[page_idx], 0,
>+					   frag_len);
>+			skb_len_add(skb, frag_len);
>+		}
>+	}
>+
>+	return virtio_transport_init_zcopy_skb(vsk, skb, iter, true);
>+}
>+
>+static int virtio_transport_copy_payload(struct sk_buff *skb,
>+					 struct vsock_sock *vsk,
>+					 struct virtio_vsock_pkt_info *info,
>+					 size_t len)
>+{
>+	void *payload;
>+	int err;
>+
>+	payload = skb_put(skb, len);
>+	err = memcpy_from_msg(payload, info->msg, len);
>+	if (err)
>+		return -1;
>+
>+	if (msg_data_left(info->msg))
>+		return 0;
>+
>+	if (info->type == VIRTIO_VSOCK_TYPE_SEQPACKET) {
>+		struct virtio_vsock_hdr *hdr;
>+
>+		hdr = virtio_vsock_hdr(skb);
>+
>+		hdr->flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
>+
>+		if (info->msg->msg_flags & MSG_EOR)
>+			hdr->flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
>+	}
>+

A comment here explaining why this is necessary would be helpful.

>+	if (info->flags & MSG_ZEROCOPY)
>+		return virtio_transport_init_zcopy_skb(vsk, skb,
>+						       &info->msg->msg_iter,
>+						       false);
>+
>+	return 0;
>+}
>+
> /* Returns a new packet on success, otherwise returns NULL.
>  *
>  * If NULL is returned, errp is set to a negative errno.
>@@ -47,15 +210,31 @@ virtio_transport_alloc_skb(struct virtio_vsock_pkt_info *info,
> 			   u32 src_cid,
> 			   u32 src_port,
> 			   u32 dst_cid,
>-			   u32 dst_port)
>+			   u32 dst_port,
>+			   struct vsock_sock *vsk)
> {
>-	const size_t skb_len = VIRTIO_VSOCK_SKB_HEADROOM + len;
>+	const size_t skb_len = VIRTIO_VSOCK_SKB_HEADROOM;
> 	struct virtio_vsock_hdr *hdr;
> 	struct sk_buff *skb;
>-	void *payload;
>-	int err;
>+	bool use_zcopy = false;
>+
>+	if (info->msg) {
>+		/* If SOCK_ZEROCOPY is not enabled, ignore MSG_ZEROCOPY
>+		 * flag later and continue in classic way(e.g. without
>+		 * completion).
>+		 */
>+		if (!sock_flag(sk_vsock(vsk), SOCK_ZEROCOPY)) {

`vsk` can be null, should we check it?
Otherwise, what about passing only a flag?
So the caller will check it.

>+			info->flags &= ~MSG_ZEROCOPY;
>+		} else {
>+			if ((info->flags & MSG_ZEROCOPY) &&
>+			    !virtio_transport_can_zcopy(&info->msg->msg_iter, len)) {

This part is not very clear, I think virtio_transport_can_zcopy()
should return `true` if "can_zcopy".

>+				use_zcopy = true;
>+			}
>+		}
>+	}
>
>-	skb = virtio_vsock_alloc_skb(skb_len, GFP_KERNEL);
>+	/* For MSG_ZEROCOPY length will be added later. */
>+	skb = virtio_vsock_alloc_skb(skb_len + (use_zcopy ? 0 : len), GFP_KERNEL);

I think is better to adsjut `skb_len` in the previous block, when we set
`use_zcopy = true`, we can do `skb_len -= len` (with the comment);

> 	if (!skb)
> 		return NULL;
>
>@@ -70,18 +249,15 @@ virtio_transport_alloc_skb(struct virtio_vsock_pkt_info *info,
> 	hdr->len	= cpu_to_le32(len);
>
> 	if (info->msg && len > 0) {
>-		payload = skb_put(skb, len);
>-		err = memcpy_from_msg(payload, info->msg, len);
>-		if (err)
>-			goto out;
>+		int err;
>
>-		if (msg_data_left(info->msg) == 0 &&
>-		    info->type == VIRTIO_VSOCK_TYPE_SEQPACKET) {
>-			hdr->flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
>+		if (use_zcopy)
>+			err = virtio_transport_fill_nonlinear_skb(skb, vsk, info);
>+		else
>+			err = virtio_transport_copy_payload(skb, vsk, info, len);
>
>-			if (info->msg->msg_flags & MSG_EOR)
>-				hdr->flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
>-		}
>+		if (err)
>+			goto out;
> 	}
>
> 	if (info->reply)
>@@ -266,7 +442,8 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
>
> 	skb = virtio_transport_alloc_skb(info, pkt_len,
> 					 src_cid, src_port,
>-					 dst_cid, dst_port);
>+					 dst_cid, dst_port,
>+					 vsk);
> 	if (!skb) {
> 		virtio_transport_put_credit(vvs, pkt_len);
> 		return -ENOMEM;
>@@ -842,6 +1019,7 @@ virtio_transport_stream_enqueue(struct vsock_sock *vsk,
> 		.msg = msg,
> 		.pkt_len = len,
> 		.vsk = vsk,
>+		.flags = msg->msg_flags,
> 	};
>
> 	return virtio_transport_send_pkt_info(vsk, &info);
>@@ -894,7 +1072,7 @@ static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
> 					   le64_to_cpu(hdr->dst_cid),
> 					   le32_to_cpu(hdr->dst_port),
> 					   le64_to_cpu(hdr->src_cid),
>-					   le32_to_cpu(hdr->src_port));
>+					   le32_to_cpu(hdr->src_port), NULL);
> 	if (!reply)
> 		return -ENOMEM;
>
>-- 
>2.25.1

