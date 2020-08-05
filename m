Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B971F23CFF2
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 21:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728611AbgHET1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 15:27:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26940 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728639AbgHERNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 13:13:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596647582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=f1A99Kan+ToYvUmOMuODkd0BFkRSjBNq3WkT2nA5570=;
        b=dR3nXJcOxXQhXr4gn6VmnbjOJP1FxOpoj2yjDm2sGOB2XQpNQ99v7U/3kvvgfu2ewkayRf
        Mn68IMjrF78i0E6dWUf6UonGQbjnuSf6zeMNP4h7bmrKiCr5kRQkOMBWv3GbNGUE/rYh6a
        XuR6rfx7M4qLvf6K9kuF8xUCy8KVRQA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-92-JRanPxWgMeGT4EnGBNaNbQ-1; Wed, 05 Aug 2020 09:44:14 -0400
X-MC-Unique: JRanPxWgMeGT4EnGBNaNbQ-1
Received: by mail-wr1-f69.google.com with SMTP id d6so12035211wrv.23
        for <netdev@vger.kernel.org>; Wed, 05 Aug 2020 06:44:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=f1A99Kan+ToYvUmOMuODkd0BFkRSjBNq3WkT2nA5570=;
        b=n7BW1tUrUD6Xjih36AwOzXWrqtiRrcnJwicjAEn9qEqaUr0wsi4dTBGibYWKUiWl9a
         no1u9lIGawjxYm8sKL6AoAD/ENUa8lnA0OOiyD/4RRDn67oGF0EIABIpXjaMDxGv7zcq
         BbAf+PlB+1/MkLnJVD8UqSh1IDaQjIQM0olm+TdyoYWXgdcWGzlhMkl7miaIR+U0ZuWM
         ziB7O0zZqkOhB99yTK+UQFgqUc7umOYDC1e1GYf4bTGjEQnGM7o0qw12knjN8mCQU87q
         M0RM6S0+ZAb+3Ld3zILL/TP7oO0vP9BjibgFDXgSHmCVsNJ9hw/t+xOQRLqYVdzzTC7E
         GnqA==
X-Gm-Message-State: AOAM531+OzP+S8Dt0Oo+6krwBK96tHPCfGR/G7Wr4O8809eGP42lJuyV
        XTzePKzFppD4o8qX5v25V1CaQlpVNjYCWHb1frF9MB7vkReVu5tWE+C3BIdxfIY/eifrcIhP2/E
        v9CMnrOd4k5gOeGBf
X-Received: by 2002:a5d:56c9:: with SMTP id m9mr2815440wrw.311.1596635052938;
        Wed, 05 Aug 2020 06:44:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz1s5cwBUNfyg52XUg786M5asAtfYsirHkxCrJWthFsY+eLaHorMKAhGdLmAYB5+K4MVfGhow==
X-Received: by 2002:a5d:56c9:: with SMTP id m9mr2815427wrw.311.1596635052770;
        Wed, 05 Aug 2020 06:44:12 -0700 (PDT)
Received: from redhat.com (bzq-79-180-0-181.red.bezeqint.net. [79.180.0.181])
        by smtp.gmail.com with ESMTPSA id o30sm2873971wra.67.2020.08.05.06.44.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 06:44:12 -0700 (PDT)
Date:   Wed, 5 Aug 2020 09:44:10 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH v3 20/38] vhost/vdpa: switch to new helpers
Message-ID: <20200805134226.1106164-21-mst@redhat.com>
References: <20200805134226.1106164-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200805134226.1106164-1-mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For new helpers handling legacy features to be effective,
vhost needs to invoke them. Tie them in.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/vdpa.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 18869a35d408..3674404688f5 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -118,9 +118,8 @@ static irqreturn_t vhost_vdpa_config_cb(void *private)
 static void vhost_vdpa_reset(struct vhost_vdpa *v)
 {
 	struct vdpa_device *vdpa = v->vdpa;
-	const struct vdpa_config_ops *ops = vdpa->config;
 
-	ops->set_status(vdpa, 0);
+	vdpa_reset(vdpa);
 }
 
 static long vhost_vdpa_get_device_id(struct vhost_vdpa *v, u8 __user *argp)
@@ -196,7 +195,6 @@ static long vhost_vdpa_get_config(struct vhost_vdpa *v,
 				  struct vhost_vdpa_config __user *c)
 {
 	struct vdpa_device *vdpa = v->vdpa;
-	const struct vdpa_config_ops *ops = vdpa->config;
 	struct vhost_vdpa_config config;
 	unsigned long size = offsetof(struct vhost_vdpa_config, buf);
 	u8 *buf;
@@ -209,7 +207,7 @@ static long vhost_vdpa_get_config(struct vhost_vdpa *v,
 	if (!buf)
 		return -ENOMEM;
 
-	ops->get_config(vdpa, config.off, buf, config.len);
+	vdpa_get_config(vdpa, config.off, buf, config.len);
 
 	if (copy_to_user(c->buf, buf, config.len)) {
 		kvfree(buf);
@@ -282,7 +280,7 @@ static long vhost_vdpa_set_features(struct vhost_vdpa *v, u64 __user *featurep)
 	if (features & ~vhost_vdpa_features[v->virtio_id])
 		return -EINVAL;
 
-	if (ops->set_features(vdpa, features))
+	if (vdpa_set_features(vdpa, features))
 		return -EINVAL;
 
 	return 0;
-- 
MST

