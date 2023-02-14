Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF2F6957F0
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 05:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbjBNEdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 23:33:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjBNEdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 23:33:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4863355BB
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 20:32:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E93B6B81ABD
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 04:32:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C068C433EF;
        Tue, 14 Feb 2023 04:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676349171;
        bh=BijJwkqqWvwFxD+1Ifbtl4fwdFooOplhVtsLyOLcx+I=;
        h=From:To:Cc:Subject:Date:From;
        b=LTnE7+kxGdBTcBe55ZIcRm0SKSZeIUd8hMdbDPTn2KQPTj/9+2n64I2A5eAPqJLMi
         qAvLf8J/5enEKEFL7z1jWONhwC75zhOf20D0QPLrFBKwt1qCy4dw0NYZd/OQLxpX3T
         46Q5Lu/BOCJu/pIVGq5BuLabkqs0N1BOO34lCV+Fk2uwVQqqSJ8BdNKQk0FEN1Makm
         ei6SCADyGuwSFAFsj7pgKXPYvodjjt+OqpRfA+ElF/igB2F1Ef7Z4mPX1o0aXlplH6
         Mme4/MZ76yr2PUzBMHPSy9/bu0vzinu38hzxbgL++1Hbpmh3fJBYm+HP9zQvg9n9rJ
         cGn05nlgFLMrA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH net-next] netlink-specs: add rx-push to ethtool family
Date:   Mon, 13 Feb 2023 20:32:46 -0800
Message-Id: <20230214043246.230518-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 5b4e9a7a71ab ("net: ethtool: extend ringparam set/get APIs for rx_push")
added a new attr for configuring rx-push, right after tx-push.
Add it to the spec, the ring param operation is covered by
the otherwise sparse ethtool spec.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
Cc: Shannon Nelson <shannon.nelson@amd.com>
---
 Documentation/netlink/specs/ethtool.yaml | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/netlink/specs/ethtool.yaml b/Documentation/netlink/specs/ethtool.yaml
index 82f4e6f8ddd3..08b776908d15 100644
--- a/Documentation/netlink/specs/ethtool.yaml
+++ b/Documentation/netlink/specs/ethtool.yaml
@@ -171,6 +171,9 @@ doc: Partial family for Ethtool Netlink.
       -
         name: tx-push
         type: u8
+      -
+        name: rx-push
+        type: u8
 
   -
     name: mm-stat
@@ -320,6 +323,7 @@ doc: Partial family for Ethtool Netlink.
             - tcp-data-split
             - cqe-size
             - tx-push
+            - rx-push
       dump: *ring-get-op
     -
       name: rings-set
@@ -339,6 +343,7 @@ doc: Partial family for Ethtool Netlink.
             - tcp-data-split
             - cqe-size
             - tx-push
+            - rx-push
     -
       name: rings-ntf
       doc: Notification for change in ring params.
-- 
2.39.1

