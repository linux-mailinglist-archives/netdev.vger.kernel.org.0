Return-Path: <netdev+bounces-8162-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DAC6722EFF
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 20:56:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 87D3F1C20D26
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 18:56:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48EDC22D71;
	Mon,  5 Jun 2023 18:56:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2122120EA
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 18:56:07 +0000 (UTC)
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2104.outbound.protection.outlook.com [40.107.95.104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E29F1
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 11:56:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ifQQChbpSpCEL88VZat4+NroeLapzgVUu5mTTxX7aBdPsppx7CHv0b3G2c9BEMM4x9AA8Y2ZCXSLd8ed7BSGqn8LDJUy8Rrb/5kErnKbNOcKapNmaItFRY0uaiL7YqXqkpALJEOgdyE/DrjODKHwSLimPGWpttDxOcokpluII1jAi9Jyz4GDkFv/TT6EDjDnz40hziPOSNehr1DNFsth3/th4kMcDEjOxuD4ix7Ozwrq+ny6mpINzxHS3fbZ45aAsAY0moEUfcczadAkLc9dQFCKm7lWH9Yf9lCuw4nvSZCdNi5ZoumWS1a0rVqDTAwMa2G4oWZZe2qbwNtnPieFCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RSA7i0x94ef+b61s4PX3Rwc5201eVx3cN4oslHGzaSA=;
 b=Vd+K55e4ocAPBjdZhu+f1gBz9h6sEjON86GoWTUbKzd9FYqnRWJ7G22kK19g+af3amgOLkZY2e3gHOZq7s0taOpLRQ0fFBGufLP/eEFX+kz7m3skLhq8c0pNmUUmHzixo6WWrq4Q3889ycTZJK6fBcnLBKjKrE/am0LlXI+J6AFcU4BJUIUXfwRtXoLkXj7Tfuj0AUrJnZbkF/yh18hzgdjFX57hzAUBASWgUo7jkwgqr26ZEP/L61GADpGQOLkkoUaAty6SsvWo80RULnjTc5bMi/4pVmFqHSrPPLb1EDz572sp8CxJhh2I3uk8Jk2xnuTc8SF6M3LioOfYQ34Q5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ipt.br; dmarc=pass action=none header.from=ipt.br; dkim=pass
 header.d=ipt.br; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ipt.br; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RSA7i0x94ef+b61s4PX3Rwc5201eVx3cN4oslHGzaSA=;
 b=GdSiCv/dW9sJzJEDmkSCv0x6bH5oxbckuz3K1RluPTg4gtVaPaJ/3riwz75exRusWqiGkMlxJklSZTuqZtDmuTdwrUWZjrl6jBnKWzy2/cl1lGBR+WpIpwBEhHpPOUFyh3VhAw6p1jc/0VqbWm5BPRwVR8om1p5lZVffuwHyYNY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ipt.br;
Received: from CPVP152MB5053.LAMP152.PROD.OUTLOOK.COM (2603:10d6:103:1a4::6)
 by CPWP152MB6145.LAMP152.PROD.OUTLOOK.COM (2603:10d6:103:20f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.19; Mon, 5 Jun
 2023 18:55:58 +0000
Received: from CPVP152MB5053.LAMP152.PROD.OUTLOOK.COM
 ([fe80::3992:821c:7cd4:349a]) by CPVP152MB5053.LAMP152.PROD.OUTLOOK.COM
 ([fe80::3992:821c:7cd4:349a%3]) with mapi id 15.20.6477.016; Mon, 5 Jun 2023
 18:55:58 +0000
From: Fernando Eckhardt Valle <fevalle@ipt.br>
To: davem@davemloft.net
Cc: jesse.brandeburg@intel.com,
	anthony.l.nguyen@intel.com,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	Fernando Eckhardt Valle <fevalle@ipt.br>
Subject: [PATCH] igc: enable Mac Address Passthrough in Lenovo Thunderbolt 4 Docks
Date: Mon,  5 Jun 2023 15:54:07 -0300
Message-Id: <20230605185407.5072-1-fevalle@ipt.br>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CP5P284CA0008.BRAP284.PROD.OUTLOOK.COM
 (2603:10d6:103:95::13) To CPVP152MB5053.LAMP152.PROD.OUTLOOK.COM
 (2603:10d6:103:1a4::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CPVP152MB5053:EE_|CPWP152MB6145:EE_
X-MS-Office365-Filtering-Correlation-Id: a22ff903-28e2-46ac-29b2-08db65f67fb7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Swz3jb3up8kEvFDL+iSt70wiOQ+dBFLWrScTY0dJHXZf4o7KmeGa92M61o5VSkq9QuBIsrgy3ipxKaQI++gOeGE+i4OoLobTHJl/b4+CXtb9pkMNdQ2t+8ABXJNRfzUick55FrY6SkT4EBsgXx+eY1W1t7tGwI8Qr1exPfyZdGJHgM/hocI0qWcbEfwoXIXKV2Q69iLk3UA8aN9ATjFm/kwSVlv74865TqcrM5eB3x7eioXLHvBcOdxl+Sremr6L+EoAb27nQLZTyFlcm5udJ3sPKV2HnI0MvNogBvHffPFg2GEZqsAkUZrqyg9609gAkXmOkciroyu2u8uoSnhA7CoU2733iu72fddo/UDmohUCwkVAf3vF5FmZGk5FDG+utXt518SykI9C5eml1Ye30WlGjwYLYf8uDzU5y6amW8i2Mq5EvnQoRjM0VhhSdcM4GFrTvDMYL2JM4aMO1xVH4/yuHWfz6q4qeyZIkeT27A/N3y6TjGnDokVoTYGvHnwmBfU3e97BixTestr7qsyNc9ywuEz6Amw4Ho4AKJ9H1bgXmIuYl2olIm1yn6KFEdqRMjMBBNZT8b3mL6NkIZ1ONRpSDHjZvyfjxZSKePn8xsQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CPVP152MB5053.LAMP152.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(39850400004)(136003)(346002)(366004)(451199021)(83380400001)(2906002)(2616005)(36756003)(86362001)(41320700001)(38350700002)(38100700002)(966005)(6486002)(316002)(41300700001)(52116002)(786003)(6666004)(5660300002)(8936002)(8676002)(478600001)(66556008)(66946007)(66476007)(6916009)(4326008)(6506007)(6512007)(26005)(1076003)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XI4cxia49XtmG16W6Bx6y66i9uh1Kd7jIhTj6d1wLbkrHqEZ6FgEC0Lp1JHt?=
 =?us-ascii?Q?d3Vztnju76dUTaeU/0zFv/Rvb5xmdt5ajWsrMFQSktjt5x6CeDC2MIRtXxx5?=
 =?us-ascii?Q?g9gHdcFDdzmOJ4Taj5kcqtECtArXsCKiN85UKJ24IbonNMSmT8pXBi8LJc3O?=
 =?us-ascii?Q?4X4Ttq/kiFI/H8bLnoW6r+BljkjcUiEoHVicHxXCFiIfxZ9r0+rOaQskMmOY?=
 =?us-ascii?Q?AcoRsd+q0OnzTx+GrBi1H6iZtkk32hxIoPyLc3d515GLwQjIKT97GVigEQdU?=
 =?us-ascii?Q?DdQ8r2vF0yrh+Sd59KCUoRz76HQcStK8RUJhJvEN2HkliTU0euelBj6aeXeR?=
 =?us-ascii?Q?QWW0HPzDvb5+W9CboVRrU1VS9SouATQP8KS9Qdwy9xcSRi/B4tFQ7FjsvBk1?=
 =?us-ascii?Q?C5n4ZQ51GtCHHsY8HtIBOetBbcj7i6KoYTljEUqP8Hr6ovJyMj1OudnjKxtO?=
 =?us-ascii?Q?HZ8qwuuqZVnoLplOuBaRKgVHd8PTRfnbnVy2oz+Y/wv4BsZakvkcsXFrXofJ?=
 =?us-ascii?Q?QbBZPA7DYwicfdvmRMAnJ9JNonyl9myd4E4KBhunOGdBHK/2ZhTGzXTJADPR?=
 =?us-ascii?Q?DA1PxTaC7ihYih3iLdpaIR6gwJmqD4k09pLi1FJg/VFfvG/l9u20ybTkkGcZ?=
 =?us-ascii?Q?Y2C9DVg7iX4UGjr6WY1GOtbisB6oXH5BfIlHgc5L2VHzRPwbrrfhFjB9AnUR?=
 =?us-ascii?Q?Z2w6I1NXKniqqSACbZQdkaH0tvb0+Yy6xTi7oRk8pj+ARJHkS3pmpy6W0Y+C?=
 =?us-ascii?Q?IfA4Qfg65YpDPVGMySolYWy/GtgZxsrU0tYHq+VMPN8uGrQrm3Xa3m2bzh5i?=
 =?us-ascii?Q?Vc8Y5UOswG4+2kSalEMmH+ER9jDsCkYuKeWijomuSp0veUSUzpWLXHYSiPH6?=
 =?us-ascii?Q?nVPWhJPbqliDHSRZkF76bgbjZ9Q79RMinEqmBgmHcCDLiNTCXxl7I1ttyK7w?=
 =?us-ascii?Q?9xMIiGRCbKvlMDeOsRYNnWKwJm+for1A7jAuoLZJBV1KIYzyNfoIDXSTI3uT?=
 =?us-ascii?Q?qsUG1+1xzXZMm7i6f8JOaI59WxBkX7dWe1/GEFzhJIunERyvYXySExmMun39?=
 =?us-ascii?Q?Q01r501pOXdyWXKomClzJ3zZkvqd2dRcv5GOqe6BXwZ9qFugTg/jhVHddDaV?=
 =?us-ascii?Q?eEcN4qy2P2qmq/LTtPtV0Grakvpwjq78+yaxeQ01AJnutPluPV9mtFZRwsLu?=
 =?us-ascii?Q?JXj7Vo4TS38OLWIHm7r7bC6Is1H1mJc/12OaexooxaWs0y0mvSMYxM6kTlbb?=
 =?us-ascii?Q?c9wyBRxEB/7Y36VPZDNFxsg+uJ3IdI5iUN6OqibBjSMnos69UxMDZSb7/sWp?=
 =?us-ascii?Q?KOPgE6aan3rOVAByxPCKB2Lb7ANQr2qhzxd/zPNl0fT+4RMb07vdoD28wahj?=
 =?us-ascii?Q?ERUFuqDtSFk9J2bPrRm2l+ZztCRRjzfx+IZkdMCZFqQxhNR71zrmqpk7plpA?=
 =?us-ascii?Q?XJpSfAES0ekJ1XG7QWW16ZDgAP98vH/5B2jq1aU2EMIF2SZUoIHfGB641cph?=
 =?us-ascii?Q?9Js+dyHsGYAGB//mgMMhI/m2SHe/sGWez442C9OEZICYfP93LkRAIoOmnhD2?=
 =?us-ascii?Q?UOl6zvYYuOFvy7yGYh8=3D?=
X-OriginatorOrg: ipt.br
X-MS-Exchange-CrossTenant-Network-Message-Id: a22ff903-28e2-46ac-29b2-08db65f67fb7
X-MS-Exchange-CrossTenant-AuthSource: CPVP152MB5053.LAMP152.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 18:55:58.5032
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: aab57f47-5b85-4924-8047-691190100bd7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hUcs6vaxER17irXOntShElGhERPjBHaniIfUTlW/gmnR+pvP2gJO5KFCXbkrgfJC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CPWP152MB6145
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In order for the Mac Address Passthrough to work with the igc
driver and the Lenovo Thunderbolt 4 dock station, it is necessary
to wait for a minimum time of 600ms for the Laptop's MAC address
to be copied to the Dock. To avoid always waiting for this 600ms
time, a parameter was created to enable the Mac Address PT and
also another parameter to modify the waiting time if necessary
in the future.
This is an old bug reported here but never finalized: 
https://patchwork.ozlabs.org/project/ubuntu-kernel/patch/20210908084952.41486-2-aaron.ma@canonical.com/

Signed-off-by: Fernando Eckhardt Valle <fevalle@ipt.br>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 1c4676882..cc491e3dc 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -30,12 +30,18 @@
 #define IGC_XDP_REDIRECT	BIT(2)
 
 static int debug = -1;
+static bool macpt_delay_enable = false;
+static unsigned int macpt_delay = 600;
 
 MODULE_AUTHOR("Intel Corporation, <linux.nics@intel.com>");
 MODULE_DESCRIPTION(DRV_SUMMARY);
 MODULE_LICENSE("GPL v2");
 module_param(debug, int, 0);
+module_param(macpt_delay_enable, bool, 0444);
+module_param(macpt_delay, uint, 0444);
 MODULE_PARM_DESC(debug, "Debug level (0=none,...,16=all)");
+MODULE_PARM_DESC(macpt_delay_enable, "True to enable Mac Addr PT");
+MODULE_PARM_DESC(macpt_delay, "Ms delay to allow Mac Addr PT change to occur");
 
 char igc_driver_name[] = "igc";
 static const char igc_driver_string[] = DRV_SUMMARY;
@@ -6606,6 +6612,9 @@ static int igc_probe(struct pci_dev *pdev,
 		}
 	}
 
+	if (macpt_delay_enable && pci_is_thunderbolt_attached(pdev))
+		msleep(macpt_delay);
+
 	if (eth_platform_get_mac_address(&pdev->dev, hw->mac.addr)) {
 		/* copy the MAC address out of the NVM */
 		if (hw->mac.ops.read_mac_addr(hw))
-- 
2.25.1


