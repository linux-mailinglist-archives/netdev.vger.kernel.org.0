Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7E95EA920
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 03:10:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbfJaCKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 22:10:01 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:33361 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbfJaCJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 22:09:41 -0400
Received: by mail-qk1-f194.google.com with SMTP id 71so5289092qkl.0;
        Wed, 30 Oct 2019 19:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xaGGtBuax3hb6qJLP5PzBUb6xfigHgBeC3bx4HxlSw4=;
        b=SCD6f8gl+v3d9pFBq2oX0oRGbkt0QfcFBDCYTjaliL29WCn58LwTdhgeF5W5TrFI4Q
         KXAJsLqEq8j02OMJhxl4Jm56w4hL5UgmniAgR62eFC9pnijkmkAvTbTkb/axVegAvDV0
         V7+PnBfJnW1GLPXx1xZUjATFL0NO43QVoa52X+pr5UIU8Hv+Us/HxARCUDeI+nED1FYc
         wc2Y10ea03s/8FFlQcsxKLNmvos5NyHAeVo/E6xn4Hil5F4xYzSEJJqYDC/PZt6Qp9yb
         /4aSkJMCycv379q+faRW7y2Vredxdq338NRkyQlzzE2FoYEkT9DQStaB2qGEr3ZAiBaN
         ckXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xaGGtBuax3hb6qJLP5PzBUb6xfigHgBeC3bx4HxlSw4=;
        b=VaLYBIeNxt5mxnmFog5HuJN2cA9PyF7dfpD4uxk4hRbZL+D6+Go6G1QEWwzW0Hpnhr
         NMnLhCYbBELTMh7zy1BUbwpV1zz2rPeWSwthaXZlClVJlujA2eCmRph6yCCTZ/stD2l2
         Mm0wfjFUgvCAW6/1qSBUEcdm2jYGU+0HStDEZa3DCooLeh0GMOXG88HAguJTyHw0mIy/
         nW/MiOLWmfqaKOtOSITaQ7TJqfUesoMZxyy2Gv6JnuVc1cbmZG+XspdxS0F2DGICtm+O
         1mCVYDemKyLaY58K/+3RpvAqjK7xUzfjW9oabTkkpt5bRII07JdzvGV0H+1D/SSh6yEP
         vtmA==
X-Gm-Message-State: APjAAAXJjqaHcwLccxDlPhCRujJKFyuMfXm67NeJjZDxDeuawAhYXwJT
        l/ycrgbgQN3iKGr/duXH/mM=
X-Google-Smtp-Source: APXvYqx3Irbr0kRJSM8oT99FpYK1j4tnSuMf8tGAd2t5hlPWJlfmfUnypUQuHkDEodoP7nDbl/myaA==
X-Received: by 2002:a37:4f4d:: with SMTP id d74mr3182606qkb.51.1572487780936;
        Wed, 30 Oct 2019 19:09:40 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id 187sm1277076qkk.103.2019.10.30.19.09.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2019 19:09:40 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 5/7] net: dsa: remove tree functions related to switches
Date:   Wed, 30 Oct 2019 22:09:17 -0400
Message-Id: <20191031020919.139872-6-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191031020919.139872-1-vivien.didelot@gmail.com>
References: <20191031020919.139872-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DSA fabric setup code has been simplified a lot so get rid of
the dsa_tree_remove_switch, dsa_tree_add_switch and dsa_switch_add
helpers, and keep the code simple with only the dsa_switch_probe and
dsa_switch_remove functions.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 net/dsa/dsa2.c | 43 ++++++++++---------------------------------
 1 file changed, 10 insertions(+), 33 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 92e71b12b729..371f15042dad 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -573,29 +573,6 @@ static void dsa_tree_teardown(struct dsa_switch_tree *dst)
 	dst->setup = false;
 }
 
-static void dsa_tree_remove_switch(struct dsa_switch_tree *dst,
-				   unsigned int index)
-{
-	dsa_tree_teardown(dst);
-
-	dsa_tree_put(dst);
-}
-
-static int dsa_tree_add_switch(struct dsa_switch_tree *dst,
-			       struct dsa_switch *ds)
-{
-	int err;
-
-	dsa_tree_get(dst);
-
-	err = dsa_tree_setup(dst);
-	if (err) {
-		dsa_tree_put(dst);
-	}
-
-	return err;
-}
-
 static struct dsa_port *dsa_port_touch(struct dsa_switch *ds, int index)
 {
 	struct dsa_switch_tree *dst = ds->dst;
@@ -846,15 +823,9 @@ static int dsa_switch_parse(struct dsa_switch *ds, struct dsa_chip_data *cd)
 	return dsa_switch_parse_ports(ds, cd);
 }
 
-static int dsa_switch_add(struct dsa_switch *ds)
-{
-	struct dsa_switch_tree *dst = ds->dst;
-
-	return dsa_tree_add_switch(dst, ds);
-}
-
 static int dsa_switch_probe(struct dsa_switch *ds)
 {
+	struct dsa_switch_tree *dst;
 	struct dsa_chip_data *pdata;
 	struct device_node *np;
 	int err;
@@ -878,7 +849,13 @@ static int dsa_switch_probe(struct dsa_switch *ds)
 	if (err)
 		return err;
 
-	return dsa_switch_add(ds);
+	dst = ds->dst;
+	dsa_tree_get(dst);
+	err = dsa_tree_setup(dst);
+	if (err)
+		dsa_tree_put(dst);
+
+	return err;
 }
 
 int dsa_register_switch(struct dsa_switch *ds)
@@ -897,7 +874,6 @@ EXPORT_SYMBOL_GPL(dsa_register_switch);
 static void dsa_switch_remove(struct dsa_switch *ds)
 {
 	struct dsa_switch_tree *dst = ds->dst;
-	unsigned int index = ds->index;
 	struct dsa_port *dp, *next;
 
 	list_for_each_entry_safe(dp, next, &dst->ports, list) {
@@ -905,7 +881,8 @@ static void dsa_switch_remove(struct dsa_switch *ds)
 		kfree(dp);
 	}
 
-	dsa_tree_remove_switch(dst, index);
+	dsa_tree_teardown(dst);
+	dsa_tree_put(dst);
 }
 
 void dsa_unregister_switch(struct dsa_switch *ds)
-- 
2.23.0

