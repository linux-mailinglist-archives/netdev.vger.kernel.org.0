Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADE861D960
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 11:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbiKEK0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 06:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiKEKZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 06:25:59 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C1D627B14;
        Sat,  5 Nov 2022 03:25:59 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id g129so6390197pgc.7;
        Sat, 05 Nov 2022 03:25:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=U3pVfup+yG64ldWhowKF8wBUHo0xoRLBn7/G0ZGa/OA=;
        b=byP6G7+7l+Wu9gkA3FhuYw5u0UHiR2gM2clNBcYriPSMRMXr/yDbo49D7cyLHUBA3O
         HfKSu9FbbMvQoJqr8MkftsK089jHpsy5HMdIqY0v4LMjcvsew8izcLGFlIDD2jf4KIrQ
         WiYTRuc8fJetOom9oTA3hvBsZcIBprbOdsDICiqjnQ4ES4X8XYjiV7bM4rwIc1Y4h8pN
         7JV2Qa3eB8q0ULTSa4RSTLv8WYoTN8jNixAIB0eK53KW5c4HB4PHkILrAs7fn8Th6bSe
         3spZMxwPDso0ZEKrH7qttZ4+8w9eXBXogo/YiTV3Z3lZ5KgEZUtiu2H4R5EevmgyNdTD
         1yXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U3pVfup+yG64ldWhowKF8wBUHo0xoRLBn7/G0ZGa/OA=;
        b=NLeHRSdszvXAiBeco8l71emMecpN6xEHKKWZCw3evkTuCDEwyMLSlh9dnlNMy4dbOx
         J10xNTPqbzjIl+KIkmN/c4b6XLAbH1ol5N4FtHzWFXtb1ISAejoYtydPQDUYuQmpO5gi
         G3TgyVG3NZY+DZg8UPtaBJl2Ucwu2s4QAqlU82LFeL2lT7uyAXJXbuuvTBYO3YYi2tSa
         bAA30Z8RlfTOphW5mkrVeYoo3GwKSLVdRUivb1Xv8deStE7Jb/2elTpNXm+d9a1sAF1V
         8csetj+83PJeo/VN4sbvxLs7PJSrSoDnpdCEZngC4JtCcKU1/OulMYX0qX4m9t/eRYK5
         phhQ==
X-Gm-Message-State: ACrzQf0pQFoeWsZrNOvw+8Sf+QbkImIw+OpImaSSynIczYRoTEDW2xPU
        9+QBt4b8W7ObHqRWvWJ7bnU=
X-Google-Smtp-Source: AMsMyM5yh39X95h2duX/nO6ICHox3imNlX9MMx18KW8rR9T8hYz3hgiKE18/QrZ1oE0odFt/fdET/Q==
X-Received: by 2002:a65:5241:0:b0:46e:f67c:c108 with SMTP id q1-20020a655241000000b0046ef67cc108mr33506139pgp.362.1667643958451;
        Sat, 05 Nov 2022 03:25:58 -0700 (PDT)
Received: from uftrace.. ([14.5.161.231])
        by smtp.gmail.com with ESMTPSA id w14-20020aa79a0e000000b0056beae3dee2sm1050109pfj.145.2022.11.05.03.25.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Nov 2022 03:25:58 -0700 (PDT)
From:   Kang Minchul <tegongkang@gmail.com>
To:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kang Minchul <tegongkang@gmail.com>
Subject: [PATCH v2] selftests/bpf: Fix unsigned expression compared with zero
Date:   Sat,  5 Nov 2022 19:25:52 +0900
Message-Id: <20221105102552.80052-1-tegongkang@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable ret is compared with zero even though it was set as u32.
So u32 to int conversion is needed.

Signed-off-by: Kang Minchul <tegongkang@gmail.com>
---
 tools/testing/selftests/bpf/xskxceiver.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index 681a5db80dae..162d3a516f2c 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -1006,7 +1006,8 @@ static int __send_pkts(struct ifobject *ifobject, u32 *pkt_nb, struct pollfd *fd
 {
 	struct xsk_socket_info *xsk = ifobject->xsk;
 	bool use_poll = ifobject->use_poll;
-	u32 i, idx = 0, ret, valid_pkts = 0;
+	u32 i, idx = 0, valid_pkts = 0;
+	int ret;
 
 	while (xsk_ring_prod__reserve(&xsk->tx, BATCH_SIZE, &idx) < BATCH_SIZE) {
 		if (use_poll) {
-- 
2.34.1

