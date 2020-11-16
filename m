Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C968F2B3FEF
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 10:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728598AbgKPJfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 04:35:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728593AbgKPJfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 04:35:24 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB8F4C0613D1;
        Mon, 16 Nov 2020 01:35:23 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id 74so24196431lfo.5;
        Mon, 16 Nov 2020 01:35:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FxyaWGigiA6CBHv9VZdDh747TfZt+Mrn5SZjiJ5kOxE=;
        b=YlR2C9TZc9+c0VsAQukQIUtdQa2AHSCzdssCyjRnZa0cqzoYGbxtieUshDtOU80SxZ
         VQZjjVCXbjejyiNiwKs7FIz3SofUICk1uA3ujS+SKJzFpiu6zYNwulyb3SlZ4oIbti2H
         n4dGRv02HywLJMC/HxKszCyB1RGP1hm4aF66jRM/cBJtf/mvfXoatGoNiwuoy7RjVVc3
         3RG9Dj17bX6OR0chsSnzswbDAg+YDz0jNzJ/pDeLzDcpxe7otzpmQk4rR5hizcaZapRT
         dEpngkf1mzrhYuXM+XEviPO2Agd9QGwaIAzXA1TfUn9IV2ztVrse5d6Wr681LqeERrbl
         DLCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FxyaWGigiA6CBHv9VZdDh747TfZt+Mrn5SZjiJ5kOxE=;
        b=fgnYY16S4syRjCz+ktiWroa5N0FyRZLmwpiUhQmrkSBQJkcu/O2cpRfyX4+EWEa0YZ
         K+7nIVSBEj39ahAf4rnTn8MD/+wcn5xMjlZUm6vUB9aldwcTVJ6gBUztTyUFgWE3IYvY
         go6bmeBIf5tTM7TtRSaGy2Sg9wXev2AfsMjarNc2PwqDj+aK/uxuOL8/BtVrfCuYASvv
         p0uF6SjMwD3N5EwEraQqYUTHrNJ+MR2uCLoZk4Evlw1UjSZIY9m1Kc46j8KAFL/1rec6
         yzsUMXfbF0PsHNRjoUdRwFKVMhYJP1gJGy2DBLMyXDzJ6u0EwnWX++TQ1J2/2trzhiFt
         AkiA==
X-Gm-Message-State: AOAM532Obo1tXdpX38wMcYE6+PAICM491d0GL6e4alvY1eA5TC9Kozq9
        M3zBQD6Nl2eBuiDDs5UjRhE=
X-Google-Smtp-Source: ABdhPJwWiQhkPSOX7+DP+n1wbQypCgrpozRFyxo785vqUBp9Xwas5JPp0symuh9I+57dA4ysUgHvSg==
X-Received: by 2002:a19:a05:: with SMTP id 5mr4940806lfk.291.1605519322241;
        Mon, 16 Nov 2020 01:35:22 -0800 (PST)
Received: from localhost.localdomain (87-205-71-93.adsl.inetia.pl. [87.205.71.93])
        by smtp.gmail.com with ESMTPSA id t26sm2667986lfp.296.2020.11.16.01.35.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 01:35:21 -0800 (PST)
From:   alardam@gmail.com
X-Google-Original-From: marekx.majtyka@intel.com
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        andrii.nakryiko@gmail.com, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, davem@davemloft.net,
        john.fastabend@gmail.com, hawk@kernel.org, toke@redhat.com
Cc:     maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        maciejromanfijalkowski@gmail.com, intel-wired-lan@lists.osuosl.org,
        Marek Majtyka <marekx.majtyka@intel.com>
Subject: [PATCH 6/8] libbpf: add functions to get XSK modes
Date:   Mon, 16 Nov 2020 10:34:50 +0100
Message-Id: <20201116093452.7541-7-marekx.majtyka@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201116093452.7541-1-marekx.majtyka@intel.com>
References: <20201116093452.7541-1-marekx.majtyka@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Majtyka <marekx.majtyka@intel.com>

Add functions to get XDP/XSK modes from netdev feature flags
over netlink ethtool family interface. These functions provide
functionalities that are going to be used in upcoming changes
together constituting new libbpf public API function which
informs about key xsk capabilities of given network interface.

Signed-off-by: Marek Majtyka <marekx.majtyka@intel.com>
---
 tools/include/uapi/linux/ethtool.h |  44 ++++
 tools/lib/bpf/ethtool.h            |  49 ++++
 tools/lib/bpf/libbpf.h             |   1 +
 tools/lib/bpf/netlink.c            | 379 ++++++++++++++++++++++++++++-
 4 files changed, 469 insertions(+), 4 deletions(-)
 create mode 100644 tools/lib/bpf/ethtool.h

diff --git a/tools/include/uapi/linux/ethtool.h b/tools/include/uapi/linux/ethtool.h
index c86c3e942df9..cf3041d302e4 100644
--- a/tools/include/uapi/linux/ethtool.h
+++ b/tools/include/uapi/linux/ethtool.h
@@ -48,4 +48,48 @@ struct ethtool_channels {
 	__u32	combined_count;
 };
 
+#define ETH_GSTRING_LEN		32
+
+/**
+ * enum ethtool_stringset - string set ID
+ * @ETH_SS_TEST: Self-test result names, for use with %ETHTOOL_TEST
+ * @ETH_SS_STATS: Statistic names, for use with %ETHTOOL_GSTATS
+ * @ETH_SS_PRIV_FLAGS: Driver private flag names, for use with
+ *	%ETHTOOL_GPFLAGS and %ETHTOOL_SPFLAGS
+ * @ETH_SS_NTUPLE_FILTERS: Previously used with %ETHTOOL_GRXNTUPLE;
+ *	now deprecated
+ * @ETH_SS_FEATURES: Device feature names
+ * @ETH_SS_RSS_HASH_FUNCS: RSS hush function names
+ * @ETH_SS_PHY_STATS: Statistic names, for use with %ETHTOOL_GPHYSTATS
+ * @ETH_SS_PHY_TUNABLES: PHY tunable names
+ * @ETH_SS_LINK_MODES: link mode names
+ * @ETH_SS_MSG_CLASSES: debug message class names
+ * @ETH_SS_WOL_MODES: wake-on-lan modes
+ * @ETH_SS_SOF_TIMESTAMPING: SOF_TIMESTAMPING_* flags
+ * @ETH_SS_TS_TX_TYPES: timestamping Tx types
+ * @ETH_SS_TS_RX_FILTERS: timestamping Rx filters
+ * @ETH_SS_UDP_TUNNEL_TYPES: UDP tunnel types
+ */
+enum ethtool_stringset {
+	ETH_SS_TEST		= 0,
+	ETH_SS_STATS,
+	ETH_SS_PRIV_FLAGS,
+	ETH_SS_NTUPLE_FILTERS,
+	ETH_SS_FEATURES,
+	ETH_SS_RSS_HASH_FUNCS,
+	ETH_SS_TUNABLES,
+	ETH_SS_PHY_STATS,
+	ETH_SS_PHY_TUNABLES,
+	ETH_SS_LINK_MODES,
+	ETH_SS_MSG_CLASSES,
+	ETH_SS_WOL_MODES,
+	ETH_SS_SOF_TIMESTAMPING,
+	ETH_SS_TS_TX_TYPES,
+	ETH_SS_TS_RX_FILTERS,
+	ETH_SS_UDP_TUNNEL_TYPES,
+
+	/* add new constants above here */
+	ETH_SS_COUNT
+};
+
 #endif /* _UAPI_LINUX_ETHTOOL_H */
diff --git a/tools/lib/bpf/ethtool.h b/tools/lib/bpf/ethtool.h
new file mode 100644
index 000000000000..14b2ae47bc26
--- /dev/null
+++ b/tools/lib/bpf/ethtool.h
@@ -0,0 +1,49 @@
+/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
+
+/*
+ * Generic netlink ethtool family required defines
+ *
+ * Copyright (c) 2020 Intel
+ */
+
+#ifndef __LIBBPF_ETHTOOL_H_
+#define __LIBBPF_ETHTOOL_H_
+
+#include <linux/ethtool_netlink.h>
+
+#define DIV_ROUND_UP(n, d)  (((n) + (d) - 1) / (d))
+#define FEATURE_BITS_TO_BLOCKS(n_bits)      DIV_ROUND_UP(n_bits, 32U)
+
+#define FEATURE_WORD(blocks, index)  ((blocks)[(index) / 32U])
+#define FEATURE_FIELD_FLAG(index)       (1U << (index) % 32U)
+#define FEATURE_BIT_IS_SET(blocks, index)        \
+		(FEATURE_WORD(blocks, index) & FEATURE_FIELD_FLAG(index))
+
+#define NETDEV_XDP_STR			"xdp"
+#define NETDEV_XDP_LEN			4
+
+#define NETDEV_AF_XDP_ZC_STR		"af-xdp-zc"
+#define NETDEV_AF_XDP_ZC_LEN		10
+
+#define BUF_SIZE_4096			4096
+#define BUF_SIZE_8192			8192
+
+#define MAX_FEATURES			500
+
+struct ethnl_params {
+	const char *ifname;
+	const char *nl_family;
+	int features;
+	int xdp_idx;
+	int xdp_zc_idx;
+	int xdp_flags;
+	int xdp_zc_flags;
+	__u16 fam_id;
+};
+
+int libbpf_ethnl_get_ethtool_family_id(struct ethnl_params *param);
+int libbpf_ethnl_get_netdev_features(struct ethnl_params *param);
+int libbpf_ethnl_get_active_bits(struct ethnl_params *param);
+
+#endif /* __LIBBPF_ETHTOOL_H_ */
+
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 6909ee81113a..4f0656716eee 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -41,6 +41,7 @@ enum libbpf_errno {
 	LIBBPF_ERRNO__WRNGPID,	/* Wrong pid in netlink message */
 	LIBBPF_ERRNO__INVSEQ,	/* Invalid netlink sequence */
 	LIBBPF_ERRNO__NLPARSE,	/* netlink parsing error */
+	LIBBPF_ERRNO__INVXDP,	/* Invalid XDP data */
 	__LIBBPF_ERRNO__END,
 };
 
diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index 4dd73de00b6f..a5344401b842 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -6,6 +6,8 @@
 #include <unistd.h>
 #include <linux/bpf.h>
 #include <linux/rtnetlink.h>
+#include <linux/genetlink.h>
+#include <linux/if.h>
 #include <sys/socket.h>
 #include <errno.h>
 #include <time.h>
@@ -14,6 +16,7 @@
 #include "libbpf.h"
 #include "libbpf_internal.h"
 #include "nlattr.h"
+#include "ethtool.h"
 
 #ifndef SOL_NETLINK
 #define SOL_NETLINK 270
@@ -23,6 +26,11 @@ typedef int (*libbpf_dump_nlmsg_t)(void *cookie, void *msg, struct nlattr **tb);
 
 typedef int (*__dump_nlmsg_t)(struct nlmsghdr *nlmsg, libbpf_dump_nlmsg_t,
 			      void *cookie);
+struct ethnl_msg {
+	struct nlmsghdr nlh;
+	struct genlmsghdr genlhdr;
+	char msg[BUF_SIZE_4096];
+};
 
 struct xdp_id_md {
 	int ifindex;
@@ -30,7 +38,7 @@ struct xdp_id_md {
 	struct xdp_link_info info;
 };
 
-static int libbpf_netlink_open(__u32 *nl_pid)
+static int libbpf_netlink_open(__u32 *nl_pid, int protocol)
 {
 	struct sockaddr_nl sa;
 	socklen_t addrlen;
@@ -40,7 +48,7 @@ static int libbpf_netlink_open(__u32 *nl_pid)
 	memset(&sa, 0, sizeof(sa));
 	sa.nl_family = AF_NETLINK;
 
-	sock = socket(AF_NETLINK, SOCK_RAW, NETLINK_ROUTE);
+	sock = socket(AF_NETLINK, SOCK_RAW, protocol);
 	if (sock < 0)
 		return -errno;
 
@@ -143,7 +151,7 @@ static int __bpf_set_link_xdp_fd_replace(int ifindex, int fd, int old_fd,
 	} req;
 	__u32 nl_pid = 0;
 
-	sock = libbpf_netlink_open(&nl_pid);
+	sock = libbpf_netlink_open(&nl_pid, NETLINK_ROUTE);
 	if (sock < 0)
 		return sock;
 
@@ -302,7 +310,7 @@ int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
 	if (flags && flags & mask)
 		return -EINVAL;
 
-	sock = libbpf_netlink_open(&nl_pid);
+	sock = libbpf_netlink_open(&nl_pid, NETLINK_ROUTE);
 	if (sock < 0)
 		return sock;
 
@@ -370,3 +378,366 @@ int libbpf_nl_get_link(int sock, unsigned int nl_pid,
 	return bpf_netlink_recv(sock, nl_pid, seq, __dump_link_nlmsg,
 				dump_link_nlmsg, cookie);
 }
+
+static int libbpf_ethtool_parse_feature_strings(struct nlattr *start, int elem,
+						int *xdp, int *xdp_zc)
+{
+	struct nlattr *tbs[__ETHTOOL_A_STRING_CNT + 1];
+	struct nlattr *tab[elem > 0 ? elem : 0];
+	struct libbpf_nla_policy policy[] = {
+		[ETHTOOL_A_STRING_UNSPEC] = {
+		.type = LIBBPF_NLA_UNSPEC,
+		.minlen = 0,
+		.maxlen = 0,
+		},
+		[ETHTOOL_A_STRING_INDEX] = {
+		.type = LIBBPF_NLA_U32,
+		.minlen = sizeof(uint32_t),
+		.maxlen = sizeof(uint32_t),
+		},
+		[ETHTOOL_A_STRING_VALUE] = {
+		.type = LIBBPF_NLA_STRING,
+		.minlen = 1,
+		.maxlen = ETH_GSTRING_LEN,
+		}
+	};
+	const char *f;
+	int n = 0;
+	__u32 v;
+	int ret;
+	int i;
+
+	if (!xdp || !xdp_zc || !start || elem <= 0)
+		return -EINVAL;
+
+	*xdp = -1;
+	*xdp_zc = -1;
+
+	ret = libbpf_nla_parse_table(tab, elem, start, 0, NULL);
+	if (ret)
+		goto cleanup;
+
+	for (i = 0; tab[i] && i < elem; ++i) {
+		ret = libbpf_nla_parse_nested(tbs, __ETHTOOL_A_STRING_CNT, tab[i], policy);
+		if (ret)
+			break;
+
+		if (tbs[ETHTOOL_A_STRING_INDEX] && tbs[ETHTOOL_A_STRING_VALUE]) {
+			f = libbpf_nla_getattr_str(tbs[ETHTOOL_A_STRING_VALUE]);
+			v = libbpf_nla_getattr_u32(tbs[ETHTOOL_A_STRING_INDEX]);
+
+			if (!strncmp(NETDEV_XDP_STR, f, NETDEV_XDP_LEN)) {
+				*xdp = v;
+				n++;
+			}
+
+			if (!strncmp(NETDEV_AF_XDP_ZC_STR, f, NETDEV_AF_XDP_ZC_LEN)) {
+				*xdp_zc = v;
+				n++;
+			}
+		} else {
+			ret = -LIBBPF_ERRNO__NLPARSE;
+			break;
+		}
+	}
+
+cleanup:
+	/* If error occurred return it. */
+	if (ret)
+		return ret;
+
+	/*
+	 * If zero or two xdp flags found that is okay.
+	 * Zero means older kernel without any xdp flags added.
+	 * Two means newer kernel with xdp flags added.
+	 * Both flags were added in single commit, so that
+	 * n == 1 is a faulty value.
+	 */
+	if (n == 2 || n == 0)
+		return 0;
+
+	/* If no error and one or more than 2 xdp flags found return error */
+	return -LIBBPF_ERRNO__INVXDP;
+}
+
+static int libbpf_ethnl_send(int sock, __u32 seq, __u32 nl_pid, struct ethnl_msg *req)
+{
+	ssize_t written;
+
+	req->nlh.nlmsg_pid = nl_pid;
+	req->nlh.nlmsg_seq = seq;
+
+	written = send(sock, req, req->nlh.nlmsg_len, 0);
+	if (written < 0)
+		return -errno;
+
+	if (written == req->nlh.nlmsg_len)
+		return 0;
+	else
+		return -errno;
+}
+
+static int libbpf_ethnl_validate(int len, __u16 fam_id, __u32 nl_pid, __u32 seq,
+				 struct ethnl_msg *req)
+{
+	if (!NLMSG_OK(&req->nlh, (unsigned int)len))
+		return -ENOMSG;
+
+	if (req->nlh.nlmsg_pid != nl_pid)
+		return -LIBBPF_ERRNO__WRNGPID;
+
+	if (req->nlh.nlmsg_seq != seq)
+		return -LIBBPF_ERRNO__INVSEQ;
+
+	if (req->nlh.nlmsg_type != fam_id) {
+		int ret = -ENOMSG;
+
+		if (req->nlh.nlmsg_type == NLMSG_ERROR) {
+			struct nlmsgerr *err = (struct nlmsgerr *)&req->genlhdr;
+
+			if (err->error)
+				ret = err->error;
+			libbpf_nla_dump_errormsg(&req->nlh);
+		}
+		return ret;
+	}
+
+	return 0;
+}
+
+static int libbpf_ethnl_send_recv(struct ethnl_msg *req, struct ethnl_params *param)
+{
+	__u32 nl_pid;
+	__u32 seq;
+	int sock;
+	int ret;
+	int len;
+
+	sock = libbpf_netlink_open(&nl_pid, NETLINK_GENERIC);
+	if (sock < 0) {
+		ret = sock;
+		goto cleanup;
+	}
+
+	seq = time(NULL);
+	ret = libbpf_ethnl_send(sock, seq, nl_pid, req);
+	if (ret)
+		goto cleanup;
+
+	len = recv(sock, req, sizeof(struct ethnl_msg), 0);
+	if (len < 0) {
+		ret = -errno;
+		goto cleanup;
+	}
+
+	ret = libbpf_ethnl_validate(len, param->fam_id, nl_pid, seq, req);
+	if (ret < 0)
+		goto cleanup;
+
+	ret = len;
+
+cleanup:
+	if (sock >= 0)
+		close(sock);
+
+	return ret;
+}
+
+int libbpf_ethnl_get_netdev_features(struct ethnl_params *param)
+{
+	struct ethnl_msg req = {
+		.nlh.nlmsg_len = NLMSG_LENGTH(sizeof(struct genlmsghdr)),
+		.nlh.nlmsg_flags = NLM_F_REQUEST,
+		.nlh.nlmsg_type = param->fam_id,
+		.nlh.nlmsg_pid = 0,
+		.genlhdr.version = ETHTOOL_GENL_VERSION,
+		.genlhdr.cmd = ETHTOOL_MSG_STRSET_GET,
+		.genlhdr.reserved = 0,
+	};
+	struct nlattr *tbn[__ETHTOOL_A_STRINGSETS_CNT + 1];
+	struct nlattr *tbnn[__ETHTOOL_A_STRINGSET_CNT + 1];
+	struct nlattr *tb[__ETHTOOL_A_STRSET_CNT + 1];
+	struct nlattr *nla, *nla_next, *nla_set;
+	int string_set = ETH_SS_FEATURES;
+	int ret;
+	int len;
+
+	memset(&req.msg, 0, BUF_SIZE_4096);
+
+	nla = (struct nlattr *)req.msg;
+	nla_next = libbpf_nla_nest_start(nla, ETHTOOL_A_STRSET_HEADER);
+	nla_next = libbpf_nla_put_str(nla_next, ETHTOOL_A_HEADER_DEV_NAME,
+				      param->ifname, IFNAMSIZ);
+	libbpf_nla_nest_end(nla, nla_next);
+
+	nla = nla_next;
+	nla_set = libbpf_nla_nest_start(nla, ETHTOOL_A_STRSET_STRINGSETS);
+	nla_next = libbpf_nla_nest_start(nla_set, ETHTOOL_A_STRINGSETS_STRINGSET);
+	nla_next = libbpf_nla_put_u32(nla_next, ETHTOOL_A_STRINGSET_ID, string_set);
+	libbpf_nla_nest_end(nla_set, nla_next);
+	libbpf_nla_nest_end(nla, nla_next);
+	if (!param->features)
+		nla_next = libbpf_nla_put_flag(nla_next, ETHTOOL_A_STRSET_COUNTS_ONLY);
+
+	req.nlh.nlmsg_len += libbpf_nla_attrs_length((struct nlattr *)req.msg, nla_next);
+
+	len = libbpf_ethnl_send_recv(&req, param);
+	if (len < 0)
+		return len;
+
+	/* set parsing error, and change if succeeded */
+	ret = -LIBBPF_ERRNO__NLPARSE;
+	nla = (struct nlattr *)req.msg;
+	len = len - NLMSG_HDRLEN - GENL_HDRLEN;
+
+	if (libbpf_nla_parse(tb, __ETHTOOL_A_STRSET_CNT, nla, len, NULL))
+		return ret;
+
+	if (!tb[ETHTOOL_A_STRSET_STRINGSETS])
+		return ret;
+
+	if (libbpf_nla_parse_nested(tbn, __ETHTOOL_A_STRINGSETS_CNT,
+				    tb[ETHTOOL_A_STRSET_STRINGSETS], NULL))
+		return ret;
+
+	if (!tbn[ETHTOOL_A_STRINGSETS_STRINGSET])
+		return ret;
+
+	if (libbpf_nla_parse_nested(tbnn, __ETHTOOL_A_STRINGSET_CNT,
+				    tbn[ETHTOOL_A_STRINGSETS_STRINGSET], NULL))
+		return ret;
+
+	if (param->features == 0) {
+		if (!tbnn[ETHTOOL_A_STRINGSET_COUNT])
+			return ret;
+
+		param->features = libbpf_nla_getattr_u32(tbnn[ETHTOOL_A_STRINGSET_COUNT]);
+
+		/* success */
+		ret = 0;
+	} else if (param->features > 0) {
+		if (!tbnn[ETHTOOL_A_STRINGSET_STRINGS])
+			return ret;
+
+		/*
+		 * Upper boundary is known, but it is input from socket stream.
+		 * Let's perform upper limit check anyway, and limit it up to
+		 * MAX_FEATURES (which is still far more than is actually needed).
+		 */
+		if (param->features > MAX_FEATURES)
+			param->features = MAX_FEATURES;
+
+		/* success if returns 0 */
+		ret = libbpf_ethtool_parse_feature_strings(tbnn[ETHTOOL_A_STRINGSET_STRINGS],
+							   param->features, &param->xdp_idx,
+							   &param->xdp_zc_idx);
+	}
+
+	return ret;
+}
+
+int libbpf_ethnl_get_ethtool_family_id(struct ethnl_params *param)
+{
+	struct ethnl_msg req = {
+		.nlh.nlmsg_len = NLMSG_LENGTH(sizeof(struct genlmsghdr)),
+		.nlh.nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK,
+		.nlh.nlmsg_type = GENL_ID_CTRL,
+		.nlh.nlmsg_pid = 0,
+		.genlhdr.version = ETHTOOL_GENL_VERSION,
+		.genlhdr.cmd = CTRL_CMD_GETFAMILY,
+		.genlhdr.reserved = 0,
+	};
+	struct nlattr *tb[__CTRL_ATTR_MAX + 1] = {0};
+	struct nlattr *nla, *nla_next;
+	int ret = -1;
+	int len;
+
+	memset(&req.msg, 0, BUF_SIZE_4096);
+	param->fam_id = GENL_ID_CTRL;
+
+	nla = (struct nlattr *)req.msg;
+	nla_next = libbpf_nla_put_str(nla, CTRL_ATTR_FAMILY_NAME, param->nl_family, GENL_NAMSIZ);
+	req.nlh.nlmsg_len += libbpf_nla_attrs_length(nla, nla_next);
+
+	len = libbpf_ethnl_send_recv(&req, param);
+	if (len < 0)
+		return len;
+
+	/* set parsing error, and change if succeeded */
+	ret = -LIBBPF_ERRNO__NLPARSE;
+	len = len - NLMSG_HDRLEN - GENL_HDRLEN;
+	if (!libbpf_nla_parse(tb, __CTRL_ATTR_MAX, nla, len, NULL)) {
+		if (tb[CTRL_ATTR_FAMILY_ID]) {
+			param->fam_id = libbpf_nla_getattr_u16(tb[CTRL_ATTR_FAMILY_ID]);
+			ret = 0;
+		}
+	}
+
+	return ret;
+}
+
+int libbpf_ethnl_get_active_bits(struct ethnl_params *param)
+{
+	struct ethnl_msg req = {
+		.nlh.nlmsg_len = NLMSG_LENGTH(sizeof(struct genlmsghdr)),
+		.nlh.nlmsg_flags = NLM_F_REQUEST,
+		.nlh.nlmsg_type = param->fam_id,
+		.nlh.nlmsg_pid = 0,
+		.genlhdr.cmd = ETHTOOL_MSG_FEATURES_GET,
+		.genlhdr.version = ETHTOOL_GENL_VERSION,
+		.genlhdr.reserved = 0,
+	};
+	__u32  active[FEATURE_BITS_TO_BLOCKS(param->features)];
+	struct nlattr *tb[__ETHTOOL_A_FEATURES_CNT + 1];
+	struct nlattr *tbn[__ETHTOOL_A_BITSET_CNT + 1];
+	int flags = ETHTOOL_FLAG_COMPACT_BITSETS;
+	struct nlattr *nla, *nla_next;
+	int ret = -1;
+	int len;
+
+	memset(&req.msg, 0, BUF_SIZE_4096);
+
+	nla = (struct nlattr *)req.msg;
+	nla_next = libbpf_nla_nest_start(nla, ETHTOOL_A_FEATURES_HEADER);
+	nla_next = libbpf_nla_put_str(nla_next, ETHTOOL_A_HEADER_DEV_NAME, param->ifname, IFNAMSIZ);
+	nla_next = libbpf_nla_put_u32(nla_next, ETHTOOL_A_HEADER_FLAGS, flags);
+	libbpf_nla_nest_end(nla, nla_next);
+	req.nlh.nlmsg_len += libbpf_nla_attrs_length(nla, nla_next);
+
+	len = libbpf_ethnl_send_recv(&req, param);
+	if (len < 0)
+		return len;
+
+	ret = -LIBBPF_ERRNO__NLPARSE;
+	nla = (struct nlattr *)req.msg;
+	len = len - NLMSG_HDRLEN - GENL_HDRLEN;
+	if (libbpf_nla_parse(tb, __ETHTOOL_A_FEATURES_CNT, nla, len, NULL))
+		return ret;
+
+	if (!tb[ETHTOOL_A_FEATURES_ACTIVE])
+		return ret;
+
+	if (libbpf_nla_parse_nested(tbn, __ETHTOOL_A_BITSET_CNT,
+				    tb[ETHTOOL_A_FEATURES_ACTIVE], NULL))
+		return ret;
+
+	if (!tbn[ETHTOOL_A_BITSET_VALUE])
+		return ret;
+
+	for (unsigned int i = 0; i < FEATURE_BITS_TO_BLOCKS(param->features); ++i)
+		active[i]  = libbpf_nla_getattr_u32(tbn[ETHTOOL_A_BITSET_VALUE] + i);
+
+	/* mark successful parsing */
+	ret = 0;
+	if (FEATURE_BIT_IS_SET(active, param->xdp_idx)) {
+		param->xdp_flags = 1;
+		if (FEATURE_BIT_IS_SET(active, param->xdp_zc_idx))
+			param->xdp_zc_flags = 1;
+	} else {
+		/* zero copy without driver mode makes no sense */
+		if (FEATURE_BIT_IS_SET(active, param->xdp_zc_idx))
+			ret = -LIBBPF_ERRNO__INVXDP;
+	}
+
+	return ret;
+}
-- 
2.20.1

