Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2183EED7C
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 15:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240202AbhHQNaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 09:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240090AbhHQN3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 09:29:31 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57236C061764;
        Tue, 17 Aug 2021 06:28:58 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id nt11so32092234pjb.2;
        Tue, 17 Aug 2021 06:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tfmLY7S9YC+x9SpV8H7iTfznHpqcBZgtxlXa323i1bs=;
        b=d4cPNEY9m/qmp+lOikOdTdgkUlBgn/O1r1AGSq8krU9fF7XRadb0fmpA1WzZOqAj9q
         mzzIYGtxUXbs4kqTJL9P+hrKGjH0mscIt77UCqJq32ALiNSZcx1KFVn1RdxiMhjoz6f7
         kT/EbRtLlqRyIVHE/FtgMU9iqdRcp7qTGGSECLnMR9CBRHbkMwYiYyy04fPuSrBVraoD
         RaBLPW4QPHnpwM2JIZSzP8F0XmhcchLfD7/Y3PuKmi4bHwYZ1lfPCyDWbdfj9pY81e/f
         byvt9mGhK5Ugq/pcwkyZM65NNIocFQPmUr+MPXmj40JY4QdnuMz/qp0fxG+4wllMuwrw
         XFgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tfmLY7S9YC+x9SpV8H7iTfznHpqcBZgtxlXa323i1bs=;
        b=FSedWMt8EnmddBX34ZIftoAX8pOjk8Ty8Edv/SCBbcV0lwE9h9mla1iMLKLR33lvGQ
         0v31A8uSnXMZ9lWmYytWBKHFF6J32K+Y8fUcMRqseND5M3yiSD07uNTll8TZqJONDAAv
         TyNBawCsW6XYMKlx/L4YR/opKOOEUeq/sXWkjauSkfw/5JgGlc/ca81NGLOkP2OktN0A
         ozxPfYxYzmUcx4ro+ZZYncH9NM2tkEsYkxr93C64U346fgvHMUVbfHfl6OQvKgJIK85g
         BW82vj/JeeO/ZzaJASQdDJ+UVxg3yKE5rbS5shiv9J6/2Hd6S/LEWpbjbZwnXcNhB4YZ
         a0sw==
X-Gm-Message-State: AOAM533e3kTe6H1ByTKSYunMey7OqwDO6B8ScAMosceyNMgGAQ84hd1L
        usn23VKQsYpkuQzxCGXQA84=
X-Google-Smtp-Source: ABdhPJyTjNxgWs8FD0a8HnHXP/C1rDd3NWyM6Z9DCRjar43gGz0WiBvbdN+PFUtYCYd2l5EfGAZpPA==
X-Received: by 2002:a17:90a:154a:: with SMTP id y10mr3694151pja.8.1629206937928;
        Tue, 17 Aug 2021 06:28:57 -0700 (PDT)
Received: from ubuntu.localdomain ([182.226.226.37])
        by smtp.gmail.com with ESMTPSA id j6sm2791577pfi.220.2021.08.17.06.28.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 06:28:57 -0700 (PDT)
From:   bongsu.jeon2@gmail.com
To:     shuah@kernel.org, krzysztof.kozlowski@canonical.com
Cc:     netdev@vger.kernel.org, linux-nfc@lists.01.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH v2 net-next 8/8] selftests: nci: Add the NCI testcase reading T4T Tag
Date:   Tue, 17 Aug 2021 06:28:18 -0700
Message-Id: <20210817132818.8275-9-bongsu.jeon2@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210817132818.8275-1-bongsu.jeon2@gmail.com>
References: <20210817132818.8275-1-bongsu.jeon2@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

Add the NCI testcase reading T4T Tag that has NFC TEST in plain text.
the virtual device application acts as T4T Tag in this testcase.

Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
---
 tools/testing/selftests/nci/nci_dev.c | 292 +++++++++++++++++++++++++-
 1 file changed, 287 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/nci/nci_dev.c b/tools/testing/selftests/nci/nci_dev.c
index a68b14642c20..e1bf55dabdf6 100644
--- a/tools/testing/selftests/nci/nci_dev.c
+++ b/tools/testing/selftests/nci/nci_dev.c
@@ -57,6 +57,29 @@ const __u8 nci_init_rsp_v2[] = {0x40, 0x01, 0x1c, 0x00, 0x1a, 0x7e, 0x06,
 const __u8 nci_rf_disc_map_rsp[] = {0x41, 0x00, 0x01, 0x00};
 const __u8 nci_rf_disc_rsp[] = {0x41, 0x03, 0x01, 0x00};
 const __u8 nci_rf_deact_rsp[] = {0x41, 0x06, 0x01, 0x00};
+const __u8 nci_rf_deact_ntf[] = {0x61, 0x06, 0x02, 0x00, 0x00};
+const __u8 nci_rf_activate_ntf[] = {0x61, 0x05, 0x1D, 0x01, 0x02, 0x04, 0x00,
+				     0xFF, 0xFF, 0x0C, 0x44, 0x03, 0x07, 0x04,
+				     0x62, 0x26, 0x11, 0x80, 0x1D, 0x80, 0x01,
+				     0x20, 0x00, 0x00, 0x00, 0x06, 0x05, 0x75,
+				     0x77, 0x81, 0x02, 0x80};
+const __u8 nci_t4t_select_cmd[] = {0x00, 0x00, 0x0C, 0x00, 0xA4, 0x04, 0x00,
+				    0x07, 0xD2, 0x76, 0x00, 0x00, 0x85, 0x01, 0x01};
+const __u8 nci_t4t_select_cmd2[] = {0x00, 0x00, 0x07, 0x00, 0xA4, 0x00, 0x0C, 0x02,
+				     0xE1, 0x03};
+const __u8 nci_t4t_select_cmd3[] = {0x00, 0x00, 0x07, 0x00, 0xA4, 0x00, 0x0C, 0x02,
+				     0xE1, 0x04};
+const __u8 nci_t4t_read_cmd[] = {0x00, 0x00, 0x05, 0x00, 0xB0, 0x00, 0x00, 0x0F};
+const __u8 nci_t4t_read_rsp[] = {0x00, 0x00, 0x11, 0x00, 0x0F, 0x20, 0x00, 0x3B,
+				  0x00, 0x34, 0x04, 0x06, 0xE1, 0x04, 0x08, 0x00,
+				  0x00, 0x00, 0x90, 0x00};
+const __u8 nci_t4t_read_cmd2[] = {0x00, 0x00, 0x05, 0x00, 0xB0, 0x00, 0x00, 0x02};
+const __u8 nci_t4t_read_rsp2[] = {0x00, 0x00, 0x04, 0x00, 0x0F, 0x90, 0x00};
+const __u8 nci_t4t_read_cmd3[] = {0x00, 0x00, 0x05, 0x00, 0xB0, 0x00, 0x02, 0x0F};
+const __u8 nci_t4t_read_rsp3[] = {0x00, 0x00, 0x11, 0xD1, 0x01, 0x0B, 0x54, 0x02,
+				   0x65, 0x6E, 0x4E, 0x46, 0x43, 0x20, 0x54, 0x45,
+				   0x53, 0x54, 0x90, 0x00};
+const __u8 nci_t4t_rsp_ok[] = {0x00, 0x00, 0x02, 0x90, 0x00};
 
 struct msgtemplate {
 	struct nlmsghdr n;
@@ -150,7 +173,7 @@ static int send_get_nfc_family(int sd, __u32 pid)
 				&nla_get_family_len, NLM_F_REQUEST);
 }
 
-static int get_family_id(int sd, __u32 pid)
+static int get_family_id(int sd, __u32 pid, __u32 *event_group)
 {
 	struct {
 		struct nlmsghdr n;
@@ -160,6 +183,7 @@ static int get_family_id(int sd, __u32 pid)
 	struct nlattr *na;
 	int resp_len;
 	__u16 id;
+	int len;
 	int rc;
 
 	rc = send_get_nfc_family(sd, pid);
@@ -173,11 +197,43 @@ static int get_family_id(int sd, __u32 pid)
 	    !NLMSG_OK(&ans.n, resp_len))
 		return 0;
 
+	len = 0;
+	resp_len = GENLMSG_PAYLOAD(&ans.n);
 	na = (struct nlattr *)GENLMSG_DATA(&ans);
-	na = (struct nlattr *)((char *)na + NLA_ALIGN(na->nla_len));
-	if (na->nla_type == CTRL_ATTR_FAMILY_ID)
-		id = *(__u16 *)NLA_DATA(na);
 
+	while (len < resp_len) {
+		len += NLA_ALIGN(na->nla_len);
+		if (na->nla_type == CTRL_ATTR_FAMILY_ID) {
+			id = *(__u16 *)NLA_DATA(na);
+		} else if (na->nla_type == CTRL_ATTR_MCAST_GROUPS) {
+			struct nlattr *nested_na;
+			struct nlattr *group_na;
+			int group_attr_len;
+			int group_attr;
+
+			nested_na = (struct nlattr *)((char *)na + NLA_HDRLEN);
+			group_na = (struct nlattr *)((char *)nested_na + NLA_HDRLEN);
+			group_attr_len = 0;
+
+			for (group_attr = CTRL_ATTR_MCAST_GRP_UNSPEC;
+				group_attr < CTRL_ATTR_MCAST_GRP_MAX; group_attr++) {
+				if (group_na->nla_type == CTRL_ATTR_MCAST_GRP_ID) {
+					*event_group = *(__u32 *)((char *)group_na +
+								  NLA_HDRLEN);
+					break;
+				}
+
+				group_attr_len += NLA_ALIGN(group_na->nla_len) +
+						  NLA_HDRLEN;
+				if (group_attr_len >= nested_na->nla_len)
+					break;
+
+				group_na = (struct nlattr *)((char *)group_na +
+							     NLA_ALIGN(group_na->nla_len));
+			}
+		}
+		na = (struct nlattr *)(GENLMSG_DATA(&ans) + len);
+	}
 	return id;
 }
 
@@ -347,6 +403,7 @@ FIXTURE_SETUP(NCI)
 {
 	struct msgtemplate msg;
 	pthread_t thread_t;
+	__u32 event_group;
 	int status;
 	int rc;
 
@@ -358,12 +415,16 @@ FIXTURE_SETUP(NCI)
 	ASSERT_NE(self->sd, -1);
 
 	self->pid = getpid();
-	self->fid = get_family_id(self->sd, self->pid);
+	self->fid = get_family_id(self->sd, self->pid, &event_group);
 	ASSERT_NE(self->fid, -1);
 
 	self->virtual_nci_fd = open("/dev/virtual_nci", O_RDWR);
 	ASSERT_GT(self->virtual_nci_fd, -1);
 
+	rc = setsockopt(self->sd, SOL_NETLINK, NETLINK_ADD_MEMBERSHIP, &event_group,
+			sizeof(event_group));
+	ASSERT_NE(rc, -1);
+
 	rc = ioctl(self->virtual_nci_fd, IOCTL_GET_NCIDEV_IDX, &self->dev_idex);
 	ASSERT_EQ(rc, 0);
 
@@ -574,6 +635,227 @@ TEST_F(NCI, start_poll)
 	EXPECT_EQ(status, 0);
 }
 
+int get_taginfo(int dev_idx, int sd, int fid, int pid)
+{
+	struct {
+		struct nlmsghdr n;
+		struct genlmsghdr g;
+		char buf[512];
+	} ans;
+
+	struct nlattr *na;
+	__u32 protocol;
+	int targetidx;
+	__u8 sel_res;
+	int resp_len;
+	int len;
+
+	__u16 tagid_type;
+	void *tagid_type_data;
+	int tagid_len;
+
+	tagid_type = NFC_ATTR_DEVICE_INDEX;
+	tagid_type_data = &dev_idx;
+	tagid_len = 4;
+
+	send_cmd_mt_nla(sd, fid, pid, NFC_CMD_GET_TARGET, 1, &tagid_type,
+			&tagid_type_data, &tagid_len, NLM_F_REQUEST | NLM_F_DUMP);
+	resp_len = recv(sd, &ans, sizeof(ans), 0);
+	if (ans.n.nlmsg_type == NLMSG_ERROR || resp_len < 0 ||
+	    !NLMSG_OK(&ans.n, resp_len))
+		return -1;
+
+	resp_len = GENLMSG_PAYLOAD(&ans.n);
+	na = (struct nlattr *)GENLMSG_DATA(&ans);
+
+	len = 0;
+	targetidx = -1;
+	protocol = -1;
+	sel_res = -1;
+
+	while (len < resp_len) {
+		len += NLA_ALIGN(na->nla_len);
+
+		if (na->nla_type == NFC_ATTR_TARGET_INDEX)
+			targetidx = *(int *)((char *)na + NLA_HDRLEN);
+		else if (na->nla_type == NFC_ATTR_TARGET_SEL_RES)
+			sel_res = *(__u8 *)((char *)na + NLA_HDRLEN);
+		else if (na->nla_type == NFC_ATTR_PROTOCOLS)
+			protocol = *(__u32 *)((char *)na + NLA_HDRLEN);
+
+		na = (struct nlattr *)(GENLMSG_DATA(&ans) + len);
+	}
+
+	if (targetidx == -1 || sel_res != 0x20 || protocol != NFC_PROTO_ISO14443_MASK)
+		return -1;
+
+	return targetidx;
+}
+
+int connect_socket(int dev_idx, int target_idx)
+{
+	struct sockaddr_nfc addr;
+	int sock;
+	int err = 0;
+
+	sock = socket(AF_NFC, SOCK_SEQPACKET, NFC_SOCKPROTO_RAW);
+	if (sock == -1)
+		return -1;
+
+	addr.sa_family = AF_NFC;
+	addr.dev_idx = dev_idx;
+	addr.target_idx = target_idx;
+	addr.nfc_protocol = NFC_PROTO_ISO14443;
+
+	err = connect(sock, (struct sockaddr *)&addr, sizeof(addr));
+	if (err) {
+		close(sock);
+		return -1;
+	}
+
+	return sock;
+}
+
+int connect_tag(int dev_idx, int virtual_fd, int sd, int fid, int pid)
+{
+	struct genlmsghdr *genlhdr;
+	struct nlattr *na;
+	char evt_data[255];
+	int target_idx;
+	int resp_len;
+	int evt_dev;
+
+	write(virtual_fd, nci_rf_activate_ntf, sizeof(nci_rf_activate_ntf));
+	resp_len = recv(sd, evt_data, sizeof(evt_data), 0);
+	if (resp_len < 0)
+		return -1;
+
+	genlhdr = (struct genlmsghdr *)((struct nlmsghdr *)evt_data + 1);
+	na = (struct nlattr *)(genlhdr + 1);
+	evt_dev = *(int *)((char *)na + NLA_HDRLEN);
+	if (dev_idx != evt_dev)
+		return -1;
+
+	target_idx = get_taginfo(dev_idx, sd, fid, pid);
+	if (target_idx == -1)
+		return -1;
+	return connect_socket(dev_idx, target_idx);
+}
+
+int read_write_nci_cmd(int nfc_sock, int virtual_fd, const __u8 *cmd, __u32 cmd_len,
+		       const __u8 *rsp, __u32 rsp_len)
+{
+	char buf[256];
+	unsigned int len;
+
+	send(nfc_sock, &cmd[3], cmd_len - 3, 0);
+	len = read(virtual_fd, buf, cmd_len);
+	if (len < 0 || memcmp(buf, cmd, cmd_len))
+		return -1;
+
+	write(virtual_fd, rsp, rsp_len);
+	len = recv(nfc_sock, buf, rsp_len - 2, 0);
+	if (len < 0 || memcmp(&buf[1], &rsp[3], rsp_len - 3))
+		return -1;
+
+	return 0;
+}
+
+int read_tag(int nfc_sock, int virtual_fd)
+{
+	if (read_write_nci_cmd(nfc_sock, virtual_fd, nci_t4t_select_cmd,
+			       sizeof(nci_t4t_select_cmd), nci_t4t_rsp_ok,
+			       sizeof(nci_t4t_rsp_ok)))
+		return -1;
+
+	if (read_write_nci_cmd(nfc_sock, virtual_fd, nci_t4t_select_cmd2,
+			       sizeof(nci_t4t_select_cmd2), nci_t4t_rsp_ok,
+			       sizeof(nci_t4t_rsp_ok)))
+		return -1;
+
+	if (read_write_nci_cmd(nfc_sock, virtual_fd, nci_t4t_read_cmd,
+			       sizeof(nci_t4t_read_cmd), nci_t4t_read_rsp,
+			       sizeof(nci_t4t_read_rsp)))
+		return -1;
+
+	if (read_write_nci_cmd(nfc_sock, virtual_fd, nci_t4t_select_cmd3,
+			       sizeof(nci_t4t_select_cmd3), nci_t4t_rsp_ok,
+			       sizeof(nci_t4t_rsp_ok)))
+		return -1;
+
+	if (read_write_nci_cmd(nfc_sock, virtual_fd, nci_t4t_read_cmd2,
+			       sizeof(nci_t4t_read_cmd2), nci_t4t_read_rsp2,
+			       sizeof(nci_t4t_read_rsp2)))
+		return -1;
+
+	return read_write_nci_cmd(nfc_sock, virtual_fd, nci_t4t_read_cmd3,
+				  sizeof(nci_t4t_read_cmd3), nci_t4t_read_rsp3,
+				  sizeof(nci_t4t_read_rsp3));
+}
+
+static void *virtual_deactivate_proc(void *data)
+{
+	int virtual_fd;
+	char buf[256];
+	int deactcmd_len;
+	int len;
+
+	virtual_fd = *(int *)data;
+	deactcmd_len = sizeof(nci_rf_deact_cmd);
+	len = read(virtual_fd, buf, deactcmd_len);
+	if (len != deactcmd_len || memcmp(buf, nci_rf_deact_cmd, deactcmd_len))
+		return (void *)-1;
+
+	write(virtual_fd, nci_rf_deact_rsp, sizeof(nci_rf_deact_rsp));
+	write(virtual_fd, nci_rf_deact_ntf, sizeof(nci_rf_deact_ntf));
+
+	return (void *)0;
+}
+
+int disconnect_tag(int nfc_sock, int virtual_fd)
+{
+	pthread_t thread_t;
+	char buf[256];
+	int status;
+	int len;
+
+	send(nfc_sock, &nci_t4t_select_cmd3[3], sizeof(nci_t4t_select_cmd3) - 3, 0);
+	len = read(virtual_fd, buf, sizeof(nci_t4t_select_cmd3));
+	if (len < 0 || memcmp(buf, nci_t4t_select_cmd3, sizeof(nci_t4t_select_cmd3)))
+		return -1;
+
+	len = recv(nfc_sock, buf, sizeof(nci_t4t_rsp_ok), 0);
+	if (len != -1)
+		return -1;
+
+	status = pthread_create(&thread_t, NULL, virtual_deactivate_proc,
+				(void *)&virtual_fd);
+
+	close(nfc_sock);
+	pthread_join(thread_t, (void **)&status);
+	return status;
+}
+
+TEST_F(NCI, t4t_tag_read)
+{
+	int nfc_sock;
+	int status;
+
+	status = start_polling(self->dev_idex, self->proto, self->virtual_nci_fd,
+			       self->sd, self->fid, self->pid);
+	EXPECT_EQ(status, 0);
+
+	nfc_sock = connect_tag(self->dev_idex, self->virtual_nci_fd, self->sd,
+			       self->fid, self->pid);
+	ASSERT_GT(nfc_sock, -1);
+
+	status = read_tag(nfc_sock, self->virtual_nci_fd);
+	ASSERT_EQ(status, 0);
+
+	status = disconnect_tag(nfc_sock, self->virtual_nci_fd);
+	EXPECT_EQ(status, 0);
+}
+
 TEST_F(NCI, deinit)
 {
 	struct msgtemplate msg;
-- 
2.32.0

