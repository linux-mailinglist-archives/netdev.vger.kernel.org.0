Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 235D62484B8
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 14:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgHRM15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 08:27:57 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:9836 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726336AbgHRM1z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 08:27:55 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id C640E5F3FC3BC6CABC40;
        Tue, 18 Aug 2020 20:27:51 +0800 (CST)
Received: from huawei.com (10.175.104.175) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Tue, 18 Aug 2020
 20:27:41 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <idryomov@gmail.com>, <jlayton@kernel.org>, <davem@davemloft.net>,
        <kuba@kernel.org>, <grandmaster@al2klimov.de>
CC:     <ceph-devel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linmiaohe@huawei.com>
Subject: [PATCH] libceph: Convert to use the preferred fallthrough macro
Date:   Tue, 18 Aug 2020 08:26:37 -0400
Message-ID: <20200818122637.21449-1-linmiaohe@huawei.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.175]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the uses of fallthrough comments to fallthrough macro.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 net/ceph/ceph_hash.c    | 20 ++++++++++----------
 net/ceph/crush/mapper.c |  2 +-
 net/ceph/messenger.c    |  4 ++--
 net/ceph/mon_client.c   |  2 +-
 net/ceph/osd_client.c   |  4 ++--
 5 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/net/ceph/ceph_hash.c b/net/ceph/ceph_hash.c
index 81e1e006c540..16a47c0eef37 100644
--- a/net/ceph/ceph_hash.c
+++ b/net/ceph/ceph_hash.c
@@ -50,35 +50,35 @@ unsigned int ceph_str_hash_rjenkins(const char *str, unsigned int length)
 	switch (len) {
 	case 11:
 		c = c + ((__u32)k[10] << 24);
-		/* fall through */
+		fallthrough;
 	case 10:
 		c = c + ((__u32)k[9] << 16);
-		/* fall through */
+		fallthrough;
 	case 9:
 		c = c + ((__u32)k[8] << 8);
 		/* the first byte of c is reserved for the length */
-		/* fall through */
+		fallthrough;
 	case 8:
 		b = b + ((__u32)k[7] << 24);
-		/* fall through */
+		fallthrough;
 	case 7:
 		b = b + ((__u32)k[6] << 16);
-		/* fall through */
+		fallthrough;
 	case 6:
 		b = b + ((__u32)k[5] << 8);
-		/* fall through */
+		fallthrough;
 	case 5:
 		b = b + k[4];
-		/* fall through */
+		fallthrough;
 	case 4:
 		a = a + ((__u32)k[3] << 24);
-		/* fall through */
+		fallthrough;
 	case 3:
 		a = a + ((__u32)k[2] << 16);
-		/* fall through */
+		fallthrough;
 	case 2:
 		a = a + ((__u32)k[1] << 8);
-		/* fall through */
+		fallthrough;
 	case 1:
 		a = a + k[0];
 		/* case 0: nothing left to add */
diff --git a/net/ceph/crush/mapper.c b/net/ceph/crush/mapper.c
index 07e5614eb3f1..7057f8db4f99 100644
--- a/net/ceph/crush/mapper.c
+++ b/net/ceph/crush/mapper.c
@@ -987,7 +987,7 @@ int crush_do_rule(const struct crush_map *map,
 		case CRUSH_RULE_CHOOSELEAF_FIRSTN:
 		case CRUSH_RULE_CHOOSE_FIRSTN:
 			firstn = 1;
-			/* fall through */
+			fallthrough;
 		case CRUSH_RULE_CHOOSELEAF_INDEP:
 		case CRUSH_RULE_CHOOSE_INDEP:
 			if (wsize == 0)
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 27d6ab11f9ee..bdfd66ba3843 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -412,7 +412,7 @@ static void ceph_sock_state_change(struct sock *sk)
 	switch (sk->sk_state) {
 	case TCP_CLOSE:
 		dout("%s TCP_CLOSE\n", __func__);
-		/* fall through */
+		fallthrough;
 	case TCP_CLOSE_WAIT:
 		dout("%s TCP_CLOSE_WAIT\n", __func__);
 		con_sock_state_closing(con);
@@ -2751,7 +2751,7 @@ static int try_read(struct ceph_connection *con)
 			switch (ret) {
 			case -EBADMSG:
 				con->error_msg = "bad crc/signature";
-				/* fall through */
+				fallthrough;
 			case -EBADE:
 				ret = -EIO;
 				break;
diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
index 3d8c8015e976..d633a0aeaa55 100644
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -1307,7 +1307,7 @@ static struct ceph_msg *mon_alloc_msg(struct ceph_connection *con,
 		 * request had a non-zero tid.  Work around this weirdness
 		 * by allocating a new message.
 		 */
-		/* fall through */
+		fallthrough;
 	case CEPH_MSG_MON_MAP:
 	case CEPH_MSG_MDS_MAP:
 	case CEPH_MSG_OSD_MAP:
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index e4fbcad6e7d8..7901ab6c79fd 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -3854,7 +3854,7 @@ static void scan_requests(struct ceph_osd *osd,
 			if (!force_resend && !force_resend_writes)
 				break;
 
-			/* fall through */
+			fallthrough;
 		case CALC_TARGET_NEED_RESEND:
 			cancel_linger_map_check(lreq);
 			/*
@@ -3891,7 +3891,7 @@ static void scan_requests(struct ceph_osd *osd,
 			     !force_resend_writes))
 				break;
 
-			/* fall through */
+			fallthrough;
 		case CALC_TARGET_NEED_RESEND:
 			cancel_map_check(req);
 			unlink_request(osd, req);
-- 
2.19.1

