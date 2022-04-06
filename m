Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60E8D4F68FE
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 20:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240571AbiDFSUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 14:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241573AbiDFST0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 14:19:26 -0400
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2091.outbound.protection.outlook.com [40.107.117.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C6EC0560;
        Wed,  6 Apr 2022 10:01:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hzwF1sei2REk72Br4iQHiVBEej/f9c1o6GmQU3uPDXLR6Q2janAATCVyzRW5mFBH49nSDUQT+ZbRAtVklatUfjzOqvp6mXpqq6kTNnZsLNYazKAVjmnbSMsd00kbM6U0kJETXQyveL7rKzIapXuR3TuHXjkFl9oCRm+BkrF67IA5oO9M0u4efPIYsc5p9j/+NJ9v6ss+q7KkkQmpNiFYMJxR9wLfKSETVEgqvsbBLMZPw5nQ24CB/n0wLhufo8CV5kUIYLaLOlh/Z5ecLGAMEVepOb+tJhFTl1VHPqWL2hzxB9+3RzReGu6IoHngeoQjW+RZ4jyqzKYQcaoyrJ/zBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VXb9X5yBGCE/Yv1MuBWWaiCSAPduSoTpjKKur/aLeSI=;
 b=lFnKwbFgwSQewCS8G72L4SkNNp40LLwKihN80L5uDNrG5OnCTLzehsHlSXRnewbYEPBbAYi6Zpt5OnqrYqGlkJB9LzCH3FO6UQz9AGoXrd7Klo6M3vfekb2pAOONixnuyR1AQG0H0OrVI+K6Ri2uCpF0L5l+fl5VHe8flsasQR2i/0CgCW095jzNvSa80OhPNB+/iLvuCntk/ozNYovsTepAySEuDKONp/BDDDaXVxm5QzQYDqZgNqbcm2PycKdVD1rFE1ls7LdhdXvVwolTANK/vC9Z/R6YdtW0BOHs17GABKl8zr616+jtvcXEvMOY3Gu5tOyLWgrNl3QJjSr+wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=quantatw.com; dmarc=pass action=none header.from=quantatw.com;
 dkim=pass header.d=quantatw.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=quantacorp.onmicrosoft.com; s=selector2-quantacorp-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VXb9X5yBGCE/Yv1MuBWWaiCSAPduSoTpjKKur/aLeSI=;
 b=TJ8uwOryV9SIN5c0U5xCMPT1DTJwE7OOun6mwI0xWRtL3MHDilGyxU5pTxEFp19AJcd48NksAuP2Lmb0iu9/MA/K8FoBd7caX7wqkRTGnBcby0doJML97U+TVHNbMxFDl7Pb8f4pm1pYCOl0ab5QeW42jLBcg7yR+nH6y7/x40I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=quantatw.com;
Received: from HK0PR04MB3282.apcprd04.prod.outlook.com (2603:1096:203:89::17)
 by PUZPR04MB5204.apcprd04.prod.outlook.com (2603:1096:301:bf::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.19; Wed, 6 Apr
 2022 17:01:21 +0000
Received: from HK0PR04MB3282.apcprd04.prod.outlook.com
 ([fe80::9c61:c8e7:d1ad:c65f]) by HK0PR04MB3282.apcprd04.prod.outlook.com
 ([fe80::9c61:c8e7:d1ad:c65f%6]) with mapi id 15.20.5123.031; Wed, 6 Apr 2022
 17:01:21 +0000
From:   Potin Lai <potin.lai@quantatw.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Joel Stanley <joel@jms.id.au>, Andrew Jeffery <andrew@aj.id.au>
Cc:     Patrick Williams <patrick@stwcx.xyz>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Potin Lai <potin.lai@quantatw.com>
Subject: [PATCH net-next RESEND v2 2/3] net: mdio: aspeed: Introduce read write function for c22 and c45
Date:   Thu,  7 Apr 2022 01:00:54 +0800
Message-Id: <20220406170055.28516-3-potin.lai@quantatw.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220406170055.28516-1-potin.lai@quantatw.com>
References: <20220406170055.28516-1-potin.lai@quantatw.com>
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0148.apcprd02.prod.outlook.com
 (2603:1096:202:16::32) To HK0PR04MB3282.apcprd04.prod.outlook.com
 (2603:1096:203:89::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87c61efc-83d8-4fa9-cd92-08da17ef12f5
X-MS-TrafficTypeDiagnostic: PUZPR04MB5204:EE_
X-Microsoft-Antispam-PRVS: <PUZPR04MB520473A11ABFAAB08F81A14C8EE79@PUZPR04MB5204.apcprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ren9hDA4e+8v7f5c1OE2OKwbg3NwkaFelHbtUJFF8B9TynWRID9Tl7H7vWc8FNtXa3LsTnipZQrddSzifdapBC3bliSN9yphRb3zxewOyRmW4Sn1QZ6p8N5ztLtCds4tFKiMVBoz+tjzGgW3PGMzRA5aXpjPgAqqF6hlnINBJGsBy3a59IX4ZQmcRHPiFNBPY4nrc3X0kugoxQ+FPO7iIVEmX07J4bnY7ibaIUKSMSjzfHpPIa2w7UuOOLHIPgC7QguAHUZGTzn97vS3cseWvlImpBIjh4MoNJpInFeFa/Hcb2H9QN/wEng0PCI9/XTH503WGbeGx0jKgbsUQD7t4X/xzETFUonxEs/HUv6d8+1hfNLx1Tcd67+A2FuZlvfAgk6KM/Sy3HXVO6P8SWayztNeMMPejiLHeSGb5bR1jkxU5pZNjlgLmTrVmeiWTkF12wewfclnanlSDnc2noP3qg2evC2i7Oht8I5A6dKlIZ68vCYCJAVUBT4Mro8A5Qj3recUXOlQEjXHrVk9LKVjuej7v7dE4ab6s0GDYv5b4go02BGFrXibKFtdBgo5lDIboNj2GFhSkf0Od9s6BkLjWx07HXS1SbuWKpxpdaWrLm1i00R0E/nC4cki7WyIP5x1Rf34imggiZKuT3+M9g/kG96l7vKAMBD8Dg4iQ9YeVZjtMXzxZtkclLAu9ARHmC94hDs0xEOERlFUkzb84/KZWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0PR04MB3282.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(5660300002)(38350700002)(26005)(7416002)(6512007)(36756003)(2906002)(6506007)(52116002)(186003)(508600001)(44832011)(38100700002)(6486002)(8936002)(110136005)(107886003)(4326008)(8676002)(66476007)(66556008)(1076003)(54906003)(66946007)(86362001)(2616005)(316002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ygTYtSb98gnQ5ZFsq4p4yDGD7JmFCZJVIQspdf9VG06jJ3Y/t2fYxXIvta2b?=
 =?us-ascii?Q?xRe+/g3Gx607loUHvzodKozBUq49irhYLQRSWJOLFWamui+DmbHr2hiBjpln?=
 =?us-ascii?Q?EKocgIWyHwuRzgh/F+evtU+OZoRKhpDk3a+hhDZAaqkLWlYakasaIM3FH1Wl?=
 =?us-ascii?Q?tpRkudCk0//LQrQaXNXgxYSBT9iLpXNb3z4akGKELCE7pIoR+33fS9xkt1c6?=
 =?us-ascii?Q?xYoI2PGoB3sUTkALWhU4cSnLp9ZiAAU4nesPH85XxMeUxp88RmVXO/ZVzCuZ?=
 =?us-ascii?Q?vDA+mNXms39gYwK3SaCnkvpN1P+2Pf/6boXbUJjYp5zfLM9wXyh4pzXDyPuU?=
 =?us-ascii?Q?oydtihoZ94YqhZaUQ41/e+qV5bU7odzJP0Bn4HNNHBCh3I6V60OcBDUZbW8S?=
 =?us-ascii?Q?kwuTvZdMsiFoiHB8XmpmeJEKIPdlZk9dmAP7qVidmx2fnwZdZwDBEfVARetB?=
 =?us-ascii?Q?rqros6YBjaDRXn3lEEVUu4CiSUKyMsQ+ItPUPlwvXnOOSpLHafuSu8/VkpOh?=
 =?us-ascii?Q?rdvXfUOvMJrOuCNFUqDdxbjnZKQMJj/EKnlWQBUC0X26rhOGaV8zqFhSzrl5?=
 =?us-ascii?Q?oP8zTLlan46wTo3VMguZMAfqHfUCm0qV1frPhA0jmZPjaDFLPkTwbPOBLKP/?=
 =?us-ascii?Q?wRBHZxVjvHkC3MdTE9d2tX0eOW6R+vPZRhuYrlUwU3ZYy4k1KGNxjbeSuc6Z?=
 =?us-ascii?Q?2TKMXKntmG6FpUWjAxkfSkFPxu6sos7RpnAOcIySEjedjxyiRSqowAVVdGvo?=
 =?us-ascii?Q?lIA4we8X5F+B1rWfHBnSC7ygMwg3T8SE4M4nJKlA2GrAb+Hyy3F/nNIv3CCe?=
 =?us-ascii?Q?VQCFkPTWI43//HsrzCqPALCbmznRXrvar9Gnp7jdylSrjtfLBEtCbYu5QyGU?=
 =?us-ascii?Q?8XE/XAnrQljHUhpDZNAkHuw8SfXxhVWtaXUDOpdTqZN/3Yc09h2sRSCS8ZCf?=
 =?us-ascii?Q?svKbdMKb+deWblD3ZiXSBb1ylxlqZ4Gw0DfxfmYTilubqKucjDUm0XqTLkoy?=
 =?us-ascii?Q?8IDC2iZIkt1t7UZFwv9Pxniwt23yNM3Pi8aLuGENsPM/xXUL5pmgLrIUr4Vy?=
 =?us-ascii?Q?hRq3o8W6nZkYHCVNEfFPyp6lBFV19ZiFM84Unj3xopWU9Snp6Klhinoa6LET?=
 =?us-ascii?Q?SeuwRwOwwMsJj9O3ILnjeGLm6FAnZoC9o8Xpew771PkD2PnflugajaAtkMCk?=
 =?us-ascii?Q?SZNJCoht2l5LP386yksYMNOJlKpsosOXtpLeo0JyOChm5pE90HrifR6Ghy4k?=
 =?us-ascii?Q?ZQWu+I0Kh7mjhqouE72vn9vtFBa3qEF8oHBJGKsujBXX7g6771XJh7+6K8JK?=
 =?us-ascii?Q?qXosR+c3/KpRKHn0+7hkn77DK0iGNX/NE2qboJwyjCei+UTH1sEdzHwWBBeE?=
 =?us-ascii?Q?5Y95F9uFARpHdzEyiLrWMDs0DOXiBpoYnpCOHRSLG7vYbVZSY9kZ6fVdPqRx?=
 =?us-ascii?Q?rBDR8hQrt1kBG0svcpNuIMyBnUjLz9BH2O3AihVHs+4yWFNWVBEMC0Okn9M9?=
 =?us-ascii?Q?QIMtdQNcIOHTpl//iMOjMK0OR+vzpGQaFUDJ+bKjks43eOk8a7biY5MA0qbE?=
 =?us-ascii?Q?Qh0viAS/5rOVeog0B9QNVzdXWwMArYYpJh7+Oc3G1PwmEpx150YbLXHgwzjq?=
 =?us-ascii?Q?3PccVXtsOUz5GrPYkNSSM8uqoljk3W6oBDWaM21UtvHBVfX7BwksZNRvQGOm?=
 =?us-ascii?Q?zxtUCyPdRczFG31hF6k1hJdICOz4DREgBVw83IQ8qaMJrF7SkFSLYtm/L50g?=
 =?us-ascii?Q?X9n5EXynt5hjMkTqnIVgg0pUL+M9DTI=3D?=
X-OriginatorOrg: quantatw.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87c61efc-83d8-4fa9-cd92-08da17ef12f5
X-MS-Exchange-CrossTenant-AuthSource: HK0PR04MB3282.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 17:01:21.0317
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 179b0327-07fc-4973-ac73-8de7313561b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z+XSGwxLcGfphvXytfNwZ8I0oMq2F4MIh+Ef4eOYmW6Vhb2YBz9dq6m3Zav/T3UVXVN6SRbBLwRXeHFvS3YztQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR04MB5204
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add following additional functions to move out the implementation from
aspeed_mdio_read() and aspeed_mdio_write().

c22:
 - aspeed_mdio_read_c22()
 - aspeed_mdio_write_c22()

c45:
 - aspeed_mdio_read_c45()
 - aspeed_mdio_write_c45()

Signed-off-by: Potin Lai <potin.lai@quantatw.com>
---
 drivers/net/mdio/mdio-aspeed.c | 46 +++++++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 12 deletions(-)

diff --git a/drivers/net/mdio/mdio-aspeed.c b/drivers/net/mdio/mdio-aspeed.c
index f22be2f069e9..5becddb56117 100644
--- a/drivers/net/mdio/mdio-aspeed.c
+++ b/drivers/net/mdio/mdio-aspeed.c
@@ -79,17 +79,10 @@ static int aspeed_mdio_get_data(struct mii_bus *bus)
 	return FIELD_GET(ASPEED_MDIO_DATA_MIIRDATA, data);
 }
 
-static int aspeed_mdio_read(struct mii_bus *bus, int addr, int regnum)
+static int aspeed_mdio_read_c22(struct mii_bus *bus, int addr, int regnum)
 {
 	int rc;
 
-	dev_dbg(&bus->dev, "%s: addr: %d, regnum: %d\n", __func__, addr,
-		regnum);
-
-	/* Just clause 22 for the moment */
-	if (regnum & MII_ADDR_C45)
-		return -EOPNOTSUPP;
-
 	rc = aspeed_mdio_op(bus, ASPEED_MDIO_CTRL_ST_C22, MDIO_C22_OP_READ,
 			    addr, regnum, 0);
 	if (rc < 0)
@@ -98,17 +91,46 @@ static int aspeed_mdio_read(struct mii_bus *bus, int addr, int regnum)
 	return aspeed_mdio_get_data(bus);
 }
 
+static int aspeed_mdio_write_c22(struct mii_bus *bus, int addr, int regnum,
+				 u16 val)
+{
+	return aspeed_mdio_op(bus, ASPEED_MDIO_CTRL_ST_C22, MDIO_C22_OP_WRITE,
+			      addr, regnum, val);
+}
+
+static int aspeed_mdio_read_c45(struct mii_bus *bus, int addr, int regnum)
+{
+	/* TODO: add c45 support */
+	return -EOPNOTSUPP;
+}
+
+static int aspeed_mdio_write_c45(struct mii_bus *bus, int addr, int regnum,
+				 u16 val)
+{
+	/* TODO: add c45 support */
+	return -EOPNOTSUPP;
+}
+
+static int aspeed_mdio_read(struct mii_bus *bus, int addr, int regnum)
+{
+	dev_dbg(&bus->dev, "%s: addr: %d, regnum: %d\n", __func__, addr,
+		regnum);
+
+	if (regnum & MII_ADDR_C45)
+		return aspeed_mdio_read_c45(bus, addr, regnum);
+
+	return aspeed_mdio_read_c22(bus, addr, regnum);
+}
+
 static int aspeed_mdio_write(struct mii_bus *bus, int addr, int regnum, u16 val)
 {
 	dev_dbg(&bus->dev, "%s: addr: %d, regnum: %d, val: 0x%x\n",
 		__func__, addr, regnum, val);
 
-	/* Just clause 22 for the moment */
 	if (regnum & MII_ADDR_C45)
-		return -EOPNOTSUPP;
+		return aspeed_mdio_write_c45(bus, addr, regnum, val);
 
-	return aspeed_mdio_op(bus, ASPEED_MDIO_CTRL_ST_C22, MDIO_C22_OP_WRITE,
-			      addr, regnum, val);
+	return aspeed_mdio_write_c22(bus, addr, regnum, val);
 }
 
 static int aspeed_mdio_probe(struct platform_device *pdev)
-- 
2.17.1

