Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9CB03FADCC
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 20:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235874AbhH2Sh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 14:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233379AbhH2ShU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 14:37:20 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D22C06175F
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 11:36:28 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id r21so9911279qtw.11
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 11:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ubique-spb-ru.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JbWKXTLJequ219BGEbUG/AHdIy4kKULzRRS7YJvdafI=;
        b=Vj55g6BfGD1dbKS21hoVvax++eLV0t1higAS3mMr3h2TmcREHKcnmq5Iwt9FdDdBiY
         sFAemUSGTahJT0q9Ei61b3kBTNDGH+SPtO6ir13vU9CJeiLSMtXIqYFgS32sHYaLqXnG
         M0b7Kb1xQmZrHYneHbHMMnwgaJZkcdJY8IgroZEDHblELZA8W+5ekTOBhW2xAi7PEArT
         jNqFT/1EL7RjKSrieVzw7Hv6GbZBzt1eirOBwo7lAjLZ8wCYwlZwtpPeZ95wMxWfYqvK
         xwsDdKR94uIIXcc/nZUGSDrakFhNbRR5CExSfwqB/b9KqKP24/tCesH3apn4NJ+VAguk
         G84w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JbWKXTLJequ219BGEbUG/AHdIy4kKULzRRS7YJvdafI=;
        b=Abc0nQCxUHJUg6bh2oP6/j+B9uHK2n+FI8QeGePu/FwUzV87YBpjShSH2dG1b2WcQ1
         DmRjtR83kbM6K/kzpqvhjIkaBubAE2pTwufWbLJ1BDF9IW+c0KEAiKVElWDIW9yBQEaR
         ISGSQRl74eUpfxCXc+vnAbd0RcaA/1v+iszEOK4xxddysUl+FXEE6+KP2XVJB3DQZO4Y
         Hpb8yFKB9cE3Ch7HvWqi4UQoGQ9wYVwcvM3mPtGQD8dcn/EBgH7Qv+YRP96AemS10ikp
         RiEZAJs5Q6cfzs9TRFFuDOrfqLAJxRWCrXbzPYqS/hjn6w+GVyKqSrJBwA9sJDAyAvDw
         yUbg==
X-Gm-Message-State: AOAM5328qgxo4WdvOlLErDcyulikVxpCa5rtZMrovVSo6pPdUQv2O0Nu
        wyitEs2FDGBR5RLyVsF6O0Fu1krOpsa+F75CZZ0=
X-Google-Smtp-Source: ABdhPJyq6yQ5lKOw00DPbhbNUkFheTC5HdGS9+DUg5Zth2pcttCgyjyUxKZ7GsOpn8fb+FTOPddoOw==
X-Received: by 2002:aed:3147:: with SMTP id 65mr17801912qtg.233.1630262187433;
        Sun, 29 Aug 2021 11:36:27 -0700 (PDT)
Received: from localhost ([154.21.15.43])
        by smtp.gmail.com with ESMTPSA id 90sm258372qte.89.2021.08.29.11.36.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Aug 2021 11:36:27 -0700 (PDT)
From:   Dmitrii Banshchikov <me@ubique.spb.ru>
To:     bpf@vger.kernel.org
Cc:     Dmitrii Banshchikov <me@ubique.spb.ru>, ast@kernel.org,
        davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, rdna@fb.com
Subject: [PATCH bpf-next v2 01/13] bpfilter: Add types for usermode helper
Date:   Sun, 29 Aug 2021 22:35:56 +0400
Message-Id: <20210829183608.2297877-2-me@ubique.spb.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210829183608.2297877-1-me@ubique.spb.ru>
References: <20210829183608.2297877-1-me@ubique.spb.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add more definitions that mirror existing iptables' ABI.
These definitions will be used in bpfilter usermode helper.

Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
---
 include/uapi/linux/bpfilter.h | 154 ++++++++++++++++++++++++++++++++++
 1 file changed, 154 insertions(+)

diff --git a/include/uapi/linux/bpfilter.h b/include/uapi/linux/bpfilter.h
index cbc1f5813f50..7cd34b1702eb 100644
--- a/include/uapi/linux/bpfilter.h
+++ b/include/uapi/linux/bpfilter.h
@@ -3,6 +3,10 @@
 #define _UAPI_LINUX_BPFILTER_H
 
 #include <linux/if.h>
+#include <linux/const.h>
+
+#define BPFILTER_STANDARD_TARGET        ""
+#define BPFILTER_ERROR_TARGET           "ERROR"
 
 enum {
 	BPFILTER_IPT_SO_SET_REPLACE = 64,
@@ -18,4 +22,154 @@ enum {
 	BPFILTER_IPT_GET_MAX,
 };
 
+enum {
+	BPFILTER_XT_TABLE_MAXNAMELEN = 32,
+	BPFILTER_FUNCTION_MAXNAMELEN = 30,
+	BPFILTER_EXTENSION_MAXNAMELEN = 29,
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

