Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0C42ADD89
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 18:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgKJR5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 12:57:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbgKJR5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 12:57:54 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB467C0613CF;
        Tue, 10 Nov 2020 09:57:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=+zDhF1cewRznQmMlaJBM+aYh5OG2sBHH1iv62Jq/+Vg=; b=cmrWa9DhioliTzHETvj9OnEx0c
        DuTZFUZGoIfxv25piFaT978APx/JY1ZzalHy6pLF562oPnH5K8YDBGw9YWqJJPI0rPfhHVUFnmvx8
        IZdksGnD2V9h2VaoU2b2NNY6FCYkcpREfc80t/jKtzFoH+p10cjuo/l8HS2zQLT1Ymd2hr5Mkr6UH
        jwqn9WPmZ8v1+9WpmOCt68uTe63f/0q/J1VzlopFNODxlDTLFR95q7EjbI38dZSvBW0sqHgok4JOO
        g3mJ4sVDPG52XXPt5MD5KL6yOPGYcr9KCD5WN694WU5KDG7p40GTLsOqbRSNNaIw5q4hDf3XK8iL8
        qoi4mgHw==;
Received: from [2601:1c0:6280:3f0::662d] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kcXtv-0008Ot-Ez; Tue, 10 Nov 2020 17:57:52 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Aleksandr Nogikh <nogikh@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-next@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next] net: kcov: don't select SKB_EXTENSIONS when there is no NET
Date:   Tue, 10 Nov 2020 09:57:46 -0800
Message-Id: <20201110175746.11437-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix kconfig warning when CONFIG_NET is not set/enabled:

WARNING: unmet direct dependencies detected for SKB_EXTENSIONS
  Depends on [n]: NET [=n]
  Selected by [y]:
  - KCOV [=y] && ARCH_HAS_KCOV [=y] && (CC_HAS_SANCOV_TRACE_PC [=y] || GCC_PLUGINS [=n])

Fixes: 6370cc3bbd8a ("net: add kcov handle to skb extensions")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Aleksandr Nogikh <nogikh@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-next@vger.kernel.org
Cc: netdev@vger.kernel.org
---
This is from linux-next. I'm only guessing that it is in net-next.

 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20201110.orig/lib/Kconfig.debug
+++ linux-next-20201110/lib/Kconfig.debug
@@ -1874,7 +1874,7 @@ config KCOV
 	depends on CC_HAS_SANCOV_TRACE_PC || GCC_PLUGINS
 	select DEBUG_FS
 	select GCC_PLUGIN_SANCOV if !CC_HAS_SANCOV_TRACE_PC
-	select SKB_EXTENSIONS
+	select SKB_EXTENSIONS if NET
 	help
 	  KCOV exposes kernel code coverage information in a form suitable
 	  for coverage-guided fuzzing (randomized testing).
