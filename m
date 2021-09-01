Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9606D3FDEBC
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 17:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343705AbhIAPfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 11:35:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44953 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244357AbhIAPfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 11:35:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630510458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=rluMAfEBU3Ib/ckTr6pbF4a7dng5gyNp2vdu3ZiqU7A=;
        b=dBlBIwMJ/+pv7hlII0UpM9iJIqxKEo7sGbCHr2ZN0vXeEnNur1+R3CaRuppzau1jP5VHzq
        QdyTnZQkaUmy7lH40msuDlenTYUAaXXZsk2WeF+Hlx4rXuopfc1fvLc4KzIHVq+cGJfjz4
        RVDkQ54nOBlJAg0WW0u72OAN54KKDx0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-451--PgNynBqNLqE6PfMSHWrVw-1; Wed, 01 Sep 2021 11:34:15 -0400
X-MC-Unique: -PgNynBqNLqE6PfMSHWrVw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C5B3187180F;
        Wed,  1 Sep 2021 15:34:12 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0978E5C1BB;
        Wed,  1 Sep 2021 15:34:09 +0000 (UTC)
Date:   Wed, 1 Sep 2021 17:34:07 +0200
From:   Eugene Syromiatnikov <esyr@redhat.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Antony Antony <antony.antony@secunet.com>,
        Christian Langrock <christian.langrock@secunet.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Dmitry V. Levin" <ldv@strace.io>, linux-api@vger.kernel.org
Subject: [PATCH] include/uapi/linux/xfrm.h: Fix XFRM_MSG_MAPPING ABI breakage
Message-ID: <20210901153407.GA20446@asgard.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 2d151d39073a ("xfrm: Add possibility to set the default to block
if we have no policy") broke ABI by changing the value of the XFRM_MSG_MAPPING
enum item.  Fix it by placing XFRM_MSG_SETDEFAULT/XFRM_MSG_GETDEFAULT
to the end of the enum, right before __XFRM_MSG_MAX.

Fixes: 2d151d39073a ("xfrm: Add possibility to set the default to block if we have no policy")
Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
---
 include/uapi/linux/xfrm.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/xfrm.h b/include/uapi/linux/xfrm.h
index b96c1ea..26f456b1 100644
--- a/include/uapi/linux/xfrm.h
+++ b/include/uapi/linux/xfrm.h
@@ -213,13 +213,13 @@ enum {
 	XFRM_MSG_GETSPDINFO,
 #define XFRM_MSG_GETSPDINFO XFRM_MSG_GETSPDINFO
 
+	XFRM_MSG_MAPPING,
+#define XFRM_MSG_MAPPING XFRM_MSG_MAPPING
+
 	XFRM_MSG_SETDEFAULT,
 #define XFRM_MSG_SETDEFAULT XFRM_MSG_SETDEFAULT
 	XFRM_MSG_GETDEFAULT,
 #define XFRM_MSG_GETDEFAULT XFRM_MSG_GETDEFAULT
-
-	XFRM_MSG_MAPPING,
-#define XFRM_MSG_MAPPING XFRM_MSG_MAPPING
 	__XFRM_MSG_MAX
 };
 #define XFRM_MSG_MAX (__XFRM_MSG_MAX - 1)
-- 
2.1.4

