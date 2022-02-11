Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBA3D4B1D97
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 06:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233951AbiBKFMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 00:12:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiBKFMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 00:12:42 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92A15C1
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 21:12:40 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id l12-20020a0568302b0c00b005a4856ff4ceso5276652otv.13
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 21:12:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QC265dfkHbGhWgKsqIJC4qYCmhJN2aaMMP/VjQYI1D0=;
        b=OlEVuJBXUK9NQqKb6YVjTGnOD9boSXvclv+8sFuj8pJ2gxYWQUHZKkfkFegWcUzEKq
         Lik3WzMgdoxIyDX3e9uFPy48uSn53cW8ZfPstCbkHvmbQLDg3AS98c1kZ6zdiNg3Y33b
         ApWpsU+JT55hF4hvtz0iN8+KbgF/5s9+FKds0F/aZUYKNs7WmS9LI3NM/qfHVTcdOd8M
         v0kRI1XjzPBQmUllcdbBXHxPojE5Pm7RpZvQjoIn1FTkHq7eRKaCC0WhXtIkS1y3EJFV
         GCtUCLebo3kTyfSVSd8pi2k5hyBxJg3UvXDVXKcwZpxCM5IGhFhHYJoMLWHE7hCEfRK0
         Kc9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QC265dfkHbGhWgKsqIJC4qYCmhJN2aaMMP/VjQYI1D0=;
        b=gA9vYhAUFYTiea0OJzvst1wHmZYGPPFirEAwKbF3FxMzgCF//fdnGYe0I5KSVze252
         aoQSr1i2mecY/0vLLhzT9E98furQaGCd7HxJ4lRBbz/zr1yX2gliPXY6iMc2h0mqoOtg
         rbQLhRycN9l5YvX8yOWf2mQYZvFqlNimEFbngjTiiJ2M+aYUcYLYuOyZ1RcgxhIeg+Bo
         EndAQX6/a4O5zKceB+V9+BSgszAt8dUFN6AyYE03Vy+yGz/bCUi+0/7Ymdh8ax6BY3Rk
         1vtsUENMD3jCVrvXeNVHtgDyjJFp6OYkQ1aa4m8XMkJLDC3m65lRXqMWsAhjt4SLKr1f
         2Jqw==
X-Gm-Message-State: AOAM532gtedocSzec3fso/sP2B3NqXhvWp1PDL/9+KTjrMRbnl4nzHMl
        dbTp81PMQUe6W4BA2Zx2TZ0uW3q+IGcjCw==
X-Google-Smtp-Source: ABdhPJzc22BS8/uWhOV725GwG/Rd/2dQZgqgvndnkhVtrCsk77xflo8KklJdRWGxW1FJpbS0zefxsg==
X-Received: by 2002:a05:6830:2a8d:: with SMTP id s13mr24766otu.115.1644556359519;
        Thu, 10 Feb 2022 21:12:39 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br ([187.94.103.218])
        by smtp.gmail.com with ESMTPSA id s64sm8899730oos.0.2022.02.10.21.12.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 21:12:38 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next] net: dsa: OF-ware slave_mii_bus (RFC)
Date:   Fri, 11 Feb 2022 02:11:41 -0300
Message-Id: <20220211051140.3785-1-luizluca@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <CAJq09z7Hu-dswU41km=L2YFbKyHUJ9JkDjUGwQN5RQqowY0=1A@mail.gmail.com>
References: <CAJq09z7Hu-dswU41km=L2YFbKyHUJ9JkDjUGwQN5RQqowY0=1A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If found, register the DSA internal allocated slave_mii_bus with an OF
"mdio" child object. It can save some drivers from creating their
internal MDIO bus.

Some doubts:
1) is there any special reason for the absence of a "device_node dn" in
   dsa_switch? Is there any constraint on where to place it?
2) Is looking for "mdio" the best solution?

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 include/net/dsa.h | 2 ++
 net/dsa/dsa2.c    | 8 +++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index b688ced04b0e..c01c059c5335 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -421,6 +421,8 @@ struct dsa_switch {
 	u32			phys_mii_mask;
 	struct mii_bus		*slave_mii_bus;
 
+	struct device_node	*dn;
+
 	/* Ageing Time limits in msecs */
 	unsigned int ageing_time_min;
 	unsigned int ageing_time_max;
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 909b045c9b11..db1aeb6b8352 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -13,6 +13,7 @@
 #include <linux/slab.h>
 #include <linux/rtnetlink.h>
 #include <linux/of.h>
+#include <linux/of_mdio.h>
 #include <linux/of_net.h>
 #include <net/devlink.h>
 #include <net/sch_generic.h>
@@ -869,6 +870,7 @@ static int dsa_switch_setup_tag_protocol(struct dsa_switch *ds)
 static int dsa_switch_setup(struct dsa_switch *ds)
 {
 	struct dsa_devlink_priv *dl_priv;
+	struct device_node *dn;
 	struct dsa_port *dp;
 	int err;
 
@@ -924,7 +926,9 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 
 		dsa_slave_mii_bus_init(ds);
 
-		err = mdiobus_register(ds->slave_mii_bus);
+		dn = of_get_child_by_name(ds->dn, "mdio");
+
+		err = of_mdiobus_register(ds->slave_mii_bus, dn);
 		if (err < 0)
 			goto free_slave_mii_bus;
 	}
@@ -1610,6 +1614,8 @@ static int dsa_switch_parse_of(struct dsa_switch *ds, struct device_node *dn)
 {
 	int err;
 
+	ds->dn = dn;
+
 	err = dsa_switch_parse_member_of(ds, dn);
 	if (err)
 		return err;
-- 
2.35.1

