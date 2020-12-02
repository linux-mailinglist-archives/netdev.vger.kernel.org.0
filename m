Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3C3D2CC441
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 18:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727744AbgLBRub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 12:50:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbgLBRua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 12:50:30 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BE91C0617A7
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 09:49:50 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id n8so1466401plp.3
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 09:49:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=ZJDp0F3ipiKpNSC6XpLr49FrbYuavwqixZnrE95IOsk=;
        b=SD011iAMZ4wqKOqFAXcKqG4hvhbzowiV3di5Tpb/biaVdK/vUSBfvdrGnHtwxcjSSk
         YAdoCHA2JL8R5mwL1rYDyKY60vKeK1LBKcOdPrQmKDUGqiBpessB+g8RCnKcqlOBwkiI
         2n3LhXmUDlZtjK2bO7+4UFmz6Ryq8Od8vj3oPDufc9xIl56l97HFcZo5G1n09H9s2NqU
         f6W+rkZI+QxQI2wHIiUSSW+nBxy0iuCiOA/hnGkCFaNByKMitGuKLzbxkGKDWJoM5Bve
         KHISvHdCVWUNVGFwQKVHHK69TbmKKzxBpLa9RSCVCdBzr5SKCNxUP+34B7SQoSOhyQuw
         F0nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=ZJDp0F3ipiKpNSC6XpLr49FrbYuavwqixZnrE95IOsk=;
        b=qjkkBdg28ctarVWdAiNNOmcmCZyYJIbgL2EXXGYMdVpFuXNwvIhvHN0y2oRzgsMYiC
         IEJ3j1BoEMWEDSM1eusTUDpnZ3hVe4d7gD2RbhRVCSwNEM1C0YQHYHhsMupsnX+/Yowk
         a4/6yBIGlc5b/1xfxLQ9AMBWq1WpDHtVxsKQTO9G+85Wh/JQbvq78PVDJ478iQoPsgU9
         MgWw+JqVzEVoTO/vq2H0kSEspXZmyc2wNvPGSVQf7IsjSbNwUxmnNFpsLIKxoSpdMzky
         0qFq2sRLy7gz3Iy9YJ7dmUE39dJhOiE+d8MLf3p9khybHHpwmXCgDN1D65G9h6hffaK2
         9Wgw==
X-Gm-Message-State: AOAM532D50Wm5kO75nDx3ijJsb9LWxPV1qsRGu7R/3fRVS+0GQ/ijKfd
        IK/X5ryLo7/88MNbkcAGSEnFledXOOo8/lpO3tm3rCEjrYx+BYiS0bWq+oUocBYSTHMmdOGzObr
        FlXyQAqy0vbhRopXjCFkuvcBcX+jJ4rTRf9DmvCpkTEQMGaZdMI0WXg==
X-Google-Smtp-Source: ABdhPJz9j1yiigrpqsrBCpbgZsReiYHrutKNSpWJQAuFIVlFtCOI2LmVVqdyuXv70GJzndBuSvMoyPU=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a17:90a:17a4:: with SMTP id
 q33mr348807pja.0.1606931388958; Wed, 02 Dec 2020 09:49:48 -0800 (PST)
Date:   Wed,  2 Dec 2020 09:49:47 -0800
Message-Id: <20201202174947.3621989-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
Subject: [PATCH bpf-next] selftests/bpf: copy file using read/write in local
 storage test
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Splice (copy_file_range) doesn't work on all filesystems. I'm running
test kernels on top of my read-only disk image and it uses plan9 under the
hood. This prevents test_local_storage from successfully passing.

There is really no technical reason to use splice, so lets do
old-school read/write to copy file; this should work in all
environments.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 .../bpf/prog_tests/test_local_storage.c       | 28 ++++++++++++-------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/test_local_storage.c b/tools/testing/selftests/bpf/prog_tests/test_local_storage.c
index fcca7ba1f368..c0fe73a17ed1 100644
--- a/tools/testing/selftests/bpf/prog_tests/test_local_storage.c
+++ b/tools/testing/selftests/bpf/prog_tests/test_local_storage.c
@@ -21,14 +21,6 @@ static inline int sys_pidfd_open(pid_t pid, unsigned int flags)
 	return syscall(__NR_pidfd_open, pid, flags);
 }
 
-static inline ssize_t copy_file_range(int fd_in, loff_t *off_in, int fd_out,
-				      loff_t *off_out, size_t len,
-				      unsigned int flags)
-{
-	return syscall(__NR_copy_file_range, fd_in, off_in, fd_out, off_out,
-		       len, flags);
-}
-
 static unsigned int duration;
 
 #define TEST_STORAGE_VALUE 0xbeefdead
@@ -47,6 +39,7 @@ static int copy_rm(char *dest)
 {
 	int fd_in, fd_out = -1, ret = 0;
 	struct stat stat;
+	char *buf = NULL;
 
 	fd_in = open("/bin/rm", O_RDONLY);
 	if (fd_in < 0)
@@ -64,18 +57,33 @@ static int copy_rm(char *dest)
 		goto out;
 	}
 
-	ret = copy_file_range(fd_in, NULL, fd_out, NULL, stat.st_size, 0);
-	if (ret == -1) {
+	buf = malloc(stat.st_blksize);
+	if (!buf) {
 		ret = -errno;
 		goto out;
 	}
 
+	while (ret = read(fd_in, buf, stat.st_blksize), ret > 0) {
+		ret = write(fd_out, buf, ret);
+		if (ret < 0) {
+			ret = -errno;
+			goto out;
+
+		}
+	}
+	if (ret < 0) {
+		ret = -errno;
+		goto out;
+
+	}
+
 	/* Set executable permission on the copied file */
 	ret = chmod(dest, 0100);
 	if (ret == -1)
 		ret = -errno;
 
 out:
+	free(buf);
 	close(fd_in);
 	close(fd_out);
 	return ret;
-- 
2.29.2.454.gaff20da3a2-goog

