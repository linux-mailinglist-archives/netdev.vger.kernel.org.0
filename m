Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D26AA3A28EA
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 12:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbhFJKD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 06:03:57 -0400
Received: from m12-12.163.com ([220.181.12.12]:42655 "EHLO m12-12.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229770AbhFJKDz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 06:03:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=CJ49G
        oS0jQHH9sB8vn0lkk7XGybqbG3lEnEVcpP8Yw8=; b=OGg9aZekkcCrBqk6MWl8D
        hzSjRTI9P8q/l5qQ2thndk8bScD+vH3qYsWs/I/1g8Ac1WlX5GFlepjpCXY5UN8V
        a0LKbTT2DSIzbsEEm6O9cLp0TFgsju9vm8zEi6cEOKKO1PW2sbVBOB8DBFjyfkKx
        Xcb19xq6glUwiv3OhEWisA=
Received: from COOL-20201210PM.ccdomain.com (unknown [218.94.48.178])
        by smtp8 (Coremail) with SMTP id DMCowADn4Mwa38FgOeJYJA--.53893S2;
        Thu, 10 Jun 2021 17:45:05 +0800 (CST)
From:   zuoqilin1@163.com
To:     idryomov@gmail.com, jlayton@kernel.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     ceph-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, zuoqilin <zuoqilin@yulong.com>
Subject: [PATCH] net/ceph: Remove unnecessary variables
Date:   Thu, 10 Jun 2021 17:45:05 +0800
Message-Id: <20210610094505.1341-1-zuoqilin1@163.com>
X-Mailer: git-send-email 2.28.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DMCowADn4Mwa38FgOeJYJA--.53893S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtF4UAw4UtFWktFykWF45KFg_yoWDCFb_C3
        yIvF1rWrWUWa40vw47Arn3ArZI9w4UAFySvr17KFWfZ3ZxKrn8Gr1rWr9xAFy7uFyIywnr
        ur1Du3y7Jr47ujkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU1hL07UUUUU==
X-Originating-IP: [218.94.48.178]
X-CM-SenderInfo: 52xr1xpolqiqqrwthudrp/xtbBRQCtiVPAMW43QAABsb
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: zuoqilin <zuoqilin@yulong.com>

There is no necessary to define variable assignment,
just return directly to simplify the steps.

Signed-off-by: zuoqilin <zuoqilin@yulong.com>
---
 net/ceph/auth.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/net/ceph/auth.c b/net/ceph/auth.c
index de407e8..b824a48 100644
--- a/net/ceph/auth.c
+++ b/net/ceph/auth.c
@@ -58,12 +58,10 @@ struct ceph_auth_client *ceph_auth_init(const char *name,
 					const int *con_modes)
 {
 	struct ceph_auth_client *ac;
-	int ret;
 
-	ret = -ENOMEM;
 	ac = kzalloc(sizeof(*ac), GFP_NOFS);
 	if (!ac)
-		goto out;
+		return ERR_PTR(-ENOMEM);
 
 	mutex_init(&ac->mutex);
 	ac->negotiating = true;
@@ -78,9 +76,6 @@ struct ceph_auth_client *ceph_auth_init(const char *name,
 	dout("%s name '%s' preferred_mode %d fallback_mode %d\n", __func__,
 	     ac->name, ac->preferred_mode, ac->fallback_mode);
 	return ac;
-
-out:
-	return ERR_PTR(ret);
 }
 
 void ceph_auth_destroy(struct ceph_auth_client *ac)
-- 
1.9.1


