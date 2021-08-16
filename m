Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A52103ECD76
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 06:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232963AbhHPEHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 00:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232954AbhHPEHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 00:07:02 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1BDCC061292;
        Sun, 15 Aug 2021 21:06:27 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id e19so19329215pla.10;
        Sun, 15 Aug 2021 21:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lOR8sBZOkd5wRqTkOV6C1roq95z+/PAnDP7aJM79Ob4=;
        b=K9nA8q+MaK2V48En6cjEzIfGieN3B0JxZuHA5sxapNeEroQtiV/JfL0MMqmts5FXgZ
         aP5uJh533RnyfYSz1CjBiTfVbKqBL2dywH+T1XkQj7OR+we5cwq5yO1cyVS+CHpwHsQz
         if0U18K5eF1biWJSRANLbz2VxuTuWZ4taIIIQSC4wtMM5HM5DpNZHG/FdId08XPFkZOe
         HlG91gGR+8yImXx/QI7zp9u6yD3t+kBojSLy6EAcEoQbP2vSzRuDKhqNiYYBkCl07N3x
         g3fFy7MIyhOamKstIVZEGsS7EAZcY4QuU91HKQRs43N+y9Hzo37e1x3I8EOLo/HqcLr5
         j70w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lOR8sBZOkd5wRqTkOV6C1roq95z+/PAnDP7aJM79Ob4=;
        b=GCjP+Z57zfbd/A5YJYRtdIMz3BmLIeLJKHRQlMD0ANmZLkc/JTBkXeiKCiaz3S99GV
         GtoxiC6KCmmVxh76zMEDwcFIjeZlOzZ79XyPTpX2XO8YM9wRsmyDii/0eEPP0kinWytC
         xEvPBUEGwATcm7LfIimv3ljPhN2Cf2yiNEeBP/agT6qfSB25A8OuC6vbDNGWJjBInhpt
         2rIEJdHWp2ZUUFpkASWIjF5EsUcVIH2K3RnI2W045RYOa38Lp3uslATMEM5NChZW9306
         P6zA/Hema6f950m+JNYC9GSFBkDaEFE/1Rsnrpe3ehLbqRnkyulBPTa20QPQOLZCeGwg
         rxpA==
X-Gm-Message-State: AOAM531ha7T0hFd2p9CXAU+WL+yAFA/GtQNFaLzGTnSkMZwHPX1I4TOE
        +3jZUb+s7Karcn3mtgIjj08=
X-Google-Smtp-Source: ABdhPJz1zvl2Hb8h2Ls785hGdhzedxS49tGefVnQiHOEeUP/MGOKUoc/J8EtIdUDJlOXwDZT1+wsng==
X-Received: by 2002:a17:902:768b:b029:12d:306e:9f68 with SMTP id m11-20020a170902768bb029012d306e9f68mr11771874pll.13.1629086787365;
        Sun, 15 Aug 2021 21:06:27 -0700 (PDT)
Received: from ubuntu.localdomain ([182.226.226.37])
        by smtp.gmail.com with ESMTPSA id i6sm9436998pfa.44.2021.08.15.21.06.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Aug 2021 21:06:26 -0700 (PDT)
From:   bongsu.jeon2@gmail.com
To:     shuah@kernel.org, krzysztof.kozlowski@canonical.com
Cc:     netdev@vger.kernel.org, linux-nfc@lists.01.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH net-next 3/3] selftests: Add the NCI testcase reading T4T Tag
Date:   Sun, 15 Aug 2021 21:06:00 -0700
Message-Id: <20210816040600.175813-4-bongsu.jeon2@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816040600.175813-1-bongsu.jeon2@gmail.com>
References: <20210816040600.175813-1-bongsu.jeon2@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

Add the NCI testcase reading T4T Tag that has NFC TEST plain text.
the virtual device application acts as T4T Tag in this testcase.

Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
---
 tools/testing/selftests/nci/nci_dev.c | 384 +++++++++++++++++++++++---
 1 file changed, 345 insertions(+), 39 deletions(-)

diff --git a/tools/testing/selftests/nci/nci_dev.c b/tools/testing/selftests/nci/nci_dev.c
index 34e76c7fa1fe..65d887dc5ccc 100644
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
@@ -87,7 +110,7 @@ static int create_nl_socket(void)
 
 static int send_cmd_mt_nla(int sd, __u16 nlmsg_type, __u32 nlmsg_pid,
 			   __u8 genl_cmd, int nla_num, __u16 nla_type[],
-			   void *nla_data[], int nla_len[])
+			   void *nla_data[], int nla_len[], __u16 flags)
 {
 	struct sockaddr_nl nladdr;
 	struct msgtemplate msg;
@@ -98,7 +121,7 @@ static int send_cmd_mt_nla(int sd, __u16 nlmsg_type, __u32 nlmsg_pid,
 
 	msg.n.nlmsg_len = NLMSG_LENGTH(GENL_HDRLEN);
 	msg.n.nlmsg_type = nlmsg_type;
-	msg.n.nlmsg_flags = NLM_F_REQUEST;
+	msg.n.nlmsg_flags = flags;
 	msg.n.nlmsg_seq = 0;
 	msg.n.nlmsg_pid = nlmsg_pid;
 	msg.g.cmd = genl_cmd;
@@ -108,12 +131,12 @@ static int send_cmd_mt_nla(int sd, __u16 nlmsg_type, __u32 nlmsg_pid,
 	for (cnt = 0; cnt < nla_num; cnt++) {
 		na = (struct nlattr *)(GENLMSG_DATA(&msg) + prv_len);
 		na->nla_type = nla_type[cnt];
-		na->nla_len = nla_len[cnt] + NLA_HDRLEN;
+		na->nla_len = NLMSG_ALIGN(nla_len[cnt] + NLA_HDRLEN);
 
 		if (nla_len > 0)
 			memcpy(NLA_DATA(na), nla_data[cnt], nla_len[cnt]);
 
-		msg.n.nlmsg_len += NLMSG_ALIGN(na->nla_len);
+		msg.n.nlmsg_len += na->nla_len;
 		prv_len = na->nla_len;
 	}
 
@@ -146,11 +169,11 @@ static int send_get_nfc_family(int sd, __u32 pid)
 	nla_get_family_data = family_name;
 
 	return send_cmd_mt_nla(sd, GENL_ID_CTRL, pid, CTRL_CMD_GETFAMILY,
-				1, &nla_get_family_type,
-				&nla_get_family_data, &nla_get_family_len);
+				1, &nla_get_family_type, &nla_get_family_data,
+				&nla_get_family_len, NLM_F_REQUEST);
 }
 
-static int get_family_id(int sd, __u32 pid)
+static int get_family_id(int sd, __u32 pid, __u32 *event_group)
 {
 	struct {
 		struct nlmsghdr n;
@@ -158,8 +181,9 @@ static int get_family_id(int sd, __u32 pid)
 		char buf[512];
 	} ans;
 	struct nlattr *na;
-	int rep_len;
+	int resp_len;
 	__u16 id;
+	int len;
 	int rc;
 
 	rc = send_get_nfc_family(sd, pid);
@@ -167,17 +191,49 @@ static int get_family_id(int sd, __u32 pid)
 	if (rc < 0)
 		return 0;
 
-	rep_len = recv(sd, &ans, sizeof(ans), 0);
+	resp_len = recv(sd, &ans, sizeof(ans), 0);
 
-	if (ans.n.nlmsg_type == NLMSG_ERROR || rep_len < 0 ||
-	    !NLMSG_OK(&ans.n, rep_len))
+	if (ans.n.nlmsg_type == NLMSG_ERROR || resp_len < 0 ||
+	    !NLMSG_OK(&ans.n, resp_len))
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
 
@@ -189,12 +245,13 @@ static int send_cmd_with_idx(int sd, __u16 nlmsg_type, __u32 nlmsg_pid,
 	int nla_len = 4;
 
 	return send_cmd_mt_nla(sd, nlmsg_type, nlmsg_pid, genl_cmd, 1,
-				&nla_type, &nla_data, &nla_len);
+				&nla_type, &nla_data, &nla_len, NLM_F_REQUEST);
 }
 
-static int get_nci_devid(int sd, __u16 fid, __u32 pid, int dev_id, struct msgtemplate *msg)
+static int get_nci_devid(int sd, __u16 fid, __u32 pid, int dev_id,
+			 struct msgtemplate *msg)
 {
-	int rc, rep_len;
+	int rc, resp_len;
 
 	rc = send_cmd_with_idx(sd, fid, pid, NFC_CMD_GET_DEVICE, dev_id);
 	if (rc < 0) {
@@ -202,14 +259,14 @@ static int get_nci_devid(int sd, __u16 fid, __u32 pid, int dev_id, struct msgtem
 		goto error;
 	}
 
-	rep_len = recv(sd, msg, sizeof(*msg), 0);
-	if (rep_len < 0) {
+	resp_len = recv(sd, msg, sizeof(*msg), 0);
+	if (resp_len < 0) {
 		rc = -2;
 		goto error;
 	}
 
 	if (msg->n.nlmsg_type == NLMSG_ERROR ||
-	    !NLMSG_OK(&msg->n, rep_len)) {
+	    !NLMSG_OK(&msg->n, resp_len)) {
 		rc = -3;
 		goto error;
 	}
@@ -222,21 +279,21 @@ static int get_nci_devid(int sd, __u16 fid, __u32 pid, int dev_id, struct msgtem
 static __u8 get_dev_enable_state(struct msgtemplate *msg)
 {
 	struct nlattr *na;
-	int rep_len;
+	int resp_len;
 	int len;
 
-	rep_len = GENLMSG_PAYLOAD(&msg->n);
+	resp_len = GENLMSG_PAYLOAD(&msg->n);
 	na = (struct nlattr *)GENLMSG_DATA(msg);
 	len = 0;
 
-	while (len < rep_len) {
+	while (len < resp_len) {
 		len += NLA_ALIGN(na->nla_len);
 		if (na->nla_type == NFC_ATTR_DEVICE_POWERED)
 			return *(char *)NLA_DATA(na);
 		na = (struct nlattr *)(GENLMSG_DATA(msg) + len);
 	}
 
-	return rep_len;
+	return resp_len;
 }
 
 FIXTURE(NCI) {
@@ -347,6 +404,7 @@ FIXTURE_SETUP(NCI)
 {
 	struct msgtemplate msg;
 	pthread_t thread_t;
+	__u32 event_group;
 	int status;
 	int rc;
 
@@ -358,12 +416,16 @@ FIXTURE_SETUP(NCI)
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
 
@@ -517,38 +579,282 @@ static void *virtual_poll_stop(void *data)
 	return (void *)-1;
 }
 
-TEST_F(NCI, start_poll)
+int start_polling(int dev_idx, int proto, int virtual_fd, int sd, int fid, int pid)
 {
 	__u16 nla_start_poll_type[2] = {NFC_ATTR_DEVICE_INDEX,
 					 NFC_ATTR_PROTOCOLS};
-	void *nla_start_poll_data[2] = {&self->dev_idex, &self->proto};
+	void *nla_start_poll_data[2] = {&dev_idx, &proto};
 	int nla_start_poll_len[2] = {4, 4};
 	pthread_t thread_t;
 	int status;
 	int rc;
 
 	rc = pthread_create(&thread_t, NULL, virtual_poll_start,
-			    (void *)&self->virtual_nci_fd);
-	ASSERT_GT(rc, -1);
+			    (void *)&virtual_fd);
+	if (rc < 0)
+		return rc;
 
-	rc = send_cmd_mt_nla(self->sd, self->fid, self->pid,
-			     NFC_CMD_START_POLL, 2, nla_start_poll_type,
-			     nla_start_poll_data, nla_start_poll_len);
-	EXPECT_EQ(rc, 0);
+	rc = send_cmd_mt_nla(sd, fid, pid, NFC_CMD_START_POLL, 2, nla_start_poll_type,
+			     nla_start_poll_data, nla_start_poll_len, NLM_F_REQUEST);
+	if (rc != 0)
+		return rc;
 
 	pthread_join(thread_t, (void **)&status);
-	ASSERT_EQ(status, 0);
+	return status;
+}
+
+int stop_polling(int dev_idx, int virtual_fd, int sd, int fid, int pid)
+{
+	pthread_t thread_t;
+	int status;
+	int rc;
 
 	rc = pthread_create(&thread_t, NULL, virtual_poll_stop,
-			    (void *)&self->virtual_nci_fd);
-	ASSERT_GT(rc, -1);
+			    (void *)&virtual_fd);
+	if (rc < 0)
+		return rc;
 
-	rc = send_cmd_with_idx(self->sd, self->fid, self->pid,
-			       NFC_CMD_STOP_POLL, self->dev_idex);
-	EXPECT_EQ(rc, 0);
+	rc = send_cmd_with_idx(sd, fid, pid,
+			       NFC_CMD_STOP_POLL, dev_idx);
+	if (rc != 0)
+		return rc;
 
 	pthread_join(thread_t, (void **)&status);
+	return status;
+}
+
+TEST_F(NCI, start_poll)
+{
+	int status;
+
+	status = start_polling(self->dev_idex, self->proto, self->virtual_nci_fd,
+			       self->sd, self->fid, self->pid);
+	EXPECT_EQ(status, 0);
+
+	status = stop_polling(self->dev_idex, self->virtual_nci_fd, self->sd,
+			      self->fid, self->pid);
+	EXPECT_EQ(status, 0);
+}
+
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
 	ASSERT_EQ(status, 0);
+
+	status = disconnect_tag(nfc_sock, self->virtual_nci_fd);
+	EXPECT_EQ(status, 0);
 }
 
 TEST_F(NCI, deinit)
-- 
2.32.0

