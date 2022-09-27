Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3354C5EBCA7
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 10:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbiI0IC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 04:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231657AbiI0IC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 04:02:29 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D00B2854
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 00:57:32 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id t4so5976008wmj.5
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 00:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=XvmaiymTmJNoWno9o8jMIYcjUDwPb215/dnmXOiq+S8=;
        b=31sUqlV1a2aw88fOvIZBHHbjHNkX86ayp5JO2DQkJAFlaxH6yDfTRcijii/KgkZKhV
         PrcLk+nWlR7NVtuQ3VGbteaAtWMOuEjU7cOK6XHmNFMIYiLB+HStc8S7g2//+42ayBs+
         9cagD5JdAMsY0cnVRsORn4EM1eRCzT57btqYNeKj9R8rHgJAoJabeUP0h2aJXCmEJpac
         WywZrQ0upMzdYWlN6VnS5/3CQJwDIGGQ7VlAsZ8lOCYR5sDfX1yXrjywT1z2Q/yzdDHs
         Zl0v8aKKyXwSNFUlxACxKEY253ucRa5vfDy/Cj2waeV2+y0CSHOxaVQwAVN2/rEhpw3S
         gbkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=XvmaiymTmJNoWno9o8jMIYcjUDwPb215/dnmXOiq+S8=;
        b=OO4Uf8huDm8Hc+P23tAFTVuz4G8AmIZqeBYwJDFuQXLFXXUPCdZtZNLU6pT9VSOI9W
         OX6aFyIKCg4eWpgLrk3/TVuNHOUKkuwbzkk3QChzXA+ksNrdbDs27lOIpfOBe9XKpt74
         OwlecZziwbZrjtR6YVQuqDX0SQha2nakrO9jTSJqzu6lDnJsT7FxI5p+FRjyqDvCwfeM
         pCeIT9dy17Z6d2NSgA65rC5bPv3A3litio0XSar1Ug789qmSHCz9b72EpqpybRG3WYjk
         A5SmSYIkna27ulLA7I7bpcHhqbXrVjttg6IZxKpk6KiA4asdCq9/3IT9WnpZtKl1TBBA
         uraQ==
X-Gm-Message-State: ACrzQf2/sqUEh4MlLoheuHoZfK2kol0IeIP7KppXAxKk23twfa6G23Ky
        rxOrBbyu9XABCefjc3N0urrvIUReUo40Ings
X-Google-Smtp-Source: AMsMyM6+qSWVwSQTRr7XHjDlI554uKO80faoUznRHEcLEfUj6n77Sufy+Bng8MaI73LoXRrop3+uZg==
X-Received: by 2002:a05:600c:500d:b0:3b5:234:d7e9 with SMTP id n13-20020a05600c500d00b003b50234d7e9mr1612205wmr.57.1664265418306;
        Tue, 27 Sep 2022 00:56:58 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id m20-20020a05600c4f5400b003b47e75b401sm14432213wmq.37.2022.09.27.00.56.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 00:56:57 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, tariqt@nvidia.com,
        moshe@nvidia.com, saeedm@nvidia.com
Subject: [patch net-next v2 7/7] net: dsa: remove bool devlink_port_setup
Date:   Tue, 27 Sep 2022 09:56:45 +0200
Message-Id: <20220927075645.2874644-8-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220927075645.2874644-1-jiri@resnulli.us>
References: <20220927075645.2874644-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Since dsa_port_devlink_setup() and dsa_port_devlink_teardown() are
already called from code paths which only execute once per port (due to
the existing bool dp->setup), keeping another dp->devlink_port_setup is
redundant, because we can already manage to balance the calls properly
(and not call teardown when setup was never called, or call setup twice,
or things like that).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 include/net/dsa.h |  2 --
 net/dsa/dsa2.c    | 14 ++++++--------
 2 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index d777eac5694f..ee369670e20e 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -294,8 +294,6 @@ struct dsa_port {
 
 	u8			lag_tx_enabled:1;
 
-	u8			devlink_port_setup:1;
-
 	/* Master state bits, valid only on CPU ports */
 	u8			master_admin_up:1;
 	u8			master_oper_up:1;
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 747c0364fb0f..af0e2c0394ac 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -510,7 +510,6 @@ static int dsa_port_devlink_setup(struct dsa_port *dp)
 			ds->ops->port_teardown(ds, dp->index);
 		return err;
 	}
-	dp->devlink_port_setup = true;
 
 	return 0;
 }
@@ -520,13 +519,12 @@ static void dsa_port_devlink_teardown(struct dsa_port *dp)
 	struct devlink_port *dlp = &dp->devlink_port;
 	struct dsa_switch *ds = dp->ds;
 
-	if (dp->devlink_port_setup) {
-		devlink_port_unregister(dlp);
-		if (ds->ops->port_teardown)
-			ds->ops->port_teardown(ds, dp->index);
-		devlink_port_fini(dlp);
-	}
-	dp->devlink_port_setup = false;
+	devlink_port_unregister(dlp);
+
+	if (ds->ops->port_teardown)
+		ds->ops->port_teardown(ds, dp->index);
+
+	devlink_port_fini(dlp);
 }
 
 static int dsa_port_setup(struct dsa_port *dp)
-- 
2.37.1

