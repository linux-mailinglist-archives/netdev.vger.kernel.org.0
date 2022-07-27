Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 036EA583369
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 21:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236962AbiG0TVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 15:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233710AbiG0TVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 15:21:17 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A2B30B;
        Wed, 27 Jul 2022 12:16:49 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id l23so33252819ejr.5;
        Wed, 27 Jul 2022 12:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/lpXVcYr+pSlGM3+sjGYZwGdTyGSk5mhwK6SxlMFQCY=;
        b=m3WXErq4rp6Y2s1W+D3PJgaksA2kmBwHnyZqfKN+GbK3yv1ajpTma/3p1yBrWe+xpj
         PHwefNwNni2REdrd3B0DLPRFaw8O+mY3R4GOW+Mt2npD+MMtTrrypXvusTDIAwznal0l
         cdDrEYJ2nQvY9t7a0oHiUd9Rx+UyOQGyKG4EKB5B0SovVe+MohDsUf1eDZrc1CP00zHq
         hHu+H+VNt7KspH63qUL7V6vMxXmppIC/1cM1xdJXRWHPgck2jOyRBeUiUD+rHNk2MUYp
         /EIkbdltoXwHe6awf2EyWQhjL57YebRbXd1zNDbkHaJK5wJ3DrE9ZVkZtd+gVPWuBrW+
         5yzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/lpXVcYr+pSlGM3+sjGYZwGdTyGSk5mhwK6SxlMFQCY=;
        b=TbDErGhnZeNcV9+AB1X2OMOe/Cgc5xKpv4w2XWSP9ZuBedwL6Xw3S4qodUZFw1LDb+
         i+8SGuQk1Hw6QTkuMC1b17bXNsFm/Lq/PeIHZ/n2eoHJs5Hz/Gi7O8QKd7IDUFsenvSV
         Z7froMw/7aSA99X5K+Cv5vK/LZzdDK6V7KCSkN+2ngxFrjX7lDq4Pfkl9wo1ATPAfQ/O
         +Ay9LWAQk8E02BjZmXG/nk8l2CQKmMWYnglTjn1DJ+Cr3Wfm0HV92bqpedUrNiSDYof9
         siNB8FGkR3cL+oemSN0tigs08p7FBB39gMzYUyBz0LmiCZz1GNKKco42eagl/H7AAvLF
         nuVA==
X-Gm-Message-State: AJIora8Cym9HTthMWC66jsU2gvhtZbNhv1JCm/sXsKRpNq1xcbT5yzEf
        xVVgiPgmVc4ncC1IPedTWPGCJ4FJvnQ=
X-Google-Smtp-Source: AGRyM1txZ+4PgwjkUqHdqbzb6SnROINNgZvrrcd1mHNKK+XKfAZKwpRUO8imux+QuzV7yR6dsgYKkw==
X-Received: by 2002:a17:906:93ef:b0:72b:3e88:a47 with SMTP id yl15-20020a17090693ef00b0072b3e880a47mr18786984ejb.706.1658949407680;
        Wed, 27 Jul 2022 12:16:47 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a01-0c23-c4df-3f00-0000-0000-0000-0e63.c23.pool.telefonica.de. [2a01:c23:c4df:3f00::e63])
        by smtp.googlemail.com with ESMTPSA id h12-20020a1709060f4c00b006ff0b457cdasm7865081ejj.53.2022.07.27.12.16.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 12:16:46 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-kselftest@vger.kernel.org, netdev@vger.kernel.org
Cc:     vladimir.oltean@nxp.com, linux-kernel@vger.kernel.org,
        pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, shuah@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH net-next v1] selftests: net: dsa: Add a Makefile which installs the selftests
Date:   Wed, 27 Jul 2022 21:16:42 +0200
Message-Id: <20220727191642.480279-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.37.1
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

Add a Makefile which takes care of installing the selftests in
tools/testing/selftests/drivers/net/dsa. This can be used to install all
DSA specific selftests and forwarding.config using the same approach as
for the selftests in tools/testing/selftests/net/forwarding.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 .../testing/selftests/drivers/net/dsa/Makefile  | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)
 create mode 100644 tools/testing/selftests/drivers/net/dsa/Makefile

diff --git a/tools/testing/selftests/drivers/net/dsa/Makefile b/tools/testing/selftests/drivers/net/dsa/Makefile
new file mode 100644
index 000000000000..2a731d5c6d85
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/dsa/Makefile
@@ -0,0 +1,17 @@
+# SPDX-License-Identifier: GPL-2.0+ OR MIT
+
+TEST_PROGS = bridge_locked_port.sh \
+	bridge_mdb.sh \
+	bridge_mld.sh \
+	bridge_vlan_aware.sh \
+	bridge_vlan_mcast.sh \
+	bridge_vlan_unaware.sh \
+	local_termination.sh \
+	no_forwarding.sh \
+	test_bridge_fdb_stress.sh
+
+TEST_PROGS_EXTENDED := lib.sh
+
+TEST_FILES := forwarding.config
+
+include ../../../lib.mk
-- 
2.37.1

