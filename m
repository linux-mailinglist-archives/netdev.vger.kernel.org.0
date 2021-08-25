Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 218143F71EF
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 11:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239936AbhHYJjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 05:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239845AbhHYJiz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 05:38:55 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61BEBC0613CF;
        Wed, 25 Aug 2021 02:38:09 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id d26so15074515wrc.0;
        Wed, 25 Aug 2021 02:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wmeoMz7zyWlaplotPTP1bJSPa6W8At1MPBr8WrlXXNw=;
        b=n9HgJx0xRdZTX7M0k1qicRaRayKoKGI9pzuGReEgIwnb6Y3kzKKJAYo8p+Pgst55iQ
         Ss0+f3/6fGRxxZnmGeGf6stCRBZJEr9jRBdsiHjCMt654QqHPp6MVvguREMTZsldLqmn
         fTDf45C9PPS7aKHVFgtLjhMWPH/CwatwId1nvopYhKTUTx73nOzfdjQ67jrwX9M79Xl/
         8BTlGesqGvqKiQM33etp5dyvlAGHiUU4V3SN6oyR7EAc+ld6boA98GqptBTHSq5/+ItR
         gj8gDiVLXmjQ8BaiUp8SDNz3ijskKtz9mQaqZmXEY8xFu0oixCk67Zde5SA91p8UFz+i
         USSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wmeoMz7zyWlaplotPTP1bJSPa6W8At1MPBr8WrlXXNw=;
        b=KUr4wE7SBujcJmX0A3Dqt5ccF9iIzZcKFQAEa6A8VqZtsMV9W4QZxuHlKwt/IfnIQn
         zFVuK86WfpyfIa19gVZ+Br5+o/6K+yObYe/ae4cmt5qqFKLNoJ3EnkYoPB6vmemLre6I
         clNJsKff6ZTtkuM+9DXS89/ahv+uf0UuyZ0wIiqcBG1XLrlsdahGDppuLjltad/1AHg3
         i4DrEnk3G7qNrF3qM7QUSlLtVDRrnqSpiDeZSjUz89NcEilO+89JFNQoY4sO2ncs9Ifj
         kFHeipn4kHI3+Z1Y4hm/tZurunZO6v8psxcHvm2Vr3Ij3pYS2JQW7iE2gwbM33wygOFL
         //4Q==
X-Gm-Message-State: AOAM530Klg07Zx/+F8WsCU/J4aiWKtmK8EggCoZ9vn7tYeO8vZpd92xl
        5W/+GCiBngsRtVkbJEKQAu4=
X-Google-Smtp-Source: ABdhPJwGZKwRcDejUYwQrMSIJw/uOXSrqWjN1cjNuvooxLLN8R2nwpZCdlhW8NC9lboZ/i3h7VmxsQ==
X-Received: by 2002:adf:fb44:: with SMTP id c4mr23630744wrs.179.1629884288036;
        Wed, 25 Aug 2021 02:38:08 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id k18sm4767910wmi.25.2021.08.25.02.38.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Aug 2021 02:38:07 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next v3 11/16] selftests: xsk: decrease sending speed
Date:   Wed, 25 Aug 2021 11:37:17 +0200
Message-Id: <20210825093722.10219-12-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210825093722.10219-1-magnus.karlsson@gmail.com>
References: <20210825093722.10219-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Decrease sending speed to avoid potentially overflowing some buffers
in the skb case that leads to dropped packets we cannot control (and
thus the tests may generate false negatives). Decrease batch size and
introduce a usleep in the transmit thread to not overflow the
receiver.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 1 +
 tools/testing/selftests/bpf/xdpxceiver.h | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 8ff24472ef1e..bc7d6bbbb867 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -637,6 +637,7 @@ static void tx_only_all(struct ifobject *ifobject)
 
 		tx_only(ifobject->xsk, &frame_nb, batch_size);
 		pkt_cnt += batch_size;
+		usleep(10);
 	}
 
 	complete_tx_only_all(ifobject);
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 0fb657b505ae..1c5457e9f1d6 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -36,7 +36,7 @@
 #define UDP_PKT_DATA_SIZE (UDP_PKT_SIZE - sizeof(struct udphdr))
 #define USLEEP_MAX 10000
 #define SOCK_RECONF_CTR 10
-#define BATCH_SIZE 64
+#define BATCH_SIZE 8
 #define POLL_TMOUT 1000
 #define DEFAULT_PKT_CNT (4 * 1024)
 #define RX_FULL_RXQSIZE 32
-- 
2.29.0

