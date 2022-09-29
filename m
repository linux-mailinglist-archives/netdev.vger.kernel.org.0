Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF915EEEFF
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235062AbiI2H3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232519AbiI2H3R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:29:17 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C10135724
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:29:15 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id u10so628797wrq.2
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=XvmaiymTmJNoWno9o8jMIYcjUDwPb215/dnmXOiq+S8=;
        b=co9Yq47x/Bl4h+GS0iCF/e99fxeGtPeSgLWIRpGB37q/bNL8u8+uetVUe74ktL3olT
         O44AauBcNRdULGvAZen00phBI6KosWxzx8nJqWnkH6WQ2sF87FO0JD7cAwB75RWTJA77
         iCOHGYy5Pz44ooWPx1GoUwzQXDHPM5Zj+LPQS6l3qk5J59fkrdSZL1cNWaOFWhns809L
         q6v6Ei0+UUD7PQ1ykSmyzuoxatF4YNTaFkb3bNpu6b2Q4WayvxDPN5oiuduMZ/nEZ/r9
         7kIIZeNvtz+mHI5uJp/vJ6jKLC6EQ4sctXwpwPvkUiuTkCJ2U0jGQkdEBWw/lF3BKrnY
         SFzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=XvmaiymTmJNoWno9o8jMIYcjUDwPb215/dnmXOiq+S8=;
        b=YatJJHJL/W3zI2mh8sRKR/jB3hwEiezQmd/QUK+74da9tMexcVkdvBXhIm6gJ2VXML
         1zowrdvkArihKFcAjF87vDNg64vKrbXcgu7r/AJGpm0BGSISH7Svihzsb8h6k+STkiWH
         adc+wcSIKzWFEFQ9YJI5RWzHs3l1KsiAocQK/uYJIPhREAf8Kd4XO/aX6pp1il6y8jMo
         D9UKPzP3UK8aGaMBygGr7pQD47h2AytNg+h2fT3FU2Ng87pdAJkx2eJL8iooG4M03whE
         d0IdVj/WjvAZQW+kBEKqfaX+c+P+jtZb/OK7IdvE/lUXWCChbZDb6myI37I5yBpYPSyp
         w7rA==
X-Gm-Message-State: ACrzQf07lW3bshNwwuhGJJe//KfeRVs5pOZmTXKatG8YamV9mH+p9cpK
        hdxQjXe5dfNZFcSwkdppnh5X3cNzsPhLQEfu
X-Google-Smtp-Source: AMsMyM4T05elxSPYr0nGSHDxcD98muxXalJsFWHP3HdWArUlTB2X3mbghYg2DkF/J1255VkbDZa9hQ==
X-Received: by 2002:adf:bc13:0:b0:228:6d28:d2cb with SMTP id s19-20020adfbc13000000b002286d28d2cbmr1109781wrg.375.1664436555002;
        Thu, 29 Sep 2022 00:29:15 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id g15-20020a5d554f000000b0022cc7c32309sm2210886wrw.115.2022.09.29.00.29.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 00:29:14 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, tariqt@nvidia.com,
        moshe@nvidia.com, saeedm@nvidia.com
Subject: [patch net-next v3 7/7] net: dsa: remove bool devlink_port_setup
Date:   Thu, 29 Sep 2022 09:29:02 +0200
Message-Id: <20220929072902.2986539-8-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220929072902.2986539-1-jiri@resnulli.us>
References: <20220929072902.2986539-1-jiri@resnulli.us>
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

