Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2196417DD
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 17:49:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbiLCQty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 11:49:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiLCQtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 11:49:53 -0500
Received: from smtp.smtpout.orange.fr (smtp-11.smtpout.orange.fr [80.12.242.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA5E20BC8
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 08:49:50 -0800 (PST)
Received: from pop-os.home ([86.243.100.34])
        by smtp.orange.fr with ESMTPA
        id 1VhypqniCap0Y1VhypzTXS; Sat, 03 Dec 2022 17:49:48 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 03 Dec 2022 17:49:48 +0100
X-ME-IP: 86.243.100.34
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org
Subject: [PATCH] packet: Don't include <linux/rculist.h>
Date:   Sat,  3 Dec 2022 17:49:44 +0100
Message-Id: <adc33d6c7dd01e29c848b9519b6a601219ba6780.1670086158.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no need to include <linux/rculist.h> here.

Prefer the less invasive <linux/types.h> which is needed for 'hlist_head'.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Let see if build-bots agree with me!

Just declaring 'struct mutex' and 'struct hlist_head' would also be an
option.
It would remove the need of any include, but is more likely to break
something.
---
 include/net/netns/packet.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/netns/packet.h b/include/net/netns/packet.h
index aae69bb43cde..74750865df36 100644
--- a/include/net/netns/packet.h
+++ b/include/net/netns/packet.h
@@ -5,8 +5,8 @@
 #ifndef __NETNS_PACKET_H__
 #define __NETNS_PACKET_H__
 
-#include <linux/rculist.h>
 #include <linux/mutex.h>
+#include <linux/types.h>
 
 struct netns_packet {
 	struct mutex		sklist_lock;
-- 
2.34.1

