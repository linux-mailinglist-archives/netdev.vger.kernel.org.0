Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27FD91CDE29
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 17:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730319AbgEKPIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 11:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730295AbgEKPI3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 11:08:29 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C01C05BD09
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 08:08:28 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id y3so11432300wrt.1
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 08:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TLMq2XwRgUC25FFpg44rE1jATuYcYABivRm1tKC5XTM=;
        b=lGEfjqd/Aqo91nNbYHQC/XXhvPNRro/VrpfSU0EKrgUiO5UJ0lZXxyaNjy0vwymwSb
         uxwP22CTUu7BkW2bIoeK3qhHOwvoFsYhIhZngMUlHLW4GZlrj2EaI2Od7rJuyEum2hPJ
         mOOddMd5+KhA4BsHVTsFc1TO02ZsDR/PDJsjrmcYeCSNntHIyaYLDAKJYR4kDyHYUkdo
         fa8cnqPq4/GDF/sZDgDOT2ZTLehxieagSqPBErq+zM756mvMYXQKGiraMxfd2vT4/Pq4
         A/Z1mAM/jRHFEXGLC9eB34BPWmePWBU9/Ou4b7W0qT+98gs2/rruU5IXXYcZJR3Y5Amy
         Dh+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TLMq2XwRgUC25FFpg44rE1jATuYcYABivRm1tKC5XTM=;
        b=rSVninHdkrflVf677xcD9YycHmJaQfYUSgfg/hE1bnG+QjSHPYkSCvUcoB7h+jKf1m
         J9ipRfLKx3DliscFL8RiGfD7pNUtseFCE9IOakmsMzCwApCzggcnIjPIaKhoJTZ57Q3q
         OdB8NZX+fAiUjkI8KHq5NQWxFcRq9D9/94s/9zaemyK6b3bnfug/WHEKnHp+NbnCBqmL
         ptWca/vMEBK1SIMv06+z1bDpJXOa6XWQZl7g6uunUdNAEO7UbowxkKN+AXOoXp0KUnhR
         CsbazKplQ0cQYK4jBjzP6H0bDyWcu5zIxy1i3X35QxYkp6Y6pcZvAU7boIRvulsZivUm
         5j8g==
X-Gm-Message-State: AGi0PuaKfK7zF9t9ShmaiBWv9cKkhE6ukfz5N5V9p3//onHiwYroy/oG
        7WOnwfB1Fgh+37Ihd2LDEkQvaA==
X-Google-Smtp-Source: APiQypLrstV08k3pPp3S+tVHPnE3B6GnlgxYC6jtUQXLXJtg4uaQOjgd0DZV0NaM/PAy80Q8A9SMbg==
X-Received: by 2002:a5d:4801:: with SMTP id l1mr18746418wrq.235.1589209706975;
        Mon, 11 May 2020 08:08:26 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id 94sm3514792wrf.74.2020.05.11.08.08.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 08:08:26 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Edwin Peer <edwin.peer@broadcom.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH v2 05/14] net: core: provide priv_to_netdev()
Date:   Mon, 11 May 2020 17:07:50 +0200
Message-Id: <20200511150759.18766-6-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200511150759.18766-1-brgl@bgdev.pl>
References: <20200511150759.18766-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Appropriate amount of extra memory for private data is allocated at
the end of struct net_device. We have a helper - netdev_priv() - that
returns its address but we don't have the reverse: a function which
given the address of the private data, returns the address of struct
net_device.

This has caused many drivers to store the pointer to net_device in
the private data structure, which basically means storing the pointer
to a structure in this very structure.

This patch proposes to add priv_to_netdev() - a helper which converts
the address of the private data to the address of the associated
net_device.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 include/linux/netdevice.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 130a668049ab..933c6808a87f 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2249,6 +2249,18 @@ static inline void *netdev_priv(const struct net_device *dev)
 	return (char *)dev + ALIGN(sizeof(struct net_device), NETDEV_ALIGN);
 }
 
+/**
+ *	priv_to_netdev - get the net_device from private data
+ *	@priv: net_device private data
+ *
+ * Get the address of network device associated with this private data.
+ */
+static inline struct net_device *priv_to_netdev(void *priv)
+{
+	priv = (char *)priv - ALIGN(sizeof(struct net_device), NETDEV_ALIGN);
+	return (struct net_device *)priv;
+}
+
 /* Set the sysfs physical device reference for the network logical device
  * if set prior to registration will cause a symlink during initialization.
  */
-- 
2.25.0

