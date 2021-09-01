Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 848113FD81C
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 12:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238726AbhIAKth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 06:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238840AbhIAKtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 06:49:16 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E808C061764;
        Wed,  1 Sep 2021 03:48:19 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id e26so1543550wmk.2;
        Wed, 01 Sep 2021 03:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y5WD1aKtaMyuh9hneT8MwIh2Gk7dZWu/fc+ZQakb7tI=;
        b=gGJXldUYNFNdQLRJ6Je7H5oJW5zFnHRoKezPQ3yORK09GTsSUYbMDlGXMY1WZTl/M+
         HUTQLPOQoEmgRN9WqrwM8JnoUH/Yu3ynstx8qXsdlOHaZQIcmIl8lT1jUATylsKuox6R
         iGdwKIRSz4tYA3IAOY6DZ2DpHJ6VguWk1S7ACCHTSof3efE23gCSBOSiWaMBVaKkn82l
         0oaaCW8gSMYitJiIyaJkedUavRX8RaHdZuQG3KHfdAdxoBakzFIUzoXmPIF1kAm1hrdb
         Kr3idkdykF6q/o+JWQLW8MOUJ+VHRTuTAk7UZSz5HURnCZtYoHF4HNI3IlIfW3eh1X7X
         lD1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y5WD1aKtaMyuh9hneT8MwIh2Gk7dZWu/fc+ZQakb7tI=;
        b=hhIQKzKuOpaTL7HgFcUbymeh2Fspfx+BvIA9pmxd/MbIOGCDMUMp1LzxgTaqC2+Uou
         dOr/W7AMZ42yZ2iF6u1RgwyiTE4Xd3XFO7Fts8gFn++rQWoLCvShuOqCYS7zz/1xAQhq
         zWo+5XR/r2rPo76ZbB3oFHYHPhatRLNIie1IHuu7DZL/rvnwBaZeRpoW07IzZnuDy2Ye
         J9HFzxXbTaA2YcDSScWsO4lxgaXtUWeaL15a2Nf2HQkZ5wNkqHClOhM/7xscErcv8PHo
         q/gmzgwirso6sS50+VKL0z3jAWqwxlCw6G+WGMLGETQoyTy5Vol0+N5hXMAWGhn3ABPs
         XZ9Q==
X-Gm-Message-State: AOAM530rK2VZnHATZh9MqHjkBjdNjdREzGf20/H4aJ1Ip24ZRxhRi89m
        NlEowHjqPu4xgvnm3vN3EwU=
X-Google-Smtp-Source: ABdhPJwp59ZjN1K9s76dCniY7jBHfPJgxTar2NiK+T0YIDY5NT0tt2A1Tf9SWZ91vmL/DyjbJUp2Cw==
X-Received: by 2002:a7b:c255:: with SMTP id b21mr8994063wmj.44.1630493298087;
        Wed, 01 Sep 2021 03:48:18 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id r12sm21530843wrv.96.2021.09.01.03.48.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Sep 2021 03:48:17 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next 13/20] selftests: xsx: make pthreads local scope
Date:   Wed,  1 Sep 2021 12:47:25 +0200
Message-Id: <20210901104732.10956-14-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210901104732.10956-1-magnus.karlsson@gmail.com>
References: <20210901104732.10956-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Make the pthread_t variables local scope instead of global. No reason
for them to be global.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 1 +
 tools/testing/selftests/bpf/xdpxceiver.h | 2 --
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 3a1afece7c2c..5ea78c503741 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -887,6 +887,7 @@ static void testapp_validate_traffic(struct test_spec *test)
 	struct ifobject *ifobj_tx = test->ifobj_tx;
 	struct ifobject *ifobj_rx = test->ifobj_rx;
 	struct pkt_stream *pkt_stream;
+	pthread_t t0, t1;
 
 	if (pthread_barrier_init(&barr, NULL, 2))
 		exit_with_error(errno);
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 7ed16128f2ad..34ae4e4ea4ac 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -138,8 +138,6 @@ struct test_spec {
 	char name[MAX_TEST_NAME_SIZE];
 };
 
-/*threads*/
 pthread_barrier_t barr;
-pthread_t t0, t1;
 
 #endif				/* XDPXCEIVER_H */
-- 
2.29.0

