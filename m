Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72D9FE7966
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 20:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731780AbfJ1Twj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 15:52:39 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:35509 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731734AbfJ1Twh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 15:52:37 -0400
Received: by mail-qt1-f195.google.com with SMTP id l3so5904874qtp.2;
        Mon, 28 Oct 2019 12:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zxJbXojmdDGiYrHKrxAhLmyHPp34QNH8YoTWtkhI+cw=;
        b=H+j8o4bcDx5VGVLuxjNwU6AQbNZQb/iTxXUpQ9Ls1OYmDRn15qNts1lHH1bs3nNUY3
         GK6oZZkDrloYVWLpETxVFB8u0Auy0bLPPedyoFP48h2g+EWmQEkxnO7362HOEJ6Dy9YG
         g2oQln2FNPWLi2RhDrAbIrVx90CJ8uKGUXPuhaREJDNUXp5cNcp0QbRRgUSnIbTVdWrJ
         N2AI0SQ2bI9YRy73XhIn6bn4f284FPRkIdM4E5dIfxI1mDvn1U2pp9waIhVZhslYWFMQ
         QvOpk3wUJNiOQyyUSyGksRCT2MPXODYIdSUz/b9g+SxSJX5hwBLNpgaATIrPMUH5BP/3
         4lmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zxJbXojmdDGiYrHKrxAhLmyHPp34QNH8YoTWtkhI+cw=;
        b=XmK5KlpJUKroAOXRsk/Jp+gKMBFs07+XcgY1+e/gd6etA1LA41Z+U7ZFUGNCHRyv0t
         qmGv3nx+vV+owGFyhGhO5CKmszgpzqayB3e73ZqVNxxVCLgtVdhYgZcuDp96q4RMVYR4
         a+HPqKxfcOZXR5G3DT82/GFN0998Ju4411to25jNAHtdRAM7qhliiw0LBNpMLZBgwSdy
         HesEzbvMbfZDg5X71dtS415YYHv4erAuY8QzcLilDuqyQKOnwMWUoIonl3tT4VoV3dKj
         8z8NsUJ+pofwtImMjduWJePTgVEIDmmJ/HTgpPi+fag58Xt/n7ctNFwjtGF55SfY0D5n
         /lSQ==
X-Gm-Message-State: APjAAAUtdPDWps04G3iWozJ3dy3iE8dNbwsJjJhH0rM1wNCURDCO02sC
        d3rL28jjxBNabNLNjjCAchw=
X-Google-Smtp-Source: APXvYqx+XJZMS6QrBrc6Iw+4ZPufnTxeh0/N0/Fyn30MFYkklxJ/gP3MDuiQHQYW5mn9YGfvpsyBFg==
X-Received: by 2002:aed:3ee4:: with SMTP id o33mr158923qtf.267.1572292356637;
        Mon, 28 Oct 2019 12:52:36 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id 189sm6056812qki.10.2019.10.28.12.52.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 12:52:36 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: [PATCH net-next 5/7] net: dsa: remove tree functions related to switches
Date:   Mon, 28 Oct 2019 15:52:18 -0400
Message-Id: <20191028195220.2371843-6-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191028195220.2371843-1-vivien.didelot@gmail.com>
References: <20191028195220.2371843-1-vivien.didelot@gmail.com>
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
index 8cddc1b3304f..5d030e2d0b7d 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -566,29 +566,6 @@ static void dsa_tree_teardown(struct dsa_switch_tree *dst)
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
@@ -839,15 +816,9 @@ static int dsa_switch_parse(struct dsa_switch *ds, struct dsa_chip_data *cd)
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
@@ -871,7 +842,13 @@ static int dsa_switch_probe(struct dsa_switch *ds)
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
@@ -890,7 +867,6 @@ EXPORT_SYMBOL_GPL(dsa_register_switch);
 static void dsa_switch_remove(struct dsa_switch *ds)
 {
 	struct dsa_switch_tree *dst = ds->dst;
-	unsigned int index = ds->index;
 	struct dsa_port *dp, *next;
 
 	list_for_each_entry_safe(dp, next, &dst->ports, list) {
@@ -898,7 +874,8 @@ static void dsa_switch_remove(struct dsa_switch *ds)
 		kfree(dp);
 	}
 
-	dsa_tree_remove_switch(dst, index);
+	dsa_tree_teardown(dst);
+	dsa_tree_put(dst);
 }
 
 void dsa_unregister_switch(struct dsa_switch *ds)
-- 
2.23.0

