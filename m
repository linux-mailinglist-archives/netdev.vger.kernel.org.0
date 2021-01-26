Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE7E303C43
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 12:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405108AbhAZL6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 06:58:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405106AbhAZL6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 06:58:06 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB13BC061786;
        Tue, 26 Jan 2021 03:57:24 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id a9so16152046wrt.5;
        Tue, 26 Jan 2021 03:57:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JNyhayEQUd/VOdsUxEkVRqD5at4MpPP2YgdbCdDLx9U=;
        b=Kb5fR7v/Y+AH1NNFt2aoAEOLTcYZHOaun+NwA7MK1HhEtOvG/JprTa+uWtFuKAaoZq
         Y/Syws8KtWKcUa5okNXDSuug0ypcPUSS8A7YaloxHFg3lMgDfkcUXjfmDn20/U5S3xHf
         +sBSrcuySB5UG6/rAuH/7l2sX/Qr0QMfC58vnLVIKDKt2GvjV81x/rjM+p55pOe8CslA
         Zo3WUs/Sa3JsT829YIwiHUPeTN47NP8xJjp6KiRrCrW9eu+bhp4h+tfyO1TB61wvcCRl
         uvE9s+Kwna649KKznGNAV1PawEBybItUK81XZUzFUuVw2SAbT8LxwcGiL3f44G61OvnP
         UCmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JNyhayEQUd/VOdsUxEkVRqD5at4MpPP2YgdbCdDLx9U=;
        b=Ad0/Ki4SjvXKXBpIznktGH7VZxoe3myH4JwUlcVENssSSFIEvrI1lm04xAmD9pUthk
         MSZOZJ/e+gU+RhkG+eoS+81dCDtTL3RMI9882I2YcV9Bn70psZ/XOYnOenXwAt3wnqPl
         KF1VZzjKd404vlIeqQnUkPES4eJjUBkzAlQIG/eS3hwdEDs2r/tmzOutJdgbZAPFttGG
         wnuVvy1yHNq7u9/1S1dAaI2Qrn8pX6Wcqm+Uzd1AjBhkBoiv7ZiqFRvmKuPjNdPYjvMs
         GElQCh9rZvYz22N1+y5nrpjihOyIwEX0l0q5Mt6Qq9751FstuNqyDSMWh/+vcLtF75hB
         hCuA==
X-Gm-Message-State: AOAM533VICw2DGffdqMRfmu5CszddvbMNBIs/HOzvo8e5C2157+p2aNp
        haUr6W8qmUirlB1JWyTFcWc2b6mfGhARTUvJ
X-Google-Smtp-Source: ABdhPJzvgXH5eGhJTdqrSu3O9E52aIb/HLxAUfwt4p2B0BRoQZl7tVgE+TuBfuHG+n3sBolUzc54nQ==
X-Received: by 2002:a5d:60d0:: with SMTP id x16mr5711371wrt.269.1611662243171;
        Tue, 26 Jan 2021 03:57:23 -0800 (PST)
Received: from anparri.mshome.net (host-95-238-70-33.retail.telecomitalia.it. [95.238.70.33])
        by smtp.gmail.com with ESMTPSA id z185sm3330283wmb.0.2021.01.26.03.57.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 03:57:22 -0800 (PST)
From:   "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Saruhan Karademir <skarade@microsoft.com>,
        Juan Vazquez <juvazq@microsoft.com>,
        "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH v2 4/4] hv_netvsc: Restrict configurations on isolated guests
Date:   Tue, 26 Jan 2021 12:56:41 +0100
Message-Id: <20210126115641.2527-5-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210126115641.2527-1-parri.andrea@gmail.com>
References: <20210126115641.2527-1-parri.andrea@gmail.com>
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
Acked-by: Jakub Kicinski <kuba@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
---
 drivers/net/hyperv/netvsc.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 1510a236aa341..afd92b4aa21fe 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -22,6 +22,7 @@
 #include <linux/prefetch.h>
 
 #include <asm/sync_bitops.h>
+#include <asm/mshyperv.h>
 
 #include "hyperv_net.h"
 #include "netvsc_trace.h"
@@ -544,7 +545,10 @@ static int negotiate_nvsp_ver(struct hv_device *device,
 	init_packet->msg.v2_msg.send_ndis_config.capability.ieee8021q = 1;
 
 	if (nvsp_ver >= NVSP_PROTOCOL_VERSION_5) {
-		init_packet->msg.v2_msg.send_ndis_config.capability.sriov = 1;
+		if (!hv_is_isolation_supported())
+			init_packet->msg.v2_msg.send_ndis_config.capability.sriov = 1;
+		else
+			netdev_info(ndev, "SR-IOV not advertised by guests on the host supporting isolation\n");
 
 		/* Teaming bit is needed to receive link speed updates */
 		init_packet->msg.v2_msg.send_ndis_config.capability.teaming = 1;
@@ -563,6 +567,13 @@ static int negotiate_nvsp_ver(struct hv_device *device,
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
@@ -579,12 +590,19 @@ static int netvsc_connect_vsp(struct hv_device *device,
 	init_packet = &net_device->channel_init_pkt;
 
 	/* Negotiate the latest NVSP protocol supported */
-	for (i = ARRAY_SIZE(ver_list) - 1; i >= 0; i--)
+	for (i = ARRAY_SIZE(ver_list) - 1; i >= 0; i--) {
 		if (negotiate_nvsp_ver(device, net_device, init_packet,
 				       ver_list[i])  == 0) {
+			if (!nvsp_is_valid_version(ver_list[i])) {
+				netdev_err(ndev, "Invalid NVSP version 0x%x (expected >= 0x%x) from the host with isolation supported\n",
+					   ver_list[i], NVSP_PROTOCOL_VERSION_61);
+				ret = -EPROTO;
+				goto cleanup;
+			}
 			net_device->nvsp_version = ver_list[i];
 			break;
 		}
+	}
 
 	if (i < 0) {
 		ret = -EPROTO;
@@ -1357,7 +1375,10 @@ static void netvsc_receive_inband(struct net_device *ndev,
 		break;
 
 	case NVSP_MSG4_TYPE_SEND_VF_ASSOCIATION:
-		netvsc_send_vf(ndev, nvmsg, msglen);
+		if (!hv_is_isolation_supported())
+			netvsc_send_vf(ndev, nvmsg, msglen);
+		else
+			netdev_err(ndev, "Ignore VF_ASSOCIATION msg from the host supporting isolation\n");
 		break;
 	}
 }
-- 
2.25.1

