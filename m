Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F76148B9B9
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 22:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245377AbiAKVfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 16:35:13 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:12394 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245368AbiAKVfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 16:35:07 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20BCxNPp017415;
        Tue, 11 Jan 2022 16:14:33 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2055.outbound.protection.outlook.com [104.47.61.55])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dgjrs97yj-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 16:14:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CqZssIal8dmzw97AFkxTdgRuBH8kXdLY8/822a8cVIcKWWrldJqljd5N8n6fZODYavxPG2Py1csUG0ZQsnWjdnpkub0kEvl0sryqR5ew9OqEamCOLs/aXia8a0KS/sK8MgdKruLYzOPOnUbgTCqe/7W3j/bm5LkPmfGgcsKO88/wL637M+cpmRjn/fiOIPPGz7mQ5BBe/6H6wQaA4upQeyDGP5FL0pj0zQYv/sz7q7oYt+SaaHHbZpxIW9UwfbEUPTJsxKfEn8yz0BfsThaaQl6hb8uavAa02fT8uGIjYQYa7mnrestGtTraxV77Mc2Pc5rp6i5FwylmlEZVN+mC4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DeicbdEHGQnBrz9PhpHkqIG6ypNQL1pi4vlQgh4CCJM=;
 b=aXDixZ+PuEtV+OQD4A6wMk4pmQFJpl8toxnBcOKwGiwVF2vKHEy70bOM7S1eYdVvV4bWtm96hkFOM+2D3m7p12sicuFvPRxXuAAX2LT1T2rnZrAP58Szh2aFpYj7NKcx2YdiQcYotNPcC2+4f3sRrEau/n5qD/qiYUNUoaKMeFHWT92c9DldviHZLQZycFBlwlYLRjyzuuGkpXl/YJ1AA7yH8jmiwnuevAjl7fmIQkzl4+3zRo7wBfpLfbQlBL+DFb0jXFyFv+w0eWOc7CSrkIh97FUdNqMNAtsbs4nySqRiJq6CTPKQMYuRIF40eA9CIqntXDQNQdjbiMVwIRdhwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DeicbdEHGQnBrz9PhpHkqIG6ypNQL1pi4vlQgh4CCJM=;
 b=0C3m2JR305Dc/jqwlQ37tJCepF/V4DqnuNBz5EMNpXwuPNBssvSRLFN7waKEeljX6DAc+9J0qO+SeA9ALqyWy/TV0ZhAYLrWtDfqckLX8gYeGzeh3MqElLEPq8QTm7U3aL0q5ufgVbAvM9JoQ1wRL4alyY08Tg7ZBB36AOv3LU4=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT3PR01MB9218.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:a0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.10; Tue, 11 Jan
 2022 21:14:32 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::d1f6:d9e4:7cc7:af76]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::d1f6:d9e4:7cc7:af76%5]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 21:14:32 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net 7/7] net: axienet: increase default TX ring size to 128
Date:   Tue, 11 Jan 2022 15:13:58 -0600
Message-Id: <20220111211358.2699350-8-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220111211358.2699350-1-robert.hancock@calian.com>
References: <20220111211358.2699350-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR07CA0049.namprd07.prod.outlook.com
 (2603:10b6:610:5b::23) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 016c2da0-c8f4-48a0-48e2-08d9d5475c6d
X-MS-TrafficTypeDiagnostic: YT3PR01MB9218:EE_
X-Microsoft-Antispam-PRVS: <YT3PR01MB9218F9E614EDCC14FC57DE0CEC519@YT3PR01MB9218.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K8/3TEk3QuHrb/BwMYaazDy7OOfj8HJ8cQXP3S3mqS0jyfueP00cPjiEOqenoh5YSiKLyxByZaCkU8m6OQJJkwTARy2r+PjZB+gTlTZPsO5JxoLhvAKTO9HZU1SxsFJsdPHskXweNfslT0kSu5s0LG87AUTXtlaQcE02YaXatUIjZTaBkyc2fM327zbo1DHGMAIFftOX+tWW0ePUofIBXQlP3fQIuVQct5h4Ct0ynNBqg4dE4ogzg2uUcXBkmvFHeqizx8CikktTE5OPiqj2dwsYrr5lZWkiRJLPyQ81iprQI8CNb/19RmntYNWsruJArKk6hbsERgqZcFviLR+NLc3uZ6PJjyFG4i52VkKO1/pSbmfyF6hSQK8vzBXWG1f1UcFMKtahEvkKo1TgkkRzIcKf3LCNSf2mdgabNYYiW2r6wLWLI6luKWQFpCPOl9irOHg/+UHCxXqvJv6SXwY/qfSq/XI/MuMdVV/X9Sb1DNcNAsky/ZRvnPt2b2T602T4LfJ57LV58VSWaIjR0zWQQk1PIwoCrE6lVAYE25IhYJ+31om4aKoVIm0M1+hm62xMbkwuQBiGvEa5URiWnLZJrZtsxa9sTgS73H1sVdiloaogGbg55H3DVe+/X8nYYEgp2QkEmN+1ssvMiJRRuiBms6SJ3ePu1a1eyUfdenGGWfxO+lZ+FZAk7vPBU2gkWSePaOnQaAMTEDkQ4HKCMPwasw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(66476007)(66946007)(52116002)(6506007)(86362001)(38100700002)(26005)(186003)(44832011)(2616005)(8676002)(2906002)(1076003)(6512007)(38350700002)(36756003)(316002)(8936002)(6666004)(4326008)(508600001)(5660300002)(6916009)(107886003)(6486002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?whw9uyEst99Blkl17S9zSPgvU4E4AWz+4ro4JetE7gO2C7YHduuoa6zoqYM8?=
 =?us-ascii?Q?1kgwKSnzZ66WiaunPaQ1RncNvEHGE4QBIO281Wz+fznlnhQ7uGvuXCwa5+hc?=
 =?us-ascii?Q?Illl9DqtvXibFnIQaba6AIJDDbqJnBaID32C6CvPIMMJiHX9bMoz7oFsV2B+?=
 =?us-ascii?Q?logLUeiGI7xVUdR++gsCTuO73wVMLAag4f+TPcRniikir+TYgwrZM72BHJN6?=
 =?us-ascii?Q?IHma05cMiUzNF11NprXpOOC8Ao/UDmFLZHjMpUsTJ44FQhyOqZgYIiQ3bMiz?=
 =?us-ascii?Q?WAEWvEJhr7kNiABnzT1LagPc6SZUk/VEfgongqvlkaEglaHJFVcMjJx5xaZL?=
 =?us-ascii?Q?6Nb0qiu19wzDZHgHkFoixVQW/2mn5v19fGt/LINQ76BTFt62pGeVGkKwJEjx?=
 =?us-ascii?Q?YPbEO9IbLvDWz5AAKoWNo5bDJl9T+Lq4M7MFKswktXuPrVKiasFRBDFcqjE3?=
 =?us-ascii?Q?SPIgX1O8Tg6c717F1TYHavTyRPISM6O6ddD3dI5I6EQMa542Id0tPFDepzNf?=
 =?us-ascii?Q?JjHeMg+OW6PvN4maaZvd32HmQLBy+Om08yivBpuZ+ubcQUPlCGTip2MAA0tj?=
 =?us-ascii?Q?tSbdauqkNTdnb2S+ftOXvZ2AN7ICEw5ngXSe4j5CCCCaFp4x276rewmTuyUD?=
 =?us-ascii?Q?N/6QoVy8d4pvzFEqv1EueWd5VP/wbgfk0+WEGupLqNJ4ra6y5awXaygszodO?=
 =?us-ascii?Q?srTT3L5eHsaCDeuybmlOxQoPy8t/ycCPKMQKh1vDfSqBxjsqmzWoRibWBvNc?=
 =?us-ascii?Q?pceE6i2AsgzFtfmuMJs8yNzFzh7wRwZc67ifxIXiJbUbY81MWB0QVFVkhzei?=
 =?us-ascii?Q?S32QsXNuStQS8KlOqdIopVm/Ft+tiGtnR3CBvACYy6K+6RnCq0taS9PAcAQa?=
 =?us-ascii?Q?6+xNMBKJz5Q24gUILZMuElK+y0ouLJQqhim0OF9WZcqpwBIqzuYbgkfzzaaz?=
 =?us-ascii?Q?ZM20y38NJQ+6V2V4To34hJyJOj7bqxmWaDRgqct0jbOKrCOaaMdv/Lb1d9qJ?=
 =?us-ascii?Q?cBxQokDxaQOzWj0Bgob+DJr++cJux+zZkZ8PMlNgb8w+V+dgUWfrWZLg6vwd?=
 =?us-ascii?Q?3aN8OW6LJL1RxpQ8wpyJ9JaXuCiwNfLSz8c770tLdSPtm+iDEfsCxiWqkJyu?=
 =?us-ascii?Q?oWGdMr8bU2Q0IWG0mkqi60OvwizzVuui6qP0SNJNLjLvSd2tu4x9+KxdOVwa?=
 =?us-ascii?Q?+PphatCAesTIUHztiqIsN/oCBP6B0ntkKsmMmv35jscdjS0uSu5k6NosWkWq?=
 =?us-ascii?Q?UFAlAbiFRbRZf6CuRmZSCKkxN8k0LaDsXFwxC7SlNWFbn+puFo2ae4y2N72X?=
 =?us-ascii?Q?gOGEXgG9E3DQnQCO5PGnFVJGDnUxZrK7LrJv0jht//2x4B3Yv2euF9EpCKEI?=
 =?us-ascii?Q?kNbwbvg8iYcir1o0BVksQMRmMpdAzU5duC02NbSr5jetCxwP9FhiZza8nSaW?=
 =?us-ascii?Q?8ojZDhJ8EVwjI8uCTXj5JwtgI8Yc3WYXmPKCvI025IYzo+vFi6EFYPSD3sA5?=
 =?us-ascii?Q?odkZG0IqWziDxKbaYr7BTZVucDcUhUADPhjdWyl6r4VWENEdukn2OG2O5fol?=
 =?us-ascii?Q?d8TtocIG+EmPeGtWfPz0qjeVUyvS5fsPyVRu8EQe0vp94jBItoQTEApBqbVI?=
 =?us-ascii?Q?8Ycadfl1AdaA/j5pEkES4tsUxzsRteUTTxVbMWS4LSZpRtPhq4wULgQxQaVR?=
 =?us-ascii?Q?6dlg1w=3D=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 016c2da0-c8f4-48a0-48e2-08d9d5475c6d
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 21:14:32.1102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /aadvfeHm3eYq7/ptSBukfKSfou7Eh/+57vdyi9VWW1RPk4FCSOEWieSEz3xbI6UwokJEN1Qe9+tdF7XyQ9w3cHeiKx5CWgzKe0fViR71BQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB9218
X-Proofpoint-ORIG-GUID: uQYeI_uNs6fE97Rqc-8GWGxZDGTy_Ia4
X-Proofpoint-GUID: uQYeI_uNs6fE97Rqc-8GWGxZDGTy_Ia4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-11_04,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 suspectscore=0 adultscore=0 clxscore=1015 phishscore=0
 mlxlogscore=654 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201110110
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With previous changes to make the driver handle the TX ring size more
correctly, the default TX ring size of 64 appears to significantly
bottleneck TX performance to around 600 Mbps on a 1 Gbps link on ZynqMP.
Increasing this to 128 seems to bring performance up to near line rate and
shouldn't cause excess bufferbloat (this driver doesn't yet support modern
byte-based queue management).

Fixes: 8a3b7a252dca9 ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 2191f813ed78..580a4245f8da 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -41,7 +41,7 @@
 #include "xilinx_axienet.h"
 
 /* Descriptors defines for Tx and Rx DMA */
-#define TX_BD_NUM_DEFAULT		64
+#define TX_BD_NUM_DEFAULT		128
 #define RX_BD_NUM_DEFAULT		1024
 #define TX_BD_NUM_MIN			(MAX_SKB_FRAGS + 1)
 #define TX_BD_NUM_MAX			4096
-- 
2.31.1

