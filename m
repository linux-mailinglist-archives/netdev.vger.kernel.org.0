Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB502F8657
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 21:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388620AbhAOUKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 15:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728081AbhAOUKp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 15:10:45 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA619C0617A1
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 12:09:24 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id e15so2246936wme.0
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 12:09:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+qXCFwBbPWtbGR33uyQvB+16QfHJsg8zQueyUlEuj0c=;
        b=r4oAoo9yjHlPOAHenr5g1EEQfCJWwxaNTfc1ja5O6o5T1ZICU4yaeYLTltJ1ZwhWt1
         hYVV2trVas9eLp1262M7RtfrYIEz7l+5afdXAZLDAVgmpGypz488LOz8xh5YUONIahkt
         eE1JpBPouAfU6ZbgapMKocnQObleFyJlMh17sdT9uSaDfAJK1H4RLL3fR/jf1vPbZSl2
         3ZXGy84XFr6wdgvBhg4tUDvEZEEb9HvFdLNJXx4pfxdQa+bod0l65TCpu6pNojaqfRmz
         GZBTnODZc6DO9w3kWfCa8POUDB0h8esIyL2gH/Yx7pqneNMukxKM+5ngce4TNsbAFuly
         uH2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+qXCFwBbPWtbGR33uyQvB+16QfHJsg8zQueyUlEuj0c=;
        b=JK0G0IQiIGNe8AOKHrxZudn507nWqcWsBXhSQjo0GKLCVKFExNLYOi+bi2kvKMtEOu
         zt9m0+SDyJc49ZIn29h5M6KWSlXj4cGToqiYFEHgTJZjer3Q4cnjYMMgcBgGj0LSU85t
         HzYzaLInoIWBVaxzSs0zut/XjkF/jFP0bOeJI3CHf4TpmNNky6qbP+QKn4kaP+dBS8Af
         ND/NNRL1Y4AFfBdOEdGIxqn7TEl6Hy/5SmrdKzLAvjr+yTFQQ3AkjrY+sIScGG9dOg95
         n1q/vYLCdoEuZ3RVX4vZT9JCicTb8BpKEL3ApOgvdaY/Jtm/Hlhi7xfQeDzs2Xx6bB1t
         GSUA==
X-Gm-Message-State: AOAM533pywnaUi/1Nn+w6z2g7ur2VkV4cCwqzS995hdnS6i+Pm7KwCd+
        3LYVdjDYPiz5IFuUhJ30uCO1E6ph86FufXWf
X-Google-Smtp-Source: ABdhPJxGn2F+giS73DFxVcuMgHRX52afEr2GWeLUY9WVozvsYAH2KsUVC7lFq4bGhVvc5fGD15RuMQ==
X-Received: by 2002:a1c:1f86:: with SMTP id f128mr10246918wmf.174.1610741363617;
        Fri, 15 Jan 2021 12:09:23 -0800 (PST)
Received: from dell.default ([91.110.221.158])
        by smtp.gmail.com with ESMTPSA id d85sm9187863wmd.2.2021.01.15.12.09.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 12:09:22 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, Geoff Levand <geoff@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Utz Bacher <utz.bacher@de.ibm.com>,
        Jens Osterkamp <Jens.Osterkamp@de.ibm.com>,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH 6/7] net: ethernet: toshiba: ps3_gelic_net: Fix some kernel-doc misdemeanours
Date:   Fri, 15 Jan 2021 20:09:04 +0000
Message-Id: <20210115200905.3470941-7-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210115200905.3470941-1-lee.jones@linaro.org>
References: <20210115200905.3470941-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/ethernet/toshiba/ps3_gelic_net.c:1107: warning: Function parameter or member 'irq' not described in 'gelic_card_interrupt'
 drivers/net/ethernet/toshiba/ps3_gelic_net.c:1107: warning: Function parameter or member 'ptr' not described in 'gelic_card_interrupt'
 drivers/net/ethernet/toshiba/ps3_gelic_net.c:1407: warning: Function parameter or member 'txqueue' not described in 'gelic_net_tx_timeout'
 drivers/net/ethernet/toshiba/ps3_gelic_net.c:1439: warning: Function parameter or member 'napi' not described in 'gelic_ether_setup_netdev_ops'
 drivers/net/ethernet/toshiba/ps3_gelic_net.c:1639: warning: Function parameter or member 'dev' not described in 'ps3_gelic_driver_probe'
 drivers/net/ethernet/toshiba/ps3_gelic_net.c:1795: warning: Function parameter or member 'dev' not described in 'ps3_gelic_driver_remove'

Cc: Geoff Levand <geoff@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Utz Bacher <utz.bacher@de.ibm.com>
Cc: Jens Osterkamp <Jens.Osterkamp@de.ibm.com>
Cc: netdev@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/ethernet/toshiba/ps3_gelic_net.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
index 3d1fc8d2ca667..55e652624bd76 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
@@ -1100,7 +1100,7 @@ static int gelic_net_poll(struct napi_struct *napi, int budget)
 	return packets_done;
 }
 
-/**
+/*
  * gelic_card_interrupt - event handler for gelic_net
  */
 static irqreturn_t gelic_card_interrupt(int irq, void *ptr)
@@ -1400,6 +1400,7 @@ static void gelic_net_tx_timeout_task(struct work_struct *work)
 /**
  * gelic_net_tx_timeout - called when the tx timeout watchdog kicks in.
  * @netdev: interface device structure
+ * @txqueue: unused
  *
  * called, if tx hangs. Schedules a task that resets the interface
  */
@@ -1431,6 +1432,7 @@ static const struct net_device_ops gelic_netdevice_ops = {
 /**
  * gelic_ether_setup_netdev_ops - initialization of net_device operations
  * @netdev: net_device structure
+ * @napi: napi structure
  *
  * fills out function pointers in the net_device structure
  */
@@ -1632,7 +1634,7 @@ static void gelic_card_get_vlan_info(struct gelic_card *card)
 	dev_info(ctodev(card), "internal vlan %s\n",
 		 card->vlan_required? "enabled" : "disabled");
 }
-/**
+/*
  * ps3_gelic_driver_probe - add a device to the control of this driver
  */
 static int ps3_gelic_driver_probe(struct ps3_system_bus_device *dev)
@@ -1787,7 +1789,7 @@ static int ps3_gelic_driver_probe(struct ps3_system_bus_device *dev)
 	return result;
 }
 
-/**
+/*
  * ps3_gelic_driver_remove - remove a device from the control of this driver
  */
 
-- 
2.25.1

