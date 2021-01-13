Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1D82F5041
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 17:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727997AbhAMQnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 11:43:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726544AbhAMQnF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 11:43:05 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60897C0617B1
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 08:41:37 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id q18so2841586wrn.1
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 08:41:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+qXCFwBbPWtbGR33uyQvB+16QfHJsg8zQueyUlEuj0c=;
        b=rIamJQ5/O9hXkJ8XV2Qoa49nIlK/UCnw1dPZbM1yTQe0gWuyYEkLbLMoqCSttZ3SvF
         NVZCqAkOlEdu6kvDZ5i16teL5uv0tNMcqyuPa2g+yBVR5/vNCg8f5cid6BPfoqb6Nbs9
         dmyJTRYuHMxbemXAl+cjgrqPQ+etMSJf3lzEVyREWL9unc69uINsTW/B/Jzd99C9xDh/
         RbRgrafutQWccR4an6CigbITNw3AL5qMMQHVnZySXP4c412om23Ykm1soyq8xB1eXjNh
         SY0Wuvh3mSuTA6RP3M0PI4k8t2rCrSRNpj0C0SWZvrEEyoYzSNcupk923IWGDZHCZ2sB
         2EoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+qXCFwBbPWtbGR33uyQvB+16QfHJsg8zQueyUlEuj0c=;
        b=GTWB4vamopQmsRv/DZadydMbmJFjaGbiuTSD0jp6ak3+pm24VEUwElaks/UStFfswP
         uNNbSNYXC6VsDYGj8ExfcrdFHZoaeLmiGuEpGR5sjwH0k1++XeVhiO0Vhs3OLh3qy7f+
         4T1sFF4rXwR9jWgSlnEr6FOLn/mESrBcwG+JQcE0S7N8DBMDr5PLoK2U83piZRjHvsLq
         1LJm2Z0/4VH7yLSMFmrOW3ce3Rrf9AbTqHuLSziZsVwKD/7IULsxn2R+kZlbhcN7wD7T
         OpLQFW8LVmolcezj1wMAbddDygkMNGd78h1iULQBOQUN8Szd8eiU5im5/WdKrmJkBMlz
         UdCQ==
X-Gm-Message-State: AOAM530as578J/HvnjTWgXr8OW0nXe7Qij0FSF3eBKN6Y6TDEzKFbCVH
        hjwmWn26rcMG3/wVJEH1ilJYrw==
X-Google-Smtp-Source: ABdhPJxzOgUK+XK3f39KvQ3vh1E31kzzc9NtmTkqwTO8srWMzsBXKhZIBDSUdCVDXGWh6bG88Jd7oA==
X-Received: by 2002:a5d:4307:: with SMTP id h7mr3529768wrq.353.1610556096162;
        Wed, 13 Jan 2021 08:41:36 -0800 (PST)
Received: from dell.default ([91.110.221.229])
        by smtp.gmail.com with ESMTPSA id t16sm3836510wmi.3.2021.01.13.08.41.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 08:41:35 -0800 (PST)
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
Date:   Wed, 13 Jan 2021 16:41:22 +0000
Message-Id: <20210113164123.1334116-7-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210113164123.1334116-1-lee.jones@linaro.org>
References: <20210113164123.1334116-1-lee.jones@linaro.org>
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

