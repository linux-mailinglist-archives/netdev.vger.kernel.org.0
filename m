Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E01044FF4D5
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 12:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233670AbiDMKhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 06:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234943AbiDMKhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 06:37:18 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10066.outbound.protection.outlook.com [40.107.1.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B4CD275F5;
        Wed, 13 Apr 2022 03:34:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gyHfjpI6SApSVmqmfoS8ZK0v909r1803Ywi2em2pATE4/rbXVxFLlJIcxNWkaUEkRm9HCkrmqxo+TUpKTjovo1TtW9JLPd1qwQfueEvfwrX9XfaBJwj0pi2Yp6Lm7AIZ5uUju9z8l/+B3vMlzI0tsHSPgcESs9STWI/Ka5UBq2wUBSjpMe7I6OwXwhVMxFdhFcgWK7iY3nVCsR0og6+F6a8pMEc3+6pE3xC8YoDDM/YI/wu66+tFljY8z2TaYtWRQelLNxudjtbjH21VnzW9m8D1KwNGZHI6T8PUzk2RvHEodCyAEtrnLaBiBT64isfY9PM+syoXNFr6XxgbWKsAJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FXSk0OYbXNrgCIS2Uqv1VLVAJ3Z0mn/5l33sZlMWuNA=;
 b=Te4vI5gSXERKQC/vJfam1oNMLpZ3elqlAAtLSW2IiNCDohSybSbbTpHL656Y+kvk4LsuUICaYd5XmuTw6hVT8YSHBL0NWrgxz/c9M9MH1YfXPQ0cWnJnTOS24zRUEqE2FXuZfzYEwiNAV4Nnxqml8g4QHcS7H2zpKQlW8lC4QtmjkV3mMSJ0YYlvTiwIfxqg0hNllDV/lDuZXE8/hMcgAL9/7jK1lFYEr4s3RqEHuRnT6TVY6ZMZAjvtENyTpObJ9kAxhtTegP96F/G/8UOVTTe4liaiN4eALR9i1rrstTuehURS4L52zyiwG2PhQ0PqAjUuzUMmk9inwEEwuVmY1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FXSk0OYbXNrgCIS2Uqv1VLVAJ3Z0mn/5l33sZlMWuNA=;
 b=adsKazxxShU/JdXcX+Sb7Az1n7CkSn66YMf5SDiRORidlPREJKkJEdbWyEUKsl1KYcJHHA9lUhCC3Al3Sncn/gLaVIlomovkYMvq4L4hdls2ExphLI/IXt64zPsasvXAVJk0drWUW8bebtpaeVBuEYbpNJOdhGcy76asPyiPoig=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by AM0PR04MB4082.eurprd04.prod.outlook.com (2603:10a6:208:59::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Wed, 13 Apr
 2022 10:34:51 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5144.029; Wed, 13 Apr 2022
 10:34:51 +0000
From:   Abel Vesa <abel.vesa@nxp.com>
To:     Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, <netdev@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v6 10/13] dt-bindings: net: fec: Add i.MX8DXL compatible string
Date:   Wed, 13 Apr 2022 13:33:53 +0300
Message-Id: <20220413103356.3433637-11-abel.vesa@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220413103356.3433637-1-abel.vesa@nxp.com>
References: <20220413103356.3433637-1-abel.vesa@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6PR04CA0047.eurprd04.prod.outlook.com
 (2603:10a6:20b:f0::24) To VI1PR04MB4688.eurprd04.prod.outlook.com
 (2603:10a6:803:6a::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a201949c-c2f5-4f31-4f75-08da1d393da1
X-MS-TrafficTypeDiagnostic: AM0PR04MB4082:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB40824FE50D3F519AEBF6C872F6EC9@AM0PR04MB4082.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SG9N+YqYZp1ZfHpHMzd+CsbFGSA4kFLZFEN5oWgdjByLekMshsjBYJT8dRU47JTigLYYkkgzjVOffZxgsVErZzx6YN50YFuH9saypHRaOeGe/lTHlSJQn5h5ME89vIyMZdDSJPxIMpxZc+GY/NSdYzFcR4WsDq28AQSEEwh93t5ANJH7Ngnasb0cxehmZQAY0M6HV5JqMIOqU7aEJWzSuF6sj+huDblLfCMMYsLZrrDC49zin1l1EuPqzGN8xI1E3RkK2ZiWKYZIOBwO1i/EJuNo1LiCFKf8HxvdDSj+fMrLccsS7QbQlmeI2zT64mMukPEhjWx0WVt6wc8DWZvnRa4XDdl+eK1SitjC+meoZlZbzfgu+W0yFITfnDrGs9Oe3Ax6sLGeBs/bGOrByVY8C+h5oSbby+lt/Kz5TDqTV68wW4TAqcuhpmhDA21XBl4lluIJ+YMDOxLKR/caOE9JtPXQjMUrnB9dIdFyOfTWl1ry7+KJoykrAk2v7pD1Ps7yy3cXw5w4DZ4Pdg4ugKnyXRAeNzwZeO4RGTuIKE6R3gO/SdrhUKXxp8ZQdxLhCnGXVBWSCveCR1R/cOVuxM/GF+MK2I/B558aK34b8ZQPh95Rg6DaR6P6JE762CWONd9bGKci7jxCraVmZo+5XNpu3Lu2ZthU85FBEOPpOt2M3ix8pPbS/0xWTauquMWm+2ANsm4kg8CXTazACZORDJU3Xg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(110136005)(38100700002)(54906003)(38350700002)(4326008)(1076003)(2616005)(2906002)(44832011)(186003)(4744005)(26005)(316002)(86362001)(66476007)(8676002)(66556008)(7416002)(52116002)(6506007)(8936002)(6512007)(36756003)(6486002)(5660300002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I2bueTqO4EiCOVZM5cnK84MbB2SrUJ/eRGZVHAu47Ee60bix9Ae6Krye2qsG?=
 =?us-ascii?Q?p73+1wz3wVbjbPPz8/DyvUVyHmbHI5MRUlwaB3IdCTIelsGvRP8y0YlJlhW8?=
 =?us-ascii?Q?vJA3SeZnqPEYuGT0K7DmBNJe+QSbuzz3HHAGRmWVQy26RN4Gh583O/PNXB+7?=
 =?us-ascii?Q?7Vp+sRr9ApO6kxEQXJ/QUN0JwAYN3atNPCxAqEY9XtqajB4zguxceBm/raKp?=
 =?us-ascii?Q?ggpd7SoiTW7S0UXvOpzG3Ep2AnXjkRByDXoeNg5TBttKNSWGQ3kQNoqY9D9o?=
 =?us-ascii?Q?EFQlrUuTH8ynUhyXNcag43shWiKE2rQTTAvaSEy/k0lPPeSIvPqJuZSGuv/H?=
 =?us-ascii?Q?JtbkVGdmwB5LiiZzjJTN4ogNa09q7eoaJHeNuL360NTmFOEp3svQPeSKW8YD?=
 =?us-ascii?Q?7GJg54eNgKlJVrUtnDW3lU2CGsrRge6Oon4t+wV3beHczf0KtGC7YXEVdlfk?=
 =?us-ascii?Q?aESHvLxdEBML/Wj6kBJ/JGuHTFOgPKdOQ1eDLVfh7vQysURc+ZigXxnZug4n?=
 =?us-ascii?Q?sXgI2S3DjhYyoegwIf4IFGBBIQWszKBY38WAGigmogH04rC1/9gYpkkLW8+Y?=
 =?us-ascii?Q?RNoFfY+mNTWBP51p5OibynhzuulBWUezUbuGr4HDj4/mDMSmxNMHeI3Ag0S/?=
 =?us-ascii?Q?2+ZCOfjCZwdMZTQ6o0KnA2KfG9I3zrFDGHzPzuCmzWJGe/o4f5280Dp2ISZH?=
 =?us-ascii?Q?RBoTUHMu6w6ItH5X3PXl+MDCZ0/0zG6KJbS5VxsAjPB24znI+jEz1bFDOz/0?=
 =?us-ascii?Q?fdza9ufny028HPC40BTtGfXKMwZbbTZbNePS57s5cc8FUWifvSi2hsqB0Esk?=
 =?us-ascii?Q?Xpme2v/RvIaGIh/OOJQmBffmClj0bg6G/PbJXnotpG+khnl4xP0CxzItyxd/?=
 =?us-ascii?Q?maVYSORWkJm+3FnYQAB9aqnQKcYncRFnfOuW3+iPHdeDTmBXTRZX/OO3Ie1g?=
 =?us-ascii?Q?2jk5DQSEBmlwldB13tQFDwLXM3jKU3qh9bc1bioeGxrgwbbWujmIi7dgG25z?=
 =?us-ascii?Q?xnZ8n6uyC+7SwF6DuEqZKg06b5CJtpZWqZKl+M8+c4XPPM+Oxft0B4eKuQ5A?=
 =?us-ascii?Q?EIhOVM+sW+k6EMYliMLRpoCSBjAFmDo4jbnCNgX7nIUw7NUrFul7am9DID6N?=
 =?us-ascii?Q?2y+TDr2rt4lKmUFWAmXvXONyQHREy/vi2DDp9gwX1kXaQxnBp2SA9I4NYEnQ?=
 =?us-ascii?Q?reegeTBE+tufdjjiYHoVqAMVpSs0fn4J+I72fzfAHiUzK3JFHpg91da3n0XA?=
 =?us-ascii?Q?yBmfmlgtnvY7meHjTNvJlflGTLROHDaki+50FFCgHYHuu3eZw366kjD4jzsw?=
 =?us-ascii?Q?Ws6pYiXOcqS1bt12wAlv2i7RFJtpoGaHGWfFh3LutJRzMNi/+q9e5xfvWea9?=
 =?us-ascii?Q?T++DquU6HCllLB9CZu3RzuGVoZekmwjw2rOV6VcEYK6d6tiEUzp/g7q9St1e?=
 =?us-ascii?Q?Q5hKsEcxwj2xZKctXw/QgReO0Dey17BAkcUjxI3yHFIQb9camxVFXJdfPyRj?=
 =?us-ascii?Q?qyrS2w2e9TRYvzOreG5zX1vR8ssPltXKy5q+rNfqtZ0bUPwBtLkqEc0qJ88T?=
 =?us-ascii?Q?bC1ku1GeuZDc/kE6rP5a9Ha7sa/pC02cP8TV0PFPw3lERMC50g5NtyLcmAnx?=
 =?us-ascii?Q?fJblDUEqKcGB7N1aLdwQ5y+Wz4tQ3FPJtMFrBMulOEAN7IwZNgueuKeeAyrv?=
 =?us-ascii?Q?7d+2ijx9Bm3HHA8kU03ixl1tlnOu/UUZX+2SSyoHla0h6cNKvIaXwlC3zA84?=
 =?us-ascii?Q?aPJxcVs6Sw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a201949c-c2f5-4f31-4f75-08da1d393da1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 10:34:51.2232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aAzvzeYWa1bCxZK6jVyzHLyWlNUwOlwGxfHfUsuLWIb3J0shOCLzlkO002d+huOV2hQKxnK/RfPR/WBJbmU6oQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4082
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the i.MX8DXL compatible string for FEC. It also uses
"fsl,imx8qm-fec".

Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
---
 Documentation/devicetree/bindings/net/fsl,fec.yaml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/fsl,fec.yaml b/Documentation/devicetree/bindings/net/fsl,fec.yaml
index daa2f79a294f..92654823f3dd 100644
--- a/Documentation/devicetree/bindings/net/fsl,fec.yaml
+++ b/Documentation/devicetree/bindings/net/fsl,fec.yaml
@@ -58,6 +58,10 @@ properties:
               - fsl,imx8qxp-fec
           - const: fsl,imx8qm-fec
           - const: fsl,imx6sx-fec
+      - items:
+          - enum:
+              - fsl,imx8dxl-fec
+          - const: fsl,imx8qm-fec
 
   reg:
     maxItems: 1
-- 
2.34.1

