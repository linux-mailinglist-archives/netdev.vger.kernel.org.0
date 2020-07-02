Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED02211E50
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 10:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728697AbgGBIXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 04:23:39 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:59632 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728663AbgGBIXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 04:23:36 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0628NRFx082069;
        Thu, 2 Jul 2020 03:23:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1593678207;
        bh=eGYb68Z81KhdwdWoOADJFuS9KisslFzKd0+Ho98yHF4=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=F0noB78AMveWf8E6/OYl0fvkIWUkgc8p1+tAJru1wvoGuIlwhyTOKLqRzzREVMbIb
         c7ubOUbj1+YlQEkv9bxxVzvmWBuTCDqVMO92gzyvCxs6XfLxklkzRgHJmP67Jzn1Se
         PLGX/HHRmdUR/21XYGVtP4/I5Rf5cywezjz+DbXY=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0628NRB2032083
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 2 Jul 2020 03:23:27 -0500
Received: from DFLE113.ent.ti.com (10.64.6.34) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 2 Jul
 2020 03:23:26 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 2 Jul 2020 03:23:26 -0500
Received: from a0393678ub.india.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0628LiYT006145;
        Thu, 2 Jul 2020 03:23:21 -0500
From:   Kishon Vijay Abraham I <kishon@ti.com>
To:     Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Jon Mason <jdmason@kudzu.us>,
        Dave Jiang <dave.jiang@intel.com>,
        Allen Hubbe <allenbh@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
CC:     <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-remoteproc@vger.kernel.org>, <linux-ntb@googlegroups.com>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>
Subject: [RFC PATCH 17/22] rpmsg.txt: Add Documentation to configure rpmsg using configfs
Date:   Thu, 2 Jul 2020 13:51:38 +0530
Message-ID: <20200702082143.25259-18-kishon@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200702082143.25259-1-kishon@ti.com>
References: <20200702082143.25259-1-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Documentation on how rpmsg device can be created using
configfs required for vhost_rpmsg_bus.c

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 Documentation/rpmsg.txt | 56 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/Documentation/rpmsg.txt b/Documentation/rpmsg.txt
index 24b7a9e1a5f9..0e0a32b2cb66 100644
--- a/Documentation/rpmsg.txt
+++ b/Documentation/rpmsg.txt
@@ -339,3 +339,59 @@ by the bus, and can then start sending messages to the remote service.
 
 The plan is also to add static creation of rpmsg channels via the virtio
 config space, but it's not implemented yet.
+
+Configuring rpmsg using configfs
+================================
+
+Usually a rpmsg_device is created when the virtproc driver (virtio_rpmsg_bus.c)
+receives a name service notification from the remote core. However there could
+also be cases where the user should be given the ability to create rpmsg_device
+(like in the case of vhost_rpmsg_bus.c) where vhost_rpmsg_bus should be
+responsible for sending name service notification. For such cases, configfs
+provides an ability to the user for binding a rpmsg_client_driver with virtproc
+device in order to create rpmsg_device.
+
+Two configfs directories are added for configuring rpmsg
+::
+
+  # ls /sys/kernel/config/rpmsg/
+    channel   virtproc
+
+channel: Whenever a new rpmsg_driver is registered with rpmsg core, a new
+sub-directory will be created for each entry provided in rpmsg_device_id
+table of rpmsg_driver.
+
+For instance when rpmsg_sample_client is installed, it'll create the following
+entry in the mounted configfs directory
+::
+
+  # ls /sys/kernel/config/rpmsg/channel/
+    rpmsg-client-sample
+
+virtproc: A virtproc device can choose to add an entry in this directory.
+Virtproc device adds an entry if it has to allow user to control creation of
+rpmsg device. (e.g vhost_rpmsg_bus.c)
+::
+
+  # ls /sys/kernel/config/rpmsg/virtproc/
+    vhost0
+
+
+The first step in allowing the user to create rpmsg device is to create a
+sub-directory rpmsg-client-sample. For each rpmsg_device, the user would like
+to create, a separate subdirectory has to be created.
+::
+
+  # mkdir /sys/kernel/config/rpmsg/channel/rpmsg-client-sample/c1
+
+The next step is to link the created sub-directory with virtproc device to
+create rpmsg device.
+::
+
+  # ln -s /sys/kernel/config/rpmsg/channel/rpmsg-client-sample/c1 \
+        /sys/kernel/config/rpmsg/virtproc/vhost0
+
+This will create rpmsg_device. However the driver will not register the
+rpmsg device until it receives the VIRTIO_CONFIG_S_DRIVER_OK (in the case
+of vhost_rpmsg_bus.c) as it can access virtio buffers only after
+VIRTIO_CONFIG_S_DRIVER_OK is set.
-- 
2.17.1

