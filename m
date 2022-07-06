Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB65A568220
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 10:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbiGFIxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 04:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbiGFIxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 04:53:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9951031
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 01:53:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4CE361982
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 08:53:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB63BC3411C;
        Wed,  6 Jul 2022 08:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657097603;
        bh=yjuzLjU/h/GeFnQv04wH2hwMrCaxWGVVryFGtKPZSR4=;
        h=From:To:Cc:Subject:Date:From;
        b=LoDdrGsV/9ihCVLBZdvB6IXcmd5kBmlu91Zw9RqdDOjZE2T9h0/7kKaJVE/HS4o4F
         p7bQVwb9yuAQA8rH1BWt5AjydkHDK7Q75kaRcOJX6Wo5GphWIkdVwRmriKZAk+RYro
         XRQmPP/4UgcvZ742vXrNeJ0SKDC+HODnOXVLBVaodlnE2+U8tepjg6mvSYc/6yHq7b
         WWwVWMLJbQuE8h+rTVnzGdlubra0r/Do1+r+CovhTepjKylmmA21GKepZ11yd67k2O
         d1tBW0VGdF/iyr+OBWBiAMENsInzv8no4sBRL2HZ+05LBIGHtuhAFnn5asCerm4Gmf
         XyuxyW9nIueRA==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next] Documentation: add a description for net.core.high_order_alloc_disable
Date:   Wed,  6 Jul 2022 10:53:20 +0200
Message-Id: <20220706085320.17581-1-atenart@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A description is missing for the net.core.high_order_alloc_disable
option in admin-guide/sysctl/net.rst ; add it. The above sysctl option
was introduced by commit ce27ec60648d ("net: add high_order_alloc_disable
sysctl/static key").

Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 Documentation/admin-guide/sysctl/net.rst | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
index fcd650bdbc7e..85ab83411359 100644
--- a/Documentation/admin-guide/sysctl/net.rst
+++ b/Documentation/admin-guide/sysctl/net.rst
@@ -391,6 +391,16 @@ GRO has decided not to coalesce, it is placed on a per-NAPI list. This
 list is then passed to the stack when the number of segments reaches the
 gro_normal_batch limit.
 
+high_order_alloc_disable
+------------------------
+
+By default the allocator for page frags tries to use high order pages (order-3
+on x86). While the default behavior gives good results in most cases, some users
+might hit a contention in page allocations/freeing. This allows to opt-in for
+order-0 allocation instead.
+
+Default: 0
+
 2. /proc/sys/net/unix - Parameters for Unix domain sockets
 ----------------------------------------------------------
 
-- 
2.36.1

