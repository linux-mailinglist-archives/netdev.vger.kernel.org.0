Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1B865F9037
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbiJIWWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231279AbiJIWVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:21:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C98E43AE4E;
        Sun,  9 Oct 2022 15:17:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD1A160CA0;
        Sun,  9 Oct 2022 22:16:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F128C433D6;
        Sun,  9 Oct 2022 22:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353798;
        bh=KiZDrteb0ZE7UEogtdroAkU8Iyt31mvEvH6D7iXd7j4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z45KYWJ8x8iYzrPuAnvEDqyuM4ODIWCCDn5HcqXjVFtz+RD5gpBYV4orn7fxk2UTH
         H3A37nWQcXEkCGbRGsA03Sh/Jpilsn+/qUadIVo/9B37PYFuZxcIqg34rPG5ug1p9q
         FfEyUNtqVKRoxfh/7d3PmkdVrW+2ZUvYJMZ+/hzSlEEM6fKl9G8O4piMlQ8+4sgi0c
         LMiAGgD8Mr4LliwZ2fVN+2dFf55++rEcKpp0Pgghq5UJDT/2VszCaC98BaMNsvyD3e
         OlrvXXpaxPDGDn+UQboH1KWXQfxLeV0u7/JIMtsZjJ6JAjx015bTmPQhi6T/FscF7u
         aZHPobGk0pfKA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     GUO Zihua <guozihua@huawei.com>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, olek2@wp.pl,
        yangyingliang@huawei.com, rdunlap@infradead.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 28/73] net: lantiq_etop: Fix return type for implementation of ndo_start_xmit
Date:   Sun,  9 Oct 2022 18:14:06 -0400
Message-Id: <20221009221453.1216158-28-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009221453.1216158-1-sashal@kernel.org>
References: <20221009221453.1216158-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: GUO Zihua <guozihua@huawei.com>

[ Upstream commit c8ef3c94bda0e21123202d057d4a299698fa0ed9 ]

Since Linux now supports CFI, it will be a good idea to fix mismatched
return type for implementation of hooks. Otherwise this might get
cought out by CFI and cause a panic.

ltq_etop_tx() would return either NETDEV_TX_BUSY or NETDEV_TX_OK, so
change the return type to netdev_tx_t directly.

Signed-off-by: GUO Zihua <guozihua@huawei.com>
Link: https://lore.kernel.org/r/20220902081521.59867-1-guozihua@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/lantiq_etop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/lantiq_etop.c b/drivers/net/ethernet/lantiq_etop.c
index 7cedbe1fdfd7..59aab4086dcc 100644
--- a/drivers/net/ethernet/lantiq_etop.c
+++ b/drivers/net/ethernet/lantiq_etop.c
@@ -470,7 +470,7 @@ ltq_etop_stop(struct net_device *dev)
 	return 0;
 }
 
-static int
+static netdev_tx_t
 ltq_etop_tx(struct sk_buff *skb, struct net_device *dev)
 {
 	int queue = skb_get_queue_mapping(skb);
-- 
2.35.1

