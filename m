Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86E8047D8D8
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 22:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240349AbhLVVfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 16:35:17 -0500
Received: from mail-eopbgr150044.outbound.protection.outlook.com ([40.107.15.44]:58757
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236629AbhLVVfQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Dec 2021 16:35:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cD/v7IIGpOqfEkBAcX2RRlU9wqA5jatlvrmd08TYyQUNZlF42jcaecMLaBD/1gVraJKDEoQ6Ob7PwEy5vHmdC4jmANcdWDGVOkq3fPPLB54M5V6FBW2vC25HQKXZdwxfGPPYs4vfkiD2finAmM6Db79JdnY5eP5dnQLaHVK5Dg17EJSc0PRj73eZMYe01Qder+4gn4VsnbWb4wMEWvUh8AN7ICwsyrfAUzQFtu9yFWCQ5sNXP/NdfbiOCSmhW/K1PVJ2riuXZP8lU2mBnv8sT6Z1/TB4o4cZtHLxSdhRaHK6eWE+Qx9ytH0bjkQHAtl8NqstsjEN+4Di6k4dJX052w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oNdwEqdA6rooVIbcBuuBjcFMtFqmRwT1mKyGqidKSmc=;
 b=izOVuirqx6J5CGucG1UShFlFM+h6Qp/6AzVzRK2anEtxLGw4Zi+fG6aw1d1NIEUdj59mqsELy9IsVCOiNf6NDmb+y/JUSlQb7p1+L25qER896+zg78EJirZDZbaQCJai3NdZgDfOib5Bi+plbDRJc9BGkHi63RZtNfoIp12DY5a9ye/Lc4fzdimFdxcwFU8Q6b6DZxD2Np5VtO3i4uTUfvby+XZpsBf/Ylkf+D4U1ZgD6w1Os8u4nGCKEW5Afu51i7obKtfCW6D/V9eOS/mLnforsizp/ZjNca8oJrbM2lmuS5e+2cw1oeipw3/HxZfHVCL3Ewk9t5B0Ug/vhPeCCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oNdwEqdA6rooVIbcBuuBjcFMtFqmRwT1mKyGqidKSmc=;
 b=CdMrb5dCn2v8ngNaD7C7EBCb/sXlC9w/LOZp/gtf2J2BJKzhQuXnkfpIF8FXWdGIQG/p9UBu3o4lfklwVwLsS6dNqf4vnT8DR1Yngyxma6J7trye46vqa4BdZvuIaHczSeX3FAuSsmT0nTHhSpgtrLJ/kW7XPqLK6+N8CTgjYlc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by AM9PR04MB8732.eurprd04.prod.outlook.com (2603:10a6:20b:43f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.16; Wed, 22 Dec
 2021 21:35:12 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::1109:76b5:b071:7fce]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::1109:76b5:b071:7fce%7]) with mapi id 15.20.4823.018; Wed, 22 Dec 2021
 21:35:12 +0000
From:   "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     christian.herber@nxp.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        richardcochran@gmail.com,
        "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Subject: [PATCH v2 2/2] phy: nxp-c45-tja11xx: read the tx timestamp without lock
Date:   Wed, 22 Dec 2021 23:34:53 +0200
Message-Id: <20211222213453.969005-3-radu-nicolae.pirea@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211222213453.969005-1-radu-nicolae.pirea@oss.nxp.com>
References: <20211222213453.969005-1-radu-nicolae.pirea@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0100.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::41) To AM9PR04MB8954.eurprd04.prod.outlook.com
 (2603:10a6:20b:409::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 342e9fec-4ead-4787-5248-08d9c592ef35
X-MS-TrafficTypeDiagnostic: AM9PR04MB8732:EE_
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <AM9PR04MB8732BB75B4A470EB021911D29F7D9@AM9PR04MB8732.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jVGtTXsm3goHFXi6EqEEgoTbLhuBuqQF+UVUPNB9YGVFW97TvKDYXu4GkyQeRpMAKbaIgLqsQL8BfGn7/P+VftNhqJ0OG0/0bEDw0uvJR4il38U+1/E5Kcv/ljpsvWStTq1MIvr1Wzb5OHX2J8zTsK/bIGUyz089/EBSbmYVpRa8CwLXCQhJQTBSQ/KGcRKf4dKau+8RlaCKPxBDpeaZu8dfvWCOS0rb8xFEEcMKdne1app27CwyGCFHaOzgZSfjVjcS/1dw6Zh1XfDNmm+VBe6piAAZk8n1+Ir1aCLZx+nMmclcM7EOZeRBItEf5jQJ2ctaXl8OKpw7Bt2hc5dz6KDa8uLfsOB1pT9uEixlpB4VfxgNGse/zSPU/9jm92KTS7nvUmFRQNE336Rgj4i7PU5dspvOVNQ/zxtwmYb0OLLyuADIf7xC6f6xtV1rlWGJWHH8rG3BkR1utKOaNES4pPerhCryBPHfoEAt2y3jRgya9QwxD6rtyml+urHg/OT2xlRU7+BAcGYKopU21JoRbKjMyF9XCCceN/MKbbUJWk69Sy+8759iLj6ZH4597QQsgmA/3644p198G+Ak04KI2vAc/a5+xLMs/3jc5mKFSdHyUL9Y9a3rtj/rzWuKNk/K2oDcKdJ+6qk5cTai+piEZFOYcJXzLjErHT+nkMNM0Qrr//yH1uWDjXwkVWVNYkEBAOv7WfKkUIrCPrFP1w1KVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(5660300002)(26005)(8936002)(6666004)(66574015)(8676002)(186003)(6506007)(66556008)(66476007)(83380400001)(316002)(1076003)(52116002)(508600001)(86362001)(2906002)(6512007)(4326008)(2616005)(6486002)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SEHRJqgddDLfkABQRDkrkXOUP1MLsQU9hNJoyuU8ZgmAKmvg1kVnOg/9foiX?=
 =?us-ascii?Q?4sSyYzmRKcDwie6IBuy1u+Hd/aVSpTkqSKQD8BpxMqxnkje/bplmkgbpEvZA?=
 =?us-ascii?Q?g02u0bjKhp9aloOgfaGSiueoLluWVnUVUlFdmyWWm+HZM9Yb6CABEnE5HR5N?=
 =?us-ascii?Q?CjRtotjb35+Fx3SJtELmJfJfqdEpqB9wXr7olAuii7hQcQWAQq8aN2QcpdD7?=
 =?us-ascii?Q?pS1giUqQCLy08diIfriP7iHM5nQ9yph+ZdyG4SEN8qnfJUU9+i+X4YBynwZX?=
 =?us-ascii?Q?sG80/ZwpTK5ZDklN7+gInt/bbqXVD6riTPy7f/gA9uYjInEQZFFiR8W49UTU?=
 =?us-ascii?Q?nWJpu2GeD4zyE6zUby6XnfbN2GPP0RMaoLteuKpKksy6FGOolBFkw3SFlOJG?=
 =?us-ascii?Q?qMUIalJR3tx78UxNv0bk+s0az4nJZ/MDGFYPzgUUhuG4EJvYokxjLlGjXz8c?=
 =?us-ascii?Q?hqgtejtg3nB9VXH3OzMypK59cKcb1OecTOTs/RAD9F1n6b7dc2eGwnyaCs7T?=
 =?us-ascii?Q?Zsm+lhXfXMxr7VnWqJbgpm3zQ1EJSdjmq/Verm4q8B6t5CUCUw6ycUKybcLF?=
 =?us-ascii?Q?/OiPLY0Md+V8NuDFuAj9yV67Fcmrfn2KJ8O5/OGZewpRssXvFkDlizsZtWCB?=
 =?us-ascii?Q?6F0F1YmjICsPnjBaJE4ZS5jck2oSnNKnQTz6KGIAUW2Bv/5X4LuV4+uNvrov?=
 =?us-ascii?Q?48lUXwH5SDaccwbZ6pDqvPNVUqZoby5leAIXh6BXrw3tb89KysRRBCtSxu4Y?=
 =?us-ascii?Q?phZLVuQZKtnslagxXhJT0mSC4DoZPma5Yk9WGABUKKCVg8IE+/kFl74+xp3p?=
 =?us-ascii?Q?cRX38bllepH13VblJmQaqFrr2JEiKTw4cNSmy+yXWkvZlH//Ock2nlLKo4EN?=
 =?us-ascii?Q?QcvGKV6L8uYNEejFTfyEOxSe87dWm3m4t6xa4GFiDT90TVrLonIW5MZqYCd2?=
 =?us-ascii?Q?gE/zbfZRbgDR3L5QFiL/WSJOKmszBvv20m0LT9jyFnAMy0JSl/R5G4EGFmh+?=
 =?us-ascii?Q?KANvnDLPcp9LBknZifvd/2kUF9r/FPQjro3zA8NQduD+H0I9huHSX369KZtl?=
 =?us-ascii?Q?FJS9reK4DXMkb4Qux67hPQUMkVDvkz32CW7m9Ho2PtUPim40WB6cChn29lEe?=
 =?us-ascii?Q?2vbGJpWDR6NJ5tfCB5g5tJvhwsNo+OXSr99E9nq1m2lPBftYq+vJFn/KP7VK?=
 =?us-ascii?Q?NXZrPFiKOPaiiqNwZPUpD3mjJ7v2LA4clf74omRbczdLsMDQoDiPHPkhatN2?=
 =?us-ascii?Q?o2Q2gPuBrSFEL7SuYoDof7e3AGfdZbfgKRUgqHMFlpswfrQjlIJmLWDVeARR?=
 =?us-ascii?Q?GvipuBktPDOlUk51DdD6AeD6KFrNwalmbGD7oFA6sxNTN0mPyTK3tAR1+j5b?=
 =?us-ascii?Q?cj2TYWmA7VLqvgH8jo0dD4gRwus5ICNMeQAB3HPxVHzj/OqanXqVud0YZa7R?=
 =?us-ascii?Q?/vovF/q3z+dTEj2F7IjBFgCK/jMX+yzF1007/9ZRGBHe/rCIQ66L5UTfHZNM?=
 =?us-ascii?Q?no20n+vOeKmns9uKPJ+uQBGZ9Woomvz9+vA7N9zQQTDG5KPvjJcYM6l6YgzD?=
 =?us-ascii?Q?ybGX3KHBlJDXpL3AXJW7E73Y5SxZE9unk8DS7Tft+zPvdNwENpM90D/cR+Ee?=
 =?us-ascii?Q?z4+OqVhxqbEC6CeCNBcrRdRe0ZxeV8mZkVd/ghfw3mGAJzdJ9jSL6f9rSKeH?=
 =?us-ascii?Q?S2yhzdpLDf07JQsprkgTaxw18zI=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 342e9fec-4ead-4787-5248-08d9c592ef35
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2021 21:35:12.0046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0Ylf55q2OV5gwl6CGkVGkm/OmvWvvTIzdtgluk7Z0+eHerZYXwHbsMiftNC7e8sot43EPF+fycIbKN3vGw7uW6oKg9GQd6j5g9J9soItT08=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8732
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reading the tx timestamps can be done in parallel with adjusting the LTC
value.

Calls to nxp_c45_get_hwtxts() are always serialised. If the phy
interrupt is enabled, .do_aux_work() will not call nxp_c45_get_hwtxts.

Signed-off-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
---
 drivers/net/phy/nxp-c45-tja11xx.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
index 06fdbae509a79..24285a528fec9 100644
--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -216,7 +216,7 @@ struct nxp_c45_phy {
 	struct ptp_clock_info caps;
 	struct sk_buff_head tx_queue;
 	struct sk_buff_head rx_queue;
-	/* used to access the PTP registers atomic */
+	/* used to access the LTC registers atomically */
 	struct mutex ptp_lock;
 	int hwts_tx;
 	int hwts_rx;
@@ -386,7 +386,6 @@ static bool nxp_c45_get_hwtxts(struct nxp_c45_phy *priv,
 	bool valid;
 	u16 reg;
 
-	mutex_lock(&priv->ptp_lock);
 	phy_write_mmd(priv->phydev, MDIO_MMD_VEND1, VEND1_EGR_RING_CTRL,
 		      RING_DONE);
 	reg = phy_read_mmd(priv->phydev, MDIO_MMD_VEND1, VEND1_EGR_RING_DATA_0);
@@ -406,7 +405,6 @@ static bool nxp_c45_get_hwtxts(struct nxp_c45_phy *priv,
 	hwts->sec |= (reg & RING_DATA_3_SEC_1_0) >> 14;
 
 nxp_c45_get_hwtxts_out:
-	mutex_unlock(&priv->ptp_lock);
 	return valid;
 }
 
-- 
2.34.1

