Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96AE36E0AE6
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 11:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjDMJ7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 05:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbjDMJ7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 05:59:41 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2040.outbound.protection.outlook.com [40.107.94.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6BF769F
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 02:59:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BG+ZfOoWIwPc1VAK4gnOGKVRVXQokLtzRhvWr6rVkpqvZi6jvqOsK4yh53iUPPvUzkHeAtoqS6jT4AerqFiT5dlupHJSRt4j27m9NNIQbTzaiIV9yzuwAoxENRPo/1boisKcIaT8N6DdmLu3FtU4cCky/ZFs8HHRFOvz5LoeKy8aSv37vNbF9Xx26g8JMz7GDy6FH6scessZMTIchENsWuI7LCW/ctT9swHaR6dTRVHAG63U0sV73EdKJn6DmoQuNsB/kV+ijagGPqgkspWAhcA6r7DSRmMPzex3jYtFudTS1H/yiBM/lvIQUlH+1DILcHm8qAOLIrFc+YL+R7KruA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qcmW5XoYWRoEgZ0UlmwVtLC6KBdkA25Co/jTfaAJNF8=;
 b=J5pvn0sAQYOnC9+pKUzens5NzaDhDbbf07naMURh5izJz4nN9hAHe1sx2/D5PRRg/GUdZdVyYtGhZxpiuHgL126ganUNl2ijF7EGx5IyNPipBGy36o78eSE28/STGPf4loLzwd/NdVSIlVHUlL0u2tctO5d38NUkChMFCDyRv8RoJWE+bymgByWFc75sGkx9m9dNfmjt+zT3KFvrO1NfGeNjcWOmLlV5pzlwNoFbGoQVYYYCdyzUIJTtGnI7l7YPnpb0iR20nZlftMUUawQOZCFf8QTq0ZCL3FT2pqjy+pV+uOR1ZiX0CtnUDhz2JdXKboctjRrIByc8GRKaRHv+tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qcmW5XoYWRoEgZ0UlmwVtLC6KBdkA25Co/jTfaAJNF8=;
 b=cwn5t0TFEMpVF5+fsvnJV5TckWzlEAiv63t8PV8zJLVF7KuhbH/9h1BuBwaLHLCdV2HIO3fb+Kif8WwPEkFMTf9kV6qHadx+MOqDOe+7OCI7yEhh2Y8XJzdzYTpAg6/roNqRnUHMQDXyUiU6VNNN6KanXwNtXG3kyavZm/1GKZV3hApcsToQ94rXptQSASrudGf6JAm367MnH77VrF+AyMquVDozI5KYbDRAzJg9W7GdP6JS/RPjGXpbKx4vWKjSROVTNzdT9/T7kyuhIml3wtFXbzdW+7O24elDprkrD06XbgoSQtC1Kc3xTA5FTcLn1vtCiYwqUNrzEk9o3a+dCw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BN9PR12MB5274.namprd12.prod.outlook.com (2603:10b6:408:11f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Thu, 13 Apr
 2023 09:59:32 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%5]) with mapi id 15.20.6277.036; Thu, 13 Apr 2023
 09:59:32 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, razor@blackwall.org, roopa@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 4/9] bridge: Take per-{Port, VLAN} neighbor suppression into account
Date:   Thu, 13 Apr 2023 12:58:25 +0300
Message-Id: <20230413095830.2182382-5-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230413095830.2182382-1-idosch@nvidia.com>
References: <20230413095830.2182382-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR2P264CA0086.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:32::26) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|BN9PR12MB5274:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f2aa94a-0030-4506-99b4-08db3c05c787
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BNShkm/tfIwbcXVCcDQEutGPFmQQwhj4uadEpItrl3YVb2AcAqya4yOJ0ZP6tXsHuOAUW9HcDWFYeXExNmSFrhhLFuLHtqZ58iOwPRsItix2S1Keu3KruoLEfk+/k0eQ+xQ/nWkEh3l0PuNR+MmDvyeUW+b50F/EwLgsNWEncbe/6tjmZidkdv4+lZMKPW55KVlVvrnWlIAV/yvfdlRbD1Boz23LbnU7Q2L9AbvqsjLka/EIe41o5FuugUykh95u9qP3onBcm/JUHyp2ljwvnRMF3suxgEU29giXrV5xOu9/sap4Jt53hAMyT3ksrCirG/Y0w8SAIJ0HqfrWy9sFw/nZjJld4BW+B/AhYvr0kEtf9phbD5tic1aH7GGzssz3yxIPh2dk/f0Eaz9zfDAcbOF0FaJpZCrzJGNqhPoFL3gX+YGGzKG8BXYPG3f6ll+YcSQ9fzkqa6nqKlxnjO66f12ODc9ojocRwxIvtlEwSkAQS0eMGG7seeQ62dbykIIwCJLIAvYZGp8Jv/+gt/VbnyohPybvPqIhd6rjwer2uFxhgygCGDk8dRwLiN5sE5Vs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(39860400002)(136003)(376002)(366004)(451199021)(1076003)(4326008)(66946007)(66476007)(66556008)(6506007)(6512007)(36756003)(107886003)(26005)(2906002)(6666004)(6486002)(2616005)(83380400001)(186003)(86362001)(5660300002)(8936002)(8676002)(38100700002)(478600001)(41300700001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y76anbzetgPCaLwyHDuCw9WzUli42i0Gz0m0SRSybms3pRT1FCwf7lKt2JC+?=
 =?us-ascii?Q?J+vPz75B2fN6CHVWtyZ+wQPf+1YnoZHB/qDN3S2UPpaKkJfxhyD6hyUgBCZI?=
 =?us-ascii?Q?rWLCUrzPK5KL19fFXhID5lHmmbkkJZk8msGMi6mhLszsCpsZJBjPG+g3tyd8?=
 =?us-ascii?Q?FQiru1/FUiIAW3i4rciF9JELlcKO8Lm9VQ3GHy/1L8Oy1ZZLNDaPtWVzY0Ms?=
 =?us-ascii?Q?St4kdG6YDTRITMgJexEGyzH/uEpZY2h/svnCuesmiBE5ohmBwdnkocfEYWD3?=
 =?us-ascii?Q?+cCAJ/CwRJrWLAwX+F3FKxZe4yz4unTfoyq4tclhaFcPWVdQlt1hHlrG1J+M?=
 =?us-ascii?Q?S6GQAk4nlIDURe08brHy9m451XvD5qRiIhaKJ7h+/1jw5FEBy5mOLFhEhYx8?=
 =?us-ascii?Q?ZWTBe83E2AmGEykBcBDdeSd14NjCkhaopBZ56qirtw5C6ptVBeOqqNO4+ZUt?=
 =?us-ascii?Q?hgitMXAEdBagwZhkxE5kas/AVAa3Ij7rnVbWAiSirrtxX6wgqkieXwXqBrqu?=
 =?us-ascii?Q?PzaaOQYMNkJ94spe9a4QEPXnpAUYdzbEzppxxv0W8v12p6zRO1n/gqgz8Gb7?=
 =?us-ascii?Q?R1uiPtIcDV7F+UfFk8bGxmdtzFTLaxDQyapEwbhIbgN74Rh83JF6Ew1ZKbKe?=
 =?us-ascii?Q?aysvyHQIcwLbeNvmJKoE7r81wfjjsLTrYnzeoqgmSv/OPAcaioSI71/+AnXr?=
 =?us-ascii?Q?ebo57nlBoc48ne9C1k3dcaJhcJB/+Ea27zuY41MBnMfdzILa5rkO73dC8cli?=
 =?us-ascii?Q?P/0c6ucgxFUbYiLiXRNMRbJSselMQUdP7anj+vz3BzUemwbqIcqNvdEN0n7s?=
 =?us-ascii?Q?0Cmr0WNwSyfzSj1f/X7IvAQ79Trb9lcS0cOhLrh5xH8DLPp239/qFPtw40hM?=
 =?us-ascii?Q?JRbOhTrf3u6c3PzpZrEYAcYiVKLoVeWmx3ldOqgb00uTHMG07VkqMpEsjlJB?=
 =?us-ascii?Q?z/J2DyN5P5PRGnEY5UDE0iITLAAfGmC3P5rYekwxDXD9WCndtNaarVl7HlqO?=
 =?us-ascii?Q?MTMYve0nn5dUvsywTG5xnDysmPPBsou3bSDYIJyqbkH3qhAmaKK4/YBKf3mP?=
 =?us-ascii?Q?mR7dnAAVlHPmKuh8tZFw6Y7VTmZM9yA+Hk0FYr727GYdcVxqvLw6i2C4ZDqN?=
 =?us-ascii?Q?2su74tPPbUaRhWYEl8UEupYZ6Z9zjkKwwTqtUDTVGsm22ZP6ytvQIytmWB0C?=
 =?us-ascii?Q?1TS8ondVndiPmEi1z4/MMz0a/dJVpKp1o9JMN6crlpJ/+ihc8YDE3yWqnhJT?=
 =?us-ascii?Q?GuJB7kc7GhqTfiKy4i1IhzIy9IkTGdiydAOGTzpQTwEZb5kW6SiHINdeZZRQ?=
 =?us-ascii?Q?w/LKcO+rlhr/sY2flv8asO0iAipiaXY5/xFGSLT1umOSkNsFMbZDISuh8anr?=
 =?us-ascii?Q?oYRpxN1X+oLflVjHp7TxLwo10vb4xoVNWVTeUFx+WHmejgMVrTwu7lCgCVgq?=
 =?us-ascii?Q?JkwVN3b3QPd5xkfg4GRAb6zvHJu9yxiqArz5PpY0a0VDQ569E6WXcafiuJML?=
 =?us-ascii?Q?5WKuNa26sy0CqZQSq+vLs3x3lw99BYXA8Ca+lbEJq6z0a8R1sbteBE9TRWoB?=
 =?us-ascii?Q?WMBfLQLrI1j7afy09cKo+tyssOpQBg3sJ6x32h0L?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f2aa94a-0030-4506-99b4-08db3c05c787
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 09:59:32.5640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YP8m9n+nszS/yTkiMo1o4AKTJAAbDmHj84zJ4y0yBSe9WtZx9ywSdqc88dQ86JpVX7WgZlnANkZL4+Iwhaf1uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5274
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bridge driver gates the neighbor suppression code behind an internal
per-bridge flag called 'BROPT_NEIGH_SUPPRESS_ENABLED'. The flag is set
when at least one bridge port has neighbor suppression enabled.

As a preparation for per-{Port, VLAN} neighbor suppression, make sure
the global flag is also set if per-{Port, VLAN} neighbor suppression is
enabled. That is, when the 'BR_NEIGH_VLAN_SUPPRESS' flag is set on at
least one bridge port.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/bridge/br_arp_nd_proxy.c | 2 +-
 net/bridge/br_if.c           | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_arp_nd_proxy.c b/net/bridge/br_arp_nd_proxy.c
index b45c00c01dea..016a25a9e444 100644
--- a/net/bridge/br_arp_nd_proxy.c
+++ b/net/bridge/br_arp_nd_proxy.c
@@ -30,7 +30,7 @@ void br_recalculate_neigh_suppress_enabled(struct net_bridge *br)
 	bool neigh_suppress = false;
 
 	list_for_each_entry(p, &br->port_list, list) {
-		if (p->flags & BR_NEIGH_SUPPRESS) {
+		if (p->flags & (BR_NEIGH_SUPPRESS | BR_NEIGH_VLAN_SUPPRESS)) {
 			neigh_suppress = true;
 			break;
 		}
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index 24f01ff113f0..3f04b40f6056 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -759,7 +759,7 @@ void br_port_flags_change(struct net_bridge_port *p, unsigned long mask)
 	if (mask & BR_AUTO_MASK)
 		nbp_update_port_count(br);
 
-	if (mask & BR_NEIGH_SUPPRESS)
+	if (mask & (BR_NEIGH_SUPPRESS | BR_NEIGH_VLAN_SUPPRESS))
 		br_recalculate_neigh_suppress_enabled(br);
 }
 
-- 
2.37.3

