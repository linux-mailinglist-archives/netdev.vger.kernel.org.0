Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4245F1341
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 22:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232406AbiI3UKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 16:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232452AbiI3UKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 16:10:11 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2041.outbound.protection.outlook.com [40.107.104.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C3827696F;
        Fri, 30 Sep 2022 13:10:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iUCWzUskeuvxNtCX9IxpZumyjNqZvURWAnW4HTjXuLWtwcLiVQnvakSgY+fd9Z2yUwAb3RScLtwL8AvkUmPKrXmhFMTYibA064IOoSZPpYnSN+mq6Pv5ZPiBdOFHm3r1iwCoN7+4xdMZSkriYfIqu4aJtj+yyTqFMfPoHd3U7ulGxamx0mdkxw2c8dLSpcpNwNRZvdycG56SueOcYBAF+9T6o38+JcyUs/m2ue/z5YV2mQmf7/HWTYSsj0/+RKrUNoideE65FVMyGTi7+WJDu4iw5I4aBSUYSevtxC3gOL+Gt7fcfThk0jKjjSfH2k36FJknLfIg92wD+a7ZwIFZag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ppbX7gkdSbkxfHgc6D5Y+h9NkpsO2d0pVIeXPyTOAWM=;
 b=Wo0Lk/l8Lcru/CEOhfENQCDnTZdb9tbqvhNA3a03jz23XGMwaUyZ/LTlIgAnZvHZLL3gSEervmcft5o6Ngo0FQEOqCfwzOJmAScL0Dwhm5TDSDX28MJcNEwWmy6ZRHPES8FvsMDT33MEXmLsD08hq3Y/fc9+r61bSGcFxTKMNrlZRe7M0Pjvs2G9zY1UNbddfDeIn7Q0aoMowJ5cHh4/lyJpdrHx6KiSH+v1v298f5HkrLQOUHAS3Jgyl9Rs2ekwG2k0/or6XJPK5nV+MKnsgCKejg+aKMFn9pEyEsdSgY3I4TDs1p59iv6wfN8xhhNdcJ3dy/ZkbVZGWz1clgS3pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ppbX7gkdSbkxfHgc6D5Y+h9NkpsO2d0pVIeXPyTOAWM=;
 b=nLkNaLq5fJFddyPc+wgtlWlNgpxqgvbFHaIOb9yvacWb/IeFfqqPvv3ncNFio3L1+ruRwPY54FHTbFGPHQNXrLqigcBeDiWuYBirWzipj1gzUWnZIWTCoMn4e+hC2ud4fl/ApNEI+rdjC9leG+SS81YPR0NX1r0IZwOgMoHjkKWQsi6lJ9SN6WMLeKeNzwL8I++dPJ6Jdk9yNvcLiqHbfkLl15BMi4j0syO8bKZeX2v66v9zL0swJ8zPuObJyP2HqZY6lG7LOZNSAP84YqX4PT0y8eZgNxl9xCiBDoBRZEi8Ai2D4f9gsvFtLh6QuuxR+jb3llwqVvsFMLA38Y9v6w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS8PR03MB7749.eurprd03.prod.outlook.com (2603:10a6:20b:404::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Fri, 30 Sep
 2022 20:09:53 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d%6]) with mapi id 15.20.5676.023; Fri, 30 Sep 2022
 20:09:53 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v6 4/9] net: fman: memac: Add serdes support
Date:   Fri, 30 Sep 2022 16:09:28 -0400
Message-Id: <20220930200933.4111249-5-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220930200933.4111249-1-sean.anderson@seco.com>
References: <20220930200933.4111249-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0144.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::29) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|AS8PR03MB7749:EE_
X-MS-Office365-Filtering-Correlation-Id: 40db64cf-c497-451f-fbb9-08daa31fbd03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gvb1L68JNvrxi8xxy4PAUlb451shNQ2il+yuWnof9yjWMBaH1+Z6r67W4Kf+5XwLe4Xy7T8yKqhYjJRaEOWg+MRJSArDXWmDkBz7zEzTmCH17BBeu4QVu2zw0RQHNZYjCOivTfodUlU5XOgrHEHNg+n0OJrBqUFgo7t2viZ6bB+jWvu+A0AqRNiX+2mkBfcDLiavuPJahvcI5kT2L5oNSifZeQqxyy7JEowaOr0fYaprbYrUsbqoj2wHQMA4zKPrJIREpfaas6YoA8aICBTF+vVrypwlLvE5pURO5RLbJ3VSig9JDxdjV3AJwxWVnNWZxIzw6U3gQpPRSavTTyk7ZDWlpO4seK4xbUtA8rajnzRBsL4+4GnbKhpv8VbYY9NtO4lI7lUcDQrEp3ZhGaP+LB6sVsgVeYkcsmu07VFQmVg45DWza8a1GC6oDRwohtZI8lHAZoSEctEOs7+G7UJblux7eWE91SvakeIR0DR0FFbvd495lw7/8U7oE0gYIFO7I9sVcVL4GGU2Z1nrM9pWOpifW857D+bP9jtkWV2bFF+5TEBD0OR/CEGHpEcnTcS5Ka/i/P3SBmU/FsMgqpU1FTr304NS1Xxbg1vTIlvWnu/1wde8PI4+zD2R3Lhndm1vWOFS92VJcMzSUcRPGLZ3vmQP5tnDFYMEtuBKwSuxHiuTvFncmh4dXwe+P3YAZppJK9w+GIYHZ+eUf0T+RP9RD9z82JYtpzGCsNYhcZf03NxINoM6BjKY+cSRZiIfJo9L9qtGvb2XJl7nITuQ9S1cXQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(366004)(396003)(346002)(39850400004)(451199015)(66946007)(2906002)(6666004)(38350700002)(38100700002)(8676002)(66476007)(66556008)(4326008)(83380400001)(41300700001)(36756003)(6486002)(6512007)(478600001)(6506007)(52116002)(26005)(110136005)(316002)(107886003)(54906003)(186003)(1076003)(2616005)(86362001)(8936002)(7416002)(44832011)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I0tIzu8gISFjV0mdaOgVoaEeB5SU3QlEhIWQ2vHKn9+iIusS6UW+dL5cgcS0?=
 =?us-ascii?Q?TuE6VHko4nt+HKzzYx6Q/fIF58ia7IvfzRgodRgy3UXk4ChU0mkYALLanufZ?=
 =?us-ascii?Q?bL81kA59gQbvQM1f/6tI8ZCJEYAfm41VzdGhpIvHm3Sl+hFiTgSyzKozD411?=
 =?us-ascii?Q?62fdf+6MOVIshTjqbFoN706H73gs8UykaFL+7FY1+iZVytbGr3iPUYvXhvbW?=
 =?us-ascii?Q?csefcN0FGNU1jnQoVvD1BRpykEvuji+3lRXkYUGa/CO9Y2OG7G9I9jCLxJmg?=
 =?us-ascii?Q?ue1TlAu91dqSoSEOtQAbEfTkqfVzlm8lXW7kObCVu6x1N7AgSKZ/NsZDXcje?=
 =?us-ascii?Q?ENfqEXyHhxq6Qd6YXc/4e7pckbjtNV5okTVYqdYvTp2BLnvZBXE0rhRzr8qF?=
 =?us-ascii?Q?ZRcVAA77/WFEi0a8EHeBoT4f6UnyGgX/6PRvILnPFaHXTZ74wo+0IheuV88A?=
 =?us-ascii?Q?LJ0SbEO2E3D5VEY5b5UIQfsfGdv4KfsWf+tyL6Tf6WSuAIxgJAw6+RQrZ3nb?=
 =?us-ascii?Q?LMnxXLAd7LVmlq5CAXhTbIOsasHrsxNgsR+cwIpFBesS7E+aCSDCWiHbay0F?=
 =?us-ascii?Q?yaZ3tsFz8qYO04v5PkIjEyXH1pstrXC4l8DhYTaYc1+TbdhbxxNpO1S0OE6/?=
 =?us-ascii?Q?MtMm7YVOZCh51RlgZ2aPSUUP3T+Lhx6cx4UF9p6b0c1pNdvHzfQYlDKG1DRH?=
 =?us-ascii?Q?uk5d4ggUUeCLiEYovL/ulxg+YiEEwhc1iKdZavibcOtVnJA/yti1eu2t3moJ?=
 =?us-ascii?Q?JPG/k3t3XRebYqomt4CxnBohKVDn6sMS3Do2qwEOB5eExvHIlTlVnRtfCm2X?=
 =?us-ascii?Q?Evd40/ISshB25plgCUsCHKXhhcSIyhNFbYxTXRmXbz6LmLQOd0zXtbEK6vkd?=
 =?us-ascii?Q?BvYjpAzPgen94djjrqgZm5zN4XfcjBA7tknz6Bumf0aqk6xUd0w//dMRygoF?=
 =?us-ascii?Q?qkr/YFwySrukgwWEa33Xoplj/7kEY7VexPE+wypitdghdKBE9iQZuPUS55g9?=
 =?us-ascii?Q?WcK98HZaCbln3cUr/exKMAsai7qu/PCQCPOGOCGEMIy3bucYtj6p93/oCJpq?=
 =?us-ascii?Q?BLIDh4ycUd3qAnkTPrF7g0rMhfgHKFLtrs4AYIpHh45akDxmobF0REkufjAZ?=
 =?us-ascii?Q?uFn7LAufdaVFhCl1NOjiAPeKaRPM2y9nUxQ/RsYTYynlBpOxik6TcuVZHiE9?=
 =?us-ascii?Q?l7HvWuEZc2ScViIsilg499Yz4TpIp+G3ajkQPLHLvCNO/42NTfMmeh/IRj10?=
 =?us-ascii?Q?qAOQW8MVbYl2l7YhlnTcPswnONznXiLMYXU7oEwIy6VzIh/ZuBJIvU0bey2j?=
 =?us-ascii?Q?rPJ6DVc5CuPWh/1aSXmOoFT03Egyv37MhKLUF+MwoUUwvqECeu09RxVzbzSy?=
 =?us-ascii?Q?rtkkRZklkgKtngmqaUX+BF3zbGWxp0f8zskSBi4pvgiMX/k6Y+X7lwh/iZNl?=
 =?us-ascii?Q?nIx9YXDgQG18qxMDoZiQ+8mqnMDPfFN4pOnxkkYNVLrGUqiPMVPqtmIvgb5t?=
 =?us-ascii?Q?moBtIhonTD5GG52IfIYT+2b70SJEA3miJ/Gdgnb6+6oPPpglG/3qxUIIfQ6M?=
 =?us-ascii?Q?Ew5ea1FoMmP7WOtd/5+rdU9PmGxRghZB+tACHN/RV65dBndw0Gs05RH+zynj?=
 =?us-ascii?Q?Sw=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40db64cf-c497-451f-fbb9-08daa31fbd03
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2022 20:09:53.7596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5a2HND06pznLZl6QmRp7lBI663o9UedeHEO3F73rovUWUTy+lN6RqPqmw13CCZvJZpTg79z4Hf42+hU2W0JcQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB7749
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for using a serdes which has to be configured. This is
primarly in preparation for the next commit, which will then change the
serdes mode dynamically.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v4)

Changes in v4:
- Don't fail if phy support was not compiled in

 .../net/ethernet/freescale/fman/fman_memac.c  | 49 ++++++++++++++++++-
 1 file changed, 47 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index 32d26cf17843..56a29f505590 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -13,6 +13,7 @@
 #include <linux/io.h>
 #include <linux/phy.h>
 #include <linux/phy_fixed.h>
+#include <linux/phy/phy.h>
 #include <linux/of_mdio.h>
 
 /* PCS registers */
@@ -324,6 +325,7 @@ struct fman_mac {
 	void *fm;
 	struct fman_rev_info fm_rev_info;
 	bool basex_if;
+	struct phy *serdes;
 	struct phy_device *pcsphy;
 	bool allmulti_enabled;
 };
@@ -1203,17 +1205,56 @@ int memac_initialization(struct mac_device *mac_dev,
 		}
 	}
 
+	memac->serdes = devm_of_phy_get(mac_dev->dev, mac_node, "serdes");
+	err = PTR_ERR(memac->serdes);
+	if (err == -ENODEV || err == -ENOSYS) {
+		dev_dbg(mac_dev->dev, "could not get (optional) serdes\n");
+		memac->serdes = NULL;
+	} else if (IS_ERR(memac->serdes)) {
+		dev_err_probe(mac_dev->dev, err, "could not get serdes\n");
+		goto _return_fm_mac_free;
+	} else {
+		err = phy_init(memac->serdes);
+		if (err) {
+			dev_err_probe(mac_dev->dev, err,
+				      "could not initialize serdes\n");
+			goto _return_fm_mac_free;
+		}
+
+		err = phy_power_on(memac->serdes);
+		if (err) {
+			dev_err_probe(mac_dev->dev, err,
+				      "could not power on serdes\n");
+			goto _return_phy_exit;
+		}
+
+		if (memac->phy_if == PHY_INTERFACE_MODE_SGMII ||
+		    memac->phy_if == PHY_INTERFACE_MODE_1000BASEX ||
+		    memac->phy_if == PHY_INTERFACE_MODE_2500BASEX ||
+		    memac->phy_if == PHY_INTERFACE_MODE_QSGMII ||
+		    memac->phy_if == PHY_INTERFACE_MODE_XGMII) {
+			err = phy_set_mode_ext(memac->serdes, PHY_MODE_ETHERNET,
+					       memac->phy_if);
+			if (err) {
+				dev_err_probe(mac_dev->dev, err,
+					      "could not set serdes mode to %s\n",
+					      phy_modes(memac->phy_if));
+				goto _return_phy_power_off;
+			}
+		}
+	}
+
 	if (!mac_dev->phy_node && of_phy_is_fixed_link(mac_node)) {
 		struct phy_device *phy;
 
 		err = of_phy_register_fixed_link(mac_node);
 		if (err)
-			goto _return_fm_mac_free;
+			goto _return_phy_power_off;
 
 		fixed_link = kzalloc(sizeof(*fixed_link), GFP_KERNEL);
 		if (!fixed_link) {
 			err = -ENOMEM;
-			goto _return_fm_mac_free;
+			goto _return_phy_power_off;
 		}
 
 		mac_dev->phy_node = of_node_get(mac_node);
@@ -1242,6 +1283,10 @@ int memac_initialization(struct mac_device *mac_dev,
 
 	goto _return;
 
+_return_phy_power_off:
+	phy_power_off(memac->serdes);
+_return_phy_exit:
+	phy_exit(memac->serdes);
 _return_fixed_link_free:
 	kfree(fixed_link);
 _return_fm_mac_free:
-- 
2.35.1.1320.gc452695387.dirty

