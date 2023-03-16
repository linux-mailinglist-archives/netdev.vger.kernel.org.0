Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD6C6BC568
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 05:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjCPEue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 00:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjCPEuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 00:50:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B09C4193E3
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 21:50:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FDB661ACA
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 04:50:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68FEBC433D2;
        Thu, 16 Mar 2023 04:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678942230;
        bh=KZaXgtgSe0+RoyrgQgTT9f74YqRgQXF8F1919ISvDxc=;
        h=From:To:Cc:Subject:Date:From;
        b=rsi/A48aRu2+bkmd+ZJgRj4Nz2mjKULZYfvfxOWSwwOl/nkyGFDz3AeXLIgOuJF3u
         nmwWKksRwMkuTjIgsncJlD/BDS73SbHw5e2w+ggz6Yr9cYqGv8LmczVjCL3dm1UxTe
         tszcUOiTRSfXRPlV7YyJYH5MR5LG7v2Yn4Dohcm2DheWzam09FJVPh19uJeJ5xWk0x
         R8qVd1l86BVsRBxxI6RnduD4tfs6w3Jq9WEMM+9jp8PxKIf4SJZ2zArbGQweBNrFBj
         4q4NOzlPhS9ldDPFjcj7VsX3OHXLH9FzB19bQUDZkVj935jiJWPl/KISL4XWtkWYGk
         7mqnEF2uSW4zg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] netlink: specs: allow uapi-header in genetlink
Date:   Wed, 15 Mar 2023 21:50:27 -0700
Message-Id: <20230316045027.529083-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
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

Chuck wanted to put the UAPI header in linux/net/ which seems
reasonable, allow genetlink families to choose the location.
It doesn't really matter for non-C-like languages.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/netlink/genetlink-c.yaml      | 2 +-
 Documentation/netlink/genetlink-legacy.yaml | 2 +-
 Documentation/netlink/genetlink.yaml        | 3 +++
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/Documentation/netlink/genetlink-c.yaml b/Documentation/netlink/genetlink-c.yaml
index f082a5ad7cf1..c83643d403b7 100644
--- a/Documentation/netlink/genetlink-c.yaml
+++ b/Documentation/netlink/genetlink-c.yaml
@@ -33,10 +33,10 @@ additionalProperties: False
   protocol:
     description: Schema compatibility level. Default is "genetlink".
     enum: [ genetlink, genetlink-c ]
-  # Start genetlink-c
   uapi-header:
     description: Path to the uAPI header, default is linux/${family-name}.h
     type: string
+  # Start genetlink-c
   c-family-name:
     description: Name of the define for the family name.
     type: string
diff --git a/Documentation/netlink/genetlink-legacy.yaml b/Documentation/netlink/genetlink-legacy.yaml
index c6b8c77f7d12..792875dd7ed1 100644
--- a/Documentation/netlink/genetlink-legacy.yaml
+++ b/Documentation/netlink/genetlink-legacy.yaml
@@ -33,10 +33,10 @@ additionalProperties: False
   protocol:
     description: Schema compatibility level. Default is "genetlink".
     enum: [ genetlink, genetlink-c, genetlink-legacy ] # Trim
-  # Start genetlink-c
   uapi-header:
     description: Path to the uAPI header, default is linux/${family-name}.h
     type: string
+  # Start genetlink-c
   c-family-name:
     description: Name of the define for the family name.
     type: string
diff --git a/Documentation/netlink/genetlink.yaml b/Documentation/netlink/genetlink.yaml
index b2d56ab9e615..8952e84ff207 100644
--- a/Documentation/netlink/genetlink.yaml
+++ b/Documentation/netlink/genetlink.yaml
@@ -33,6 +33,9 @@ additionalProperties: False
   protocol:
     description: Schema compatibility level. Default is "genetlink".
     enum: [ genetlink ]
+  uapi-header:
+    description: Path to the uAPI header, default is linux/${family-name}.h
+    type: string
 
   definitions:
     description: List of type and constant definitions (enums, flags, defines).
-- 
2.39.2

