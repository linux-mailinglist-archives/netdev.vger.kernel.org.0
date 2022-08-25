Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6B385A06D2
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 03:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236420AbiHYBr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 21:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235830AbiHYBrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 21:47:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C1B9CCF4;
        Wed, 24 Aug 2022 18:41:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCFB061AEC;
        Thu, 25 Aug 2022 01:40:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8063C433D6;
        Thu, 25 Aug 2022 01:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661391640;
        bh=OhiCheoA+yiXdAopqj9Zlyv1wWQsfEjgr6m1eBF4ka0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GJTpWWlSocc2Lz1OPkVKYpZ1HPV1wzcTyGQFz6qU7tzdoub1i2UGCE8LYpSTGv17u
         gZWMCOPSWISClOsySJb9dWtBy65zXypENDrYR458HFaukOoit39yc92qLhcBDZ6rdT
         bHuiBKJiHoU1Y3vdSaYohQqh98dSmVd2KelAOQIdNFEWQ3OFLG+vXdZazBFT5/onEn
         AwTtn20FWeyLMoB4uil2/mm94ljZ6h2CslrH8ZTF6Ad6Mtm9ZzLdqNNc30FP/1vWFL
         9Yzaw2vVT4DdMTr9gbdO9e/SKFzAHc1AIh5jRsdNJFbaoEmn8JHwahWMpP97/ml69u
         jhzIVgXqGQiaA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Florian Westphal <fw@strlen.de>,
        Sasha Levin <sashal@kernel.org>, pablo@netfilter.org,
        kadlec@netfilter.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 2/3] netfilter: conntrack: NF_CONNTRACK_PROCFS should no longer default to y
Date:   Wed, 24 Aug 2022 21:40:31 -0400
Message-Id: <20220825014035.24239-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220825014035.24239-1-sashal@kernel.org>
References: <20220825014035.24239-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit aa5762c34213aba7a72dc58e70601370805fa794 ]

NF_CONNTRACK_PROCFS was marked obsolete in commit 54b07dca68557b09
("netfilter: provide config option to disable ancient procfs parts") in
v3.3.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index dacd2d34a790..f7cc20641b09 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -96,7 +96,6 @@ config NF_CONNTRACK_ZONES
 
 config NF_CONNTRACK_PROCFS
 	bool "Supply CT list in procfs (OBSOLETE)"
-	default y
 	depends on PROC_FS
 	---help---
 	This option enables for the list of known conntrack entries
-- 
2.35.1

