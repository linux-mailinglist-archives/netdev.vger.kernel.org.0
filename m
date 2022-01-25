Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99CE749AC37
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 07:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233223AbiAYGRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 01:17:49 -0500
Received: from pi.codeconstruct.com.au ([203.29.241.158]:53270 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343996AbiAYGEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 01:04:24 -0500
Received: by codeconstruct.com.au (Postfix, from userid 10001)
        id 9C7F0202F7; Tue, 25 Jan 2022 14:04:16 +0800 (AWST)
From:   Matt Johnston <matt@codeconstruct.com.au>
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        cake@lists.bufferbloat.net
Subject: [PATCH net] sch_cake: diffserv8 CS1 should be bulk
Date:   Tue, 25 Jan 2022 14:04:10 +0800
Message-Id: <20220125060410.2691029-1-matt@codeconstruct.com.au>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The CS1 priority (index 0x08) was changed from 0 to 1 when LE (index
0x01) was added. This looks unintentional, it doesn't match the
docs and CS1 shouldn't be the same tin as AF1x

Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
Fixes: b8392808eb3f ("sch_cake: add RFC 8622 LE PHB support to CAKE diffserv handling")
---
 net/sched/sch_cake.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 857aaebd49f4..6ff2ddc5b812 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -313,7 +313,7 @@ static const u8 precedence[] = {
 
 static const u8 diffserv8[] = {
 	2, 0, 1, 2, 4, 2, 2, 2,
-	1, 2, 1, 2, 1, 2, 1, 2,
+	0, 2, 1, 2, 1, 2, 1, 2,
 	5, 2, 4, 2, 4, 2, 4, 2,
 	3, 2, 3, 2, 3, 2, 3, 2,
 	6, 2, 3, 2, 3, 2, 3, 2,
-- 
2.32.0

