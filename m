Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00D8B69B22F
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 19:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjBQSLo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 13:11:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjBQSLn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 13:11:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52FDD5250
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 10:10:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676657456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=OQTqw7A1ZpZ0Y604anUTsntYYj8ALqjdo4Z0U8+q7nw=;
        b=ae+Pdx2xbhLogoQ76WN+9+6VrmU81YXBscwp2GhPJOs/S6RpDiX9i3W/RIlLFdRzY6OvcX
        XH9GcMYQ7ilI4C1chYxxHbsC71yUCPHopgr2URePWtdDCgOtCsBB6u5ddFpjrFxPwgbrES
        zyuVDW2g3VfwKxLF5NHSJiS+hpbG7GY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-88-OIrgzZ79NE2Ycnwgiq5IzQ-1; Fri, 17 Feb 2023 13:10:52 -0500
X-MC-Unique: OIrgzZ79NE2Ycnwgiq5IzQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5DA27185A794;
        Fri, 17 Feb 2023 18:10:52 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.192.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4ACB3140EBF4;
        Fri, 17 Feb 2023 18:10:51 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next] devlink: drop leftover duplicate/unused code
Date:   Fri, 17 Feb 2023 19:09:20 +0100
Message-Id: <8ad783f77a577505653d90fb47075ea4c9ca5d97.1676657010.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The recent merge from net left-over some unused code in
leftover.c - nomen omen.

Just drop the unused bits.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/devlink/leftover.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 8fc85ba3f6e0..dffca2f9bfa7 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -3837,19 +3837,6 @@ int devlink_resources_validate(struct devlink *devlink,
 	return err;
 }
 
-static void devlink_param_notify(struct devlink *devlink,
-				 unsigned int port_index,
-				 struct devlink_param_item *param_item,
-				 enum devlink_command cmd);
-
-struct devlink_info_req {
-	struct sk_buff *msg;
-	void (*version_cb)(const char *version_name,
-			   enum devlink_info_version_type version_type,
-			   void *version_cb_priv);
-	void *version_cb_priv;
-};
-
 static const struct devlink_param devlink_param_generic[] = {
 	{
 		.id = DEVLINK_PARAM_GENERIC_ID_INT_ERR_RESET,
-- 
2.39.1

