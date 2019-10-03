Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52F73CAE0B
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 20:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388340AbfJCSTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 14:19:41 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:44244 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729906AbfJCSTk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 14:19:40 -0400
Received: by mail-qk1-f194.google.com with SMTP id u22so3300283qkk.11
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 11:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h0vkSi8FKdKEx+ZhBbrjV/lm760w4pXTyW6JeJp2RXU=;
        b=hLXlcZgrrgL7S5SWLM5SqS+mbD9ErXIF4SZWGd6d43yMERKx/4aMzeRUZfoatuZTeV
         lk/y2Jh6CEEfuCIa7xk59f8Ijj2L4Un8ABMPgst5+R9xuWYsP9ANNZSwSoi/G+OwzhgA
         XKgMwVbei9qzw2AkAcgdSaAm6ZfTh1BN+Ko27NgCnhiAnPY9+5GtfXFP8PCtZpVwU9Pl
         dEPLqZtAPX1hpFB7Ni7TP1Pt4rQdZMkvKu6N1P0zIGM2aUrRxG/DRxnOF6vS4xz4mSsZ
         4ZLyYAp9SgoqLPJb2dp5h9aiE/d/KRA5G/OKWnJm0ZivcFmTy1lyn/nol4Gzwdz5jNNf
         LCsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h0vkSi8FKdKEx+ZhBbrjV/lm760w4pXTyW6JeJp2RXU=;
        b=Ltv/bbHBlmljO9+VnIJWqigy4WodoVPx+8cKjCJNFFVnRbAOdh8L1fWpaBugXFSEFV
         GaS4tsQ9VswFBA93m2vT76t4Be865QiDV0uTtrONbWbAFq2dNst1OFkkwQ1WH6Jtf1Oj
         VdDv/1qYwY7uM9jsKjmV+kQDRuUJOQcvU7w5quu1RTplSn6hyTUcxNHEIqGaxv/Vzl9l
         z+KWZte5hQU2bo3yjemRhB8j56isM9iUgWa+fY/YGOx+ZwUIlC5Dd8niTOIvDm6YBsL7
         tg0PSWztGn2qMumizoaBFl3umkXZAdYcJBDjawwj22zVTa4A2IkSYrQxn8VN/YmkY7iK
         sX1A==
X-Gm-Message-State: APjAAAURIrVCXgATPm3MbolI19u/yQ0rKt1pJ25oDtPHHgFf+ZgViKLM
        Ig20XPsKlXB3BtsuobtPDLFq1dNEON0=
X-Google-Smtp-Source: APXvYqx0hkAWHSSiVoPAd7WrLz/jJpPfv1/up7/G37JPABg30MPEQk4svKTy2X6zF/pTwWKYCTkwIw==
X-Received: by 2002:a37:5c06:: with SMTP id q6mr5797499qkb.236.1570126779377;
        Thu, 03 Oct 2019 11:19:39 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m91sm1592984qte.8.2019.10.03.11.19.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Oct 2019 11:19:38 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        davejwatson@fb.com, borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        atul.gupta@chelsio.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net-next 1/6] net/tls: move TOE-related structures to a separate header
Date:   Thu,  3 Oct 2019 11:18:54 -0700
Message-Id: <20191003181859.24958-2-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191003181859.24958-1-jakub.kicinski@netronome.com>
References: <20191003181859.24958-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move tls_device structure and register/unregister functions
to a new header to avoid confusion with normal, non-TOE offload.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
---
 drivers/crypto/chelsio/chtls/chtls.h |  1 +
 include/net/tls.h                    | 34 -------------
 include/net/tls_toe.h                | 73 ++++++++++++++++++++++++++++
 net/tls/tls_main.c                   |  1 +
 4 files changed, 75 insertions(+), 34 deletions(-)
 create mode 100644 include/net/tls_toe.h

diff --git a/drivers/crypto/chelsio/chtls/chtls.h b/drivers/crypto/chelsio/chtls/chtls.h
index 025c831d0899..e353c42fea91 100644
--- a/drivers/crypto/chelsio/chtls/chtls.h
+++ b/drivers/crypto/chelsio/chtls/chtls.h
@@ -21,6 +21,7 @@
 #include <crypto/internal/hash.h>
 #include <linux/tls.h>
 #include <net/tls.h>
+#include <net/tls_toe.h>
 
 #include "t4fw_api.h"
 #include "t4_msg.h"
diff --git a/include/net/tls.h b/include/net/tls.h
index c664e6dba0d1..57865c944095 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -60,7 +60,6 @@
 #define TLS_RECORD_TYPE_DATA		0x17
 
 #define TLS_AAD_SPACE_SIZE		13
-#define TLS_DEVICE_NAME_MAX		32
 
 #define MAX_IV_SIZE			16
 #define TLS_MAX_REC_SEQ_SIZE		8
@@ -74,37 +73,6 @@
  */
 #define TLS_AES_CCM_IV_B0_BYTE		2
 
-/*
- * This structure defines the routines for Inline TLS driver.
- * The following routines are optional and filled with a
- * null pointer if not defined.
- *
- * @name: Its the name of registered Inline tls device
- * @dev_list: Inline tls device list
- * int (*feature)(struct tls_device *device);
- *     Called to return Inline TLS driver capability
- *
- * int (*hash)(struct tls_device *device, struct sock *sk);
- *     This function sets Inline driver for listen and program
- *     device specific functioanlity as required
- *
- * void (*unhash)(struct tls_device *device, struct sock *sk);
- *     This function cleans listen state set by Inline TLS driver
- *
- * void (*release)(struct kref *kref);
- *     Release the registered device and allocated resources
- * @kref: Number of reference to tls_device
- */
-struct tls_device {
-	char name[TLS_DEVICE_NAME_MAX];
-	struct list_head dev_list;
-	int  (*feature)(struct tls_device *device);
-	int  (*hash)(struct tls_device *device, struct sock *sk);
-	void (*unhash)(struct tls_device *device, struct sock *sk);
-	void (*release)(struct kref *kref);
-	struct kref kref;
-};
-
 enum {
 	TLS_BASE,
 	TLS_SW,
@@ -643,8 +611,6 @@ static inline bool tls_offload_tx_resync_pending(struct sock *sk)
 
 int tls_proccess_cmsg(struct sock *sk, struct msghdr *msg,
 		      unsigned char *record_type);
-void tls_register_device(struct tls_device *device);
-void tls_unregister_device(struct tls_device *device);
 int decrypt_skb(struct sock *sk, struct sk_buff *skb,
 		struct scatterlist *sgout);
 struct sk_buff *tls_encrypt_skb(struct sk_buff *skb);
diff --git a/include/net/tls_toe.h b/include/net/tls_toe.h
new file mode 100644
index 000000000000..81b66c76b31f
--- /dev/null
+++ b/include/net/tls_toe.h
@@ -0,0 +1,73 @@
+/*
+ * Copyright (c) 2016-2017, Mellanox Technologies. All rights reserved.
+ * Copyright (c) 2016-2017, Dave Watson <davejwatson@fb.com>. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <linux/kref.h>
+#include <linux/list.h>
+
+struct sock;
+
+#define TLS_DEVICE_NAME_MAX		32
+
+/*
+ * This structure defines the routines for Inline TLS driver.
+ * The following routines are optional and filled with a
+ * null pointer if not defined.
+ *
+ * @name: Its the name of registered Inline tls device
+ * @dev_list: Inline tls device list
+ * int (*feature)(struct tls_device *device);
+ *     Called to return Inline TLS driver capability
+ *
+ * int (*hash)(struct tls_device *device, struct sock *sk);
+ *     This function sets Inline driver for listen and program
+ *     device specific functioanlity as required
+ *
+ * void (*unhash)(struct tls_device *device, struct sock *sk);
+ *     This function cleans listen state set by Inline TLS driver
+ *
+ * void (*release)(struct kref *kref);
+ *     Release the registered device and allocated resources
+ * @kref: Number of reference to tls_device
+ */
+struct tls_device {
+	char name[TLS_DEVICE_NAME_MAX];
+	struct list_head dev_list;
+	int  (*feature)(struct tls_device *device);
+	int  (*hash)(struct tls_device *device, struct sock *sk);
+	void (*unhash)(struct tls_device *device, struct sock *sk);
+	void (*release)(struct kref *kref);
+	struct kref kref;
+};
+
+void tls_register_device(struct tls_device *device);
+void tls_unregister_device(struct tls_device *device);
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index ac88877dcade..a19c6a1e034a 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -42,6 +42,7 @@
 #include <linux/inet_diag.h>
 
 #include <net/tls.h>
+#include <net/tls_toe.h>
 
 MODULE_AUTHOR("Mellanox Technologies");
 MODULE_DESCRIPTION("Transport Layer Security Support");
-- 
2.21.0

