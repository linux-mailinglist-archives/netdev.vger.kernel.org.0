Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34D5F672D7A
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 01:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbjASAgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 19:36:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbjASAgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 19:36:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE05F5FD75;
        Wed, 18 Jan 2023 16:36:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C0AB61B03;
        Thu, 19 Jan 2023 00:36:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B93C433F1;
        Thu, 19 Jan 2023 00:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674088583;
        bh=h9E1z2xP1unAfF5G4j1pRm4zgMwWY/epRKl25o0Z7ds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tLAI/2ZM7GPNLHOR0lnSEsluZBt67/AkWz9aJDW4NK0p/fR31N8NaQOD39vsCzTqx
         1wvrAPUKonrLlEY4zSaYQEKoPtXVd+Eu4LKnVMHpdwCoQ/gYPuVJ1NLC2MUXLw0AHx
         f8RUpq4wmRdWguRNjLmxrbaBEX8UOkdVMgVi7tngZdiIyvKq924P6W+G67iCXO1OUl
         cyK78RwDSVwazGXje8qyeqoJr2/5MywjxeeCuyOSEFgTIq5+N1YvR5IKpW6waAtvu1
         oDiDuo40oSeviGa24Jkrqokjo/v7Qhw+E+BOeYgKCJXaWoE+mOweqv9Qb7JeiC/sIB
         SEhzs7hQUvoWA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        robh@kernel.org, johannes@sipsolutions.net,
        stephen@networkplumber.org, ecree.xilinx@gmail.com, sdf@google.com,
        f.fainelli@gmail.com, fw@strlen.de, linux-doc@vger.kernel.org,
        razor@blackwall.org, nicolas.dichtel@6wind.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 6/8] net: fou: rename the source for linking
Date:   Wed, 18 Jan 2023 16:36:11 -0800
Message-Id: <20230119003613.111778-7-kuba@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230119003613.111778-1-kuba@kernel.org>
References: <20230119003613.111778-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We'll need to link two objects together to form the fou module.
This means the source can't be called fou, the build system expects
fou.o to be the combined object.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ipv4/Makefile              | 1 +
 net/ipv4/{fou.c => fou_core.c} | 0
 2 files changed, 1 insertion(+)
 rename net/ipv4/{fou.c => fou_core.c} (100%)

diff --git a/net/ipv4/Makefile b/net/ipv4/Makefile
index af7d2cf490fb..fabbe46897ce 100644
--- a/net/ipv4/Makefile
+++ b/net/ipv4/Makefile
@@ -26,6 +26,7 @@ obj-$(CONFIG_IP_MROUTE) += ipmr.o
 obj-$(CONFIG_IP_MROUTE_COMMON) += ipmr_base.o
 obj-$(CONFIG_NET_IPIP) += ipip.o
 gre-y := gre_demux.o
+fou-y := fou_core.o
 obj-$(CONFIG_NET_FOU) += fou.o
 obj-$(CONFIG_NET_IPGRE_DEMUX) += gre.o
 obj-$(CONFIG_NET_IPGRE) += ip_gre.o
diff --git a/net/ipv4/fou.c b/net/ipv4/fou_core.c
similarity index 100%
rename from net/ipv4/fou.c
rename to net/ipv4/fou_core.c
-- 
2.39.0

