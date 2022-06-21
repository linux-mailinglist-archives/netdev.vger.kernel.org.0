Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20ECD552944
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 04:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243863AbiFUCRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 22:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232192AbiFUCRq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 22:17:46 -0400
Received: from mail.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CBFAD1572E;
        Mon, 20 Jun 2022 19:17:44 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 91E621E80D50;
        Tue, 21 Jun 2022 10:17:45 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id WGOyw6uWBhUX; Tue, 21 Jun 2022 10:17:43 +0800 (CST)
Received: from localhost.localdomain (unknown [180.167.10.98])
        (Authenticated sender: yuzhe@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 6081E1E80D2D;
        Tue, 21 Jun 2022 10:17:42 +0800 (CST)
From:   Yu Zhe <yuzhe@nfschina.com>
To:     ap420073@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        liqiong@nfschina.com, Yu Zhe <yuzhe@nfschina.com>
Subject: [PATCH] amt: remove unnecessary (void*) conversions.
Date:   Tue, 21 Jun 2022 10:16:48 +0800
Message-Id: <20220621021648.2544-1-yuzhe@nfschina.com>
X-Mailer: git-send-email 2.11.0
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

remove unnecessary void* type castings.

Signed-off-by: Yu Zhe <yuzhe@nfschina.com>
---
 drivers/net/amt.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index be2719a3ba70..732f4c0daa73 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -1373,11 +1373,11 @@ static void amt_add_srcs(struct amt_dev *amt, struct amt_tunnel_list *tunnel,
 	int i;
 
 	if (!v6) {
-		igmp_grec = (struct igmpv3_grec *)grec;
+		igmp_grec = grec;
 		nsrcs = ntohs(igmp_grec->grec_nsrcs);
 	} else {
 #if IS_ENABLED(CONFIG_IPV6)
-		mld_grec = (struct mld2_grec *)grec;
+		mld_grec = grec;
 		nsrcs = ntohs(mld_grec->grec_nsrcs);
 #else
 	return;
@@ -1458,11 +1458,11 @@ static void amt_lookup_act_srcs(struct amt_tunnel_list *tunnel,
 	int i, j;
 
 	if (!v6) {
-		igmp_grec = (struct igmpv3_grec *)grec;
+		igmp_grec = grec;
 		nsrcs = ntohs(igmp_grec->grec_nsrcs);
 	} else {
 #if IS_ENABLED(CONFIG_IPV6)
-		mld_grec = (struct mld2_grec *)grec;
+		mld_grec = grec;
 		nsrcs = ntohs(mld_grec->grec_nsrcs);
 #else
 	return;
-- 
2.11.0

