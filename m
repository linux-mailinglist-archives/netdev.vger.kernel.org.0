Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4A5A20DD96
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731706AbgF2TOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731654AbgF2TOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:14:04 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543B7C00E3C9
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 05:04:18 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id o2so15872710wmh.2
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 05:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kk4GqzupyJ/zMhEjt50iMo8E42JSASWwyoRhFrVXFkw=;
        b=s9kteNeXi1zTwB+iA/Da/H/SPwbWFgSRcTYjOhHXHWF3DK4DgkjnWLtB3kXWUYcT73
         hrQ3sZLr45ONRMe37aZJiaJZqvsJkdNy022pJEVyvesHs/Usys8f1PNEbBh/x2TgLjW5
         MzXNu61KMK8OAc8kI7zqSWj6yUSfkkAeWvduGtmpBPGg5zflFGTAloz+lI6SH8ZeyaF4
         fgHItffrSY9r+xFcjDC7cJKNDoYT11AD7qfDTq0LviqPvjIASWNkM3GOYEhgZi13/HMO
         nbFl97jRYhP8AwnmUe5P7dnadnS6u8YZj+1fWhK6Oe2uxf6rzW6Igdl90lnBrDHpjR5z
         NqZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kk4GqzupyJ/zMhEjt50iMo8E42JSASWwyoRhFrVXFkw=;
        b=otCPH3vhhN5OCaNivrQ/zHC3z0JVI3N74Rbmr3AgyjiCrDqDYPka1NM8Y9VHOj1Jsh
         YF95g3l+kyL/IadtkNaEzZi7nt6dYAtLR1n9H2r4LqePAzmZnmgm6uZ3LTZYTIzx2JE1
         4ytiwESIM5NvOJUVKCppln2f8WLZ5MqwnrPA0kt5TDHxfxtuQ3hPVEPVRsDppH+5qDto
         EdecS0Y8MXLYUXJ/WNp/52bx+yb/urTSn9Cqi6V3z10ocHqdyYhycg0/lwfl6395CR/5
         dd+rweKpwy+YgIf8lKxgv/6WUfT7oxDf9DTHEq5abVAhT1OTWoGf0zXc0tAsYWrwNybM
         m65g==
X-Gm-Message-State: AOAM533KjVzJLjdc7YYxMRvj067oy0Fo6/6RLqk1OoIKkj6H2G8dalRY
        2feEPzGfjx7u2EYhRA1uzyFHnA==
X-Google-Smtp-Source: ABdhPJyWDqDeFgVInuObhpy/Ftb/2DR2R2EIJXvEfaNkWasvMTcTlNr2GvJFRYK1k6XxTkq/Wt9wfQ==
X-Received: by 2002:a1c:cc0d:: with SMTP id h13mr17832883wmb.168.1593432256110;
        Mon, 29 Jun 2020 05:04:16 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id d81sm25274347wmc.0.2020.06.29.05.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 05:04:15 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH v2 03/10] net: devres: rename the release callback of devm_register_netdev()
Date:   Mon, 29 Jun 2020 14:03:39 +0200
Message-Id: <20200629120346.4382-4-brgl@bgdev.pl>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200629120346.4382-1-brgl@bgdev.pl>
References: <20200629120346.4382-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Make it an explicit counterpart to devm_register_netdev() just like we
do with devm_free_netdev() for better clarity.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 net/devres.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/devres.c b/net/devres.c
index 57a6a88d11f6..1f9be2133787 100644
--- a/net/devres.c
+++ b/net/devres.c
@@ -39,7 +39,7 @@ struct net_device *devm_alloc_etherdev_mqs(struct device *dev, int sizeof_priv,
 }
 EXPORT_SYMBOL(devm_alloc_etherdev_mqs);
 
-static void devm_netdev_release(struct device *dev, void *this)
+static void devm_unregister_netdev(struct device *dev, void *this)
 {
 	struct net_device_devres *res = this;
 
@@ -77,7 +77,7 @@ int devm_register_netdev(struct device *dev, struct net_device *ndev)
 				 netdev_devres_match, ndev)))
 		return -EINVAL;
 
-	dr = devres_alloc(devm_netdev_release, sizeof(*dr), GFP_KERNEL);
+	dr = devres_alloc(devm_unregister_netdev, sizeof(*dr), GFP_KERNEL);
 	if (!dr)
 		return -ENOMEM;
 
-- 
2.26.1

