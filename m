Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5FA34FBD6D
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 15:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346610AbiDKNld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 09:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346606AbiDKNlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 09:41:18 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0209130F
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 06:39:02 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id b21so650809ljf.4
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 06:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=z5/W5d8ndtvXDnyj0JyTra9alKgaGGYDMc0cdYTNV+Y=;
        b=PrNADXRvCHQzEChEPZg2kZj2LmA3yA1kD5ofn6xym7Neu/ROj+Tf88BEBnHcTrX6zN
         QA+RXn7FIQd2kWEQ6ciFFhyLUIJaYhBKJ4HgU31OE6xHtbMkGZrgQioXycEHo5wN21Af
         fW7sXUhV8TThK665pAO8Yg8HmweuI9KaHu/7QTVsOFfZj0NwTfKK1o4UaCmFMLLgO59z
         VYxD1emxfusy5Hutf+hzI6e64uTHPyYv/MDGVwGZZkI98effVZyPQmceUjp8KlRn/UtF
         n6QTT0FCD65iAkEO1MRKAoN+w2NM7HBb4iy4sTXlUB1U26NLYF52XQkiYWYAY0hDSU9s
         l9Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=z5/W5d8ndtvXDnyj0JyTra9alKgaGGYDMc0cdYTNV+Y=;
        b=y42P1/87UJaUhyoxu4R1TQFY3N39aE7Q15BTpBQ4K4kH/QfAIjrU8SFm9F+nCWQyn2
         RtSYtoMz9V/UV3uZ5RZLk2nZDvojrtRmTxHD8SORe8Z1WJrBg+SKfcveZC5oPHyKQrgK
         d/K5EDrBBo68OjjIYn2qCBxF4aGKE+VTjnYa5yVvrIn+mGM6Q80cd2LM8ygRiA9LTghO
         O8q92cpdpvg+9x7wivXyMhBg4MGdYSdVnxAlmPVdsEZJZdtGLXa+QKJXTYZ7Nc0AhcFb
         bBD2AsU/Zp7EVw8G+p7BKvm7tXvk1lSzvV7SuYViyk8UeZsr0WUIa+H+XT3OZlX8cPIL
         iLEg==
X-Gm-Message-State: AOAM531hyfKeSFRJP8SSgCZFfxrMRvKmbzfkfEv/PRFznNpXPB+FW+qp
        AHV+azk9IWJzkkEeLd1Da9o=
X-Google-Smtp-Source: ABdhPJzQsThOV+obcF51ZdbEECKXTvk7EJ2ggIeeWtcSxu+TM3BAO/EUQdy8+lJnQJzoNqN7/S2pCg==
X-Received: by 2002:a2e:b5aa:0:b0:24b:519f:d21f with SMTP id f10-20020a2eb5aa000000b0024b519fd21fmr9949878ljn.35.1649684340759;
        Mon, 11 Apr 2022 06:39:00 -0700 (PDT)
Received: from wbg.labs.westermo.se (h-158-174-22-128.NA.cust.bahnhof.se. [158.174.22.128])
        by smtp.gmail.com with ESMTPSA id p12-20020a056512138c00b0044833f1cd85sm3336847lfa.62.2022.04.11.06.39.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 06:39:00 -0700 (PDT)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joachim Wiberg <troglobit@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH RFC net-next 09/13] selftests: forwarding: rename test groups for next bridge mdb tests
Date:   Mon, 11 Apr 2022 15:38:33 +0200
Message-Id: <20220411133837.318876-10-troglobit@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220411133837.318876-1-troglobit@gmail.com>
References: <20220411133837.318876-1-troglobit@gmail.com>
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

Rename test groups to PASS and FAIL, respectively, for upcoming changes
to test suite.

Signed-off-by: Joachim Wiberg <troglobit@gmail.com>
---
 .../selftests/net/forwarding/bridge_mdb.sh     | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_mdb.sh b/tools/testing/selftests/net/forwarding/bridge_mdb.sh
index b1ba6876dd86..c0b84b7d4364 100755
--- a/tools/testing/selftests/net/forwarding/bridge_mdb.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_mdb.sh
@@ -7,9 +7,15 @@
 ALL_TESTS="mdb_add_del_test"
 NUM_NETIFS=2
 
-TEST_GROUP_IP4="225.1.2.3"
-TEST_GROUP_IP6="ff02::42"
-TEST_GROUP_MAC="01:00:01:c0:ff:ee"
+PASS_GRP_IP4="225.1.2.3"
+FAIL_GRP_IP4="225.1.2.4"
+
+PASS_GRP_MAC="01:00:01:c0:ff:ee"
+FAIL_GRP_MAC="01:00:01:c0:ff:ef"
+
+PASS_GRP_IP6="ff02::42"
+FAIL_GRP_IP6="ff02::43"
+
 
 source lib.sh
 
@@ -88,9 +94,9 @@ do_mdb_add_del()
 
 mdb_add_del_test()
 {
-	do_mdb_add_del $TEST_GROUP_MAC permanent
-	do_mdb_add_del $TEST_GROUP_IP4
-	do_mdb_add_del $TEST_GROUP_IP6
+	do_mdb_add_del $PASS_GRP_MAC permanent
+	do_mdb_add_del $PASS_GRP_IP4
+	do_mdb_add_del $PASS_GRP_IP6
 }
 
 trap cleanup EXIT
-- 
2.25.1

