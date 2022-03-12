Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 798564D6B75
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 01:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbiCLAbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 19:31:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbiCLAbj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 19:31:39 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 610EB251B90
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 16:30:33 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id u9so5164244qta.5
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 16:30:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=x64architecture.com; s=x64;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z+xg56amiFOmO3t/mozoCJZ321Z8I4RKP3FFSZrXPCA=;
        b=iTn+KPGA1ZiZank1157PTYWZ4XAjPPyHXcJLQkAdeEO90uLSx7Zrct8GseftpAQaF4
         0DzwVCY1a/grwa8nxkv4hO9m0qlWhh9iAHY42mtTKPPvTqi5k+L2OPUPoPX75atY+sX3
         ph5HaDWG1bNhRl2XbhHs7EmV6v2w2HrttJxOcybp/PieChBWdIO0PcDBfQY8k3Q6iC/Z
         NS5Fq4pXQHBIIFNeSMPV8D7UTHh4IxqsLjKpQu2cNQS+pcRKJaRFXhLhjNbV/forfUWx
         d/Br7atNmN0wf6xPpUZ+/jsqVLqDrMywwEjtSaEY58/ID1LyeY+go3QoamGCHcnsTG67
         tNhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z+xg56amiFOmO3t/mozoCJZ321Z8I4RKP3FFSZrXPCA=;
        b=GESTqj/mbvv+tZ+UKgHCHjgbIJd6uooWyiVfiRQO65P1/yKsmKw1LTKPJujsFCExZZ
         +krw0ZimX1WO3drC48FrVOFlja+QZ431/psCTXMlc+XIf/Uk7HmDZ5/Nu5K1Sob2l1HQ
         6Dx3Ym90r/QoVJNfY/HIcdyCb2ys3xENPs3EVOhQAn8NUc0qnT+sAj5KM9y0f+KbyfkN
         Rlx5Av8sVGYFX07JcBRZF2w7tMqYc6WIRRyC0fb1sFMFpl2kfkllpYYfVl9OluKmUlbJ
         8P5qk1KSQPYTBAl1mM4fp1Xz3wJvXIFVbqANUZjl/l7tJ8FZodE9GGnfD+oN0gPgEcKn
         CKsA==
X-Gm-Message-State: AOAM5328nSDX6e95V6bxCdGmV0bY7kWsiZrz69U/0jr5mI8KaLkUKnKq
        o+OTlyOUH9y0jyN2EWFeng2FbOy2Mh4TPgEQ
X-Google-Smtp-Source: ABdhPJxMzgeWfFTBn5aWmfIpXX25MOTnQCsoU4xGgvb7/8Ej6/SSRr0bHOzb4KPosmT30alRKuQPJQ==
X-Received: by 2002:a05:622a:190:b0:2e1:b6e1:a329 with SMTP id s16-20020a05622a019000b002e1b6e1a329mr7563284qtw.42.1647045032196;
        Fri, 11 Mar 2022 16:30:32 -0800 (PST)
Received: from kcancemi-arch.Engineering.com ([167.206.126.218])
        by smtp.gmail.com with ESMTPSA id i192-20020a379fc9000000b0067b314c0ff3sm4510828qke.43.2022.03.11.16.30.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 16:30:31 -0800 (PST)
From:   Kurt Cancemi <kurt@x64architecture.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, linux@armlinux.org.uk,
        Kurt Cancemi <kurt@x64architecture.com>
Subject: [PATCH v2 net] net: phy: marvell: Fix invalid comparison in the resume and suspend functions.
Date:   Fri, 11 Mar 2022 19:20:19 -0500
Message-Id: <20220312002016.60416-1-kurt@x64architecture.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This bug resulted in only the current mode being resumed and suspended when
the PHY supported both fiber and copper modes and when the PHY only supported
copper mode the fiber mode would incorrectly be attempted to be resumed and
suspended.

Fixes: 3758be3dc162 ("Marvell phy: add functions to suspend and resume both interfaces: fiber and copper links.")
Signed-off-by: Kurt Cancemi <kurt@x64architecture.com>
---
 drivers/net/phy/marvell.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 2429db614b59..80b888a88127 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1687,7 +1687,7 @@ static int marvell_suspend(struct phy_device *phydev)
 	int err;
 
 	/* Suspend the fiber mode first */
-	if (!linkmode_test_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
 			       phydev->supported)) {
 		err = marvell_set_page(phydev, MII_MARVELL_FIBER_PAGE);
 		if (err < 0)
@@ -1722,7 +1722,7 @@ static int marvell_resume(struct phy_device *phydev)
 	int err;
 
 	/* Resume the fiber mode first */
-	if (!linkmode_test_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
 			       phydev->supported)) {
 		err = marvell_set_page(phydev, MII_MARVELL_FIBER_PAGE);
 		if (err < 0)
-- 
2.35.1

