Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2592320CA20
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 21:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbgF1Tyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 15:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726929AbgF1Tx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 15:53:59 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E08BC03E979;
        Sun, 28 Jun 2020 12:53:59 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id w6so14532467ejq.6;
        Sun, 28 Jun 2020 12:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iZR0CLUeN8paQkiNldz9uiOSLfW0tnjjbz4UVcCADzk=;
        b=ToEHJ4P779R3as4H8AN4Wawahh+8LXXwG4HKHeDHV1c49P+KFrJ1bwgDXNjy133HGY
         +rwLKej7PyOUXnZDd7kYjy6bw7O3RYp1Hpo4YITt/KoLZXX5ANqEJ9g78tuBO3wPksWZ
         xvoWFN9+/xbeqEOtLAVvxe8xMVLmYNXnGONnK32swszHyHLVkw5ARwmLtLpcTG3tJ8kJ
         UfK1mXMjZUxdnfRnNHZunV3/QM30gl8nCv0kQA1qeGjmP91STJ9LcXZIXUqE4WrTyeBk
         C3eEg3zxMVNcTAg9U+0oAquZLtWBO3NSU/jdmfLATl5LmSzDVy6diTJMAm37ZPuiDJqh
         Qu7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iZR0CLUeN8paQkiNldz9uiOSLfW0tnjjbz4UVcCADzk=;
        b=SBWSIH6Dwqu7VrGe+o5+7/Ja9IMz78T9l7t6D/ch98VCGc4pGcfaa68m/MSvMnT5jY
         Ng331j3sRjZlA2CEitVCfeNZcY2rhq2JOiaw9slHfUpKPP9wbXiOx9NGgflWdsVII/ha
         R78UhJ6k1onikvWoRZk5ub+8ZJfnVz7peWHvLRYb3N8VjRSM0gjXbLGiRyUIsWIwIvj/
         qj3P0hv8U3PKPo1tJQOBeMYLRBDSZGTy/50ujo0NbXQdw2ICEfZNw2gJQbqafj+3EWX3
         0nxeh4L0OnzOdg2BMJvSprcrDGeLISPq0zeQ1prnCJrNA3GFOihR5BIBLy0v1u5bDpNq
         J6Qw==
X-Gm-Message-State: AOAM532fiDjlCcqJIQ0iUo+PbocuL73/A41azbE+UDAuizM9gs5q/2o8
        K1vtO7LHBRNgqaem7cOoC5GLivyq
X-Google-Smtp-Source: ABdhPJxpSRlCDWbL3AZhB0RUJyt8jD1tL5ru5iFy5rhG4IONxBHio2q7Q+X3Ig0aX7Tcmz1JFukjMQ==
X-Received: by 2002:a17:906:9147:: with SMTP id y7mr10419402ejw.399.1593374037855;
        Sun, 28 Jun 2020 12:53:57 -0700 (PDT)
Received: from localhost.localdomain ([2a02:a03f:b7f9:7600:f145:9a83:6418:5a5c])
        by smtp.gmail.com with ESMTPSA id z8sm15669531eju.106.2020.06.28.12.53.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2020 12:53:57 -0700 (PDT)
From:   Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        oss-drivers@netronome.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Subject: [PATCH 13/15] net/hsr: fix hsr_dev_xmit()'s return type
Date:   Sun, 28 Jun 2020 21:53:35 +0200
Message-Id: <20200628195337.75889-14-luc.vanoostenryck@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200628195337.75889-1-luc.vanoostenryck@gmail.com>
References: <20200628195337.75889-1-luc.vanoostenryck@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
which is a typedef for an enum type, but the implementation in this
driver returns an 'int'.

Fix this by returning 'netdev_tx_t' in this driver too.

Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
---
 net/hsr/hsr_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index cd99f548e440..7be85e024236 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -210,7 +210,7 @@ static netdev_features_t hsr_fix_features(struct net_device *dev,
 	return hsr_features_recompute(hsr, features);
 }
 
-static int hsr_dev_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t hsr_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct hsr_priv *hsr = netdev_priv(dev);
 	struct hsr_port *master;
-- 
2.27.0

