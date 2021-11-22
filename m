Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D28B458AB8
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 09:49:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238952AbhKVIwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 03:52:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239038AbhKVIws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 03:52:48 -0500
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AAD3C061748;
        Mon, 22 Nov 2021 00:49:40 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1637570978;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=wLy8KC+AAJA86hkKGngN4HL1h4W8gXZ6cLhix4WtbhM=;
        b=IMGtcTmrQ22dZBUmyfWqek+kaVaywxeRf8nzqMKQ8vo+t7k+y02TO37zKgla8oFqeNw30c
        gB4DoHWzNwdfmqlUX69RCVOxyr8YTJhyEuJrvfxzBX4eh1W4cF4dUtE6T63x7Wlj1aPSSC
        RFdbA2Rc1FWGBwnOmfeR53A5ZKNN/cw=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH net-next] neighbor: Remove redundant if statement
Date:   Mon, 22 Nov 2021 16:49:09 +0800
Message-Id: <20211122084909.18093-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The if statement already exists in the __neigh_event_send() function,
remove redundant if statement.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 include/net/neighbour.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index 38a0c1d24570..667129827816 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -452,9 +452,7 @@ static inline int neigh_event_send(struct neighbour *neigh, struct sk_buff *skb)
 	
 	if (READ_ONCE(neigh->used) != now)
 		WRITE_ONCE(neigh->used, now);
-	if (!(neigh->nud_state&(NUD_CONNECTED|NUD_DELAY|NUD_PROBE)))
-		return __neigh_event_send(neigh, skb);
-	return 0;
+	return __neigh_event_send(neigh, skb);
 }
 
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
-- 
2.32.0

