Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ACEF402413
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 09:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbhIGHVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 03:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240362AbhIGHVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 03:21:16 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 519E2C061757;
        Tue,  7 Sep 2021 00:20:10 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id v20-20020a1cf714000000b002e71f4d2026so1196790wmh.1;
        Tue, 07 Sep 2021 00:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y5WD1aKtaMyuh9hneT8MwIh2Gk7dZWu/fc+ZQakb7tI=;
        b=QODs9NLWPWmwgLPDEyOV4b5Yb7KPMfgJlM79RjPcrtCeoK5YfgB+HdE0OdErk6NLXi
         G9cbE8fUcVfoLmE/FND2Skq2LRCc2gFheWBMZEqbhPGfM8nmbIbItXereOqAZbC0VMXW
         EO7mdh6AYFmAqmHKrWJw5V79GbD8sMwsDMnd0i9d6wJj3KT9xRFNDKCYk29OPNMoiGzg
         ub0bpBCM9ha15x+d1QkjfzwpOm61Gqxorgv6H7fYGpnbuxJlLxz1TVv89RiEH/h59FWc
         LeIyyEjwgXP3+2siwbg61Wc9+56YpogLvIx9gdS/3FmT0nLXdCE5AoP9LqUJfjeWJU79
         JUBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y5WD1aKtaMyuh9hneT8MwIh2Gk7dZWu/fc+ZQakb7tI=;
        b=oC+kUSbaa51WAHY9P1NK9a582bRbqQjdBl1ezqpi3qD57TAMOtYm7LkefsouYHC6wM
         gCg085NMF9WhUzKJv2Y8C1JwUAZH4Kob6zh0XZfMhDQgD83iFaqrn1hxve7lZuxxm8vY
         SEdJbXy/oxZ/aFA+KnCtNG1L9DF4ZFAhGJFUNmiwx02HfqpPqglcPBTxvQ3Q/ffLtp2F
         yQWzf4CG+unwoAuIhpkfIOxAYXqfwdyImd9z5sMhABXEGIP8m7muC7py3ibZ/+iIIM2k
         zw6w59AfO8SR0rmRykemgfDMRDzdzAQocEEaaFBekfKIjRgLky1vmhyMtWRQ2mLfrdhS
         G/iQ==
X-Gm-Message-State: AOAM531ORADw6tpnigIbt6B1hKGzMOvL0rgPp9+XRaWD1dLmQ6PLs4dV
        LLsH7L1bq4gaUF8yKvYLrZM=
X-Google-Smtp-Source: ABdhPJyhv7Jz/B7A/RgdvdKAF+4DmEdFlFA0+5c9ppFUWI4ETPZfpmkbSBcBTwF/XZgI87fk6GbhWQ==
X-Received: by 2002:a7b:cbc9:: with SMTP id n9mr2449075wmi.50.1630999208913;
        Tue, 07 Sep 2021 00:20:08 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id k16sm722941wrd.47.2021.09.07.00.20.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Sep 2021 00:20:08 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next v2 13/20] selftests: xsx: make pthreads local scope
Date:   Tue,  7 Sep 2021 09:19:21 +0200
Message-Id: <20210907071928.9750-14-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210907071928.9750-1-magnus.karlsson@gmail.com>
References: <20210907071928.9750-1-magnus.karlsson@gmail.com>
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

