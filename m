Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B065E2F8A25
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 02:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728293AbhAPBBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 20:01:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbhAPBBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 20:01:16 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD0FBC061793
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:00:35 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id ga15so15864508ejb.4
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:00:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VDJdCaP9sF8SGzmcmkXisXBOlBt0JGJJnYJZHRk+qDQ=;
        b=sTCU/x6Vibr0eMpUT+6XD6hRyGxcYlD+nPCRGMuzkwa1VOh9q1zJpcH2bWZ53BlTPc
         mwz+VxbRKMFh5NJJ4ptj95cYFztdI4ZY+ra290TS0r87G7tTDKOUZWXpzDlBFhUWkpC6
         KRZPF6plQdhU/lgt9YjdAQ3/pIeDB43sRsd2SXpOyJE+D4RYaJBGP0+YM45cEcQ1ThfZ
         RQ+SJd+HrzC27Bl+bWHStaw50ICtv18YA2eHBAlyltlSQg72ciXfPUaHOENlrJwgoekq
         GwJqX72nqRkEdqsF1+M3E1cdrVSXq2tatVpJx9KFu6EPf5cZLMmRJVpYUTvEfZJV/bSg
         qpYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VDJdCaP9sF8SGzmcmkXisXBOlBt0JGJJnYJZHRk+qDQ=;
        b=HEl8+WbuapV0/DmZsqC2jwVn1ghD3/X0sX9PTiYdwEbCAS3VLDqYZqwQOWb3eqFc7Z
         7ghvlD/iErEHrW9py1mQkTOpFzaNjEfab7ZObQUILyx5+41z45vlDMKzTTNpRLTv4nNp
         kD7DC5H9t3/ncZl7CTF4D1JnOh8bgeBbgPecnIvgrEwNq2vJvkDY5NOl9lGhUOgLXb1R
         Qo1TwT10grHFZxUjRvMfTqbpMnYV3LPvHkJu+ddMlqaMmIraQrDclzIlVa0LjBkhT1gf
         u9ZW5k6xcfD3tP5hrQPSzhgqcYo6yVwxonxjD0euhWjwGci+PsY12epqaIAoQZzPv/k3
         i0eA==
X-Gm-Message-State: AOAM530yb85L6cHxHf4Sp/9SvF7XZDpO0hZVTPUsufnXLcxMWNcCMaF9
        uZ0hqZ0lDJGzwmSINp6nexo=
X-Google-Smtp-Source: ABdhPJw5vkgr5RazOUUirJGU+ucLiBQR2ZvZKUTJXDw4iwcUV5LZGzA7rGR/oYjcv7TU1apq36J8DQ==
X-Received: by 2002:a17:906:6a92:: with SMTP id p18mr10231103ejr.308.1610758834555;
        Fri, 15 Jan 2021 17:00:34 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id k3sm5666655eds.87.2021.01.15.17.00.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 17:00:34 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: [PATCH v2 net-next 01/14] net: mscc: ocelot: allow offloading of bridge on top of LAG
Date:   Sat, 16 Jan 2021 02:59:30 +0200
Message-Id: <20210116005943.219479-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210116005943.219479-1-olteanv@gmail.com>
References: <20210116005943.219479-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Commit 7afb3e575e5a ("net: mscc: ocelot: don't handle netdev events for
other netdevs") was too aggressive, and it made ocelot_netdevice_event
react only to network interface events emitted for the ocelot switch
ports.

In fact, only the PRECHANGEUPPER should have had that check.

When we ignore all events that are not for us, we miss the fact that the
upper of the LAG changes, and the bonding interface gets enslaved to a
bridge. This is an operation we could offload under certain conditions.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
---
Changes in v2:
None.

 drivers/net/ethernet/mscc/ocelot_net.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index a520fd485912..467170363ab2 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1153,10 +1153,8 @@ static int ocelot_netdevice_event(struct notifier_block *unused,
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 	int ret = 0;
 
-	if (!ocelot_netdevice_dev_check(dev))
-		return 0;
-
 	if (event == NETDEV_PRECHANGEUPPER &&
+	    ocelot_netdevice_dev_check(dev) &&
 	    netif_is_lag_master(info->upper_dev)) {
 		struct netdev_lag_upper_info *lag_upper_info = info->upper_info;
 		struct netlink_ext_ack *extack;
-- 
2.25.1

