Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87D5B554ED6
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 17:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359214AbiFVPOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 11:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359210AbiFVPOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 11:14:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6857B33E32
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 08:14:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655910852;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=wGPNK+3CbuAdTkTsB3EwZQ5iFbUOR/MKa+csfzqSuVU=;
        b=BlvsBw77fMmr/1g5C2f/WV/FN052f/2MNSNlKscjkSXenCfmaQfwOJvuOaY6+QVIa3wMJl
        ifYrouCFcVerLxh5/FwdofbjzkQKucy3LbH4xs2FPs+4R8jV8qF8aTfJe9ifSt3ODZQVNV
        Re3bD+YVRBZ0UpdfXSEWMaP4yif/WhA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-101-HFIA6syMOZ6jYT6N4YWKdg-1; Wed, 22 Jun 2022 11:14:11 -0400
X-MC-Unique: HFIA6syMOZ6jYT6N4YWKdg-1
Received: by mail-wm1-f72.google.com with SMTP id p22-20020a05600c359600b0039c7b23a1c7so10205668wmq.2
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 08:14:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wGPNK+3CbuAdTkTsB3EwZQ5iFbUOR/MKa+csfzqSuVU=;
        b=qsX+AnRTm8BvPC84Gyo7h76ooZIC458cWpV3VM1nsOwHTrj6sV2erQnBUUOSUKC0BD
         spakCwBDyTihQahVnp1YVjoy5lL54LxRzJI/AcUsVmxivx1UADdHhLM2rGTUKEhfIQl2
         fTWi1ixKJM5ryOvg+PZTvn64ZQhNGfExhbJvB3eoFUWLX0vU6Ci9rP3XkZDbwLWGpfUe
         Eq62LwK97LU60lvs8Ur8XquQ8M8DUNhfyuzeGrpYqRCeChaxm+ohzrdbfklOBZUvZ66z
         B/YYTwSIbG1m6/NB0htrLeFvtO9sMRwgv54NtPDYmmFhD5uKC0JaN/RZavDBkf9zuTdr
         4lSQ==
X-Gm-Message-State: AOAM530ZpNSAqWqyUh7IJIQFj/jN408q6FMuDbveTUCHZSRFzcZJK3E0
        wRHpIIftAn5VKQs9IIJe1Z1DQ3yFamSpbtVhVjs0YsUtS8XRtfEo9NR6oQJe5Qjbcbg6qMEe558
        D7GY5dgU30Ojpaj+Y
X-Received: by 2002:a05:600c:3508:b0:39c:8240:5538 with SMTP id h8-20020a05600c350800b0039c82405538mr46419578wmq.165.1655910849743;
        Wed, 22 Jun 2022 08:14:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzEzFT4TFaMqQR0Ghk5VXNDtqjANOX/reNQn5bceF+MCQwu4Q10ypxVnyl4WOcDbkKlljFl6w==
X-Received: by 2002:a05:600c:3508:b0:39c:8240:5538 with SMTP id h8-20020a05600c350800b0039c82405538mr46419547wmq.165.1655910849466;
        Wed, 22 Jun 2022 08:14:09 -0700 (PDT)
Received: from step1.redhat.com (host-79-46-200-40.retail.telecomitalia.it. [79.46.200.40])
        by smtp.gmail.com with ESMTPSA id z6-20020a7bc7c6000000b0039c63f4bce0sm25194613wmk.12.2022.06.22.08.14.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 08:14:08 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        Gautam Dawar <gautam.dawar@xilinx.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH] vhost-vdpa: call vhost_vdpa_cleanup during the release
Date:   Wed, 22 Jun 2022 17:14:07 +0200
Message-Id: <20220622151407.51232-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before commit 3d5698793897 ("vhost-vdpa: introduce asid based IOTLB")
we call vhost_vdpa_iotlb_free() during the release to clean all regions
mapped in the iotlb.

That commit removed vhost_vdpa_iotlb_free() and added vhost_vdpa_cleanup()
to do some cleanup, including deleting all mappings, but we forgot to call
it in vhost_vdpa_release().

This causes that if an application does not remove all mappings explicitly
(or it crashes), the mappings remain in the iotlb and subsequent
applications may fail if they map the same addresses.

Calling vhost_vdpa_cleanup() also fixes a memory leak since we are not
freeing `v->vdev.vqs` during the release from the same commit.

Since vhost_vdpa_cleanup() calls vhost_dev_cleanup() we can remove its
call from vhost_vdpa_release().

Fixes: 3d5698793897 ("vhost-vdpa: introduce asid based IOTLB")
Cc: gautam.dawar@xilinx.com
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vhost/vdpa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 5ad2596c6e8a..23dcbfdfa13b 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -1209,7 +1209,7 @@ static int vhost_vdpa_release(struct inode *inode, struct file *filep)
 	vhost_dev_stop(&v->vdev);
 	vhost_vdpa_free_domain(v);
 	vhost_vdpa_config_put(v);
-	vhost_dev_cleanup(&v->vdev);
+	vhost_vdpa_cleanup(v);
 	mutex_unlock(&d->mutex);
 
 	atomic_dec(&v->opened);
-- 
2.36.1

