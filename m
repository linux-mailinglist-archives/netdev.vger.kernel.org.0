Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 086F65AC7E2
	for <lists+netdev@lfdr.de>; Sun,  4 Sep 2022 23:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235754AbiIDV4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Sep 2022 17:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235770AbiIDVzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Sep 2022 17:55:41 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F49A17A97;
        Sun,  4 Sep 2022 14:53:28 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id b16so9144845edd.4;
        Sun, 04 Sep 2022 14:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date;
        bh=lYbV35uTqzxof3PRLCtOB2AjQ6YCxGJB8ZrkPJEQRC8=;
        b=eyPQ1Z5msk8BKpRWQZuZnrYn9DHo8IrWbjmn3s68x/pkeJWKugm7ZOwUWp3RyxN4B2
         aSobFC8LEpVO/MvSNnII3kw+/+Qw88bT1daGmW6yJSr235VSZs+H0AVvkX4BvD1CxqVL
         /gxFgxm89fEapFAwKddTydynx+TfSYmZBYigy45L7rLsQWLyS23Nc2csBvpOt49h48Xn
         quv0+0sxmWNJbHP+27aq1dSoz8MPA4pf89fjkoVl3tJoiGGYf+nhtcJ3FAdPhyWQLfmc
         3eThNdx6jA/TmWoG+jgyj45r57b5PZjcBRqMMDjknEbZgUEYjQvWWdGHL+EtuarrLDBk
         e+qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=lYbV35uTqzxof3PRLCtOB2AjQ6YCxGJB8ZrkPJEQRC8=;
        b=Who3pe7EgDjE0348Gce+9IeUCHt3F7T1i3Lv7B6tCD0OFpbjkuahSgh2bXGhzZ+S2X
         /veoGbTwNzhaHRvWuAMFLTsvJHj/MSoAYAi7gzhXSESaFk6Xy3XJSIKqeXwQYBHDW1qW
         E3GKxxPcz354H5lbd7iuFxMmGgJBgxmxpLn2hY6kx2qBqQf0R4e2LGMvJsfdYifkYrUu
         6Tpcm1DuDcUnLJVMjgHWQ157oITWyl60nftkwx9ZArveY5/z6GnS8RtXKkArDjnWeWKU
         PnwiDQPQWplqI/nh2+g5yaAJwTG1EuCfL6i9UOrKRBGoLNkKIsKjDov5t7cWVLUolEaU
         1vsA==
X-Gm-Message-State: ACgBeo1eh4qLcxVHrUM03lZis7gL/2MZrt6QpV6wQG8lJq9phy8w5uKu
        i3iKDiJwec/7y/HXaj24zfk=
X-Google-Smtp-Source: AA6agR4iXZ/Y0o+IsybabCZyKvgkmvKDfYiI5sBk1+f8OqJf6a5D1PXbHgYj9GovKmpxzEd2RObp/A==
X-Received: by 2002:a05:6402:1e8f:b0:440:eb20:7a05 with SMTP id f15-20020a0564021e8f00b00440eb207a05mr40220362edf.169.1662328406180;
        Sun, 04 Sep 2022 14:53:26 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-134.ip85.fastwebnet.it. [93.42.70.134])
        by smtp.googlemail.com with ESMTPSA id n27-20020a056402515b00b0043cf2e0ce1csm5315695edd.48.2022.09.04.14.53.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Sep 2022 14:53:25 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [net PATCH] net: dsa: qca8k: fix NULL pointer dereference for of_device_get_match_data
Date:   Sun,  4 Sep 2022 23:53:19 +0200
Message-Id: <20220904215319.13070-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.37.2
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

of_device_get_match_data is called on priv->dev before priv->dev is
actually set. Move of_device_get_match_data after priv->dev is correctly
set to fix this kernel panic.

Fixes: 3bb0844e7bcd ("net: dsa: qca8k: cache match data to speed up access")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca/qca8k-8xxx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 1d3e7782a71f..c181346388a4 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -1889,9 +1889,9 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 	if (!priv)
 		return -ENOMEM;
 
-	priv->info = of_device_get_match_data(priv->dev);
 	priv->bus = mdiodev->bus;
 	priv->dev = &mdiodev->dev;
+	priv->info = of_device_get_match_data(priv->dev);
 
 	priv->reset_gpio = devm_gpiod_get_optional(priv->dev, "reset",
 						   GPIOD_ASIS);
-- 
2.37.2

