Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38B8A3158A8
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 22:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234428AbhBIV3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 16:29:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233924AbhBIVOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 16:14:14 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B424C061788
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 13:13:28 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id k204so19418871oih.3
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 13:13:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PDpwFkmPxH6ciI2XoWxAqgpzMyliu9KEV9JmnUxkEXM=;
        b=KYc5ofENeXxcywILRgEwKQE5y1MqWfn3pVoDllTF7Dsd18PkcM4hsBkEC6yD9uvQeu
         4D1hLK9ZAeQ0LUoWldu5HipiUo6dLsOM6hcVvzesj8xmn564pcYcCV89rMc6xtFOBSSb
         NWnXeGng5jtQgd1SGGJfobpyOtVwOm4nTttOuV7TdghACX6Xx265ZhLTEubxKLGgnEuW
         HR28nrAlSt8aPWnJj2PeNdgzX9+2ugsfZxv7oPx2QuBGbqb0339NiG6qDEEUjQRuePD8
         fExiqngCrvCfeqXxVaOFLenOmqj0kRzy4H8oaSeO6MqFyQsVorP0XHIbRaeJgzf/MkTh
         kZuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PDpwFkmPxH6ciI2XoWxAqgpzMyliu9KEV9JmnUxkEXM=;
        b=eyLzK6dnvrqFh0oZ3vjnPTGEiK+6N+fL3jCWroklaR7l6wfHyXwwOfo+6jE01E2hR2
         p5HPk9pd4cMrLJTor291afebLeQQJiEXCax0khvz1TNUa0lqpKU38Y13jXr0n4FFFruF
         zmsBWFkamon7v9Le2KWRUU+O55G9U5AgErsXyoDwRYeaTmOlhcDjMGpCAng1xF6iMlZR
         mi9DK/XaWBHQm0NOc8TJPhn0DGc9AqKtAwoKsVNa1H+PonDJs3VfPL4oRk/dAxf3/SR+
         m806AT55ng+/xg5DVlQGjfN29uMyG7cIYJuvaDLF6QFhwLykj9vHrRaCdYltNpenHIVK
         HCqg==
X-Gm-Message-State: AOAM533qy1rqT67QCgIlfis62RWZ4BkqCQ127w3J2vgct7r1T+rVIKx4
        jwvM+FfAm9qEl1cEr25dWg==
X-Google-Smtp-Source: ABdhPJxCmWQDcOiLMxDZIZZ3GTilrTn/PUOeFtMrtpG/nEoSewJrPR1nShCDfsa9QY02QJtF3VVOtg==
X-Received: by 2002:aca:f00a:: with SMTP id o10mr3759516oih.175.1612905207795;
        Tue, 09 Feb 2021 13:13:27 -0800 (PST)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id r4sm2512777oig.52.2021.02.09.13.13.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Feb 2021 13:13:26 -0800 (PST)
From:   George McCollister <george.mccollister@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH net-next 2/2] net: dsa: xrs700x: use of_match_ptr() on xrs700x_mdio_dt_ids
Date:   Tue,  9 Feb 2021 15:12:56 -0600
Message-Id: <20210209211256.111764-2-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20210209211256.111764-1-george.mccollister@gmail.com>
References: <20210209211256.111764-1-george.mccollister@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use of_match_ptr() on xrs700x_mdio_dt_ids so that NULL is substituted
when CONFIG_OF isn't defined. This will prevent unnecessary use of
xrs700x_mdio_dt_ids when CONFIG_OF isn't defined.

Signed-off-by: George McCollister <george.mccollister@gmail.com>
---
 drivers/net/dsa/xrs700x/xrs700x_mdio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/xrs700x/xrs700x_mdio.c b/drivers/net/dsa/xrs700x/xrs700x_mdio.c
index 3b3b78f20263..44f58bee04a4 100644
--- a/drivers/net/dsa/xrs700x/xrs700x_mdio.c
+++ b/drivers/net/dsa/xrs700x/xrs700x_mdio.c
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/phy.h>
 #include <linux/if_vlan.h>
+#include <linux/of.h>
 #include "xrs700x.h"
 #include "xrs700x_reg.h"
 
@@ -150,7 +151,7 @@ MODULE_DEVICE_TABLE(of, xrs700x_mdio_dt_ids);
 static struct mdio_driver xrs700x_mdio_driver = {
 	.mdiodrv.driver = {
 		.name	= "xrs700x-mdio",
-		.of_match_table = xrs700x_mdio_dt_ids,
+		.of_match_table = of_match_ptr(xrs700x_mdio_dt_ids),
 	},
 	.probe	= xrs700x_mdio_probe,
 	.remove	= xrs700x_mdio_remove,
-- 
2.11.0

