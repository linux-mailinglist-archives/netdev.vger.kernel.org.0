Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7757675C1C
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 18:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbjATRvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 12:51:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbjATRvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 12:51:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C7F09B129;
        Fri, 20 Jan 2023 09:51:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5907B829CB;
        Fri, 20 Jan 2023 17:50:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09441C433A0;
        Fri, 20 Jan 2023 17:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674237054;
        bh=YXiBHwslqYy3GGu9iTllh09zWwI2wvL6HRYbY8dXWac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EmoOi5wk5QSmaox8R8cRsnqRQGmnN/7LrNzNUFBZ+jgiFF3S7NoHp51ayIJeiSIV0
         ZEU4f4pbgD1K3wwrS8qqZUA3ZWtc0v2xFldAgTSyRP9+93KlYh2SZzm1sYrzd+UDZ7
         AmsIwCPePcBYJc8141/QOyTLvZt/SqWGoWX9TJOFLzDZv1C1HG6R5Nu1sEmFp7GiSD
         GudOwXw56WQ/u+kxvzCuLNnufJmykk3X/iW63QXj7U+spmCwTwP3wFT266rT3fLrkP
         60vPzc8hwKi9jr5XVs2z7IHjq51w2FqOZh6M6OLjg6KAnqMJfqz4UiSVQCePemFSfG
         8kAujhZfvjS6A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        robh@kernel.org, johannes@sipsolutions.net,
        stephen@networkplumber.org, ecree.xilinx@gmail.com, sdf@google.com,
        f.fainelli@gmail.com, fw@strlen.de, linux-doc@vger.kernel.org,
        razor@blackwall.org, nicolas.dichtel@6wind.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v4 6/8] net: fou: rename the source for linking
Date:   Fri, 20 Jan 2023 09:50:39 -0800
Message-Id: <20230120175041.342573-7-kuba@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230120175041.342573-1-kuba@kernel.org>
References: <20230120175041.342573-1-kuba@kernel.org>
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

Acked-by: Stanislav Fomichev <sdf@google.com>
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

