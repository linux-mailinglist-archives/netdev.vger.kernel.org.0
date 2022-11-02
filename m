Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C547B615BEA
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 06:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiKBFlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 01:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiKBFlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 01:41:23 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0326F1122
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 22:41:23 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id z14so22908875wrn.7
        for <netdev@vger.kernel.org>; Tue, 01 Nov 2022 22:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jPX90jqhqdnSm+neboNuWZHmKHx5dT4r/bH8PHoz/kk=;
        b=Z4T81yvj4WIrbkXSy5yioXCSzuoW+fGTp2pchZ8pf/yHsCqp4ItNpEg/wye4ziz0o0
         ehdR5blado+O9o6qaxf+o6Zf5AkVL895TRXbt5MIaPiGly/gD9P+tXaKeBR8eNrm9yXK
         I5y33WWgBY7szol6t5w0UTuGWtC7y86bI4srcM5Qx8v5YjUK7zb5/ZJ0Ev+CAtSD5H3r
         oYe4LbfmKXGTNa0nIGjuyBf2JVjb0Pp3WNTL6uQDFWsQJFMcV1UOTLVwndindwsx9Iuy
         o6G7ERtMhXD7W/Wh1N3hcUpJ5KAyuUWpfzP5ggOhPptxNvQdIVmWD+eCshm0TTIKnA6z
         O8Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jPX90jqhqdnSm+neboNuWZHmKHx5dT4r/bH8PHoz/kk=;
        b=bo5Mhrb2UxjF9CUO8s/jlVVezGnMP+dh+dUpcZhhuwNu2RXzxd8/xp2OVTuelmmdjx
         lT2LgVwxCO9dLMO1J5BZAkhPa/B/enk9pzxi5a/9l1i4FaxiduSpYoI+DyI12Tc+sTgi
         d0+hLyzcw07UMhfkrP/QnDYjO7tyLX//NVbplP9rquEqWoZbF89GiP3ld+15IXNoWHv7
         ZhA08WhARdslFIXnQdfnLB1gpciy72CbgIGd9+z+Ndm5h2sWw8HpwgvEQDnmnPLL1MEd
         fX5Vnkeol69l3OHgfgQLPkRigPkc5PqUy5f+/VqDNDMpffQq3z+h8wpCBT4N6vAMyluP
         idtg==
X-Gm-Message-State: ACrzQf0mJ/1wVSCqZT2H56e+0qs49C/7KAxAiYHHJm+HZ8ZNIDPI5sBa
        IsmemabOUSSs0co5FQDzpop8/MRv060=
X-Google-Smtp-Source: AMsMyM7hypmOn1AIQV9+NW++h3+doMANOVnP1/RNjPEE6L9byPPvvWRKZVoED+byUtVR0ux61uL+2g==
X-Received: by 2002:adf:f58f:0:b0:236:eea6:d4c with SMTP id f15-20020adff58f000000b00236eea60d4cmr1135461wro.39.1667367681462;
        Tue, 01 Nov 2022 22:41:21 -0700 (PDT)
Received: from saproj-Latitude-5501.yandex.net ([2a02:6b8:0:40c:7d89:f027:f2a2:28d9])
        by smtp.gmail.com with ESMTPSA id s7-20020a7bc387000000b003cf75f56105sm743034wmj.41.2022.11.01.22.41.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 22:41:21 -0700 (PDT)
From:   Sergei Antonov <saproj@gmail.com>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, vasundhara-v.volam@broadcom.com,
        Sergei Antonov <saproj@gmail.com>
Subject: [PATCH ethtool] fix a warning when compiling for 32-bit
Date:   Wed,  2 Nov 2022 08:41:15 +0300
Message-Id: <20221102054115.1849736-1-saproj@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

Since BNXT_PCIE_STATS_LEN is size_t:

../../ethtool/bnxt.c:66:68: warning: format ‘%lx’ expects argument of type ‘long unsigned int’, but argument 3 has type ‘unsigned int’ [-Wformat=]
   66 |                 fprintf(stdout, "Length is too short, expected 0x%lx\n",
      |                                                                  ~~^
      |                                                                    |
      |                                                                    long unsigned int
      |                                                                  %x

Signed-off-by: Sergei Antonov <saproj@gmail.com>
---
 bnxt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/bnxt.c b/bnxt.c
index b46db726d1c5..2b0ac7646b2b 100644
--- a/bnxt.c
+++ b/bnxt.c
@@ -63,7 +63,7 @@ int bnxt_dump_regs(struct ethtool_drvinfo *info __maybe_unused, struct ethtool_r
 		return 0;
 
 	if (regs->len < (BNXT_PXP_REG_LEN + BNXT_PCIE_STATS_LEN)) {
-		fprintf(stdout, "Length is too short, expected 0x%lx\n",
+		fprintf(stdout, "Length is too short, expected 0x%zx\n",
 			BNXT_PXP_REG_LEN + BNXT_PCIE_STATS_LEN);
 		return -1;
 	}
-- 
2.34.1

