Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAA566A3F15
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 11:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbjB0KDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 05:03:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbjB0KDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 05:03:51 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37FAF76A7;
        Mon, 27 Feb 2023 02:03:31 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id j2so5537902wrh.9;
        Mon, 27 Feb 2023 02:03:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4kWm37Ixl905qbNIzKjmoOPdiZM9qfGzX7zoFG4LKFs=;
        b=nGuceni+LvNZpQjYuwGLrsqUz9oolJ7gyVYKUj3vd8/kJXwrTDdfapCTfwAeVIvP0L
         tFKMXfqaTNFnms2aB8p7OElqogKZhpc8ASyRNEYbGvpb4dq4COkVWovqb3HGpV5LaZZ3
         0FNHd0wGvmkFP5frzjF9YsbYrKE0rR4BIoiI2l3pg0QJ0k2k/UxlhA7vmh71D+uqbNIb
         zya82D1JxYJnCQ64Nu3NYIy0CeDE3Gk4/L3srfyP+xQVN64tLXV3dIGJZIMVoU1+7PP/
         4beVnfceIWzhL5trofCLdkuHCGyXBEGsu7pyPNfzCMpsGe6RLu4uvb99d6Okt7DUTVCP
         BI0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4kWm37Ixl905qbNIzKjmoOPdiZM9qfGzX7zoFG4LKFs=;
        b=VVmW+IAkz2iP0jQRp0Xe62LklbP4adA2i9NtqXqgHiATdfbUw4oEeNbCOrJurXTTYj
         srGRzUboVc4leKN+B1gead9d6XBgvrU/jLzVg6NvEgY3OVcLWb4geIf3QgRqCNgxnF67
         4nVCgSrlv2METZfmkJqIvpjCPBM0XBUceJgXsYL8xWHlxMK01DFf3YUPYTCBQilKBnfn
         Qfz66t0a+5pf95mmqODv5hv4TbD9gjCpX1BeJkHSclhBuSSCNWoB68Jl+daJyrN5bdpr
         4ovol8oH/PGdZpW4Stqd5+dvITJ6oYVyKekjtDu4lhCMggCwI7fJlEBuONHbf4IiJmfJ
         zaug==
X-Gm-Message-State: AO0yUKWKxDDuNLWswBTUh1RoSWyGLyuR26G0le21T4b3e0iiIezMwwuM
        qqCwpcG0ngrgNqWAbashblU=
X-Google-Smtp-Source: AK7set+4nIYPmwmJ/R4nDrRJ13s//9CahcGEUYiZZQyNeCoA1RWY2zXaWtsdLjvS3318MLcA0jBzWg==
X-Received: by 2002:adf:ce08:0:b0:2c5:5b9d:70ee with SMTP id p8-20020adfce08000000b002c55b9d70eemr19500975wrn.22.1677492209582;
        Mon, 27 Feb 2023 02:03:29 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id e15-20020a5d594f000000b002c5d3f0f737sm6613343wri.30.2023.02.27.02.03.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 02:03:28 -0800 (PST)
Date:   Mon, 27 Feb 2023 13:03:22 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Oleksij Rempel <linux@rempel-privat.de>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net] net: phy: unlock on error in phy_probe()
Message-ID: <Y/x/6kHCjnQHqOpF@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If genphy_c45_read_eee_adv() fails then we need to do a reset and unlock
the &phydev->lock mutex before returning.

Fixes: 3eeca4e199ce ("net: phy: do not force EEE support")
Signed-off-by: Dan Carpenter <error27@gmail.com>
---
 drivers/net/phy/phy_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 3f8a64fb9d71..9e9fd8ff00f6 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -3146,7 +3146,7 @@ static int phy_probe(struct device *dev)
 	 */
 	err = genphy_c45_read_eee_adv(phydev, phydev->advertising_eee);
 	if (err)
-		return err;
+		goto out;
 
 	/* There is no "enabled" flag. If PHY is advertising, assume it is
 	 * kind of enabled.
-- 
2.39.1

