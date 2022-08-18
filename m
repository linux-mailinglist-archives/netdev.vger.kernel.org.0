Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6F0D5988A7
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344698AbiHRQUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344742AbiHRQUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:20:03 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150082.outbound.protection.outlook.com [40.107.15.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98496C482F;
        Thu, 18 Aug 2022 09:17:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bb9QTH2f0OMa7m6b2X3D0ijNVq70hcMYrbQ2R3n7skEtr0/SwPW+qEdxBbuVI4BQg1v67DN0aVRGDtM6eLttM47wkCw9RlC8QSAV2j5KkdbbxYere9biTsUnzUXUGH3TBTFlWulVBibxdEh8Pg8r3omfAJIVIlTccUhDdYQQxmzhl2BEPJGJDb9kbyFHHBqLL9Xl+R4cqbUUDObf3RWJ4+QFlv+E8X4RtaTom46pwy6gOxA8Mu5F/J6JlPSH8hHe83S/izZ1LEHPKhd3Stbv5ei8i3AHaI8Hp0nqWIvPe6gbb0YDBQvkqJpdhXREA0Of52t2kNu4x9sZILPwlZfsPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vWM3q3R1Y8E6SXV9dJvf6zSZ3NqhIdokyA4glzZABBk=;
 b=dkmVVwQ2dQ+S9awJcTNgARSFl3UqH9ei/DgJ7z+FiK1DV5TiI+bw/SYb/d+9MrVLSERsx55fePEAoYe74ddNIXB/EW0GrIJl+dlW6Pa0cmPyqszLKMTbzguu4Jal5phemUBBbRJSwAOagI4X3hhiTQNxHhZSvvKNtqpZgJpddh15RZlupGmgTb1rEibLCdlBveTr20i3kenqXr9ZvSx2A8oFAZuOwOvRCo6GzJpXkR2dis1o2cdlG/KaKhlAMy9AB22IKLruT0d0BqquQ4WNzMFhfw4dEw/4xy+3HoFOsn2hav6iRI2bxBIInM3MGbGLPCe9gXuSurl4xmdLKeKCIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vWM3q3R1Y8E6SXV9dJvf6zSZ3NqhIdokyA4glzZABBk=;
 b=I3dhJlgHtuAAdm1EGAuJ5HkSSDT2pkI2XzdncFcIVgT2p6cT4kTzrP/N/UKrim6HvztTs6dWU+ZLVPa+2/Wat5wZ12GLenReRMxeUnIE6VL8JARYbV23A1uWZUqFTnEeJy6Yty1Lhw/L27CZ5ZjyA40HrUCItftyGjhG+jaFdBu5c/ogBXlzEIj8pFm52OJgFKOH9ID/ovhj7ZLgNOs9vhmyF8MC0n/ge+ag671Rwri8vOdLjsgtrKpHnd3qhf1JaTAlS+9KAz6TxtgenzIQ5etmLgVKnOXVyXVLmj6hrMtSwVn7H1sCebn4KgtqpyJOegQ6DoP3dlXJerh5tPOffg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM6PR03MB5621.eurprd03.prod.outlook.com (2603:10a6:20b:f6::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Thu, 18 Aug
 2022 16:17:40 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 18 Aug 2022
 16:17:39 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Camelia Groza <camelia.groza@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        Madalin Bucur <madalin.bucur@nxp.com>,
        linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [RESEND PATCH net-next v4 22/25] net: dpaa: Use mac_dev variable in dpaa_netdev_init
Date:   Thu, 18 Aug 2022 12:16:46 -0400
Message-Id: <20220818161649.2058728-23-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220818161649.2058728-1-sean.anderson@seco.com>
References: <20220818161649.2058728-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0009.namprd20.prod.outlook.com
 (2603:10b6:208:e8::22) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3cf7cc65-d8d6-4239-39bd-08da81352c02
X-MS-TrafficTypeDiagnostic: AM6PR03MB5621:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5imJ+SDGnq59zK0JbWrIpVmMCpS9UyD6sat+87NKXdqGCU1+7nTEczJefUfq4j9NVN/v7p9oeWdtxlvoIAtcR12W5TxP/vU5FI3jSWJb/4UEGdzIpZ4Z0+TgpqE/6bY2e8VgxCMv6EJUlKxEm5vqCNK9UtQKsFv4um6UR/g/fXz7HMFAgdgaop5iwyQ0mA/okBiSeYWH7kCvFC2ss/esAbCTD2Wcui5G9epFeHUcx/uINnnPLrIIcxAoO5UlZY9zGbeMwlauayC/AYusAjvvD/yHKii318tw8SGBr+cTO+9SOtQfUGYg81NxYuI/LfcFdNDnoLeo4jOC34mkwbNrgoDPK3aVzzJ/4P89/ioW4uMf41AybK9tHZrTo5yyjpPuqaEFlpNZtUGuNJ04SRI8Kr2vOqxyV2GkNNp0dcHCkobd4Cx1g7urZxtnDcI8s6oWbMrnZi4amUPwSSexR4YFouhnv2Mf+i/J/GibID94S9ysedZzNTOrmvQuuFKziox+AS/2mT63h+QDbm6kMxj6blutIjJ1wUxXD3hABgoy5xpS3YZCYR3F100jmux8yspd++WMEwsCEIVlFxv1RdZvtKY28cH1VezWNwfVtD9IrjrGJLVE0H68zZlEJ4Id6XWtjlph5lAOFQF5u+ZG/SnF16b7ziKSovORWfDaGHCzBjSp4OGG4196P9TK20YwK6HfdiIZnWrRNOX7EOtsvgq/eS/Woe8QtJkOQnJe9NT/zTLpkmO/caZClRciAacMHGBVCpFHGmIxfrL1X+c0g16KIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(346002)(396003)(376002)(39850400004)(41300700001)(316002)(478600001)(54906003)(38350700002)(5660300002)(38100700002)(6486002)(66946007)(7416002)(110136005)(66556008)(66476007)(8936002)(44832011)(8676002)(4326008)(2906002)(36756003)(6506007)(186003)(86362001)(107886003)(26005)(1076003)(6666004)(2616005)(52116002)(6512007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H852fQZ1FVziu8Dnzvu3L5QQtD7UZLkUO8FcZUH3wKed0mbdqVTi0EbW5VIj?=
 =?us-ascii?Q?3SRPG/Tzdr+iTHPX/6553/cXOBj6erhMS1qJBmFJyWWZjg3PtgJDNCPukp/j?=
 =?us-ascii?Q?SWeZf2tecRSMNexUPMpTq8aj2HZGJaq9+but8DzpG3A3Sn84JpTTy9TKw52m?=
 =?us-ascii?Q?71QoNCUKxFo1N4+9XxbR7f35qjs/PcMkiiKEUbyfGP1htAADoX8QXUeWfMD0?=
 =?us-ascii?Q?oOEsswki6b2pKrqwCK0/YxNBSaXh0A3Vkl7HRopOVBk9XA4xCbfqbK/2qPQY?=
 =?us-ascii?Q?9oKU3wYvNZM5yCJgDt0bZ9ned8Ntqwp9XXLywf/+gzDeAW1pccLCCqVaxw1y?=
 =?us-ascii?Q?whXRmS64OdQ7A2OT8JK+Tz/8fO1NtwVTkfW46ENNU4p1ida7165cya19A3iP?=
 =?us-ascii?Q?B3+h982X+mCM1ev7wq8A+ThSAZdljacIas8MqDTkEHYl0d4BJa5Za25C0A+x?=
 =?us-ascii?Q?pwWt+X9NTh7rZHekRpKevw357w6B1Ml99iA/aXUnNHTtqyYH2yeoggmQmDFz?=
 =?us-ascii?Q?oO1WfxgtQZkvTP1tuzOZ1USMrk1sKA9MfBekjNGpN7y6D11FDTlkDlznYD9C?=
 =?us-ascii?Q?HjLiKJgqGhjn4qUEuG6hlO2IZxe75eO9v74lGetyEXH6BAFP24CgMXfMF8wL?=
 =?us-ascii?Q?5IqJbDrR8FAWAhWwjTHy+I3A3ZkHhfteq3EOV2eJOaJAuIQ5m1xAVTQ9M+Ls?=
 =?us-ascii?Q?S7kr8rIBSFUOomyJUOsEAbqKDER+6o4UHOKPH2hZTdi5GG/oir7gcHSmyj5J?=
 =?us-ascii?Q?gwVDndGF5/GkhnA9cXvogWi5mnogOhZJ5MzDGV3vgNDfEKOoYmSOwL2yuthZ?=
 =?us-ascii?Q?ubTZwD/mW/AfV0NTNAo1+Vafh5OXWuMO8I5jgHL+CVtSgjU84AQD93/s4viM?=
 =?us-ascii?Q?rbFSJeEwymDuTN2OkNcqZGI+2MJqtkgtct+Ffv7BNnO+jnGzQcDLWG4TL9sK?=
 =?us-ascii?Q?LjG+NJspzQ+PWindMft34/l3zxg58ZWBRm5huiWcHEYxJ3Zf9rdEe+fDLN8I?=
 =?us-ascii?Q?wpU23ryEKBzF81nsbX4Ftf+OcfLDg/ZwOWrUBB48zTXpoztoa3gJoiaIbV7B?=
 =?us-ascii?Q?il1z0h+WevnmF4xM7xJihG4Tv9LBr2+p+QWzdkZnKYSb09RPFa770Ug1Tt4R?=
 =?us-ascii?Q?/RZKA5cT98CKhr35f5VMfvw298zagogT6/21YS0inXBFsy3jcnpO1Yr2j5HO?=
 =?us-ascii?Q?U2GH4SSyqfZmRaiiYrwHNA4uv9tdYHDlr9aGuoc6bYwWawa/p90uonqWxkzO?=
 =?us-ascii?Q?J4+KQFGLF8DPbxlYWjJoEFoeYWXjNiL6cY9QwWWUQmTA2gsPa4eAPxyHwEk1?=
 =?us-ascii?Q?2i1loDZRP4nH7YA5sNBml+OfPAlgRxrFxTVg6QmKM3X0/1sDcPbqodsAu9XS?=
 =?us-ascii?Q?CIeheOnZjdkNmiKEPIS2vle8bMKVNVO/6hN528IYJ3LVcyGP4Tc3TeBtGHJ0?=
 =?us-ascii?Q?9/4qA8Xwi2bhLdjtFKezPtremlzGJ/+lJ5WVAkHjxCT5akg7EnuQthF0QsnJ?=
 =?us-ascii?Q?ltXbiI9S+WcfR14vUOG6tKWmfcd+oZtQw+1yASbXTgPq0UtTVMvNOHNig4gZ?=
 =?us-ascii?Q?aFJf8TWQ95nFfgaIOd9Xar0sxp4BcWyOOCL/GFDLVwuidOLLLaWXwHKzanxS?=
 =?us-ascii?Q?8g=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cf7cc65-d8d6-4239-39bd-08da81352c02
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 16:17:39.9033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mvlNfKyKrpEn/+wsiaBp9C5e1F/bYuFLnXq29Nrw8dmfgfRecubEt6K7XPu6bcyw+ay6j6rwsVVLo84fWpeIkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB5621
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are several references to mac_dev in dpaa_netdev_init. Make things a
bit more concise by adding a local variable for it.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Acked-by: Camelia Groza <camelia.groza@nxp.com>
---

Changes in v4:
- Use mac_dev for calling change_addr

 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 0ea29f83d0e4..b0ebf2ff0d00 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -203,6 +203,7 @@ static int dpaa_netdev_init(struct net_device *net_dev,
 {
 	struct dpaa_priv *priv = netdev_priv(net_dev);
 	struct device *dev = net_dev->dev.parent;
+	struct mac_device *mac_dev = priv->mac_dev;
 	struct dpaa_percpu_priv *percpu_priv;
 	const u8 *mac_addr;
 	int i, err;
@@ -216,10 +217,10 @@ static int dpaa_netdev_init(struct net_device *net_dev,
 	}
 
 	net_dev->netdev_ops = dpaa_ops;
-	mac_addr = priv->mac_dev->addr;
+	mac_addr = mac_dev->addr;
 
-	net_dev->mem_start = (unsigned long)priv->mac_dev->vaddr;
-	net_dev->mem_end = (unsigned long)priv->mac_dev->vaddr_end;
+	net_dev->mem_start = (unsigned long)mac_dev->vaddr;
+	net_dev->mem_end = (unsigned long)mac_dev->vaddr_end;
 
 	net_dev->min_mtu = ETH_MIN_MTU;
 	net_dev->max_mtu = dpaa_get_max_mtu();
@@ -246,7 +247,7 @@ static int dpaa_netdev_init(struct net_device *net_dev,
 		eth_hw_addr_set(net_dev, mac_addr);
 	} else {
 		eth_hw_addr_random(net_dev);
-		err = priv->mac_dev->change_addr(priv->mac_dev->fman_mac,
+		err = mac_dev->change_addr(mac_dev->fman_mac,
 			(const enet_addr_t *)net_dev->dev_addr);
 		if (err) {
 			dev_err(dev, "Failed to set random MAC address\n");
-- 
2.35.1.1320.gc452695387.dirty

