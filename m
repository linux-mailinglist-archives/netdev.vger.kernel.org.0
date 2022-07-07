Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 806EE56A496
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 15:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235965AbiGGNzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 09:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235806AbiGGNzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 09:55:52 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8516839B;
        Thu,  7 Jul 2022 06:55:50 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id y8so17500884eda.3;
        Thu, 07 Jul 2022 06:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7rOF5KfbCG1CTPmXEdIRSPyxY+PZFL3v83bEdapfOlc=;
        b=bllXbcG5R/K4Ftg0XdFbVZGP8nHSV0H+4C8HgBQ5NemiAhIhp7xZR8e5qgtjP9FHSW
         Qygm17Zyf+ceIYRuoNpWKEuv3ARlNZZPojjQ92aYTbs0VrIaRnwSu/ZUYiAubRFvkAVs
         OJkAKB7G5L9CkJZlZtXzWBcmuEb9o4nQav8kZ16+HgcY6l8iqyuI31G7kIZVVkGXTp+G
         50Kx6FuTJQ6w4kLa0m+vaM2PWeYotIqQz7u9yOB0N9Z++XW1P5SlExBJLYaiN+7bwVlT
         uYN81hA8RO8JW8jYId8uCQ+9KQKkVofJhn0aTWlrQGB9Vn++m7vGTGyvIy81eHyeWKL0
         /YpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7rOF5KfbCG1CTPmXEdIRSPyxY+PZFL3v83bEdapfOlc=;
        b=w6XSsACCr9Ws3O1/H/rqa4rrcpR7pqkw5iGhErJAHNy53oDQDq3ILLnZMLgpHitOaP
         ziYDcwCNq8IOPrt92hepRUQJcScWaqEbDim0F9mtMH2bGzVF38P1f/zBTw3gbQawQYks
         0n+/JC+yAnxPdVbL3qmCk7MTZvsYCFJN3UWaVsEg2kYjiabIJ12kb7KBDAJShv5Yaxmo
         Nd9j7RJqZKwYs3V7sjmB+bVohisEi9DbFcWICKQbdf2+vInBsrEuchtNjYfoJPL5jP2P
         cJud+9oSoysPAVFW38api+BkiK0aK0RvkOhR/UfwPsktkl1Zh5JqR5fs2v6wUE9nhwD/
         n1ZQ==
X-Gm-Message-State: AJIora9E5QOh4zVWiZaA7ZcOCWGLYpVaJrOUMhtU6G+2wwUq/mGkwnKD
        mLKgPoneZ63q++tx3mEAh+kef3yxiig=
X-Google-Smtp-Source: AGRyM1sEDW9njR2dEzEF48yavr1rl5uu4k1bUh+MAcCEUt3K/HretduCnJVI9FTXOGvrK8ANWizDhA==
X-Received: by 2002:a05:6402:15a:b0:431:71b9:86f3 with SMTP id s26-20020a056402015a00b0043171b986f3mr60669526edu.249.1657202148996;
        Thu, 07 Jul 2022 06:55:48 -0700 (PDT)
Received: from localhost.localdomain (dynamic-095-117-000-249.95.117.pool.telefonica.de. [95.117.0.249])
        by smtp.googlemail.com with ESMTPSA id x10-20020a170906298a00b00705cd37fd5asm19054969eje.72.2022.07.07.06.55.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 06:55:48 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     vladimir.oltean@nxp.com, linux-kernel@vger.kernel.org,
        pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, shuah@kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 1/2] selftests: forwarding: Install local_termination.sh
Date:   Thu,  7 Jul 2022 15:55:31 +0200
Message-Id: <20220707135532.1783925-2-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220707135532.1783925-1-martin.blumenstingl@googlemail.com>
References: <20220707135532.1783925-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using the Makefile from tools/testing/selftests/net/forwarding/
all tests should be installed. Add local_termination.sh to the list of
"to be installed tests" where it has been missing so far.

Fixes: 90b9566aa5cd3f ("selftests: forwarding: add a test for local_termination.sh")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 tools/testing/selftests/net/forwarding/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/forwarding/Makefile b/tools/testing/selftests/net/forwarding/Makefile
index 669ffd6f2a68..6fcf6cdfaee2 100644
--- a/tools/testing/selftests/net/forwarding/Makefile
+++ b/tools/testing/selftests/net/forwarding/Makefile
@@ -38,6 +38,7 @@ TEST_PROGS = bridge_igmp.sh \
 	ipip_hier_gre_key.sh \
 	ipip_hier_gre_keys.sh \
 	ipip_hier_gre.sh \
+	local_termination.sh \
 	loopback.sh \
 	mirror_gre_bound.sh \
 	mirror_gre_bridge_1d.sh \
-- 
2.37.0

