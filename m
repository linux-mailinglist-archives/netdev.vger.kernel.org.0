Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA40598949
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345025AbiHRQqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345011AbiHRQqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:46:34 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2080.outbound.protection.outlook.com [40.107.22.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC7AABA9DE;
        Thu, 18 Aug 2022 09:46:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PjdEQ34tdwnG5onkP30aL2wLII+BTi0c/hI7pYYv+SWLQmbPo3KeMmz4faNR4Psxme+64S2mdSz0ODF4W6V1SpvbWYWNegDA7u0IOkFFlUmcwt1g+rrMiSa6P9bvag3thhn+OtiDJ8CR7VXh8bbyIA96nJht7cD2JiDzboeTEyweG7qYdx8vdx+YjsIsFLZDfgn/S0md6RPx82i8rWDWmnfZbZwPpn+BPsueSWbrGy8KkZqRgva1MuyRWXIrolbGuT5KiHRr6iXw10xJjjwC/2s3KwNdzClVyrnkisvzlJEHwAmr20TWaEDxolTQ/7kELKzEiEw5kRcNQteyQq0DeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zVN3RE4YPj3naLmLY7q0GTywVhKdcECxcsV/A7K37bA=;
 b=BTFK22EarPDhFmFtB+IhmOCtmIN0b2OhMysLLZh1tSRAjVRaYHyGyLbTWqgl06BUVB04P+23Hz4pN0xe5FRzR8LBESpKKDu/38QOMrnIWygvcv6rv8KhVRSrFjJOqqXAioVAMukY/CZMO2WkENeCI8DihAL61jMnT1aZYHYaBm+/GL9M/CVSyy/63v2pHL2RLrd+F6/LC9pSYQbRJdmcsfupzTbaUyIkKxK8RqJrojPd0K97oOaaFYixV6dn5ZdUwTebMhTftn5cpZ0q46jBVp9EKgY5lI/mGtC8gVf1f1O4GA+y3uYuvxkO0nSeHho8KUYM/nAAPVPP2t9VpnKMmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zVN3RE4YPj3naLmLY7q0GTywVhKdcECxcsV/A7K37bA=;
 b=Bn1JPU31xguUUJ1jNBRCLe6UwSxzg2FTuzTaOZg/3K35/5Q0pZpRB/o0YJ/ocTi3Zy2fKk9lg4YQr1B0GVk0ddmiEJP3tM2NqxZpz37aH0LfnLlXJmbtqIP1pTztyvHHaXoUa4/8J7g+DKsXFMmyL2YujdXKyDFtkuctMFrv0MT8LC48BjHaAdbiEMR2czM4Pko79nzpSNzszYAu6q+WAY9nDn3Q/dZ7QS44UccrwRtAHovG1i1vuQQyUHU7AuP/psmT5JVCEDoxLbGl7K/cY4wH3q680mGKAhP+09HC5hzFFQQs8KA/aDk3VMmp6sylCE3xzNediY2bgpSJaU/u8A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PAXPR03MB7649.eurprd03.prod.outlook.com (2603:10a6:102:1dc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 16:46:28 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 18 Aug 2022
 16:46:28 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v4 01/10] net: phy: Add 1000BASE-KX interface mode
Date:   Thu, 18 Aug 2022 12:46:07 -0400
Message-Id: <20220818164616.2064242-2-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220818164616.2064242-1-sean.anderson@seco.com>
References: <20220818164616.2064242-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR07CA0019.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::29) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e660a573-aafd-4c40-e714-08da8139322b
X-MS-TrafficTypeDiagnostic: PAXPR03MB7649:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aGM+Q5bQWKOXa/A9EBTTkz1TdpLClNKIcrEYQgxDdxnEFarzVAsGec8yQCFE3cl6NWnBRL+EZ3V5MKVvw8yOXlBM9Ro7Md4LrkufZo7+SYnRNO1O28CrWD+oUUsX+3AIB1z750KTauHtmu8w6ytVbtigYws8gUblx4Y1UQx+FfFSWshOR2EBNFPnehx1qV9Zlgxyztp5artFe15KehZsb8uKfku2rVFxp9JPq+dt+LknwwkgvwYUB1Bb3p13Ive8Ef1uvvyT1y3MPGxWeQX5RLikUYy5X9QnSqoDoS4Knx5d53FaQYY2izyA7wqsvegTg2gPxb2R2Lp26qjPa80rrFdDL4juQ6gE8pyxOLEWnwSvEv3hLuhzEVvdtX6diIODdcixX5kasaC2XyY8VI+IGN0zO+GMWEb584VgI/RHWg3U3WdCcVo7yDxeXPQNJkehKZUXSGbT1ONZrANXOgIg+pLDf/wU3nHah/yfI6SHlWsp1avlNTXuSvaFe8E+1Mq7RKN9F4pp+ssarx0uoq3ummKCivHCaXF0LxT/acaUGYPyEGOj4aWQgXzFizMWGlMJ/YUVnv83LVt1+EmmauqkC2lpFZ7I3LwIyNWjhyNyEn1AIo6J83lMAEk7G+09nYDGg9RAEK3gwBiBqVbWoGSckVfozGaUoR85JhWyJ/4SIS7kUiQFxFaY0+NcMCW/QbWXLIYYgP5iscwmRFSdT2SpFrTUvn8gRnUqvfmQF+nilSEGqe5aSkWku+UMs4PPajXt5bEXlyaiF2oUawx/2rZCJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(396003)(346002)(376002)(366004)(136003)(66476007)(66946007)(478600001)(66556008)(6486002)(8676002)(2906002)(41300700001)(107886003)(6512007)(86362001)(52116002)(4326008)(6666004)(186003)(1076003)(2616005)(7416002)(44832011)(5660300002)(26005)(8936002)(36756003)(54906003)(110136005)(6506007)(38350700002)(38100700002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jwek7Gp9/Nah0bJmzNV2XRL23CTD+/vS2CCWmmBegimQtcn7he62al/02VGq?=
 =?us-ascii?Q?7SqOUTyBOMLusNSuErzFh7jFzQPVtGP1a8UpzqsqNhyxFNV0HvygSt0WcIBs?=
 =?us-ascii?Q?bAtCX1C9/1tSOeXtqJHYioh9fWsQQKWYt28f5b94B+2wroK8TaYsPm+qy6eH?=
 =?us-ascii?Q?Zj3nHIQmtBArA4e6DrjhpCTXSsNiAg1MpPeCHlJVuGup0KM5DklVrtY4mQz+?=
 =?us-ascii?Q?nVb/SV9Mp9tF8RynqyMst3IZF6iVuyewrccYdjOhkiVlYBiN4c9GTyK8OOi0?=
 =?us-ascii?Q?6e5s8BjwFJFkKB2piOyVQCyxUwvFDurMiqX+FUl57zmp9amE5VKsWim83+QA?=
 =?us-ascii?Q?ZjE1YlNhJqBzkeu2PYsRwLTARVasEJOsnZ8W9YAQy/XqZVL0xBglioHHIZE8?=
 =?us-ascii?Q?+yeOGcu5BfUKo8TeYy96Sf1+sVhXgw0+a0gxdsoaAGsxxk8xlgcrARzwixnF?=
 =?us-ascii?Q?ENFXV+Mh6AbBCbCIcyBHQEjuoSmxgQ6GYL4NyDHHwWQ0xO2SIRrnzJYYBhUp?=
 =?us-ascii?Q?WC9bPXDPaeOsWotANimo6l7J2o9mFxTAodP/E0RmUrjJlcNaNzJ2+ljFhkyX?=
 =?us-ascii?Q?G9jC+VKGw6myKawQMoH1TiQabCBaEoHaA6OT0MfyZttMH9fOWh8nJUIgkTDT?=
 =?us-ascii?Q?Qskb9Goslcwub0RvIpSPcejySLbt1m7jjWaXSZN0Av8viY+q8heDGVNtOrVm?=
 =?us-ascii?Q?vgZ7r+WVU41hM1wDtrvaPaRAwRTatA0ui2UsZsb6L6rX+It1Rks4z/xB7hAv?=
 =?us-ascii?Q?QxqmLUQlnuvNcyxpbkQKi9l298IeSKctf8jDk4kTkRDy8WG4upPUumz6uCGr?=
 =?us-ascii?Q?nJPb6SX526AWHG6fzJIJ3Qba5EDJAS8E6PINyfWROPO3vtA5w762pufkPtks?=
 =?us-ascii?Q?A4TukWiKMDoNOy/3/QVKsTZIJVjt4PS4KWMtBBtfWnZV5/b+JBAmGMDn9Hi1?=
 =?us-ascii?Q?Ef8NNLVXg5mtusXO7B5kO00FO75AE+pjp47iWkst+HHUF+neCTON11Ckr3Zb?=
 =?us-ascii?Q?eiMq6myCEZg1j/RPaHtIYVU4CG2bnK7avtYFnXN97Eu6B0E3AU1yLqbxawqU?=
 =?us-ascii?Q?/F2r+Xw7+8Z8B8ScDZssGK8rUTfKxRbTjwX9Z+pNhcpfxEmPMvbRBk5gbmH2?=
 =?us-ascii?Q?VpWW/cL465ev93FzQ6eNnY2zwjm+nrM2nKeRhaDU5hOw92jB3HSaAKHSyrSQ?=
 =?us-ascii?Q?LGMWTafb6+5LZgB6dA0SYwNNrPVSXb8JpkWmA7bsEZCOIhfCLiwYoCK+fbdi?=
 =?us-ascii?Q?q2uNOLSwXoWnfR1VLxsf+5fyPUoVM47zs31ht6Ky8rglTR8FHBgT+brzkfj9?=
 =?us-ascii?Q?HZ+DQiNZVHutz9cnCRbtUuLk+yFrjyc0HITJop2U1Cao5VwYvmUPGQ3qmSlx?=
 =?us-ascii?Q?qI8eWL+fWJUWdW6MWnCtCKAJsTd/GSHufpi9PHpAQs4A3avWzyXV9S6I+eIa?=
 =?us-ascii?Q?mC9hJ69dx5wU3TD7CzNoKU30bO+A1DHRfCT8ZbQUQv39g6uLnVTk0y21ZWM+?=
 =?us-ascii?Q?ALWovXF5/x08GXArHJbQU4Jan3XG6SjsXBZlanGGzMf6DUtlDK6F/TB7wMm5?=
 =?us-ascii?Q?dpTsxziLQ0fGNAyEQqNp5QDEG5pHZWJ42o2VM3MZTRZgO5OSh8Zjs2xm6LVU?=
 =?us-ascii?Q?bw=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e660a573-aafd-4c40-e714-08da8139322b
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 16:46:28.2765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EYQeXiVS2Eu6UybFFaXy/f84wgoHc1tWbPc9wpUVzSgOeYoKMaa0uWwsYA3rzWG6/GpcZ1agPWuSEBHnt8d/GQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR03MB7649
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add 1000BASE-KX interface mode. This 1G backplane ethernet as described in
clause 70. Clause 73 autonegotiation is mandatory, and only full duplex
operation is supported.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v1)

 drivers/net/phy/phylink.c | 1 +
 include/linux/phy.h       | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 9bd69328dc4d..b08716fe22c1 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -344,6 +344,7 @@ void phylink_get_linkmodes(unsigned long *linkmodes, phy_interface_t interface,
 	case PHY_INTERFACE_MODE_1000BASEX:
 		caps |= MAC_1000HD;
 		fallthrough;
+	case PHY_INTERFACE_MODE_1000BASEKX:
 	case PHY_INTERFACE_MODE_TRGMII:
 		caps |= MAC_1000FD;
 		break;
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 87638c55d844..81ce76c3e799 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -115,6 +115,7 @@ extern const int phy_10gbit_features_array[1];
  * @PHY_INTERFACE_MODE_25GBASER: 25G BaseR
  * @PHY_INTERFACE_MODE_USXGMII:  Universal Serial 10GE MII
  * @PHY_INTERFACE_MODE_10GKR: 10GBASE-KR - with Clause 73 AN
+ * @PHY_INTERFACE_MODE_1000BASEKX: 1000Base-KX - with Clause 73 AN
  * @PHY_INTERFACE_MODE_MAX: Book keeping
  *
  * Describes the interface between the MAC and PHY.
@@ -152,6 +153,7 @@ typedef enum {
 	PHY_INTERFACE_MODE_USXGMII,
 	/* 10GBASE-KR - with Clause 73 AN */
 	PHY_INTERFACE_MODE_10GKR,
+	PHY_INTERFACE_MODE_1000BASEKX,
 	PHY_INTERFACE_MODE_MAX,
 } phy_interface_t;
 
@@ -249,6 +251,8 @@ static inline const char *phy_modes(phy_interface_t interface)
 		return "trgmii";
 	case PHY_INTERFACE_MODE_1000BASEX:
 		return "1000base-x";
+	case PHY_INTERFACE_MODE_1000BASEKX:
+		return "1000base-kx";
 	case PHY_INTERFACE_MODE_2500BASEX:
 		return "2500base-x";
 	case PHY_INTERFACE_MODE_5GBASER:
-- 
2.35.1.1320.gc452695387.dirty

