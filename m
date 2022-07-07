Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E440756A494
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 15:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235882AbiGGNzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 09:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235777AbiGGNzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 09:55:52 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722BA198;
        Thu,  7 Jul 2022 06:55:51 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id z41so23285906ede.1;
        Thu, 07 Jul 2022 06:55:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6akCPIgr8HGJIBWi6ls9yminwTT+fuazEkGCjpCKWVw=;
        b=flmDLr4QVWS1Xjiafg/+VA1HhH6ucmWh9iY8gj4q2kaOWsW2KjOmNEeq6HqHzrHOao
         8tuIwlo6RfT8UDMT2LtCk083/SvLoo2fvLhm/rXZvxHzATU1X7ijfIgePCIyINQTY9xv
         xEX86SiUKNfIdeAIxHupABpBxXm/XdZhCgHiAL12c6/LL11AommnUeRd8afy4ZKx0Boe
         lIuz7UqnCPa1jz41dPBy9s18nTXUrIVZcOyJe1AtB8KHU49A10gdeATTuVu/NSC2QX0J
         /tfLCmVYYkohEHkmUiEMSme/9xAsO9XmR34rG93xaaHKS2dVTeHPE8JxzzrAUVbJqbqE
         i2Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6akCPIgr8HGJIBWi6ls9yminwTT+fuazEkGCjpCKWVw=;
        b=g1NYyXuQlWx19T84cq5P7C1Phezi+s2pE4DcNOaULdaz1YdPsSqV5psJmgrOC5Pkt3
         kA25QbpxC/jiUfEtNGjMCBsWD7dn0OgGAAiJJ2WCQMXes3EFUViU/SNxBRvQqFyMyBO9
         Qsq2lWZnnEwpeOFP2iH3SJmL3NvL/TcvOr4LUGlo+J0Lez04bp5rwqaOJyPgK8HDfsFx
         oxPPSkaGhTyIhsntHvhkzmlVDANZyNw23r8O8/WG7xmtOCSWzFdtXUhYgJnYulNH7ezh
         X3b9pqTp3cauiuUG8fKFiIfdSEKtdWU8Nd83iclABZDzqt6cWDpIBQfPDGMFZ0DIx3OU
         xjxA==
X-Gm-Message-State: AJIora+H1lgis/uWp5IYizrbxiiUw2jYVMBc4Zgo8Uah6/WYwhbYeC3U
        nVJe0b5m0pMwwkwqgYzf5xOLpOPznz4=
X-Google-Smtp-Source: AGRyM1uJ0I6gUyAMhq/gEJTnIQn1LRDGVeM9YVny+hyxq+2YOCHdbACWOoWpMmlNHzkZeoASXXPjGQ==
X-Received: by 2002:a05:6402:1907:b0:435:c243:a66e with SMTP id e7-20020a056402190700b00435c243a66emr60906897edz.44.1657202149903;
        Thu, 07 Jul 2022 06:55:49 -0700 (PDT)
Received: from localhost.localdomain (dynamic-095-117-000-249.95.117.pool.telefonica.de. [95.117.0.249])
        by smtp.googlemail.com with ESMTPSA id x10-20020a170906298a00b00705cd37fd5asm19054969eje.72.2022.07.07.06.55.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 06:55:49 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     vladimir.oltean@nxp.com, linux-kernel@vger.kernel.org,
        pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, shuah@kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 2/2] selftests: forwarding: Install no_forwarding.sh
Date:   Thu,  7 Jul 2022 15:55:32 +0200
Message-Id: <20220707135532.1783925-3-martin.blumenstingl@googlemail.com>
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
all tests should be installed. Add no_forwarding.sh to the list of
"to be installed tests" where it has been missing so far.

Fixes: 476a4f05d9b83f ("selftests: forwarding: add a no_forwarding.sh test")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 tools/testing/selftests/net/forwarding/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/forwarding/Makefile b/tools/testing/selftests/net/forwarding/Makefile
index 6fcf6cdfaee2..a9c5c1be5088 100644
--- a/tools/testing/selftests/net/forwarding/Makefile
+++ b/tools/testing/selftests/net/forwarding/Makefile
@@ -54,6 +54,7 @@ TEST_PROGS = bridge_igmp.sh \
 	mirror_gre_vlan_bridge_1q.sh \
 	mirror_gre_vlan.sh \
 	mirror_vlan.sh \
+	no_forwarding.sh \
 	pedit_dsfield.sh \
 	pedit_ip.sh \
 	pedit_l4port.sh \
-- 
2.37.0

