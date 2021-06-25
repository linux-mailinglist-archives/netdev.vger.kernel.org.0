Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7D7F3B48FE
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 20:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbhFYS4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 14:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbhFYS4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 14:56:01 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78F35C061574
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 11:53:39 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id yy20so8845734ejb.6
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 11:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CGD4nVR1UJSiFHCmez0Ep/hjXV7j45YJTpnFxgYmszE=;
        b=KiN979bxbufge6e/uBKT2ZSOFKuRf7Y9qK1d8GXk4Crnu5NFI5HopiLZ7d5rXMneOK
         HpRulPP9nTx5K+vzrGaFrF8rCksG6MktNXn5/RQkkKIEXT3SzcbHgHoowmMFHdhHJq6N
         7S+CwiPafDVxN/ISSSqn9OqKYeZA5OzRxSbMJTtPg+khWkrCxqOHoB2t+RORXzjOEN4C
         qjjB9mi7MA4JR7hXlwDNULE4rZnkK/XDcp2+TSVjCKebGxoT6pFnNZDCZRvhgVqHmsxp
         HRpW1IXqvN/IZZNENoG+DXjB9VoH+0+ZRKKM1bY7iSl80Q4Tl7mhSOT5WeyBW3cgMUQD
         sSWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CGD4nVR1UJSiFHCmez0Ep/hjXV7j45YJTpnFxgYmszE=;
        b=DJb28brBpCZ2hmFt/zPEzmIyLE7aMYmKLXGXGNlYBjy3hXCn6ozxu5XKta3p/2T7q3
         TF6oStXNfnDKtytvqZuHbdp6Z6UJPYX/KNjlpnv/ubPPdypx7dWHp3kZGTtWUAzGOaa0
         uvjMHBmTlSroz0W1MyhJnv8UAz163AKKOJlVWXL5/jkrTnYnbMcsF/a1eFQeLJKFRl/S
         PfxBqqT3I1D5xyIib1rSLt8t2WUljKh+SqS3fIxREnBGif6+mssIqw5X1e2ezrZiqbUT
         xGnpfiVqBnJQ+Ffxw1ElNPfLxt88tAiWKN7TF3Z7dHDb0IILy48lNSmFq4VPRZiiOawm
         e7OQ==
X-Gm-Message-State: AOAM531yIilJOonVJ9u4G3C0D1S9XQuiw4aUIiblRK4QX01lKVnjYGlQ
        ob2ExrPJwDvvZHc/zMDEXK8=
X-Google-Smtp-Source: ABdhPJwRNAUCT29DxOECRWTGFaHgCdc6iPHqRn7UPzMUGacrgYJ1ecy/MWjaWgkwB6p7RIdQbjA/tA==
X-Received: by 2002:a17:906:c2d9:: with SMTP id ch25mr12558565ejb.127.1624647218100;
        Fri, 25 Jun 2021 11:53:38 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id w2sm3094954ejn.118.2021.06.25.11.53.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 11:53:37 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 2/7] net: ocelot: delete call to br_fdb_replay
Date:   Fri, 25 Jun 2021 21:53:16 +0300
Message-Id: <20210625185321.626325-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210625185321.626325-1-olteanv@gmail.com>
References: <20210625185321.626325-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Not using this driver, I did not realize it doesn't react to
SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE notifications, but it implements just
the bridge bypass operations (.ndo_fdb_{add,del}). So the call to
br_fdb_replay just produces notifications that are ignored, delete it
for now.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_net.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index aad33d22c33f..4fc74ee4aaab 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1165,10 +1165,6 @@ static int ocelot_switchdev_sync(struct ocelot *ocelot, int port,
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
-	err = br_fdb_replay(bridge_dev, brport_dev, &ocelot_switchdev_nb);
-	if (err)
-		return err;
-
 	err = br_vlan_replay(bridge_dev, brport_dev,
 			     &ocelot_switchdev_blocking_nb, extack);
 	if (err && err != -EOPNOTSUPP)
-- 
2.25.1

