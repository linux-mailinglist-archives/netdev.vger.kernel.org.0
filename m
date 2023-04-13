Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8F96E00D4
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 23:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbjDLV3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 17:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbjDLV3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 17:29:19 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C5665B3;
        Wed, 12 Apr 2023 14:29:17 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id h12so11534109lfj.8;
        Wed, 12 Apr 2023 14:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681334956;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hk7xrlNRg2LjZhR5nnd2KHymPvx3zfiMgU5M+lLV6HU=;
        b=V/xeUYZxj1igJ0+uiSoZIThxos0Sd6GZlIIVkJz4YN5x1DicEctqTz+qWmxpPzfU0H
         NVt6SkFV70FUOxLccgZKXxavU8ENzRuJEbfUcvN774ef2sN3nv5mQx6vDBrB3WEBUj8b
         NqxbasXTDaFJ4UbgNpIYwmBLvUBhYqr0+aVySBcwmUFbiT6jANbYfqSGllOIzJT1rDvJ
         y3q96lE+DE8SNQ6YftOGBq08Y4pRitxCfqhGSvUQ3tQSuOwCFoWHNxMsuLvRlyeJieRP
         dGgOuYCnd4VkWLf+pTT56YeqjQgvnkvayNMm1mgDCv+HQLpnEKI/3VX9VxXjhBznjgnn
         8cTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681334956;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hk7xrlNRg2LjZhR5nnd2KHymPvx3zfiMgU5M+lLV6HU=;
        b=AGun8RJ4Pahfalhi74fvKU0bTCKEdS2E/Y9qD8E+zMmseV0+GtvymnlwCZwPbUjNjR
         IviQ1MU1eV7MEp9F0ojbviJ6bNKTctmYKkqKQ56TgeX2sW/UTUVjM8mXWdjFIXWpBNRa
         XjEP8oIIgSZBA3bSQDHcSwFG+QQdnzNPlgZodp2NIidgAeZaiZpGQodaHy3St9POO/+m
         10GmZ2dP1p/HHvMV5Ll/yOT/E0SWZPCgrjjD8aVZYRJUvcaITHIN8xoRLJq9aWjxbCdl
         h60k69lc8zOJWsq6c4EIPZI6Q1vCDuFWiuu92U4p2/IdxHb2r0i7n7S5wfaodz8Ffsmi
         eTMA==
X-Gm-Message-State: AAQBX9ceLMISlmubv92NgpJyHBxpghUieOMtl//B9JDgPwCM9ewWgWm3
        R24qowYNUme4Rb07IKd+C8U=
X-Google-Smtp-Source: AKy350Ye1GA676YQ4BN6dYLkL9CQQn88C/Cbl2rh/iPRc7tBj4iZYzuChU7PL/iQBKOFJguk8wSagA==
X-Received: by 2002:a05:6512:38cc:b0:4eb:53f7:a569 with SMTP id p12-20020a05651238cc00b004eb53f7a569mr60214lft.63.1681334956325;
        Wed, 12 Apr 2023 14:29:16 -0700 (PDT)
Received: from localhost.localdomain (93-80-67-75.broadband.corbina.ru. [93.80.67.75])
        by smtp.googlemail.com with ESMTPSA id p14-20020a2e804e000000b002a7758b13c9sm1882481ljg.52.2023.04.12.14.29.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 14:29:15 -0700 (PDT)
From:   Ivan Mikhaylov <fr0st61te@gmail.com>
To:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ivan Mikhaylov <fr0st61te@gmail.com>,
        Paul Fertser <fercerpav@gmail.com>
Subject: [PATCH 2/4] net/ncsi: change from ndo_set_mac_address to dev_set_mac_address
Date:   Thu, 13 Apr 2023 00:29:03 +0000
Message-Id: <20230413002905.5513-3-fr0st61te@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230413002905.5513-1-fr0st61te@gmail.com>
References: <20230413002905.5513-1-fr0st61te@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change ndo_set_mac_address to dev_set_mac_address because
dev_set_mac_address provides a way to notify network layer about MAC
change. In other case, services may not aware about MAC change and keep
using old one which set from network adapter driver.

As example, DHCP client from systemd do not update MAC address without
notification from net subsystem which leads to the problem with acquiring
the right address from DHCP server.

Signed-off-by: Paul Fertser <fercerpav@gmail.com>
Signed-off-by: Ivan Mikhaylov <fr0st61te@gmail.com>
---
 net/ncsi/ncsi-rsp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ncsi/ncsi-rsp.c b/net/ncsi/ncsi-rsp.c
index 91c42253a711..069c2659074b 100644
--- a/net/ncsi/ncsi-rsp.c
+++ b/net/ncsi/ncsi-rsp.c
@@ -616,7 +616,6 @@ static int ncsi_rsp_handler_oem_gma(struct ncsi_request *nr, int mfr_id)
 {
 	struct ncsi_dev_priv *ndp = nr->ndp;
 	struct net_device *ndev = ndp->ndev.dev;
-	const struct net_device_ops *ops = ndev->netdev_ops;
 	struct ncsi_rsp_oem_pkt *rsp;
 	struct sockaddr saddr;
 	u32 mac_addr_off = 0;
@@ -643,7 +642,9 @@ static int ncsi_rsp_handler_oem_gma(struct ncsi_request *nr, int mfr_id)
 	/* Set the flag for GMA command which should only be called once */
 	ndp->gma_flag = 1;
 
-	ret = ops->ndo_set_mac_address(ndev, &saddr);
+	rtnl_lock();
+	ret = dev_set_mac_address(ndev, &saddr, NULL);
+	rtnl_unlock();
 	if (ret < 0)
 		netdev_warn(ndev, "NCSI: 'Writing mac address to device failed\n");
 
-- 
2.40.0

