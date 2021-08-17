Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 409043EED79
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 15:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239996AbhHQNaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 09:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240054AbhHQN32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 09:29:28 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85CA5C061764;
        Tue, 17 Aug 2021 06:28:55 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id 28-20020a17090a031cb0290178dcd8a4d1so2970554pje.0;
        Tue, 17 Aug 2021 06:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/ZplN+DQNjy/fGTSwhmHuEQ65uOe/NIplIHGWhiFszo=;
        b=WvAyxJYInJUFXJ4QJrYKlFxGPar8wHEk8GoKa4cC8pk2RwtyHr3CGvO6XZxVmGoATF
         HYRGTWOGBKO13ow5rCLeVZ0koRfaofZd7zL52nSKpjkTW+IohzOGz4rK8Ve+XcYnAuKj
         kkNc0LARPhlFloFzpTqHCyuYaAbr5pyEYv498KwHzj0HWix6zkI0pjyIASxWx+V/L2SI
         co7rqsKc/mA9uqikoyzo9aTipBKpbamxJLDKkFFLaS+VPi5seMCcQoA2pwuKu/wzqipR
         QVp4N6/eEiIU3PqtKEUoQiBSyDfsQl2Ml4Bm/ELhkgKq8Nrt0AOj4PYPxAB19ua1OVN5
         W9IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/ZplN+DQNjy/fGTSwhmHuEQ65uOe/NIplIHGWhiFszo=;
        b=O5FfG2uY6Ymxq0rdesF4p8r8T//6pSQ+oMZ/C/99YpamQiP43uSgUTrwVaZfidyiFn
         hda20A7O/7RgO+MFo+Kj7XVF9p/VZoTQWKJoWTg0gFEoO2IYf2nDwJ6N2k0fU360HAiW
         u/EhhWYcDDu7GCzM2FP64fYLfM3CuAO7/RS9UEHipiXXMiGgqQXpO7aTu/4+mJyZ5Eh3
         HbQkEy3JvD/GIjS6Zn9fMf0ifUbMHnhhIUWTGZpMbGxrGmEnmvmwrUk73tz2z+iZtAW1
         +d7CjNQAyEbxZgzK77h2jbKYE4Xukb6OBNlA0TSKUE9XdXM6k/ktNQ35YX2KPW5vfLI9
         S+og==
X-Gm-Message-State: AOAM533awtyL1tZamX4CpPM9UUs+yusAuQFSt7qMLytHVx/kmA+Ic6jG
        IvOpWkWfmU9CbsjkpjsMC9xIh29xNjZw+g==
X-Google-Smtp-Source: ABdhPJwjs6ll+Fse/MhmD4u8giVOEOqjIV0lDGexqfHdKcTxeObEO4Vp83hluXRKeOsA9tfVz2S6pw==
X-Received: by 2002:a17:903:234e:b0:12d:ad8d:56c6 with SMTP id c14-20020a170903234e00b0012dad8d56c6mr2762205plh.23.1629206934900;
        Tue, 17 Aug 2021 06:28:54 -0700 (PDT)
Received: from ubuntu.localdomain ([182.226.226.37])
        by smtp.gmail.com with ESMTPSA id j6sm2791577pfi.220.2021.08.17.06.28.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 06:28:54 -0700 (PDT)
From:   bongsu.jeon2@gmail.com
To:     shuah@kernel.org, krzysztof.kozlowski@canonical.com
Cc:     netdev@vger.kernel.org, linux-nfc@lists.01.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH v2 net-next 7/8] selftests: nci: Extract the start/stop discovery function
Date:   Tue, 17 Aug 2021 06:28:17 -0700
Message-Id: <20210817132818.8275-8-bongsu.jeon2@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210817132818.8275-1-bongsu.jeon2@gmail.com>
References: <20210817132818.8275-1-bongsu.jeon2@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

To reuse the start/stop discovery code in other testcase, extract the code.

Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
---
 tools/testing/selftests/nci/nci_dev.c | 53 +++++++++++++++++++--------
 1 file changed, 38 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/nci/nci_dev.c b/tools/testing/selftests/nci/nci_dev.c
index 2b90379523c6..a68b14642c20 100644
--- a/tools/testing/selftests/nci/nci_dev.c
+++ b/tools/testing/selftests/nci/nci_dev.c
@@ -517,38 +517,61 @@ static void *virtual_poll_stop(void *data)
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
 
-	rc = send_cmd_mt_nla(self->sd, self->fid, self->pid, NFC_CMD_START_POLL, 2,
-			     nla_start_poll_type, nla_start_poll_data,
-			     nla_start_poll_len, NLM_F_REQUEST);
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
-	ASSERT_EQ(status, 0);
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
 }
 
 TEST_F(NCI, deinit)
-- 
2.32.0

