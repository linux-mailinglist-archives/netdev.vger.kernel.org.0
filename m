Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77812399EA3
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 12:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbhFCKQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 06:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbhFCKQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 06:16:53 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FAABC061756
        for <netdev@vger.kernel.org>; Thu,  3 Jun 2021 03:14:52 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id h12-20020a05600c350cb029019fae7a26cdso3333085wmq.5
        for <netdev@vger.kernel.org>; Thu, 03 Jun 2021 03:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ubique-spb-ru.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LVbCOGU7gtoqVWCuLiLGdbq6lukEGJhpYIytUkCDM00=;
        b=r8pd42ryT9w+DfoVsWZ0ArQGHS2hWGNmOko7/7k+zfcTtxW0dzrh0UpCFzSRrrmFmn
         5HJARz6vM+3uzPja/hIZowJ4r3jG7J6gD3Wf9i3DhIplB8KBzs6y1Tdo94vgW3yjdwyj
         Es95fcDq7uNyS04HWGy6S5LMbAhvhwdRYK55bdamAY06cTcmA4m0Z8FkkU6DsYvYB6bH
         lpU2aSxfRcQZdnh9doJqthcbhSZKYusKxWXTBZfDBey5vN2auVqdz5Du12vNcnlWtm2Q
         nPW+jjh//4vm+tCeh8CUIoX9Xsdd2+AtPRsC790A/Pt/6cMFzBHEKU+M3IGRv8PudCXs
         h8Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LVbCOGU7gtoqVWCuLiLGdbq6lukEGJhpYIytUkCDM00=;
        b=U1ntuMg6R3gy6tCwjW8Wn8yANWZhNyZSwfl833Ij6UMOIAnT/Ol1l37UTM+LcDFPTs
         zGLoUZC5WnPRtWT6mYCjhYQThzmMEb6gh7yUSs4MYYDFG9akFRPau9yQGmzAkw/WCetQ
         n6DK6Hw/gs6ee0J7Lkq/8kWSRbGZ4EKzE+ygWssf4mY1BKwGBQMb0ojjT55PfzsIkbPz
         hk4kZMfdL1lQLtQQkmRSWHACv4L6j/ooeE9qSWw9gquQkB9aimf0ern2FY9rSE7Rg8C0
         baRY7m139WYjoV59HHMoOVXmW2XsQlVv4/MbLQTEPA1pjwEGjzUy+z7KnyBcaFWZEKDx
         DxlQ==
X-Gm-Message-State: AOAM530Dvrm5nQcP9+bzIM49XubjaUEtqdAaXDLP1/u25Gq/rTlo60wR
        rNymNQX4VNZGH9+edaxL5HPpzmAFjRD2Iq0m52k=
X-Google-Smtp-Source: ABdhPJz3CSTrnqRsBuP5C7U2Dx5eOQ4a6aUyE/fJ0cr3a3hT4axC42iwz8SOuRjUX0poKi3G1aHuGA==
X-Received: by 2002:a1c:65c2:: with SMTP id z185mr9568342wmb.2.1622715290891;
        Thu, 03 Jun 2021 03:14:50 -0700 (PDT)
Received: from localhost ([154.21.15.43])
        by smtp.gmail.com with ESMTPSA id l10sm1028528wrs.11.2021.06.03.03.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 03:14:50 -0700 (PDT)
From:   Dmitrii Banshchikov <me@ubique.spb.ru>
To:     bpf@vger.kernel.org
Cc:     Dmitrii Banshchikov <me@ubique.spb.ru>, ast@kernel.org,
        davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, rdna@fb.com
Subject: [PATCH bpf-next v1 03/10] tools: Add bpfilter usermode helper header
Date:   Thu,  3 Jun 2021 14:14:18 +0400
Message-Id: <20210603101425.560384-4-me@ubique.spb.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210603101425.560384-1-me@ubique.spb.ru>
References: <20210603101425.560384-1-me@ubique.spb.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The header will be used in bpfilter usermode helper test infrastructure.

Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
---
 tools/include/uapi/linux/bpfilter.h | 179 ++++++++++++++++++++++++++++
 1 file changed, 179 insertions(+)
 create mode 100644 tools/include/uapi/linux/bpfilter.h

diff --git a/tools/include/uapi/linux/bpfilter.h b/tools/include/uapi/linux/bpfilter.h
new file mode 100644
index 000000000000..8b49d81f81c8
--- /dev/null
+++ b/tools/include/uapi/linux/bpfilter.h
@@ -0,0 +1,179 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI_LINUX_BPFILTER_H
+#define _UAPI_LINUX_BPFILTER_H
+
+#include <linux/if.h>
+#include <linux/const.h>
+
+#define BPFILTER_FUNCTION_MAXNAMELEN    30
+#define BPFILTER_EXTENSION_MAXNAMELEN   29
+
+#define BPFILTER_STANDARD_TARGET        ""
+#define BPFILTER_ERROR_TARGET           "ERROR"
+
+
+#define BPFILTER_ALIGN(__X) __ALIGN_KERNEL(__X, __alignof__(__u64))
+
+enum {
+	BPFILTER_IPT_SO_SET_REPLACE = 64,
+	BPFILTER_IPT_SO_SET_ADD_COUNTERS = 65,
+	BPFILTER_IPT_SET_MAX,
+};
+
+enum {
+	BPFILTER_IPT_SO_GET_INFO = 64,
+	BPFILTER_IPT_SO_GET_ENTRIES = 65,
+	BPFILTER_IPT_SO_GET_REVISION_MATCH = 66,
+	BPFILTER_IPT_SO_GET_REVISION_TARGET = 67,
+	BPFILTER_IPT_GET_MAX,
+};
+
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
+#endif /* _UAPI_LINUX_BPFILTER_H */
-- 
2.25.1

