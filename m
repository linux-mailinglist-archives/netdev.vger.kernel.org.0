Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D69373EE9D2
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 11:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239668AbhHQJ35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 05:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239544AbhHQJ3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 05:29:52 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AEC1C0612A5;
        Tue, 17 Aug 2021 02:29:12 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id u15so13270957wmj.1;
        Tue, 17 Aug 2021 02:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=743CbwfClFAE9LTZpqSwqA+nFBMZxZ5f0FNxdydkr4M=;
        b=kk2eONtcYsNqDm3OEsziy5BUwTN56FvQYgpxtorYyAIYo4jmTLStaiz0keZIhURKHc
         LMpiqiefty9NrggUmO4oMH8nzTiBJSlPigJzWJb5FNoUqt7meOz/ae5MTVK0UmJz5JiY
         UAE6Wcl58JeI4O7nuwku0VtG6Hu9iDGhCHEgHd8Ae7KR44m8scs38c2CyD08OGCcn0/X
         GaeZ8LMEOMlr1K+PSor0coDGQtYwZ8bjFHNstCGe2ta7c/sjsaV/kDTjW3iAwWwP9tpn
         gLDY0LyrGDGEjx2bS7ip98NcsZfVBG7BqwTJVfKg1i7oBrtrV7RYUVepbB7QzoRstSPO
         4FCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=743CbwfClFAE9LTZpqSwqA+nFBMZxZ5f0FNxdydkr4M=;
        b=lysEJW5/mNt/L/xaez4pc9Wf30ub22A7r9O1Qt2osN8EFsWlRiLvcxsBWLIl691r/y
         /tinHt8XgB0c4GZZ3yQig2LPHaS3Le8+OdnBfK6S1jeGFTw0/+wGYPL5maJFQUh9NT0w
         dnWhT8GTZqXDiKXNt968rjZ5MHzPkcZi2vqM+DCUFpK8mM6zBVkbqaStVBrdpJTfYVtU
         d2Sw57BexaaYopWWPZkpSLX94OUcjXEQ/h8zlna+uxXmm+ymqF1I6d7jEgQYwY+TpmXb
         Eymakox6HIZ1y4eXPTXGcQ6O3esOwr3HidJv0n2xG0+LWp9f//jgzaKdPAB/DaWOfjcO
         mG2A==
X-Gm-Message-State: AOAM533jdI5aCNxiLXpHYpnVeFMuNgCniw5PFZ0CZdtpFRwBrTRkpAK3
        b6I8ZQgbmeFSlfDjuVMRmck=
X-Google-Smtp-Source: ABdhPJx/mbDo6wpQq5rra/zCWFdDvo2XHpzDf9XKuCbwiyzgYTY5dAV6YKosnYuNAfPLO/5oviy60w==
X-Received: by 2002:a1c:1904:: with SMTP id 4mr2303507wmz.93.1629192551023;
        Tue, 17 Aug 2021 02:29:11 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id l2sm1462421wme.28.2021.08.17.02.29.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Aug 2021 02:29:10 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next v2 12/16] selftests: xsk: remove cleanup at end of program
Date:   Tue, 17 Aug 2021 11:27:25 +0200
Message-Id: <20210817092729.433-13-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210817092729.433-1-magnus.karlsson@gmail.com>
References: <20210817092729.433-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Remove the cleanup right before the program/process exits as this will
trigger the cleanup without us having to write or maintain any
code. The application is not a library, so let us benefit from that.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 29 +++++-------------------
 1 file changed, 6 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 8ff24472ef1e..c1bb03e0ca07 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -1041,28 +1041,24 @@ static void run_pkt_test(int mode, int type)
 int main(int argc, char **argv)
 {
 	struct rlimit _rlim = { RLIM_INFINITY, RLIM_INFINITY };
-	bool failure = false;
 	int i, j;
 
 	if (setrlimit(RLIMIT_MEMLOCK, &_rlim))
 		exit_with_error(errno);
 
-	for (int i = 0; i < MAX_INTERFACES; i++) {
+	for (i = 0; i < MAX_INTERFACES; i++) {
 		ifdict[i] = malloc(sizeof(struct ifobject));
 		if (!ifdict[i])
 			exit_with_error(errno);
 
 		ifdict[i]->ifdict_index = i;
 		ifdict[i]->xsk_arr = calloc(2, sizeof(struct xsk_socket_info *));
-		if (!ifdict[i]->xsk_arr) {
-			failure = true;
-			goto cleanup;
-		}
+		if (!ifdict[i]->xsk_arr)
+			exit_with_error(errno);
+
 		ifdict[i]->umem_arr = calloc(2, sizeof(struct xsk_umem_info *));
-		if (!ifdict[i]->umem_arr) {
-			failure = true;
-			goto cleanup;
-		}
+		if (!ifdict[i]->umem_arr)
+			exit_with_error(errno);
 	}
 
 	setlocale(LC_ALL, "");
@@ -1081,19 +1077,6 @@ int main(int argc, char **argv)
 		}
 	}
 
-cleanup:
-	for (int i = 0; i < MAX_INTERFACES; i++) {
-		if (ifdict[i]->ns_fd != -1)
-			close(ifdict[i]->ns_fd);
-		free(ifdict[i]->xsk_arr);
-		free(ifdict[i]->umem_arr);
-		free(ifdict[i]);
-	}
-
-	if (failure)
-		exit_with_error(errno);
-
 	ksft_exit_pass();
-
 	return 0;
 }
-- 
2.29.0

