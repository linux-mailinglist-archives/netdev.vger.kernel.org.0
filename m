Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C890255D7AA
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343731AbiF1Hzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 03:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343681AbiF1Hzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 03:55:50 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701DC13FA7
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 00:55:49 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id b19so1134853ljf.6
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 00:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=CfDHQwRwqZq5XpGRYdGPtbOI2+7Srf+S8q/0QgKiGe8=;
        b=WU/pm2NzAdRKFbDdiXlpijFtX0wFBt5GRNm0JqhMbq+/04hs0T3QRYoUq8gdd5to0b
         Uhhv6U2kJiDvP5Q3pjSsmqAHPDX3T6SDxiKgn+Dfrx0I8VLSp4pZhQ8IRrvfE8nGtm8z
         0sXvq6DsRTQS33sw5LOh6mdFSeVWjPNN35FMnHbm4us6ngh6NQbCIQXmk+gJCe6EzWGJ
         o5j6Lqcak4KdHxv5b5ZFwxGuRahMtfrOigjSMVKIQClwo3ytZ9TUYqpN/232ExDIUWHm
         AYA3UvE2bxfnRGjPW0TCSqwcpaNrEWWFU1wly/86bUKdb0P8mwpO6cIk7ojsFNd78RUh
         QwAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=CfDHQwRwqZq5XpGRYdGPtbOI2+7Srf+S8q/0QgKiGe8=;
        b=kHToxKsaGJlKUmX++iy50BgPR/ubin/FJPq120aA73s+7r9kPzOxyEuUxDdri5P41S
         8Cp40qAvhtoKiasl5nZ8FFzq5tS3Pfilgsfl1a1AjBiK+aE3Fxw3R85R0L3NP/LcQkcp
         /JkCa1S+ut9XU8Z1UaMI9Vf3mRB4T/3W3KszSQ5sMkYF07D700ze2ZH5+9mGrkpJlcWA
         WGX02zHuAjJEGTygeFbX+NkfC2xjd09iDX3xKGCFBAacpeeB49WNmCt9HfX5cX6Hm1Uz
         /j99j0pzP6t/k0kH+nQG/Prp8z1To2fwNIMhpiYBg824/CXRtEGm0F4Mxq+lvWuoGKsS
         rntQ==
X-Gm-Message-State: AJIora/BQmyftgdNg0Gpr998zdMBXJkwlYZB3uoUhE/ughAf4grWi8fk
        j5mRW+7T4rlj82jwN1zS5Os=
X-Google-Smtp-Source: AGRyM1tW7WP2jbltl2Cz9g53l3q+wNG4D4sWHxrQpgPW8iYPw/Qi1vwQaE95tJcQZonw2qiswzjT7A==
X-Received: by 2002:a2e:a26c:0:b0:25a:6dad:8bf5 with SMTP id k12-20020a2ea26c000000b0025a6dad8bf5mr9146201ljm.136.1656402947703;
        Tue, 28 Jun 2022 00:55:47 -0700 (PDT)
Received: from wse-c0155.labs.westermo.se (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id f1-20020a056512360100b0047f9cee5f16sm2101392lfs.183.2022.06.28.00.55.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 00:55:47 -0700 (PDT)
From:   Casper Andersson <casper.casan@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org
Subject: [PATCH net-next] net: sparx5: mdb add/del handle non-sparx5 devices
Date:   Tue, 28 Jun 2022 09:55:46 +0200
Message-Id: <20220628075546.3560083-1-casper.casan@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
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

When adding/deleting mdb entries on other net_devices, eg., tap
interfaces, it should not crash.

Signed-off-by: Casper Andersson <casper.casan@gmail.com>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
index 40ef9fad3a77..ec07f7d0528c 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
@@ -397,6 +397,9 @@ static int sparx5_handle_port_mdb_add(struct net_device *dev,
 	bool is_host;
 	int res, err;
 
+	if (!sparx5_netdevice_check(dev))
+		return -EOPNOTSUPP;
+
 	is_host = netif_is_bridge_master(v->obj.orig_dev);
 
 	/* When VLAN unaware the vlan value is not parsed and we receive vid 0.
@@ -480,6 +483,9 @@ static int sparx5_handle_port_mdb_del(struct net_device *dev,
 	u32 mact_entry, res, pgid_entry[3], misc_cfg;
 	bool host_ena;
 
+	if (!sparx5_netdevice_check(dev))
+		return -EOPNOTSUPP;
+
 	if (!br_vlan_enabled(spx5->hw_bridge_dev))
 		vid = 1;
 	else
-- 
2.30.2

