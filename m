Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE5C14624E
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 08:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbgAWHLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 02:11:23 -0500
Received: from relay.sw.ru ([185.231.240.75]:36266 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725985AbgAWHLW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 02:11:22 -0500
Received: from vvs-ws.sw.ru ([172.16.24.21])
        by relay.sw.ru with esmtp (Exim 4.92.3)
        (envelope-from <vvs@virtuozzo.com>)
        id 1iuWe8-0005pX-N3; Thu, 23 Jan 2020 10:11:20 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH 3/6] vcc_seq_next should increase position index
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Message-ID: <124d05e1-1c57-4824-4037-b8066af4a229@virtuozzo.com>
Date:   Thu, 23 Jan 2020 10:11:20 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

if seq_file .next fuction does not change position index,
read after some lseek can generate unexpected output.

https://bugzilla.kernel.org/show_bug.cgi?id=206283
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/atm/proc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/atm/proc.c b/net/atm/proc.c
index d79221f..c318967 100644
--- a/net/atm/proc.c
+++ b/net/atm/proc.c
@@ -134,8 +134,7 @@ static void vcc_seq_stop(struct seq_file *seq, void *v)
 static void *vcc_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
 	v = vcc_walk(seq, 1);
-	if (v)
-		(*pos)++;
+	(*pos)++;
 	return v;
 }
 
-- 
1.8.3.1

