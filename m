Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 749903B73D4
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 16:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233819AbhF2OJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 10:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233084AbhF2OJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 10:09:48 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD09FC061768
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 07:07:20 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id s15so31409261edt.13
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 07:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=scHE9d5ONVOSdnYa8WVWpcK+kRjde55g2yNWIa6qibo=;
        b=CPQwwDj6wiEJ4ZYKqhbT6ssPVv2NYdEHr9dSgGVtQBta259ZuNEfG2J9LqnBJK/7T7
         pkU9xUxcfmEGjcV/XKPguudEmo0wMofRBM+7mhskB2kmCTQ+UMqXIP+l5aaOGOmJqyrs
         RJfMzEOyMB9Sm+SUoQZq8Asp8zPriU6qvuDWXP6ZISSKiW3y5apI4WgqTyjZnrhrWw3t
         cvID5Cbg6ot/dXehrZFKgwUXIux/KiH3Ml5Jotqr+EVfQnUnRQRrFRGYYJsFGqR+w9KT
         hDvvyPCEuzG2X1Qf7XHxhFHUbb7615V/SATrQAe/Jwnomy+RPwANGZQeK9k3fn+7C6zh
         XqOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=scHE9d5ONVOSdnYa8WVWpcK+kRjde55g2yNWIa6qibo=;
        b=rmZo/+sCtHS7023zF/EVyuoMUhcfolQLWe1ehpx0vVwDzfEMjLFUFbdTD11JR1CVuE
         SlUXmHUVHW+3hqT36YEI5JY1I69+I3hnDbKZakpMdFLShU9NZfDvHGxRsujRFUj69eLi
         RyGNv+/tZqgYUkjLhT2W7xbEwnb+5Cj3prWIbcn5Z9q7KXCgyM3cYcN3J1NxX4LYwoqQ
         FXf27pIf6dGAEd/baGPCpd+nlu/xI4hYA8TD16V6Tk8bHwSL7T4zgc6T0XxG+DKVw8AL
         9EiCRcv31AJ2ffSRcXmnoHvRHL92U02qu66Z6UaYYhvd7rQoA9ztkoWvekMMA4qBIxlB
         L5gA==
X-Gm-Message-State: AOAM532pcRjwQOO7J6eIhz+zMV6HXmTbxJ/W8xMLAZngXJ38HOvPGVQT
        gpAVOF010jgSFbQayhX7xMEXfdAo0gM=
X-Google-Smtp-Source: ABdhPJyDLKG7cWLBjgNw6df2gg/f63nbuhCwrKrBiyMjatwlqEcEPQMHO6Hj7J9zEywF2MnS9LIBxg==
X-Received: by 2002:a05:6402:348d:: with SMTP id v13mr30820266edc.119.1624975639185;
        Tue, 29 Jun 2021 07:07:19 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id b27sm8220121ejl.10.2021.06.29.07.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 07:07:18 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        bridge@lists.linux-foundation.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v5 net-next 03/15] net: bridge: allow br_fdb_replay to be called for the bridge device
Date:   Tue, 29 Jun 2021 17:06:46 +0300
Message-Id: <20210629140658.2510288-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210629140658.2510288-1-olteanv@gmail.com>
References: <20210629140658.2510288-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

When a port joins a bridge which already has local FDB entries pointing
to the bridge device itself, we would like to offload those, so allow
the "dev" argument to be equal to the bridge too. The code already does
what we need in that case.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v4->v5: split in 2 separate checks, one for br_dev and one for dev,
        because it looks better

 net/bridge/br_fdb.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index bad7e84d76af..2b862cffc03a 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -760,7 +760,10 @@ int br_fdb_replay(const struct net_device *br_dev, const struct net_device *dev,
 	unsigned long action;
 	int err = 0;
 
-	if (!netif_is_bridge_master(br_dev) || !netif_is_bridge_port(dev))
+	if (!netif_is_bridge_master(br_dev))
+		return -EINVAL;
+
+	if (!netif_is_bridge_port(dev) && !netif_is_bridge_master(dev))
 		return -EINVAL;
 
 	br = netdev_priv(br_dev);
-- 
2.25.1

