Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B03735EBC9E
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 10:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbiI0IBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 04:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231396AbiI0IAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 04:00:39 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49765B0294
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 00:56:54 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id s14so13773951wro.0
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 00:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=5AC9rhXKlJRRXdUWnUqHjLPZfMA6XqruzQhBmxQFAM0=;
        b=sCka1ueglsjWEyqpSc3LDBfGfN3aF35FDGH1XPEu6PbR7YrYioqBeWTzYpB35TcUZU
         105NshwqadXIaJ7UNGmIO6p2k2+Z1btmAxLhylwAWuA5tN7X1gLi1Xq3eecnlhYz88aA
         czcnzdGgaW+TdNXYxcdHgUpKv85bSzrpYwLd9FMtdkJ4TYTuIgf7AYg/prTj5WZS8F9w
         y0IvL8cOQagi+R4TSUnYbk/7g6YaOffj01ucT9y1eUOmn6jiGyCOtniFSnKfrhWI9ra+
         FGg4aD9YRExOOmUw5f+QfVYnVcQ/J4Q2asyfJ7z4tNB+3Q0UKXoIbT6/NrXtuyofE39m
         hmgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=5AC9rhXKlJRRXdUWnUqHjLPZfMA6XqruzQhBmxQFAM0=;
        b=lK95pkwuW9sigkuVe2lUaekjZiK12nYns3we6AhbfPQECObkxKO7JZtVDvhRvQA6iV
         PDi6cMVVIfaWkl0dq1bD8jXm33+uMN711baaJBak7/MhCxbfuonV1/QeKImNijI/sb7c
         GLRIfl6kgyDdANed/yr4o0A3QgQmSl81odoTegzKIpHKfAf4CKaYb1M5dAHeFogEo/Fr
         No60PhQa6hHvPsiJzgX1iwNMQrDRY6ShWXALdwc/08z92rBQsPUcp0qOSp6FlBb8h44U
         rPKyrQlkbIctVXNH0gf/TB8UM0ZWJf7qxvG3zQ86cRWvLx1//eyGlkojWeJ5/o6b/jkY
         h0kA==
X-Gm-Message-State: ACrzQf3D1fvNTCQsiOK725CQ2/lb3gcw+Ox1hGwumyuZsyyGQ/wgdFBK
        c3WHNGGwib/6O1aTPY5MaC5MHlaszsSkBW22
X-Google-Smtp-Source: AMsMyM4xAXqaK5Db285tzmcgXTCTFkoKBaGSuEYeA2LJFeA1Btybiix2ldUrnysXUcdWG7b9pO8NnA==
X-Received: by 2002:a5d:457b:0:b0:22b:24d6:1a9f with SMTP id a27-20020a5d457b000000b0022b24d61a9fmr15292471wrc.201.1664265413578;
        Tue, 27 Sep 2022 00:56:53 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id bg8-20020a05600c3c8800b003a5c999cd1asm1161242wmb.14.2022.09.27.00.56.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 00:56:53 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, tariqt@nvidia.com,
        moshe@nvidia.com, saeedm@nvidia.com
Subject: [patch net-next v2 4/7] net: dsa: move port_setup/teardown to be called outside devlink port registered area
Date:   Tue, 27 Sep 2022 09:56:42 +0200
Message-Id: <20220927075645.2874644-5-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220927075645.2874644-1-jiri@resnulli.us>
References: <20220927075645.2874644-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Move port_setup() op to be called before devlink_port_register() and
port_teardown() after devlink_port_unregister().

Note it makes sense to move this alongside the rest of the devlink port
code, the reinit() function also gets much nicer, as clearly the fact that
port_setup()->devlink_port_region_create() was called in dsa_port_setup
did not fit the flow.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/dsa/dsa2.c | 68 +++++++++++++++++++-------------------------------
 1 file changed, 26 insertions(+), 42 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 7024e2120de1..6f555b1bb483 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -472,12 +472,6 @@ static int dsa_port_setup(struct dsa_port *dp)
 	if (dp->setup)
 		return 0;
 
-	if (ds->ops->port_setup) {
-		err = ds->ops->port_setup(ds, dp->index);
-		if (err)
-			return err;
-	}
-
 	switch (dp->type) {
 	case DSA_PORT_TYPE_UNUSED:
 		dsa_port_disable(dp);
@@ -532,11 +526,8 @@ static int dsa_port_setup(struct dsa_port *dp)
 		dsa_port_disable(dp);
 	if (err && dsa_port_link_registered)
 		dsa_shared_port_link_unregister_of(dp);
-	if (err) {
-		if (ds->ops->port_teardown)
-			ds->ops->port_teardown(ds, dp->index);
+	if (err)
 		return err;
-	}
 
 	dp->setup = true;
 
@@ -549,17 +540,26 @@ static int dsa_port_devlink_setup(struct dsa_port *dp)
 	struct dsa_switch_tree *dst = dp->ds->dst;
 	struct devlink_port_attrs attrs = {};
 	struct devlink *dl = dp->ds->devlink;
+	struct dsa_switch *ds = dp->ds;
 	const unsigned char *id;
 	unsigned char len;
 	int err;
 
+	memset(dlp, 0, sizeof(*dlp));
+	devlink_port_init(dl, dlp);
+
+	if (ds->ops->port_setup) {
+		err = ds->ops->port_setup(ds, dp->index);
+		if (err)
+			return err;
+	}
+
 	id = (const unsigned char *)&dst->index;
 	len = sizeof(dst->index);
 
 	attrs.phys.port_number = dp->index;
 	memcpy(attrs.switch_id.id, id, len);
 	attrs.switch_id.id_len = len;
-	memset(dlp, 0, sizeof(*dlp));
 
 	switch (dp->type) {
 	case DSA_PORT_TYPE_UNUSED:
@@ -578,24 +578,23 @@ static int dsa_port_devlink_setup(struct dsa_port *dp)
 
 	devlink_port_attrs_set(dlp, &attrs);
 	err = devlink_port_register(dl, dlp, dp->index);
+	if (err) {
+		if (ds->ops->port_teardown)
+			ds->ops->port_teardown(ds, dp->index);
+		return err;
+	}
+	dp->devlink_port_setup = true;
 
-	if (!err)
-		dp->devlink_port_setup = true;
-
-	return err;
+	return 0;
 }
 
 static void dsa_port_teardown(struct dsa_port *dp)
 {
 	struct devlink_port *dlp = &dp->devlink_port;
-	struct dsa_switch *ds = dp->ds;
 
 	if (!dp->setup)
 		return;
 
-	if (ds->ops->port_teardown)
-		ds->ops->port_teardown(ds, dp->index);
-
 	devlink_port_type_clear(dlp);
 
 	switch (dp->type) {
@@ -625,40 +624,25 @@ static void dsa_port_teardown(struct dsa_port *dp)
 static void dsa_port_devlink_teardown(struct dsa_port *dp)
 {
 	struct devlink_port *dlp = &dp->devlink_port;
+	struct dsa_switch *ds = dp->ds;
 
-	if (dp->devlink_port_setup)
+	if (dp->devlink_port_setup) {
 		devlink_port_unregister(dlp);
+		if (ds->ops->port_teardown)
+			ds->ops->port_teardown(ds, dp->index);
+		devlink_port_fini(dlp);
+	}
 	dp->devlink_port_setup = false;
 }
 
 /* Destroy the current devlink port, and create a new one which has the UNUSED
- * flavour. At this point, any call to ds->ops->port_setup has been already
- * balanced out by a call to ds->ops->port_teardown, so we know that any
- * devlink port regions the driver had are now unregistered. We then call its
- * ds->ops->port_setup again, in order for the driver to re-create them on the
- * new devlink port.
+ * flavour.
  */
 static int dsa_port_reinit_as_unused(struct dsa_port *dp)
 {
-	struct dsa_switch *ds = dp->ds;
-	int err;
-
 	dsa_port_devlink_teardown(dp);
 	dp->type = DSA_PORT_TYPE_UNUSED;
-	err = dsa_port_devlink_setup(dp);
-	if (err)
-		return err;
-
-	if (ds->ops->port_setup) {
-		/* On error, leave the devlink port registered,
-		 * dsa_switch_teardown will clean it up later.
-		 */
-		err = ds->ops->port_setup(ds, dp->index);
-		if (err)
-			return err;
-	}
-
-	return 0;
+	return dsa_port_devlink_setup(dp);
 }
 
 static int dsa_devlink_info_get(struct devlink *dl,
-- 
2.37.1

