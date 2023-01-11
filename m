Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A61F6657BD
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 10:39:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbjAKJiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 04:38:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236563AbjAKJh0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 04:37:26 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFD39F62;
        Wed, 11 Jan 2023 01:36:05 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id co23so14420799wrb.4;
        Wed, 11 Jan 2023 01:36:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oB3RET0NjysKCgsDHpa39CsoLMdR671i7tMj3eqHlXU=;
        b=NBzTdURxKoiELT5Ik89dTnV6PgiLdCJi2u0EK3zAIxFnDSbT/1t/oigdaXzrMcR2Ek
         cv2EtPM3K+vbbLTSW3xXCSeCNu4KfQwE6XwM6r2nZ7O1vTsVep2/P9IIZsXy6f56N1pD
         cnyX6annvG4ffw2P743EDKu87KM5eRFc84CEORIPp/MymnbSVcr0eH7W5jpRO7QxiY9g
         DBxUuMt2pwt24IGL9vlDFWe/otAzr5iJ/JKTRdswxOZoa93B5HbOmSCbtaOENndVfUii
         ouyYxiLgsmIFQHmQ3cYiic0nuHkAlAWS6vVly6sLgr29WiegIZbKMAjMvwpH8IDSj61Z
         75wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oB3RET0NjysKCgsDHpa39CsoLMdR671i7tMj3eqHlXU=;
        b=0np6t4y47fo8vi0o8wPkTaYdT7pOkl6f48F40QjNjgjscFFNnLdn9naZM3DAkS6Vb1
         0meMC33oUrEXfgiMqsl76C4PpiTTDOCRtM+r46BnsPxR82u/I/QB6XRJGSdYTFba5m1E
         WBRgWCekwdJ08SbxbRK5wdKm4+VRdvT0DsqGHgp7ISCIpxZMXe8401UNtjDJVJPWn8Kc
         7B0RMX7BcWozqvNOfYm1a7gjdxyQJJLbpqPw02UA2XnUoI+u3tThLC1c5P3lrkjQLzLs
         D5RxbTkOvLpRcA7bVbQI8DpBCJQBR2RNR6fzFFOw5tEDoRxeFH55ZqtFT790snMuJXYA
         LcjA==
X-Gm-Message-State: AFqh2kqXEmZGSR6/59ph+4aIL1VVWqtCeuIF8mCvGGSFfexm6d5n54G5
        mCEvVxB7Ln/zRSOTxW98WPI=
X-Google-Smtp-Source: AMrXdXtyx146RmuMRp3QoxO6lbIs16xHgKfETZo8T0s+kHyvVyo7ZaAU+/4+gC1veuIc/oj60c29cg==
X-Received: by 2002:adf:f0c1:0:b0:272:805a:5057 with SMTP id x1-20020adff0c1000000b00272805a5057mr40048161wro.30.1673429764305;
        Wed, 11 Jan 2023 01:36:04 -0800 (PST)
Received: from localhost.localdomain (h-176-10-254-193.A165.priv.bahnhof.se. [176.10.254.193])
        by smtp.gmail.com with ESMTPSA id c18-20020adffb52000000b0025e86026866sm15553069wrs.0.2023.01.11.01.36.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Jan 2023 01:36:03 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, tirthendu.sarkar@intel.com
Cc:     jonathan.lemon@gmail.com
Subject: [PATCH bpf-next v3 03/15] selftests/xsk: submit correct number of frames in populate_fill_ring
Date:   Wed, 11 Jan 2023 10:35:14 +0100
Message-Id: <20230111093526.11682-4-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230111093526.11682-1-magnus.karlsson@gmail.com>
References: <20230111093526.11682-1-magnus.karlsson@gmail.com>
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

From: Magnus Karlsson <magnus.karlsson@intel.com>

Submit the correct number of frames in the function
xsk_populate_fill_ring(). For the tests that set the flag
use_addr_for_fill, uninitialized buffers were sent to the fill ring
following the correct ones. This has no impact on the tests, since
they only use the ones that were initialized. But for correctness,
this should be fixed.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/testing/selftests/bpf/xskxceiver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index 2ff43b22180f..a239e975ab66 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -1272,7 +1272,7 @@ static void xsk_populate_fill_ring(struct xsk_umem_info *umem, struct pkt_stream
 
 		*xsk_ring_prod__fill_addr(&umem->fq, idx++) = addr;
 	}
-	xsk_ring_prod__submit(&umem->fq, buffers_to_fill);
+	xsk_ring_prod__submit(&umem->fq, i);
 }
 
 static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
-- 
2.34.1

