Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 308695EEEFE
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235234AbiI2H33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235117AbiI2H3R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:29:17 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F140D135067
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:29:14 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id d12-20020a05600c3acc00b003b4c12e47f3so278466wms.4
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=6QNNmB1KrlRdIoS5VOtMx6+GOMit4lATyDU2M5Q3WeE=;
        b=HUMLN1kImp1kqlK4H5X206mys2GS0FFM92UY6TjztayPsqELSavTRQHBKzR0T4zcz3
         02naIj7+W2MjvkRLqJcbiQw17jChckjbldMKwg/aZjq2djZDRgsr5jqe4TfnGoBley29
         WZLFLEZYyhcrI61mUf5JPHlDj5CcqWxZUQpopYft0AdFy+ymxNgIAKhIawwgM6TybZQr
         xk6x3yq3e5Sj0TBr8EPf2CzAojBbGwGioIGTevQ4/Y3YWANi5fOAihnTlfsT9wS6NCw4
         mupfblRmPEMcUHUWpm9aBw5rrTltLjRQIdv3vqVfNHcUaE0nd2ML+98i/VS6tZ5kZTyq
         Rqsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=6QNNmB1KrlRdIoS5VOtMx6+GOMit4lATyDU2M5Q3WeE=;
        b=oNeY5b9XkcKAWaJkedXP0AB8layJotWhrWRIGEeLGre6S/IY14nImpeeFxft7kjbgQ
         rctV/RxF86U1ER67oCUbuKO0xyhqeq7zshb2ckFFZrlm3bC2j7vT6grZxI5iEU1ocMLR
         2hLu6PAiNX28SdkHNKwCXMDc2FYsmLKugKD911oDug11TXE3uQiWMKPVt+HiwjymbyLh
         BeVE8+p9nIhHOPzKfrUX33riTmTMgQurCWYvyR/56FTg9+h3ZgGa/EU/a43CLpWhCDtF
         P8qM0Ri+exwqxSa4heJmjC1txHX04eSmlAmUb7FaL/KE7wEvcErYRPr/oU0c3r6zO1vG
         74Kg==
X-Gm-Message-State: ACrzQf18eMIvkBOEYAY8F86MIbkPtrfNAYP/iyWEezXQM80oxB3OWgXq
        d+rhWZmR3UEe0RspQykXxWuKfwVvIB/zcwt4
X-Google-Smtp-Source: AMsMyM41zFteFidypyyE0Lasizuc+jw0mH9SYM+cWeVSWy1+gr8LN5+FeiM5f7xnDgDedhPIZFxvEA==
X-Received: by 2002:a05:600c:42d4:b0:3b3:3de1:7564 with SMTP id j20-20020a05600c42d400b003b33de17564mr1199035wme.152.1664436553427;
        Thu, 29 Sep 2022 00:29:13 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id j19-20020a05600c1c1300b003a5ca627333sm4164861wms.8.2022.09.29.00.29.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 00:29:12 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, tariqt@nvidia.com,
        moshe@nvidia.com, saeedm@nvidia.com
Subject: [patch net-next v3 6/7] net: dsa: don't do devlink port setup early
Date:   Thu, 29 Sep 2022 09:29:01 +0200
Message-Id: <20220929072902.2986539-7-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220929072902.2986539-1-jiri@resnulli.us>
References: <20220929072902.2986539-1-jiri@resnulli.us>
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

Commit 3122433eb533 ("net: dsa: Register devlink ports before calling DSA driver setup()")
moved devlink port setup to be done early before driver setup()
was called. That is no longer needed, so move the devlink port
initialization back to dsa_port_setup(), as the first thing done there.

Note there is no longer needed to reinit port as unused if
dsa_port_setup() fails, as it unregisters the devlink port instance on
the error path.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v1->v2:
- added back the reinit as unused in case port setup fails
---
 net/dsa/dsa2.c | 176 +++++++++++++++++++++++--------------------------
 1 file changed, 82 insertions(+), 94 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 6f555b1bb483..747c0364fb0f 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -461,6 +461,74 @@ static void dsa_tree_teardown_cpu_ports(struct dsa_switch_tree *dst)
 			dp->cpu_dp = NULL;
 }
 
+static int dsa_port_devlink_setup(struct dsa_port *dp)
+{
+	struct devlink_port *dlp = &dp->devlink_port;
+	struct dsa_switch_tree *dst = dp->ds->dst;
+	struct devlink_port_attrs attrs = {};
+	struct devlink *dl = dp->ds->devlink;
+	struct dsa_switch *ds = dp->ds;
+	const unsigned char *id;
+	unsigned char len;
+	int err;
+
+	memset(dlp, 0, sizeof(*dlp));
+	devlink_port_init(dl, dlp);
+
+	if (ds->ops->port_setup) {
+		err = ds->ops->port_setup(ds, dp->index);
+		if (err)
+			return err;
+	}
+
+	id = (const unsigned char *)&dst->index;
+	len = sizeof(dst->index);
+
+	attrs.phys.port_number = dp->index;
+	memcpy(attrs.switch_id.id, id, len);
+	attrs.switch_id.id_len = len;
+
+	switch (dp->type) {
+	case DSA_PORT_TYPE_UNUSED:
+		attrs.flavour = DEVLINK_PORT_FLAVOUR_UNUSED;
+		break;
+	case DSA_PORT_TYPE_CPU:
+		attrs.flavour = DEVLINK_PORT_FLAVOUR_CPU;
+		break;
+	case DSA_PORT_TYPE_DSA:
+		attrs.flavour = DEVLINK_PORT_FLAVOUR_DSA;
+		break;
+	case DSA_PORT_TYPE_USER:
+		attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
+		break;
+	}
+
+	devlink_port_attrs_set(dlp, &attrs);
+	err = devlink_port_register(dl, dlp, dp->index);
+	if (err) {
+		if (ds->ops->port_teardown)
+			ds->ops->port_teardown(ds, dp->index);
+		return err;
+	}
+	dp->devlink_port_setup = true;
+
+	return 0;
+}
+
+static void dsa_port_devlink_teardown(struct dsa_port *dp)
+{
+	struct devlink_port *dlp = &dp->devlink_port;
+	struct dsa_switch *ds = dp->ds;
+
+	if (dp->devlink_port_setup) {
+		devlink_port_unregister(dlp);
+		if (ds->ops->port_teardown)
+			ds->ops->port_teardown(ds, dp->index);
+		devlink_port_fini(dlp);
+	}
+	dp->devlink_port_setup = false;
+}
+
 static int dsa_port_setup(struct dsa_port *dp)
 {
 	struct devlink_port *dlp = &dp->devlink_port;
@@ -472,6 +540,10 @@ static int dsa_port_setup(struct dsa_port *dp)
 	if (dp->setup)
 		return 0;
 
+	err = dsa_port_devlink_setup(dp);
+	if (err)
+		return err;
+
 	switch (dp->type) {
 	case DSA_PORT_TYPE_UNUSED:
 		dsa_port_disable(dp);
@@ -526,64 +598,12 @@ static int dsa_port_setup(struct dsa_port *dp)
 		dsa_port_disable(dp);
 	if (err && dsa_port_link_registered)
 		dsa_shared_port_link_unregister_of(dp);
-	if (err)
-		return err;
-
-	dp->setup = true;
-
-	return 0;
-}
-
-static int dsa_port_devlink_setup(struct dsa_port *dp)
-{
-	struct devlink_port *dlp = &dp->devlink_port;
-	struct dsa_switch_tree *dst = dp->ds->dst;
-	struct devlink_port_attrs attrs = {};
-	struct devlink *dl = dp->ds->devlink;
-	struct dsa_switch *ds = dp->ds;
-	const unsigned char *id;
-	unsigned char len;
-	int err;
-
-	memset(dlp, 0, sizeof(*dlp));
-	devlink_port_init(dl, dlp);
-
-	if (ds->ops->port_setup) {
-		err = ds->ops->port_setup(ds, dp->index);
-		if (err)
-			return err;
-	}
-
-	id = (const unsigned char *)&dst->index;
-	len = sizeof(dst->index);
-
-	attrs.phys.port_number = dp->index;
-	memcpy(attrs.switch_id.id, id, len);
-	attrs.switch_id.id_len = len;
-
-	switch (dp->type) {
-	case DSA_PORT_TYPE_UNUSED:
-		attrs.flavour = DEVLINK_PORT_FLAVOUR_UNUSED;
-		break;
-	case DSA_PORT_TYPE_CPU:
-		attrs.flavour = DEVLINK_PORT_FLAVOUR_CPU;
-		break;
-	case DSA_PORT_TYPE_DSA:
-		attrs.flavour = DEVLINK_PORT_FLAVOUR_DSA;
-		break;
-	case DSA_PORT_TYPE_USER:
-		attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
-		break;
-	}
-
-	devlink_port_attrs_set(dlp, &attrs);
-	err = devlink_port_register(dl, dlp, dp->index);
 	if (err) {
-		if (ds->ops->port_teardown)
-			ds->ops->port_teardown(ds, dp->index);
+		dsa_port_devlink_teardown(dp);
 		return err;
 	}
-	dp->devlink_port_setup = true;
+
+	dp->setup = true;
 
 	return 0;
 }
@@ -618,31 +638,15 @@ static void dsa_port_teardown(struct dsa_port *dp)
 		break;
 	}
 
-	dp->setup = false;
-}
-
-static void dsa_port_devlink_teardown(struct dsa_port *dp)
-{
-	struct devlink_port *dlp = &dp->devlink_port;
-	struct dsa_switch *ds = dp->ds;
+	dsa_port_devlink_teardown(dp);
 
-	if (dp->devlink_port_setup) {
-		devlink_port_unregister(dlp);
-		if (ds->ops->port_teardown)
-			ds->ops->port_teardown(ds, dp->index);
-		devlink_port_fini(dlp);
-	}
-	dp->devlink_port_setup = false;
+	dp->setup = false;
 }
 
-/* Destroy the current devlink port, and create a new one which has the UNUSED
- * flavour.
- */
-static int dsa_port_reinit_as_unused(struct dsa_port *dp)
+static int dsa_port_setup_as_unused(struct dsa_port *dp)
 {
-	dsa_port_devlink_teardown(dp);
 	dp->type = DSA_PORT_TYPE_UNUSED;
-	return dsa_port_devlink_setup(dp);
+	return dsa_port_setup(dp);
 }
 
 static int dsa_devlink_info_get(struct devlink *dl,
@@ -866,7 +870,6 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 {
 	struct dsa_devlink_priv *dl_priv;
 	struct device_node *dn;
-	struct dsa_port *dp;
 	int err;
 
 	if (ds->setup)
@@ -889,18 +892,9 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 	dl_priv = devlink_priv(ds->devlink);
 	dl_priv->ds = ds;
 
-	/* Setup devlink port instances now, so that the switch
-	 * setup() can register regions etc, against the ports
-	 */
-	dsa_switch_for_each_port(dp, ds) {
-		err = dsa_port_devlink_setup(dp);
-		if (err)
-			goto unregister_devlink_ports;
-	}
-
 	err = dsa_switch_register_notifier(ds);
 	if (err)
-		goto unregister_devlink_ports;
+		goto devlink_free;
 
 	ds->configure_vlan_while_not_filtering = true;
 
@@ -941,9 +935,7 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 		ds->ops->teardown(ds);
 unregister_notifier:
 	dsa_switch_unregister_notifier(ds);
-unregister_devlink_ports:
-	dsa_switch_for_each_port(dp, ds)
-		dsa_port_devlink_teardown(dp);
+devlink_free:
 	devlink_free(ds->devlink);
 	ds->devlink = NULL;
 	return err;
@@ -951,8 +943,6 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 
 static void dsa_switch_teardown(struct dsa_switch *ds)
 {
-	struct dsa_port *dp;
-
 	if (!ds->setup)
 		return;
 
@@ -971,8 +961,6 @@ static void dsa_switch_teardown(struct dsa_switch *ds)
 	dsa_switch_unregister_notifier(ds);
 
 	if (ds->devlink) {
-		dsa_switch_for_each_port(dp, ds)
-			dsa_port_devlink_teardown(dp);
 		devlink_free(ds->devlink);
 		ds->devlink = NULL;
 	}
@@ -1025,7 +1013,7 @@ static int dsa_tree_setup_ports(struct dsa_switch_tree *dst)
 		if (dsa_port_is_user(dp) || dsa_port_is_unused(dp)) {
 			err = dsa_port_setup(dp);
 			if (err) {
-				err = dsa_port_reinit_as_unused(dp);
+				err = dsa_port_setup_as_unused(dp);
 				if (err)
 					goto teardown;
 			}
-- 
2.37.1

