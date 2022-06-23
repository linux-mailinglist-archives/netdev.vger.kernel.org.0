Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31B2F556F48
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 02:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236917AbiFWACi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 20:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232190AbiFWACh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 20:02:37 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF9340903
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 17:02:36 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id k14so5235009plh.4
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 17:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Cg/Ha1pm1JB8OKSt871OodatyKWlkiM73gNITVPRFRk=;
        b=gFyIXY5hESIvSFkllmRqy9hHXemwAO8foY2q7YMDZ2nuwDSxQGBj94i5tVGaC95+jO
         e/kUqlKdh2aoyysqnnFLIxFTihGZSlxKQ+QlohCrHUVJxcfLHBDHWVP2/NaCYIoJfjSz
         DvqwxRwItunAHr0bO3GOBcLEHkOb52B21VigA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Cg/Ha1pm1JB8OKSt871OodatyKWlkiM73gNITVPRFRk=;
        b=R0p8j0c9MUFp2+H2Bf2l/mu22QgvIMjmLRApyZ1N/dDGtg0pG44pMc6CZgg7v1usIX
         h7IPiIEBjOqwcGECXETNiZpZwV/zHROFxVI7xw5mo2KEa255mDiQ9zpQdLYORnzl3hbf
         ZglWUJto8d33qC1kyYL7X+0SRcdruUDo8AnxFUTvURDTo/oz10yyeJHAgJJAqUvgtL3X
         4qFXYRQWIi0AEMjuT9u/lQ+TQApAScTzKK8trc2iztUuAOesRLBHvsVk9XOn1Zynq25C
         R3+jEfi5/S23qOL0SKt7/S/AO4tMKjuYjd1RJGP+spCMYyuv199Otzuk3ZVI63TSxt4O
         P8Xg==
X-Gm-Message-State: AJIora9osKsB8uOsnQV/Ax2BzXTLItbONc2ABHzO2BgJW7z1tBap7QPn
        rGtho4XtH9t9MDWKrpt9F4gIVQ==
X-Google-Smtp-Source: AGRyM1tHd224vF4M15VB7JJ1g93yTszkzPaHES6ikaz7xAUUoKKhjsVjmHY7lyeSCgiiNxlxQZPnqA==
X-Received: by 2002:a17:903:2443:b0:16a:2b65:7edd with SMTP id l3-20020a170903244300b0016a2b657eddmr15789767pls.20.1655942556346;
        Wed, 22 Jun 2022 17:02:36 -0700 (PDT)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id o6-20020a1709026b0600b001663165eb16sm249777plk.7.2022.06.22.17.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 17:02:36 -0700 (PDT)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, d.michailidis@fungible.com
Cc:     willemb@google.com
Subject: [PATCH net] selftests/net: pass ipv6_args to udpgso_bench's IPv6 TCP test
Date:   Wed, 22 Jun 2022 17:02:34 -0700
Message-Id: <20220623000234.61774-1-dmichail@fungible.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

udpgso_bench.sh has been running its IPv6 TCP test with IPv4 arguments
since its initial conmit. Looks like a typo.

Fixes: 3a687bef148d ("selftests: udp gso benchmark")
Cc: willemb@google.com
Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>
---
 tools/testing/selftests/net/udpgso_bench.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/udpgso_bench.sh b/tools/testing/selftests/net/udpgso_bench.sh
index 80b5d352702e..dc932fd65363 100755
--- a/tools/testing/selftests/net/udpgso_bench.sh
+++ b/tools/testing/selftests/net/udpgso_bench.sh
@@ -120,7 +120,7 @@ run_all() {
 	run_udp "${ipv4_args}"
 
 	echo "ipv6"
-	run_tcp "${ipv4_args}"
+	run_tcp "${ipv6_args}"
 	run_udp "${ipv6_args}"
 }
 
-- 
2.25.1

