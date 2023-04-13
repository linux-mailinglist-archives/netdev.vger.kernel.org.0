Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E67E86E0F07
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 15:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbjDMNmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 09:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbjDMNls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 09:41:48 -0400
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01olkn2081d.outbound.protection.outlook.com [IPv6:2a01:111:f403:704b::81d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5DBAD17;
        Thu, 13 Apr 2023 06:39:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g9xrADIMYJrEhvYmgnulJUAskHYAcS8tJ6UScpyRNlTS7SRwbunfBhXFsUZFKZo2tHLKZTDSHfqdWQAZ4PkEON0cTzsnFiD5Q083VWWyMvAUoMG9kBKSidV2eRbdaAEF87LDujAknmC2POdts2KD123wKfbpP/IUtOs93njmbZFNeUuzDxLGC+umEg8xrpi4EGZcVhWzC1gvx2QJPFbFYf9LCQEqYR7TM3pX//u1lelHwoc3UYfw+zDt4/HTG0KQxzkV9bytHHXFDeZwjfwdyucljSM7GQxXhU5/EiZQ5L8gjHxqlLo0VmBzRjkmuC8yMjD7B085EVL9Q5FeCKDnfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mm54x0ZpfEPUTyp717dSMXaBikmpwNkOoQc7/DEi4Rs=;
 b=f8rxgxlaDbVbwK3HoL+FjrgVdF7OrCgwbap7MJV8FO6YkBzilDenBjVNFT7Op/o4I/Jn4yoeXMhaJXnX+//2TTIRAYyh7Uk4KBP4D71YycuxuM2SiZQ7fPjvNupyfboxc5Lp/RMwRqVngBO1xqyLn9mAoHfjt1F7b5ZYYcDCrIInDzgjHWN//p51q+M30crY3hRp0oZCGuQT9Q4bD7ANbqaH1p0WUgSxqushGZOyLYftSq9ml5jh4OMmTPvzsQImWIqHbjIyqL26KcS8duKopSPzwjN4VGxzVCoxy38vtPa2HpA0XHQDDj2u1jk30sA9fgMnPiF2rYTpstsBqiKBfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mm54x0ZpfEPUTyp717dSMXaBikmpwNkOoQc7/DEi4Rs=;
 b=Sl+A1NvhqYsnMRTg2SL7sD8WVJTQqoNNStf+KvqKJnPalM7MeC/b6RlJsJhnz4mZnzekVDAvgMzsLHCGs8yDlUdXPRcXLhwdyFGD+9QNC9LUZjp/KIRtzcWGWYHDsR4CqMsE4CSxQIPOh296MWy5jSiG8gHb6wNcy9LfEqhGn5XiIZ6D0VaZOaRum37VXrUEwmUfbXdRX58+tOU0uowtRpAq4C2zLzgodGa2FbMuA+s6tKHI62k5tSADv0Wbh1/wsjZ6NGIlVwxIabUYg+dOK6YDf4UrJ7tkwZyKtyGX254nXGxyd6IKW5A7Y4FRp9Aww73DxeF1C+klEr8Afzhqrg==
Received: from KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 (2603:1096:820:9a::12) by TY0PR01MB5412.apcprd01.prod.exchangelabs.com
 (2603:1096:400:279::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.4; Thu, 13 Apr
 2023 13:38:57 +0000
Received: from KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 ([fe80::5bff:fd7e:ec7c:e9d3]) by KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 ([fe80::5bff:fd7e:ec7c:e9d3%7]) with mapi id 15.20.6298.030; Thu, 13 Apr 2023
 13:38:57 +0000
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
Subject: [PATCH] net: stmmac:fix system hang when setting up tag_8021q VLAN  for DSA ports
Date:   Thu, 13 Apr 2023 21:38:32 +0800
Message-ID: <KL1PR01MB5448020DE191340AE64530B0E6989@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-TMN:  [FBE36qCL9osDQYswg1W5k2d0z5bBysbfamTzsZgSih8=]
X-ClientProxiedBy: SG2PR02CA0012.apcprd02.prod.outlook.com
 (2603:1096:3:17::24) To KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 (2603:1096:820:9a::12)
X-Microsoft-Original-Message-ID: <20230413133832.7838-1-rk.code@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR01MB5448:EE_|TY0PR01MB5412:EE_
X-MS-Office365-Filtering-Correlation-Id: eec0b1c0-148c-4afb-327a-08db3c246e63
X-MS-Exchange-SLBlob-MailProps: EgT5Wr3QDKx/5wRYKwbtF7hqq2E99L18DXqaHAPjZVBBA9B1MIywpG4LTy0MxrqpW+U88FnyYC79tmKNQR7a8GxOvPldwlTMKqBrU2bn+EX8lEHDTh7UXI2TZkoxz4EFTRdfOY14tKDG7IiqfJ0E1p9Nrnul31xvP1xDhiAaY1N59lP75OVSeuAGQYnNHvG9ti7F8S2NBtB78mkmAC5IYWL0gmSvNOw3+Ey70NFRNbrvwJ291SJiLNo6hz4EPuTgFlC7nVYX0CwyMoARwnnJZXXb56j0gBXZwJEZAMG4zQGiYpRSfa0zcB3y8ONVwhbVbH5QOAP3dlkH4eqndtUqhd3P2R+hdMAP/gXspbsUgQL9lF1xaRQvp58Yqeu8sxeoNaW/VRCYgzTDNK+TUvj2S/8R9LeK5XCu9uxKD5vlfpOkwAx7y2I5TmTW3Pe2r6WVjL9xpv83WOKT4iqfwOcrDMe1yX26GHVpPpH4nEG1s/gwZlqRdWX2kd4/Oj19QaIe5nEkhnUmMbH1DvpxMgJueOhXYNXT9oHqxzk7z6ZJA7ple24XDr0aJgS0VEiudnuWH3+wSRRHZoZfjP5z2C+zxcgNs5YduKg07ssFcH0qyxaL9fgmS80Rj+CFr1Nfr4yww1+tdmu+0OoC3pXU7kPKwFWxCDmRKCGJYvzo095LYpY4+7Q8OlnJXhGGwt9Ir2BUbV8NYOB1Qa83kiKNQcd/jvugEESjEaV2GywQ6NSRdtA=
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8MtZXCkJIx9gEEtKNhLEVrqIBGNSQH6ZsuUepAK1q7Rg0n7OCoqGTr0mxVF0D9gRwz3tyFnb4T+d3K6LoEVVvZVNTTkAcUquRt+6H4PdW3r4WnPiFceLp+oK1AGSIbb+SlTU7Z2NTHL5Bnetb9fJVBHf8g+xq2fwipYEb2wQuXboe3BNEUXaqqIvnL3Uijj37tzGrg6jAU6A7U3QKpogDtZ8la2KqfY8o4pYyX9BmyUVmnnQqigp61LpNqz39AFsJzL4N+r2ohvp41vhQevpdGu+sbIek8UW8kuKuXnuOcYO8MBjoixObjjH5fhjCIIMGbcdNfKb/fPExnc0lZO5q710klO4Aj5UhhIC/JEj0vbg7A5sz5szLBsWXAp+X0I/ZbqStOK5hzLtY4ie1Cb/yPMBDFpi7I3j7zeunF3WIqgCUI6d8YxMJRCGxsKbIrZWfpAuEdTeU50thCutjUZwGAtuLxgcb+IM86761OBqoPtbHm2mVXiB1lAcbBwHRlY7Yy1P2MaDKUTYSJHZQtg+7qP0vL3oFfvny3PLrMLZ33jqY6I6fAvOe8bYb7b9r9FwtyyUyTAqJzj2j/koUc3krKkpUN11NwQcnHYAIUCKisMmEEAXiz1eWE8/88ZmfFWP
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qwbjwu/zFmItuqYCEJTUiHGDXjYsNFBjKbtuWGXYCAVnFiJ+B8oCOhm0wboa?=
 =?us-ascii?Q?b6vzRWVlvVLZG5yqzK0DWr6vT8c5cSLoIkeKq8YJoUfPtgp/LDv7pA+ZS6T0?=
 =?us-ascii?Q?sOn65OleDyvSo2o0FjJdoRDOb5J3YbD9fwwLh06boP0UY19+jqLyZCHsSkJ/?=
 =?us-ascii?Q?kCemgJWLe2RXa1orQGPAE9jEGUzGWowhDCE4HIo1gPnwdR6lRjkAoZx+tJFz?=
 =?us-ascii?Q?5UGCrAZbLGWmbOfebv7lZ4kTJogpdZjdqI1/3MJYdSie94GpcCzwAmPBD7Bz?=
 =?us-ascii?Q?A+IjkcZFFthv+7GgpXVdVWp7INUygt7kaytVQcRh0u8fAfEpqg8HXOC8Lo7k?=
 =?us-ascii?Q?82LgqX5wiI6SF5HV1H/SyaEVp+NL5/aEDqLNgnvHoOwGaf8zWe1rO4j6lyoF?=
 =?us-ascii?Q?ybDw5j8tzf7xfgxeE7uYjise9GaCkmNqS2dZh1+UoS/5AW+ffZQ8VmbSIgXf?=
 =?us-ascii?Q?Vy/l7VgDZwG3eZmcJl/OcOGpUXu2RSS6Lhzhrsw3UFZL1aF46PYNrKuRe4N8?=
 =?us-ascii?Q?4QhQwnJcH3gJLgoYJNPd4YdvQ2BzF/0QXEGMJwxNkMEMGUCxdDODc2zj7OdD?=
 =?us-ascii?Q?y7dktzVNs4H2aviHCt1GIcTGI9DUUNWiRT19pBLykQRfUBrxuESPAYHOwIHT?=
 =?us-ascii?Q?dNL0CIYZgc3NBNk+9YltIhIhgoKf9qwYf2b778amDTuq9qWxpcQU1QHX2EBQ?=
 =?us-ascii?Q?cYLAxmQkWhrXol9W75XG5cnDJx4Ls0n6Z3cK6cYIubv4JkBqEEaXcI5CaqI1?=
 =?us-ascii?Q?hiHS2b9jdPKd9bjTILQ7pZ6EuFr+cb/GUMwM/IhYw1As9ScOj8Blr7cHaEEB?=
 =?us-ascii?Q?aCZY3OwIThTgoyCseuE1PkntvedKs22M/6t1r57HTf7HbYFfDgNYTjE3qvZK?=
 =?us-ascii?Q?3qUW8cahp5B+KZb1KQSqsc6wWJnCpjZOeV5ZVdZVqTJ3/9juKIYL/NSElb7U?=
 =?us-ascii?Q?fcmKIg8yrXFPgDzi1Ajf6MEpzjKshagi4bgg9EMV41eQzg3zkC2dKC4YCZR6?=
 =?us-ascii?Q?NX4cY+nAFuuudUxO0q+zMP+eCPbb6pibit9zD4Z1VP5M29+txokaZCmOAD4v?=
 =?us-ascii?Q?dW05E2iUivXGixp0SXBssLZZRC5P+9gnblpY2t1ebVD4QrOCu3vkdmKGu3+5?=
 =?us-ascii?Q?3u7dPlEgADMUByb609YHHkyYKUkHlHvAmIhn2V6e9aRb8Y/dZUVK/+oYfAKG?=
 =?us-ascii?Q?VDWJg/+d1I28bWoSc25a2VEKlpQbY+sZvc02hw=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eec0b1c0-148c-4afb-327a-08db3c246e63
X-MS-Exchange-CrossTenant-AuthSource: KL1PR01MB5448.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 13:38:57.3416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR01MB5412
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

