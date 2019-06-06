Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF4537705
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 16:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728922AbfFFOnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 10:43:32 -0400
Received: from mout.kundenserver.de ([217.72.192.75]:45157 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727309AbfFFOnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 10:43:32 -0400
Received: from orion.localdomain ([77.9.2.22]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MDgtl-1hRQpp30cB-00Aqgr; Thu, 06 Jun 2019 16:43:22 +0200
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org
Subject: [PATCH] net: ipv4: fib_semantics: fix uninitialized variable
Date:   Thu,  6 Jun 2019 16:43:17 +0200
Message-Id: <1559832197-22758-1-git-send-email-info@metux.net>
X-Mailer: git-send-email 1.9.1
X-Provags-ID: V03:K1:A8lM3KTrS7d9lFYFMMXKbOZdHpr6Pq+8VblZT4wy4ZwdFw4CJh1
 IC3s8zx+P/5s5GBiK4YoBKBm2BMlc7qSZ37kw+TIovbxlKlz2CmwSq3dfo9e+VdvMBfyi1T
 C8gbQ+yw8jBTpvYtNKZqyD2hN3Ufxa8YZ4UvERmKF8g/85FIPZG5jgnKdDYzF3PRw0LFZx9
 NIzS5uZQWDFowrQaH5MJg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:huYfGX0OWj0=:ov/76Vx0+ndbj2Xe8G4c3P
 aCQF12X8uaeSSXKUAQlu6iHZ0nNVRgJwwnKFM6eGe99+brL0TDhPzl3vKPKPhCYtqki6IXXIV
 aA9tTs1eXOCnxAOYR2c6wyeQRchSUPccmtz03tmeoZ5qocbRFS5chNTu+o7Cq8UeNrxn7Ry3L
 iN+mMi0zK+B0LxeE/2RMc1BE/WkfbfBmTP5OpHpTnwPIS2LjROefKD0JRAKxCi82HcFHMAN4m
 r729PYQQuntBX2PjfmbSX3Uy/YzCBiBdo0cT3EbIjUA11pdB1gRMZWV7Ns11tbTBai7YePwBa
 eLQiqmg5S/w+xJb+5dhQTVVx/uQv65h/FwhC+H0P4d7Bcs4v2X4ebS1vx9wHQjiSDZqLHVRN1
 XW/6ytveu6AKwNsMvL+bPCj8lj4vCm8LM49YArT99PFlCkrX7qLVsx7aydRcF8plm3tlbbKd4
 VWuRJhkT6vQLUBb3SALBkuBObP8kEkGh7hPp82ydl2Uz9p10ykbn9n1GSykb+0XrEY/GDPkAW
 ujUAjpwPf5/Qj8vdvBKZQS3iStiMB1cP+Kz+imreA6SOQGR1cBgsrMT5eVY/hICZMLZICYtR1
 Xpc43wQbJmkV0ThVHKOXnUXXgDoFeZiZvJYDOzAvlGy9M81sZSRNv8r1ugjgu1Jyk93NBE4O5
 nLbkeAY9P0HZqGNbIT0nnSFQIp/vsjcKewem7XNQTOXDM+qcVMg/m1+QQUOrjBt9EAjJLgg20
 nidl62oSXwkdH0lH713NDo/7gGQhY8rCfoRz1w==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Enrico Weigelt <info@metux.net>

fix an uninitialized variable:

  CC      net/ipv4/fib_semantics.o
net/ipv4/fib_semantics.c: In function 'fib_check_nh_v4_gw':
net/ipv4/fib_semantics.c:1027:12: warning: 'err' may be used uninitialized in this function [-Wmaybe-uninitialized]
   if (!tbl || err) {
            ^~

Signed-off-by: Enrico Weigelt <info@metux.net>
---
 net/ipv4/fib_semantics.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index b804106..bfa49a8 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -964,7 +964,7 @@ static int fib_check_nh_v4_gw(struct net *net, struct fib_nh *nh, u32 table,
 {
 	struct net_device *dev;
 	struct fib_result res;
-	int err;
+	int err = 0;
 
 	if (nh->fib_nh_flags & RTNH_F_ONLINK) {
 		unsigned int addr_type;
-- 
1.9.1

