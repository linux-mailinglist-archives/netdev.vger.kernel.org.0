Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3157DEF6F
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 16:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729134AbfJUO0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 10:26:20 -0400
Received: from mail-wm1-f48.google.com ([209.85.128.48]:51691 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728911AbfJUO0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 10:26:19 -0400
Received: by mail-wm1-f48.google.com with SMTP id q70so6394488wme.1
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 07:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e41xeTRBdTBupSsvuex+EzNtgqOYBOPm2HAmqmk0ulg=;
        b=gaKT27XOFEOlLezi7ESfF1Radkmt+9iLtfbDt6wPFa66+jQgPhZTcS1SlRC0+p5yz4
         QVx2snCOp0BFED+QZnPFG6hoHZ4j3hfAQfiarBQe9eah7eemmqbJOYDEFxK2JzyOlOGN
         8GIvl8nODb48Vk7TGkpOt4TDrWWXxXFxk0M+UclROnMlvm1XDzuRsUyhP0UC7wFJd6HN
         xVvTXan+80cTIluBdI+ksXX3Cmf6phZ+xepbUxZXAihDWF9VHIzPnIKt2c028TTuI0ui
         W0AUTjvKG2cww0yPDEmbndIqNiBE4Lj8FQQexgHr8BtX9QR4g8BMyr8NlIbF/sIPsGzK
         GazQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e41xeTRBdTBupSsvuex+EzNtgqOYBOPm2HAmqmk0ulg=;
        b=tCIaTv0i8+GcYxYWAIFR1N8BEGP1i94oc/nssT3u1PIyQH+OFej7eFgi5AzKXz1Y87
         HD0TLQBTJtQa014wjqwh5YpoSPR3CMe784IJPu/IMk3mrRa3Dow7+IyuzfX8AuHGGwH5
         iW+dFy2q45uHNDSmtddymvhmehimS+S/Re/Hm6bULRR3qmtsVvtB3zPVQ5SoQjmbIRA8
         jyW+nJVhE/Wu3P4Gp1LTB3BYcdQA33EeuOPTJjS6Z4EKDjsHonzMjkx8EbSgpIqyKJDe
         BPr6Ggu2uh54U4tFFifXi6gXKWcziIz0GF/OuPCu0/PSCRR4M+qP+ZBE708kGPMfUei3
         stTA==
X-Gm-Message-State: APjAAAXlqLm+ItrtMjW3hrY03GI73D/zhLLeDsA5KGPNTG2Ey8ssTZy6
        Zt7FaCO+dwaH3aPc4psHJbqC3Oz3eBs=
X-Google-Smtp-Source: APXvYqzGm3rCKycTA+N3AIiTK7ysIISc+Cz9YFno0KT0h4wDxfY6RuH6xjEwVH4ADGWlcVi8JWUCRw==
X-Received: by 2002:a7b:cf28:: with SMTP id m8mr20966295wmg.161.1571667977460;
        Mon, 21 Oct 2019 07:26:17 -0700 (PDT)
Received: from localhost (ip-94-113-126-64.net.upcbroadband.cz. [94.113.126.64])
        by smtp.gmail.com with ESMTPSA id y186sm21280916wmd.26.2019.10.21.07.26.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 07:26:17 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com, andrew@lunn.ch,
        mlxsw@mellanox.com
Subject: [patch net-next v3 3/3] devlink: add format requirement for devlink object names
Date:   Mon, 21 Oct 2019 16:26:13 +0200
Message-Id: <20191021142613.26657-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191021142613.26657-1-jiri@resnulli.us>
References: <20191021142613.26657-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Currently, the name format is not required by the code, however it is
required during patch review. All params added until now are in-lined
with the following format:
1) lowercase characters, digits and underscored are allowed
2) underscore is neither at the beginning nor at the end and
   there is no more than one in a row.

Add checker to the code to require this format from drivers and warn if
they don't follow. This applies to params, resources, reporters,
traps, trap groups, dpipe tables and dpipe fields.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v2->v3:
- loosen the checks to allow uppercase as well
- also check resources, reporters,
  traps, trap groups, dpipe tables and dpipe fields.
v1->v2:
- removed empty line after comment
- added check for empty string
- converted i and len to size_t and put on a single line
- s/valid_name/name_valid/ to be aligned with the rest
---
 net/core/devlink.c | 79 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 45b6a9a964f6..e7d714699579 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -20,6 +20,7 @@
 #include <linux/workqueue.h>
 #include <linux/u64_stats_sync.h>
 #include <linux/timekeeping.h>
+#include <linux/ctype.h>
 #include <rdma/ib_verbs.h>
 #include <net/netlink.h>
 #include <net/genetlink.h>
@@ -31,6 +32,30 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/devlink.h>
 
+static bool devlink_obj_name_valid(const char *name)
+{
+	size_t i, len = strlen(name);
+
+	if (!len)
+		return false;
+
+	/* Name can contain lowercase/uppercase characters or digits.
+	 * Underscores are also allowed, but not at the beginning
+	 * or end of the name and not more than one in a row.
+	 */
+	for (i = 0; i < len; i++) {
+		if (isalnum(name[i]))
+			continue;
+		if (name[i] != '_')
+			return false;
+		if (i == 0 || i + 1 == len)
+			return false;
+		if (name[i - 1] == '_')
+			return false;
+	}
+	return true;
+}
+
 static struct devlink_dpipe_field devlink_dpipe_fields_ethernet[] = {
 	{
 		.name = "destination_mac",
@@ -4782,6 +4807,9 @@ devlink_health_reporter_create(struct devlink *devlink,
 		goto unlock;
 	}
 
+	if (WARN_ON(!devlink_obj_name_valid(ops->name)))
+		return ERR_PTR(-EINVAL);
+
 	if (WARN_ON(auto_recover && !ops->recover) ||
 	    WARN_ON(graceful_period && !ops->recover)) {
 		reporter = ERR_PTR(-EINVAL);
@@ -6702,6 +6730,36 @@ void devlink_sb_unregister(struct devlink *devlink, unsigned int sb_index)
 }
 EXPORT_SYMBOL_GPL(devlink_sb_unregister);
 
+static int
+devlink_dpipe_header_verify(struct devlink_dpipe_header *dpipe_header)
+{
+	int i;
+
+	if (WARN_ON(!devlink_obj_name_valid(dpipe_header->name)))
+		return -EINVAL;
+
+	for (i = 0; i < dpipe_header->fields_count; i++) {
+		const char *name = dpipe_header->fields[i].name;
+
+		if (WARN_ON(!devlink_obj_name_valid(name)))
+			return -EINVAL;
+	}
+	return 0;
+}
+
+static int
+devlink_dpipe_headers_verify(struct devlink_dpipe_headers *dpipe_headers)
+{
+	int i, err;
+
+	for (i = 0; i < dpipe_headers->headers_count; i++) {
+		err = devlink_dpipe_header_verify(dpipe_headers->headers[i]);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
 /**
  *	devlink_dpipe_headers_register - register dpipe headers
  *
@@ -6713,6 +6771,11 @@ EXPORT_SYMBOL_GPL(devlink_sb_unregister);
 int devlink_dpipe_headers_register(struct devlink *devlink,
 				   struct devlink_dpipe_headers *dpipe_headers)
 {
+	int err;
+
+	err = devlink_dpipe_headers_verify(dpipe_headers);
+	if (err)
+		return err;
 	mutex_lock(&devlink->lock);
 	devlink->dpipe_headers = dpipe_headers;
 	mutex_unlock(&devlink->lock);
@@ -6785,6 +6848,9 @@ int devlink_dpipe_table_register(struct devlink *devlink,
 	if (devlink_dpipe_table_find(&devlink->dpipe_table_list, table_name))
 		return -EEXIST;
 
+	if (WARN_ON(!devlink_obj_name_valid(table_name)))
+		return -EINVAL;
+
 	if (WARN_ON(!table_ops->size_get))
 		return -EINVAL;
 
@@ -6853,6 +6919,9 @@ int devlink_resource_register(struct devlink *devlink,
 
 	top_hierarchy = parent_resource_id == DEVLINK_RESOURCE_ID_PARENT_TOP;
 
+	if (WARN_ON(!devlink_obj_name_valid(resource_name)))
+		return -EINVAL;
+
 	mutex_lock(&devlink->lock);
 	resource = devlink_resource_find(devlink, NULL, resource_id);
 	if (resource) {
@@ -7044,6 +7113,10 @@ static int devlink_param_verify(const struct devlink_param *param)
 {
 	if (!param || !param->name || !param->supported_cmodes)
 		return -EINVAL;
+
+	if (WARN_ON(!devlink_obj_name_valid(param->name)))
+		return -EINVAL;
+
 	if (param->generic)
 		return devlink_param_generic_verify(param);
 	else
@@ -7650,6 +7723,9 @@ static int devlink_trap_verify(const struct devlink_trap *trap)
 	if (!trap || !trap->name || !trap->group.name)
 		return -EINVAL;
 
+	if (WARN_ON(!devlink_obj_name_valid(trap->name)))
+		return -EINVAL;
+
 	if (trap->generic)
 		return devlink_trap_generic_verify(trap);
 	else
@@ -7686,6 +7762,9 @@ devlink_trap_group_driver_verify(const struct devlink_trap_group *group)
 
 static int devlink_trap_group_verify(const struct devlink_trap_group *group)
 {
+	if (WARN_ON(!devlink_obj_name_valid(group->name)))
+		return -EINVAL;
+
 	if (group->generic)
 		return devlink_trap_group_generic_verify(group);
 	else
-- 
2.21.0

