Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7972FC1D9
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 22:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389184AbhASSt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 13:49:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404335AbhASSAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 13:00:54 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD92DC0613CF;
        Tue, 19 Jan 2021 09:59:21 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id 6so13349322wri.3;
        Tue, 19 Jan 2021 09:59:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k7/hoLcnw6l2pu/nWsn638Uybn8/h44erkd3cqMs75g=;
        b=hG/Z8cxwdJfUwuWkI4Gn1KKKrYD3QFQ+PSFlvjzWIMltM0fCLG8e/J0EaDG1kUGSii
         8SmAp1J8GtCIHJ1fnghHPx/49CqSRr4rfX1DPrFm0vs62k4cK9PyVEoB91tui0dOf7Ab
         I5gRq4YR58iffU7QkMv9KaBsDuxVCYNkk7eNz/KzYbmrGgbD6mfACxjGmO8jRYdFKKDc
         NofAT1EmrOZ+PDzNnhdNtMLu/VVLxLXc1HkhY5C26sTIHYPXz6BW/1V8k5qv+3nY+LOe
         4ucTrw27Lxeypp0luIMOhrXX07ZATMIbEXOJoeZHbKmCbD11TTI7SK4O+q7zX+IdGRkl
         0p7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k7/hoLcnw6l2pu/nWsn638Uybn8/h44erkd3cqMs75g=;
        b=YyX0XaElJs94mk2o/MAG7ihZWHEBa35kEKESseIIOIB5oXsyLvdl7VqCSOrwnoYiZi
         yWV9axwTyEXtfuWgxkBqp1yQuedvIUZvqFkqvySSan2WYMU0aSOr19X1X1qxd1HhHpVq
         /jQWh7P2jBgh3/C/7bxMCQy7WsKC4O9tV9wR/wOuvgsg2KtlA6/dmH+jGhFCGWXtZeOP
         fk1ToAmsC1ySCK5SKsY4GiU0deyiZvUNohITCRFDAi6YGknF3Ccjv+VREoLvNfhfJmA6
         ZJFdJTfVbddCU+eycNn8ALgXNhLmbxeNiUen0HAq06jfF4oiggEEg1J6RHkq6GxS9PCq
         2XEQ==
X-Gm-Message-State: AOAM531hrSpWL5d+Y56SawuksP1/jmaTQVnMUoZbmKIv/QpWf4OjQPc6
        ewXPMmLMVd2NUZpvS1Ip5OsJVAH3ew6QgK2E
X-Google-Smtp-Source: ABdhPJwsTE2uhK37bOtWS6R13mPLJGFm6cEvjrlojQ7dXlEEfTIXWa8v3KW/2mwnUYWKOq+eb35O6Q==
X-Received: by 2002:adf:d238:: with SMTP id k24mr5440011wrh.414.1611079160233;
        Tue, 19 Jan 2021 09:59:20 -0800 (PST)
Received: from anparri.mshome.net (host-79-50-177-118.retail.telecomitalia.it. [79.50.177.118])
        by smtp.gmail.com with ESMTPSA id h125sm5899312wmh.16.2021.01.19.09.59.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 09:59:19 -0800 (PST)
From:   "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Saruhan Karademir <skarade@microsoft.com>,
        Juan Vazquez <juvazq@microsoft.com>,
        linux-hyperv@vger.kernel.org,
        "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 4/4] hv_netvsc: Restrict configurations on isolated guests
Date:   Tue, 19 Jan 2021 18:58:41 +0100
Message-Id: <20210119175841.22248-5-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210119175841.22248-1-parri.andrea@gmail.com>
References: <20210119175841.22248-1-parri.andrea@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Restrict the NVSP protocol version(s) that will be negotiated with the
host to be NVSP_PROTOCOL_VERSION_61 or greater if the guest is running
isolated.  Moreover, do not advertise the SR-IOV capability and ignore
NVSP_MSG_4_TYPE_SEND_VF_ASSOCIATION messages in isolated guests, which
are not supposed to support SR-IOV.  This reduces the footprint of the
code that will be exercised by Confidential VMs and hence the exposure
to bugs and vulnerabilities.

Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
---
 drivers/net/hyperv/netvsc.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 1510a236aa341..8027d553cb67d 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -22,6 +22,7 @@
 #include <linux/prefetch.h>
 
 #include <asm/sync_bitops.h>
+#include <asm/mshyperv.h>
 
 #include "hyperv_net.h"
 #include "netvsc_trace.h"
@@ -544,7 +545,8 @@ static int negotiate_nvsp_ver(struct hv_device *device,
 	init_packet->msg.v2_msg.send_ndis_config.capability.ieee8021q = 1;
 
 	if (nvsp_ver >= NVSP_PROTOCOL_VERSION_5) {
-		init_packet->msg.v2_msg.send_ndis_config.capability.sriov = 1;
+		if (!hv_is_isolation_supported())
+			init_packet->msg.v2_msg.send_ndis_config.capability.sriov = 1;
 
 		/* Teaming bit is needed to receive link speed updates */
 		init_packet->msg.v2_msg.send_ndis_config.capability.teaming = 1;
@@ -563,6 +565,13 @@ static int negotiate_nvsp_ver(struct hv_device *device,
 	return ret;
 }
 
+static bool nvsp_is_valid_version(u32 version)
+{
+       if (hv_is_isolation_supported())
+               return version >= NVSP_PROTOCOL_VERSION_61;
+       return true;
+}
+
 static int netvsc_connect_vsp(struct hv_device *device,
 			      struct netvsc_device *net_device,
 			      const struct netvsc_device_info *device_info)
@@ -579,12 +588,17 @@ static int netvsc_connect_vsp(struct hv_device *device,
 	init_packet = &net_device->channel_init_pkt;
 
 	/* Negotiate the latest NVSP protocol supported */
-	for (i = ARRAY_SIZE(ver_list) - 1; i >= 0; i--)
+	for (i = ARRAY_SIZE(ver_list) - 1; i >= 0; i--) {
+		if (!nvsp_is_valid_version(ver_list[i])) {
+			ret = -EPROTO;
+			goto cleanup;
+		}
 		if (negotiate_nvsp_ver(device, net_device, init_packet,
 				       ver_list[i])  == 0) {
 			net_device->nvsp_version = ver_list[i];
 			break;
 		}
+	}
 
 	if (i < 0) {
 		ret = -EPROTO;
@@ -1357,7 +1371,8 @@ static void netvsc_receive_inband(struct net_device *ndev,
 		break;
 
 	case NVSP_MSG4_TYPE_SEND_VF_ASSOCIATION:
-		netvsc_send_vf(ndev, nvmsg, msglen);
+		if (!hv_is_isolation_supported())
+			netvsc_send_vf(ndev, nvmsg, msglen);
 		break;
 	}
 }
-- 
2.25.1

