Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E386F5E759D
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 10:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbiIWIXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 04:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231182AbiIWIXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 04:23:17 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A89B31162CD
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 01:23:14 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id n15so12325686wrq.5
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 01:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=YFEvJ/RKjhmvlVPLUD3Cqk9u+S3Qsgpvsfy23XmSnT8=;
        b=xuwgSL+k9BKvUq5Y8p/v2zYMDk7y2GvqIomRIidNQzOx4S56/Ekxnkc6dVHnb35d3m
         FbxFvh9Q9N6O10BufFtz6wWSq7TfVFE7lDmk+6OBXvwOUy0DabmgnZGD2CGHWFW8j+se
         UGVXsV2rzNo0/hDOqjK8Un9kxAVp6HiDrmHSdXgj0B0OjnyEX272qtOwlNtH0iJXOn0A
         FIZs5EQKpQ+X4PMVblepFmyWSNyg7lecWw0LQCiy/svdlnplGTCvmo/V9K19eRgcKAOK
         PzPkx0+YGuXXuSCWT6UFlhRNS45BTXv31LK3pYXI1DDnslMFRymHUpdOF4g20qMHxWID
         e1aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=YFEvJ/RKjhmvlVPLUD3Cqk9u+S3Qsgpvsfy23XmSnT8=;
        b=FOk3TrmS9HFI6YhoXFEFtgcETiQiQVMK8CMqjTyt/nE6VL5ak87JeNSwFWUf08b1UI
         3yCPhnkodqY0ZD1K9HiaNzvhPcbObHZAI1vvHf15omWvZ8IBIFFmSYXH34FJWrG13Ior
         AfnXKOdcn96e/A0cvYXdVIzbNqBH8er84dFPIxQlt21FkykEzlcreZwaI7d2h9mMgaE4
         j4tMoRfpK5qrzX3N0TUBYhxYJSvD+55i2gRfv9vDN+4iggEcGPFGOLaVq+6QcPGhpz8/
         25fZig0jzhtf32tZLvnwNrXzkQwmAb/zc7P/ypZT3RHIFcXuUA+LpHmIdWuK83yf0phV
         64Hw==
X-Gm-Message-State: ACrzQf1TDczGZTx9LU/Wqp1aLz77JBd+V9aRrvuvwVdPM3ZcZ2k5JkQv
        AQ6MCyoBxc7qtN6PR4/vj0u4qQ==
X-Google-Smtp-Source: AMsMyM4bdVt3vaj37y8CH/P7NLQGXzQzRL8awhY0FLeSj2zaEFJPEdiaOQkVuExB0hRF7DggvtVypg==
X-Received: by 2002:adf:de8d:0:b0:22a:e4b5:6791 with SMTP id w13-20020adfde8d000000b0022ae4b56791mr4374851wrl.1.1663921393156;
        Fri, 23 Sep 2022 01:23:13 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id bg42-20020a05600c3caa00b003a5f4fccd4asm1844515wmb.35.2022.09.23.01.23.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 01:23:12 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Shuah Khan <shuah@kernel.org>, Jakub Kicinski <kuba@kernel.org>
Cc:     Hangbin Liu <liuhangbin@gmail.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] selftests/bonding: re-add lladdr target test
Date:   Fri, 23 Sep 2022 10:23:06 +0200
Message-Id: <20220923082306.2468081-1-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1406; i=matthieu.baerts@tessares.net;
 h=from:subject; bh=AllAkDq+t+NJ5dCbtr0QN/nvka+ooj6Nxcu0FnWxesc=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBjLWzoxx/J66co0FDhYxhq9FsSjjrCXEGFkOb2abBq
 hmT0snyJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCYy1s6AAKCRD2t4JPQmmgc6UxEA
 DwPzVGAEs0qZ39OvtbkrRh9HJbP+529XBkMuvDjrksZhBN1w5GbIXlnqAGvtg7Zz/0EVvqh7DZk+iO
 7rHxlOmbdfaMCjBRuYM47fkOytV/QJJc9Uq49WknWL4SI0h0TNFvEl1l409TOJuKxK46b2adTEM/eX
 17gX9Lc+c/HhN/4qmJl1STgRf18uR+EuDk7YbckGE1d0sHxVggRy0GAJz71HUBo2bYG9vGKqMJ0LMv
 MkEGAGRUrcSK5XCtSUvZOfKBZrTvpw7OQhzs7sUXKc7qBAG5oMiGlERdpOTIRHrJBk5CA1D5GebYBU
 DwqjcUmRbz0Y50S746rDADEsxmE6yRosb47wSd0bfF9FzMLQjE490jF6dO1PwW8Qb77uUrIrlI3ccm
 QStkcpFapGa0cCAcp9IDhO9Az9vIBv8Sk+sReGkHyqcEqhQi5KsyPDuKOyn194/iN8IW+GVM7PKbf8
 JRPbg+/TFu8JC6aes8EmN39bxGjhliRpPMn4MLYM6kM14z3e2JcCUi4Nh3re81hhFFLqOJETpoNXCU
 bBHKJuQBPNrgJLa18e+NQoI2kXiQZ+3ulIboieNfDSXX9yLsQks1RxwVsizWSk+DadvFKeLwuMK0oB
 1nrwbdJ1IOlkvKKXR6YhPVP0fFm0fgBoWzEfOJJonEeSx4iV7hzEeKqYqpsA==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp; fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It looks like this test has been accidentally dropped when resolving
conflicts in this Makefile.

Most probably because there were 3 different patches modifying this file
in parallel:

  commit 152e8ec77640 ("selftests/bonding: add a test for bonding lladdr target")
  commit bbb774d921e2 ("net: Add tests for bonding and team address list management")
  commit 2ffd57327ff1 ("selftests: bonding: cause oops in bond_rr_gen_slave_id")

The first one was applied in 'net-next' while the two other ones were
recently applied in the 'net' tree.

But that's alright, easy to fix by re-adding the missing one!

Fixes: 0140a7168f8b ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net")
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 tools/testing/selftests/drivers/net/bonding/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/drivers/net/bonding/Makefile b/tools/testing/selftests/drivers/net/bonding/Makefile
index d14846fcf3d1..e9dab5f9d773 100644
--- a/tools/testing/selftests/drivers/net/bonding/Makefile
+++ b/tools/testing/selftests/drivers/net/bonding/Makefile
@@ -4,6 +4,7 @@
 TEST_PROGS := \
 	bond-arp-interval-causes-panic.sh \
 	bond-break-lacpdu-tx.sh \
+	bond-lladdr-target.sh \
 	dev_addr_lists.sh
 
 TEST_FILES := lag_lib.sh

base-commit: d05d9eb79d0cd0f7a978621b4a56a1f2db444f86
-- 
2.37.2

