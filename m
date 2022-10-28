Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C56E611A22
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 20:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiJ1Scr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 14:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiJ1Scq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 14:32:46 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67100229E6B
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 11:32:44 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id d25so9216603lfb.7
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 11:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uxj9M/0CqGoX3XXKZn419+Fkv5RKMRMgDNXyjP5cMng=;
        b=IF05zNnzYDXRaAOArwKG85KZ5zidWjIic8XxDYz7ALN81+EZkQbtH3eIVJx/iPxZAL
         Y/QSb8tGNxVEvHIohaVxZOZTQTf4YiaTrZYgqbMYZsAZSceqxiIyaHCrvL2kSMDrUr9P
         697+4fd0wcwOiwM/VLHYoQRzhpl7sLQDitgx+Boj+nJH/08c7A9Go5WcehHq2RqFzhJI
         ZksaTJH1Y1b6QwxiF1rnspagjI/jKrrDU0WMBZfLuI7ofJnZXAq64XkVzSKWHMykiQMU
         qy6LXF9okFD+wZOROM61TXYsB4qhX9ttp8Tb+cnxP3qy2ghrt7j1F0Jdp9BrueRujL3R
         ns3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uxj9M/0CqGoX3XXKZn419+Fkv5RKMRMgDNXyjP5cMng=;
        b=ZuB5u1kQS/AiZcUITcEki2hVoTfh0ZmlDh1vwq1CixKUEdf+hTXsWdWEYxZPHaNIJo
         0fr1gCFT6NwKn8Epj02Iud1cvQgH2aE1f3ZDuoyetPeld55nFGZt60fL6eMDBVtQb5Jk
         S97aGxgBrTEh1G4PBxrqyni8TGZw6mC146uo+Rsa/YIIu/gBObf/Vi4y5frjSjHWA8qw
         UwgkKZoDGn6rEXYwzHSNFPzXCK2JAM5jXKvZ1/UXgO7wK/ktkgul+Y5U1t7VfqnqqE8w
         lPTHjcVBafaigqA+PSqlM45JAALV7BQK2xxgenR2/wh+vE0E7dqTe38UZ/Msb+qxCi4e
         a5Ng==
X-Gm-Message-State: ACrzQf3HQF/BWZz9AqnsD1kD9Su2yKNLtyo7Renx7hkAMnLnRMukf9qJ
        Rb/CYB2Ce57yjhVLu83DMbcx2U2RTWOqSA==
X-Google-Smtp-Source: AMsMyM5vFUEtQPfGE7pjYG1AwOkiInRQxG+1/6id7ki7U4QDQTzix2g2wwjjxyX2KBSdG/9/lz4rWQ==
X-Received: by 2002:a05:6512:33cb:b0:4a4:2bee:5c8b with SMTP id d11-20020a05651233cb00b004a42bee5c8bmr259251lfg.237.1666981962600;
        Fri, 28 Oct 2022 11:32:42 -0700 (PDT)
Received: from saproj-Latitude-5501.yandex.net ([2a02:6b8:0:40c:5e0d:c276:399c:5839])
        by smtp.gmail.com with ESMTPSA id k2-20020a2eb742000000b0026dc7b59d8esm739161ljo.22.2022.10.28.11.32.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 11:32:42 -0700 (PDT)
From:   Sergei Antonov <saproj@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, pabeni@redhat.com, kuba@kernel.org,
        edumazet@google.com, davem@davemloft.net,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Sergei Antonov <saproj@gmail.com>
Subject: [PATCH 2/3] net: ftmac100: report the correct maximum MTU of 1500
Date:   Fri, 28 Oct 2022 21:32:19 +0300
Message-Id: <20221028183220.155948-2-saproj@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221028183220.155948-1-saproj@gmail.com>
References: <20221028183220.155948-1-saproj@gmail.com>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The driver uses the MAX_PKT_SIZE (1518) for both MTU reporting and for
TX. However, the 2 places do not measure the same thing.

On TX, skb->len measures the entire L2 packet length (without FCS, which
software does not possess). So the comparison against 1518 there is
correct.

What is not correct is the reporting of dev->max_mtu as 1518. Since MTU
measures L2 *payload* length (excluding L2 overhead) and not total L2
packet length, it means that the correct max_mtu supported by this
device is the standard 1500. Anything higher than that will be dropped
on RX currently.

To fix this, subtract VLAN_ETH_HLEN from MAX_PKT_SIZE when reporting the
max_mtu, since that is the difference between L2 payload length and
total L2 length as seen by software.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Sergei Antonov <saproj@gmail.com>
---
 drivers/net/ethernet/faraday/ftmac100.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/faraday/ftmac100.c b/drivers/net/ethernet/faraday/ftmac100.c
index 8013f85fc148..7c571b4515a9 100644
--- a/drivers/net/ethernet/faraday/ftmac100.c
+++ b/drivers/net/ethernet/faraday/ftmac100.c
@@ -11,6 +11,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
+#include <linux/if_vlan.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
@@ -1070,7 +1071,7 @@ static int ftmac100_probe(struct platform_device *pdev)
 	SET_NETDEV_DEV(netdev, &pdev->dev);
 	netdev->ethtool_ops = &ftmac100_ethtool_ops;
 	netdev->netdev_ops = &ftmac100_netdev_ops;
-	netdev->max_mtu = MAX_PKT_SIZE;
+	netdev->max_mtu = MAX_PKT_SIZE - VLAN_ETH_HLEN;
 
 	err = platform_get_ethdev_address(&pdev->dev, netdev);
 	if (err == -EPROBE_DEFER)
-- 
2.34.1

