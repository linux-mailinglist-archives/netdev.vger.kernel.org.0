Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEF1F62C139
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 15:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233299AbiKPOoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 09:44:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233132AbiKPOn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 09:43:59 -0500
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C7793F071;
        Wed, 16 Nov 2022 06:43:56 -0800 (PST)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AGC2iqk004595;
        Wed, 16 Nov 2022 14:43:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=CzwstQNtn4atjVSRVM5JAP2bytjugRovtqE0xBOj9pY=;
 b=lFvqtzpxRrJDFqbfnUWPd2JkBOp+dFdoRoqNAcXZF0hUSreTgxo9S5zf5VMti8Lv3jZC
 nobX0TaGBSJvEKQp+yZuKrDP1xiOum5zfDvRgFn5USmB0y3KSGJdkHWL9AMez1Lij3bH
 yrp3bwFWpBIvG2ndIz2QYV/xfo+ofU9IHsayMjQsEVvUgvveU7o+teHeq8pEjxP7DhEH
 9YI6mqBYI+iTbvYW7/ZpdIUpkgJ5eIE2wZW3bU3HLWyvgnp7il7jAhLAzPrpwPED2y0Y
 0PiXXwn8elpGf//thSM0ao6dwFu35XwdlJjvN6+Jf8AaMOwpOubDt3BRsCKwhJso0emK IQ== 
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2042.outbound.protection.outlook.com [104.47.74.42])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3kv75cs6yh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Nov 2022 14:43:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F8w0dvg+F6A15ufpLQZLNoNNX+7KsaESlPpHKs2ET56FuJRz/sd1xuXBkeotuGpHTt7tDMt9sIlbA46GGgonomLcP4v0+ttfhsP/xyDiWbXPB4La0olSQuOfiKBx1Xwi7Fsh1EkEnNHkQy2ZeZg8dcOUwlZ23/6bTqN572EACghp3XmDelVKCIuNKNZVt8S9X+GcvZMkfbxa2slGHJ89dec4G/+HlG5gADTBaHYfOc/MqkzIBOBdgVS+1irzJBUdisuaxq91YJSq8q/MPggfxZ2X5zt5Dj1R1Pnmg+GqPHea/5fLm56mlYjP4M1F+UP2hitTBq8lqlGpsfYiWNMNfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CzwstQNtn4atjVSRVM5JAP2bytjugRovtqE0xBOj9pY=;
 b=iVZd46qTc0aAVQeFnqTSf6mYei0MGjdy1Qm2MHvjEYUTIRwULMpckj/iWz42+QqzhFR0+meQBOVHvlpu02snOeFsjIGs9FBBnswClDtYzDnTL08w512bpBRfe411G/iE3P8cnpXwCBzisK6MGVAxK5mbgy92IXWAHQ300gFAeJCz+gez+kfR49W9vtDl65u5wPl18dN3dAiS+ROPui0uHhmVQbW9kc8Ap2gj1nw5PjJUJEyecK7hqTYA4ayoSMPoQyjwKFKhmojHpaCv9cD95/NiNFKH1JdW5OSooXDSjgRsBmWjKA5301YqOs1fUslzylAwGqoq0KODxbpFr5SLxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from MW5PR11MB5764.namprd11.prod.outlook.com (2603:10b6:303:197::8)
 by PH8PR11MB6927.namprd11.prod.outlook.com (2603:10b6:510:225::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Wed, 16 Nov
 2022 14:43:28 +0000
Received: from MW5PR11MB5764.namprd11.prod.outlook.com
 ([fe80::d789:b673:44d7:b9b2]) by MW5PR11MB5764.namprd11.prod.outlook.com
 ([fe80::d789:b673:44d7:b9b2%5]) with mapi id 15.20.5813.018; Wed, 16 Nov 2022
 14:43:28 +0000
From:   Xiaolei Wang <xiaolei.wang@windriver.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] net: phy: Add link between phy dev and mac dev
Date:   Wed, 16 Nov 2022 22:43:04 +0800
Message-Id: <20221116144305.2317573-2-xiaolei.wang@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221116144305.2317573-1-xiaolei.wang@windriver.com>
References: <20221116144305.2317573-1-xiaolei.wang@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SL2P216CA0216.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:18::11) To MW5PR11MB5764.namprd11.prod.outlook.com
 (2603:10b6:303:197::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW5PR11MB5764:EE_|PH8PR11MB6927:EE_
X-MS-Office365-Filtering-Correlation-Id: cbb79cd4-bd57-48ee-254f-08dac7e0ec58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o3NdMB1Jm9R9/9sWcFwxPbuRwkugzOKKIdiMNobinP34rf8cdpkMxIlpwVUwRH5vwbSdHn5ttvU5En1oCvoAEloEcf3+ueZWQ+aY56Tm+aWodRtRVvEoQcVpWWY/wy3FxcaSoXvKULBY9tnE6FI9BYi8ubEC8VVp53RcJ67kT3jM1TsUbUvM0QEvqWMTa1iRXunEwzDtxmFFIeOkzanFAG5bydIsJ2vnF2tJ0T9QxBPBcrXBZBmb88xwTTg7PSMAF1tKb3Vi47AN+qH3mWpwWnGseH98DOqrlgZ4AIPjKJ8035OS44V0zuvudDcX9pSPB9RyW//hCcvRrSDnZ7NwHXKuEjbTw0Qw3BOKSOkQLWPEYErrWQNnptWb2zV1P7ezcju22JMSoXyXrRgDyYbgCfMTthWtHllWsnETDGeAzlg2MwV8RnTWyKtozh+uxR2ucW5LQRcPUhMeq67ZO2fbxoMX3ZN1jHgNWZVQZ6zOmt8GZqd+HSBBEWZ9gRKqg+5cIhrmeGSccS8X5v2mRHiuFrgXWmFZS6uM3CPAA4Ujfe0pEHkEAQKYuAPy4CERpYWk7UWHO5ODVNBUJuZJ6vuReKZw95SPhy3apHEZn95TjVmIFn4aOmtGKcBPkPRvsoyzBH6Ogdf3WYUAugR2gRu9ajb/zgWGVeq1tXyE16Lhtq7sL63JPNdE7vB6H/NmjTsX1dylv1vU3P63rhmd8IbfXBj9NT9mqyywtsYo7zzNePtYABwnQc8Js08yT858peEJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5764.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39850400004)(376002)(366004)(346002)(136003)(396003)(451199015)(38350700002)(186003)(2616005)(1076003)(38100700002)(2906002)(8936002)(52116002)(44832011)(6486002)(6666004)(6506007)(26005)(5660300002)(66556008)(66476007)(41300700001)(8676002)(6512007)(66946007)(4326008)(478600001)(316002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nYnKk6ZiMUUPk7H/UT9LXpC9dxMgat6toErn86vW9oYXqFd9ZwlVYuuR4uqb?=
 =?us-ascii?Q?MPza8oCt8hnAL2TPL81ed+hv4T5m6q4CMds9UvlColgpJF2ennMROKMCgClq?=
 =?us-ascii?Q?oQItfI7Jfj2YPnhGTdXpKvKPV2mkOhgrZXXRAus6miVN66YOMdBEi7xVDfIf?=
 =?us-ascii?Q?JOC5B3ciIBsdwhd2yTCEmjb+LN1ev4fhVKizx8yFe8JWvorDKrFbxB444E2q?=
 =?us-ascii?Q?MUU1LmAC6ABYLZUBx3vIRIj7JDEB/GXO+PICsuswJfZVKns4mqSOABmS8dDl?=
 =?us-ascii?Q?6aZ6iFdhNyf6aA0ePvE1K5xAt10KaYjZiaEYAk3YmlQWkXif5dMa03JqbuRE?=
 =?us-ascii?Q?/xxm83PBBM1WsWxnXn4n4C93dSgHFmYmVRWgxHgc12mkAG0CSYSdL9cmNxzI?=
 =?us-ascii?Q?NarZmgcKdGUZQ2RnsRPVNd2160Wa7cKkzgSg0xRlBA4HLIalPlOomEQBA72N?=
 =?us-ascii?Q?JZ3o+fopxfzUz1BEE0omryYOtUIlA/KNu3vT94eulaIpamO+8JOCNsqNOcUx?=
 =?us-ascii?Q?mLN0NG6X3Cz+9RVFAPBCX/WRyIMVTgDvNmJuWKDvIZCzZlooI6iBGT7nr+O6?=
 =?us-ascii?Q?2TeQl8r7Af/2yvrgaYS/VlnMKeAERe0DsV4V9Orn50zL+Z6vEgOsQFGFtH1C?=
 =?us-ascii?Q?lP3aV1ACXOTa6pGC14Xk1O11a+xwAAgwVIKzcUmw6l9yeEgOY7fWikWEBD0y?=
 =?us-ascii?Q?BOlxU5su5fco2csIBdYVhgwAhrR/SopzXbYiA9mhRPpG1DyflFJsPha91Kpl?=
 =?us-ascii?Q?/8+fjNYL/er1Xa/o+0nvXoBNN+S/GOqvGfQ7khGdxYw/vomnVXsbHszwZ+Hf?=
 =?us-ascii?Q?o5QGPpBUzvDrF2gMWZUlkaFILMTIdV6c8PonXg0Ku3RFDPNJDXcju5LeCQU/?=
 =?us-ascii?Q?g/x1Oa7Zl9MFr2YwEUtkgRRYPGu6SGgKEKhv1Sh/pA1+3lf+tl1pJyNiIndQ?=
 =?us-ascii?Q?ggrpZr/WFLrTVtdRS0I3pK6K4kP/RGD3f9HuTKLbJfLL1JzVzlAKAmH7vwtW?=
 =?us-ascii?Q?5WGgr0BrCvsK2Qls27ISPOmTJiT9GPGTbyTxznhpDvrMc0YTEXWAXGrwLpLq?=
 =?us-ascii?Q?A5vuT6bvBqpqvWZpJACTNseIu/buuJbp4Geo7/izowdCfTPmacWe1F7o7Oq2?=
 =?us-ascii?Q?q7U6pqb4JbN97NP3BdMMmLwWS3nmC4n/x1/JEBefznNBoYfd9iNz1vWgnwqc?=
 =?us-ascii?Q?ouGo9abpzNJNbFgBRSZvUDOJ8Tid6Ot1VHi/CkscOMso72TVBzOWg4keqwm3?=
 =?us-ascii?Q?2j6eZz0nFRVcDYXCHyxIWna77gwkwzBJ+a3oPlM0xrB3XdISfDntR5zcV3vY?=
 =?us-ascii?Q?BBeLnGxTanLSpVUwc1TkSpr4J4VK10Nq/bExQXtRPH4iJZNnGgelZ3BfFBrb?=
 =?us-ascii?Q?ZMq0rOqsS4JXWyFVroiM+ADWl6jSbfO2laBLECIRa5vLkOIjD/i7OE+Z9L9a?=
 =?us-ascii?Q?ap6qaHH+6wRLly7ecXQsGocpHdnMhImAjCGDXFkqgV6nJGu3j6EuIV0od6jt?=
 =?us-ascii?Q?z2U8i65/7IKtDAVwY7yn2PvqJ6nYHJWLon6uWp1TRNnQJts8NzxaiCoyikJv?=
 =?us-ascii?Q?wjNlo+aR1U8iYUQ6VkLke7j0P/b8lhKo6Igwg4dZlwBp21YEIMNvFtbef44A?=
 =?us-ascii?Q?jg=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbb79cd4-bd57-48ee-254f-08dac7e0ec58
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5764.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 14:43:28.0011
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I37u1XfuubSZASrmpoIXemtHu+7sIf7ScSIOSR5CQfRaONZ8Cz3cKutXNP61d1mfsZP0HypBQc6CrsJqPVQiYPCLSqHbQfmqgw8N0hFh0n4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6927
X-Proofpoint-GUID: 9vRy97bLMSsbe7arUNuI7b4KOs6mk60g
X-Proofpoint-ORIG-GUID: 9vRy97bLMSsbe7arUNuI7b4KOs6mk60g
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-16_03,2022-11-16_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=910 clxscore=1015 adultscore=0 bulkscore=0 spamscore=0
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2211160102
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The external phy used by current mac interface
is managed by another mac interface, so we should
create a device link between phy dev and mac dev.

Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
---
 drivers/net/phy/phy.c | 20 ++++++++++++++++++++
 include/linux/phy.h   |  1 +
 2 files changed, 21 insertions(+)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index e741d8aebffe..0ef6b69026c7 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -35,6 +35,7 @@
 #include <net/netlink.h>
 #include <net/genetlink.h>
 #include <net/sock.h>
+#include <linux/of_mdio.h>
 
 #define PHY_STATE_TIME	HZ
 
@@ -1535,3 +1536,22 @@ int phy_ethtool_nway_reset(struct net_device *ndev)
 	return phy_restart_aneg(phydev);
 }
 EXPORT_SYMBOL(phy_ethtool_nway_reset);
+
+/**
+ * The external phy used by current mac interface is managed by
+ * another mac interface, so we should create a device link between
+ * phy dev and mac dev.
+ */
+void phy_mac_link_add(struct device_node *phy_np, struct net_device *ndev)
+{
+	struct phy_device *phy_dev = of_phy_find_device(phy_np);
+	struct device *dev = phy_dev ? &phy_dev->mdio.dev : NULL;
+
+	if (dev && ndev->dev.parent != dev)
+		device_link_add(ndev->dev.parent, dev,
+				DL_FLAG_PM_RUNTIME);
+
+	if (phy_dev)
+		put_device(&phy_dev->mdio.dev);
+}
+EXPORT_SYMBOL(phy_mac_link_add);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index ddf66198f751..11cdfbd81153 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1758,6 +1758,7 @@ int phy_package_join(struct phy_device *phydev, int addr, size_t priv_size);
 void phy_package_leave(struct phy_device *phydev);
 int devm_phy_package_join(struct device *dev, struct phy_device *phydev,
 			  int addr, size_t priv_size);
+void phy_mac_link_add(struct device_node *phy_np, struct net_device *ndev);
 
 #if IS_ENABLED(CONFIG_PHYLIB)
 int __init mdio_bus_init(void);
-- 
2.25.1

