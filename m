Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9D0305CA7
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 14:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343812AbhA0NMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 08:12:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343657AbhA0NKv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 08:10:51 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A47C06178C;
        Wed, 27 Jan 2021 05:09:06 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id n25so1573342pgb.0;
        Wed, 27 Jan 2021 05:09:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tdr1vTjH34h/VYtvH3qpG6TP7zun3Pkb4XYsF/4HLgM=;
        b=SaCEgrvNt31ta7fH1mOZQBFS0uN77PVA2AM3IVOJXQfOHUAHOE4GblC/e02/+4ISWl
         4md6elVHf6w0feuUf6ly1oAQtCaORbPyiEVPfKY5A3SmNc1g5Dff0WrmBq20skuCYcnB
         vVGt9fITElBOBYlxysKtVhMdEpXiHU34cjbfylrOKmWs201hE7hfvMQZ24fQ/3XxWs0x
         hGWCNHEOrGNsMQjYPPCDDFe1/pry6KaD5GWgLh++hH38bWU/Zv3ePPBTkssu+r6ZyaUL
         JNyF5HXnowvv3+SEYp+4/KqTkvuUc0Cx/APVT9XcbZOHCe1SOdEDSBZoesqbRf64/VJZ
         1SGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tdr1vTjH34h/VYtvH3qpG6TP7zun3Pkb4XYsF/4HLgM=;
        b=DIevHrlCsRsN5Zv7A0dHrRl4JElR43BfGotOWwe6JXX7585VkPk4NOHVXLKW4s2cOS
         b38chCFzvs20yWdw731we8jeme4F9QYe96XBOL0jXi34hU3XxuDcNPtmQFy0yCvoLyfF
         6waC0JGT/dxDtg8swBtJJOjF60cybKgqxuJfYC5i0nuch8xq/jfRDhlYMAzAWONhgRry
         kTywNH6Kbx8qp+w0kNmEbwiKz4+WzKuf4Puoy6xaxQm4QyaOwb49ngiBT5yV19GXvRht
         CYzffkAaqqpEaIx8ewgSnC7pne1xbYeoiDO7bkaOBobYVi0uL2FL+xyF2rI+RlAqkf6i
         hvQA==
X-Gm-Message-State: AOAM531SHTz76TH+ESgLuxmdsCZArd8iJh8U/QhTFrkBRWZhZutjge2X
        sI1JVIPnCeRdeh5QbUQmLFG7Ozj0QFKuBQ==
X-Google-Smtp-Source: ABdhPJx1pAg7dbz/HExnfq4yKGL+1skNsuXvjpD0Ej6Gji13HS3vvvjiGH5aaEynzRUWDWejz/BLrg==
X-Received: by 2002:a63:643:: with SMTP id 64mr11053291pgg.422.1611752945644;
        Wed, 27 Jan 2021 05:09:05 -0800 (PST)
Received: from localhost.localdomain ([182.226.226.37])
        by smtp.googlemail.com with ESMTPSA id 6sm2163343pjm.31.2021.01.27.05.09.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 05:09:04 -0800 (PST)
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
X-Google-Original-From: Bongsu Jeon
To:     kuba@kernel.org, shuah@kernel.org
Cc:     krzk@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-nfc@lists.01.org,
        linux-kselftest@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH net-next v4 2/2] selftests: Add nci suite
Date:   Wed, 27 Jan 2021 22:08:29 +0900
Message-Id: <20210127130829.4026-3-bongsu.jeon@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210127130829.4026-1-bongsu.jeon@samsung.com>
References: <20210127130829.4026-1-bongsu.jeon@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

This is the NCI test suite. It tests the NFC/NCI module using virtual NCI
device. Test cases consist of making the virtual NCI device on/off and
controlling the device's polling for NCI1.0 and NCI2.0 version.

Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
---
 MAINTAINERS                           |   8 +
 tools/testing/selftests/Makefile      |   1 +
 tools/testing/selftests/nci/Makefile  |   6 +
 tools/testing/selftests/nci/config    |   3 +
 tools/testing/selftests/nci/nci_dev.c | 599 ++++++++++++++++++++++++++
 5 files changed, 617 insertions(+)
 create mode 100644 tools/testing/selftests/nci/Makefile
 create mode 100644 tools/testing/selftests/nci/config
 create mode 100644 tools/testing/selftests/nci/nci_dev.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 096b584e7fed..b62832e39e2a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12531,6 +12531,14 @@ F:	include/net/nfc/
 F:	include/uapi/linux/nfc.h
 F:	net/nfc/
 
+NFC VIRTUAL NCI DEVICE DRIVER
+M:	Bongsu Jeon <bongsu.jeon@samsung.com>
+L:	netdev@vger.kernel.org
+L:	linux-nfc@lists.01.org (moderated for non-subscribers)
+S:	Supported
+F:	drivers/nfc/virtual_ncidev.c
+F:	tools/testing/selftests/nci/
+
 NFS, SUNRPC, AND LOCKD CLIENTS
 M:	Trond Myklebust <trond.myklebust@hammerspace.com>
 M:	Anna Schumaker <anna.schumaker@netapp.com>
diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 8a917cb4426a..c42aacec5038 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -34,6 +34,7 @@ TARGETS += memory-hotplug
 TARGETS += mincore
 TARGETS += mount
 TARGETS += mqueue
+TARGETS += nci
 TARGETS += net
 TARGETS += net/forwarding
 TARGETS += net/mptcp
diff --git a/tools/testing/selftests/nci/Makefile b/tools/testing/selftests/nci/Makefile
new file mode 100644
index 000000000000..47669a1d6a59
--- /dev/null
+++ b/tools/testing/selftests/nci/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0
+CFLAGS += -Wl,-no-as-needed -Wall
+LDFLAGS += -lpthread
+
+TEST_GEN_PROGS := nci_dev
+include ../lib.mk
diff --git a/tools/testing/selftests/nci/config b/tools/testing/selftests/nci/config
new file mode 100644
index 000000000000..b084e78276be
--- /dev/null
+++ b/tools/testing/selftests/nci/config
@@ -0,0 +1,3 @@
+CONFIG_NFC=y
+CONFIG_NFC_NCI=y
+CONFIG_NFC_VIRTUAL_NCI=y
diff --git a/tools/testing/selftests/nci/nci_dev.c b/tools/testing/selftests/nci/nci_dev.c
new file mode 100644
index 000000000000..57b505cb1561
--- /dev/null
+++ b/tools/testing/selftests/nci/nci_dev.c
@@ -0,0 +1,599 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2021 Samsung Electrnoics
+ * Bongsu Jeon <bongsu.jeon@samsung.com>
+ *
+ * Test code for nci
+ */
+
+#include <stdlib.h>
+#include <errno.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <fcntl.h>
+#include <pthread.h>
+#include <linux/genetlink.h>
+#include <sys/socket.h>
+#include <linux/nfc.h>
+
+#include "../kselftest_harness.h"
+
+#define GENLMSG_DATA(glh)	((void *)(NLMSG_DATA(glh) + GENL_HDRLEN))
+#define GENLMSG_PAYLOAD(glh)	(NLMSG_PAYLOAD(glh, 0) - GENL_HDRLEN)
+#define NLA_DATA(na)		((void *)((char *)(na) + NLA_HDRLEN))
+#define NLA_PAYLOAD(len)	((len) - NLA_HDRLEN)
+
+#define MAX_MSG_SIZE	1024
+
+#define IOCTL_GET_NCIDEV_IDX	0
+#define VIRTUAL_NFC_PROTOCOLS	(NFC_PROTO_JEWEL_MASK | \
+				 NFC_PROTO_MIFARE_MASK | \
+				 NFC_PROTO_FELICA_MASK | \
+				 NFC_PROTO_ISO14443_MASK | \
+				 NFC_PROTO_ISO14443_B_MASK | \
+				 NFC_PROTO_ISO15693_MASK)
+
+const __u8 nci_reset_cmd[] = {0x20, 0x00, 0x01, 0x01};
+const __u8 nci_init_cmd[] = {0x20, 0x01, 0x00};
+const __u8 nci_rf_discovery_cmd[] = {0x21, 0x03, 0x09, 0x04, 0x00, 0x01,
+				      0x01, 0x01, 0x02, 0x01, 0x06, 0x01};
+const __u8 nci_init_cmd_v2[] = {0x20, 0x01, 0x02, 0x00, 0x00};
+const __u8 nci_rf_disc_map_cmd[] = {0x21, 0x00, 0x07, 0x02, 0x04, 0x03,
+				     0x02, 0x05, 0x03, 0x03};
+const __u8 nci_rf_deact_cmd[] = {0x21, 0x06, 0x01, 0x00};
+const __u8 nci_reset_rsp[] = {0x40, 0x00, 0x03, 0x00, 0x10, 0x01};
+const __u8 nci_reset_rsp_v2[] = {0x40, 0x00, 0x01, 0x00};
+const __u8 nci_reset_ntf[] = {0x60, 0x00, 0x09, 0x02, 0x01, 0x20, 0x0e,
+			       0x04, 0x61, 0x00, 0x04, 0x02};
+const __u8 nci_init_rsp[] = {0x40, 0x01, 0x14, 0x00, 0x02, 0x0e, 0x02,
+			      0x00, 0x03, 0x01, 0x02, 0x03, 0x02, 0xc8,
+			      0x00, 0xff, 0x10, 0x00, 0x0e, 0x12, 0x00,
+			      0x00, 0x04};
+const __u8 nci_init_rsp_v2[] = {0x40, 0x01, 0x1c, 0x00, 0x1a, 0x7e, 0x06,
+				 0x00, 0x02, 0x92, 0x04, 0xff, 0xff, 0x01,
+				 0x00, 0x40, 0x06, 0x00, 0x00, 0x01, 0x01,
+				 0x00, 0x02, 0x00, 0x03, 0x01, 0x01, 0x06,
+				 0x00, 0x80, 0x00};
+const __u8 nci_rf_disc_map_rsp[] = {0x41, 0x00, 0x01, 0x00};
+const __u8 nci_rf_disc_rsp[] = {0x41, 0x03, 0x01, 0x00};
+const __u8 nci_rf_deact_rsp[] = {0x41, 0x06, 0x01, 0x00};
+
+struct msgtemplate {
+	struct nlmsghdr n;
+	struct genlmsghdr g;
+	char buf[MAX_MSG_SIZE];
+};
+
+static int create_nl_socket(void)
+{
+	int fd;
+	struct sockaddr_nl local;
+
+	fd = socket(AF_NETLINK, SOCK_RAW, NETLINK_GENERIC);
+	if (fd < 0)
+		return -1;
+
+	memset(&local, 0, sizeof(local));
+	local.nl_family = AF_NETLINK;
+
+	if (bind(fd, (struct sockaddr *)&local, sizeof(local)) < 0)
+		goto error;
+
+	return fd;
+error:
+	close(fd);
+	return -1;
+}
+
+static int send_cmd_mt_nla(int sd, __u16 nlmsg_type, __u32 nlmsg_pid,
+			   __u8 genl_cmd, int nla_num, __u16 nla_type[],
+			   void *nla_data[], int nla_len[])
+{
+	struct sockaddr_nl nladdr;
+	struct msgtemplate msg;
+	struct nlattr *na;
+	int cnt, prv_len;
+	int r, buflen;
+	char *buf;
+
+	msg.n.nlmsg_len = NLMSG_LENGTH(GENL_HDRLEN);
+	msg.n.nlmsg_type = nlmsg_type;
+	msg.n.nlmsg_flags = NLM_F_REQUEST;
+	msg.n.nlmsg_seq = 0;
+	msg.n.nlmsg_pid = nlmsg_pid;
+	msg.g.cmd = genl_cmd;
+	msg.g.version = 0x1;
+
+	prv_len = 0;
+	for (cnt = 0; cnt < nla_num; cnt++) {
+		na = (struct nlattr *)(GENLMSG_DATA(&msg) + prv_len);
+		na->nla_type = nla_type[cnt];
+		na->nla_len = nla_len[cnt] + NLA_HDRLEN;
+
+		if (nla_len > 0)
+			memcpy(NLA_DATA(na), nla_data[cnt], nla_len[cnt]);
+
+		msg.n.nlmsg_len += NLMSG_ALIGN(na->nla_len);
+		prv_len = na->nla_len;
+	}
+
+	buf = (char *)&msg;
+	buflen = msg.n.nlmsg_len;
+	memset(&nladdr, 0, sizeof(nladdr));
+	nladdr.nl_family = AF_NETLINK;
+
+	while ((r = sendto(sd, buf, buflen, 0, (struct sockaddr *)&nladdr,
+			   sizeof(nladdr))) < buflen) {
+		if (r > 0) {
+			buf += r;
+			buflen -= r;
+		} else if (errno != EAGAIN) {
+			return -1;
+		}
+	}
+	return 0;
+}
+
+static int send_get_nfc_family(int sd, __u32 pid)
+{
+	__u16 nla_get_family_type = CTRL_ATTR_FAMILY_NAME;
+	void *nla_get_family_data;
+	int nla_get_family_len;
+	char family_name[100];
+
+	nla_get_family_len = strlen(NFC_GENL_NAME) + 1;
+	strcpy(family_name, NFC_GENL_NAME);
+	nla_get_family_data = family_name;
+
+	return send_cmd_mt_nla(sd, GENL_ID_CTRL, pid, CTRL_CMD_GETFAMILY,
+				1, &nla_get_family_type,
+				&nla_get_family_data, &nla_get_family_len);
+}
+
+static int get_family_id(int sd, __u32 pid)
+{
+	struct {
+		struct nlmsghdr n;
+		struct genlmsghdr g;
+		char buf[512];
+	} ans;
+	struct nlattr *na;
+	int rep_len;
+	__u16 id;
+	int rc;
+
+	rc = send_get_nfc_family(sd, pid);
+
+	if (rc < 0)
+		return 0;
+
+	rep_len = recv(sd, &ans, sizeof(ans), 0);
+
+	if (ans.n.nlmsg_type == NLMSG_ERROR || rep_len < 0 ||
+	    !NLMSG_OK(&ans.n, rep_len))
+		return 0;
+
+	na = (struct nlattr *)GENLMSG_DATA(&ans);
+	na = (struct nlattr *)((char *)na + NLA_ALIGN(na->nla_len));
+	if (na->nla_type == CTRL_ATTR_FAMILY_ID)
+		id = *(__u16 *)NLA_DATA(na);
+
+	return id;
+}
+
+static int send_cmd_with_idx(int sd, __u16 nlmsg_type, __u32 nlmsg_pid,
+			     __u8 genl_cmd, int dev_id)
+{
+	__u16 nla_type = NFC_ATTR_DEVICE_INDEX;
+	void *nla_data = &dev_id;
+	int nla_len = 4;
+
+	return send_cmd_mt_nla(sd, nlmsg_type, nlmsg_pid, genl_cmd, 1,
+				&nla_type, &nla_data, &nla_len);
+}
+
+static int get_nci_devid(int sd, __u16 fid, __u32 pid, int dev_id, struct msgtemplate *msg)
+{
+	int rc, rep_len;
+
+	rc = send_cmd_with_idx(sd, fid, pid, NFC_CMD_GET_DEVICE, dev_id);
+	if (rc < 0) {
+		rc = -1;
+		goto error;
+	}
+
+	rep_len = recv(sd, msg, sizeof(*msg), 0);
+	if (rep_len < 0) {
+		rc = -2;
+		goto error;
+	}
+
+	if (msg->n.nlmsg_type == NLMSG_ERROR ||
+	    !NLMSG_OK(&msg->n, rep_len)) {
+		rc = -3;
+		goto error;
+	}
+
+	return 0;
+error:
+	return rc;
+}
+
+static __u8 get_dev_enable_state(struct msgtemplate *msg)
+{
+	struct nlattr *na;
+	int rep_len;
+	int len;
+
+	rep_len = GENLMSG_PAYLOAD(&msg->n);
+	na = (struct nlattr *)GENLMSG_DATA(msg);
+	len = 0;
+
+	while (len < rep_len) {
+		len += NLA_ALIGN(na->nla_len);
+		if (na->nla_type == NFC_ATTR_DEVICE_POWERED)
+			return *(char *)NLA_DATA(na);
+		na = (struct nlattr *)(GENLMSG_DATA(msg) + len);
+	}
+
+	return rep_len;
+}
+
+FIXTURE(NCI) {
+	int virtual_nci_fd;
+	bool open_state;
+	int dev_idex;
+	bool isNCI2;
+	int proto;
+	__u32 pid;
+	__u16 fid;
+	int sd;
+};
+
+FIXTURE_VARIANT(NCI) {
+	bool isNCI2;
+};
+
+FIXTURE_VARIANT_ADD(NCI, NCI1_0) {
+	.isNCI2 = false,
+};
+
+FIXTURE_VARIANT_ADD(NCI, NCI2_0) {
+	.isNCI2 = true,
+};
+
+static void *virtual_dev_open(void *data)
+{
+	char buf[258];
+	int dev_fd;
+	int len;
+
+	dev_fd = *(int *)data;
+
+	while ((len = read(dev_fd, buf, 258)) == 0)
+		;
+	if (len <= 0)
+		goto error;
+	if (len != sizeof(nci_reset_cmd))
+		goto error;
+	if (memcmp(nci_reset_cmd, buf, len))
+		goto error;
+	write(dev_fd, nci_reset_rsp, sizeof(nci_reset_rsp));
+
+	while ((len = read(dev_fd, buf, 258)) == 0)
+		;
+	if (len <= 0)
+		goto error;
+	if (len != sizeof(nci_init_cmd))
+		goto error;
+	if (memcmp(nci_init_cmd, buf, len))
+		goto error;
+	write(dev_fd, nci_init_rsp, sizeof(nci_init_rsp));
+
+	while ((len = read(dev_fd, buf, 258)) == 0)
+		;
+	if (len <= 0)
+		goto error;
+	if (len != sizeof(nci_rf_disc_map_cmd))
+		goto error;
+	if (memcmp(nci_rf_disc_map_cmd, buf, len))
+		goto error;
+	write(dev_fd, nci_rf_disc_map_rsp, sizeof(nci_rf_disc_map_rsp));
+
+	return (void *)0;
+error:
+	return (void *)-1;
+}
+
+static void *virtual_dev_open_v2(void *data)
+{
+	char buf[258];
+	int dev_fd;
+	int len;
+
+	dev_fd = *(int *)data;
+
+	while ((len = read(dev_fd, buf, 258)) == 0)
+		;
+	if (len <= 0)
+		goto error;
+	if (len != sizeof(nci_reset_cmd))
+		goto error;
+	if (memcmp(nci_reset_cmd, buf, len))
+		goto error;
+	write(dev_fd, nci_reset_rsp_v2, sizeof(nci_reset_rsp_v2));
+	write(dev_fd, nci_reset_ntf, sizeof(nci_reset_ntf));
+
+	while ((len = read(dev_fd, buf, 258)) == 0)
+		;
+	if (len <= 0)
+		goto error;
+	if (len != sizeof(nci_init_cmd_v2))
+		goto error;
+	if (memcmp(nci_init_cmd_v2, buf, len))
+		goto error;
+	write(dev_fd, nci_init_rsp_v2, sizeof(nci_init_rsp_v2));
+
+	while ((len = read(dev_fd, buf, 258)) == 0)
+		;
+	if (len <= 0)
+		goto error;
+	if (len != sizeof(nci_rf_disc_map_cmd))
+		goto error;
+	if (memcmp(nci_rf_disc_map_cmd, buf, len))
+		goto error;
+	write(dev_fd, nci_rf_disc_map_rsp, sizeof(nci_rf_disc_map_rsp));
+
+	return (void *)0;
+error:
+	return (void *)-1;
+}
+
+FIXTURE_SETUP(NCI)
+{
+	struct msgtemplate msg;
+	pthread_t thread_t;
+	int status;
+	int rc;
+
+	self->open_state = false;
+	self->proto = VIRTUAL_NFC_PROTOCOLS;
+	self->isNCI2 = variant->isNCI2;
+
+	self->sd = create_nl_socket();
+	ASSERT_NE(self->sd, -1);
+
+	self->pid = getpid();
+	self->fid = get_family_id(self->sd, self->pid);
+	ASSERT_NE(self->fid, -1);
+
+	self->virtual_nci_fd = open("/dev/virtual_nci", O_RDWR);
+	ASSERT_GT(self->virtual_nci_fd, -1);
+
+	rc = ioctl(self->virtual_nci_fd, IOCTL_GET_NCIDEV_IDX, &self->dev_idex);
+	ASSERT_EQ(rc, 0);
+
+	rc = get_nci_devid(self->sd, self->fid, self->pid, self->dev_idex, &msg);
+	ASSERT_EQ(rc, 0);
+	EXPECT_EQ(get_dev_enable_state(&msg), 0);
+
+	if (self->isNCI2)
+		rc = pthread_create(&thread_t, NULL, virtual_dev_open_v2,
+				    (void *)&self->virtual_nci_fd);
+	else
+		rc = pthread_create(&thread_t, NULL, virtual_dev_open,
+				    (void *)&self->virtual_nci_fd);
+	ASSERT_GT(rc, -1);
+
+	rc = send_cmd_with_idx(self->sd, self->fid, self->pid,
+			       NFC_CMD_DEV_UP, self->dev_idex);
+	EXPECT_EQ(rc, 0);
+
+	pthread_join(thread_t, (void **)&status);
+	ASSERT_EQ(status, 0);
+	self->open_state = true;
+}
+
+static void *virtual_deinit(void *data)
+{
+	char buf[258];
+	int dev_fd;
+	int len;
+
+	dev_fd = *(int *)data;
+
+	while ((len = read(dev_fd, buf, 258)) == 0)
+		;
+	if (len <= 0)
+		goto error;
+	if (len != sizeof(nci_reset_cmd))
+		goto error;
+	if (memcmp(nci_reset_cmd, buf, len))
+		goto error;
+	write(dev_fd, nci_reset_rsp, sizeof(nci_reset_rsp));
+
+	return (void *)0;
+error:
+	return (void *)-1;
+}
+
+static void *virtual_deinit_v2(void *data)
+{
+	char buf[258];
+	int dev_fd;
+	int len;
+
+	dev_fd = *(int *)data;
+
+	while ((len = read(dev_fd, buf, 258)) == 0)
+		;
+	if (len <= 0)
+		goto error;
+	if (len != sizeof(nci_reset_cmd))
+		goto error;
+	if (memcmp(nci_reset_cmd, buf, len))
+		goto error;
+	write(dev_fd, nci_reset_rsp_v2, sizeof(nci_reset_rsp_v2));
+	write(dev_fd, nci_reset_ntf, sizeof(nci_reset_ntf));
+
+	return (void *)0;
+error:
+	return (void *)-1;
+}
+
+FIXTURE_TEARDOWN(NCI)
+{
+	pthread_t thread_t;
+	int status;
+	int rc;
+
+	if (self->open_state) {
+		if (self->isNCI2)
+			rc = pthread_create(&thread_t, NULL,
+					    virtual_deinit_v2,
+					    (void *)&self->virtual_nci_fd);
+		else
+			rc = pthread_create(&thread_t, NULL, virtual_deinit,
+					    (void *)&self->virtual_nci_fd);
+
+		ASSERT_GT(rc, -1);
+		rc = send_cmd_with_idx(self->sd, self->fid, self->pid,
+				       NFC_CMD_DEV_DOWN, self->dev_idex);
+		EXPECT_EQ(rc, 0);
+
+		pthread_join(thread_t, (void **)&status);
+		ASSERT_EQ(status, 0);
+	}
+
+	close(self->sd);
+	close(self->virtual_nci_fd);
+	self->open_state = false;
+}
+
+TEST_F(NCI, init)
+{
+	struct msgtemplate msg;
+	int rc;
+
+	rc = get_nci_devid(self->sd, self->fid, self->pid, self->dev_idex,
+			   &msg);
+	ASSERT_EQ(rc, 0);
+	EXPECT_EQ(get_dev_enable_state(&msg), 1);
+}
+
+static void *virtual_poll_start(void *data)
+{
+	char buf[258];
+	int dev_fd;
+	int len;
+
+	dev_fd = *(int *)data;
+
+	while ((len = read(dev_fd, buf, 258)) == 0)
+		;
+	if (len <= 0)
+		goto error;
+	if (len != sizeof(nci_rf_discovery_cmd))
+		goto error;
+	if (memcmp(nci_rf_discovery_cmd, buf, len))
+		goto error;
+	write(dev_fd, nci_rf_disc_rsp, sizeof(nci_rf_disc_rsp))
+		;
+
+	return (void *)0;
+error:
+	return (void *)-1;
+}
+
+static void *virtual_poll_stop(void *data)
+{
+	char buf[258];
+	int dev_fd;
+	int len;
+
+	dev_fd = *(int *)data;
+
+	while ((len = read(dev_fd, buf, 258)) == 0)
+		;
+	if (len <= 0)
+		goto error;
+	if (len != sizeof(nci_rf_deact_cmd))
+		goto error;
+	if (memcmp(nci_rf_deact_cmd, buf, len))
+		goto error;
+	write(dev_fd, nci_rf_deact_rsp, sizeof(nci_rf_deact_rsp));
+
+	return (void *)0;
+error:
+	return (void *)-1;
+}
+
+TEST_F(NCI, start_poll)
+{
+	__u16 nla_start_poll_type[2] = {NFC_ATTR_DEVICE_INDEX,
+					 NFC_ATTR_PROTOCOLS};
+	void *nla_start_poll_data[2] = {&self->dev_idex, &self->proto};
+	int nla_start_poll_len[2] = {4, 4};
+	pthread_t thread_t;
+	int status;
+	int rc;
+
+	rc = pthread_create(&thread_t, NULL, virtual_poll_start,
+			    (void *)&self->virtual_nci_fd);
+	ASSERT_GT(rc, -1);
+
+	rc = send_cmd_mt_nla(self->sd, self->fid, self->pid,
+			     NFC_CMD_START_POLL, 2, nla_start_poll_type,
+			     nla_start_poll_data, nla_start_poll_len);
+	EXPECT_EQ(rc, 0);
+
+	pthread_join(thread_t, (void **)&status);
+	ASSERT_EQ(status, 0);
+
+	rc = pthread_create(&thread_t, NULL, virtual_poll_stop,
+			    (void *)&self->virtual_nci_fd);
+	ASSERT_GT(rc, -1);
+
+	rc = send_cmd_with_idx(self->sd, self->fid, self->pid,
+			       NFC_CMD_STOP_POLL, self->dev_idex);
+	EXPECT_EQ(rc, 0);
+
+	pthread_join(thread_t, (void **)&status);
+	ASSERT_EQ(status, 0);
+}
+
+TEST_F(NCI, deinit)
+{
+	struct msgtemplate msg;
+	pthread_t thread_t;
+	int status;
+	int rc;
+
+	rc = get_nci_devid(self->sd, self->fid, self->pid, self->dev_idex,
+			   &msg);
+	ASSERT_EQ(rc, 0);
+	EXPECT_EQ(get_dev_enable_state(&msg), 1);
+
+	if (self->isNCI2)
+		rc = pthread_create(&thread_t, NULL, virtual_deinit_v2,
+				    (void *)&self->virtual_nci_fd);
+	else
+		rc = pthread_create(&thread_t, NULL, virtual_deinit,
+				    (void *)&self->virtual_nci_fd);
+	ASSERT_GT(rc, -1);
+
+	rc = send_cmd_with_idx(self->sd, self->fid, self->pid,
+			       NFC_CMD_DEV_DOWN, self->dev_idex);
+	EXPECT_EQ(rc, 0);
+
+	pthread_join(thread_t, (void **)&status);
+	self->open_state = 0;
+	ASSERT_EQ(status, 0);
+
+	rc = get_nci_devid(self->sd, self->fid, self->pid, self->dev_idex,
+			   &msg);
+	ASSERT_EQ(rc, 0);
+	EXPECT_EQ(get_dev_enable_state(&msg), 0);
+}
+
+TEST_HARNESS_MAIN
-- 
2.25.1

