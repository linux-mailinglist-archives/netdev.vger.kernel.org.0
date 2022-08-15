Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71FBE59512C
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 06:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232209AbiHPEwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 00:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233761AbiHPEvt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 00:51:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9324B17CFA7;
        Mon, 15 Aug 2022 13:49:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED91E6128E;
        Mon, 15 Aug 2022 20:49:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0BF5C433D6;
        Mon, 15 Aug 2022 20:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596550;
        bh=ZVE2RNHPOttuDHZ2xX2gbbcEhpFNhv9Nt5X6GeRZKSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cUkQtYIDzoOpYCzOKmbhgMMr5vl7QPNPhlItf34lzDhv3ryYDyHMbmMReGhlQxrlt
         km1KxFYXliLYUSXFtaeoQdZBkvfhgLipR378qM8LbRtoF+QmmIoayMDuE0h3p97vPz
         SDJtrzo9rjBMTHQcUKQn+1aJCbKC8ENgEPUVl0z8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Lindner <mareklindner@neomailbox.ch>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <a@unstable.cc>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        Sven Eckelmann <sven@narfation.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 1114/1157] batman-adv: tracing: Use the new __vstring() helper
Date:   Mon, 15 Aug 2022 20:07:50 +0200
Message-Id: <20220815180524.874593378@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Steven Rostedt (Google) <rostedt@goodmis.org>

[ Upstream commit 9abc291812d784bd4a26c01af4ebdbf9f2dbf0bb ]

Instead of open coding a __dynamic_array() with a fixed length (which
defeats the purpose of the dynamic array in the first place). Use the new
__vstring() helper that will use a va_list and only write enough of the
string into the ring buffer that is needed.

Link: https://lkml.kernel.org/r/20220724191650.236b1355@rorschach.local.home

Cc: Marek Lindner <mareklindner@neomailbox.ch>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Simon Wunderlich <sw@simonwunderlich.de>
Cc: Antonio Quartulli <a@unstable.cc>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: b.a.t.m.a.n@lists.open-mesh.org
Cc: netdev@vger.kernel.org
Acked-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/trace.h | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/net/batman-adv/trace.h b/net/batman-adv/trace.h
index d673ebdd0426..31c8f922651d 100644
--- a/net/batman-adv/trace.h
+++ b/net/batman-adv/trace.h
@@ -28,8 +28,6 @@
 
 #endif /* CONFIG_BATMAN_ADV_TRACING */
 
-#define BATADV_MAX_MSG_LEN	256
-
 TRACE_EVENT(batadv_dbg,
 
 	    TP_PROTO(struct batadv_priv *bat_priv,
@@ -40,16 +38,13 @@ TRACE_EVENT(batadv_dbg,
 	    TP_STRUCT__entry(
 		    __string(device, bat_priv->soft_iface->name)
 		    __string(driver, KBUILD_MODNAME)
-		    __dynamic_array(char, msg, BATADV_MAX_MSG_LEN)
+		    __vstring(msg, vaf->fmt, vaf->va)
 	    ),
 
 	    TP_fast_assign(
 		    __assign_str(device, bat_priv->soft_iface->name);
 		    __assign_str(driver, KBUILD_MODNAME);
-		    WARN_ON_ONCE(vsnprintf(__get_dynamic_array(msg),
-					   BATADV_MAX_MSG_LEN,
-					   vaf->fmt,
-					   *vaf->va) >= BATADV_MAX_MSG_LEN);
+		    __assign_vstr(msg, vaf->fmt, vaf->va);
 	    ),
 
 	    TP_printk(
-- 
2.35.1



