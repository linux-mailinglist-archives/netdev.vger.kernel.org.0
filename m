Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5E1F4DC313
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 10:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbiCQJlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 05:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232112AbiCQJlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 05:41:05 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E95A18A3FE;
        Thu, 17 Mar 2022 02:39:29 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id bn33so6453039ljb.6;
        Thu, 17 Mar 2022 02:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=Rzca7XlJ3nGkRZRrrr3Av3J4sdu0DWRxi2d5ZWbv6Pg=;
        b=qMJYU9bvcIwzFO/6T3IGHQlUDY2nf8R0HceNbhjVGNu30qxD2oLqM33Q7BtWqV5gjX
         rnPbltg8xm5RjaYcPIkPW8ZpJOFCa4bvN1PrySyJYrgYyANBHmgXzN+4IDabjbOi0Haj
         3JLY8qYTUQYuj8nwjl2ZzH1yGO70LoA4FbDxuMmnu15N6/qSsKLepCeFgPoX1/8sOnpy
         k/GTyj2UO7qABKzgz40LSXS7pqIM4Cdn9r9c8l9JOdpflybjkaI15regv2D9YHBWMEeb
         qRnUH8zS12ZOATaCaesIlZUSY83wifNQEawIvw0JyoYv8l/NwVuNlFxsWNoJB0zAm/NW
         tdSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=Rzca7XlJ3nGkRZRrrr3Av3J4sdu0DWRxi2d5ZWbv6Pg=;
        b=2xJd0XEq6MswToUpLSQK6ZS3uOAPRatgfjr48tg3ZkC4ecZSvW3CYSYFlQ6Pxq6mFD
         1xRnaKAy8VCB3LjS/PM5SWYhH0cOCtoNEyRbDcc/HPFfBUvlePlycfi42/rfkDbvKEuW
         OkKysdgQPjRAXkLdRNACEfDYuaPpPItQVEyffgLLWDZmDPTGBN2aT9yPjBuXeV6eWYBK
         W8YJ3jYiIQesg4tTiQQh2B1kd8Zw6YC7UJaLpUNfKc/9OKnYhONKqyfO/USycAg3fUVT
         N/wdpjdQcwIecaqJTTGZtSjfb58e16hYovbZoxbgoXkbvNMyfLn3oiWjhcKiPn6j0mto
         iYMg==
X-Gm-Message-State: AOAM532ZNsHf5W8EAH6jnjh3gHOxrT7JGg1Fh79wURTF2b4QP2To1M+N
        B1tDTWlaPGI1ZXNZoW3p8YM=
X-Google-Smtp-Source: ABdhPJyn9gqazX/j3OpRrVKTgyvCZMLd5NLNYKb/X05EDTG7+95nNuZlXHbmzlHFY1TmyL4xEx4z/g==
X-Received: by 2002:a05:651c:2008:b0:248:49e:c105 with SMTP id s8-20020a05651c200800b00248049ec105mr2332459ljo.327.1647509967749;
        Thu, 17 Mar 2022 02:39:27 -0700 (PDT)
Received: from wse-c0127.beijerelectronics.com ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id w13-20020a2e998d000000b002496199495csm113479lji.55.2022.03.17.02.39.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 02:39:27 -0700 (PDT)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: [PATCH v2 net-next 4/4] selftests: forwarding: add test of MAC-Auth Bypass to locked port tests
Date:   Thu, 17 Mar 2022 10:39:02 +0100
Message-Id: <20220317093902.1305816-5-schultz.hans+netdev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220317093902.1305816-1-schultz.hans+netdev@gmail.com>
References: <20220317093902.1305816-1-schultz.hans+netdev@gmail.com>
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
 .../net/forwarding/bridge_locked_port.sh      | 29 ++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_locked_port.sh b/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
index 6e98efa6d371..2f9519e814b6 100755
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
@@ -170,6 +170,33 @@ locked_port_ipv6()
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
+	ping_do $h1 192.0.2.2
+	check_fail $? "MAB: Ping worked on port just locked"
+
+	if ! bridge fdb show | grep `mac_get $h1` | grep -q "locked"; then
+		RET=1
+		retmsg="MAB: No locked fdb entry after ping on locked port"
+	fi
+
+	bridge fdb del `mac_get $h1` dev $swp1 master
+	bridge fdb add `mac_get $h1` dev $swp1 master static
+
+	ping_do $h1 192.0.2.2
+	check_err $? "MAB: Ping did not work with fdb entry without locked flag"
+
+	log_test "Locked port MAB"
+}
 trap cleanup EXIT
 
 setup_prepare
-- 
2.30.2

