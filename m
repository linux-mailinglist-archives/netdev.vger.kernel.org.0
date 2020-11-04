Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4CFE2A6032
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 10:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbgKDJHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 04:07:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728989AbgKDJGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 04:06:38 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4912C061A4D
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 01:06:37 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id e2so1604363wme.1
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 01:06:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DTJOzm0gZUliIM1CJNEOWqPKlNYApXefDQfPPtC85HY=;
        b=aFbXdi65yd82soGVwLmvy7Zkj7puzP3tlWDEpJLWKc6c3ovAsCy4j2MSROqTyeZJ44
         K3tFlhh2YKybamQbocQs3KrJ1LfviUXKeMTiECQGyLQ2qHlSjksyYKaAoueAPNnV1IJC
         dQ2OE3GNaBV80sNaITRjXJxUEN5P5qIctgwgz90nTKDpYdqCvOqQlB8brj+HVoUtTKPh
         3FuLxpHRaeB7RsZwRtQV4LjCJNOGE5i7hPdqP5zg0aihpaepjdSj3RrJVrP8VpZce9o7
         c3qfZFbIGc0TuGqp/ukXo/pVH1VXuLEBY4pO2x+y2NNDZPyDXAJ+DqazP8r2s/pWe6tk
         5qXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DTJOzm0gZUliIM1CJNEOWqPKlNYApXefDQfPPtC85HY=;
        b=oVzzKWV1n88uUzCo0BlgaTJXtKfxYkvldimYXkYUTaYaX7l1P9eamUmL9wU7H5K0V6
         pUvRuWmk139dqkQcx5hCb+wQheFr2x4X8bZDCI3Dq+4RMc0xtIhp2gZHYE7S31XN+Rdc
         bYyJ33rD/qm0ABU09/1wH6ZJxdWJ9PPQkB/js/ARmnFbeA2PimDDf7BEnjfr5/Wqlxl9
         RIsHEJ7INlnz7CnvHvwdS7QeskCTVjakmARCZ1q+36/QmC8XgPtLVuMHZLMwkEkLpUe7
         IkXR6hymx/8ZdX8NtIVy9b6VFu2cKm02gcBpDzdsP+hVoekPHvZZ4FvhGCDWpTtbtUzP
         sezQ==
X-Gm-Message-State: AOAM5308AjznemkTwmiEUMPcMkIZXE0nrXWfyyj/Zi6IAgg8f2KnwXG7
        /wF8qi5tQu6GN3zlCzMwFk0aWQ==
X-Google-Smtp-Source: ABdhPJxBaA6Bp7PvuVjNkKD5jYF3dYv7+JL6snqExRkG7etBcqIuE/SBL8AemuDBsSRPuujgMPj9kw==
X-Received: by 2002:a1c:1b85:: with SMTP id b127mr3591594wmb.163.1604480796423;
        Wed, 04 Nov 2020 01:06:36 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id e25sm1607823wrc.76.2020.11.04.01.06.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 01:06:35 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Utz Bacher <utz.bacher@de.ibm.com>,
        Jens Osterkamp <Jens.Osterkamp@de.ibm.com>,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 10/12] net: ethernet: toshiba: ps3_gelic_net: Fix some kernel-doc misdemeanours
Date:   Wed,  4 Nov 2020 09:06:08 +0000
Message-Id: <20201104090610.1446616-11-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201104090610.1446616-1-lee.jones@linaro.org>
References: <20201104090610.1446616-1-lee.jones@linaro.org>
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
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/ethernet/toshiba/ps3_gelic_net.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
index d9a5722f561b5..f886e23f8ed0a 100644
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
@@ -1787,10 +1789,9 @@ static int ps3_gelic_driver_probe(struct ps3_system_bus_device *dev)
 	return result;
 }
 
-/**
+/*
  * ps3_gelic_driver_remove - remove a device from the control of this driver
  */
-
 static int ps3_gelic_driver_remove(struct ps3_system_bus_device *dev)
 {
 	struct gelic_card *card = ps3_system_bus_get_drvdata(dev);
-- 
2.25.1

