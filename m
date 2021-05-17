Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A266386D48
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 00:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344236AbhEQWy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 18:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344205AbhEQWyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 18:54:54 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8150C061573
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 15:53:35 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id z17so8036490wrq.7
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 15:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ubique-spb-ru.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LVbCOGU7gtoqVWCuLiLGdbq6lukEGJhpYIytUkCDM00=;
        b=tv2rM1qLY1x/o/m/UhrKnsyStOn/uF9TW6YAuQmBZjgkBIOyIwFUvSpmsPQxfP1fl1
         PeCfGs0TrwPD/XDiby1EluzziQFOnLL4TgvzwlGbY+7NZP8TwFv/NGzjWV4hbxbLftEz
         G/eU23Fiau6QMsIF0TK79oLi6lY+hxGrrnEX/e4a6+5E5vIpp+RugyJF2puQo/Efvfvd
         APfDR/LfIREHCGykHJbJ8nhCvagJltoOKXy7Jfs1UfjPux9EY1YueVRjKn+hJ7DjNp2o
         IBtjHbh1zmevtkZNBfe8o2NQDhtsDYdZt9VDRBSXy5assYXGfHNe9wbXmd7OMdnRG7C4
         2pBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LVbCOGU7gtoqVWCuLiLGdbq6lukEGJhpYIytUkCDM00=;
        b=YQtuso4p+0yXiODfnBN1Xm4fTgcpFDpwEsYpi/3SwXyb1gWWJoVvQYrcvM7EOZIPSV
         LkqV9tPI1mBAD0RHrL2eMmLlJaIdk5QUC3YeOOgUYKmZmkk4A3KlFCYsU0D41o9aVz1M
         KRXxNpCYZg6GytKoDx4O7aoaONR63K/H+tcD12zy2V2+gZQrx2yP+gGaUJ/6j+Og4fn0
         qf7UqYBotkI+CBl4ZeQQtgXtxtY/ZNGZ6g8IaL/mMyGhuw3Q/OMGNQHnLCMC9SKD4EUN
         BpjitV35DdHAkE2zoz6BEWF4dDl0+LIUf4t8HT0YcUSgobuxOThj9nJqhSyNVT110+rz
         js7g==
X-Gm-Message-State: AOAM531753Bi5AxMTMbIZnsAaVtwsndmJ7+VDA9jI0qQFqeUKdCyce+n
        RXCwcCZa+QAfBuKLmplBVsCUvA==
X-Google-Smtp-Source: ABdhPJwBM3s88GCibwiJkUteHvKrfv4RM/nq187z16QzLLiZVuzNGHTCfdm2YZVdhA45AxWU9VJ8JQ==
X-Received: by 2002:a5d:4304:: with SMTP id h4mr2572700wrq.210.1621292014616;
        Mon, 17 May 2021 15:53:34 -0700 (PDT)
Received: from localhost ([154.21.15.43])
        by smtp.gmail.com with ESMTPSA id r1sm3347250wrt.67.2021.05.17.15.53.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 15:53:34 -0700 (PDT)
From:   Dmitrii Banshchikov <me@ubique.spb.ru>
To:     bpf@vger.kernel.org
Cc:     Dmitrii Banshchikov <me@ubique.spb.ru>, ast@kernel.org,
        davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, rdna@fb.com
Subject: [PATCH bpf-next 04/11] tools: Add bpfilter usermode helper header
Date:   Tue, 18 May 2021 02:53:01 +0400
Message-Id: <20210517225308.720677-5-me@ubique.spb.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210517225308.720677-1-me@ubique.spb.ru>
References: <20210517225308.720677-1-me@ubique.spb.ru>
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

