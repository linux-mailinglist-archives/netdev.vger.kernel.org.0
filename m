Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7E61C4779
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 21:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgEDT7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 15:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726419AbgEDT7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 15:59:06 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F9EC061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 12:59:04 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id d17so533978wrg.11
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 12:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=0aHh92ML8oduvR19KesGxpKGxDmTnMmLNmLo3d1fS3w=;
        b=fdzu0GpXFH6JzOzG5D1INdTzLsiQ/r9UJSQOe4qCsuzxxIdX7rHVaO+JCBp3XmOEls
         Jh/vKYae2DPHhDMO+BEBarkZ9vmRIxn7CwGxmyCcHh/UTqJlbuLPjg0fpbpjnkTDS0nz
         gycBIqrVd9QG+6En5ZjpQ7XqE43mkuL5YWqKlQ2HnW0T9UdzUBG7LvEG/VaH6WXoHUF+
         w+ZRDyySxjXLFg1MtTuTY6jPgFvCZJYZVZIA/h348eqrp6V2octK6MmkXAnBiK87YR+E
         q22zM9grI/4kop9PO7KpNj+woUQY9UOlJXRySyduPcpkHrgdgimF/X7bUV727Rol3rF8
         PIZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=0aHh92ML8oduvR19KesGxpKGxDmTnMmLNmLo3d1fS3w=;
        b=nC+avpqPK75K4CIgkGpAESiVjj4HyrUkAHlrIzA1NqkgaK0qumagd1Awvsu0XEdv1m
         oXwOPNSKzY6w67G4wjUpizEl0GrvJJ5Ltbo79Fu0i8M1kDda1b3OCx0xv1fXnP+CzEo9
         qzNcR3yKwKJnMeQ7weZbHK40mKADCt7Sqgf3oJBkg5jiQkkcZByZnyiqm/tUUAERbVuP
         JN1WO/9O6Faagbg9TjUOIMTyQWsQ11UverKt7slndSekABcqbZnYXsh1heL/HKMiYlgU
         huZ0BpMq2JAhiT3LEWGj/KnrukkSxh1nyJr2QAKQA2Yu55wQiPl7dfdS4Csszp5P2f+u
         Co2A==
X-Gm-Message-State: AGi0PuaC9AscILUMXqKR8hGuPnRlMMUMf6crsBi/TmY2GJ8x5E6Jnbfw
        6WxhZocX35Zad50nS6A9R2c=
X-Google-Smtp-Source: APiQypKhn1Uymvms8VnBwFBXGz4IAVGsOwIOw5601BcTF2Ei/8C7lCfi54fxmQ4fZVz3x7TP2Tg97A==
X-Received: by 2002:adf:d4ce:: with SMTP id w14mr981485wrk.232.1588622342988;
        Mon, 04 May 2020 12:59:02 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id c20sm791526wmd.36.2020.05.04.12.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 12:59:02 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH v2 net] net: dsa: remove duplicate assignment in dsa_slave_add_cls_matchall_mirred
Date:   Mon,  4 May 2020 22:58:56 +0300
Message-Id: <20200504195856.12340-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This was caused by a poor merge conflict resolution on my side. The
"act = &cls->rule->action.entries[0];" assignment was already present in
the code prior to the patch mentioned below.

Fixes: e13c2075280e ("net: dsa: refactor matchall mirred action to separate function")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Forgot to copy the netdev list.

 net/dsa/slave.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index ba8bf90dc0cc..a7f5fe64c2f3 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -856,20 +856,18 @@ dsa_slave_add_cls_matchall_mirred(struct net_device *dev,
 	struct dsa_port *to_dp;
 	int err;
 
-	act = &cls->rule->action.entries[0];
-
 	if (!ds->ops->port_mirror_add)
 		return -EOPNOTSUPP;
 
-	if (!act->dev)
-		return -EINVAL;
-
 	if (!flow_action_basic_hw_stats_check(&cls->rule->action,
 					      cls->common.extack))
 		return -EOPNOTSUPP;
 
 	act = &cls->rule->action.entries[0];
 
+	if (!act->dev)
+		return -EINVAL;
+
 	if (!dsa_slave_dev_check(act->dev))
 		return -EOPNOTSUPP;
 
-- 
2.17.1

