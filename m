Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 039CB51EF55
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 21:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238560AbiEHTGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 15:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238817AbiEHRm2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 13:42:28 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2112.outbound.protection.outlook.com [40.107.93.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69570E023
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 10:38:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DBvjF3uUsXfh3Pm394TAWeyOadP4vYEdeL2I27nYcUDJJ851daeyWQjupWFvbbrFP4/ClOT6nxCJjrv5V+9H4o8WSElyVM6gc12Q2NQ9FsGr7mealPB0zalukImWh6YDeUg1cOkGYZU1SkssdtNQJrPxVsXHX+KY0jhm2ZUdE5ckvvuxiMOI9+IBiB4G/v6/PDqhAmEHkGoeDMsP6rHMx9s3s6X/4ZYC6MS3YQxZpk2+Ay0tbqjAY45MM9Ynw7w5krz3qNenO0/Sl7f2l9S6zSASK+oVtLxOhJN4g5jBwPRF8xkLpXG8gRC0Ev/bU0vZWaMZUh4FWU3TQLWWi2o+1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uUKvHjTF2j5WZo12Co1YtrpbhFudtVzDyYEatpiwweQ=;
 b=UN9nnPNkt6LQ9ZsE9G/2OI7HRe/rXjD6BLH7YWshcEqGuyb2xQzrSCOHL9Hxn55Xi66Ho78hz+qCKyR9wJasQny3aL67eYXdWGW1hF6p6DAkAiglE0UGg5HyRErznAs/3H6vj99YiHkbp7BdnfUv67ATnWlQzJdU28cxdOj9S70fMirjF7WysP9pOx9vRom6vlS2D5Hr8fVPN3pFlylNHOyauhdCcGD38L6toto4r+78mK1xSwDmocnqBlaUIsWkz1nsyT64e8LiIhQcdoVww4/+6aYpwDt9976HUl3i4BAB0y8N4bjoowHlOM1jjMIDFeLs4MzVJiF5iI39zaLMzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uUKvHjTF2j5WZo12Co1YtrpbhFudtVzDyYEatpiwweQ=;
 b=B/ShxvKFx3nbkaZCq4fXCpqcrkhQtLIVflRhutLbAdWOPsYEvk+1HgtpPVAp3g5poJivUeYkL8QlrPW5V9hdJ9DwBFqSJr9I+OJL0hzUh8t088n/WY2cJvelTlIP1MXfT43BG27DnNqFBUI2JT7VgnLf/N1mnt660qwWB0s8dVA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MWHPR13MB1200.namprd13.prod.outlook.com (2603:10b6:300:12::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.12; Sun, 8 May
 2022 17:38:35 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94%3]) with mapi id 15.20.5250.012; Sun, 8 May 2022
 17:38:35 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yu Xiao <yu.xiao@corigine.com>
Subject: [PATCH net-next 2/2] nfp: support Corigine PCIE vendor ID
Date:   Sun,  8 May 2022 19:38:16 +0200
Message-Id: <20220508173816.476357-3-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220508173816.476357-1-simon.horman@corigine.com>
References: <20220508173816.476357-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0P190CA0008.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da16b38f-7678-469a-de3f-08da311993ec
X-MS-TrafficTypeDiagnostic: MWHPR13MB1200:EE_
X-Microsoft-Antispam-PRVS: <MWHPR13MB1200BF44473A6AA7F91A644CE8C79@MWHPR13MB1200.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n8kT7YM7K6GUfnk73q5hVAclmGsRyWOXJZzmebNk1e8E0zLHB9+cR+uvSnfg5b4MLP1N2Z3g+wsTx8DlCtj6L500ykFXs1N5JhnoCw8I9y9DuZS7W7zb4PZgdro0Si3e4gGzdVl+YLV8KBmZpA+mx4BbU3qhkKtQCcp1mOunXwJXTuCzzuf0XCE7sL1vPiqIffNvArkU1E8kxD1NGA1O3VypTKC8vcCJGiLmg9yGvM2eSKqO+cyQt0a1nJcrNnSlJsCvxmtp4X67i1KGWmn/7LG75V/8KZpdcHW9kPIYy9OpBSxDiwMa6JJw+kZncAXM30NcOtAuFSGReo+MZ2DpbsxAVZpt2F4/b/49ntvqN1A08N644SvPCBtwjV5R00nFx0i2jX0+ljA5c0ytPPhFK57bXrKcopG1zGnk+YJmJxxuk0DI8BRgp6DhxVlp357k9wSStLMb33aVlDkeDY4y6qEkBm660gnr6/ptUhVjHKGiQVc3Cnm2ht2fsPrZNR+92THbptrBdbVXZ/ZJntv1gNo7IYqoE7f6rngSIqVhuxF1JRqi9KXdBuNgy9pP1iKS6CMad/CGU5HZkBCq4Lt127hYz1tBneoy5b3t1DCX4994vvmJGBfpFgHxKejjjNxkj2fbr5d+ZkK+pERPXG4TJd03sdjYvtl+R6nPFJyUg7ZUeeib9z500L+Tw56APfVS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(136003)(346002)(376002)(396003)(39830400003)(2906002)(36756003)(8936002)(5660300002)(44832011)(8676002)(66476007)(66946007)(66556008)(4326008)(107886003)(86362001)(110136005)(83380400001)(1076003)(38100700002)(6486002)(186003)(2616005)(6506007)(52116002)(6666004)(316002)(6512007)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IA4gF5Zbq1qxMzQ01VHScd6zSbTs0Wmds/OQwTT1pAnwfYh8YAw0OK1lexgR?=
 =?us-ascii?Q?NKJXrmBQ3tkK8HbD1m1r727O/zQUCDruA4e98uNy8SFV2zBIXUUs2G6jIedZ?=
 =?us-ascii?Q?ht2jg5Tl6DIpIWWcpvNe6hBkn7ohGTgwU/kO1TPcd0BsRoF0LvWlUhdyJ5v7?=
 =?us-ascii?Q?LmMl4/2QqG0IhesxrGBjaIGbT3PeuFLOKyXG417mUuUXkLKjlGkLHaeUBE4o?=
 =?us-ascii?Q?oxAdkPkfjt1CZv40K1z3AKkRO6us8k85hH7DD/dnC/mCDDuS8+okKDw4SypL?=
 =?us-ascii?Q?P1Gl/ondCVUIL0wa7Tqvy7BkR3L2sHpoKXAXnjTVYqblrJGkBBNYyGG+ZLH6?=
 =?us-ascii?Q?JhuBHB4XXPEaMsu35NJoFuOz4H7t7wvBT5lIS8VPvkLagFu3pE79RUWnv4k2?=
 =?us-ascii?Q?amIXljUVxYQ1bIi/NM8tHOIqT0gbeIcKMyFYYN4sGNSvugkAgODROYZNP3ak?=
 =?us-ascii?Q?6LiddxGv9FjGdNlm1i6zxTtvGBkNJSwVOzKmRtfpT98fbq3GUOVjBYfdX9e8?=
 =?us-ascii?Q?5nj28y/sf48DKmLXMEzMPdYKaciMfQYz1TPIxnxjX3K0Mqs/8yu5+vkGooMj?=
 =?us-ascii?Q?F996J9ip7q/3lGnENWX8Wqjs8X9Fyhdg6+b43ACaoO5gwWi8C4+GfGRGk89m?=
 =?us-ascii?Q?0OjSJUiBjwwvxLqEbKrOB1zQVGsMQIbM2MvWBWe1apy4SOj2zfsPa4EkT4tA?=
 =?us-ascii?Q?ESV/ux+dBe49oeS6lF2UITIsfD0DSDZp85cM/zTiYZvWiNGQuvLo5urQhwpy?=
 =?us-ascii?Q?7pSvUbZwiTeh48D7lZpAkGIlf5LP3SjsFC6CYrmhwGyLiBo5ISQbOmRl43OR?=
 =?us-ascii?Q?BTUF13D1qBO4i/yZCdZV3/r/vqaNA8zUs0fqcuSEGm2PNfdEQbvlJ5WwInfD?=
 =?us-ascii?Q?/hFgOhUdDgd09f1reXyE2gbEvxfJqwFP8ktUX/yvpGg8tsx6GN80yOoHpiVW?=
 =?us-ascii?Q?XrN++Q+EmRJYge/chzp/BNP2tB5r5dP9tDCWyg4P90EJON6Smhu8bj8orhz5?=
 =?us-ascii?Q?L7mnjJxSKEMswyDi3SyrXbYrIn9EpzzgsMhqhwvVDScozSISt46H/cHWpDeB?=
 =?us-ascii?Q?QWhgFyQZCnMWWvYCy5Q47ia3QKnvAVhjZVcnVf/A1rqRZ7+ALKSWXKYL56V9?=
 =?us-ascii?Q?iS/mXnRSqEo/dOL1+YLJaU38BGNAbV8LQ85/uf0nCROdn5S72K+mwoiVkss3?=
 =?us-ascii?Q?nPZKSlAI88OP79ylT3DGc96hrsAQcHEZtNO8OLhUy6MRvoZu/Dip1Y9knAWx?=
 =?us-ascii?Q?ikpLPaFQiDgl8qXkgUhddY/9PJXJdCMzIRhnyxdjSzx0g4tdzsr5k9N7yHRW?=
 =?us-ascii?Q?eZ0qmnEiILnA0YcEG72wSR9+McFVuHyrfbzXZv3XgS5yONF9j7WSdzqN0Dai?=
 =?us-ascii?Q?ddkQi2uWZJbNerTYoKDicQt1r39VEf7YfU35rQzD6JZ6HqFT7YnbmwKdgfBu?=
 =?us-ascii?Q?CWFgnOItslyAS2Hi2EaTwfE7hi65q7sTiu5tJhKzcN2sS35q+a80Ihs9MCwY?=
 =?us-ascii?Q?nRxwo8ydthmdJg1NjLbWVgbKd6rVVJsECyv8QGsOAILMdtDHd1uh8qhccW9J?=
 =?us-ascii?Q?VFVhrNJJvxBWtJ1DAZktg2JP4wne47hAJw5hcIApx3LdLrg9AeDVAYrOByqC?=
 =?us-ascii?Q?povbcpYaYtl6WAMzRSEzI+z1xInPDkihq315G0FEOX4abyz8Ydw4fumog9mS?=
 =?us-ascii?Q?/ZIOJ0mdaFPI8cgWS2Uqmo8oMUTcsx9gRWZMgUwF50wY662AyKujalp0FoBK?=
 =?us-ascii?Q?ia5PGDd3J5Rf2SmveIQh1+VncpnYyX76MTZK6HEebiqjp3tVla4Y0wyt/2ht?=
X-MS-Exchange-AntiSpam-MessageData-1: Z3ePSXN1NrjmA8fI0QRXCA5QWOj/PdVhauw=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da16b38f-7678-469a-de3f-08da311993ec
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 17:38:35.3470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DltWZq1wHMvhtrlS7MgbH3cyDGwTKfKLus+c7PJx7+FsZ6bSMju6ekaNAemsiMu1vftRdMOr7twycn9eyB1AttPDWGQCc6g8G2QfhKp+5hM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR13MB1200
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yu Xiao <yu.xiao@corigine.com>

Historically the nfp driver has supported NFP chips with Netronome's
PCIE vendor ID. This patch extends the driver to also support NFP
chips, which at this point are assumed to be otherwise identical from
a software perspective, that have Corigine's PCIE vendor ID (0x1da8).

Also, Rename the macro definitions PCI_DEVICE_ID_NERTONEOME_NFPXXXX
to PCI_DEVICE_ID_NFPXXXX, as they are now used in conjunction with two
PCIE vendor IDs.

Signed-off-by: Yu Xiao <yu.xiao@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_main.c | 30 +++++++++++++++----
 .../ethernet/netronome/nfp/nfp_netvf_main.c   | 12 ++++++--
 .../netronome/nfp/nfpcore/nfp6000_pcie.c      | 16 +++++-----
 .../ethernet/netronome/nfp/nfpcore/nfp_dev.h  |  8 +++++
 4 files changed, 50 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_main.c b/drivers/net/ethernet/netronome/nfp/nfp_main.c
index 08757cd6c7c5..4f88d17536c3 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_main.c
@@ -33,22 +33,38 @@
 static const char nfp_driver_name[] = "nfp";
 
 static const struct pci_device_id nfp_pci_device_ids[] = {
-	{ PCI_VENDOR_ID_NETRONOME, PCI_DEVICE_ID_NETRONOME_NFP3800,
+	{ PCI_VENDOR_ID_NETRONOME, PCI_DEVICE_ID_NFP3800,
 	  PCI_VENDOR_ID_NETRONOME, PCI_ANY_ID,
 	  PCI_ANY_ID, 0, NFP_DEV_NFP3800,
 	},
-	{ PCI_VENDOR_ID_NETRONOME, PCI_DEVICE_ID_NETRONOME_NFP4000,
+	{ PCI_VENDOR_ID_NETRONOME, PCI_DEVICE_ID_NFP4000,
 	  PCI_VENDOR_ID_NETRONOME, PCI_ANY_ID,
 	  PCI_ANY_ID, 0, NFP_DEV_NFP6000,
 	},
-	{ PCI_VENDOR_ID_NETRONOME, PCI_DEVICE_ID_NETRONOME_NFP5000,
+	{ PCI_VENDOR_ID_NETRONOME, PCI_DEVICE_ID_NFP5000,
 	  PCI_VENDOR_ID_NETRONOME, PCI_ANY_ID,
 	  PCI_ANY_ID, 0, NFP_DEV_NFP6000,
 	},
-	{ PCI_VENDOR_ID_NETRONOME, PCI_DEVICE_ID_NETRONOME_NFP6000,
+	{ PCI_VENDOR_ID_NETRONOME, PCI_DEVICE_ID_NFP6000,
 	  PCI_VENDOR_ID_NETRONOME, PCI_ANY_ID,
 	  PCI_ANY_ID, 0, NFP_DEV_NFP6000,
 	},
+	{ PCI_VENDOR_ID_CORIGINE, PCI_DEVICE_ID_NFP3800,
+	  PCI_VENDOR_ID_CORIGINE, PCI_ANY_ID,
+	  PCI_ANY_ID, 0, NFP_DEV_NFP3800,
+	},
+	{ PCI_VENDOR_ID_CORIGINE, PCI_DEVICE_ID_NFP4000,
+	  PCI_VENDOR_ID_CORIGINE, PCI_ANY_ID,
+	  PCI_ANY_ID, 0, NFP_DEV_NFP6000,
+	},
+	{ PCI_VENDOR_ID_CORIGINE, PCI_DEVICE_ID_NFP5000,
+	  PCI_VENDOR_ID_CORIGINE, PCI_ANY_ID,
+	  PCI_ANY_ID, 0, NFP_DEV_NFP6000,
+	},
+	{ PCI_VENDOR_ID_CORIGINE, PCI_DEVICE_ID_NFP6000,
+	  PCI_VENDOR_ID_CORIGINE, PCI_ANY_ID,
+	  PCI_ANY_ID, 0, NFP_DEV_NFP6000,
+	},
 	{ 0, } /* Required last entry. */
 };
 MODULE_DEVICE_TABLE(pci, nfp_pci_device_ids);
@@ -681,8 +697,10 @@ static int nfp_pci_probe(struct pci_dev *pdev,
 	struct nfp_pf *pf;
 	int err;
 
-	if (pdev->vendor == PCI_VENDOR_ID_NETRONOME &&
-	    pdev->device == PCI_DEVICE_ID_NETRONOME_NFP6000_VF)
+	if ((pdev->vendor == PCI_VENDOR_ID_NETRONOME ||
+	     pdev->vendor == PCI_VENDOR_ID_CORIGINE) &&
+	    (pdev->device == PCI_DEVICE_ID_NFP3800_VF ||
+	     pdev->device == PCI_DEVICE_ID_NFP6000_VF))
 		dev_warn(&pdev->dev, "Binding NFP VF device to the NFP PF driver, the VF driver is called 'nfp_netvf'\n");
 
 	dev_info = &nfp_dev_info[pci_id->driver_data];
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c b/drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c
index a51eb26dd977..e19bb0150cb5 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c
@@ -38,14 +38,22 @@ struct nfp_net_vf {
 static const char nfp_net_driver_name[] = "nfp_netvf";
 
 static const struct pci_device_id nfp_netvf_pci_device_ids[] = {
-	{ PCI_VENDOR_ID_NETRONOME, PCI_DEVICE_ID_NETRONOME_NFP3800_VF,
+	{ PCI_VENDOR_ID_NETRONOME, PCI_DEVICE_ID_NFP3800_VF,
 	  PCI_VENDOR_ID_NETRONOME, PCI_ANY_ID,
 	  PCI_ANY_ID, 0, NFP_DEV_NFP3800_VF,
 	},
-	{ PCI_VENDOR_ID_NETRONOME, PCI_DEVICE_ID_NETRONOME_NFP6000_VF,
+	{ PCI_VENDOR_ID_NETRONOME, PCI_DEVICE_ID_NFP6000_VF,
 	  PCI_VENDOR_ID_NETRONOME, PCI_ANY_ID,
 	  PCI_ANY_ID, 0, NFP_DEV_NFP6000_VF,
 	},
+	{ PCI_VENDOR_ID_CORIGINE, PCI_DEVICE_ID_NFP3800_VF,
+	  PCI_VENDOR_ID_CORIGINE, PCI_ANY_ID,
+	  PCI_ANY_ID, 0, NFP_DEV_NFP3800_VF,
+	},
+	{ PCI_VENDOR_ID_CORIGINE, PCI_DEVICE_ID_NFP6000_VF,
+	  PCI_VENDOR_ID_CORIGINE, PCI_ANY_ID,
+	  PCI_ANY_ID, 0, NFP_DEV_NFP6000_VF,
+	},
 	{ 0, } /* Required last entry. */
 };
 MODULE_DEVICE_TABLE(pci, nfp_netvf_pci_device_ids);
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c
index bd47a5717d37..33b4c2856316 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c
@@ -621,13 +621,13 @@ static int enable_bars(struct nfp6000_pcie *nfp, u16 interface)
 			nfp->dev_info->pcie_expl_offset;
 
 		switch (nfp->pdev->device) {
-		case PCI_DEVICE_ID_NETRONOME_NFP3800:
+		case PCI_DEVICE_ID_NFP3800:
 			pf = nfp->pdev->devfn & 7;
 			nfp->iomem.csr = bar->iomem + NFP_PCIE_BAR(pf);
 			break;
-		case PCI_DEVICE_ID_NETRONOME_NFP4000:
-		case PCI_DEVICE_ID_NETRONOME_NFP5000:
-		case PCI_DEVICE_ID_NETRONOME_NFP6000:
+		case PCI_DEVICE_ID_NFP4000:
+		case PCI_DEVICE_ID_NFP5000:
+		case PCI_DEVICE_ID_NFP6000:
 			nfp->iomem.csr = bar->iomem + NFP_PCIE_BAR(0);
 			break;
 		default:
@@ -640,12 +640,12 @@ static int enable_bars(struct nfp6000_pcie *nfp, u16 interface)
 	}
 
 	switch (nfp->pdev->device) {
-	case PCI_DEVICE_ID_NETRONOME_NFP3800:
+	case PCI_DEVICE_ID_NFP3800:
 		expl_groups = 1;
 		break;
-	case PCI_DEVICE_ID_NETRONOME_NFP4000:
-	case PCI_DEVICE_ID_NETRONOME_NFP5000:
-	case PCI_DEVICE_ID_NETRONOME_NFP6000:
+	case PCI_DEVICE_ID_NFP4000:
+	case PCI_DEVICE_ID_NFP5000:
+	case PCI_DEVICE_ID_NFP6000:
 		expl_groups = 4;
 		break;
 	default:
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.h b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.h
index d4189869cf7b..e4d38178de0f 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.h
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.h
@@ -6,6 +6,14 @@
 
 #include <linux/types.h>
 
+#define PCI_VENDOR_ID_CORIGINE	0x1da8
+#define PCI_DEVICE_ID_NFP3800	0x3800
+#define PCI_DEVICE_ID_NFP4000	0x4000
+#define PCI_DEVICE_ID_NFP5000	0x5000
+#define PCI_DEVICE_ID_NFP6000	0x6000
+#define PCI_DEVICE_ID_NFP3800_VF	0x3803
+#define PCI_DEVICE_ID_NFP6000_VF	0x6003
+
 enum nfp_dev_id {
 	NFP_DEV_NFP3800,
 	NFP_DEV_NFP3800_VF,
-- 
2.30.2

