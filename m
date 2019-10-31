Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33B2EEA91A
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 03:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbfJaCJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 22:09:42 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:40515 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726184AbfJaCJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 22:09:39 -0400
Received: by mail-qk1-f195.google.com with SMTP id y81so5241632qkb.7;
        Wed, 30 Oct 2019 19:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SffOY1YRL9xdOtjyuQFTVW3lR7f6e57nyKs5tVyvACA=;
        b=qKffUKbZvSoIPzdeXv+cmogmk/kiAJQIllSIscYzoeV87QMdCyUv/ge2uzTKWsBVzr
         55ifOe+Z3/jMbUelTuSwBtPaKqUr32l+hIl2ZOOK5ksHhTjDMWSYjTMtKDjMLcEQjL2G
         DziZIS93G8jnFBC82//vdfMJfROcQ4/f8KuzWas6b1fOeQ1mH/ExSlvC/CWgnIQnG05n
         Z2mczOSbmqQ2MNRScvDrKF6r8pSOlBUHotLBafpWXMBQUkd9hbs4FfbzTpyLt1JtJ/KN
         xoGRpZeySEQwizWkZL2KVIV6a03K7skJl/ZHlTepK1L/4N1kgKZMTseL3p71zGLf3g0Z
         wR6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SffOY1YRL9xdOtjyuQFTVW3lR7f6e57nyKs5tVyvACA=;
        b=V6XJFf3LTwdLQQkVmfMfoLwMoX+0RzH2KM33w3RttWLgQlGjc852vNUCm+TG6X+wdy
         M7NIGTv9No+z69xcbDy/CeWMDSWP80vi324xCpMbPt33UMwgw0iYV32hZT8cuHITGDsx
         k/7itBwrHeiSkqnhXrcXn7G9mKjCo2Q0xMjbx/s7Q9gGsgHU3sNCGIARzAkQOCMuPkiA
         Ul8DJnhrfPOOyZgvaeVr0lvg6l7wrZLYIPMA9IDG3+N163A0NDS0zGhv6H2WCOmfdp8f
         BsbtwGTbzgW7jAbJgqyKbcE/R/CG0vXu/PR+3ZMznB/sAbuzCs/1d03OQs655IYp90+4
         0JsQ==
X-Gm-Message-State: APjAAAWJ6p+GxkfeV/TlahOCWbjDsL4s0DEkh8xEXu+gFK0sjVMgPiit
        kKO7qh6yWZhcebDx7J4OY9E=
X-Google-Smtp-Source: APXvYqwM9QpotrIsha8utONVysoQPBms3/FxjR0oY6J52RmdEq7H+v+gXM6qVivydbZt3aDvP8skpg==
X-Received: by 2002:a05:620a:14b9:: with SMTP id x25mr1925192qkj.116.1572487776056;
        Wed, 30 Oct 2019 19:09:36 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id i41sm1455617qti.42.2019.10.30.19.09.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2019 19:09:35 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 2/7] net: dsa: remove ds->rtable
Date:   Wed, 30 Oct 2019 22:09:14 -0400
Message-Id: <20191031020919.139872-3-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191031020919.139872-1-vivien.didelot@gmail.com>
References: <20191031020919.139872-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drivers do not use the ds->rtable static arrays anymore, get rid of it.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 include/net/dsa.h | 7 -------
 net/dsa/dsa2.c    | 4 ----
 2 files changed, 11 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 3d7366d634d8..b46222adb5c2 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -258,13 +258,6 @@ struct dsa_switch {
 	 */
 	const struct dsa_switch_ops	*ops;
 
-	/*
-	 * An array of which element [a] indicates which port on this
-	 * switch should be used to send packets to that are destined
-	 * for switch a. Can be NULL if there is only one switch chip.
-	 */
-	s8		rtable[DSA_MAX_SWITCHES];
-
 	/*
 	 * Slave mii_bus and devices for the individual ports.
 	 */
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 222d7dbfcfea..efd7453f308e 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -181,10 +181,6 @@ static bool dsa_switch_setup_routing_table(struct dsa_switch *ds)
 	struct dsa_switch_tree *dst = ds->dst;
 	bool complete = true;
 	struct dsa_port *dp;
-	int i;
-
-	for (i = 0; i < DSA_MAX_SWITCHES; i++)
-		ds->rtable[i] = DSA_RTABLE_NONE;
 
 	list_for_each_entry(dp, &dst->ports, list) {
 		if (dp->ds == ds && dsa_port_is_dsa(dp)) {
-- 
2.23.0

