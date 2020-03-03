Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0801E176DE1
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 05:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbgCCEQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 23:16:03 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40947 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726910AbgCCEQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 23:16:03 -0500
Received: by mail-pl1-f195.google.com with SMTP id y1so706178plp.7
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 20:16:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KKBKvNcJGY1TZuV+ovrL2wWJl2GnYYxVCVyMuW9EBv0=;
        b=l0pHfgCMYFjdDNe8Y66X/pNIBOj4kUM6DBx04nOMq/4qbtdsR4eLpe3XKTbnvtnhJf
         SWCNVGW/TAODFqfSHUvDgUoVa1XuwoTsMaB6+bx9J7CQxzSjCRnp2DsMujj8eWdhVln0
         AokMT1YM/j4oyCKmc5h2ewWW5BLYsXrZ04rxxEPss76ykL9bwdMW/1B3VBQySrUAKWdp
         OQr48ama4954bEQK3h+fHTJkBHyNFeuAW2Sm9rRjvO7TgvT4WukWRiQK89Twp50+W1vS
         aWSGj92used5JXF2I96wLUY0gdCo2zmJhhfvcq32CDWJM/G0sEeBgLnIJh7qi37Jb3Ny
         /5+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KKBKvNcJGY1TZuV+ovrL2wWJl2GnYYxVCVyMuW9EBv0=;
        b=MtDYMweOiB957gS9+sxPRipfVxJnxqW+d9XxfgoH8VjoR3ryxR7Yn7J0287iaQ2Evv
         tXnnkU1o+mMJ4ZE98E3Jly7G3B8v3gkU80uph2PNxYTeA2h+yMyLH0wl0WLqdCwxbDBJ
         RkGdAdIZQuAONsic46aZ8YoXFmmPphGozAMzJ2Z8SWfF0ppeZhJ45kXUDDjo2Wp9RCJy
         7AKj5huAm+9FRTIlSk8vPojpqyrzOGAVoBhQW6aFY7C3ikTWR6r2tlRiB9zDRGhEyjYB
         SMJ6qemusXZMgFMhohoqiq3rSc0KCDns6ikFBU28fSgvNDJu4VTK88LgW5oeneK3scUV
         pFDA==
X-Gm-Message-State: ANhLgQ3zUO/2Qs9YI6mDW7sy87qBSLUhTpueapyiLzUE/MWQUU+VepsN
        igsjNKAExNCeFd04OpRSO5oFkBPomsI=
X-Google-Smtp-Source: ADFU+vssapIwkWJq3chMgyunv9X86ccnIPn96+jOyEBVJu2wUJrR2qp1LAyEDqvrg/FNtqFp6bWIXw==
X-Received: by 2002:a17:902:6b07:: with SMTP id o7mr2310874plk.141.1583208962188;
        Mon, 02 Mar 2020 20:16:02 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id t7sm396682pjy.1.2020.03.02.20.16.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Mar 2020 20:16:01 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 2/8] ionic: remove pragma packed
Date:   Mon,  2 Mar 2020 20:15:39 -0800
Message-Id: <20200303041545.1611-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200303041545.1611-1-snelson@pensando.io>
References: <20200303041545.1611-1-snelson@pensando.io>
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
index ce07c2931a72..74697c25cd40 100644
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
+	} __attribute__((packed));
 	__le32 words[64];
 };
 
@@ -417,7 +415,7 @@ union ionic_lif_identity {
 			__le32 max_frame_size;
 			u8 rsvd2[106];
 			union ionic_lif_config config;
-		} eth;
+		} __attribute__((packed)) eth;
 
 		struct {
 			u8 version;
@@ -439,8 +437,8 @@ union ionic_lif_identity {
 			struct ionic_lif_logical_qtype rq_qtype;
 			struct ionic_lif_logical_qtype cq_qtype;
 			struct ionic_lif_logical_qtype eq_qtype;
-		} rdma;
-	};
+		} __attribute((packed)) rdma;
+	} __attribute((packed));
 	__le32 words[512];
 };
 
@@ -526,7 +524,7 @@ struct ionic_q_init_cmd {
 	__le64 sg_ring_base;
 	__le32 eq_index;
 	u8     rsvd2[16];
-};
+} __attribute__((packed));
 
 /**
  * struct ionic_q_init_comp - Queue init command completion
@@ -1095,7 +1093,7 @@ struct ionic_port_status {
 	u8     status;
 	u8     rsvd[51];
 	struct ionic_xcvr_status  xcvr;
-};
+} __attribute((packed));
 
 /**
  * struct ionic_port_identify_cmd - Port identify command
@@ -1251,7 +1249,7 @@ struct ionic_port_getattr_comp {
 		u8      pause_type;
 		u8      loopback_mode;
 		u8      rsvd2[11];
-	};
+	} __attribute__((packed));
 	u8     color;
 };
 
@@ -1319,7 +1317,7 @@ struct ionic_dev_setattr_cmd {
 		char    name[IONIC_IFNAMSIZ];
 		__le64  features;
 		u8      rsvd2[60];
-	};
+	} __attribute__((packed));
 };
 
 /**
@@ -1334,7 +1332,7 @@ struct ionic_dev_setattr_comp {
 	union {
 		__le64  features;
 		u8      rsvd2[11];
-	};
+	} __attribute__((packed));
 	u8     color;
 };
 
@@ -1361,7 +1359,7 @@ struct ionic_dev_getattr_comp {
 	union {
 		__le64  features;
 		u8      rsvd2[11];
-	};
+	} __attribute__((packed));
 	u8     color;
 };
 
@@ -1426,7 +1424,7 @@ struct ionic_lif_setattr_cmd {
 		} rss;
 		u8	stats_ctl;
 		u8      rsvd[60];
-	};
+	} __attribute__((packed));
 };
 
 /**
@@ -1444,7 +1442,7 @@ struct ionic_lif_setattr_comp {
 	union {
 		__le64  features;
 		u8      rsvd2[11];
-	};
+	} __attribute__((packed));
 	u8     color;
 };
 
@@ -1483,7 +1481,7 @@ struct ionic_lif_getattr_comp {
 		u8      mac[6];
 		__le64  features;
 		u8      rsvd2[11];
-	};
+	} __attribute__((packed));
 	u8     color;
 };
 
@@ -1688,7 +1686,7 @@ struct ionic_vf_setattr_cmd {
 		u8     linkstate;
 		__le64 stats_pa;
 		u8     pad[60];
-	};
+	} __attribute__((packed));
 };
 
 struct ionic_vf_setattr_comp {
@@ -1726,7 +1724,7 @@ struct ionic_vf_getattr_comp {
 		u8     linkstate;
 		__le64 stats_pa;
 		u8     pad[11];
-	};
+	} __attribute__((packed));
 	u8     color;
 };
 
@@ -2471,7 +2469,7 @@ union ionic_dev_cmd_regs {
 		union ionic_dev_cmd_comp    comp;
 		u8                    rsvd[48];
 		u32                   data[478];
-	};
+	} __attribute__((packed));
 	u32 words[512];
 };
 
@@ -2484,7 +2482,7 @@ union ionic_dev_regs {
 	struct {
 		union ionic_dev_info_regs info;
 		union ionic_dev_cmd_regs  devcmd;
-	};
+	} __attribute__((packed));
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

