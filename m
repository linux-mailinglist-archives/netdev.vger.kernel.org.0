Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73DDB17CA13
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 02:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbgCGBEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 20:04:21 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41472 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726733AbgCGBEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 20:04:20 -0500
Received: by mail-pl1-f195.google.com with SMTP id t14so1554147plr.8
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 17:04:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rc6jNvp/c23UvoUnFO2kVN5wxgcAoTsXXqLWvToQMSg=;
        b=z6OsC8DlGcudmcvIswv3rlDogtgOLKf/DfPmofT2dWMIsk96LxDcfrLnfC/8Lm3tNt
         Pf3dMYtK6ub4m/XDPdP9rTsULBaScQMjOujXdh9ohOhEVm5Ix4x/3JHtjvOhFLRRWLJz
         xVzpKe1aE5m07zjRJeyzibsBj7p07+K/ccklRcizy2Q/MXqgvCFY60jHgFBjIvQlSSoe
         +6KRRse5YC3yM1dkANT4awCFQQ7GKpz2Y7u7zTQHcsxdyxBxyAVAYKEZB85fF3wwvd9x
         IUE7Lu4DHpm3Mw08IXT3wJQ0A69l2nRqJWTyBNc2XI71ZekXeRzahVGKn2Iu0Xh29+ai
         fozQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=rc6jNvp/c23UvoUnFO2kVN5wxgcAoTsXXqLWvToQMSg=;
        b=J+PN55hwOb+P2EDoePef9hZDUubO8QEvOAsv5DbXiJRcFzzmKZjVOMSmi0d2HyOMci
         74w+rCcCP6wcIYS/rPSMi7tHUHl8YhxNnZD4VpZSzzBz4v1sYAO1SASAU9SMSXuW+nmQ
         HfXegy8tPJEFMEOkR+TBX7U1mV81FBrrnUJxYzglosgkJOm9KIe6RwgMOIKc5OMy3QSq
         H1y7W2QoQLtZP54ZaWRbguFIEco7PyvIUPlT3D3IYo+7QvNmpstHMN94ZjBrwifM6fNT
         dByPs4XljXMoZXH+SqfGS7snBT6+u7TtvoZOalENwcakZsTvIyBv6mHf7ZNVseeKGPv5
         84wA==
X-Gm-Message-State: ANhLgQ1PRqzUdPT7J1VJWnjuIEJSoBr/8vi5wgtknqM0J9Sl4AkQNVNY
        NiC48fd0Efk2RBB7tyUAzNe92pBAQhg=
X-Google-Smtp-Source: ADFU+vsawjtSJSGdEE6k6J2PVuKXoRcJXM25kGAVq6xRDnWH2kLx8XMWm6LnRSjdar7IIvy4n+DR/A==
X-Received: by 2002:a17:90a:b10d:: with SMTP id z13mr6553809pjq.132.1583543059191;
        Fri, 06 Mar 2020 17:04:19 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id o66sm23224949pfb.93.2020.03.06.17.04.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Mar 2020 17:04:18 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v4 net-next 2/8] ionic: remove pragma packed
Date:   Fri,  6 Mar 2020 17:04:02 -0800
Message-Id: <20200307010408.65704-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200307010408.65704-1-snelson@pensando.io>
References: <20200307010408.65704-1-snelson@pensando.io>
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

