Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBA823A20BF
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 01:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbhFIX36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 19:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbhFIX36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 19:29:58 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56181C061574
        for <netdev@vger.kernel.org>; Wed,  9 Jun 2021 16:27:49 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id 22-20020a17090a0c16b0290164a5354ad0so2603231pjs.2
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 16:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ryjTh+mD4YySh21tlg0ARtI0y9ZaLutIYM7xzEboUMM=;
        b=PGAajtMkuQ3LaeTRZIG07olMjiCPi1sq3ITEedmcyp4kGig8kV2hTPoI3NKR1B1a+E
         8MeDJ3E5rcRaw7ehm8sgbCOJZsSlU3wxL1I1kkWGJHw8GfGA2VVggWGRCQl85yUFLIaF
         b6VAkSQrOHIuq/euJ1bRx9Jl62SkXI8en5mJuL64oPOMb0VY6wCZYa4i/UeyG0Wvyvj5
         mDL8xJiHUkGbyJxM0c/SCIaJOiUow9O3q6HgxLoYfJ8rdGG0AVCj30CRyBNcgfEPyuW2
         w3KYyJg2uij3Y7S1OWR87xbEYWkKXCZrsl/v+7BehEMo1x3WTj1Yfp1LetwJ32a0eONp
         18tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ryjTh+mD4YySh21tlg0ARtI0y9ZaLutIYM7xzEboUMM=;
        b=XqQjaP1TQrFDxDGIJijWFnfcXWG+3QjzDwTOBwY5qwZXYAPMvcWOgTYoVYDX9AkYyb
         uVAYor+idCK1lAUAqh/R3kBDfbnYNojkIQPfowAjtiv4+mSax4aLHRuKovC4cfoxMxp3
         gJJINLzFxyggWFs8ejDvDcQFmlS4YA7N13KeteQYnLHHJ2aeX3NQQOClxpF/blpbmww2
         Ho6FkgzB5IqpkVNvf2/MDzd78ZCxG3AXivwYh8QvYKmaFR7Ov/XrTqFz/r6tPdY4hC4s
         68vCtrLiWI8HJy0n6aNovV/iz6SzjtL4nujaN2kRLc57Hv2HTNpqgPdMSvDzSjWu3/m1
         /RhA==
X-Gm-Message-State: AOAM533064FztGt+5NlE/oeNTeuQK5tgPHLnY3zkL3l9CiWosEW4hgm8
        LKKz8rXSvBAvDFscxBw0dukRZA==
X-Google-Smtp-Source: ABdhPJxV7dXx9oYLLYKaZWYQUOlR4GVI03/GJ5W/+RMY3mRb75ZKPONwNUoGp6uEe7gqZSngjxUlYg==
X-Received: by 2002:a17:90a:398f:: with SMTP id z15mr125059pjb.183.1623281268943;
        Wed, 09 Jun 2021 16:27:48 -0700 (PDT)
Received: from n124-121-013.byted.org (ec2-54-241-92-238.us-west-1.compute.amazonaws.com. [54.241.92.238])
        by smtp.gmail.com with ESMTPSA id k1sm526783pfa.30.2021.06.09.16.27.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Jun 2021 16:27:48 -0700 (PDT)
From:   Jiang Wang <jiang.wang@bytedance.com>
To:     sgarzare@redhat.com
Cc:     virtualization@lists.linux-foundation.org, stefanha@redhat.com,
        mst@redhat.com, arseny.krasnov@kaspersky.com,
        jhansen@vmware.comments, cong.wang@bytedance.com,
        duanxiongchun@bytedance.com, xieyongji@bytedance.com,
        chaiwen.cc@bytedance.com, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        Lu Wei <luwei32@huawei.com>,
        Alexander Popov <alex.popov@linux.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC v1 5/6] vhost/vsock: add kconfig for vhost dgram support
Date:   Wed,  9 Jun 2021 23:24:57 +0000
Message-Id: <20210609232501.171257-6-jiang.wang@bytedance.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20210609232501.171257-1-jiang.wang@bytedance.com>
References: <20210609232501.171257-1-jiang.wang@bytedance.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Also change number of vqs according to the config

Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
---
 drivers/vhost/Kconfig |  8 ++++++++
 drivers/vhost/vsock.c | 11 ++++++++---
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
index 587fbae06182..d63fffee6007 100644
--- a/drivers/vhost/Kconfig
+++ b/drivers/vhost/Kconfig
@@ -61,6 +61,14 @@ config VHOST_VSOCK
 	To compile this driver as a module, choose M here: the module will be called
 	vhost_vsock.
 
+config VHOST_VSOCK_DGRAM
+	bool "vhost vsock datagram sockets support"
+	depends on VHOST_VSOCK
+	default n
+	help
+	Enable vhost-vsock to support datagram types vsock.  The QEMU
+	and the guest must support datagram types too to use it.
+
 config VHOST_VDPA
 	tristate "Vhost driver for vDPA-based backend"
 	depends on EVENTFD
diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index d366463be6d4..12ca1dc0268f 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -48,7 +48,11 @@ static DEFINE_READ_MOSTLY_HASHTABLE(vhost_vsock_hash, 8);
 
 struct vhost_vsock {
 	struct vhost_dev dev;
+#ifdef CONFIG_VHOST_VSOCK_DGRAM
 	struct vhost_virtqueue vqs[4];
+#else
+	struct vhost_virtqueue vqs[2];
+#endif
 
 	/* Link to global vhost_vsock_hash, writes use vhost_vsock_mutex */
 	struct hlist_node hash;
@@ -763,15 +767,16 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
 
 	vqs[VSOCK_VQ_TX] = &vsock->vqs[VSOCK_VQ_TX];
 	vqs[VSOCK_VQ_RX] = &vsock->vqs[VSOCK_VQ_RX];
-	vqs[VSOCK_VQ_DGRAM_TX] = &vsock->vqs[VSOCK_VQ_DGRAM_TX];
-	vqs[VSOCK_VQ_DGRAM_RX] = &vsock->vqs[VSOCK_VQ_DGRAM_RX];
 	vsock->vqs[VSOCK_VQ_TX].handle_kick = vhost_vsock_handle_tx_kick;
 	vsock->vqs[VSOCK_VQ_RX].handle_kick = vhost_vsock_handle_rx_kick;
+#ifdef CONFIG_VHOST_VSOCK_DGRAM
+	vqs[VSOCK_VQ_DGRAM_TX] = &vsock->vqs[VSOCK_VQ_DGRAM_TX];
+	vqs[VSOCK_VQ_DGRAM_RX] = &vsock->vqs[VSOCK_VQ_DGRAM_RX];
 	vsock->vqs[VSOCK_VQ_DGRAM_TX].handle_kick =
 						vhost_vsock_handle_tx_kick;
 	vsock->vqs[VSOCK_VQ_DGRAM_RX].handle_kick =
 						vhost_vsock_handle_rx_kick;
-
+#endif
 	vhost_dev_init(&vsock->dev, vqs, ARRAY_SIZE(vsock->vqs),
 		       UIO_MAXIOV, VHOST_VSOCK_PKT_WEIGHT,
 		       VHOST_VSOCK_WEIGHT, true, NULL);
-- 
2.11.0

