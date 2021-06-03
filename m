Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D725C399EAA
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 12:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhFCKR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 06:17:29 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:41533 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhFCKR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 06:17:29 -0400
Received: by mail-wr1-f52.google.com with SMTP id h8so5228094wrz.8
        for <netdev@vger.kernel.org>; Thu, 03 Jun 2021 03:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ubique-spb-ru.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5+z9yQBwGKLQ3pjRj4QMkBOoGjzosPzwejTgCIv89Lg=;
        b=fEyaH/xoapt+Nbgw1o+/0sbcrWyyWSxcAFw24xpOSpGT7Gxnhs4HqCKDVOZNpcpmZ5
         3JOb/f58y/OTJ/iv+2Sy+LGI/J2yGLFZrnDOGELFiH/RdnnqhGSJ2mrxVQ3iAR1Dfuhm
         YcqRfBNGBnV8RPZCvujxSr6XkYSl9q61xpMJ6WHho3gi0mtnf9s0c6zbc74UUl83KhA6
         Ve1GjiGkq4YGYNC/Y2Q+6iRzKoE/89Ml6CEQMK7WfvFukKwzVhSPYp78zktI08CRdGc9
         w5lEb9jdpmE2fj5bnuJimofgPNvlgfV3zH2i3nCO+rju/pV5yU2SKHS85FzIT+yn+rok
         A7jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5+z9yQBwGKLQ3pjRj4QMkBOoGjzosPzwejTgCIv89Lg=;
        b=S/3kqpXo/G5D3sn46NLg5gW9WD1zvC/prR4nEnlFLpfQJUECbpbTsLaSwpP2kvXcEp
         BpC2fmLVB+rHx66VZvPEWjEK+KsAjDjBYzXo5zq9ctIwlved070EsZlHc0HOhyTl2Z98
         O4lV+V+IlZ3Ki2IakmQGiKoizVTW08udZs6VeigKku66Q0GKs/zYTm6L54E1Y1ft6qTy
         kVycQVpEjo0YKihKSTg6T6PYdTySGGy8YK4SV2h5bSuqzquxEYVtyRFqjvzi4+GMlbi3
         xMJylnyfbSw4gPfbf92oxFrnB0mpAo+BvEdB31VcZ4fY3q4cuBWmZsVST9zKufN0wHkq
         RVMw==
X-Gm-Message-State: AOAM533SecYmFr2xuMTHcJ4TJgpkiEl4DO5MW64Z9IOdcx04E6SjOy4d
        rksgNI1tvSSwqkit3Qc9nPcRHg==
X-Google-Smtp-Source: ABdhPJw2Y8e3+pA1up1bQe4dRrPGqAR9RUUPTI55nH03DR5PgEOXFApWqPdvSTcAWCFcgGeZggRfdw==
X-Received: by 2002:a05:6000:12cc:: with SMTP id l12mr37189092wrx.91.1622715284081;
        Thu, 03 Jun 2021 03:14:44 -0700 (PDT)
Received: from localhost ([154.21.15.43])
        by smtp.gmail.com with ESMTPSA id p10sm2761055wrr.58.2021.06.03.03.14.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 03:14:43 -0700 (PDT)
From:   Dmitrii Banshchikov <me@ubique.spb.ru>
To:     bpf@vger.kernel.org
Cc:     Dmitrii Banshchikov <me@ubique.spb.ru>, ast@kernel.org,
        davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, rdna@fb.com
Subject: [PATCH bpf-next v1 01/10] bpfilter: Add types for usermode helper
Date:   Thu,  3 Jun 2021 14:14:16 +0400
Message-Id: <20210603101425.560384-2-me@ubique.spb.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210603101425.560384-1-me@ubique.spb.ru>
References: <20210603101425.560384-1-me@ubique.spb.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add more definitions that mirror existing iptables' ABI.
These definitions will be used in bpfilter usermode helper.

Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
---
 include/uapi/linux/bpfilter.h | 155 ++++++++++++++++++++++++++++++++++
 1 file changed, 155 insertions(+)

diff --git a/include/uapi/linux/bpfilter.h b/include/uapi/linux/bpfilter.h
index cbc1f5813f50..e97d95d0ba54 100644
--- a/include/uapi/linux/bpfilter.h
+++ b/include/uapi/linux/bpfilter.h
@@ -3,6 +3,13 @@
 #define _UAPI_LINUX_BPFILTER_H
 
 #include <linux/if.h>
+#include <linux/const.h>
+
+#define BPFILTER_FUNCTION_MAXNAMELEN    30
+#define BPFILTER_EXTENSION_MAXNAMELEN   29
+
+#define BPFILTER_STANDARD_TARGET        ""
+#define BPFILTER_ERROR_TARGET           "ERROR"
 
 enum {
 	BPFILTER_IPT_SO_SET_REPLACE = 64,
@@ -18,4 +25,152 @@ enum {
 	BPFILTER_IPT_GET_MAX,
 };
 
+enum {
+	BPFILTER_XT_TABLE_MAXNAMELEN = 32,
+};
+
+enum {
+	BPFILTER_NF_DROP = 0,
+	BPFILTER_NF_ACCEPT = 1,
+	BPFILTER_NF_STOLEN = 2,
+	BPFILTER_NF_QUEUE = 3,
+	BPFILTER_NF_REPEAT = 4,
+	BPFILTER_NF_STOP = 5,
+	BPFILTER_NF_MAX_VERDICT = BPFILTER_NF_STOP,
+	BPFILTER_RETURN = (-BPFILTER_NF_REPEAT - 1),
+};
+
+enum {
+	BPFILTER_INET_HOOK_PRE_ROUTING = 0,
+	BPFILTER_INET_HOOK_LOCAL_IN = 1,
+	BPFILTER_INET_HOOK_FORWARD = 2,
+	BPFILTER_INET_HOOK_LOCAL_OUT = 3,
+	BPFILTER_INET_HOOK_POST_ROUTING = 4,
+	BPFILTER_INET_HOOK_MAX,
+};
+
+enum {
+	BPFILTER_IPT_F_MASK = 0x03,
+	BPFILTER_IPT_INV_MASK = 0x7f
+};
+
+struct bpfilter_ipt_match {
+	union {
+		struct {
+			__u16 match_size;
+			char name[BPFILTER_EXTENSION_MAXNAMELEN];
+			__u8 revision;
+		} user;
+		struct {
+			__u16 match_size;
+			void *match;
+		} kernel;
+		__u16 match_size;
+	} u;
+	unsigned char data[0];
+};
+
+struct bpfilter_ipt_target {
+	union {
+		struct {
+			__u16 target_size;
+			char name[BPFILTER_EXTENSION_MAXNAMELEN];
+			__u8 revision;
+		} user;
+		struct {
+			__u16 target_size;
+			void *target;
+		} kernel;
+		__u16 target_size;
+	} u;
+	unsigned char data[0];
+};
+
+struct bpfilter_ipt_standard_target {
+	struct bpfilter_ipt_target target;
+	int verdict;
+};
+
+struct bpfilter_ipt_error_target {
+	struct bpfilter_ipt_target target;
+	char error_name[BPFILTER_FUNCTION_MAXNAMELEN];
+};
+
+struct bpfilter_ipt_get_info {
+	char name[BPFILTER_XT_TABLE_MAXNAMELEN];
+	__u32 valid_hooks;
+	__u32 hook_entry[BPFILTER_INET_HOOK_MAX];
+	__u32 underflow[BPFILTER_INET_HOOK_MAX];
+	__u32 num_entries;
+	__u32 size;
+};
+
+struct bpfilter_ipt_counters {
+	__u64 packet_cnt;
+	__u64 byte_cnt;
+};
+
+struct bpfilter_ipt_counters_info {
+	char name[BPFILTER_XT_TABLE_MAXNAMELEN];
+	__u32 num_counters;
+	struct bpfilter_ipt_counters counters[0];
+};
+
+struct bpfilter_ipt_get_revision {
+	char name[BPFILTER_EXTENSION_MAXNAMELEN];
+	__u8 revision;
+};
+
+struct bpfilter_ipt_ip {
+	__u32 src;
+	__u32 dst;
+	__u32 src_mask;
+	__u32 dst_mask;
+	char in_iface[IFNAMSIZ];
+	char out_iface[IFNAMSIZ];
+	__u8 in_iface_mask[IFNAMSIZ];
+	__u8 out_iface_mask[IFNAMSIZ];
+	__u16 protocol;
+	__u8 flags;
+	__u8 invflags;
+};
+
+struct bpfilter_ipt_entry {
+	struct bpfilter_ipt_ip ip;
+	__u32 bfcache;
+	__u16 target_offset;
+	__u16 next_offset;
+	__u32 comefrom;
+	struct bpfilter_ipt_counters counters;
+	__u8 elems[0];
+};
+
+struct bpfilter_ipt_standard_entry {
+	struct bpfilter_ipt_entry entry;
+	struct bpfilter_ipt_standard_target target;
+};
+
+struct bpfilter_ipt_error_entry {
+	struct bpfilter_ipt_entry entry;
+	struct bpfilter_ipt_error_target target;
+};
+
+struct bpfilter_ipt_get_entries {
+	char name[BPFILTER_XT_TABLE_MAXNAMELEN];
+	__u32 size;
+	struct bpfilter_ipt_entry entries[0];
+};
+
+struct bpfilter_ipt_replace {
+	char name[BPFILTER_XT_TABLE_MAXNAMELEN];
+	__u32 valid_hooks;
+	__u32 num_entries;
+	__u32 size;
+	__u32 hook_entry[BPFILTER_INET_HOOK_MAX];
+	__u32 underflow[BPFILTER_INET_HOOK_MAX];
+	__u32 num_counters;
+	struct bpfilter_ipt_counters *cntrs;
+	struct bpfilter_ipt_entry entries[0];
+};
+
 #endif /* _UAPI_LINUX_BPFILTER_H */
-- 
2.25.1

