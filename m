Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC9806B95F1
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 14:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbjCNNUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 09:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231889AbjCNNTP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 09:19:15 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67931E186
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 06:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=k1; bh=VjTn3E20TaRsaW
        HsM1MQTWl0oPBdqH1Fh0HrLM/sBLQ=; b=EQCfCw6pYRkDgljCsJYRNtEbYyyLTu
        go8Oyi1uENTxLGwzL8K5CG5Jl+he9MDhaqZsFZB78NH8WB6/Kn3YzIFuVdktfoqG
        3WVDlFSuzWysobydUzl2tABDGnX05VuRwysFwLgGQKCk8YHpomsGfkx807wSDVK9
        1QH62rX1QU9FM=
Received: (qmail 3111673 invoked from network); 14 Mar 2023 14:14:57 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 14 Mar 2023 14:14:57 +0100
X-UD-Smtp-Session: l3s3148p1@5b2gA9z2ps0ujnvb
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     netdev@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org, kernel@pengutronix.de,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/4] fec: add FIXME to move 'mac_managed_pm' to probe
Date:   Tue, 14 Mar 2023 14:14:41 +0100
Message-Id: <20230314131443.46342-4-wsa+renesas@sang-engineering.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230314131443.46342-1-wsa+renesas@sang-engineering.com>
References: <20230314131443.46342-1-wsa+renesas@sang-engineering.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Renesas hardware, we had issues because the above flag was set during
'open'. It was concluded that it needs to be set during 'probe'. It
looks like FEC needs the same fix but I can't test it because I don't
have the hardware. At least, leave a note about the issue.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index c73e25f8995e..b16f56208d66 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2318,6 +2318,7 @@ static int fec_enet_mii_probe(struct net_device *ndev)
 	fep->link = 0;
 	fep->full_duplex = 0;
 
+	/* FIXME: should be set right after mdiobus is registered */
 	phy_dev->mac_managed_pm = true;
 
 	phy_attached_info(phy_dev);
-- 
2.30.2

