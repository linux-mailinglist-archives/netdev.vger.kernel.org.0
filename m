Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B13B697555
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 05:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjBOEVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 23:21:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjBOEVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 23:21:54 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7380CA9;
        Tue, 14 Feb 2023 20:21:53 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id co8so14033440wrb.1;
        Tue, 14 Feb 2023 20:21:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=20yunjTjnc/qKA6l389BECnPli1wmHip5Ke8sWuSQPA=;
        b=F1TDD61vqC4SzAIG6bZJxvyfV70qgpYUwPVNi39x35lrMXOCyvlS67eDPnfNL8DItQ
         QTdiO/m2OobtUAqDvnw1xD4Pt9+LOR3bNzvpH1jPrP9SnvbwMwx8RzR2H3zMHfBlG8kJ
         WS6GIpqVuedeNr36/s1yqBvZKccW7P0Vjin24mOddj2iTX8DYYrkEk7RHEtN3bMeLCEy
         KCvnTNkzvDfr9dR8FXyRvdJgO1bpEd0zUqkPmdXkbpouUKZWsjrMKL1SGBsTfPPoz2NV
         i3twJk/1IFBWjnquN5/xkgyuJqqbd1aFnvwooqtY+9cLxTH4x7Vy73xdOGWyg63P/FFE
         IXkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=20yunjTjnc/qKA6l389BECnPli1wmHip5Ke8sWuSQPA=;
        b=4Q9BmRIaWxxMjND2dJgb6BLTnG+NuVaLaLPw9luGsWT68TrfVpidVB9Iyu68dREdA/
         z/dlzBytirRnoSUEtVWhsmxRizRa70v1XBJCZxqsm8Gu8zA1r5G4BY7n0pNKbHy5fNf8
         BHW8F06LsO9CRAAJ8jaqyroC2GxcId9VAfsr2rwR5cTqWWeVgdX5w4dhwlXvS3a65Yqf
         8U7rpVSbh/OXwVPxxBZoV2aIK5zHYz51FykVOX/ko6l5+j2IDPEu2Mp5r8x71+ZgtmJm
         IifrkeZCaKpipR7sefBQSxt7tjaYeFYxUT3CoiWZhjNob5qEnRjD29RFgZOaoXHQdnnz
         ETuQ==
X-Gm-Message-State: AO0yUKVkClU4jqaUHipQjdREUupmFOPkVHK5nKxcgqdQt3lANSCoso8U
        iWULIBeu+/13Q46pIGECqfA=
X-Google-Smtp-Source: AK7set+UpXANkwDH724nS5xPdmfI8lU1our3+oDH4kkuUkC97KhZD6jradfPAezIawanxAd+jDTh5w==
X-Received: by 2002:a5d:564c:0:b0:2c5:5ef8:fa36 with SMTP id j12-20020a5d564c000000b002c55ef8fa36mr333565wrw.70.1676434911831;
        Tue, 14 Feb 2023 20:21:51 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id i8-20020a5d4388000000b002c5493a17efsm12356872wrq.25.2023.02.14.20.21.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 20:21:51 -0800 (PST)
Date:   Wed, 15 Feb 2023 07:21:47 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Frank Sae <Frank.Sae@motor-comm.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH v2 net-next] net: phy: motorcomm: uninitialized variables in
 yt8531_link_change_notify()
Message-ID: <Y+xd2yJet2ImHLoQ@kili>
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

These booleans are never set to false, but are just used without being
initialized.

Fixes: 4ac94f728a58 ("net: phy: Add driver for Motorcomm yt8531 gigabit ethernet phy")
Signed-off-by: Dan Carpenter <error27@gmail.com>
---
v2: reverse Christmas tree.  Also add "motorcomm" to the subject.  It
really feels like previous patches to this driver should have had
motorcomm in the subject as well.  It's a common anti-pattern to only
put the subsystem name and not the driver name when adding a new file.

 drivers/net/phy/motorcomm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/motorcomm.c b/drivers/net/phy/motorcomm.c
index ee7c37dfdca0..2fa5a90e073b 100644
--- a/drivers/net/phy/motorcomm.c
+++ b/drivers/net/phy/motorcomm.c
@@ -1533,10 +1533,10 @@ static int yt8531_config_init(struct phy_device *phydev)
 static void yt8531_link_change_notify(struct phy_device *phydev)
 {
 	struct device_node *node = phydev->mdio.dev.of_node;
+	bool tx_clk_1000_inverted = false;
+	bool tx_clk_100_inverted = false;
+	bool tx_clk_10_inverted = false;
 	bool tx_clk_adj_enabled = false;
-	bool tx_clk_1000_inverted;
-	bool tx_clk_100_inverted;
-	bool tx_clk_10_inverted;
 	u16 val = 0;
 	int ret;
 
-- 
2.39.1

