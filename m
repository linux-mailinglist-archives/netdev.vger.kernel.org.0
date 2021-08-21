Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C3B3F378A
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 02:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240242AbhHUAVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 20:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239503AbhHUAU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 20:20:59 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6879C06175F;
        Fri, 20 Aug 2021 17:20:20 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id d17so6855322plr.12;
        Fri, 20 Aug 2021 17:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zRBh7n5s/L5dMFTMg00BFzyMyGdARy9x6UMz5YDSOzA=;
        b=coIcv6rM/26HUqxZRrbvgbv6UMGxfYYHXIAuwKIZZgeLl2G1GoGMvkCVg9FKZmw4un
         LkQXxWLq8KwuWxPj/dCFPWbJQuFFyQxcIFq2lf0eBvTihblGfK6vgQUDrGvSWpusJ5zS
         X5XVJ1wWC20f7wNqA+A43blLCymWQ+kyAsiHDtmEVKeQKt+hiR+7paW2TfGjDZYj1cNo
         rPoqAZ1qD60czznDUwVwj6LmqThd1f1k+z8ulVIGdbDc1l9lFRgGVvzz1joghCahUt1t
         zjM1kQ/7vnJzsmoFxhsyF+C41dlFbTeMLtJqhL6+TpTOHJhSr44Xm6w51QHRwsDHOBut
         LBug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zRBh7n5s/L5dMFTMg00BFzyMyGdARy9x6UMz5YDSOzA=;
        b=qg/oBvH4swDa+b/d+BK1yquXcaaSWuUziImph+lx5mjdYlyS+Eok8+aGYBlh9+9dMd
         hZK/OvcduzGui67GXVZZinTtwx9xG6eDELi8nQKRqldLUqqObQ1EDuUBsw5ZHyFgR5Z8
         89shO4gCHjrTjRxBbi6jUr9SrR8rcz9CyC1OnQ+WDREVA023RV85yPZiZeTgc4KR8FKU
         uXZtPQ9eHlvaEREqOGFVlRGKYiEpXuu5dpNWzueplCFUxLpCrIuuHTD8UunPUl9ttK9w
         /v2KDncRE4ho6cbuJEdv/zgzmUXRkDgUZU3jLUoF23ZkIsghGuYLjr8D/grYZi7N6xZ4
         o+dw==
X-Gm-Message-State: AOAM532DjKI97oiMj/WjHp8v2i50epI3MnGj5e2hMu8bgb3t+SZvZ4Hk
        q4Ms1KH6/GDC5CILyE1sufv/WHlk7Jk=
X-Google-Smtp-Source: ABdhPJxDb0Ac7EBCxbJHW8CG+pp6v/ylmnY9mKMb8muC/Z/UUFyVU/VeHhUgSQWM7mHTkJn/jBfsBA==
X-Received: by 2002:a17:90a:4681:: with SMTP id z1mr6999742pjf.131.1629505220116;
        Fri, 20 Aug 2021 17:20:20 -0700 (PDT)
Received: from localhost ([2405:201:6014:d820:9cc6:d37f:c2fd:dc6])
        by smtp.gmail.com with ESMTPSA id gl19sm7392829pjb.20.2021.08.20.17.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 17:20:19 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v4 02/22] tools: include: add ethtool_drvinfo definition to UAPI header
Date:   Sat, 21 Aug 2021 05:49:50 +0530
Message-Id: <20210821002010.845777-3-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210821002010.845777-1-memxor@gmail.com>
References: <20210821002010.845777-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of copying the whole header in, just add the struct definitions
we need for now. In the future it can be synced as a copy of in-tree
header if required.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/include/uapi/linux/ethtool.h | 53 ++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/tools/include/uapi/linux/ethtool.h b/tools/include/uapi/linux/ethtool.h
index c86c3e942df9..47afae3895ec 100644
--- a/tools/include/uapi/linux/ethtool.h
+++ b/tools/include/uapi/linux/ethtool.h
@@ -48,4 +48,57 @@ struct ethtool_channels {
 	__u32	combined_count;
 };
 
+#define ETHTOOL_FWVERS_LEN	32
+#define ETHTOOL_BUSINFO_LEN	32
+#define ETHTOOL_EROMVERS_LEN	32
+
+/**
+ * struct ethtool_drvinfo - general driver and device information
+ * @cmd: Command number = %ETHTOOL_GDRVINFO
+ * @driver: Driver short name.  This should normally match the name
+ *	in its bus driver structure (e.g. pci_driver::name).  Must
+ *	not be an empty string.
+ * @version: Driver version string; may be an empty string
+ * @fw_version: Firmware version string; may be an empty string
+ * @erom_version: Expansion ROM version string; may be an empty string
+ * @bus_info: Device bus address.  This should match the dev_name()
+ *	string for the underlying bus device, if there is one.  May be
+ *	an empty string.
+ * @reserved2: Reserved for future use; see the note on reserved space.
+ * @n_priv_flags: Number of flags valid for %ETHTOOL_GPFLAGS and
+ *	%ETHTOOL_SPFLAGS commands; also the number of strings in the
+ *	%ETH_SS_PRIV_FLAGS set
+ * @n_stats: Number of u64 statistics returned by the %ETHTOOL_GSTATS
+ *	command; also the number of strings in the %ETH_SS_STATS set
+ * @testinfo_len: Number of results returned by the %ETHTOOL_TEST
+ *	command; also the number of strings in the %ETH_SS_TEST set
+ * @eedump_len: Size of EEPROM accessible through the %ETHTOOL_GEEPROM
+ *	and %ETHTOOL_SEEPROM commands, in bytes
+ * @regdump_len: Size of register dump returned by the %ETHTOOL_GREGS
+ *	command, in bytes
+ *
+ * Users can use the %ETHTOOL_GSSET_INFO command to get the number of
+ * strings in any string set (from Linux 2.6.34).
+ *
+ * Drivers should set at most @driver, @version, @fw_version and
+ * @bus_info in their get_drvinfo() implementation.  The ethtool
+ * core fills in the other fields using other driver operations.
+ */
+struct ethtool_drvinfo {
+	__u32	cmd;
+	char	driver[32];
+	char	version[32];
+	char	fw_version[ETHTOOL_FWVERS_LEN];
+	char	bus_info[ETHTOOL_BUSINFO_LEN];
+	char	erom_version[ETHTOOL_EROMVERS_LEN];
+	char	reserved2[12];
+	__u32	n_priv_flags;
+	__u32	n_stats;
+	__u32	testinfo_len;
+	__u32	eedump_len;
+	__u32	regdump_len;
+};
+
+#define ETHTOOL_GDRVINFO	0x00000003
+
 #endif /* _UAPI_LINUX_ETHTOOL_H */
-- 
2.33.0

