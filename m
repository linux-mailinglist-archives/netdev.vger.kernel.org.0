Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF0D1B0E78
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 16:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728973AbgDTOea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 10:34:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57335 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726895AbgDTOea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 10:34:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587393269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=QKgQlmHl/vlNhHGtLDszGPS70GFdJJv30q0eyxymYP8=;
        b=JhrFNeQEQZ9+5TiTewoff+I/1rZLhYVKVJhrqs+0gRNhdwZVQzpuuhNzXtFX2OzXvCh7jw
        Tojk8P0DnhxQLDWA88n9GDxjZbYS7UhsSFNmyzI+ZrC5xFkL2NpBoBo0VNiNQNxAibd00q
        ceHOrDV95FctugBDMq94dta4fnKugzg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-476-vh_vJWUjPjapc2KzC_7GQg-1; Mon, 20 Apr 2020 10:34:27 -0400
X-MC-Unique: vh_vJWUjPjapc2KzC_7GQg-1
Received: by mail-wm1-f70.google.com with SMTP id f17so3570933wmm.5
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 07:34:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=QKgQlmHl/vlNhHGtLDszGPS70GFdJJv30q0eyxymYP8=;
        b=CKmtMqXDwykFy2th0l9JDTsEMlHCnNThSyC60ghptcZnfumo9IF1uG8YNa408K2iIj
         E7wcsbJSJUGSp8PkLT8mRqwkeqcD7ggu1IWa3nLUXvEGZSMsS4/BKd/ifKXM0+jk5Fam
         Yaj7io/WVyQuw6caIDaWHUQ4KIUhwbMyCl/e9sPp60HUcNe18nLLuzR6ozycNAGPP7vJ
         iKaWYPz2RlPSq3edX5IWyssOMWuk+VVjk02n5DPrkdLx6MopYmmZBOReewCsAxBU2S3s
         sQGfH6f++XfZV4B0g8PdckILOfiqMCFiNqJQf7TwRw1avQC4cepOt9kjXDelNN9E6w3n
         8F5g==
X-Gm-Message-State: AGi0PubNRhX1YV/kYYEEDgEod61I3s+tfiot6qxkddAO5eGMKWCeWRcr
        3BsSUXelWLSQ8IiFa9rtaqWvlI6kfPM/tZsO3tiROFtsSj0eTxtuMBVtGvH11Dhog0+gxx+nQs5
        ixI041+ALcpgjNIE+
X-Received: by 2002:a5d:4e02:: with SMTP id p2mr19097330wrt.302.1587393266214;
        Mon, 20 Apr 2020 07:34:26 -0700 (PDT)
X-Google-Smtp-Source: APiQypJPCB2aIBVyG+epiQn8wefNJaBqE0mL7KfjY5M7sLpr1ftDgKPHhXnntLSPOZw2XTiIctqPcQ==
X-Received: by 2002:a5d:4e02:: with SMTP id p2mr19097299wrt.302.1587393265925;
        Mon, 20 Apr 2020 07:34:25 -0700 (PDT)
Received: from redhat.com (bzq-79-183-51-3.red.bezeqint.net. [79.183.51.3])
        by smtp.gmail.com with ESMTPSA id u12sm1690368wmu.25.2020.04.20.07.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 07:34:25 -0700 (PDT)
Date:   Mon, 20 Apr 2020 10:34:23 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Richard Earnshaw <Richard.Earnshaw@arm.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v4] vhost: disable for OABI
Message-ID: <20200420143229.245488-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.24.1.751.gd10ce2899c
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vhost is currently broken on the some ARM configs.

The reason is that the ring element addresses are passed between
components with different alignments assumptions. Thus, if
guest selects a pointer and host then gets and dereferences
it, then alignment assumed by the host's compiler might be
greater than the actual alignment of the pointer.
compiler on the host from assuming pointer is aligned.

This actually triggers on ARM with -mabi=apcs-gnu - which is a
deprecated configuration. With this OABI, compiler assumes that
all structures are 4 byte aligned - which is stronger than
virtio guarantees for available and used rings, which are
merely 2 bytes. Thus a guest without -mabi=apcs-gnu running
on top of host with -mabi=apcs-gnu will be broken.

The correct fix is to force alignment of structures - however
that is an intrusive fix that's best deferred until the next release.

We didn't previously support such ancient systems at all - this surfaced
after vdpa support prompted removing dependency of vhost on
VIRTULIZATION. So for now, let's just add something along the lines of

	depends on !ARM || AEABI

to the virtio Kconfig declaration, and add a comment that it has to do
with struct member alignment.

Note: we can't make VHOST and VHOST_RING themselves have
a dependency since these are selected. Add a new symbol for that.

We should be able to drop this dependency down the road.

Fixes: 20c384f1ea1a0bc7 ("vhost: refine vhost and vringh kconfig")
Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Suggested-by: Richard Earnshaw <Richard.Earnshaw@arm.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

changes from v3:
	update commit log clarifying the motivation and that
	it's a temporary fix.

	suggested by Christoph Hellwig

 drivers/misc/mic/Kconfig |  2 +-
 drivers/net/caif/Kconfig |  2 +-
 drivers/vdpa/Kconfig     |  2 +-
 drivers/vhost/Kconfig    | 17 +++++++++++++----
 4 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/misc/mic/Kconfig b/drivers/misc/mic/Kconfig
index 8f201d019f5a..3bfe72c59864 100644
--- a/drivers/misc/mic/Kconfig
+++ b/drivers/misc/mic/Kconfig
@@ -116,7 +116,7 @@ config MIC_COSM
 
 config VOP
 	tristate "VOP Driver"
-	depends on VOP_BUS
+	depends on VOP_BUS && VHOST_DPN
 	select VHOST_RING
 	select VIRTIO
 	help
diff --git a/drivers/net/caif/Kconfig b/drivers/net/caif/Kconfig
index 9db0570c5beb..661c25eb1c46 100644
--- a/drivers/net/caif/Kconfig
+++ b/drivers/net/caif/Kconfig
@@ -50,7 +50,7 @@ config CAIF_HSI
 
 config CAIF_VIRTIO
 	tristate "CAIF virtio transport driver"
-	depends on CAIF && HAS_DMA
+	depends on CAIF && HAS_DMA && VHOST_DPN
 	select VHOST_RING
 	select VIRTIO
 	select GENERIC_ALLOCATOR
diff --git a/drivers/vdpa/Kconfig b/drivers/vdpa/Kconfig
index 3e1ceb8e9f2b..e8140065c8a5 100644
--- a/drivers/vdpa/Kconfig
+++ b/drivers/vdpa/Kconfig
@@ -10,7 +10,7 @@ if VDPA
 
 config VDPA_SIM
 	tristate "vDPA device simulator"
-	depends on RUNTIME_TESTING_MENU && HAS_DMA
+	depends on RUNTIME_TESTING_MENU && HAS_DMA && VHOST_DPN
 	select VHOST_RING
 	default n
 	help
diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
index 2c75d164b827..c4f273793595 100644
--- a/drivers/vhost/Kconfig
+++ b/drivers/vhost/Kconfig
@@ -13,6 +13,15 @@ config VHOST_RING
 	  This option is selected by any driver which needs to access
 	  the host side of a virtio ring.
 
+config VHOST_DPN
+	bool
+	depends on !ARM || AEABI
+	default y
+	help
+	  Anything selecting VHOST or VHOST_RING must depend on VHOST_DPN.
+	  This excludes the deprecated ARM ABI since that forces a 4 byte
+	  alignment on all structs - incompatible with virtio spec requirements.
+
 config VHOST
 	tristate
 	select VHOST_IOTLB
@@ -28,7 +37,7 @@ if VHOST_MENU
 
 config VHOST_NET
 	tristate "Host kernel accelerator for virtio net"
-	depends on NET && EVENTFD && (TUN || !TUN) && (TAP || !TAP)
+	depends on NET && EVENTFD && (TUN || !TUN) && (TAP || !TAP) && VHOST_DPN
 	select VHOST
 	---help---
 	  This kernel module can be loaded in host kernel to accelerate
@@ -40,7 +49,7 @@ config VHOST_NET
 
 config VHOST_SCSI
 	tristate "VHOST_SCSI TCM fabric driver"
-	depends on TARGET_CORE && EVENTFD
+	depends on TARGET_CORE && EVENTFD && VHOST_DPN
 	select VHOST
 	default n
 	---help---
@@ -49,7 +58,7 @@ config VHOST_SCSI
 
 config VHOST_VSOCK
 	tristate "vhost virtio-vsock driver"
-	depends on VSOCKETS && EVENTFD
+	depends on VSOCKETS && EVENTFD && VHOST_DPN
 	select VHOST
 	select VIRTIO_VSOCKETS_COMMON
 	default n
@@ -63,7 +72,7 @@ config VHOST_VSOCK
 
 config VHOST_VDPA
 	tristate "Vhost driver for vDPA-based backend"
-	depends on EVENTFD
+	depends on EVENTFD && VHOST_DPN
 	select VHOST
 	depends on VDPA
 	help
-- 
MST

