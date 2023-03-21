Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8986C29D6
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 06:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjCUF1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 01:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjCUF1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 01:27:12 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 099B2135;
        Mon, 20 Mar 2023 22:27:01 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 0662D5C00BE;
        Tue, 21 Mar 2023 01:26:58 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 21 Mar 2023 01:26:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:message-id:reply-to:sender
        :subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm2; t=1679376418; x=1679462818; bh=X
        4DAieLlRVUgBOIkUGiEOjKixLtPs6G2ZgCs8Z+IwsE=; b=sooniVB5OehRJc1uK
        xO+5BdBUlN1fcRliRtxn3qj00aTKO08UXhDavrjsBDFMMaN++lFEmK07FBgCpwI5
        xu/Fmid9fl84PqodV/rJGQZpBnOAMQKMOoz9NN0jWJFzPTkIM3mWlHUHeeextCRT
        EzOmacKmqAIes9hfzchuFBirJnqI/LujxO55JZjDUbUBJx79Ls+O6tKs+pMNo8+7
        QEcrUkERgkxAToQykgnJsGMb1a0xY7WlTXHXHPa8OObhKVyvmd8nDoU/urfRW7iL
        51oBj3c/gS0b+CSM1vLE9alHUZetR7ZCVLG+g2Mgk03EegWaKtQRpp9KBrH3jLN8
        tTgng==
X-ME-Sender: <xms:IUAZZPSiIWC8Hf_XJlO8j2BO5vaGJNB-5izCqLFMjgkdW3632iUisg>
    <xme:IUAZZAy2nz-PLPstWeIEpMi4hDIzC9AjJsWx7fuzsZxz0_JyUWOUebXoKMVyj0dab
    _P_U5BhNUwOVzatBzo>
X-ME-Received: <xmr:IUAZZE2j_8ZK3TRYgFZIG3bAywkESvt_uRNtIk3O_gVt5V04J52DvkMheSI-NGHSHQUvMenN8aTIZUkcKkgcClJauyzKP-XaDOo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdefledgjeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepvfevkffhufffsedttdertddttddtnecuhfhrohhmpefhihhnnhcuvfhhrghi
    nhcuoehfthhhrghinheslhhinhhugidqmheikehkrdhorhhgqeenucggtffrrghtthgvrh
    hnpeehfffggeefveegvedtiefffeevuedtgefhueehieetffejfefggeevfeeuvdduleen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehfthhhrg
    hinheslhhinhhugidqmheikehkrdhorhhg
X-ME-Proxy: <xmx:IUAZZPAhb_1an8FT3rFIM137ms8aftnaok_xhPJAUQkMNS_w0N6Y7g>
    <xmx:IUAZZIjXUmYdYva6Uxu6jdy5vAiHK-X2sqI5Dbt7_uiwtCzcIhREIg>
    <xmx:IUAZZDqRMCG-NFgKdmv-PT_sKQT2gaO7dNARHBH0tZ5hVUHyLE-0Zg>
    <xmx:IkAZZCbw77PjlRC3DIFBCLUneehOELB206RaLz0myADoB65gMjqvaw>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 21 Mar 2023 01:26:55 -0400 (EDT)
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Changzhong <zhangchangzhong@huawei.com>
Message-Id: <6645a4b5c1e364312103f48b7b36783b94e197a2.1679370343.git.fthain@linux-m68k.org>
From:   Finn Thain <fthain@linux-m68k.org>
Subject: [PATCH v2 net] net/sonic: use dma_mapping_error() for error check
Date:   Tue, 21 Mar 2023 14:45:43 +1100
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

The DMA address returned by dma_map_single() should be checked with
dma_mapping_error(). Fix it accordingly.

Fixes: efcce839360f ("[PATCH] macsonic/jazzsonic network drivers update")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
---
This was originally Zhang Changzhong's patch. I've just added the missing
curly bracket which caused a build failure when the patch was first posted.
---
 drivers/net/ethernet/natsemi/sonic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/sonic.c b/drivers/net/ethernet/natsemi/sonic.c
index d17d1b4f2585..825356ee3492 100644
--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -292,7 +292,7 @@ static int sonic_send_packet(struct sk_buff *skb, struct net_device *dev)
 	 */
 
 	laddr = dma_map_single(lp->device, skb->data, length, DMA_TO_DEVICE);
-	if (!laddr) {
+	if (dma_mapping_error(lp->device, laddr)) {
 		pr_err_ratelimited("%s: failed to map tx DMA buffer.\n", dev->name);
 		dev_kfree_skb_any(skb);
 		return NETDEV_TX_OK;
@@ -509,7 +509,7 @@ static bool sonic_alloc_rb(struct net_device *dev, struct sonic_local *lp,
 
 	*new_addr = dma_map_single(lp->device, skb_put(*new_skb, SONIC_RBSIZE),
 				   SONIC_RBSIZE, DMA_FROM_DEVICE);
-	if (!*new_addr) {
+	if (dma_mapping_error(lp->device, *new_addr)) {
 		dev_kfree_skb(*new_skb);
 		*new_skb = NULL;
 		return false;
-- 
2.37.5

