Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D5A3FAE7B
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 22:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234668AbhH2UfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 16:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232989AbhH2UfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 16:35:11 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7768BC061756
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 13:34:18 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id bt14so26706591ejb.3
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 13:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8pMVpa5AUtn8zg4wT+N7afaNlo9ExjpizhuI6FMNBYk=;
        b=C7n3MCfbj1bnBCZRmP5QsDC4I5KuepyBs6klndJjFi4mjikwMYgmcCgNIde6V220jW
         5m8YA/+2x2/o9nRoXfzC6/njxkZ7BySwfzeSmVLp9wzZtZwIMSrCcQ4eqv6/mOK3+TIh
         cv3Ah0ejQO8xtWtvZfkvcGGqZL1NUMGDsHbxA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8pMVpa5AUtn8zg4wT+N7afaNlo9ExjpizhuI6FMNBYk=;
        b=QPKC1iZ4fOabJ0x1XPDbQq932bG4JvGw4siBshBL/nliSKetwiWKBXzbEzEPOePgcb
         eWU6oOIHBsMTBHyG2l1HWjDI3dBCVZF2SGvOv3dMra4FlcMrmkE42gF6Ld2go/cNhPFM
         OXM2MBJAtrQgdfnLxDo9VhXxRVeuaMnBAfCdeJYpfJtyVuFcqQzcHH8dN+wHfPBdTzg6
         iG6cyfJuLow7oVsaz/0F40SVcrtpBNnulG7o3ZD9AkZnmezfZledlD7oeotfW/LbEzip
         nf1GiVPxTDEC/hVHxanrvLtmdio62KGdvj+qsqDB9YSVTh1jVNB4BYshJcu9sOAPpg+5
         ub+w==
X-Gm-Message-State: AOAM531jYh9GP1QzrpVOk26hk9mfNqACMTZuAZKMGSCFN5fA+4c4z0wL
        0xvhWVL7hswHxAlYueCwtMJjMg==
X-Google-Smtp-Source: ABdhPJwmR9t8Vk903ZMSGGjxY27nGdwktMKb8q3SjS2+jzG4AIir4BSNXDBlWQQexoa5bj+0CJWTtg==
X-Received: by 2002:a17:906:840d:: with SMTP id n13mr4336067ejx.53.1630269256995;
        Sun, 29 Aug 2021 13:34:16 -0700 (PDT)
Received: from taos.k.g (lan.nucleusys.com. [92.247.61.126])
        by smtp.gmail.com with ESMTPSA id kw10sm5785656ejc.111.2021.08.29.13.34.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Aug 2021 13:34:16 -0700 (PDT)
From:   Petko Manolov <petko.manolov@konsulko.com>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, netdev@vger.kernel.org,
        Petko Manolov <petko.manolov@konsulko.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v3] net: usb: pegasus: fixes of set_register(s) return value evaluation;
Date:   Sun, 29 Aug 2021 23:34:02 +0300
Message-Id: <20210829203403.10167-1-petko.manolov@konsulko.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  - restore the behavior in enable_net_traffic() to avoid regressions - Jakub
    Kicinski;
  - hurried up and removed redundant assignment in pegasus_open() before yet
    another checker complains;

  v3:
     Added CC: stable@vger.kernel.org in a vague hope this time it'll go in;

Fixes: 8a160e2e9aeb ("net: usb: pegasus: Check the return value of get_geristers() and friends;")
CC: stable@vger.kernel.org
Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Petko Manolov <petko.manolov@konsulko.com>

---
 drivers/net/usb/pegasus.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index 652e9fcf0b77..9f9dd0de33cb 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -446,7 +446,7 @@ static int enable_net_traffic(struct net_device *dev, struct usb_device *usb)
 		write_mii_word(pegasus, 0, 0x1b, &auxmode);
 	}
 
-	return 0;
+	return ret;
 fail:
 	netif_dbg(pegasus, drv, pegasus->net, "%s failed\n", __func__);
 	return ret;
@@ -835,7 +835,7 @@ static int pegasus_open(struct net_device *net)
 	if (!pegasus->rx_skb)
 		goto exit;
 
-	res = set_registers(pegasus, EthID, 6, net->dev_addr);
+	set_registers(pegasus, EthID, 6, net->dev_addr);
 
 	usb_fill_bulk_urb(pegasus->rx_urb, pegasus->usb,
 			  usb_rcvbulkpipe(pegasus->usb, 1),
-- 
2.30.2
