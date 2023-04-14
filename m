Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9A056E1A4B
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 04:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbjDNCYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 22:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjDNCYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 22:24:10 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01olkn2060.outbound.protection.outlook.com [40.92.53.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F7330D5;
        Thu, 13 Apr 2023 19:24:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VotyPCJVFMIhfTrCoRucowbjF2VAOOSHEQKEUth0eG9kxv6oaqaaq0Qtn5ttWG5mjBEOiqAqAY0sf2qz0tktz09KuqcF9tn0aEQjBswKg1Voks/T1YKFaLOiEG9xXqSUg9B+rFout6Ls4y1oDThwR+TD9Pvl8w2R9eoW4Sa3kViMbAgWNtf5M87pu7G4qBkn1nt8uEmn/o2njjBmWIyGAuZJvv5B/r9uElzu7YddcRawSicqfJBaZep4uNdsUkxEOIOTjej1qVG2v0jgasqByJlKsgpHo8GbFovr7G590qeJrnZ77Jm9auu4n8XXByAC0zHnoULyuSKUuOvDwlVHOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qBDbvD3JZkVSBPlod6bdoB90wzu9+p4AQQEdai6b+04=;
 b=Mf08bS4Uk5QmjdjjCIf8/DrkfWX1zgBAhoPpocel7yqw12HPw5M8BZcnQOCdOVhhXU4sqp3LSXMzQbiPh4xdeefSUDRdVZvdC2np9I9HLhhjk+omGM+nXkC1Ik3CT2K8N5lusPU6jb8DNEuyKvHeS1R0XYCPO1bqbeU0pAFn2tk4DXxyOltDK99PXxG+3MZQCf7ab9kfKZKu7i5K7nDPqmEMkSMr3qP+tYP00a6e8zgHo5GR8nqcNZdxjQm0S7UJflmtS7YtI6NmTSdvQioqi5qLYJYo5w7d7Q4W19f2DYGyh9fmVHVR01dh+blPQK8xJCzBkMEbQxwTsrENYhYO7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qBDbvD3JZkVSBPlod6bdoB90wzu9+p4AQQEdai6b+04=;
 b=TWDB+QJi7mg8PVi6bMD85NJ5++mZFQgO8q3Cl4Lj6PUZ0u6N/ZeJxJMpYzs87r7t3PrZsJtRLxjpu3Mf1rMLbz/l7WIBLYDB0PUnS+5fAFHARboASv7R3zcMDt7o9GecQGC67bmEYem5Re6HOszbdAZog/tqhQWFyMPX0EygoPBkTvGCVRKr/dalYAfNwQO+oM5pGa/1wYJ7+Lbg53YFn4v6ItdmMrKVgU9+eZQaXwJkIHCilsHQYKAkMm41DxKMbHii1U9G70PcEwLrr6YFU11+TYF/bWkdO/AlJt737l1GUIaDkU3Lz64eGKQ66syFDudXX4Zew2dHkT+Z8Bk06A==
Received: from KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 (2603:1096:820:9a::12) by SEZPR01MB5342.apcprd01.prod.exchangelabs.com
 (2603:1096:101:e5::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.4; Fri, 14 Apr
 2023 02:24:01 +0000
Received: from KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 ([fe80::5bff:fd7e:ec7c:e9d3]) by KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 ([fe80::5bff:fd7e:ec7c:e9d3%7]) with mapi id 15.20.6319.007; Fri, 14 Apr 2023
 02:24:01 +0000
From:   Yan Wang <rk.code@outlook.com>
To:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        kuba@kernel.org, mcoquelin.stm32@gmail.com
Cc:     Yan Wang <rk.code@outlook.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        netdev@vger.kernel.org (open list:STMMAC ETHERNET DRIVER),
        linux-stm32@st-md-mailman.stormreply.com (moderated list:ARM/STM32
        ARCHITECTURE),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/STM32
        ARCHITECTURE), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next v2] net: stmmac:fix system hang when setting up tag_8021q VLAN for DSA ports
Date:   Fri, 14 Apr 2023 10:23:41 +0800
Message-ID: <KL1PR01MB54482D50B5C8713A2CA697DFE6999@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-TMN:  [iutxibE7g/AJa0EZGWrBA8JcKp1NSYu2Ve8NNNXbiLE=]
X-ClientProxiedBy: SG2PR01CA0111.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::15) To KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 (2603:1096:820:9a::12)
X-Microsoft-Original-Message-ID: <20230414022341.18095-1-rk.code@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR01MB5448:EE_|SEZPR01MB5342:EE_
X-MS-Office365-Filtering-Correlation-Id: 157a1ed4-ba50-4fc4-4700-08db3c8f4f71
X-MS-Exchange-SLBlob-MailProps: ScCmN3RHayHCvCmR7Mrip+46pMXVmOzprsLuyh2I67nGh5nZ7zZbEY0KUuutlMqqtHCXkPobdCGgHNhfJS+upb0wirypm/N7aVOfjvdbQhVoUvlduaM9or71uiMQbb2TZclrArSjcKMcnTjAo0cciFggy1rLkM/HP0DPfuTy/BYmN1433IYYHRp22hMaXeH45Uox2UISjxKyBOhHepyg86tv36jYUtbbgupny3H2o977FmjyWxMmzO6LICfXqZjAAu280PKYn6ZTzm4ch2+3wXvJaBiLaIhF1cvznv5v0fVlkf0nm3PQ6pa96GP+rPgNVGv9nUF/XzAa4Zvwybw7lhWRpC2sn5tqCplDb7PguPolnGMu3AQiUHg5lHAHCLvc/vTo5mfAeOjAze0kTVTF4oVHQ5onSeq37lbvNaKi8Mta+Y8m9H+0wIvm9j2M/1rkxeea3bGYmw+snfOECsW+Ja1GJpSJUj6J+arEU2anLVNxCmSnR4vUZeagnZdehwGdxLgRzQUMUwzdELo6uJf/lQHeHeR+CmGaHqg14bzF2mj7ChxxauaH3F+1jfIZc5D8/p1E5vlU3TUgWWdm0BtGH2gogfQqrwvPzNAfskrVCkQEHl6pnomgJwzjvvd6q0u34CWyFDwqno5NDsovgzc0h64n3/xRpvNa97YvXN3SkS0j7rV/8X/OvyRvB2wwoAPIBQgO5nbb0P7nUW06lNcl2VaZTmVa5zyefRLPLb3JHus=
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qzHaPCFYOQcEQL7nliogwm1wpVh2SlFe84bjb59amplC1Tt7nLAg2fFnhpx1gb7vJ3G0+dibHjjIw8U+AB1pP0DnTHYgaNjnJclwmlpK4MWsJPfb3CurIlJUhwNOKyYjErosYzxNitGG2jzRHSV8Gvh+BWbHSLYZ2i3yCm6LZTibVAPQ8ocALgHeatheRjVMvcP5Tw6c9Rbsiyt8UlAKMIliDgEanGztDphUFL3CwUTFbd0pTUoHi/4BLT2/lGat0ovKNAHIqpm8+Sk8CtvmBXOdJtntvJbOIkRlIG2+mWruOXzKTiWnHRwN5cXfu+NB3+E6ozbGF2ewyG0oIaLWAmRcwoHJMobGGGSUVpByGwaDe7gfy2HwJUrZU7nU8JTwEb54AOhuq4YV45U5k3UQI+mqBXlzBvdFTsmspSS6pkfHvqhdBLJ6pwbQR+H89Qt9OHogz2K0ve+u6iNk+awHGUTkNtmch9sz2S5h1HFEO15AYiPDt0rhznmwQlAD2qz+N101G6BFPxPIgup9eHL8wy0sXWrf7JMA0IAzhfoSjQZbl6xGRO1EZdUmrjSqPxbMe3Gixi6Xn2rXYFXnThPtw618frRDNaixDjnAhl+35YOK4eMaR9RC4e7sYI5yIkrf
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d8sHqUsVdDFEtfLgYcpvcd1FGuirujX/G/8IAErtjA+gg5a8DdrR0aolK4Fn?=
 =?us-ascii?Q?nkG8xOdGev0kVF1rblcK0upEWevtcOv5Aa7dpoLc1U8Fu74j+4mJ1pb60bF4?=
 =?us-ascii?Q?2h2wtLEIHk27PCqkYS0M7QingCO1NTlqbYg/kmkjBDM2rU642ZludhV4NaUz?=
 =?us-ascii?Q?5G3yjqWv5tJjk4YmFxoKphzzJeVS6ACGc+aOS0uAEk+koPQE5avIAA/u2xTg?=
 =?us-ascii?Q?PluoFxGGB3aML3E3qja1aJwqIX2Y3eKFTKiAeA7Oh9nG6TGshsJ4qkumfmrW?=
 =?us-ascii?Q?l+kaym4kNusZFIkJ0KIJwoqt4KAywpCljw6teVUuNQryqVjIMh+uchfrjv44?=
 =?us-ascii?Q?BeRUbEATLgn93K7N7xhw8wqkZWkeRR8B5WnVUcLdKxpw9yWH93Gzmy5AGYZz?=
 =?us-ascii?Q?wNjixof6woRuJBBKJhXuSJIVt3K9oMFl5uo3hjS/WUreSjlvhNKD5RbaoovI?=
 =?us-ascii?Q?7hZXXWpIN1O1ahGw7JF7nSLc+Gt08t7fcpIAGkyAQX22HsWzAlSGYy1NAGzH?=
 =?us-ascii?Q?H2wRl76NiyUIfL3S3ZB3KZXsaIjriExno8ts6q9jFGic7L8M8YoDiJmX6nI4?=
 =?us-ascii?Q?JZ6ZoTXXpYeE8RxKhZIqj2Wau5+1GvRvaOMTx3GtKrLRE+RyMlxeaKYiayty?=
 =?us-ascii?Q?MwTu2L0HO1sFUC1xkkP7UfHL/XwefE0rIqUH4m3sgeSxC9zWFh4IzJHfNZYg?=
 =?us-ascii?Q?0w3N3ndSVF5RoX25uaiV5LeLZn3CMUuQE+JnHsALAC9H5uggI3blCk/0pFSM?=
 =?us-ascii?Q?bAZmFBbgpdHVIJ2g+WYYcu6MbrMuKZ1X8UR5wtdNaAlijvIkeRt7Y796T8i8?=
 =?us-ascii?Q?im3pRSaL4P9jcgqPK881/GksD4ygVrkNWatJtNCXuf54R/DLJ//6Wmb7nv86?=
 =?us-ascii?Q?1Y8IwTlUzRCDQ97wT8eWmT9x15pIlwC6QeZMN3myBiIlgc3IRArxvvKK1KyV?=
 =?us-ascii?Q?Vlt2LLrzntJy7oh0CAYshX3PwgP9Zzxsnjk+tz0IhHb/ig7hF2OQKm6YXG9m?=
 =?us-ascii?Q?pdlLMLI6duPAjHDlwB7rnUDY7bNKw9VcoHvKBhQUtpyt/DFM0/WLj8UcFMlO?=
 =?us-ascii?Q?oKMIsM7CRBvwcqJ5IJG2W5na0hHlOlZYOg0hrJX8n8OjV9hnFlD3fbbgs0mN?=
 =?us-ascii?Q?zc09JTMNfcO9Wf3y1Z1W6IUb2cwMOu/Vqdtq/f8XaSGFqN63+bhBSAL7zVS5?=
 =?us-ascii?Q?wcdgfdnuPYDe16hcyMc8fh6n/5ociAhDZoUn/g=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 157a1ed4-ba50-4fc4-4700-08db3c8f4f71
X-MS-Exchange-CrossTenant-AuthSource: KL1PR01MB5448.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2023 02:24:01.5841
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR01MB5342
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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

Fixes: 804ff4120f67 ("net: stmmac:fix system hang when setting up tag_8021q VLAN for DSA ports")
Signed-off-by: Yan Wang <rk.code@outlook.com>
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

