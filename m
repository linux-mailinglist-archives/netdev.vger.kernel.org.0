Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA4B3D75D3
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236812AbhG0NTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236690AbhG0NSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 09:18:30 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D766C061760;
        Tue, 27 Jul 2021 06:18:30 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id e2so15194903wrq.6;
        Tue, 27 Jul 2021 06:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w0E15WjB5l/ONlsxKyYmXzmAa5QhDL/Q1sNeXYjyMj0=;
        b=uUsTWlZ5IECec8LeH2Qess+6ugcZBHvIjnGMH2EKHngBsmGVnHgLfTfbBcVM6NleDJ
         X/IhZX8zab44AnJmuLCk0zlV1D/4PBoZJ4bgc6VrQR79tLMVQ2RgvGcl96nspWspd54H
         2S3P2Zx5yCLsUSyKliwpn4xp55UywCJ7A0tZhykFFa2+JvmgRA236Z4r7TqI5jAvuceG
         ZfASMz1aDD9FZiWWOTPI9PFUQ/OFKmHtmdnZeuA4HeiR/xl4pkQkK3jqHZi8eKfv2rFS
         mAVnsccPY94vZRuHIN9C3j25Z9y4jzPtxefVQaV1Kq0oSGCIvL8PO5rRv6MrklYEW6Mc
         Rd4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w0E15WjB5l/ONlsxKyYmXzmAa5QhDL/Q1sNeXYjyMj0=;
        b=oldbxovgYYpAXOxgcaHaQw9reXMaeR0/WnvHp7vj1449yyu/VPVFTBprLvEAVW3sxt
         z73WaocwRnju+f2ATTkI8FJ2wStXcSuIO1WqIRJOE52FxyBmNanoyNmIlrpSucWMBUpv
         uzNZnq+FA6G2M7IHKr4YevVChuHoQ1TvvQPDbOoGpmxS3qaETX6R7FiheIRzL+N24x3I
         Yc/gir5P20BEafIT3+dwT+5DU3TtETvlp31RzanVkYRdD+2J4GtFu0XpH7wjeSfwI6ku
         nH7CmJIIUP/78v86+jBOMdmtGul0EMflsIBYHBPC37qyWeoYo//pe7AN2nIvAazYcRJ2
         9OYg==
X-Gm-Message-State: AOAM5324Z9RC9qnlbYmQEhjUbc67xSKC9NrbO6KQbgTa3JZwJ0JVgwww
        9ynSoJuPlObNIHnHa5vJ3GM=
X-Google-Smtp-Source: ABdhPJxZ2S18ykjGqbvgizyeJzdEvjvAdTIgKaLjxPQwfPXbUr/rpoUAcUQqqGQ80efhQWlXIUztwg==
X-Received: by 2002:a05:6000:11c8:: with SMTP id i8mr2820578wrx.300.1627391909103;
        Tue, 27 Jul 2021 06:18:29 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id u11sm3277553wrr.44.2021.07.27.06.18.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Jul 2021 06:18:28 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        joamaki@gmail.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org
Subject: [PATCH bpf-next 13/17] selftests: xsk: remove cleanup at end of program
Date:   Tue, 27 Jul 2021 15:17:49 +0200
Message-Id: <20210727131753.10924-14-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210727131753.10924-1-magnus.karlsson@gmail.com>
References: <20210727131753.10924-1-magnus.karlsson@gmail.com>
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
index 327129f83fef..8cc66c3ce94a 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -1045,25 +1045,21 @@ static void run_pkt_test(int mode, int type)
 
 int main(int argc, char **argv)
 {
-	bool failure = false;
 	int i, j;
 
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
@@ -1082,19 +1078,6 @@ int main(int argc, char **argv)
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

