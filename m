Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4596A628FBF
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 03:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbiKOCHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 21:07:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232202AbiKOCHN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 21:07:13 -0500
Received: from mail.nfschina.com (unknown [124.16.136.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AEE121A05B;
        Mon, 14 Nov 2022 18:07:10 -0800 (PST)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id E6C661E80DB8;
        Tue, 15 Nov 2022 10:04:12 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id y99CiAy1pngm; Tue, 15 Nov 2022 10:04:10 +0800 (CST)
Received: from localhost.localdomain (unknown [219.141.250.2])
        (Authenticated sender: zeming@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 2DDD61E80DB4;
        Tue, 15 Nov 2022 10:04:10 +0800 (CST)
From:   Li zeming <zeming@nfschina.com>
To:     vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Li zeming <zeming@nfschina.com>
Subject: [PATCH] sctp: sm_statefuns: Remove pointer casts of the same type
Date:   Tue, 15 Nov 2022 10:07:05 +0800
Message-Id: <20221115020705.3220-1-zeming@nfschina.com>
X-Mailer: git-send-email 2.18.2
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,MAY_BE_FORGED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The subh.addip_hdr pointer is also of type (struct sctp_addiphdr *), so
it does not require a cast.

Signed-off-by: Li zeming <zeming@nfschina.com>
---
 net/sctp/sm_statefuns.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 714605746fee..fa9c61d3000f 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -4044,7 +4044,7 @@ enum sctp_disposition sctp_sf_do_asconf_ack(struct net *net,
 			   (void *)err_param, commands);
 
 	if (last_asconf) {
-		addip_hdr = (struct sctp_addiphdr *)last_asconf->subh.addip_hdr;
+		addip_hdr = last_asconf->subh.addip_hdr;
 		sent_serial = ntohl(addip_hdr->serial);
 	} else {
 		sent_serial = asoc->addip_serial - 1;
-- 
2.18.2

