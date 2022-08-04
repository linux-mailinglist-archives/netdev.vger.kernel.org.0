Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2BF58A18B
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 21:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240094AbiHDTtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 15:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240103AbiHDTtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 15:49:00 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130085.outbound.protection.outlook.com [40.107.13.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B2470E6D;
        Thu,  4 Aug 2022 12:48:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FPC7zdfOAtSfg5Yfhteu4pPWi4xBe1xleu7KfO08FVaAGEFlmixjITJqXJKtN+CIt2SUaFBUDOzFnhXBeLx+F65WYheL+pK2b6h1J+rowh1ZPXcMtr2EDcmK7z21mbm3A/caimN/a3rq2NAnH1ISmfqeEu1XAak+DmXxE2M9VxtOHtMrTxyb1ch6wALfId6jeo2aF+Qchs9Lr7jn4w74fw3SZIc5RvKgDyIq2TLnAl5YK6Dt4MLfB9yX2lX15gC7Jy8989csz2uS4DAjdvPskOhUIlfnOa8qRktbr6y0fSXEAL/UJWR/Y0cEBrAnt1pkXTZCXMhbkKdi2XdcZtWhAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U8mr+E5E/bquLjHtd3y1fs2FBigd04YzSdV1VetNIuY=;
 b=ff2vFqkJwPrfGWUg0/xvVqxjdJTGPEq9+hvjWSbYJ7iMFwggzA/YkffAIYxPKbmmzpgQs3Pios4PVUImapMa/ED96UszJ10GF4qH77UKVnxqogWGSfH3TRZVfhed61f72ht8p45pP9ij/tW+VnOGuvpuj7Q26P4LMxgKQzjd+Poirmnivd/sCMSE+cLxtwJ/DZ1yYQhgOt8b6ok/R05fObykcNtC2amnfSGlFtyYS2/K9bRv6MX11tv25WBvT63ZPXJA8JMPDeI5ZbkcvkRZA6u2N8i4SVZx1rEyLP4qyQUU/iKTskezgSsdMbasUKFttFDT4J1S5B2V8o8lmTXCMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U8mr+E5E/bquLjHtd3y1fs2FBigd04YzSdV1VetNIuY=;
 b=0WGV3TG/H2yH/+mjsWnrzl5jJQ9vdJJjImtNz2jpvzSiqyu3wZ6VuFtZuUhq3kWf1KaEr42Inb+XcDmsKn+Dq017GUuQjktjuh9+vjo0qIifdMphNupVILO/b1mELXG3S5PcBf0PicHFMui9pIGpZfhkFmIIX15SWi82a2yc57cjI/rUnCooaPApojvF8HLnaH6hRqvifS1UUwMVdcogO1RrHLxDGc7dETzsIZ0HfEy5gMA7vXWuZf1pW2UWp4CqYhwAeLMU3N0SHHrc599faPsPy8HQPvQaA173Ml3hBleFsiS5ecxE65lZp9ijncu3Gy1SBNUQ3cHGDu2ymzL8dQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by HE1PR0301MB2297.eurprd03.prod.outlook.com (2603:10a6:3:25::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Thu, 4 Aug
 2022 19:47:39 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.014; Thu, 4 Aug 2022
 19:47:39 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        netdev@vger.kernel.org
Cc:     "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH net-next v4 8/8] arm64: dts: layerscape: Add nodes for QSGMII PCSs
Date:   Thu,  4 Aug 2022 15:47:05 -0400
Message-Id: <20220804194705.459670-9-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220804194705.459670-1-sean.anderson@seco.com>
References: <20220804194705.459670-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P223CA0012.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::17) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9e97bfe2-d858-4392-b6ec-08da76523006
X-MS-TrafficTypeDiagnostic: HE1PR0301MB2297:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fXz+PRqQfnUJhVLFFaljw+gXGyBTjQS8cE6H9hjMXTUslY84RnK9UQv222at72j/7VGWFgRckHFJnKGWm8+jjnPPOMKwK8ByBaM2VtRuh9skmVDWsCXO+Lho+ZUIxxplfZTYFiwLis7pNWzml6Nan74cFlupwG6CERETv9YtVJKz2z+OTMfvPiSaRreGs5uDtzHWyp9Um5yvuuvN76vNXiCvVoQf540wy7+ZHI+fSgsFqWdB8N4ZCbTxZWmupfFXhgAQD7VhOXJuk2Rq5s7h0+NS1TgW80HD1RNu7Ed15E6PWqZ/CWRBEBfngsXM4cv4Rz9G8gk2NMtroa67fHJ0x783o9UqH02a+k6kdIbFA8MmJxR/oJ1QLtV0rI2rQpS77HdmCalyGt+0dsz+6ELPY0AVZbVkH77cz0fsF7NF9JEq/kK0HvdIMe0q4DSWZeEZgD5va4PIAV9guQgRMzguauR9yKlFX+d9Ji+ZijgUsQIrvveGBPKP8g0PU4Tw2QpsAXqIackLD+MNbEg2rGwVCKA3q15hx3IHXu2HjciWaoaj01tHqbNhY6ZFIjaL716s02a34lI6oF8a1iOrdwDMP74gu637FHv7gUOsmUXP30M4sgbFhhcoFAKX3qZ+2GyCL7fcgoTRFvRzCSHTW4wvjQ7Xw7Pn70YvFfQ5DSgAJ2Q+IxS4nADULRzEgS56AvYLmkhPoSLrJbf2aqg9LfZRVQVZ/T8bBHemeucmUsBtmAATNnGhZsdhIlNZxOGtbh7CPzzIPQ33K0JJkFJsBHPJhGl+4pGg6IeA50FOLmroDl4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(366004)(346002)(376002)(136003)(396003)(6486002)(478600001)(186003)(1076003)(26005)(7416002)(6506007)(6666004)(2906002)(6512007)(8936002)(44832011)(41300700001)(38350700002)(110136005)(38100700002)(86362001)(316002)(5660300002)(54906003)(8676002)(36756003)(66946007)(66556008)(4326008)(2616005)(66476007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Uw6Z0tJ6jATFY3UNc6VaNQMlx2+4Y7eUJNGwneaqQM8pVXOstNggFtZ8BBr0?=
 =?us-ascii?Q?bc/Bo2gSp20y+h6mYeqY/3uoHrVJtQFhSrZQvCn3wNu8Kv/MmzKI0Fhbx6KY?=
 =?us-ascii?Q?JVEhaNtLq7ReV5hHdu4dWgWqQodRNqMl3fusfQtNDr6QA0Oiu7ziDVehroEi?=
 =?us-ascii?Q?6R80imRV2g57EfgqZn0dWy45sFUscck34tVUquaa8eYIoX2SAr9/Sb+rEEs/?=
 =?us-ascii?Q?uDuF3+lPKISruXUmNWR4luaZCHG1QiW/DU8Dg1bNr/a6vx9ZtaPYFeRwg27I?=
 =?us-ascii?Q?yuVdf2HXT6Otqm/x8LZG7FbOq9j89ogc84cIi7CuYDhtC856b+Zl67sw8eEO?=
 =?us-ascii?Q?Ib1sni6Q7GaQnNRGqybEQ+vgzwpcj3nRgQ32GDWZoFSghcxtc4TG6IJkjxbj?=
 =?us-ascii?Q?1QhJKSoQ3uOAc3gcGL2rznOeoW6E11vzQKfjEwvN0JNQl6xgEB4yMwaGR5V6?=
 =?us-ascii?Q?C+FZi5jaKlRzNY7BIPgI1yAksaOXGPIltV9qBEhMEaRgjVPCqHdaNtACKpxQ?=
 =?us-ascii?Q?Lp4GHGjoWZQ6/7AcX1brAV+vTVTtNWTCMjKbt71nhKPEVLX5uRLb48pwcp/Z?=
 =?us-ascii?Q?T3qhowFE+jLka7CUdc1jd5lOTVaNoAn5Fv9/2PnW03cJnMnabyXbks0UkryN?=
 =?us-ascii?Q?Ou8O3KGuMsqR7OQmn/QJyCrP68vUY0bnm/sUDmwzBvSaTEEiIIhRIPEkvFFY?=
 =?us-ascii?Q?swWPpsxrwla8KsaGsnw/sOaouNisss0HJ0qKmAQdYqH16oXMNsSZnAl+tHb7?=
 =?us-ascii?Q?GmV2haMoGsfcwkucO2fz+/vSk+l/6Hu6z7wVTteZ9elYJr1bbxND2gAWEKaa?=
 =?us-ascii?Q?Cku/fBmXAtmQFsvo4vlHLuR9MtQ+ACD+ocGw3t04iKtHLqCEigyse46QS2uE?=
 =?us-ascii?Q?PG4XT6LqAe4pjo92Ox5Rd1HlPwN++K7VlDyaqJcBf0OlX/rUHkMxkF742B4o?=
 =?us-ascii?Q?3cGTB2xnL0ACfH0ef6sY1Cq7ZBMWjhmFySEsZ1NzkiyghMFpd9K/7Z2Wne/i?=
 =?us-ascii?Q?yKRwLvTjwlF+59wj8NlGU+HKqx3dBhEuW+Gam9XJCIQ6SvCx8cOLL2yn3qio?=
 =?us-ascii?Q?4wX1aieIMl4eYJB4M8hRTUXC4GQ9bN/VWN+lVKUmPDhlaSibor0dzsUlmArl?=
 =?us-ascii?Q?KyUl5+ucbBMhKCMu4RZS5sYgy/uwrx44zYV179feghXVJlH26TCbqRMjDJWS?=
 =?us-ascii?Q?7mBxe7xFUpK70OZLGJ2C6fKQAqnA4EBSZ+FZFxe1/SXoF0TeoEpLByTfSNxc?=
 =?us-ascii?Q?mO6qrrTjJJ09usNDDhjrWqfmwJ9KwKvYOj8ClrjCTXyGDQqe3jm832NdTZN9?=
 =?us-ascii?Q?jxIHXglxScxIB55pXFRVU45zTOE33+GjYvv1yTqmwJQ/V/qC7HZCnXSEBTRU?=
 =?us-ascii?Q?hjUD3yalp+YgBtjDrZdWLWaseSETikL/bkFHqFe1JnksnXKGQouijrRXtCwz?=
 =?us-ascii?Q?8M2VdOTDYLIDw6V4ITFW6sS//m5MbFObaiQQM0akR8jKG0PcqvNg0IBItkK4?=
 =?us-ascii?Q?5Cl1MuwFdc6SOd/uZBOj845UzQBMLjtZkf+acoDBEMVma/pkS/LitezqPEaQ?=
 =?us-ascii?Q?vuqpaUVrskjKdeMoDByE3ayZr/k2izxOtJuEn8raNbNLkisOI1hs8V1Do8CB?=
 =?us-ascii?Q?Qw=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e97bfe2-d858-4392-b6ec-08da76523006
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 19:47:39.4457
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y8E3xJV4wkfFtIDNQBlOHniGSQbfjXUq/Me/tq1uV8K7JFGo6kgFPh5ApKnkOMcuDQuBgVMDfIOA1HD288MgDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0301MB2297
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we actually read registers from QSGMII PCSs, it's important
that we have the correct address (instead of hoping that we're the MAC
with all the QSGMII PCSs on its bus). This adds nodes for the QSGMII
PCSs.  The exact mapping of QSGMII to MACs depends on the SoC.

Since the first QSGMII PCSs share an address with the SGMII and XFI
PCSs, we only add new nodes for PCSs 2-4. This avoids address conflicts
on the bus.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v3)

Changes in v3:
- Split this patch off from the previous one

Changes in v2:
- New

 .../boot/dts/freescale/fsl-ls1043-post.dtsi   | 24 ++++++++++++++++++
 .../boot/dts/freescale/fsl-ls1046-post.dtsi   | 25 +++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1043-post.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1043-post.dtsi
index d237162a8744..5c4d7eef8b61 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1043-post.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1043-post.dtsi
@@ -24,9 +24,12 @@ &fman0 {
 
 	/* these aliases provide the FMan ports mapping */
 	enet0: ethernet@e0000 {
+		pcs-handle-names = "qsgmii";
 	};
 
 	enet1: ethernet@e2000 {
+		pcsphy-handle = <&pcsphy1>, <&qsgmiib_pcs1>;
+		pcs-handle-names = "sgmii", "qsgmii";
 	};
 
 	enet2: ethernet@e4000 {
@@ -36,11 +39,32 @@ enet3: ethernet@e6000 {
 	};
 
 	enet4: ethernet@e8000 {
+		pcsphy-handle = <&pcsphy4>, <&qsgmiib_pcs2>;
+		pcs-handle-names = "sgmii", "qsgmii";
 	};
 
 	enet5: ethernet@ea000 {
+		pcsphy-handle = <&pcsphy5>, <&qsgmiib_pcs3>;
+		pcs-handle-names = "sgmii", "qsgmii";
 	};
 
 	enet6: ethernet@f0000 {
 	};
+
+	mdio@e1000 {
+		qsgmiib_pcs1: ethernet-pcs@1 {
+			compatible = "fsl,lynx-pcs";
+			reg = <0x1>;
+		};
+
+		qsgmiib_pcs2: ethernet-pcs@2 {
+			compatible = "fsl,lynx-pcs";
+			reg = <0x2>;
+		};
+
+		qsgmiib_pcs3: ethernet-pcs@3 {
+			compatible = "fsl,lynx-pcs";
+			reg = <0x3>;
+		};
+	};
 };
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1046-post.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1046-post.dtsi
index d6caaea57d90..4e3345093943 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1046-post.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1046-post.dtsi
@@ -23,6 +23,8 @@ &soc {
 &fman0 {
 	/* these aliases provide the FMan ports mapping */
 	enet0: ethernet@e0000 {
+		pcsphy-handle = <&qsgmiib_pcs3>;
+		pcs-handle-names = "qsgmii";
 	};
 
 	enet1: ethernet@e2000 {
@@ -35,14 +37,37 @@ enet3: ethernet@e6000 {
 	};
 
 	enet4: ethernet@e8000 {
+		pcsphy-handle = <&pcsphy4>, <&qsgmiib_pcs1>;
+		pcs-handle-names = "sgmii", "qsgmii";
 	};
 
 	enet5: ethernet@ea000 {
+		pcsphy-handle = <&pcsphy5>, <&pcsphy5>;
+		pcs-handle-names = "sgmii", "qsgmii";
 	};
 
 	enet6: ethernet@f0000 {
 	};
 
 	enet7: ethernet@f2000 {
+		pcsphy-handle = <&pcsphy7>, <&qsgmiib_pcs2>, <&pcsphy7>;
+		pcs-handle-names = "sgmii", "qsgmii", "xfi";
+	};
+
+	mdio@eb000 {
+		qsgmiib_pcs1: ethernet-pcs@1 {
+			compatible = "fsl,lynx-pcs";
+			reg = <0x1>;
+		};
+
+		qsgmiib_pcs2: ethernet-pcs@2 {
+			compatible = "fsl,lynx-pcs";
+			reg = <0x2>;
+		};
+
+		qsgmiib_pcs3: ethernet-pcs@3 {
+			compatible = "fsl,lynx-pcs";
+			reg = <0x3>;
+		};
 	};
 };
-- 
2.35.1.1320.gc452695387.dirty

