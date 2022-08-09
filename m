Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9962358E3A8
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 01:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbiHIXUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 19:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiHIXUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 19:20:23 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A152BB0C
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 16:20:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 493B0CE193D
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 23:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74372C433D6;
        Tue,  9 Aug 2022 23:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660087215;
        bh=6BpJKCCv/CadpL3f+bXDBmPBYF1nZH+JIgn9HTCaWMg=;
        h=From:To:Cc:Subject:Date:From;
        b=av4jlk7SDmLTdk4ix6+85A2p6XXsA4ZUyJXslWh2bflVCPZP6+EOEDtpT5VElkCpK
         sc77oyNo2ojqGCuoaaTaGZca1zEK7g8bUaat2pBi79pvG7vRF+7QwhHBzsdRbO8F62
         bhD8qsXTtykAvxFdBObokGibo+1TZAM1+7sqyOWOEeTaw9K8FpFiTknrld8K/Gss3p
         dCCR9LwzQOmOC/ZEOLEhzeM53tHGGgvzMCvOk8eiiCwUjgtjOh2HdhDQGL8Q6n5e71
         sIqfKZk4Xn22kobhnaOx9gs0ANuDzRod0VYsu7v35rDqW+6N7NjaPO9nQKNnT11cNb
         ey1ISyeKU2jMg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        fw@strlen.de, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] net: add missing kdoc for struct genl_multicast_group::flags
Date:   Tue,  9 Aug 2022 16:20:12 -0700
Message-Id: <20220809232012.403730-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Multicast group flags were added in commit 4d54cc32112d ("mptcp: avoid
lock_fast usage in accept path"), but it missed adding the kdoc.

Mention which flags go into that field, and do the same for
op structs.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/genetlink.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/net/genetlink.h b/include/net/genetlink.h
index 7cb3fa8310ed..56a50e1c51b9 100644
--- a/include/net/genetlink.h
+++ b/include/net/genetlink.h
@@ -11,6 +11,7 @@
 /**
  * struct genl_multicast_group - generic netlink multicast group
  * @name: name of the multicast group, names are per-family
+ * @flags: GENL_* flags (%GENL_ADMIN_PERM or %GENL_UNS_ADMIN_PERM)
  */
 struct genl_multicast_group {
 	char			name[GENL_NAMSIZ];
@@ -116,7 +117,7 @@ enum genl_validate_flags {
  * struct genl_small_ops - generic netlink operations (small version)
  * @cmd: command identifier
  * @internal_flags: flags used by the family
- * @flags: flags
+ * @flags: GENL_* flags (%GENL_ADMIN_PERM or %GENL_UNS_ADMIN_PERM)
  * @validate: validation flags from enum genl_validate_flags
  * @doit: standard command callback
  * @dumpit: callback for dumpers
@@ -137,7 +138,7 @@ struct genl_small_ops {
  * struct genl_ops - generic netlink operations
  * @cmd: command identifier
  * @internal_flags: flags used by the family
- * @flags: flags
+ * @flags: GENL_* flags (%GENL_ADMIN_PERM or %GENL_UNS_ADMIN_PERM)
  * @maxattr: maximum number of attributes supported
  * @policy: netlink policy (takes precedence over family policy)
  * @validate: validation flags from enum genl_validate_flags
-- 
2.37.1

