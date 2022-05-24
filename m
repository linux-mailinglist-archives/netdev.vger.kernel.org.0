Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0980A532D49
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 17:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236285AbiEXPWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 11:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238825AbiEXPWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 11:22:16 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00D2F49682;
        Tue, 24 May 2022 08:22:12 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id c19so18312332lfv.5;
        Tue, 24 May 2022 08:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=FgEZaD+qaBUQURDZcatdSAcmpukEK3yyWD1n5B1AlNE=;
        b=Dqj8l9wZWDZHC1yP3YJCdmoXSjz9VdQZ0nXh27JmdifHCAIdkhRbRZVQrIejbZ3WjQ
         Facd+POgcmZoA1cdq73VcsPdCaQaAaTKVp5LHtYw4L1/E/nOU22l7xsISjb2Rwn5mTYS
         B/K02m5GurI9+HcZsANOpX/kFRKW5mQsMTRHcVgCKPiJVvMYxxxks6npgJp87DTTWKCo
         0zfjBUBu4SaIPElyMYzh2zUvhVknUjvzJ6sSEPM6AE3Lwg4DdaLTqZDWzfgdvPOLmSW1
         K7UQILzLUgJSIWLuPfcMrf+Kum4zLz5TvwBScXCaxb0/192mPsaw8vZoKo3dhGaOiHST
         a3lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=FgEZaD+qaBUQURDZcatdSAcmpukEK3yyWD1n5B1AlNE=;
        b=Ba/kgke4xvcp2a+nza7Z+Fj2hi0jq6xGhukWTrrA20dJY7yyPSxFE2WoCKWLoFQZ4n
         u6v+ba/Jl2aCpqrJ9fLVJQs0CqV/sgpvocjqH8BGyvaZyQcUPm01JbKs34+Z4R3YgSaS
         dzpNXY5sKvqyKHMAWa7/30M2MfSvJJA6sn4Fr3RhLucZ3InEJ9vV3wGDFdubtsda4+yU
         Kh65FM6iFiw1tt/W4/U7Y8J10zFrmHFECsV23pQ2SFi+YhXO5HsKQRzY6bjyDq1nGJUF
         7Hzq2yxovwK/Zx2b2wQGvzMS5FYpg2C0h83r5TGycE+xLsWNeDSxf9gOo3p6HLmMjn6b
         exSA==
X-Gm-Message-State: AOAM533QyZArUP3BcaV2QSFArYJPxCvJs+72HZGdzFMSxy+O80Rcf6mk
        /FH9fV9q6gYp58DTDWnn40s=
X-Google-Smtp-Source: ABdhPJxDH5QbQwWSsc4CHoBv8PDLSvGdn1OPRFrwKo67di2vK6AqwBhM00lt3/n2SEU2ZLuAtpjeLA==
X-Received: by 2002:a05:6512:150b:b0:43b:3539:e215 with SMTP id bq11-20020a056512150b00b0043b3539e215mr19370076lfb.573.1653405731360;
        Tue, 24 May 2022 08:22:11 -0700 (PDT)
Received: from wse-c0127.westermo.com (2-104-116-184-cable.dk.customer.tdc.net. [2.104.116.184])
        by smtp.gmail.com with ESMTPSA id d22-20020a2e3316000000b00253deeaeb3dsm2441404ljc.131.2022.05.24.08.22.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 08:22:11 -0700 (PDT)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: [PATCH V3 net-next 4/4] selftests: forwarding: add test of MAC-Auth Bypass to locked port tests
Date:   Tue, 24 May 2022 17:21:44 +0200
Message-Id: <20220524152144.40527-5-schultz.hans+netdev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220524152144.40527-1-schultz.hans+netdev@gmail.com>
References: <20220524152144.40527-1-schultz.hans+netdev@gmail.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
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

Verify that the MAC-Auth mechanism works by adding a FDB entry with the
locked flag set. denying access until the FDB entry is replaced with a
FDB entry without the locked flag set.

Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
---
 .../net/forwarding/bridge_locked_port.sh      | 42 ++++++++++++++++---
 1 file changed, 36 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_locked_port.sh b/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
index 5b02b6b60ce7..50b9048d044a 100755
--- a/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
@@ -1,7 +1,7 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
-ALL_TESTS="locked_port_ipv4 locked_port_ipv6 locked_port_vlan"
+ALL_TESTS="locked_port_ipv4 locked_port_ipv6 locked_port_vlan locked_port_mab"
 NUM_NETIFS=4
 CHECK_TC="no"
 source lib.sh
@@ -94,13 +94,13 @@ locked_port_ipv4()
 	ping_do $h1 192.0.2.2
 	check_fail $? "Ping worked after locking port, but before adding FDB entry"
 
-	bridge fdb add `mac_get $h1` dev $swp1 master static
+	bridge fdb replace `mac_get $h1` dev $swp1 master static
 
 	ping_do $h1 192.0.2.2
 	check_err $? "Ping did not work after locking port and adding FDB entry"
 
 	bridge link set dev $swp1 locked off
-	bridge fdb del `mac_get $h1` dev $swp1 master static
+	bridge fdb del `mac_get $h1` dev $swp1 master
 
 	ping_do $h1 192.0.2.2
 	check_err $? "Ping did not work after unlocking port and removing FDB entry."
@@ -124,13 +124,13 @@ locked_port_vlan()
 	ping_do $h1.100 198.51.100.2
 	check_fail $? "Ping through vlan worked after locking port, but before adding FDB entry"
 
-	bridge fdb add `mac_get $h1` dev $swp1 vlan 100 master static
+	bridge fdb replace `mac_get $h1` dev $swp1 master static
 
 	ping_do $h1.100 198.51.100.2
 	check_err $? "Ping through vlan did not work after locking port and adding FDB entry"
 
 	bridge link set dev $swp1 locked off
-	bridge fdb del `mac_get $h1` dev $swp1 vlan 100 master static
+	bridge fdb del `mac_get $h1` dev $swp1 vlan 100 master
 
 	ping_do $h1.100 198.51.100.2
 	check_err $? "Ping through vlan did not work after unlocking port and removing FDB entry"
@@ -153,7 +153,8 @@ locked_port_ipv6()
 	ping6_do $h1 2001:db8:1::2
 	check_fail $? "Ping6 worked after locking port, but before adding FDB entry"
 
-	bridge fdb add `mac_get $h1` dev $swp1 master static
+	bridge fdb replace `mac_get $h1` dev $swp1 master static
+
 	ping6_do $h1 2001:db8:1::2
 	check_err $? "Ping6 did not work after locking port and adding FDB entry"
 
@@ -166,6 +167,35 @@ locked_port_ipv6()
 	log_test "Locked port ipv6"
 }
 
+locked_port_mab()
+{
+	RET=0
+	check_locked_port_support || return 0
+
+	ping_do $h1 192.0.2.2
+	check_err $? "MAB: Ping did not work before locking port"
+
+	bridge link set dev $swp1 locked on
+	bridge link set dev $swp1 learning on
+
+	bridge fdb del `mac_get $h1` dev $swp1 master
+
+	ping_do $h1 192.0.2.2
+	check_fail $? "MAB: Ping worked on locked port without FDB entry"
+
+	bridge fdb show | grep `mac_get $h1` | grep -q "locked"
+	check_err $? "MAB: No locked fdb entry after ping on locked port"
+
+	bridge fdb replace `mac_get $h1` dev $swp1 master static
+
+	ping_do $h1 192.0.2.2
+	check_err $? "MAB: Ping did not work with fdb entry without locked flag"
+
+	bridge fdb del `mac_get $h1` dev $swp1 master
+	bridge link set dev $swp1 locked off
+
+	log_test "Locked port MAB"
+}
 trap cleanup EXIT
 
 setup_prepare
-- 
2.30.2

