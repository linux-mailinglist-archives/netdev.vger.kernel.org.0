Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFAA1F1956
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 14:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729835AbgFHMyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 08:54:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51326 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729315AbgFHMxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 08:53:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591620793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nNh1TL7xZUtXOusVSg8tIG35kTb/6beDbMDeGMbkL8c=;
        b=cdK3hBalYnQTZ2ivoNup29kX+WgRgCaAnDsw5wfyGBdugUnta7zGmGaDV+15nJQns5GPRJ
        3GryBGOPIok8qhGcXLqe2hE9foMQtYKpzJzxjWt4OCmt5QWp2ExK7hHLytKKm+6LttVg4K
        zxoZmC//Jkzvnn47x3BXU0ECh6klymA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-T0ZYK9QkPBiWS5TMZm7DpQ-1; Mon, 08 Jun 2020 08:53:11 -0400
X-MC-Unique: T0ZYK9QkPBiWS5TMZm7DpQ-1
Received: by mail-wr1-f72.google.com with SMTP id h6so7166789wrx.4
        for <netdev@vger.kernel.org>; Mon, 08 Jun 2020 05:53:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nNh1TL7xZUtXOusVSg8tIG35kTb/6beDbMDeGMbkL8c=;
        b=IcSVvp6KifOuvN8M6XlksBsZ9Eb+qy1ah0gLXLYcDHHOhuE/7ibzyy1OVsYrq7uVTC
         oqeybvZ/EkaT7BDxscvE93YQBQbelPg24FRnD2d6UEWUfnQnfj6GD/Mg0R41HGSxuGSJ
         Eg56rWDcyN7ist1PYAHxP3v5DvyjszfuuI2D8CZG3MD17QJcCaUv38Q762YnehdMj4S5
         9V9U/PbXh09f1UmZup3zBso9DYZDMHBwWY5RN8MBenkQGk/oh6D48Cae3Wf88oNMzyRF
         XCJq0xP8hs/eFiqZTM8OpgIGmF0oXH2XuCFPs4U791kEW69fqyDZ5BUe20gwHxh6+LJB
         TOww==
X-Gm-Message-State: AOAM533klTy3o23tufGOFDgpsh+NiDKPGDSwk/6I87M6Js/FAs5txR7y
        G31WmZykExdDBjfRY1P2WTWQcbM0cMFqsiFQXsWhq7urH6ejoZ9j1Tu6NdI2LoifgJ06TR+Agqz
        UMMWQxlUc4J79mwHV
X-Received: by 2002:a5d:4b47:: with SMTP id w7mr22414162wrs.234.1591620790802;
        Mon, 08 Jun 2020 05:53:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJweTCKDLbfiVGUFqWREKS9iQ8j4XUwzsDXWV07w/+PxSXiYAJVsAr7kpiUE/TGQ+cExzBaktw==
X-Received: by 2002:a5d:4b47:: with SMTP id w7mr22414144wrs.234.1591620790552;
        Mon, 08 Jun 2020 05:53:10 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id h15sm22578283wrt.73.2020.06.08.05.53.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 05:53:10 -0700 (PDT)
Date:   Mon, 8 Jun 2020 08:53:08 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        eperezma@redhat.com
Subject: [PATCH RFC v6 08/11] vhost/test: convert to the buf API
Message-ID: <20200608125238.728563-9-mst@redhat.com>
References: <20200608125238.728563-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608125238.728563-1-mst@redhat.com>
X-Mailer: git-send-email 2.24.1.751.gd10ce2899c
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/test.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index 7d69778aaa26..12304eb8da15 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -44,9 +44,10 @@ static void handle_vq(struct vhost_test *n)
 {
 	struct vhost_virtqueue *vq = &n->vqs[VHOST_TEST_VQ];
 	unsigned out, in;
-	int head;
+	int ret;
 	size_t len, total_len = 0;
 	void *private;
+	struct vhost_buf buf;
 
 	mutex_lock(&vq->mutex);
 	private = vhost_vq_get_backend(vq);
@@ -58,15 +59,15 @@ static void handle_vq(struct vhost_test *n)
 	vhost_disable_notify(&n->dev, vq);
 
 	for (;;) {
-		head = vhost_get_vq_desc(vq, vq->iov,
-					 ARRAY_SIZE(vq->iov),
-					 &out, &in,
-					 NULL, NULL);
+		ret = vhost_get_avail_buf(vq, &buf, vq->iov,
+					  ARRAY_SIZE(vq->iov),
+					  &out, &in,
+					  NULL, NULL);
 		/* On error, stop handling until the next kick. */
-		if (unlikely(head < 0))
+		if (unlikely(ret < 0))
 			break;
 		/* Nothing new?  Wait for eventfd to tell us they refilled. */
-		if (head == vq->num) {
+		if (!ret) {
 			if (unlikely(vhost_enable_notify(&n->dev, vq))) {
 				vhost_disable_notify(&n->dev, vq);
 				continue;
@@ -78,13 +79,14 @@ static void handle_vq(struct vhost_test *n)
 			       "out %d, int %d\n", out, in);
 			break;
 		}
-		len = iov_length(vq->iov, out);
+		len = buf.out_len;
 		/* Sanity check */
 		if (!len) {
 			vq_err(vq, "Unexpected 0 len for TX\n");
 			break;
 		}
-		vhost_add_used_and_signal(&n->dev, vq, head, 0);
+		vhost_put_used_buf(vq, &buf);
+		vhost_signal(&n->dev, vq);
 		total_len += len;
 		if (unlikely(vhost_exceeds_weight(vq, 0, total_len)))
 			break;
-- 
MST

