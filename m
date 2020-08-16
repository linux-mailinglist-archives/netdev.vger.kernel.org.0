Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC2BD2459FD
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 01:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729023AbgHPXDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 19:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbgHPXDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Aug 2020 19:03:01 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55C7DC061786
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 16:03:01 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id t10so6572282plz.10
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 16:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bGp5jPj6YMIwtj56lYfWFkpJmOr0owZy9LNZ5qS70eo=;
        b=bD3xWDCoIoQIlTyzqLZegdSNgqfqZsvI1BKmB8k2+1tO4fSL5mXkXg0OA9UkUN4BAi
         ts707rS7nJ6IjabIUSuNRAOJ6bNsCGHTTqcxFd9/bMvx0G9c3INnW+ZT3YhtnY91Vphl
         JFzAaeHbIuVL2xTmM42WVLCcF8KsXJiSHmsw51HLirMG4aWWWpJHv0F2Cke+iapvNO61
         QDCF5qD6DKgdVsTWrf6pHFh8jb3XHZnBQHoouNUtLSfWpl/sdBG2sMaiAAzPxf4Sj9Vd
         F37Q2fv4R+Fo0CW8tFX2cCZC2TTz80DFZ7hKbueLUTM0A8yU+20V5mg7wumpyQi4ZZCs
         5uew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bGp5jPj6YMIwtj56lYfWFkpJmOr0owZy9LNZ5qS70eo=;
        b=hy4+GIcobAnXVWtdxuK4EPzSSI4KR+7UhXR8vxNoTdFn3YSQ/mQ2WudHFh0Mo8AeZB
         TEwhWbowkMjeuXiNVPsZTx55lkP6wzlHllu9KiI+KfUTQFJihMyyr3IdLrmKXhw+r/OF
         pQ0lxU5v320wNOXRgcYtYQJvPyDKBqiatB/in4Ycjnknj8O9WLKOY3S+cZVzv6k5q/4o
         v0qtvD/Re0UUcK5R9citLE4GYgpKevLKq/Fix2VyGILVZW7VLxGY9qr7iUr5/m6OpyI8
         2G2Y/oTYlxBOyDhSzIDXFE5VMO0+6tpLIvkzD1R7hKDdenOandFROJ1tDCBoJN1hwGpG
         RBKg==
X-Gm-Message-State: AOAM533nTc4xuePEOcvJBxhJKChsDwuGCS9P2W9n/9wZ9k6sg9nm+/7M
        mj4USPcjxKuUkHPU9oFAz5otFsVhQV221g==
X-Google-Smtp-Source: ABdhPJwjwf9sDS8ryQadyKI5ju4xR8nx4wy5n+zkV3kWt7zGvPkLdvsQOqYOneqyzrZ2vtqAHwtSqg==
X-Received: by 2002:a17:90a:17a7:: with SMTP id q36mr10382192pja.61.1597618980322;
        Sun, 16 Aug 2020 16:03:00 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 198sm16382760pfz.120.2020.08.16.16.02.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2020 16:02:59 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     leon@kernel.org
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 v1 2/2] rdma: use print_type() rather than print_color_type(xx, COLOR_NONE)
Date:   Sun, 16 Aug 2020 16:02:56 -0700
Message-Id: <20200816230256.13839-2-stephen@networkplumber.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200816230256.13839-1-stephen@networkplumber.org>
References: <20200816230256.13839-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is helper function that already has no color mode.
Use it so color is only used when needed

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 rdma/dev.c      | 14 +++++++-------
 rdma/link.c     | 24 ++++++++++++------------
 rdma/res-cmid.c | 10 +++++-----
 rdma/res-cq.c   |  2 +-
 rdma/res-qp.c   | 10 +++++-----
 rdma/res.c      | 22 +++++++++++-----------
 rdma/stat.c     | 12 ++++++------
 rdma/sys.c      |  2 +-
 rdma/utils.c    | 18 +++++++++---------
 9 files changed, 57 insertions(+), 57 deletions(-)

diff --git a/rdma/dev.c b/rdma/dev.c
index fd4c2376550c..eea09a4720b1 100644
--- a/rdma/dev.c
+++ b/rdma/dev.c
@@ -94,11 +94,11 @@ static void dev_print_caps(struct rd *rd, struct nlattr **tb)
 
 	caps = mnl_attr_get_u64(tb[RDMA_NLDEV_ATTR_CAP_FLAGS]);
 
-	print_color_string(PRINT_FP, COLOR_NONE, NULL, "\n    caps: <", NULL);
+	print_string(PRINT_FP, NULL, "\n    caps: <", NULL);
 	open_json_array(PRINT_JSON, "caps");
 	for (idx = 0; caps; idx++) {
 		if (caps & 0x1)
-			print_color_string(PRINT_ANY, COLOR_NONE, NULL,
+			print_string(PRINT_ANY, NULL,
 					   caps >> 0x1 ? "%s, " : "%s",
 					   dev_caps_to_str(idx));
 		caps >>= 0x1;
@@ -113,7 +113,7 @@ static void dev_print_fw(struct rd *rd, struct nlattr **tb)
 		return;
 
 	str = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_FW_VERSION]);
-	print_color_string(PRINT_ANY, COLOR_NONE, "fw", "fw %s ", str);
+	print_string(PRINT_ANY, "fw", "fw %s ", str);
 }
 
 static void dev_print_node_guid(struct rd *rd, struct nlattr **tb)
@@ -128,7 +128,7 @@ static void dev_print_node_guid(struct rd *rd, struct nlattr **tb)
 	node_guid = mnl_attr_get_u64(tb[RDMA_NLDEV_ATTR_NODE_GUID]);
 	memcpy(vp, &node_guid, sizeof(uint64_t));
 	snprintf(str, 32, "%04x:%04x:%04x:%04x", vp[3], vp[2], vp[1], vp[0]);
-	print_color_string(PRINT_ANY, COLOR_NONE, "node_guid", "node_guid %s ",
+	print_string(PRINT_ANY, "node_guid", "node_guid %s ",
 			   str);
 }
 
@@ -144,7 +144,7 @@ static void dev_print_sys_image_guid(struct rd *rd, struct nlattr **tb)
 	sys_image_guid = mnl_attr_get_u64(tb[RDMA_NLDEV_ATTR_SYS_IMAGE_GUID]);
 	memcpy(vp, &sys_image_guid, sizeof(uint64_t));
 	snprintf(str, 32, "%04x:%04x:%04x:%04x", vp[3], vp[2], vp[1], vp[0]);
-	print_color_string(PRINT_ANY, COLOR_NONE, "sys_image_guid",
+	print_string(PRINT_ANY, "sys_image_guid",
 			   "sys_image_guid %s ", str);
 }
 
@@ -185,7 +185,7 @@ static void dev_print_node_type(struct rd *rd, struct nlattr **tb)
 
 	node_type = mnl_attr_get_u8(tb[RDMA_NLDEV_ATTR_DEV_NODE_TYPE]);
 	node_str = node_type_to_str(node_type);
-	print_color_string(PRINT_ANY, COLOR_NONE, "node_type", "node_type %s ",
+	print_string(PRINT_ANY, "node_type", "node_type %s ",
 			   node_str);
 }
 
@@ -202,7 +202,7 @@ static int dev_parse_cb(const struct nlmsghdr *nlh, void *data)
 	open_json_object(NULL);
 	idx =  mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
 	name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
-	print_color_uint(PRINT_ANY, COLOR_NONE, "ifindex", "%u: ", idx);
+	print_uint(PRINT_ANY, "ifindex", "%u: ", idx);
 	print_color_string(PRINT_ANY, COLOR_IFNAME, "ifname", "%s: ", name);
 
 	dev_print_node_type(rd, tb);
diff --git a/rdma/link.c b/rdma/link.c
index 4b68eb28ec36..bfd720c55d2f 100644
--- a/rdma/link.c
+++ b/rdma/link.c
@@ -96,11 +96,11 @@ static void link_print_caps(struct rd *rd, struct nlattr **tb)
 
 	caps = mnl_attr_get_u64(tb[RDMA_NLDEV_ATTR_CAP_FLAGS]);
 
-	print_color_string(PRINT_FP, COLOR_NONE, NULL, "\n    caps: <", NULL);
+	print_string(PRINT_FP, NULL, "\n    caps: <", NULL);
 	open_json_array(PRINT_JSON, "caps");
 	for (idx = 0; caps; idx++) {
 		if (caps & 0x1)
-			print_color_string(PRINT_ANY, COLOR_NONE, NULL,
+			print_string(PRINT_ANY, NULL,
 					   caps >> 0x1 ? "%s, " : "%s",
 					   caps_to_str(idx));
 		caps >>= 0x1;
@@ -120,7 +120,7 @@ static void link_print_subnet_prefix(struct rd *rd, struct nlattr **tb)
 	subnet_prefix = mnl_attr_get_u64(tb[RDMA_NLDEV_ATTR_SUBNET_PREFIX]);
 	memcpy(vp, &subnet_prefix, sizeof(uint64_t));
 	snprintf(str, 32, "%04x:%04x:%04x:%04x", vp[3], vp[2], vp[1], vp[0]);
-	print_color_string(PRINT_ANY, COLOR_NONE, "subnet_prefix",
+	print_string(PRINT_ANY, "subnet_prefix",
 			   "subnet_prefix %s ", str);
 }
 
@@ -132,7 +132,7 @@ static void link_print_lid(struct rd *rd, struct nlattr **tb)
 		return;
 
 	lid = mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_LID]);
-	print_color_uint(PRINT_ANY, COLOR_NONE, "lid", "lid %u ", lid);
+	print_uint(PRINT_ANY, "lid", "lid %u ", lid);
 }
 
 static void link_print_sm_lid(struct rd *rd, struct nlattr **tb)
@@ -143,7 +143,7 @@ static void link_print_sm_lid(struct rd *rd, struct nlattr **tb)
 		return;
 
 	sm_lid = mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_SM_LID]);
-	print_color_uint(PRINT_ANY, COLOR_NONE, "sm_lid", "sm_lid %u ", sm_lid);
+	print_uint(PRINT_ANY, "sm_lid", "sm_lid %u ", sm_lid);
 }
 
 static void link_print_lmc(struct rd *rd, struct nlattr **tb)
@@ -154,7 +154,7 @@ static void link_print_lmc(struct rd *rd, struct nlattr **tb)
 		return;
 
 	lmc = mnl_attr_get_u8(tb[RDMA_NLDEV_ATTR_LMC]);
-	print_color_uint(PRINT_ANY, COLOR_NONE, "lmc", "lmc %u ", lmc);
+	print_uint(PRINT_ANY, "lmc", "lmc %u ", lmc);
 }
 
 static const char *link_state_to_str(uint8_t link_state)
@@ -176,7 +176,7 @@ static void link_print_state(struct rd *rd, struct nlattr **tb)
 		return;
 
 	state = mnl_attr_get_u8(tb[RDMA_NLDEV_ATTR_PORT_STATE]);
-	print_color_string(PRINT_ANY, COLOR_NONE, "state", "state %s ",
+	print_string(PRINT_ANY, "state", "state %s ",
 			   link_state_to_str(state));
 }
 
@@ -202,7 +202,7 @@ static void link_print_phys_state(struct rd *rd, struct nlattr **tb)
 		return;
 
 	phys_state = mnl_attr_get_u8(tb[RDMA_NLDEV_ATTR_PORT_PHYS_STATE]);
-	print_color_string(PRINT_ANY, COLOR_NONE, "physical_state",
+	print_string(PRINT_ANY, "physical_state",
 			   "physical_state %s ", phys_state_to_str(phys_state));
 }
 
@@ -216,9 +216,9 @@ static void link_print_netdev(struct rd *rd, struct nlattr **tb)
 
 	netdev_name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_NDEV_NAME]);
 	idx = mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_NDEV_INDEX]);
-	print_color_string(PRINT_ANY, COLOR_NONE, "netdev", "netdev %s ",
+	print_string(PRINT_ANY, "netdev", "netdev %s ",
 			   netdev_name);
-	print_color_uint(PRINT_ANY, COLOR_NONE, "netdev_index",
+	print_uint(PRINT_ANY, "netdev_index",
 			 rd->show_details ? "netdev_index %u " : "", idx);
 }
 
@@ -243,9 +243,9 @@ static int link_parse_cb(const struct nlmsghdr *nlh, void *data)
 	name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
 
 	open_json_object(NULL);
-	print_color_uint(PRINT_JSON, COLOR_NONE, "ifindex", NULL, idx);
+	print_uint(PRINT_JSON, "ifindex", NULL, idx);
 	print_color_string(PRINT_ANY, COLOR_IFNAME, "ifname", "link %s/", name);
-	print_color_uint(PRINT_ANY, COLOR_NONE, "port", "%u ", port);
+	print_uint(PRINT_ANY, "port", "%u ", port);
 	link_print_subnet_prefix(rd, tb);
 	link_print_lid(rd, tb);
 	link_print_sm_lid(rd, tb);
diff --git a/rdma/res-cmid.c b/rdma/res-cmid.c
index bfaa47b5ad89..1474be87013f 100644
--- a/rdma/res-cmid.c
+++ b/rdma/res-cmid.c
@@ -39,13 +39,13 @@ static const char *cm_id_ps_to_str(uint32_t ps)
 
 static void print_cm_id_state(struct rd *rd, uint8_t state)
 {
-	print_color_string(PRINT_ANY, COLOR_NONE, "state", "state %s ",
+	print_string(PRINT_ANY, "state", "state %s ",
 			   cm_id_state_to_str(state));
 }
 
 static void print_ps(struct rd *rd, uint32_t ps)
 {
-	print_color_string(PRINT_ANY, COLOR_NONE, "ps", "ps %s ",
+	print_string(PRINT_ANY, "ps", "ps %s ",
 			   cm_id_ps_to_str(ps));
 }
 
@@ -56,9 +56,9 @@ static void print_ipaddr(struct rd *rd, const char *key, char *addrstr,
 	char json_name[name_size];
 
 	snprintf(json_name, name_size, "%s:%u", addrstr, port);
-	print_color_string(PRINT_ANY, COLOR_NONE, key, key, json_name);
-	print_color_string(PRINT_FP, COLOR_NONE, NULL, " %s:", addrstr);
-	print_color_uint(PRINT_FP, COLOR_NONE, NULL, "%u ", port);
+	print_string(PRINT_ANY, key, key, json_name);
+	print_string(PRINT_FP, NULL, " %s:", addrstr);
+	print_uint(PRINT_FP, NULL, "%u ", port);
 }
 
 static int ss_ntop(struct nlattr *nla_line, char *addr_str, uint16_t *port)
diff --git a/rdma/res-cq.c b/rdma/res-cq.c
index 313f929a29b5..f0ac2ebb3118 100644
--- a/rdma/res-cq.c
+++ b/rdma/res-cq.c
@@ -21,7 +21,7 @@ static void print_poll_ctx(struct rd *rd, uint8_t poll_ctx, struct nlattr *attr)
 {
 	if (!attr)
 		return;
-	print_color_string(PRINT_ANY, COLOR_NONE, "poll-ctx", "poll-ctx %s ",
+	print_string(PRINT_ANY, "poll-ctx", "poll-ctx %s ",
 			   poll_ctx_to_str(poll_ctx));
 }
 
diff --git a/rdma/res-qp.c b/rdma/res-qp.c
index a38be3995d19..8c0f37615649 100644
--- a/rdma/res-qp.c
+++ b/rdma/res-qp.c
@@ -32,18 +32,18 @@ static void print_rqpn(struct rd *rd, uint32_t val, struct nlattr **nla_line)
 {
 	if (!nla_line[RDMA_NLDEV_ATTR_RES_RQPN])
 		return;
-	print_color_uint(PRINT_ANY, COLOR_NONE, "rqpn", "rqpn %d ", val);
+	print_uint(PRINT_ANY, "rqpn", "rqpn %d ", val);
 }
 
 static void print_type(struct rd *rd, uint32_t val)
 {
-	print_color_string(PRINT_ANY, COLOR_NONE, "type", "type %s ",
+	print_string(PRINT_ANY, "type", "type %s ",
 			   qp_types_to_str(val));
 }
 
 static void print_state(struct rd *rd, uint32_t val)
 {
-	print_color_string(PRINT_ANY, COLOR_NONE, "state", "state %s ",
+	print_string(PRINT_ANY, "state", "state %s ",
 			   qp_states_to_str(val));
 }
 
@@ -52,7 +52,7 @@ static void print_rqpsn(struct rd *rd, uint32_t val, struct nlattr **nla_line)
 	if (!nla_line[RDMA_NLDEV_ATTR_RES_RQ_PSN])
 		return;
 
-	print_color_uint(PRINT_ANY, COLOR_NONE, "rq-psn", "rq-psn %d ", val);
+	print_uint(PRINT_ANY, "rq-psn", "rq-psn %d ", val);
 }
 
 static void print_pathmig(struct rd *rd, uint32_t val, struct nlattr **nla_line)
@@ -60,7 +60,7 @@ static void print_pathmig(struct rd *rd, uint32_t val, struct nlattr **nla_line)
 	if (!nla_line[RDMA_NLDEV_ATTR_RES_PATH_MIG_STATE])
 		return;
 
-	print_color_string(PRINT_ANY, COLOR_NONE, "path-mig-state",
+	print_string(PRINT_ANY, "path-mig-state",
 			   "path-mig-state %s ", path_mig_to_str(val));
 }
 
diff --git a/rdma/res.c b/rdma/res.c
index 4661dda4c303..2cb9fd97d0d4 100644
--- a/rdma/res.c
+++ b/rdma/res.c
@@ -75,7 +75,7 @@ static int res_no_args_parse_cb(const struct nlmsghdr *nlh, void *data)
 	idx =  mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
 	name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
 	open_json_object(NULL);
-	print_color_uint(PRINT_ANY, COLOR_NONE, "ifindex", "%u: ", idx);
+	print_uint(PRINT_ANY, "ifindex", "%u: ", idx);
 	print_color_string(PRINT_ANY, COLOR_IFNAME, "ifname", "%s: ", name);
 	res_print_summary(rd, tb);
 	newline(rd);
@@ -161,12 +161,12 @@ void print_comm(struct rd *rd, const char *str, struct nlattr **nla_line)
 		snprintf(tmp, sizeof(tmp), "%s", str);
 	else
 		snprintf(tmp, sizeof(tmp), "[%s]", str);
-	print_color_string(PRINT_ANY, COLOR_NONE, "comm", "comm %s ", tmp);
+	print_string(PRINT_ANY, "comm", "comm %s ", tmp);
 }
 
 void print_dev(struct rd *rd, uint32_t idx, const char *name)
 {
-	print_color_int(PRINT_ANY, COLOR_NONE, "ifindex", NULL, idx);
+	print_int(PRINT_ANY, "ifindex", NULL, idx);
 	print_color_string(PRINT_ANY, COLOR_IFNAME, "ifname", "dev %s ", name);
 }
 
@@ -175,23 +175,23 @@ void print_link(struct rd *rd, uint32_t idx, const char *name, uint32_t port,
 {
 	char tmp[64] = {};
 
-	print_color_uint(PRINT_JSON, COLOR_NONE, "ifindex", NULL, idx);
+	print_uint(PRINT_JSON, "ifindex", NULL, idx);
 	print_color_string(PRINT_ANY, COLOR_IFNAME, "ifname", NULL, name);
 	if (nla_line[RDMA_NLDEV_ATTR_PORT_INDEX]) {
-		print_color_uint(PRINT_ANY, COLOR_NONE, "port", NULL, port);
+		print_uint(PRINT_ANY, "port", NULL, port);
 		snprintf(tmp, sizeof(tmp), "%s/%d", name, port);
 	} else {
 		snprintf(tmp, sizeof(tmp), "%s/-", name);
 	}
 
 	if (!rd->json_output)
-		print_color_string(PRINT_ANY, COLOR_NONE, NULL, "link %s ",
+		print_string(PRINT_ANY, NULL, "link %s ",
 				   tmp);
 }
 
 void print_qp_type(struct rd *rd, uint32_t val)
 {
-	print_color_string(PRINT_ANY, COLOR_NONE, "qp-type", "qp-type %s ",
+	print_string(PRINT_ANY, "qp-type", "qp-type %s ",
 			   qp_types_to_str(val));
 }
 
@@ -224,8 +224,8 @@ void print_key(struct rd *rd, const char *name, uint64_t val,
 {
 	if (!nlattr)
 		return;
-	print_color_string(PRINT_FP, COLOR_NONE, NULL, name, NULL);
-	print_color_hex(PRINT_ANY, COLOR_NONE, name, " 0x%" PRIx64 " ", val);
+	print_string(PRINT_FP, NULL, name, NULL);
+	print_hex(PRINT_ANY, name, " 0x%" PRIx64 " ", val);
 }
 
 void res_print_uint(struct rd *rd, const char *name, uint64_t val,
@@ -233,8 +233,8 @@ void res_print_uint(struct rd *rd, const char *name, uint64_t val,
 {
 	if (!nlattr)
 		return;
-	print_color_uint(PRINT_ANY, COLOR_NONE, name, name, val);
-	print_color_uint(PRINT_FP, COLOR_NONE, NULL, " %d ", val);
+	print_uint(PRINT_ANY, name, name, val);
+	print_uint(PRINT_FP, NULL, " %d ", val);
 }
 
 RES_FUNC(res_no_args,	RDMA_NLDEV_CMD_RES_GET,	NULL, true, 0);
diff --git a/rdma/stat.c b/rdma/stat.c
index 274e4aca5172..30a874255ead 100644
--- a/rdma/stat.c
+++ b/rdma/stat.c
@@ -125,7 +125,7 @@ static int qp_link_get_mode_parse_cb(const struct nlmsghdr *nlh, void *data)
 
 	open_json_object(NULL);
 	print_link(rd, idx, name, port, tb);
-	print_color_string(PRINT_ANY, COLOR_NONE, "mode", "mode %s ", output);
+	print_string(PRINT_ANY, "mode", "mode %s ", output);
 	newline(rd);
 	return MNL_CB_OK;
 }
@@ -270,7 +270,7 @@ static int res_counter_line(struct rd *rd, const char *name, int index,
 		return err;
 	open_json_object(NULL);
 	print_link(rd, index, name, port, nla_line);
-	print_color_uint(PRINT_ANY, COLOR_NONE, "cntn", "cntn %u ", cntn);
+	print_uint(PRINT_ANY, "cntn", "cntn %u ", cntn);
 	if (nla_line[RDMA_NLDEV_ATTR_RES_TYPE])
 		print_qp_type(rd, qp_type);
 	res_print_uint(rd, "pid", pid, nla_line[RDMA_NLDEV_ATTR_RES_PID]);
@@ -278,7 +278,7 @@ static int res_counter_line(struct rd *rd, const char *name, int index,
 	res_get_hwcounters(rd, hwc_table, true);
 	isfirst = true;
 	open_json_array(PRINT_JSON, "lqpn");
-	print_color_string(PRINT_FP, COLOR_NONE, NULL, "\n    LQPN: <", NULL);
+	print_string(PRINT_FP, NULL, "\n    LQPN: <", NULL);
 	mnl_attr_for_each_nested(nla_entry, qp_table) {
 		struct nlattr *qp_line[RDMA_NLDEV_ATTR_MAX] = {};
 		err = mnl_attr_parse_nested(nla_entry, rd_attr_cb, qp_line);
@@ -290,9 +290,9 @@ static int res_counter_line(struct rd *rd, const char *name, int index,
 
 		qpn = mnl_attr_get_u32(qp_line[RDMA_NLDEV_ATTR_RES_LQPN]);
 		if (!isfirst)
-			print_color_string(PRINT_FP, COLOR_NONE, NULL, ",",
+			print_string(PRINT_FP, NULL, ",",
 					   NULL);
-		print_color_uint(PRINT_ANY, COLOR_NONE, NULL, "%d", qpn);
+		print_uint(PRINT_ANY, NULL, "%d", qpn);
 		isfirst = false;
 	}
 	close_json_array(PRINT_ANY, ">");
@@ -712,7 +712,7 @@ static int stat_show_parse_cb(const struct nlmsghdr *nlh, void *data)
 	port = mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_PORT_INDEX]);
 	open_json_object(NULL);
 	print_color_string(PRINT_ANY, COLOR_IFNAME, "ifname", "link %s/", name);
-	print_color_uint(PRINT_ANY, COLOR_NONE, "port", "%u ", port);
+	print_uint(PRINT_ANY, "port", "%u ", port);
 	ret = res_get_hwcounters(rd, tb[RDMA_NLDEV_ATTR_STAT_HWCOUNTERS], true);
 
 	newline(rd);
diff --git a/rdma/sys.c b/rdma/sys.c
index 8fb565d70598..8f1b597a6286 100644
--- a/rdma/sys.c
+++ b/rdma/sys.c
@@ -35,7 +35,7 @@ static int sys_show_parse_cb(const struct nlmsghdr *nlh, void *data)
 		else
 			mode_str = "unknown";
 
-		print_color_string(PRINT_ANY, COLOR_NONE, "netns", "netns %s\n",
+		print_string(PRINT_ANY, "netns", "netns %s\n",
 				   mode_str);
 	}
 	return MNL_CB_OK;
diff --git a/rdma/utils.c b/rdma/utils.c
index 4d3de4fadba2..e273524d754e 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -764,20 +764,20 @@ struct dev_map *dev_map_lookup(struct rd *rd, bool allow_port_index)
 void newline(struct rd *rd)
 {
 	close_json_object();
-	print_color_string(PRINT_FP, COLOR_NONE, NULL, "\n", NULL);
+	print_string(PRINT_FP, NULL, "\n", NULL);
 }
 
 void newline_indent(struct rd *rd)
 {
 	newline(rd);
-	print_color_string(PRINT_FP, COLOR_NONE, NULL, "    ", NULL);
+	print_string(PRINT_FP, NULL, "    ", NULL);
 }
 
 static int print_driver_string(struct rd *rd, const char *key_str,
 				 const char *val_str)
 {
-	print_color_string(PRINT_ANY, COLOR_NONE, key_str, key_str, val_str);
-	print_color_string(PRINT_FP, COLOR_NONE, NULL, " %s ", val_str);
+	print_string(PRINT_ANY, key_str, key_str, val_str);
+	print_string(PRINT_FP, NULL, " %s ", val_str);
 	return 0;
 }
 
@@ -799,7 +799,7 @@ static int print_driver_s32(struct rd *rd, const char *key_str, int32_t val,
 			return -EINVAL;
 		}
 	}
-	print_color_int(PRINT_JSON, COLOR_NONE, key_str, NULL, val);
+	print_int(PRINT_JSON, key_str, NULL, val);
 	return 0;
 }
 
@@ -816,7 +816,7 @@ static int print_driver_u32(struct rd *rd, const char *key_str, uint32_t val,
 			return -EINVAL;
 		}
 	}
-	print_color_int(PRINT_JSON, COLOR_NONE, key_str, NULL, val);
+	print_int(PRINT_JSON, key_str, NULL, val);
 	return 0;
 }
 
@@ -833,7 +833,7 @@ static int print_driver_s64(struct rd *rd, const char *key_str, int64_t val,
 			return -EINVAL;
 		}
 	}
-	print_color_int(PRINT_JSON, COLOR_NONE, key_str, NULL, val);
+	print_int(PRINT_JSON, key_str, NULL, val);
 	return 0;
 }
 
@@ -850,7 +850,7 @@ static int print_driver_u64(struct rd *rd, const char *key_str, uint64_t val,
 			return -EINVAL;
 		}
 	}
-	print_color_int(PRINT_JSON, COLOR_NONE, key_str, NULL, val);
+	print_int(PRINT_JSON, key_str, NULL, val);
 	return 0;
 }
 
@@ -904,7 +904,7 @@ void print_raw_data(struct rd *rd, struct nlattr **nla_line)
 	data = mnl_attr_get_payload(nla_line[RDMA_NLDEV_ATTR_RES_RAW]);
 	open_json_array(PRINT_JSON, "data");
 	while (i < len) {
-		print_color_uint(PRINT_ANY, COLOR_NONE, NULL, "%d", data[i]);
+		print_uint(PRINT_ANY, NULL, "%d", data[i]);
 		i++;
 	}
 	close_json_array(PRINT_ANY, ">");
-- 
2.27.0

