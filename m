Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDED61D95A
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 11:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiKEKSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 06:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiKEKSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 06:18:04 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6E51F2D8;
        Sat,  5 Nov 2022 03:18:02 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id b11so6548237pjp.2;
        Sat, 05 Nov 2022 03:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=30MWZ/QAU7ucYr6chFrQAelaY4GfUj5j6UgBAnY7lFI=;
        b=FDPbz3+19IIyhmm+7vQeQZOGmnCyOif87dleZhv96SxcydSqMrcXRUO1T/luCKU5sy
         YDeZ2hxAVCyyYoKH+zMCROkQdAr+1B+oZBvX8CGGxtD5toIDHcKKFyjoPJhooy7Grihs
         /AoJE2fQKhheNBOGBy45zZILJ9rskZg8OJ5Teq2prhIYBJxeZKrJuEt4qViYYxVeNPqW
         4jruKBq2MsN3whxKEvXyfiTuE2uVm2k7zHXVq86uLpNMx3AU1ZQ7lndaGXk8KHoJjByL
         Szu35lEpzcAhiF3ZgsM2xu0YzKJoZ9zA5Y/wA8+WvVwBtxU4WuDwwMIj6F3tqRFxqVKK
         G41w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=30MWZ/QAU7ucYr6chFrQAelaY4GfUj5j6UgBAnY7lFI=;
        b=zm7PXMPezqBZG5zxWHS1E3kpqS1f0axIIcXl5b1ZlvuT84zLEt3j000J5IVx6lK8mH
         CfdWGnjTsMfaa0JTqFHYjOEHTu7bs3LrVGaEGdIoBm2wsvb2668+CN4tWYi6f+bsjtXm
         0l6nWYCxXvU/EGn0ixy5+FLuvsG/cSjtt9GFVvl4lSsKQ69IwhWaPydw7oxeCVfx6F82
         b3ZtGJCzFrpTtaEPF2Fg8tYTisfemPg2k65EsN9kz2MkZj9P2p8JKOtyvysfiG4QFliK
         ozpcNjiyj3kJCBSWEWruS2SuB+g41Sz8J1waQxXHnu+uQ4WZFWHizl3V8KNL7rlrhy9u
         q/SQ==
X-Gm-Message-State: ACrzQf0t1lROIh/fNlXGunRyM283QED8l2ksXCHygidV5Bt8oPwmhw+s
        7tJZC28WBVrrV5OXAIAxSuk=
X-Google-Smtp-Source: AMsMyM6KeDbNMjpPHBjhckNCbykdnuthE8h6iW05TrKkv2fNp2b0H4kBpKwicIbh4pPzRtKo8C+dNg==
X-Received: by 2002:a17:903:240d:b0:183:9bab:9c3 with SMTP id e13-20020a170903240d00b001839bab09c3mr39992059plo.48.1667643482051;
        Sat, 05 Nov 2022 03:18:02 -0700 (PDT)
Received: from uftrace.. ([14.5.161.231])
        by smtp.gmail.com with ESMTPSA id i4-20020a056a00004400b00562cfc80864sm1014334pfk.36.2022.11.05.03.17.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Nov 2022 03:18:01 -0700 (PDT)
From:   Kang Minchul <tegongkang@gmail.com>
To:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kang Minchul <tegongkang@gmail.com>
Subject: [PATCH] selftests/bpf: Fix unsigned expression compared with zero
Date:   Sat,  5 Nov 2022 19:17:55 +0900
Message-Id: <20221105101755.79848-1-tegongkang@gmail.com>
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

Variable ret is compared with zero even though it have set as u32.
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

