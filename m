Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BDFF22F505
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 18:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729459AbgG0QZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 12:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729306AbgG0QZh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 12:25:37 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A016C061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 09:25:37 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id h7so15768993qkk.7
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 09:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ftfQ08ORCRsliGpN2k0pI0UWrP2nufp8QRORAmCssEM=;
        b=JvwZIxvGgorUM7JUjCzAnk/p8V0pZhEARfcJ5U1kjHrN/nLeikyXe+NqAbkN81gJ0Z
         Npk31V+t6XJnTkuwLVR/clalVpxM8cHxhCcvIWok4JHPGkfIzeBnUE5JCUpG/Ok1tT15
         l5ilcWD7ptR7aDOyJj/tFlIpr/CTyO1LbMTBGX+08N1i9kkLSYCm09KspV1HxFkUHfUq
         OAMZw5sKQloXNSvvgZxxK/1MP1fq59nFQY+VRf+R9RLCwgFI3GGXYzEkShN6An67C0en
         UI/05N5niKMSKvyUY56zSydLr8qc9wo1a9M8nzK2RUqbDqDp0QSTxfPY6PCaJPqZzmRo
         llXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ftfQ08ORCRsliGpN2k0pI0UWrP2nufp8QRORAmCssEM=;
        b=Ox+vEMZf8pm43ZYGMLUA+vC53rj3DUKP5BVcZhVZnTW1VunpBE6AFG8g8of6VboFvc
         RDfq/zt2w7xTCGme+ZY9XcW6PraIyUhdDuHKPxZ4sSj81P3UORa3bb4mo8tah5r7aYzt
         9vcLOtQA1xpAMzT+5T6ZSPKjiANM3VaJT5Rv6QpAEIKh2Yh57HSXE1QTlbUbfLjks/dt
         drc3l9tKuyKpmPOM/qTu0qmIAiw2G2NwjE3Olyf+oLExIAwljLojHS+BuaOHYD6cMX0U
         htCJFxzSD7vBwBu5Ue964uxEpHe6xz6i11I8OChxIMbZpHvUjpPQh0Y/n3m35z9H9wSw
         gKiQ==
X-Gm-Message-State: AOAM533BlVjc8fI5921qHMtJRSet8Vi4k8tNPVwYggyCQ9J4M9RQY4vW
        cwFXMP1c3Eu1CK8grtZ8nqhtYJs5
X-Google-Smtp-Source: ABdhPJw5T8n4/7IDMAVgfNDaxhcp4ScA3sBmT3Zu6l6EsKIhIHwbwRaVQL3ehLEELTcfeltsaEQxUw==
X-Received: by 2002:a37:e86:: with SMTP id 128mr22704620qko.314.1595867136457;
        Mon, 27 Jul 2020 09:25:36 -0700 (PDT)
Received: from tannerlove.nyc.corp.google.com ([2620:0:1003:316:f693:9fff:feea:df57])
        by smtp.gmail.com with ESMTPSA id o37sm16764529qte.9.2020.07.27.09.25.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 09:25:35 -0700 (PDT)
From:   Tanner Love <tannerlove.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Tanner Love <tannerlove@google.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net 4/4] selftests/net: tcp_mmap: fix clang warning for target arch PowerPC
Date:   Mon, 27 Jul 2020 12:25:31 -0400
Message-Id: <20200727162531.4089654-5-tannerlove.kernel@gmail.com>
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
In-Reply-To: <20200727162531.4089654-1-tannerlove.kernel@gmail.com>
References: <20200727162531.4089654-1-tannerlove.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tanner Love <tannerlove@google.com>

When size_t maps to unsigned int (e.g. on 32-bit powerpc), then the
comparison with 1<<35 is always true. Clang 9 threw:
warning: result of comparison of constant 34359738368 with \
expression of type 'size_t' (aka 'unsigned int') is always true \
[-Wtautological-constant-out-of-range-compare]
        while (total < FILE_SZ) {

Tested: make -C tools/testing/selftests TARGETS="net" run_tests

Fixes: 192dc405f308 ("selftests: net: add tcp_mmap program")
Signed-off-by: Tanner Love <tannerlove@google.com>
Acked-by: Willem de Bruijn <willemb@google.com>
---
 tools/testing/selftests/net/tcp_mmap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/tcp_mmap.c b/tools/testing/selftests/net/tcp_mmap.c
index 4555f88252ba..a61b7b3da549 100644
--- a/tools/testing/selftests/net/tcp_mmap.c
+++ b/tools/testing/selftests/net/tcp_mmap.c
@@ -344,7 +344,7 @@ int main(int argc, char *argv[])
 {
 	struct sockaddr_storage listenaddr, addr;
 	unsigned int max_pacing_rate = 0;
-	size_t total = 0;
+	uint64_t total = 0;
 	char *host = NULL;
 	int fd, c, on = 1;
 	char *buffer;
@@ -473,12 +473,12 @@ int main(int argc, char *argv[])
 		zflg = 0;
 	}
 	while (total < FILE_SZ) {
-		ssize_t wr = FILE_SZ - total;
+		int64_t wr = FILE_SZ - total;
 
 		if (wr > chunk_size)
 			wr = chunk_size;
 		/* Note : we just want to fill the pipe with 0 bytes */
-		wr = send(fd, buffer, wr, zflg ? MSG_ZEROCOPY : 0);
+		wr = send(fd, buffer, (size_t)wr, zflg ? MSG_ZEROCOPY : 0);
 		if (wr <= 0)
 			break;
 		total += wr;
-- 
2.28.0.rc0.142.g3c755180ce-goog

