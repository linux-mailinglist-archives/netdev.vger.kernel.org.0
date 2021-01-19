Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD8642FBE2B
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 18:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390079AbhASRqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 12:46:30 -0500
Received: from mail-eopbgr80123.outbound.protection.outlook.com ([40.107.8.123]:42328
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389185AbhASPKA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 10:10:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nxLzz2wJcD1/Ma/4kycITRY0uBebqLk0kfzCx+wn2kJspTi+43A8muC8yEf92acUOTQnZhJLfywAQyYZDMIhFQ4Z8Ebk98STBEa8S0sE0A2RmYHwR2DbL0/DmDnmznZSr1a13iUS1neUZFRnv0YSg8mi2lX8iWV9a/LHYphwOIxv4QM0SZMMj7yZepXLmmLFk/hpvJi3FXMv7Uk7qoBVTIRp1rAtNpfDFLnvZCQMwAzv2Xb8MjlZbWM7V0ESElNAQh/9PUzMeF75xH2DMrn4vpb2sKVaY+vmweDlV2Eix41+iQ0v4KLImLrtO03PwxIV58+GAYDONSsnMz18kzGuFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=241boPmGQEBSlLK5BDGAA+vnueefBdcSSjqOawguRC0=;
 b=i5RbKOmtap3R3Uymim6ZlZp4SYIRkrIgHJpbyJmen7JAn45mAGDy6DvWGx8BjZmhJZPt78kiA9i5Z4eBzgX3Ns9HrVDef4MbrlHQvcvihFipU+Y6+P+Ptg2NJPQRLQlhtE0yipFDQwWjZG1Umu8bHfQzTIrqC8eAPDAxZ/IYNGc6ko19d0qaE6Me0OfLBjDdjEa16Q438k1BCBcku0RUudXBbxQay4KRsvEVXgPw3HNTUPv5DcYAUv+cPXAS6VjSbGvDz6N4GJ567CcQNP4fJZcfdR9mgGqJA7t2x6rRShTrkQkfYKkplAyn8dQ0vCVFG8okSJ9xKOQnOnEB4HN8xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=241boPmGQEBSlLK5BDGAA+vnueefBdcSSjqOawguRC0=;
 b=AnJsfKWTjr0R9zIYiUCuAXlyHJEqCX8TDZcGW7dGjMBGeB6HjOf6AeMhr+xmETuJkMkplPIgHbRFbg6DGqHlfhxVXz/34vgdcXjYsM0e9sDZTiGP5lHUDWlSnxKKwdFwd96xMTzA1y7ec+R95f/hb5bZP3p1X9pnkZpcPPQmn0I=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB1922.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:40::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Tue, 19 Jan
 2021 15:09:02 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3763.014; Tue, 19 Jan 2021
 15:09:02 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     netdev@vger.kernel.org
Cc:     Li Yang <leoyang.li@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Zhao Qiang <qiang.zhao@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH net-next v2 01/17] ethernet: ucc_geth: remove unused read of temoder field
Date:   Tue, 19 Jan 2021 16:07:46 +0100
Message-Id: <20210119150802.19997-2-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210119150802.19997-1-rasmus.villemoes@prevas.dk>
References: <20210119150802.19997-1-rasmus.villemoes@prevas.dk>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM6PR02CA0036.eurprd02.prod.outlook.com
 (2603:10a6:20b:6e::49) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM6PR02CA0036.eurprd02.prod.outlook.com (2603:10a6:20b:6e::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Tue, 19 Jan 2021 15:09:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 926a93b7-8268-43ff-2ac2-08d8bc8c2771
X-MS-TrafficTypeDiagnostic: AM0PR10MB1922:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR10MB1922D0DECDFFCDF0C6C1673793A30@AM0PR10MB1922.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XQa1+MZm0dQeWEpHGD158LVWWCq2zAODLIzEryXhldNm/4G6ENQPouoN+xMzau/41FTxnjMEY1t7jO7IVmc59cAB4D5qOHLp8g/cN6OPxgqhgr0D1abC4dPQLj/8ObmD3aA6B6BPig97GUWUdBW6KKC7Wn8FJRZhJE84yEIpT5Iw5XejN8GZkCFR1gsHLDbKzLzPI5fkRSXjYVDNTu2LUopaiewLuLbkfDpUcZAyvRP8toJzTp9nlFqiBQjDqaCPTfqolOKeEGOmbEKwvaJt8TpSzdP8nza5/Xl0G9jQV55XZzlC/JIkAUOZelE/PntYWLacxobIHipj9ZntGg6BavA+6rCBK8SMgfmp7mdVcibEd3Vv0kt+aBuzVN93dq739rIzv+pSL6OmONCfGpbDfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39840400004)(366004)(346002)(376002)(136003)(396003)(1076003)(186003)(956004)(2906002)(6512007)(44832011)(86362001)(16526019)(6666004)(2616005)(83380400001)(6916009)(107886003)(8676002)(26005)(36756003)(52116002)(66556008)(66946007)(6506007)(54906003)(4326008)(6486002)(5660300002)(478600001)(316002)(8976002)(66476007)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Da+EFG3LEqMwoU8Cuxf8uWUNFaFcWksO4eZDN1mflk971jgr7tafn6g8F1Cp?=
 =?us-ascii?Q?pHwFKmkQFoJiHXLZVq0to1vUsh51+ycawh56SURygDMsFvApag/HnN2DzBY2?=
 =?us-ascii?Q?hOe+hgdkEI3w7um24FLXuxDlpDk2H8g2PEIGXPIt1CZ4vSM+fZeQrugA7PLf?=
 =?us-ascii?Q?JCt2+XB88nR3TKqgD1dpKgRHHtX4dLhZorfTDyrmXQrx9uTNPjiwNau32d5/?=
 =?us-ascii?Q?Rz2kRK8qJ15dEIyA9Jqe23uMjgHYXw2hf3dv4V8mQQ9X1JFDBa4NRkdz2mQd?=
 =?us-ascii?Q?MUVnJ8Dep+cSCkxhszgupwZph/Wog+23eBECJrJ0HDL3db2melKRygAV8vXQ?=
 =?us-ascii?Q?3nUzw/4S5O8hqz9yUV8mqh3IWjGahH8bv5bM6DdnjRAO9LelE3SaKq2XuUlG?=
 =?us-ascii?Q?zhOowBRcfzJ7t3TQpuSg1i5v7v6qte6k0522tlY+3tq6Dyj2T5K4dgXTWvoe?=
 =?us-ascii?Q?hSaElDg8pQXvR8cM3vU6drpx0+BBoZN8ceCe4+59erodIBDj41aOqh/Nrxf0?=
 =?us-ascii?Q?ljz0uPLWTxQxOwb7pLbfIH4qWWWbWMq3fqGVyIaI2i7R5mbuhtC6jMPuiPvc?=
 =?us-ascii?Q?nF7KDYhZlhfkxgI1ZnLtgwXyrzkTT6acRHZKFdlBADMAtmxdiNE378OIvlWt?=
 =?us-ascii?Q?1gFgzyRM04B7Sz/k39KoADY4lIPDLBgdwR7JJkYFRVDYGjEG/2ExWwJJ69Xl?=
 =?us-ascii?Q?UIii0zFg8O3ATWYYreE1dDXeOsdb4xiM37wluruoa1EvmA8RH1goMtQo8oqR?=
 =?us-ascii?Q?9sAzEtGTODOlN8FrhK9QD18LRaLW3Bd3GbtS7j99GRMvRtnJYeLRkq1yFPxP?=
 =?us-ascii?Q?OXYLsa/+sYelr/WPsnfUY8eRcXdXZAB4dUxqa4q7UQHnE42AIvq29iFQCzwr?=
 =?us-ascii?Q?KRwnDDKQLdyYvf7Qj99w3X6oHB8QFIklKGNGgfiEzrRHstPh0jaSRmf9Wgyg?=
 =?us-ascii?Q?tL/CzdvMBt3cEHfACJud7+TOWMgExja/uY8XQxzlHfjSfIuF2SIsP3CynQqY?=
 =?us-ascii?Q?7IzX?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 926a93b7-8268-43ff-2ac2-08d8bc8c2771
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2021 15:09:01.8465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kY7EdJfSvVVL1rS42rpthEP/1rGvw6lUYBS6RNrfjCCkmZRFjRzDIXxsTJel3Qc39xwZ2eneoKMcJxvtJNp6ooE2hy9TU3MuS3f+GL5Mn9o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB1922
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In theory, such a read-after-write might be required by the hardware,
but nothing in the data sheet suggests that to be the case. The name
test also suggests that it's some debug leftover.

Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---
 drivers/net/ethernet/freescale/ucc_geth.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index 6d853f018d53..d4b775870f4e 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -2359,7 +2359,6 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
 	u32 init_enet_pram_offset, cecr_subblock, command;
 	u32 ifstat, i, j, size, l2qt, l3qt;
 	u16 temoder = UCC_GETH_TEMODER_INIT;
-	u16 test;
 	u8 function_code = 0;
 	u8 __iomem *endOfRing;
 	u8 numThreadsRxNumerical, numThreadsTxNumerical;
@@ -2667,8 +2666,6 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
 	temoder |= ((ug_info->numQueuesTx - 1) << TEMODER_NUM_OF_QUEUES_SHIFT);
 	out_be16(&ugeth->p_tx_glbl_pram->temoder, temoder);
 
-	test = in_be16(&ugeth->p_tx_glbl_pram->temoder);
-
 	/* Function code register value to be used later */
 	function_code = UCC_BMR_BO_BE | UCC_BMR_GBL;
 	/* Required for QE */
-- 
2.23.0

