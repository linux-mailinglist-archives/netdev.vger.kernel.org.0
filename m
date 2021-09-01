Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1D03FD7FF
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 12:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238424AbhIAKtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 06:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238220AbhIAKs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 06:48:59 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08F76C061575;
        Wed,  1 Sep 2021 03:48:03 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 79-20020a1c0452000000b002e6cf79e572so4431280wme.1;
        Wed, 01 Sep 2021 03:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LBCLQ/6Mm7ekbNtZBIv/c8fxdC6nOz1HbQAiHRTgx0g=;
        b=ZEnjJcFYORGgT+J0wQVjra8VTmpsmi0pvnV6T5obZ+WpQhcUJWk7TCj7lgBFGncQ20
         ht194BCbSifaEgmeO/RRS/X8nwaEeZUpyvZpWFKJjC8nG706dY2vv/UT3/O5UtNkNIho
         /Ff2+wZvVMl6AtQEHNk0ckyawFYcKpOt1iIwpcqjK+xIc+NjBV4xaNvDDiqDRz0PLa8k
         q/FntJaNlY7sqT2UyDC7QrUMIWfYDFEOfF0S2CToqp0MKEIdFQ6VXZBwcIt2h4AUz9nT
         /sVpaHITbrdFczpvmQU4tG5Y+r0RZ7H4050/QVMP/LNNumUt61JSl6k+8CbVwVNcPpOz
         sCIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LBCLQ/6Mm7ekbNtZBIv/c8fxdC6nOz1HbQAiHRTgx0g=;
        b=RFk9/3vIrDTR3UEjH4bU32zzAr8pUFMHRZfIYIkztIzH68n3siD7u6nKQX1izUsTjY
         u9eFjwger4X5NNdSo3dwmNpptn/SkDNb+qBIa+GV/t+I2HjjHYKVwcvgjHJXdgnrmRRo
         jxtj3aS6xY66gOo0+uQgWDsP/huf4Brp8TkIEddNLIMpMYsfGKmFIiR/V2sSDiXU3eJV
         nPt+qTd9InS5HtXWaICMy14Admi0XIe7tO3hn27u5Qz0bPsXVfABpIwje41gOgKE5DmM
         ePZannTgmp6r4mKrJYtTVrBJ2cdtGrU20i1L0Ph7UZvCh/cob4GrQHWJdcK20zlz+QKc
         j/eA==
X-Gm-Message-State: AOAM533FRXY05Zi9a88QQ4RKQDk2o5IDbqyKMjw7HklxTWzN8kESHO8T
        3lkiSJZi7uptt1y/kM9e0NY=
X-Google-Smtp-Source: ABdhPJyuKOCq7Xaolvs9june/9UitI6/va9SBx01WJ0mzjULmMLCaEYZVXRkV6Nr/NJ6r1TjKjbMJw==
X-Received: by 2002:a7b:cc0a:: with SMTP id f10mr9172896wmh.32.1630493281665;
        Wed, 01 Sep 2021 03:48:01 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id r12sm21530843wrv.96.2021.09.01.03.48.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Sep 2021 03:48:01 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next 02/20] selftests: xsk: introduce type for thread function
Date:   Wed,  1 Sep 2021 12:47:14 +0200
Message-Id: <20210901104732.10956-3-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210901104732.10956-1-magnus.karlsson@gmail.com>
References: <20210901104732.10956-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Introduce a typedef of the thread function so this can be passed to
init_iface() in order to simplify that function.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 25 ++++++++++++------------
 tools/testing/selftests/bpf/xdpxceiver.h |  4 +++-
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 9639d8da516d..edf5b6cc6998 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -974,10 +974,9 @@ static void testapp_stats(void)
 	print_ksft_result();
 }
 
-static void init_iface(struct ifobject *ifobj, const char *dst_mac,
-		       const char *src_mac, const char *dst_ip,
-		       const char *src_ip, const u16 dst_port,
-		       const u16 src_port, enum fvector vector)
+static void init_iface(struct ifobject *ifobj, const char *dst_mac, const char *src_mac,
+		       const char *dst_ip, const char *src_ip, const u16 dst_port,
+		       const u16 src_port, enum fvector vector, thread_func_t func_ptr)
 {
 	struct in_addr ip;
 
@@ -993,15 +992,13 @@ static void init_iface(struct ifobject *ifobj, const char *dst_mac,
 	ifobj->dst_port = dst_port;
 	ifobj->src_port = src_port;
 
-	if (vector == tx) {
-		ifobj->fv.vector = tx;
-		ifobj->func_ptr = worker_testapp_validate_tx;
+	if (vector == tx)
 		ifdict_tx = ifobj;
-	} else {
-		ifobj->fv.vector = rx;
-		ifobj->func_ptr = worker_testapp_validate_rx;
+	else
 		ifdict_rx = ifobj;
-	}
+
+	ifobj->fv.vector = vector;
+	ifobj->func_ptr = func_ptr;
 }
 
 static void run_pkt_test(int mode, int type)
@@ -1097,8 +1094,10 @@ int main(int argc, char **argv)
 
 	parse_command_line(argc, argv);
 
-	init_iface(ifdict[tx], MAC1, MAC2, IP1, IP2, UDP_PORT1, UDP_PORT2, tx);
-	init_iface(ifdict[rx], MAC2, MAC1, IP2, IP1, UDP_PORT2, UDP_PORT1, rx);
+	init_iface(ifdict[tx], MAC1, MAC2, IP1, IP2, UDP_PORT1, UDP_PORT2, tx,
+		   worker_testapp_validate_tx);
+	init_iface(ifdict[rx], MAC2, MAC1, IP2, IP1, UDP_PORT2, UDP_PORT1, rx,
+		   worker_testapp_validate_rx);
 
 	ksft_set_plan(TEST_MODE_MAX * TEST_TYPE_MAX);
 
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index de80516ac6c2..799d524eb425 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -116,6 +116,8 @@ struct pkt_stream {
 	struct pkt *pkts;
 };
 
+typedef void *(*thread_func_t)(void *arg);
+
 struct ifobject {
 	char ifname[MAX_INTERFACE_NAME_CHARS];
 	char nsname[MAX_INTERFACES_NAMESPACE_CHARS];
@@ -123,8 +125,8 @@ struct ifobject {
 	struct xsk_socket_info *xsk_arr;
 	struct xsk_umem_info *umem;
 	struct xsk_umem_info *umem_arr;
-	void *(*func_ptr)(void *arg);
 	struct flow_vector fv;
+	thread_func_t func_ptr;
 	struct pkt_stream *pkt_stream;
 	int ns_fd;
 	u32 dst_ip;
-- 
2.29.0

