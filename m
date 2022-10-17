Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18A14601956
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 22:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbiJQUXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 16:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbiJQUXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 16:23:24 -0400
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2088.outbound.protection.outlook.com [40.107.249.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E59BA46DBE;
        Mon, 17 Oct 2022 13:23:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F+r/o1134LtF84gI51TXzw0/eAOUPCoH7lLfx7ymETQGvh5OLrrW1pO3+atYqZPiRyLimIxVHwBDchF/NNEu47OQuchp3qXXJUnejyBpkSn+Hug7GW5oJepHlRO7eIEfcDsuc1E4G92dfdecsuST2cLEwiJzhn6Amn3eV3gVL5u3MBvE7yX3itEsFCHVO2UJabouvbC8f05/5N06GVjGLOvY2bjcGiqMy9vCIFYqGKWoD8lpj0etr+PiASf8qJERYEHHN0rg6Evbgm0yp0ir991PX/Vlw8+TxJpntE9v/6cte/KHIKfp+KnNnUzYJS40Z+u1cXQaJVFMABVPg+5aVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yhWiPukeqtRGphejfz5xbInCPQvZjgcBGiv0ermy4sw=;
 b=jQv/GAMfOWs6Gdpwl73XHffuYUzdA/WfATZcqUYCaM00mH4V+TVavbwonJSWb/aIf4AVEOr2V54BWsdoe9BGHSWNQt4nNgjfMmPjs5FMMjM7Dez/pEQdrto/KQuSzpYDq04lRdbCm3wutHhnAas4ZdQ/jgsDO1rfmW8aXZFKr+cuJ50v2N0I/T5cqElMQKDcG5PH8nibymH5GSKKX/fuZtAxcMV13S4HaPM5rR4+etMYvh0d5tPiSFnQ+MlBmtl+flYla6b5jv3VBoT17J0ThO6ernOYwJ+JRROU7YNWNMpwK33mW0t9R3fcwCKXtZkmSp33/rkD4QZWfLm8dWA+pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yhWiPukeqtRGphejfz5xbInCPQvZjgcBGiv0ermy4sw=;
 b=KLe14F9iO/1bmwqbZEBHYhdlXULq6oYpXF6nMI6U28ZATPQMXXS+HlGtceF+aiU684U9Bim2b/nuWi9X7+kX+7YAQ4fDCsmBcYNPuCCc3m4XiKzTuJuML+boJu4YfFXVx5TJA8/gPzToqGEafFJ9jIdLizK1dLb+AJNarRPPpPMPPwdPjYC6P4InmagYe4cfIUwjkBDZkbBtPKeLwfcXE/gCAiusSO021WdSX++KDy4wUdRbqaDtRkYD9QLfbix91LAjHu53fjCcgE1kaSA4shOeCQXkfKXTW9wH/lkcXmQwAdeJgXshKQImARHIdvH0ASxa+GMQ+Au/89Vm/qr96w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DBBPR03MB6761.eurprd03.prod.outlook.com (2603:10a6:10:1f4::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Mon, 17 Oct
 2022 20:23:21 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d%6]) with mapi id 15.20.5723.033; Mon, 17 Oct 2022
 20:23:21 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v7 05/10] net: fman: memac: Add serdes support
Date:   Mon, 17 Oct 2022 16:22:36 -0400
Message-Id: <20221017202241.1741671-6-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20221017202241.1741671-1-sean.anderson@seco.com>
References: <20221017202241.1741671-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0251.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::16) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|DBBPR03MB6761:EE_
X-MS-Office365-Filtering-Correlation-Id: 20518067-ea49-4c6f-f4b4-08dab07d6f23
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DQNtnl29yMI4ZzmnFvZTbjq8uWgIRDfZnFIsswQ8+UELZrd5DY+SZvG1Ucj/UgpDv9b+hNiMKT8gdqFI+xKet5QVXOYRkoVPorfx8vo/r0IPmadyS/GD64E7aTGCkkypK55CVgykYWHuOuLPe/nVo87wciYrWAEADe5k/1kdruBpuCM6s4kvJlyKnmH2MaCvJRIfrz5ITGAs8TUECmBkqS3FrZKz3hDfZBOdBetx1KO5bBluCGq3Nla89m43E1Vt6WZPoNZrivrD827KXH2kv6dfsynef6++GyWRcrmt3S0eqhOfpBvMzSb31FtlcYQzwQ3AyFhYgxV0jq7S9kThxG6GgHZs9H1G4j6iy4QEQaQbsVLi+LBAJUCOAukixSiGqIMR8R3pQfj1UfPOJHKtE9gIqRmpsQrP0Y6Y3Pv/HQt1/COeSDE/Pz8PyFsAUbFgVTUBlGVnq5GFmVi2obnMITSMCyDJ2TZLrCq3lhfTRsSbyqx3ZtcOcRW7kPC7w7drr44nUD/VRoA3ylZ5DvVFF+apr2MDvrGxJvLLtxwWk4B02W1YJM60dVmOZ1mLoV0hf6hqVZFrcDHdz25KThprmvWgcnmx1+4tQUueCKoK0S3g29eJXg5m7Qn/6hc5ZJrG2m6OCbXUj9ktuvHV/6jmhra1WEFpOah8mIHaAPDpEQvbGIIk5NWhNlcdfOQ2Du3x4DP2iDyi0LD12E2FhM3WaNwQKh/lHCWZn5K5Y1G7+qzGQl3EmO+2K9Im3z2oMn+OhndTDMW76LMFID06+6iJsw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(396003)(39850400004)(376002)(346002)(451199015)(2906002)(5660300002)(7416002)(66946007)(66556008)(4326008)(110136005)(54906003)(8676002)(316002)(36756003)(478600001)(107886003)(6666004)(6506007)(8936002)(41300700001)(6486002)(38350700002)(6512007)(83380400001)(26005)(44832011)(52116002)(66476007)(38100700002)(1076003)(186003)(86362001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?l8iEFqvpq9WLcKQl1EfV3s4tqIRUvLxAIgUfhwvXa4alRZXcDK39Tu1226ki?=
 =?us-ascii?Q?XlHfjrlfyOP0gLJBGG6js1HbCz8Pd5dvN47s/0RbUoNaDEwrtKw9SDNxXey3?=
 =?us-ascii?Q?FBZ3BBn9sI1Whb3skMbyNnohd88n6i+W8N3J+2gQHbM1eBv5ennHazAdU5Uu?=
 =?us-ascii?Q?SmJ7tEJ26OgIlMSZCBnzlDWAs7OJo/jrrvoHnux3uccwKhBfPtmONerQQdaQ?=
 =?us-ascii?Q?Qj0E8/NkXjP9JmvABxuXwaWOukNs6Q7d5shjaRyL4ugf0NvNFK4fOUcYnEaS?=
 =?us-ascii?Q?5Tl3Cbac413EOpaudp0oZuBAnCCCr2mfxTAUmENtGAZzIK2kSIqEJ8skz2ct?=
 =?us-ascii?Q?3XvCkjLnQh2vhgkcgX2D5OdomX1HjPkq1cOSvZSByspawXGL1ug4hj9IhfCh?=
 =?us-ascii?Q?nmgu0JBBhO20k9HL+0y4/bANkcKpGyCicI7hVVcH9zNsCNEpRa2cZxLLv6Ug?=
 =?us-ascii?Q?/6sjCjBNUX4t5JBOi3j4FIMmxToPQPCMeKsNGvoD6ZJykba5Y+V+tQcRv+Lv?=
 =?us-ascii?Q?MJ8on/G/WkGLr9QCc8g81iTGCMAovGpR7YVrcsaSqNkOqITV+kuoBWYc8suK?=
 =?us-ascii?Q?BIvBghtYuHKzDWWoXC32Xl3bWGDl/hQ0YonRbYjGSQuV/EGyKLHiajbFKnZM?=
 =?us-ascii?Q?VCobhCGeXYBtEwkmuXI9pwYSKFOLpUZZ5aIDo6XMhEaDGj9vqTodbQSvRJz4?=
 =?us-ascii?Q?SALKIuLtryxYxs2s7Se5DHydbzJUE78ye9ecdmhvmtbRxoYfksG7lHx6Glr6?=
 =?us-ascii?Q?TSfpO/58w27AnxK63+SL4KqnYMwiZFB4Lhyrk3NKFa/pQx+AzlF7MRPIiC6D?=
 =?us-ascii?Q?6WYkOt2kA68l0xA4vuiwm0in59LxbdOE16T04SIP3gFpEkD5xajXuxFQYYTO?=
 =?us-ascii?Q?izYmNne7Eon4FPWqVfd7V34IkL2xZ8BZyuorQNZmTvKx6WcTjyZghwb0wPbR?=
 =?us-ascii?Q?IsW/Tfvm7q29WqKUcB7bd5TjF7FY8sCRcy6iXXw/GeU73vOj3mxLC4bhP1Wf?=
 =?us-ascii?Q?FyleOEFUEkGW/GQk0LrcbO1LkYdd+UKDntue3HdWqfHdmzJHogiJrZhhdLcQ?=
 =?us-ascii?Q?o+2M0RAZCQJpvpqeSUJVjmZta5KR+12nzDK8dPsNNJ8wrjg2Se2tfL2DS5Y3?=
 =?us-ascii?Q?eeXhYiIYx08aMWJgdIkyBif9RKLDys21P87/crBdBw62bDArwUDwZ4w+ZwRa?=
 =?us-ascii?Q?oXXPFsA3Nm+U5YE+lVQjHOyOpcDo+7O0mNIcNKnuyKLWP3J4fQi8YefHW7FK?=
 =?us-ascii?Q?PkG4dccumF2IEheC6Ge1l1BSfHMHPPXhh9B6EwqA9fHIQoE6Fz0Y0zaFC34+?=
 =?us-ascii?Q?fgg4oyC5x89+IhKWSj4v8I3fp39UOHktXsi/9VH28u1vm50wha5hxjjiUHSH?=
 =?us-ascii?Q?Zva7zWV9Ibvsun9RzqDKKEkhL0HyDYS+m/31ls/NicAW4SQWRelFexlU222D?=
 =?us-ascii?Q?D3y4zdp+Pi8hd2/+X2E+hzlIh3YesvMp/gJcPWwIRttgJXEXZBArs5xsM03U?=
 =?us-ascii?Q?mB6GBD/oP0T4/vy0XExkmDyz1F+ELdYSEU1FCYrwp1yALdKKt6b3QdzacNqu?=
 =?us-ascii?Q?2DkX9IcMuWKoNgtlYl+q3urBFlbcfifalxRk9CJGo8lwe8DX3LVX8YTK0//T?=
 =?us-ascii?Q?gA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20518067-ea49-4c6f-f4b4-08dab07d6f23
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2022 20:23:21.1030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yMvU89I5Y6ELcX4hHSQqBgfrFrLBzIMXlZYCaNiBNCAH5CzkYZu4xbs8niouw6cLS5bfS8TKPdLXj52lIikxWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB6761
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for using a serdes which has to be configured. This is
primarly in preparation for phylink conversion, which will then change the
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

