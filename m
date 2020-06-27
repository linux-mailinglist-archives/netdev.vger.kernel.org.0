Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A381320C12C
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 14:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgF0MDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 08:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbgF0MDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 08:03:22 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E47C03E979
        for <netdev@vger.kernel.org>; Sat, 27 Jun 2020 05:03:22 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id a1so11764786ejg.12
        for <netdev@vger.kernel.org>; Sat, 27 Jun 2020 05:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QymiGcAXjM/8xTeHmmvjGy/xOKmj/n1E9kYOpwUdE9k=;
        b=c19FgAp2bUylwhDGSUfKI4B4WF29Jri0u4GMJXGkEqTKb/hAptoFa7dJ3iEBGMGIwN
         miFKPdJNszZvbZuXAskVIoQnFL79TSwNEdmE0qS424TarGdX6QasToOUKjJKfnjoK7nr
         wXwOnZO8a637g/ZCDoplkPvLIf+wTb+V/K0xw1oHhRDY2B8FZWIJYGMSG7j0yD01e228
         cmRHg6l3eKiylwyal8NFJL+1sHPKRjGhdfCDLtMI3AbJE1XfVdUIVTPUtJ6PD+29Dxuy
         OhrLzV67AXCgrBEaSa7l3OldtPlj+CgfmX8iUo1PfCblhdkDFOMUtNC/A+H7L9+7+unz
         pGXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QymiGcAXjM/8xTeHmmvjGy/xOKmj/n1E9kYOpwUdE9k=;
        b=nsjcjwMQQXzb3Uh2dmkWeXViLMLhUh4mvHzENNC6os4fxHqQ0gQ6booigt+e2UfnkB
         PiAlgu0iEKupQCyNpJCcDMFFg1Bk6h96kN28U3jlw8o5MpRGQIQ3zxlNps0ro6B05cgR
         TCfrrAHZHwAxJF68eID4QY6JhLbbfgDP9uPEr1zRHLtSfvWpBvyKPbuKRIoiCSQqc5W6
         bJX4hPh1I/gt4FX5MHVhdSLb6gD4BKYlUWaAEj6vYVijE0mxGXEX0IS2MjYXGvYjR8nh
         iGr1Y/J6KerbHcKx3OR56y8afMaJK2HEBb7ivk1PTIfJlnETLquqSQ/1kfgByk2ofQqT
         qVHA==
X-Gm-Message-State: AOAM532dCcOC3KMHLnYiP8DK50n0puwwbPK2HYVSqQQjCswtLweWf8rk
        cteeXNk2lyKywqV8U0QYaYg=
X-Google-Smtp-Source: ABdhPJxuI4rM55c7hFhJa3+OYozRh0gIsScWOyQ/86LCrLyPICKrMhgig0gaaPeQN2B4bv+QE/Ltlw==
X-Received: by 2002:a17:906:1499:: with SMTP id x25mr6309142ejc.406.1593259401158;
        Sat, 27 Jun 2020 05:03:21 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id f19sm12095942edr.68.2020.06.27.05.03.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Jun 2020 05:03:20 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     UNGLinuxDriver@microchip.com, alexandre.belloni@bootlin.com
Subject: [PATCH net-next] net: mscc: ocelot: remove EXPORT_SYMBOL from ocelot_net.c
Date:   Sat, 27 Jun 2020 15:03:06 +0300
Message-Id: <20200627120306.282071-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Now that all net_device operations are bundled together inside
mscc_ocelot.ko and no longer part of the common library, there's no
reason to export these symbols.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_net.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 702b42543fb7..5868ff753232 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -953,7 +953,6 @@ static int ocelot_netdevice_event(struct notifier_block *unused,
 struct notifier_block ocelot_netdevice_nb __read_mostly = {
 	.notifier_call = ocelot_netdevice_event,
 };
-EXPORT_SYMBOL(ocelot_netdevice_nb);
 
 static int ocelot_switchdev_event(struct notifier_block *unused,
 				  unsigned long event, void *ptr)
@@ -975,7 +974,6 @@ static int ocelot_switchdev_event(struct notifier_block *unused,
 struct notifier_block ocelot_switchdev_nb __read_mostly = {
 	.notifier_call = ocelot_switchdev_event,
 };
-EXPORT_SYMBOL(ocelot_switchdev_nb);
 
 static int ocelot_switchdev_blocking_event(struct notifier_block *unused,
 					   unsigned long event, void *ptr)
@@ -1008,7 +1006,6 @@ static int ocelot_switchdev_blocking_event(struct notifier_block *unused,
 struct notifier_block ocelot_switchdev_blocking_nb __read_mostly = {
 	.notifier_call = ocelot_switchdev_blocking_event,
 };
-EXPORT_SYMBOL(ocelot_switchdev_blocking_nb);
 
 int ocelot_probe_port(struct ocelot *ocelot, u8 port,
 		      void __iomem *regs,
@@ -1054,4 +1051,3 @@ int ocelot_probe_port(struct ocelot *ocelot, u8 port,
 
 	return err;
 }
-EXPORT_SYMBOL(ocelot_probe_port);
-- 
2.25.1

