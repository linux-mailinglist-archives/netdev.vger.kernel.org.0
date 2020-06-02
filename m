Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B34871EBC7E
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 15:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728371AbgFBNG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 09:06:56 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:35415 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728358AbgFBNG3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 09:06:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591103187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nZ+SseV/ZcYFSq4g3IfECGD3NtX/OI1iTKB8+Z0Evh0=;
        b=VrgHtPis2kvjyQFTxq9acZGG2LxhXUUQRr+PaZUfF3sfjId2ZoczoAZKUGzdMhSeZVC0Ws
        M5vv7bzG5paBrezj2IJOaTtZMXHVhdczyhZhkb8Sz6OXR8ae6kyB73/kq9c48XSbFJgSd0
        tVKvuYDBnxjfTg1Ay6c7I8Q92WTJCuw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-236-GqRwbR9UOVmh6x-tzZVgxg-1; Tue, 02 Jun 2020 09:06:26 -0400
X-MC-Unique: GqRwbR9UOVmh6x-tzZVgxg-1
Received: by mail-wr1-f71.google.com with SMTP id l1so1374581wrc.8
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 06:06:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nZ+SseV/ZcYFSq4g3IfECGD3NtX/OI1iTKB8+Z0Evh0=;
        b=lY0E4+JcVXYMzvoUWCcPEwPruLfUdU7f20C5RzkUJrC2KyE09zd8LDAQ5MiGAav3IW
         3ZJG75UDKPfdw832beaOnSVpOAmx0HtDuI5/l1TV5lFgo3YDePJiCQPFj9OSBlPqrxBt
         S2vYhE96WRwJDapPSMe3P7M8AYES165C35Q00wcH1hXS6sz3iEEgUecmChOvj327ySWE
         eTQVBzEYJfuBT/MdlAAOIGCBkhOO/Zl+8iTx/Nd+HdoNhXy3MI+IwTZVT2H8VbJ/vYJq
         mv96OaEpbmilY18syBDfec+Qk2E1sh8LVkL6l+F7OV8OY+hR6aYBdY91QGCi67V3G9nI
         nSHw==
X-Gm-Message-State: AOAM53327FtVvNtdD4az25WJt/fqiacZO+5CZxUtksBxGDea7/agrR5s
        uqE/f7tFvGHgyeq4SSkX0owPucYZ+yn9QLVlzEyCs3T+aJDWvYiMuRXFQ3XLuo4LcWXJf/uNS1i
        0lUQ7UL3fMrt8CT3f
X-Received: by 2002:a5d:6289:: with SMTP id k9mr27798491wru.358.1591103184856;
        Tue, 02 Jun 2020 06:06:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzV89PYQkmoqnUsoXjBfNQaiS/ysgLH5sFD2QE7LqFLiCerhfIUk7XIzd7ub9CmcrxwG1Onyg==
X-Received: by 2002:a5d:6289:: with SMTP id k9mr27798483wru.358.1591103184639;
        Tue, 02 Jun 2020 06:06:24 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id o10sm3857545wrj.37.2020.06.02.06.06.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 06:06:24 -0700 (PDT)
Date:   Tue, 2 Jun 2020 09:06:22 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH RFC 12/13] vhost/vsock: switch to the buf API
Message-ID: <20200602130543.578420-13-mst@redhat.com>
References: <20200602130543.578420-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200602130543.578420-1-mst@redhat.com>
X-Mailer: git-send-email 2.24.1.751.gd10ce2899c
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A straight-forward conversion.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/vsock.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index fb4e944c4d0d..07d1fb340fb4 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -103,7 +103,8 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 		unsigned out, in;
 		size_t nbytes;
 		size_t iov_len, payload_len;
-		int head;
+		struct vhost_buf buf;
+		int ret;
 
 		spin_lock_bh(&vsock->send_pkt_list_lock);
 		if (list_empty(&vsock->send_pkt_list)) {
@@ -117,16 +118,17 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 		list_del_init(&pkt->list);
 		spin_unlock_bh(&vsock->send_pkt_list_lock);
 
-		head = vhost_get_vq_desc(vq, vq->iov, ARRAY_SIZE(vq->iov),
-					 &out, &in, NULL, NULL);
-		if (head < 0) {
+		ret = vhost_get_avail_buf(vq, &buf,
+					  vq->iov, ARRAY_SIZE(vq->iov),
+					  &out, &in, NULL, NULL);
+		if (ret < 0) {
 			spin_lock_bh(&vsock->send_pkt_list_lock);
 			list_add(&pkt->list, &vsock->send_pkt_list);
 			spin_unlock_bh(&vsock->send_pkt_list_lock);
 			break;
 		}
 
-		if (head == vq->num) {
+		if (!ret) {
 			spin_lock_bh(&vsock->send_pkt_list_lock);
 			list_add(&pkt->list, &vsock->send_pkt_list);
 			spin_unlock_bh(&vsock->send_pkt_list_lock);
@@ -186,7 +188,8 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 		 */
 		virtio_transport_deliver_tap_pkt(pkt);
 
-		vhost_add_used(vq, head, sizeof(pkt->hdr) + payload_len);
+		buf.in_len = sizeof(pkt->hdr) + payload_len;
+		vhost_put_used_buf(vq, &buf);
 		added = true;
 
 		pkt->off += payload_len;
@@ -440,7 +443,8 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
 	struct vhost_vsock *vsock = container_of(vq->dev, struct vhost_vsock,
 						 dev);
 	struct virtio_vsock_pkt *pkt;
-	int head, pkts = 0, total_len = 0;
+	int ret, pkts = 0, total_len = 0;
+	struct vhost_buf buf;
 	unsigned int out, in;
 	bool added = false;
 
@@ -461,12 +465,13 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
 			goto no_more_replies;
 		}
 
-		head = vhost_get_vq_desc(vq, vq->iov, ARRAY_SIZE(vq->iov),
-					 &out, &in, NULL, NULL);
-		if (head < 0)
+		ret = vhost_get_avail_buf(vq, &buf,
+					  vq->iov, ARRAY_SIZE(vq->iov),
+					  &out, &in, NULL, NULL);
+		if (ret < 0)
 			break;
 
-		if (head == vq->num) {
+		if (!ret) {
 			if (unlikely(vhost_enable_notify(&vsock->dev, vq))) {
 				vhost_disable_notify(&vsock->dev, vq);
 				continue;
@@ -494,7 +499,8 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
 			virtio_transport_free_pkt(pkt);
 
 		len += sizeof(pkt->hdr);
-		vhost_add_used(vq, head, len);
+		buf.in_len = len;
+		vhost_put_used_buf(vq, &buf);
 		total_len += len;
 		added = true;
 	} while(likely(!vhost_exceeds_weight(vq, ++pkts, total_len)));
-- 
MST

