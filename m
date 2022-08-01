Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF53586B58
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 14:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235019AbiHAMv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 08:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235058AbiHAMvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 08:51:45 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A50F91A380
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 05:46:28 -0700 (PDT)
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id A3C613F043
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 12:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1659357983;
        bh=3bPb0dad/oOvrex03/AgLvrUL+bomAiOTjep52WTUPk=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=nvcjtNhY/7ks2XaqE0ubLyk1X+O7UpOq28nryjAJOhw+tvowKkwrxlYh1MmCUssDg
         SB3hTNz//GiZKGe/ICKfvSdEm4+5yKFCOc7ioV6D37gPhEeCSwmY5Fl8WfB7siWC3Q
         eIwbnUzYbsTDaUgWBvteJIr3T6AsIYUxOobM9aqUyF4mTitMGEM3SBPz5GNhz7b88m
         PeOi1RdHZzhywrWMOjvM/2vqr9vP86HmoJhjju1GERqAUvj7RQFr6nN3vGwmyFtVY0
         TAcEjtj5YPoyo28OX5vWgbUEiH6e7u+Lt31GtZJqN83A3+lMUuaHhyo/Xq5Kvs9TCm
         7JJfLgKc/ZIPQ==
Received: by mail-ed1-f71.google.com with SMTP id f13-20020a0564021e8d00b00437a2acb543so7029135edf.7
        for <netdev@vger.kernel.org>; Mon, 01 Aug 2022 05:46:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3bPb0dad/oOvrex03/AgLvrUL+bomAiOTjep52WTUPk=;
        b=nVjYqdUJrafP0ENTmjRIxT1XIxv/GcQgntQ6PIIi9BgbgaKCU2hXDR6Yx6mVg0vY7L
         RvmUctFqseTr/h3umsBr/oTdAo/Nqto9aCEKVSj+fhvC+WWpIcrYIv9588Fao2XFDQKs
         TsKHMskQpgsxXX0Nmh87fQezvlNj3CSJZrtwbY2PTFhmULmugPE1jPqGZIPmnt9aS047
         u/o9patC9oBOFEx8DD8iQ1yOTN4PvnqXQu9sjyy4X9yGPziXGTz1vxoacfaLamP4KQQ4
         uOnXQE4S0dq8v2058ibxH2R4pV1EZC9w8/jDpPCC+v6J73G4aGQDSgSdR8BinfiEVaJl
         n3jA==
X-Gm-Message-State: AJIora8VQHr4ZR8Pkd3iuG60dHsxVUoYPoEM/n0Y1PQWxkgiexlqXqcj
        uKzDrFyo0IKN65/LUjctzAvFjAT93RdBlaRWgwweztr2oM20NbIetCipMETf9Z7OYnQXPjJFFDm
        wyfzv7WTx2C19n+wwAVxHR27sfEXsDnyAGQ==
X-Received: by 2002:a17:907:1b09:b0:72f:d49e:6924 with SMTP id mp9-20020a1709071b0900b0072fd49e6924mr12342235ejc.15.1659357983395;
        Mon, 01 Aug 2022 05:46:23 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1siAb2whtG2DzEO1CK9FWYk3yYciUFIkpJRrwW0nZ4E8RV1QembUa/rlHkpipXv6aQPvEOryg==
X-Received: by 2002:a17:907:1b09:b0:72f:d49e:6924 with SMTP id mp9-20020a1709071b0900b0072fd49e6924mr12342227ejc.15.1659357983161;
        Mon, 01 Aug 2022 05:46:23 -0700 (PDT)
Received: from localhost.localdomain (p579d80fd.dip0.t-ipconnect.de. [87.157.128.253])
        by smtp.gmail.com with ESMTPSA id ay24-20020a056402203800b0043d3e06519fsm4393386edb.57.2022.08.01.05.46.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 05:46:22 -0700 (PDT)
From:   Kleber Sacilotto de Souza <kleber.souza@canonical.com>
To:     linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Justin Iurman <justin.iurman@uliege.be>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>
Subject: [RESEND PATCH] selftests: net: fix IOAM test skip return code
Date:   Mon,  1 Aug 2022 14:46:15 +0200
Message-Id: <20220801124615.256416-1-kleber.souza@canonical.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ioam6.sh test script exits with an error code (1) when tests are
skipped due to lack of support from userspace/kernel or not enough
permissions. It should return the kselftests SKIP code instead.

Reviewed-by: Justin Iurman <justin.iurman@uliege.be>
Signed-off-by: Kleber Sacilotto de Souza <kleber.souza@canonical.com>
---

Notes:
    - Reposting to CC netdev@
    - Keeping Justin's Review tag from the original post

 tools/testing/selftests/net/ioam6.sh | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/net/ioam6.sh b/tools/testing/selftests/net/ioam6.sh
index a2b9fad5a9a6..4ceb401da1bf 100755
--- a/tools/testing/selftests/net/ioam6.sh
+++ b/tools/testing/selftests/net/ioam6.sh
@@ -117,6 +117,8 @@
 #        | Schema Data         |                                     |
 #        +-----------------------------------------------------------+
 
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
 
 ################################################################################
 #                                                                              #
@@ -211,7 +213,7 @@ check_kernel_compatibility()
     echo "SKIP: kernel version probably too old, missing ioam support"
     ip link del veth0 2>/dev/null || true
     ip netns del ioam-tmp-node || true
-    exit 1
+    exit $ksft_skip
   fi
 
   ip -netns ioam-tmp-node route add db02::/64 encap ioam6 mode inline \
@@ -227,7 +229,7 @@ check_kernel_compatibility()
          "without CONFIG_IPV6_IOAM6_LWTUNNEL?"
     ip link del veth0 2>/dev/null || true
     ip netns del ioam-tmp-node || true
-    exit 1
+    exit $ksft_skip
   fi
 
   ip link del veth0 2>/dev/null || true
@@ -752,20 +754,20 @@ nfailed=0
 if [ "$(id -u)" -ne 0 ]
 then
   echo "SKIP: Need root privileges"
-  exit 1
+  exit $ksft_skip
 fi
 
 if [ ! -x "$(command -v ip)" ]
 then
   echo "SKIP: Could not run test without ip tool"
-  exit 1
+  exit $ksft_skip
 fi
 
 ip ioam &>/dev/null
 if [ $? = 1 ]
 then
   echo "SKIP: iproute2 too old, missing ioam command"
-  exit 1
+  exit $ksft_skip
 fi
 
 check_kernel_compatibility
-- 
2.34.1

