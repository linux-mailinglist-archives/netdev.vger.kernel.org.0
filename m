Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A45730AB4C
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 16:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231643AbhBAP3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 10:29:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbhBAOt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 09:49:27 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A14C0613ED;
        Mon,  1 Feb 2021 06:48:45 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id e15so13412227wme.0;
        Mon, 01 Feb 2021 06:48:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NXmjZGDtwtRpXSM4EkkisMkH5FybRiSoeeMKyZ65veQ=;
        b=I3QPeOuGXt7cnwZ52uYRWZdkCLRq04qDIJ+AzC5DMJharQBeOu3NY5IXl8ua7QUvsf
         9UUSQmavIzeOz30PZ626kCh9lXxdoOZ0kxNdHrIpBDHt7dmfefak6hZvdrzgjFOvSr9H
         MTUFhm/W4VoINqbpYCPJUGOT0ju6OWMFXY+eUykrvx8+3CGZjwBYn8Xq1Tj9CzGinxAe
         bWpAZ1o/3IuvB1rcnQD3omv8F331QN6+46gxXvSRNW8HBKI2LSl3OBpR8wqjgf9Ipxvp
         mSXNQXhUSaF0iAzOJBGNAxzbeMqMUg0fvsO1LsW70fgVbsvgxSwoem83JgJj+pv/LFXm
         ojWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NXmjZGDtwtRpXSM4EkkisMkH5FybRiSoeeMKyZ65veQ=;
        b=KVjZEnnCZgKo7/fK02Uma8/o0TRk/kfAgysfMkmmKQ2ScOnW2bg09Jb37sbvIpL2xT
         zLR545eaU4ZjYYlkwTTgbGafVOUZVQZkbtD7FETOTdA2ko3F9OUop3QPjopSClHk2QP8
         Z4Tur3b+bOFCp9IoiYlHXrju23GYylFMyE1oc+oa0cvUffFtelgMWKXkv8myYFVFpUZX
         z0o31/6UadZz/5c0yg7YN/5e7p7rWAKSN5QCAHKTX62+d9jGyyla5aWFVKNunvuHGJt+
         LvY2nzLmGBAn2aMMs4i0WAtI1HGdZd7JyLdhDNW5I8ZBWsN3SuNy/802t/bOCWvinRc5
         uirg==
X-Gm-Message-State: AOAM532+RJYbll6+52j38yf7D7rH6ABsbOihJQLUPykFfEvSNUZoBySD
        X9pnyzxt++N1Im0JQVsNHyYXhplWSPVMC7Q2
X-Google-Smtp-Source: ABdhPJyox0X1TtodTmYQpq525lRGey0Et8jEXtJcCdTDPKuf3X0dteWR/lCtiH4EvCbddVkAtqtAQA==
X-Received: by 2002:a1c:6289:: with SMTP id w131mr7347394wmb.0.1612190923373;
        Mon, 01 Feb 2021 06:48:43 -0800 (PST)
Received: from anparri.mshome.net (host-95-238-70-33.retail.telecomitalia.it. [95.238.70.33])
        by smtp.gmail.com with ESMTPSA id c11sm26106591wrs.28.2021.02.01.06.48.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 06:48:42 -0800 (PST)
From:   "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        linux-hyperv@vger.kernel.org,
        Saruhan Karademir <skarade@microsoft.com>,
        Juan Vazquez <juvazq@microsoft.com>,
        "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH v3 hyperv-next 4/4] hv_netvsc: Restrict configurations on isolated guests
Date:   Mon,  1 Feb 2021 15:48:14 +0100
Message-Id: <20210201144814.2701-5-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210201144814.2701-1-parri.andrea@gmail.com>
References: <20210201144814.2701-1-parri.andrea@gmail.com>
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
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
---
 drivers/net/hyperv/netvsc.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 1510a236aa341..51005f2d4a821 100644
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
+		if (hv_is_isolation_supported())
+			netdev_info(ndev, "SR-IOV not advertised by guests on the host supporting isolation\n");
+		else
+			init_packet->msg.v2_msg.send_ndis_config.capability.sriov = 1;
 
 		/* Teaming bit is needed to receive link speed updates */
 		init_packet->msg.v2_msg.send_ndis_config.capability.teaming = 1;
@@ -591,6 +595,13 @@ static int netvsc_connect_vsp(struct hv_device *device,
 		goto cleanup;
 	}
 
+	if (hv_is_isolation_supported() && net_device->nvsp_version < NVSP_PROTOCOL_VERSION_61) {
+		netdev_err(ndev, "Invalid NVSP version 0x%x (expected >= 0x%x) from the host supporting isolation\n",
+			   net_device->nvsp_version, NVSP_PROTOCOL_VERSION_61);
+		ret = -EPROTO;
+		goto cleanup;
+	}
+
 	pr_debug("Negotiated NVSP version:%x\n", net_device->nvsp_version);
 
 	/* Send the ndis version */
@@ -1357,7 +1368,10 @@ static void netvsc_receive_inband(struct net_device *ndev,
 		break;
 
 	case NVSP_MSG4_TYPE_SEND_VF_ASSOCIATION:
-		netvsc_send_vf(ndev, nvmsg, msglen);
+		if (hv_is_isolation_supported())
+			netdev_err(ndev, "Ignore VF_ASSOCIATION msg from the host supporting isolation\n");
+		else
+			netvsc_send_vf(ndev, nvmsg, msglen);
 		break;
 	}
 }
-- 
2.25.1

