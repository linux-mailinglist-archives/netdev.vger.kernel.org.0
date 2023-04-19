Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CAE96E7C1C
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 16:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232812AbjDSOQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 10:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232775AbjDSOPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 10:15:38 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01olkn2017.outbound.protection.outlook.com [40.92.53.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 558A416DF3;
        Wed, 19 Apr 2023 07:15:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mvwwG7EORmzVEJ4aqoqG5SAkDPqm8hSfmxi0PaBN/lj9VBDlSwKhnplMTwuk411EwvR1X+MJp0cN++aqYZ65QXE80la0uV2ZSOBQaPEWmfBa0rDy05HdnDxB9dK35fZnuLPJrLoADYlygjNEmYR43jj05RoYKOaT8ug7RBtDI6XWOnYHTerO7IqqtQvr4Ogug4DC0cRIC0MA4CGUhQ6RX94TlLhw25TXy8HMgKlg/09FPOVUc8k3qpm1vJ4rhVkDzz37Wl2VNoqnWeK3nI0xQ4K+v3Fv6Uof5lu6UM3+p+WgvujrQOtMfXw/w0MnAC40Fd9s/gtOwniZ8rUC5vqfRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EwMex9/vqrxT/pGnN5t0f6wgraxdDhEWXacOVPgSfiM=;
 b=YTpXFCjSpC65rjC8p1lCJ88yqY0DoyblLZDymK5sK0Z7/9B8AM/5G93eOknCo+4C+MFgu2m/QnABedxVCcAHDsNkdAD2KSHhuvScOx9jRQ9NUpc1FBzSevvfvRl0jrmWc7mKuRgXwKaJi6z5ovxNFWwhcHgZh3CYkTiebwO2m5M45OR7fAOcsZB3LY3CKV5UQRz+6TdHP5euvHDxHEB1uxkbBdOliqjOqdLfHWxchkn5gBxWVjslOnOI6RNg1WFjOei6ynjRCUNuJN0c2DEfWRI7fXimGOZV+e5VvvKRPYza0Z9J1p0bUUubRMXnxp5IVbozrFX1Kf6uqn2vbJc4gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EwMex9/vqrxT/pGnN5t0f6wgraxdDhEWXacOVPgSfiM=;
 b=lvsv37tDOh7oFGFeBVp9pWLryMarpYFUfJFba2tpf/BmMQQ+u5gxYhS3DCSe19UzZEKD5JNhqu7Qu4U6eZe1vETInx8PGtkhLZKkX22Rk+GjGIDg2YVQ6FRQqA8qKsT7FKci0Ey7jZEMZq5/CXkONwJ6C+DgJO1ACtJ5qXAfXI2v75ssaOGS5A6Z0xkkUZddvHQtZHgFeG/WvNLfEcd0Bezpww7DRQejqJRvgZyDLOJ1xLzP1dnsBEbN8DiGIPq1KBm97YnL3BLgDfmuoMYOZVCumeKJZ1X7bQPruaS6GnHv7rbLWW87dTN2PJ2a6PNDNSJh34Ch0pUPNpaez+Bd3Q==
Received: from KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 (2603:1096:820:9a::12) by PUZPR01MB5311.apcprd01.prod.exchangelabs.com
 (2603:1096:301:106::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.20; Wed, 19 Apr
 2023 14:14:42 +0000
Received: from KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 ([fe80::5bff:fd7e:ec7c:e9d3]) by KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 ([fe80::5bff:fd7e:ec7c:e9d3%7]) with mapi id 15.20.6319.021; Wed, 19 Apr 2023
 14:14:42 +0000
From:   Yan Wang <rk.code@outlook.com>
To:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        kuba@kernel.org, mcoquelin.stm32@gmail.com
Cc:     Yan Wang <rk.code@outlook.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        netdev@vger.kernel.org (open list:STMMAC ETHERNET DRIVER),
        linux-stm32@st-md-mailman.stormreply.com (moderated list:ARM/STM32
        ARCHITECTURE),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/STM32
        ARCHITECTURE), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next v6] net: stmmac:fix system hang when setting up tag_8021q VLAN for DSA ports
Date:   Wed, 19 Apr 2023 22:13:46 +0800
Message-ID: <KL1PR01MB544874DAEE749710E67727A2E6629@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <KL1PR01MB5448020DE191340AE64530B0E6989@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
References: <KL1PR01MB5448020DE191340AE64530B0E6989@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
Content-Type: text/plain
X-TMN:  [T5Zz4zhCaaRN6D4NZMgacFsHXk+6xs60]
X-ClientProxiedBy: SG2PR01CA0120.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::24) To KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 (2603:1096:820:9a::12)
X-Microsoft-Original-Message-ID: <20230419141346.10517-1-rk.code@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR01MB5448:EE_|PUZPR01MB5311:EE_
X-MS-Office365-Filtering-Correlation-Id: 690c8def-c4c0-46ca-609c-08db40e06b78
X-MS-Exchange-SLBlob-MailProps: YfhX3sd/0TVMxuI8J5UzJ6wcIdkd2x4ktEaID4hDgJNjb+GaNGG+vZlHu3LoU5M6TN/MDJP2IprhMk63hsQGQm6XYPDXbqzoA+TZJYxtNuk9PwFIbLAjEPufhN9+Yr+2FcEGHBWTmWRMjLtniK+1Sp4IRwxLWRGb7OHDPuoRm1krZFYh0w0bmiaZ8HrrKYca40qNfs161G0yWNliKjFZ9GdVjjUqFfV1lI/ehDhFBiYVpqWn+sjolnTVog26BCsIEqH19GONXJxoV0ROk0xMQbCAOz0ypGB7Y7sTHTydF3h0u7U+VyqNd5BjkHsENMT/+EO0wKCrihZKR95k5HtbbXbfZPk0iHmAKR7DSso8sVlLAIYn7oMQggoTIi029KAJwMLHR5XwSTuMqPG+Sw9MMo+FwpY4o2uH712dXgIOa4V5xJRpVEDDJ9k+5M789HTAk1qKOywfYowPRnc4fwvFlNvDqidYcjfafGZhtCAwggkJ7HEVmXo96kuL44C3fa4apOfPD/tpZzTZomwilwxHQZPyfBdLLR2nWBCO5hMzFlbokMVRDwP5rs4oPRzyYni1Y5tWWLQv4ifqwZpY/gT/dLynwRiH/xsLwrVJTNkg/RcCTqeBvOik08SYK6azbZ5COGCDWloZre47Ddg9nTphwn0rA+44oZ9Tl95Sl2IBZafn8AOeCjnunySOmn0QLEbMmFfjVMEKcETuBrw0nkbou+TaH5EkI8hfWk6HxjXk2RFI6sNsCo4W/hXI0LRq0+nZgiHE1+k/fDLXfK5gQepJC+b1bl6XKnHE5s5Fy3edY9A=
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OwZNjkYP+p0BXd04eqbttVf35tLK9NBQm0AEj8+78AKzlr5u3NZAk+GhF0DejVtkRO1vLMczwLt2ddcMLcOW2Em3OtA1D1yqmCbNv4khrGdhzIreGCs13L9HoLehPPESnhKuti1RRl6UZd69k1+ayGExMKp3Hosvi28JWv5XN/oBtAEyBqY+n7J0jjLuqNcT1YKUY/aFg+83dRF1wPKYJizZd+ybCgqqK7EOtHjyH4tKaVGX/z5SmZF3aA3NJylXAKW7FINW2ScHS+R1noY4dxDrhaCjlnGlOsN9vwRk4SC+4xon81mLlr/Lgfh6mp2SH4XlsLgS/METZqUIfLVlOB7QDPB8b9vCirfccURmMwj8hopvoe+InZWzL8Izq4j62TUK9U3J15cgEcFPsg2EmQo5jR0FfmT/Uajfuu1ASPnc0FT/RayojAcJAMylq3rnR3U6seI4BRhWzTiF0LE841TO+UPeuJL/rA37l4nfFS2SNayAPLmj8Sul1db5DIkGnOIyW5kb+IhdsqK55ERnCQs3ZD9bOtMu0a7DKaiyxC3z1d80YSHLOsKlhvrJ8STcLhKWsmDRMgv9LEu9E+FpRDO3hcr19clG8IvBTJwwSQgakOnyHlkiUMSHAQ0zMBQvsWWp6vazY1NJMhas78MkaQ==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gTyLDbLdOO3MzFousNNwvhJuGntd7XKaTu9MG2S3YHa4LkQJI8bQB/nu/4wQ?=
 =?us-ascii?Q?PMvgJMS5uZZ/lGtXFLS9KeCjnewjgPgxI/B0STwUKMkHtJbRwS6GKmpqPuJ/?=
 =?us-ascii?Q?HaBC3ZZYSA07wtBlzC1Efebo7NqMFgoA7Q1PhKO/gs+z+ahVpRejzNjrfkzv?=
 =?us-ascii?Q?+zTRX+3l4DD+lc2+7mbDgtOXuoyABX6EE5FoBl9qGMscbBJMPZ8z9Ujqmzwv?=
 =?us-ascii?Q?vJqzVDpOmMQGYjX4eRtFWlGzLZOpJIcbBSs7FPkLaeLW0ccDK39b5OdoCN9B?=
 =?us-ascii?Q?wYe/KVm+oIHPHSOf8vNF5q+3tBW17eJA43sYYPOyTh8eHxDX4mduhCFE2kIU?=
 =?us-ascii?Q?fBu4GY+mxWhYloWvQnFt702QMxcni5gIRD67Jq9qxKjC2MrfdYB7jN4Fdp+d?=
 =?us-ascii?Q?PCknxJ53YdOiEakP4RTlJqQojr78XNdDD9rG7ZoqwTw62b0YSjLxLQGd1QsY?=
 =?us-ascii?Q?0Xutp8zENrubbY12dver4HcutF4P9NkU+4fZwOZwCcvSu9LpYpRkICQ0ADat?=
 =?us-ascii?Q?20nqANOG+eUAfP7KUOoaJ9zsu/LpVzSJXL+QqR1bwNIn/pSgb+insfargA1R?=
 =?us-ascii?Q?MCp5YJXk9KAknE1itfoN8MZ89jcGYT88DXMijRMUbgThzYSKqMPhBddwgYEH?=
 =?us-ascii?Q?ObHTTiafmZSIOkUb2KtSdNjn/2gjFevp7DFXtIikNG1k0IsxAK5KEwfP3aKu?=
 =?us-ascii?Q?7xehnBfAbT90ciJ7laOITHLmLy3O4chpMHYw05dbYt+foIqFQto6GDRc4Pd1?=
 =?us-ascii?Q?OoNCIIB24AOX+yRjksfV0SKWvQOX9ok2NwJElWbaOUaM/sVJJwqm8N/PjlRC?=
 =?us-ascii?Q?ez2EclMuzww0bUal/kh5iDKTOgkGU3PKo0xBekd9rVh+1uHJyCFg/juBqXeu?=
 =?us-ascii?Q?3x+C70XLq3lujMIkBMJcH20cehagv/47JQJEBsuXsO4UC/IcnQZ+DY4KJymr?=
 =?us-ascii?Q?WzL2aup4z0sW0bFHSD2k5fXhw6fgGg5PBZ2z4OTcJDRsnt6uhZbS4LdrRj4j?=
 =?us-ascii?Q?04BCdl7vJaHiti5kvupDzDxJZEYkDcKlDeYHahavrWoKu2pgH/c+e+KsUai3?=
 =?us-ascii?Q?taUYs8/0Pgs8kYF0LUqKTMFHF5/xbRsDJo6ZXL408+t43XgqNnQcDLjuIwJM?=
 =?us-ascii?Q?gvck4Hp/Rz6xPW42/7F1dz4U91f12ZdxbqeO6w0ODyPIFbJHRhuslSRzk1SH?=
 =?us-ascii?Q?bwhfx8dsy+WhNjUZ3ZyAXn9RfqhBvefE7hyBpw=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 690c8def-c4c0-46ca-609c-08db40e06b78
X-MS-Exchange-CrossTenant-AuthSource: KL1PR01MB5448.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 14:14:42.6645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR01MB5311
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The system hang because of dsa_tag_8021q_port_setup()->
				stmmac_vlan_rx_add_vid().

I found in stmmac_drv_probe() that cailing pm_runtime_put()
disabled the clock.

First, when the kernel is compiled with CONFIG_PM=y,The stmmac's
resume/suspend is active.

Secondly,stmmac as DSA master,the dsa_tag_8021q_port_setup() function
will callback stmmac_vlan_rx_add_vid when DSA dirver starts. However,
The system is hanged for the stmmac_vlan_rx_add_vid() accesses its
registers after stmmac's clock is closed.

I would suggest adding the pm_runtime_resume_and_get() to the
stmmac_vlan_rx_add_vid().This guarantees that resuming clock output
while in use.

Fixes: b3dcb3127786 ("net: stmmac: correct clocks enabled in stmmac_vlan_rx_kill_vid()")
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Yan Wang <rk.code@outlook.com>
---
v6:
  - Add Reviewed Signature
v5: https://lore.kernel.org/netdev/KL1PR01MB544863D839654F0EC9485894E69C9@KL1PR01MB5448.apcprd01.prod.exchangelabs.com/
  - Add version tags.
v4: https://lore.kernel.org/netdev/KL1PR01MB5448C7BF5A7AAC1CBCD5C36AE6989@KL1PR01MB5448.apcprd01.prod.exchangelabs.com/
  - Fixed email address,but The Version number is wrong.
v3: https://lore.kernel.org/netdev/KL1PR01MB544872920F00149E3BDDC7ECE6999@KL1PR01MB5448.apcprd01.prod.exchangelabs.com/
  - Fixed the Fixes tag,but Missing version change log.
v2: https://lore.kernel.org/netdev/KL1PR01MB54482D50B5C8713A2CA697DFE6999@KL1PR01MB5448.apcprd01.prod.exchangelabs.com/
  - Add a error fixed tag.
v1: https://lore.kernel.org/netdev/KL1PR01MB5448020DE191340AE64530B0E6989@KL1PR01MB5448.apcprd01.prod.exchangelabs.com/
  - the Subject is set incorrectly
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index d7fcab057032..f9cd063f1fe3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -6350,6 +6350,10 @@ static int stmmac_vlan_rx_add_vid(struct net_device *ndev, __be16 proto, u16 vid
 	bool is_double = false;
 	int ret;
 
+	ret = pm_runtime_resume_and_get(priv->device);
+	if (ret < 0)
+		return ret;
+
 	if (be16_to_cpu(proto) == ETH_P_8021AD)
 		is_double = true;
 
@@ -6357,16 +6361,18 @@ static int stmmac_vlan_rx_add_vid(struct net_device *ndev, __be16 proto, u16 vid
 	ret = stmmac_vlan_update(priv, is_double);
 	if (ret) {
 		clear_bit(vid, priv->active_vlans);
-		return ret;
+		goto err_pm_put;
 	}
 
 	if (priv->hw->num_vlan) {
 		ret = stmmac_add_hw_vlan_rx_fltr(priv, ndev, priv->hw, proto, vid);
 		if (ret)
-			return ret;
+			goto err_pm_put;
 	}
+err_pm_put:
+	pm_runtime_put(priv->device);
 
-	return 0;
+	return ret;
 }
 
 static int stmmac_vlan_rx_kill_vid(struct net_device *ndev, __be16 proto, u16 vid)
-- 
2.17.1

