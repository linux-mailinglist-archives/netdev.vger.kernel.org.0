Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0FA179F18
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 06:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbgCEFXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 00:23:33 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45366 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbgCEFXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 00:23:33 -0500
Received: by mail-pf1-f194.google.com with SMTP id 2so2162798pfg.12
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 21:23:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rc6jNvp/c23UvoUnFO2kVN5wxgcAoTsXXqLWvToQMSg=;
        b=GLCRX0UaUnax0xL8/G+sCdPa4ai/nRD/pCtN+gpuHbNXUcsXie7ZMntWQAOn8dH7dN
         ZKNZUyY+mWG+AGitv+SDjCfk7dJ9Ro/7mKm5Fm2dlv4Cg2N0DoXOuDDnHvrg63aHnZ5E
         dHH6/BhiknA4dDg3jRQ/dU3l+L/KRMjwcFJmuPEMn4IkUKBw6n7P/P9REeQEpEy2I6Z2
         sZS1O9Q9n7jD2ITZbQd0D/W/cVzCpxSxt/KhYEB+UYwilmrDdvDuvXaRjnVBy28yqbIB
         cg7UK8qgERUE6PfU4HQEjEi/yuksPtrthkqWDjZrkqkAVhlHi/Lw5PCkH94FN8DMwfmu
         2R4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=rc6jNvp/c23UvoUnFO2kVN5wxgcAoTsXXqLWvToQMSg=;
        b=XOQF+HbkNaOSreSOyTf9fJYtbLyiOELgeCzHLey1ygahRDs2kw8Qa6cvFlrQC0Ihw+
         K+SSOniuxQutHViZsXBcNCX4mp3NNI4xTgWx/E6QGAm9Lv3KYvvPWCivV1STqSyoRsE5
         UTlQPMLI61d8rNC7LuOkDjeu5jjAHnKEvGIBOIDD7593MjWaJ32ayF22gYz/QWfm5anM
         8tTF51oVzUJ7ltP8HF+JM0+XCXzi4/eUKAGkzahUV7QR/vsZ18JGKVpXDhAz1vF6SFxI
         xj/UdmedZutEGATRO7FQyUwQhscRJWEalovHaeWXZUX6hWnVLON1sRcnKai9R3v/lVNX
         dzuA==
X-Gm-Message-State: ANhLgQ0msx9INYhxjxAnQ4kW8vqOCncGwH5rIC/9YrtBaVkPKmeStXwT
        lwFRJqTduH5FU1KELx2CAq16XQHsBMs=
X-Google-Smtp-Source: ADFU+vsZgfVEv9BCYCqBijs6fFyjohSL3deSvQUheImibn1djIZgZwpjMELuCFI7lC4fvVoBGWXkEQ==
X-Received: by 2002:a63:cc4c:: with SMTP id q12mr5722464pgi.443.1583385810353;
        Wed, 04 Mar 2020 21:23:30 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id h2sm29337759pgv.40.2020.03.04.21.23.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Mar 2020 21:23:29 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 2/8] ionic: remove pragma packed
Date:   Wed,  4 Mar 2020 21:23:13 -0800
Message-Id: <20200305052319.14682-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200305052319.14682-1-snelson@pensando.io>
References: <20200305052319.14682-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the misguided "#pragma packed" with tags on each
struct/union definition that actually needs it.  This is safer
and more efficient on the various compilers and architectures.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_if.h    | 38 +++++++++----------
 1 file changed, 17 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_if.h b/drivers/net/ethernet/pensando/ionic/ionic_if.h
index ce07c2931a72..e5e98067fba4 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_if.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_if.h
@@ -4,8 +4,6 @@
 #ifndef _IONIC_IF_H_
 #define _IONIC_IF_H_
 
-#pragma pack(push, 1)
-
 #define IONIC_DEV_INFO_SIGNATURE		0x44455649      /* 'DEVI' */
 #define IONIC_DEV_INFO_VERSION			1
 #define IONIC_IFNAMSIZ				16
@@ -366,7 +364,7 @@ union ionic_lif_config {
 		u8     rsvd2[2];
 		__le64 features;
 		__le32 queue_count[IONIC_QTYPE_MAX];
-	};
+	} __packed;
 	__le32 words[64];
 };
 
@@ -417,7 +415,7 @@ union ionic_lif_identity {
 			__le32 max_frame_size;
 			u8 rsvd2[106];
 			union ionic_lif_config config;
-		} eth;
+		} __packed eth;
 
 		struct {
 			u8 version;
@@ -439,8 +437,8 @@ union ionic_lif_identity {
 			struct ionic_lif_logical_qtype rq_qtype;
 			struct ionic_lif_logical_qtype cq_qtype;
 			struct ionic_lif_logical_qtype eq_qtype;
-		} rdma;
-	};
+		} __packed rdma;
+	} __packed;
 	__le32 words[512];
 };
 
@@ -526,7 +524,7 @@ struct ionic_q_init_cmd {
 	__le64 sg_ring_base;
 	__le32 eq_index;
 	u8     rsvd2[16];
-};
+} __packed;
 
 /**
  * struct ionic_q_init_comp - Queue init command completion
@@ -1095,7 +1093,7 @@ struct ionic_port_status {
 	u8     status;
 	u8     rsvd[51];
 	struct ionic_xcvr_status  xcvr;
-};
+} __packed;
 
 /**
  * struct ionic_port_identify_cmd - Port identify command
@@ -1251,7 +1249,7 @@ struct ionic_port_getattr_comp {
 		u8      pause_type;
 		u8      loopback_mode;
 		u8      rsvd2[11];
-	};
+	} __packed;
 	u8     color;
 };
 
@@ -1319,7 +1317,7 @@ struct ionic_dev_setattr_cmd {
 		char    name[IONIC_IFNAMSIZ];
 		__le64  features;
 		u8      rsvd2[60];
-	};
+	} __packed;
 };
 
 /**
@@ -1334,7 +1332,7 @@ struct ionic_dev_setattr_comp {
 	union {
 		__le64  features;
 		u8      rsvd2[11];
-	};
+	} __packed;
 	u8     color;
 };
 
@@ -1361,7 +1359,7 @@ struct ionic_dev_getattr_comp {
 	union {
 		__le64  features;
 		u8      rsvd2[11];
-	};
+	} __packed;
 	u8     color;
 };
 
@@ -1426,7 +1424,7 @@ struct ionic_lif_setattr_cmd {
 		} rss;
 		u8	stats_ctl;
 		u8      rsvd[60];
-	};
+	} __packed;
 };
 
 /**
@@ -1444,7 +1442,7 @@ struct ionic_lif_setattr_comp {
 	union {
 		__le64  features;
 		u8      rsvd2[11];
-	};
+	} __packed;
 	u8     color;
 };
 
@@ -1483,7 +1481,7 @@ struct ionic_lif_getattr_comp {
 		u8      mac[6];
 		__le64  features;
 		u8      rsvd2[11];
-	};
+	} __packed;
 	u8     color;
 };
 
@@ -1688,7 +1686,7 @@ struct ionic_vf_setattr_cmd {
 		u8     linkstate;
 		__le64 stats_pa;
 		u8     pad[60];
-	};
+	} __packed;
 };
 
 struct ionic_vf_setattr_comp {
@@ -1726,7 +1724,7 @@ struct ionic_vf_getattr_comp {
 		u8     linkstate;
 		__le64 stats_pa;
 		u8     pad[11];
-	};
+	} __packed;
 	u8     color;
 };
 
@@ -2471,7 +2469,7 @@ union ionic_dev_cmd_regs {
 		union ionic_dev_cmd_comp    comp;
 		u8                    rsvd[48];
 		u32                   data[478];
-	};
+	} __packed;
 	u32 words[512];
 };
 
@@ -2484,7 +2482,7 @@ union ionic_dev_regs {
 	struct {
 		union ionic_dev_info_regs info;
 		union ionic_dev_cmd_regs  devcmd;
-	};
+	} __packed;
 	__le32 words[1024];
 };
 
@@ -2574,6 +2572,4 @@ struct ionic_identity {
 	union ionic_qos_identity qos;
 };
 
-#pragma pack(pop)
-
 #endif /* _IONIC_IF_H_ */
-- 
2.17.1

