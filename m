Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C198B3EED75
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 15:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240176AbhHQN35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 09:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240022AbhHQN3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 09:29:25 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 355F7C061764;
        Tue, 17 Aug 2021 06:28:52 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id n13-20020a17090a4e0d00b0017946980d8dso5130556pjh.5;
        Tue, 17 Aug 2021 06:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WZI4oJnKj5qvjjBmjelGVqMD99NjqyWcYOyrmYvbCn0=;
        b=SkOmSmFgTNdohK/Z3uE76cxQ2/8GzO5KOapBc29FVK6JcjtoLpeHmErkQ7cG3FH2oM
         +U1nY+DcMYWbpwJZwRQg3IM+BRxBUe1Zkl8Rr1vqBaFUzz7D/C2WM/C2c+VZOcrCgOCy
         W867GXKCaOWHJMwM+qeG8rMwJ/5c5JHfvPk+hQ3YEDoJHcm35XYZlLfZVU4diA+IdMUd
         2ti+RMl/7fGQIj1hRm+iXGhF5mAKhZT/FR8G7Qsk2JP3CsJhJ5HODBhUOKl6q247PhU0
         i6AXWQ6Tcf/DYl9vyM0n8Lp84m2Ohm/JySnXqlSACXKMe71NkhPt9qTbbtAiopZoqtqx
         GagQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WZI4oJnKj5qvjjBmjelGVqMD99NjqyWcYOyrmYvbCn0=;
        b=n8hq1nE0mhQYt7riF0d4u9qxnh4d8Y3bn1vDfPbBaDtVuRp2Kw6nV3FcoLTc1mh4p7
         SFzYZ10hr9Wj02aKMG1lsX8SIS3eAYiLxZ66Xv34xYEbDMyRsnIlCGPYxWUM9qWq7oVJ
         N0okpiDGXJ0gamaJsZvdC8hJGBcdSzgAXJ2PEI/RQjbfhJ0pY8NgUPdSy9APOQU2Q+hD
         24Emj9URKgDOKRCn6UD3PivnKmktMxfSJX+wmxBQrVxgCNfhsLqx1X53eDtGX2MgnX9z
         ZDsBhZ/g+Sfu6g45S1R7o0Xu5re21TOSPB09XR9i55Y4PVlmgbUN8htwDSATQ9/sIOfY
         InIA==
X-Gm-Message-State: AOAM5318XH3VvUUJM6411tv10I30TC77qdcqxX/QeIIaRr73SEsxIvOz
        NyTqINljQuOr6ygijo7DNqg=
X-Google-Smtp-Source: ABdhPJxF8f/JsOvBsGtpYIepsMpvExDz1ljnvHLqlSvqqb7eGGVgtwtRV09BWibrazIj9KWe3mVj/Q==
X-Received: by 2002:aa7:900e:0:b0:3e1:3dfe:bb2b with SMTP id m14-20020aa7900e000000b003e13dfebb2bmr3685459pfo.81.1629206931825;
        Tue, 17 Aug 2021 06:28:51 -0700 (PDT)
Received: from ubuntu.localdomain ([182.226.226.37])
        by smtp.gmail.com with ESMTPSA id j6sm2791577pfi.220.2021.08.17.06.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 06:28:51 -0700 (PDT)
From:   bongsu.jeon2@gmail.com
To:     shuah@kernel.org, krzysztof.kozlowski@canonical.com
Cc:     netdev@vger.kernel.org, linux-nfc@lists.01.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH v2 net-next 6/8] selftests: nci: Add the flags parameter for the send_cmd_mt_nla
Date:   Tue, 17 Aug 2021 06:28:16 -0700
Message-Id: <20210817132818.8275-7-bongsu.jeon2@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210817132818.8275-1-bongsu.jeon2@gmail.com>
References: <20210817132818.8275-1-bongsu.jeon2@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

To reuse the send_cmd_mt_nla for NLM_F_REQUEST and NLM_F_DUMP flag,
add the flags parameter to the function.

Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
---
 tools/testing/selftests/nci/nci_dev.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/nci/nci_dev.c b/tools/testing/selftests/nci/nci_dev.c
index a1786cef73bc..2b90379523c6 100644
--- a/tools/testing/selftests/nci/nci_dev.c
+++ b/tools/testing/selftests/nci/nci_dev.c
@@ -87,7 +87,7 @@ static int create_nl_socket(void)
 
 static int send_cmd_mt_nla(int sd, __u16 nlmsg_type, __u32 nlmsg_pid,
 			   __u8 genl_cmd, int nla_num, __u16 nla_type[],
-			   void *nla_data[], int nla_len[])
+			   void *nla_data[], int nla_len[], __u16 flags)
 {
 	struct sockaddr_nl nladdr;
 	struct msgtemplate msg;
@@ -98,7 +98,7 @@ static int send_cmd_mt_nla(int sd, __u16 nlmsg_type, __u32 nlmsg_pid,
 
 	msg.n.nlmsg_len = NLMSG_LENGTH(GENL_HDRLEN);
 	msg.n.nlmsg_type = nlmsg_type;
-	msg.n.nlmsg_flags = NLM_F_REQUEST;
+	msg.n.nlmsg_flags = flags;
 	msg.n.nlmsg_seq = 0;
 	msg.n.nlmsg_pid = nlmsg_pid;
 	msg.g.cmd = genl_cmd;
@@ -146,8 +146,8 @@ static int send_get_nfc_family(int sd, __u32 pid)
 	nla_get_family_data = family_name;
 
 	return send_cmd_mt_nla(sd, GENL_ID_CTRL, pid, CTRL_CMD_GETFAMILY,
-				1, &nla_get_family_type,
-				&nla_get_family_data, &nla_get_family_len);
+				1, &nla_get_family_type, &nla_get_family_data,
+				&nla_get_family_len, NLM_F_REQUEST);
 }
 
 static int get_family_id(int sd, __u32 pid)
@@ -189,7 +189,7 @@ static int send_cmd_with_idx(int sd, __u16 nlmsg_type, __u32 nlmsg_pid,
 	int nla_len = 4;
 
 	return send_cmd_mt_nla(sd, nlmsg_type, nlmsg_pid, genl_cmd, 1,
-				&nla_type, &nla_data, &nla_len);
+				&nla_type, &nla_data, &nla_len, NLM_F_REQUEST);
 }
 
 static int get_nci_devid(int sd, __u16 fid, __u32 pid, int dev_id, struct msgtemplate *msg)
@@ -531,9 +531,9 @@ TEST_F(NCI, start_poll)
 			    (void *)&self->virtual_nci_fd);
 	ASSERT_GT(rc, -1);
 
-	rc = send_cmd_mt_nla(self->sd, self->fid, self->pid,
-			     NFC_CMD_START_POLL, 2, nla_start_poll_type,
-			     nla_start_poll_data, nla_start_poll_len);
+	rc = send_cmd_mt_nla(self->sd, self->fid, self->pid, NFC_CMD_START_POLL, 2,
+			     nla_start_poll_type, nla_start_poll_data,
+			     nla_start_poll_len, NLM_F_REQUEST);
 	EXPECT_EQ(rc, 0);
 
 	pthread_join(thread_t, (void **)&status);
-- 
2.32.0

