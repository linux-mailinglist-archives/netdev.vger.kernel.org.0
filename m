Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ACBF3EED6C
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 15:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239945AbhHQN3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 09:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239919AbhHQN3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 09:29:13 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 434CEC0613C1;
        Tue, 17 Aug 2021 06:28:40 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id j1so32031361pjv.3;
        Tue, 17 Aug 2021 06:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jhNRygkZSnokXeb7qSRMRLwwZtJvbBcUNqtBdqOfilA=;
        b=dv469uMiCBKv8f19tkJvZluYNjYUk2n9vFUAj6y2pWd+gifcKmLdQVCpGqrUqd+9Az
         MUd8yVHC8sLMtImIi6T2C6QD6bl8iqudIo9AF37+azbdwKPRvTtHocfwAEDi6+1/4Qe3
         ElyU8efNwS/D6AEWk78gj8r9CMoGnebgsyTwvl7ySzLAD+z90im2jJkfPCf7SPYMQ+jO
         GmtO9NoJJs3oPwIVqX0x+QTNIFWTVc18bVd0E2emt86tdLCjBeQdBY3ZUkaOSKFnvqyH
         60mvx7s04i4ezrTge1TL5asNWcku7KSaWcVlCANbWX5vsXY+XzQk1lYEr1R+EmjEQnuC
         Shxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jhNRygkZSnokXeb7qSRMRLwwZtJvbBcUNqtBdqOfilA=;
        b=TNTUkHHbluIr3mhFrhIml6uBZDrlsm7kSsgeXxQzk8g3VNa0ciO3xearvobqf3+X7C
         mqSGmDj6J/xrzZrXQ7cN1+6zMJ3FRBKjzCmqTSQIGaMMXgT89CbET1UpHo4aedlMGcTb
         pgWy1s1UP9IagvstppEEOrZ8FoNgjJsVX4WfI7hz9ijiB99q7FJEtstDGMyj1Xp1maQj
         ab2fVtSMB8u9NdQh2Zv3kdYrFemuKI5DiFPQcYoOqv+FWF5zQM85LAW/664mVrvrAr9R
         n4EyKcezGHepZAhtOehAeBdNLSSiVgdatRcSPgqtbLBzeJAgOKx6q7eWvENrToA5itXK
         S+fQ==
X-Gm-Message-State: AOAM533vMKp+8Bu8B3JATY0VNOpMJnVheDAtisiNDxzux9CigVT3RN1a
        +mfGkITNeCqYdZA6dNqCwWsn0YJ9vOkQZA==
X-Google-Smtp-Source: ABdhPJynolp6WuR07au470zbOmTWsxfP30A7i9LThiPgdlDcRR/804ebG1pO2he5RgjfKJPY7G9XXQ==
X-Received: by 2002:a17:902:ec06:b0:12d:8605:731d with SMTP id l6-20020a170902ec0600b0012d8605731dmr2797843pld.78.1629206919768;
        Tue, 17 Aug 2021 06:28:39 -0700 (PDT)
Received: from ubuntu.localdomain ([182.226.226.37])
        by smtp.gmail.com with ESMTPSA id j6sm2791577pfi.220.2021.08.17.06.28.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 06:28:39 -0700 (PDT)
From:   bongsu.jeon2@gmail.com
To:     shuah@kernel.org, krzysztof.kozlowski@canonical.com
Cc:     netdev@vger.kernel.org, linux-nfc@lists.01.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH v2 net-next 2/8] selftests: nci: Remove the polling code to read a NCI frame
Date:   Tue, 17 Aug 2021 06:28:12 -0700
Message-Id: <20210817132818.8275-3-bongsu.jeon2@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210817132818.8275-1-bongsu.jeon2@gmail.com>
References: <20210817132818.8275-1-bongsu.jeon2@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

Because the virtual NCI device uses Wait Queue, the virtual device
application doesn't need to poll the NCI frame.

Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 tools/testing/selftests/nci/nci_dev.c | 33 +++++++++------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/nci/nci_dev.c b/tools/testing/selftests/nci/nci_dev.c
index 57b505cb1561..34e76c7fa1fe 100644
--- a/tools/testing/selftests/nci/nci_dev.c
+++ b/tools/testing/selftests/nci/nci_dev.c
@@ -270,8 +270,7 @@ static void *virtual_dev_open(void *data)
 
 	dev_fd = *(int *)data;
 
-	while ((len = read(dev_fd, buf, 258)) == 0)
-		;
+	len = read(dev_fd, buf, 258);
 	if (len <= 0)
 		goto error;
 	if (len != sizeof(nci_reset_cmd))
@@ -280,8 +279,7 @@ static void *virtual_dev_open(void *data)
 		goto error;
 	write(dev_fd, nci_reset_rsp, sizeof(nci_reset_rsp));
 
-	while ((len = read(dev_fd, buf, 258)) == 0)
-		;
+	len = read(dev_fd, buf, 258);
 	if (len <= 0)
 		goto error;
 	if (len != sizeof(nci_init_cmd))
@@ -290,8 +288,7 @@ static void *virtual_dev_open(void *data)
 		goto error;
 	write(dev_fd, nci_init_rsp, sizeof(nci_init_rsp));
 
-	while ((len = read(dev_fd, buf, 258)) == 0)
-		;
+	len = read(dev_fd, buf, 258);
 	if (len <= 0)
 		goto error;
 	if (len != sizeof(nci_rf_disc_map_cmd))
@@ -313,8 +310,7 @@ static void *virtual_dev_open_v2(void *data)
 
 	dev_fd = *(int *)data;
 
-	while ((len = read(dev_fd, buf, 258)) == 0)
-		;
+	len = read(dev_fd, buf, 258);
 	if (len <= 0)
 		goto error;
 	if (len != sizeof(nci_reset_cmd))
@@ -324,8 +320,7 @@ static void *virtual_dev_open_v2(void *data)
 	write(dev_fd, nci_reset_rsp_v2, sizeof(nci_reset_rsp_v2));
 	write(dev_fd, nci_reset_ntf, sizeof(nci_reset_ntf));
 
-	while ((len = read(dev_fd, buf, 258)) == 0)
-		;
+	len = read(dev_fd, buf, 258);
 	if (len <= 0)
 		goto error;
 	if (len != sizeof(nci_init_cmd_v2))
@@ -334,8 +329,7 @@ static void *virtual_dev_open_v2(void *data)
 		goto error;
 	write(dev_fd, nci_init_rsp_v2, sizeof(nci_init_rsp_v2));
 
-	while ((len = read(dev_fd, buf, 258)) == 0)
-		;
+	len = read(dev_fd, buf, 258);
 	if (len <= 0)
 		goto error;
 	if (len != sizeof(nci_rf_disc_map_cmd))
@@ -402,8 +396,7 @@ static void *virtual_deinit(void *data)
 
 	dev_fd = *(int *)data;
 
-	while ((len = read(dev_fd, buf, 258)) == 0)
-		;
+	len = read(dev_fd, buf, 258);
 	if (len <= 0)
 		goto error;
 	if (len != sizeof(nci_reset_cmd))
@@ -425,8 +418,7 @@ static void *virtual_deinit_v2(void *data)
 
 	dev_fd = *(int *)data;
 
-	while ((len = read(dev_fd, buf, 258)) == 0)
-		;
+	len = read(dev_fd, buf, 258);
 	if (len <= 0)
 		goto error;
 	if (len != sizeof(nci_reset_cmd))
@@ -489,16 +481,14 @@ static void *virtual_poll_start(void *data)
 
 	dev_fd = *(int *)data;
 
-	while ((len = read(dev_fd, buf, 258)) == 0)
-		;
+	len = read(dev_fd, buf, 258);
 	if (len <= 0)
 		goto error;
 	if (len != sizeof(nci_rf_discovery_cmd))
 		goto error;
 	if (memcmp(nci_rf_discovery_cmd, buf, len))
 		goto error;
-	write(dev_fd, nci_rf_disc_rsp, sizeof(nci_rf_disc_rsp))
-		;
+	write(dev_fd, nci_rf_disc_rsp, sizeof(nci_rf_disc_rsp));
 
 	return (void *)0;
 error:
@@ -513,8 +503,7 @@ static void *virtual_poll_stop(void *data)
 
 	dev_fd = *(int *)data;
 
-	while ((len = read(dev_fd, buf, 258)) == 0)
-		;
+	len = read(dev_fd, buf, 258);
 	if (len <= 0)
 		goto error;
 	if (len != sizeof(nci_rf_deact_cmd))
-- 
2.32.0

