Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3A9120CA36
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 21:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbgF1Txu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 15:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbgF1Txs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 15:53:48 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD82AC03E97B;
        Sun, 28 Jun 2020 12:53:47 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id h28so11146510edz.0;
        Sun, 28 Jun 2020 12:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FkEfzQFYhiTTzIfLmoFDGHIS3u7YcXXOiJy6nfPZIrQ=;
        b=DiaK0MfgTCNEv/bYJOycIrJnQ+dTB96cNpQZaeWYfRY8pT+Gf1HveHth8+mY9m4R1R
         WfwI2rgxPnHguKWTKquz2/dneH+2JFPiPyZdiuKAAnDOq2qVfITb0fsfLo66k0rN8OUJ
         YAgbM5qF8Fgf7cgGAtyv78AxYyM0uWd05rAkQY1xpCiA/fwMmrKduE919u86wwDzTjpa
         iM3aXKvGiQxUWaL91O4qRkCLljOdbDAO8vLwvlsDa3YgAR/SlcPzvno/PXQqbyRV7aU1
         22dDO0tioJ1ekBkyBXFtxNZHnr0CJ0HU1YzoFW8GteP6p4xvOrgdamDa0fQzwJ+edKR2
         UY6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FkEfzQFYhiTTzIfLmoFDGHIS3u7YcXXOiJy6nfPZIrQ=;
        b=b7Gshd3dV0IT3PPHAmCwdiU0/Dcb3xCHMWuJ2lWt5EIpkE5ll93sUB/ffPQWZIGHdK
         6xnmV9X2qZs/q46HPixZdS2XPJnzKT+mAAi0sJE2pz584UPlB2ngFdUkUc0lubDdTyy4
         4tNlYpNGUonYh8epTkewGRqBmtGhNpwgJWLzM+QxUUhkRH8jyftkqgDnGNJ5LeyLLTWW
         B1n+2Ui4Ebfbgudj4oR3+Phd5B4WHfNyTK1B5BknlFtIE3h96rVREtTzETuesc/Twc/b
         K3LAi53b7Tb5hvmra/VzAVwHmqiWGXZKdvTRww9EU7i662c3froAHELpEnjHM7h3iml9
         P6Ww==
X-Gm-Message-State: AOAM530JtKeqLW7q2+LkPSimUenK8paMfo2SKNWUBNIbgzLqmee0YmyW
        EIA9eXYvFBBXTOrt0o7MR54=
X-Google-Smtp-Source: ABdhPJxZj4ytPV4kFX8iHNzZekK2qo1u4+RzIEHApvBb/svqO5yWNRQjCQUOex2z1IXKDwM2BFZdUA==
X-Received: by 2002:aa7:c54f:: with SMTP id s15mr14629590edr.175.1593374026518;
        Sun, 28 Jun 2020 12:53:46 -0700 (PDT)
Received: from localhost.localdomain ([2a02:a03f:b7f9:7600:f145:9a83:6418:5a5c])
        by smtp.gmail.com with ESMTPSA id z8sm15669531eju.106.2020.06.28.12.53.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2020 12:53:46 -0700 (PDT)
From:   Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        oss-drivers@netronome.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Subject: [PATCH 04/15] caif: fix cfv_netdev_tx()'s return type
Date:   Sun, 28 Jun 2020 21:53:26 +0200
Message-Id: <20200628195337.75889-5-luc.vanoostenryck@gmail.com>
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
 drivers/net/caif/caif_virtio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/caif/caif_virtio.c b/drivers/net/caif/caif_virtio.c
index eb426822ad06..80ea2e913c2b 100644
--- a/drivers/net/caif/caif_virtio.c
+++ b/drivers/net/caif/caif_virtio.c
@@ -519,7 +519,7 @@ static struct buf_info *cfv_alloc_and_copy_to_shm(struct cfv_info *cfv,
 }
 
 /* Put the CAIF packet on the virtio ring and kick the receiver */
-static int cfv_netdev_tx(struct sk_buff *skb, struct net_device *netdev)
+static netdev_tx_t cfv_netdev_tx(struct sk_buff *skb, struct net_device *netdev)
 {
 	struct cfv_info *cfv = netdev_priv(netdev);
 	struct buf_info *buf_info;
-- 
2.27.0

