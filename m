Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8E6A6417E7
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 17:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiLCQvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 11:51:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbiLCQvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 11:51:42 -0500
Received: from smtp.smtpout.orange.fr (smtp-22.smtpout.orange.fr [80.12.242.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8840E2126E
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 08:51:10 -0800 (PST)
Received: from pop-os.home ([86.243.100.34])
        by smtp.orange.fr with ESMTPA
        id 1VjGpuTflbw2u1VjGpvypk; Sat, 03 Dec 2022 17:51:08 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 03 Dec 2022 17:51:08 +0100
X-ME-IP: 86.243.100.34
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH] net: xsk: Don't include <linux/rculist.h>
Date:   Sat,  3 Dec 2022 17:51:04 +0100
Message-Id: <88d6a1d88764cca328610854f890a9ca1f4b029e.1670086246.git.christophe.jaillet@wanadoo.fr>
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
 include/net/netns/xdp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/netns/xdp.h b/include/net/netns/xdp.h
index e5734261ba0a..21a4f25a187a 100644
--- a/include/net/netns/xdp.h
+++ b/include/net/netns/xdp.h
@@ -2,8 +2,8 @@
 #ifndef __NETNS_XDP_H__
 #define __NETNS_XDP_H__
 
-#include <linux/rculist.h>
 #include <linux/mutex.h>
+#include <linux/types.h>
 
 struct netns_xdp {
 	struct mutex		lock;
-- 
2.34.1

