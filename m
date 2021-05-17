Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1CC386D42
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 00:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344199AbhEQWyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 18:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242469AbhEQWyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 18:54:43 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3886FC061573
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 15:53:25 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id n2so8129562wrm.0
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 15:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ubique-spb-ru.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5+z9yQBwGKLQ3pjRj4QMkBOoGjzosPzwejTgCIv89Lg=;
        b=gjq6aHKgbQKZe0q7MmvwG552V4savz9MIu1dlKXExlDljHEZORV3V4QX9LO54J5LTv
         oSkxgR6gTM+IpBW2gAz0sJIrBCnfAFfxSf6XWp4INx21bLmcPGZKolTiUJ+thB9wsUQQ
         LK4v6IEyQ4NytSvS/Wkvdc0NB9rRyNoZaV22lGA6wd65ercbjW9xaQBgWEhngw6U5lB4
         mVyxm7xgdetVj2Wd43ccy4SQx+Rukx3aQN946mMVfUfK2AQZmMdfbiVKlZsaIWzlbaXz
         R7+2o2lCdhMVeBrpe/prUXmz/+fQgiBgtWogQ2bPWMEXL8VQvAfhWIj7vofoYpBzZE2a
         nULQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5+z9yQBwGKLQ3pjRj4QMkBOoGjzosPzwejTgCIv89Lg=;
        b=tQaPEsXUSi9MptYb3ZBOvATVPwtDYUEAH7noVhAkBJY/fVsWDEP3B/YbkAuQwl0ywN
         KrStqXyeHGHbKyAdXGljqT3SKn3MSOpEQsG97aRzgs7KUxeZBnUXEFz9VhR72PSmm8GC
         0S5iLllBIFtF8AM0dqyYPbHek6cMYAC7luRBWgl3YrWR2KQyEckBnpEQRG35diB17Kho
         pfnISqyOKneAnHukjd5dXMcwilor7oewvn1JAxDWkTZWXK8wMn6m0pTGWFca1X8+kvVy
         vFn9SoLilY1KC+HGemiWRx2Wt48MSmDWj0T2tCWO9mCc21OVnJ0c65ydKM4BN+FCDnr2
         YyTg==
X-Gm-Message-State: AOAM5337tQ+oDk4ZV44M6UXRJ3ryRwyGRo0M3RQBY0WkR/KpYxsrUhGt
        U4l2J/gz4mHgkIQNTcJnJwQi2A==
X-Google-Smtp-Source: ABdhPJxI8DKO8VaST4Eg//djHKSxxf1H3FzFygWWzTkZBZXBIDoHZQ6bjxxQ8RETtUCkVocSmzMKQg==
X-Received: by 2002:a5d:4ccc:: with SMTP id c12mr2489333wrt.137.1621292003993;
        Mon, 17 May 2021 15:53:23 -0700 (PDT)
Received: from localhost ([154.21.15.43])
        by smtp.gmail.com with ESMTPSA id q10sm16151668wmc.31.2021.05.17.15.53.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 15:53:23 -0700 (PDT)
From:   Dmitrii Banshchikov <me@ubique.spb.ru>
To:     bpf@vger.kernel.org
Cc:     Dmitrii Banshchikov <me@ubique.spb.ru>, ast@kernel.org,
        davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, rdna@fb.com
Subject: [PATCH bpf-next 01/11] bpfilter: Add types for usermode helper
Date:   Tue, 18 May 2021 02:52:58 +0400
Message-Id: <20210517225308.720677-2-me@ubique.spb.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210517225308.720677-1-me@ubique.spb.ru>
References: <20210517225308.720677-1-me@ubique.spb.ru>
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

