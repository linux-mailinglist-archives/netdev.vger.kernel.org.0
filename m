Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB1C11F5395
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 13:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728855AbgFJLiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 07:38:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29141 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728623AbgFJLgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 07:36:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591788975;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+SD3Vrt7U6HArLpzqOyIxuZrc1fS29Ei8HX5xaDKKOw=;
        b=XVN6nOuA43iDlFdg6LVf7YTxeBwVeeVXzXvw+G8iedVX/pOHO1iIWzeEXjaK31tQhrJef/
        YIUwaEjN258AEj3zJlp4aQvHabvoEoJBnKqVQG1kinOz4+8oLnwNKalbdQzfgTs2Vnk/93
        hmaT8RtA4P4rOtQSwjkjxpsFeFeyk7U=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-106-sXNWKWbrPZuq7zm72692Lg-1; Wed, 10 Jun 2020 07:36:12 -0400
X-MC-Unique: sXNWKWbrPZuq7zm72692Lg-1
Received: by mail-wr1-f69.google.com with SMTP id r5so968328wrt.9
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 04:36:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+SD3Vrt7U6HArLpzqOyIxuZrc1fS29Ei8HX5xaDKKOw=;
        b=KktDACmgpHp8LQAxPfKP1zjiKDizW3kn4MwB+K57BxPSjPIATdYeozkRXCNfJe7n6Y
         uYSf4Iz6FhQQVnQoI028VZVKEKQOYB3nDYq9IM3KNRXrQepwRWozsqGr0z833WSfKN0e
         pYrzxxpc2GlwO4QRxBNWMLLpmyR9erA+/XnU2NLGlJNnvQdhmVkldOO4nbd+87Xs1FjX
         T/pFZPG8YfpaPuvcfuz9Z2ulQkDQsyL/EdIKwLft8lAarCMfZEh4TNMcMX4dKlh74hj9
         7QqPgdza6umCacDSQgzHuqbLluimqws2OFRR9oEFwvxFf4irYlWP77bhTt7sn4sL09sJ
         P/Qw==
X-Gm-Message-State: AOAM531icA25QDV0NQe5LBJthIrWXnvPeOJBP8i4dNuIpjM6dS2TmOBG
        zQm9DknllrNqiwDVFoUlAWnqRgvgMO2Gfi0RI9TI66lz7Ep8JaIvZCD8TWwvTyVqUUTP8kxI8aF
        mZUcaIJLloFWFACb1
X-Received: by 2002:a1c:22d7:: with SMTP id i206mr2755086wmi.186.1591788970804;
        Wed, 10 Jun 2020 04:36:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxemEaCHMgCrHg7/oKSQ4yFnNXg1fLjZ5OHmMHvyeRIUoWRpQOB/0A8RO0HmZnjlr0fN5RKtA==
X-Received: by 2002:a1c:22d7:: with SMTP id i206mr2755070wmi.186.1591788970615;
        Wed, 10 Jun 2020 04:36:10 -0700 (PDT)
Received: from redhat.com ([212.92.121.57])
        by smtp.gmail.com with ESMTPSA id a1sm6866225wmd.28.2020.06.10.04.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 04:36:10 -0700 (PDT)
Date:   Wed, 10 Jun 2020 07:36:08 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        eperezma@redhat.com
Subject: [PATCH RFC v7 05/14] vhost: reorder functions
Message-ID: <20200610113515.1497099-6-mst@redhat.com>
References: <20200610113515.1497099-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200610113515.1497099-1-mst@redhat.com>
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
index 28f324fd77df..506208b63126 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2429,19 +2429,6 @@ void vhost_discard_vq_desc(struct vhost_virtqueue *vq, int n)
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
@@ -2511,6 +2498,19 @@ int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem *heads,
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

