Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A114578770
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 18:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234013AbiGRQcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 12:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233635AbiGRQbs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 12:31:48 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067B722B1F
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 09:31:48 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id bf13so11042569pgb.11
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 09:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c8d2SPElLORRa5BWEaSZq3SmhaobgoESCITkZXTRKV4=;
        b=JynrChrWSA0QWNHm/kACINZbZ2XXpqrUuskQcme5GZwvnLBIGkBJdnRbmMfPNpj1OC
         4AChw9ULWxm+WJ3KRB6EfummCBYiTLS1oiMjMNi+DjbmnlRiMNsIfsCCGv22iPMVaWKB
         +Jtrp44NeTOMVVcK/dl4893UoyIWmFOYOym2/4s7tHsr1cg4VNyvmczJtbBW4SFQH+DQ
         i1tJKxkbDrm4Bbkt5fXQDazIAKFg7oHTePwZbW1yj42XAiTTZJqTnlq36aMdKleTqvdr
         RjMv7P0XkOrI7EOY4hJlj6Vo8J0S+kBAumQXG9MJRUGMcj4HoxGN17nWiRJsDyP8zS2Y
         gzNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c8d2SPElLORRa5BWEaSZq3SmhaobgoESCITkZXTRKV4=;
        b=IRufzdyHgxfjnJN0OIQz1KvHa7vUDCtGepgTH/h2tyIw34sgl5sTGFZkeifSynhMxR
         SZ0IivaESZi7SUO7PcYbsuj6ymSMgudwKrA78faWven5+DYUCK1pd/i8qH0MLf+5lBvk
         vtfr37F1pEfWDqDxLJ3WJfd08GcIvOGKtpvKLMr2puURpavi0vQ7r3aMm30q3rOP3BKI
         LFDlIIwSUc8Kd2gc4S43cCFbj6cm03o/z2D+3/IDF39ECMTixC3zzlA9lT245G3ep6qG
         Arj1zVHT2BENzLVd8HIyE8POITxKU/QweNMGTOjTpRb2gI1ZPKPdojioLNLt8Jozhmrf
         +wLQ==
X-Gm-Message-State: AJIora8r72JZwDG7e1PdTvcWN1PbW9NrnI8ZnQGoWN2+R5rMdovrTXER
        jObCA2+BbJvcEVyeOAVWHJdaURYwVWCEQw==
X-Google-Smtp-Source: AGRyM1vXoffoMOhLDrDihAzqoIWOKNM91KqPWgaVtDZCei1yLtafx/9pSahcxqyHHkj/4fiX1aVW9g==
X-Received: by 2002:a05:6a00:99f:b0:52a:dd61:a50f with SMTP id u31-20020a056a00099f00b0052add61a50fmr28760688pfg.9.1658161907462;
        Mon, 18 Jul 2022 09:31:47 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id t187-20020a625fc4000000b0052ab8a92496sm9117462pfb.168.2022.07.18.09.31.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 09:31:44 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     parav@nvidia.com
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2] uapi: add vdpa.h
Date:   Mon, 18 Jul 2022 09:31:13 -0700
Message-Id: <20220718163112.11023-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Iproute2 depends on kernel headers and all necessary kernel headers
should be in iproute tree. When vdpa was added the kernel header
file was not.

Fixes: c2ecc82b9d4c ("vdpa: Add vdpa tool")
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 include/uapi/linux/vdpa.h | 59 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)
 create mode 100644 include/uapi/linux/vdpa.h

diff --git a/include/uapi/linux/vdpa.h b/include/uapi/linux/vdpa.h
new file mode 100644
index 000000000000..94e4dad1d86c
--- /dev/null
+++ b/include/uapi/linux/vdpa.h
@@ -0,0 +1,59 @@
+/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
+/*
+ * vdpa device management interface
+ * Copyright (c) 2020 Mellanox Technologies Ltd. All rights reserved.
+ */
+
+#ifndef _LINUX_VDPA_H_
+#define _LINUX_VDPA_H_
+
+#define VDPA_GENL_NAME "vdpa"
+#define VDPA_GENL_VERSION 0x1
+
+enum vdpa_command {
+	VDPA_CMD_UNSPEC,
+	VDPA_CMD_MGMTDEV_NEW,
+	VDPA_CMD_MGMTDEV_GET,		/* can dump */
+	VDPA_CMD_DEV_NEW,
+	VDPA_CMD_DEV_DEL,
+	VDPA_CMD_DEV_GET,		/* can dump */
+	VDPA_CMD_DEV_CONFIG_GET,	/* can dump */
+	VDPA_CMD_DEV_VSTATS_GET,
+};
+
+enum vdpa_attr {
+	VDPA_ATTR_UNSPEC,
+
+	/* Pad attribute for 64b alignment */
+	VDPA_ATTR_PAD = VDPA_ATTR_UNSPEC,
+
+	/* bus name (optional) + dev name together make the parent device handle */
+	VDPA_ATTR_MGMTDEV_BUS_NAME,		/* string */
+	VDPA_ATTR_MGMTDEV_DEV_NAME,		/* string */
+	VDPA_ATTR_MGMTDEV_SUPPORTED_CLASSES,	/* u64 */
+
+	VDPA_ATTR_DEV_NAME,			/* string */
+	VDPA_ATTR_DEV_ID,			/* u32 */
+	VDPA_ATTR_DEV_VENDOR_ID,		/* u32 */
+	VDPA_ATTR_DEV_MAX_VQS,			/* u32 */
+	VDPA_ATTR_DEV_MAX_VQ_SIZE,		/* u16 */
+	VDPA_ATTR_DEV_MIN_VQ_SIZE,		/* u16 */
+
+	VDPA_ATTR_DEV_NET_CFG_MACADDR,		/* binary */
+	VDPA_ATTR_DEV_NET_STATUS,		/* u8 */
+	VDPA_ATTR_DEV_NET_CFG_MAX_VQP,		/* u16 */
+	VDPA_ATTR_DEV_NET_CFG_MTU,		/* u16 */
+
+	VDPA_ATTR_DEV_NEGOTIATED_FEATURES,	/* u64 */
+	VDPA_ATTR_DEV_MGMTDEV_MAX_VQS,		/* u32 */
+	VDPA_ATTR_DEV_SUPPORTED_FEATURES,	/* u64 */
+
+	VDPA_ATTR_DEV_QUEUE_INDEX,              /* u32 */
+	VDPA_ATTR_DEV_VENDOR_ATTR_NAME,		/* string */
+	VDPA_ATTR_DEV_VENDOR_ATTR_VALUE,        /* u64 */
+
+	/* new attributes must be added above here */
+	VDPA_ATTR_MAX,
+};
+
+#endif
-- 
2.35.1

