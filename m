Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB6F1668F52
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 08:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232678AbjAMHhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 02:37:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240738AbjAMHgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 02:36:25 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9CCA482A1;
        Thu, 12 Jan 2023 23:36:03 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id g10so14672098wmo.1;
        Thu, 12 Jan 2023 23:36:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DXggE3W8CIBjCZ9C95iTI+NeNj7il/k4Fv8jK8o0OlI=;
        b=Dq+Feophv6UuqAGIrE/kjgvybH7PZDEem3UecsytoP+TVYPP85ixUzw/cctMzTpNBQ
         u20Jg+4GYu4Q/rE/R3MM5YEqL6Wq7ElnaWQPQQ1oy7hX1nWSe2YZ4IEfrqKbCK8tg5eB
         1BQmE5nW97gfTsX2MlGGkDiNi+HxU/g6PO294AuHbGVjntUaxpqHSvAnRKQTd6W3jz+F
         US1yhxbF7YHs6SFW7lOZExRRZ6t7AqY+tS/2IC9T98H/SjhmgZxQsy/TnAqqWCQpXusn
         cVDFCp5nBzFVntxLu3IsS7/gpYe096dkvdtItzNn7niiM4g25Tapmg+DBVZJgv/7LlNQ
         dCwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DXggE3W8CIBjCZ9C95iTI+NeNj7il/k4Fv8jK8o0OlI=;
        b=qZm04dUx1Tfuy/8yN/E3kHF+o9Ng1EuSiiE8RmSk2CQT6UxtgSflQOHJ9hdFFi+nWN
         alGZ2U8qkHosz1TWrUBBm2gyYhFzNF+1OoDQCjHeJLP4LOu1zX1290QEQQCsV3xoIG7Y
         dqAhU/KrkA2GsdJIZm94lR/6Y4rBSB2MG/5xhjVsUpn6dmsxzuwN+X4uE70nHcdJ/FUr
         bc9K3eV82v3q0suyXRFgJUCSrj5OIJctvH9Q5Zffwhnqw5pQFIveO2WdJ3656XndpiLi
         FydoOQ+7keWMlTfYqpgTCtkQLsZOoKGDBqAYRexQL1XdpNAkpBlhQEo9s5fjLK6JK6SW
         Ziaw==
X-Gm-Message-State: AFqh2kp587FwgevgzqPwV8Hi07E/Tx2kZrTfSMxGI1ZjfSQEBVllJgML
        36NoNpdP3NvkErxVi18lauMvgeYphCKUWA==
X-Google-Smtp-Source: AMrXdXvajpOjI5yU+GLbikMrDle5FotCAEeQY3dIc7nvFO6wi8Y++y5wxDnf84RKtU30Tmod4Qk11g==
X-Received: by 2002:a05:600c:3d05:b0:3d3:5c21:dd94 with SMTP id bh5-20020a05600c3d0500b003d35c21dd94mr59341271wmb.9.1673595362080;
        Thu, 12 Jan 2023 23:36:02 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id u13-20020a05600c19cd00b003c6f1732f65sm31259062wmq.38.2023.01.12.23.36.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 23:36:01 -0800 (PST)
Date:   Fri, 13 Jan 2023 10:35:43 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] devlink: remove some unnecessary code
Message-ID: <Y8EJz8oxpMhfiPUb@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This code checks if (attrs[DEVLINK_ATTR_TRAP_POLICER_ID]) twice.  Once
at the start of the function and then a couple lines later.  Delete the
second check since that one must be true.

Because the second condition is always true, it means the:

	policer_item = group_item->policer_item;

assignment is immediately over-written.  Delete that as well.

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
This is from static analysis and not tested.  It's possible (although
unlikely) that the static checker found buggy code instead of merely
a bit of dead code.  Please review this one carefully.

 net/devlink/leftover.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 1e23b2da78cc..bf5e0b1c0422 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -8719,6 +8719,7 @@ static int devlink_trap_group_set(struct devlink *devlink,
 	struct netlink_ext_ack *extack = info->extack;
 	const struct devlink_trap_policer *policer;
 	struct nlattr **attrs = info->attrs;
+	u32 policer_id;
 	int err;
 
 	if (!attrs[DEVLINK_ATTR_TRAP_POLICER_ID])
@@ -8727,17 +8728,11 @@ static int devlink_trap_group_set(struct devlink *devlink,
 	if (!devlink->ops->trap_group_set)
 		return -EOPNOTSUPP;
 
-	policer_item = group_item->policer_item;
-	if (attrs[DEVLINK_ATTR_TRAP_POLICER_ID]) {
-		u32 policer_id;
-
-		policer_id = nla_get_u32(attrs[DEVLINK_ATTR_TRAP_POLICER_ID]);
-		policer_item = devlink_trap_policer_item_lookup(devlink,
-								policer_id);
-		if (policer_id && !policer_item) {
-			NL_SET_ERR_MSG_MOD(extack, "Device did not register this trap policer");
-			return -ENOENT;
-		}
+	policer_id = nla_get_u32(attrs[DEVLINK_ATTR_TRAP_POLICER_ID]);
+	policer_item = devlink_trap_policer_item_lookup(devlink, policer_id);
+	if (policer_id && !policer_item) {
+		NL_SET_ERR_MSG_MOD(extack, "Device did not register this trap policer");
+		return -ENOENT;
 	}
 	policer = policer_item ? policer_item->policer : NULL;
 
-- 
2.35.1

