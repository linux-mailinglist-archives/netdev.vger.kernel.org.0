Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8864B02AC
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 03:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233875AbiBJB7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 20:59:36 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:60356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233647AbiBJB7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 20:59:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2478D2A9;
        Wed,  9 Feb 2022 17:56:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AD5E616E7;
        Thu, 10 Feb 2022 00:36:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC46FC340F3;
        Thu, 10 Feb 2022 00:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644453416;
        bh=0Zcn2spP+v1l17CzmNikMsabblPByh6KQmSW1yNBd9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YswJp/6BhLwFcSve95j+nFsLSJ4kWGcS+ZwB2np2OybLUMxuq1Lx94EjWJDn4A0YQ
         uf45OzfjQCa/7q9gm47mKwy6B5LRyH5civM58VWSgWriiC568i7p3719xMfq+LL60V
         +2d9VF5va0MG05whcyxEe/2luTQXA0a80p6VFYgCsh/4iY5/ABzc59yVUs06Xt/u2P
         +kjWNzhR7xqGCdxdeE2ao4Q6r3vzrnVR8ka0QXl33Liu/a+nDcsIAh1U+2n8FQOj4e
         FcFyyFxGzGoOZ7SCR7es2QgfjX826JW6Qk5GLr7boX9kFUF1iCr/eXFuFg00LE05WA
         94TKWY9iTpOuw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, willemb@google.com, lorenzo@google.com,
        maze@google.com, dsahern@kernel.org, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, linux-kselftest@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 04/11] selftests: net: rename cmsg_so_mark
Date:   Wed,  9 Feb 2022 16:36:42 -0800
Message-Id: <20220210003649.3120861-5-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220210003649.3120861-1-kuba@kernel.org>
References: <20220210003649.3120861-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename the file in prep for generalization.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/testing/selftests/net/.gitignore                    | 2 +-
 tools/testing/selftests/net/Makefile                      | 2 +-
 .../selftests/net/{cmsg_so_mark.c => cmsg_sender.c}       | 0
 tools/testing/selftests/net/cmsg_so_mark.sh               | 8 ++++----
 4 files changed, 6 insertions(+), 6 deletions(-)
 rename tools/testing/selftests/net/{cmsg_so_mark.c => cmsg_sender.c} (100%)

diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
index 7581a7348e1b..21a411b04890 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -35,4 +35,4 @@ test_unix_oob
 gro
 ioam6_parser
 toeplitz
-cmsg_so_mark
+cmsg_sender
diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 9897fa9ab953..8f4c1f16655f 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -52,7 +52,7 @@ TEST_GEN_FILES += gro
 TEST_GEN_PROGS = reuseport_bpf reuseport_bpf_cpu reuseport_bpf_numa
 TEST_GEN_PROGS += reuseport_dualstack reuseaddr_conflict tls
 TEST_GEN_FILES += toeplitz
-TEST_GEN_FILES += cmsg_so_mark
+TEST_GEN_FILES += cmsg_sender
 
 TEST_FILES := settings
 
diff --git a/tools/testing/selftests/net/cmsg_so_mark.c b/tools/testing/selftests/net/cmsg_sender.c
similarity index 100%
rename from tools/testing/selftests/net/cmsg_so_mark.c
rename to tools/testing/selftests/net/cmsg_sender.c
diff --git a/tools/testing/selftests/net/cmsg_so_mark.sh b/tools/testing/selftests/net/cmsg_so_mark.sh
index 19c6aab8d0e9..29a623aac74b 100755
--- a/tools/testing/selftests/net/cmsg_so_mark.sh
+++ b/tools/testing/selftests/net/cmsg_so_mark.sh
@@ -41,14 +41,14 @@ check_result() {
     fi
 }
 
-ip netns exec $NS ./cmsg_so_mark $TGT4 1234 $((MARK + 1))
+ip netns exec $NS ./cmsg_sender $TGT4 1234 $((MARK + 1))
 check_result $? 0 "IPv4 pass"
-ip netns exec $NS ./cmsg_so_mark $TGT6 1234 $((MARK + 1))
+ip netns exec $NS ./cmsg_sender $TGT6 1234 $((MARK + 1))
 check_result $? 0 "IPv6 pass"
 
-ip netns exec $NS ./cmsg_so_mark $TGT4 1234 $MARK
+ip netns exec $NS ./cmsg_sender $TGT4 1234 $MARK
 check_result $? 1 "IPv4 rejection"
-ip netns exec $NS ./cmsg_so_mark $TGT6 1234 $MARK
+ip netns exec $NS ./cmsg_sender $TGT6 1234 $MARK
 check_result $? 1 "IPv6 rejection"
 
 # Summary
-- 
2.34.1

