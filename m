Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC0A1F66C1
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 13:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728106AbgFKLeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 07:34:37 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:32369 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728056AbgFKLea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 07:34:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591875269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GQeTVzMxKn8MhUVbsXHw7bWDPyusaDacrq6kngKNb/s=;
        b=XJunigVuXa/i4mFv2/FFcdSiZks5Eay0H5u35L86/z1minsuOiP9MMVW+4S1cSivHUUxpi
        SAk3lniDKqdMgnhosI15cNCGDIwoFN5p9Np45i+om8EuIEe+8MeE61u+wqGMUFiH2F0Ksq
        jx+Ht5O7JX0Wc4Mh41hendHErGYJQEE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-8GHSZtDsO9S3pToUsyNYWg-1; Thu, 11 Jun 2020 07:34:27 -0400
X-MC-Unique: 8GHSZtDsO9S3pToUsyNYWg-1
Received: by mail-wr1-f72.google.com with SMTP id l18so2475301wrm.0
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 04:34:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GQeTVzMxKn8MhUVbsXHw7bWDPyusaDacrq6kngKNb/s=;
        b=n526nNjgj4nQgNmRoqipQrIiWk0nMqX/xEAX1D3DRZ423mRYOFtHKVfyDs73LIpz3d
         +9PNdP9KWpVJgOc7WSI0mw1PWNFVbRpTbrwbyzovDhggbPaf2sUfaM4mv/CuKmMY9uJ1
         BOoAGoCaNnlxCJWUWMCYrCaL6re+Lahr50C591vJpgtjdUY9DEpBlX5kA2xt2F+S1VKK
         VWby9orAmnjSEkA91W5YLX6DCqjGHKiR3kL1wZzNGfCNcHBoPTGPru9u9bLX7iXGVZCZ
         I3DGgCRTR/bDZuP5s3xrZX9kGPv9CpMP2ES65FCekvfRVbAsBgchs2XCy/fs82/PUcET
         Ivug==
X-Gm-Message-State: AOAM530XYmYUkDXWKcJIDlZbo5C0BCeDk+3vazMgcrG4OeQRaWBik7NC
        1CP2JNMeFGXRqQxAQP8uJ5BAFL61IHDci62lexmoe0gxS1qZTAWlOukzHIG/n5AOIp0rR2hs9n4
        2Y3SqwbC6uXMgFhRw
X-Received: by 2002:adf:f450:: with SMTP id f16mr9149828wrp.307.1591875266440;
        Thu, 11 Jun 2020 04:34:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxu4RmLScea2SydO/nk/Zqnhh0evcgLZ860ln0HWt26ptj8Of6uBtznoHEKq49OIRHfJG06rw==
X-Received: by 2002:adf:f450:: with SMTP id f16mr9149807wrp.307.1591875266209;
        Thu, 11 Jun 2020 04:34:26 -0700 (PDT)
Received: from redhat.com (bzq-79-181-55-232.red.bezeqint.net. [79.181.55.232])
        by smtp.gmail.com with ESMTPSA id w3sm4155571wmg.44.2020.06.11.04.34.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2020 04:34:25 -0700 (PDT)
Date:   Thu, 11 Jun 2020 07:34:24 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        eperezma@redhat.com
Subject: [PATCH RFC v8 04/11] vhost: reorder functions
Message-ID: <20200611113404.17810-5-mst@redhat.com>
References: <20200611113404.17810-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200611113404.17810-1-mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reorder functions in the file to not rely on forward
declarations, in preparation to making them static
down the road.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/vhost.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index dfcdb36d4227..c38605b01080 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2425,19 +2425,6 @@ void vhost_discard_vq_desc(struct vhost_virtqueue *vq, int n)
 }
 EXPORT_SYMBOL_GPL(vhost_discard_vq_desc);
 
-/* After we've used one of their buffers, we tell them about it.  We'll then
- * want to notify the guest, using eventfd. */
-int vhost_add_used(struct vhost_virtqueue *vq, unsigned int head, int len)
-{
-	struct vring_used_elem heads = {
-		cpu_to_vhost32(vq, head),
-		cpu_to_vhost32(vq, len)
-	};
-
-	return vhost_add_used_n(vq, &heads, 1);
-}
-EXPORT_SYMBOL_GPL(vhost_add_used);
-
 static int __vhost_add_used_n(struct vhost_virtqueue *vq,
 			    struct vring_used_elem *heads,
 			    unsigned count)
@@ -2507,6 +2494,19 @@ int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem *heads,
 }
 EXPORT_SYMBOL_GPL(vhost_add_used_n);
 
+/* After we've used one of their buffers, we tell them about it.  We'll then
+ * want to notify the guest, using eventfd. */
+int vhost_add_used(struct vhost_virtqueue *vq, unsigned int head, int len)
+{
+	struct vring_used_elem heads = {
+		cpu_to_vhost32(vq, head),
+		cpu_to_vhost32(vq, len)
+	};
+
+	return vhost_add_used_n(vq, &heads, 1);
+}
+EXPORT_SYMBOL_GPL(vhost_add_used);
+
 static bool vhost_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
 {
 	__u16 old, new;
-- 
MST

