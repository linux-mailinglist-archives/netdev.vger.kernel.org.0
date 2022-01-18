Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0924D493017
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 22:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349583AbiARVnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 16:43:14 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:13290 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349587AbiARVmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 16:42:52 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20IBxQUE007528;
        Tue, 18 Jan 2022 16:42:35 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2053.outbound.protection.outlook.com [104.47.61.53])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dnbdu0rte-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 16:42:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NiM2uf13AENh7Z2mx/4mwgTNpBZIRRaw25ZafM8yJVbJnwG9bQxPyOr9U2EBPy2C0mdb6Jj778RaYUdNPH9UT3WE9lIb+PE2f28nqtHa7BhvgAR0YNMf+a6CXxlrmbJh4XFgnvykGyG6YJULbDf3buCo7ZzSv4zKrWF7/H+odyWWb0ueYWWUW0y4gbUOtqqMUsFU9jmJ9df5Fch85qd0hKIJn2zC8v9piu1FzgwpVN7040afxzEERP3KFCUMnU8p5tUBu3POQgKBNmm9rRLhOqJhICZ8YAtDq45IViTPVFp9iqLHDx334KE+dnD04NrjEA6oAUwDT+5deTym29y+4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BZ9DDfEtZf1cRTgI1GPp+WCaxta9n1fDGueAt0DNbwM=;
 b=QNv+/BmScjqFRS/HwCdc1AP/x0wlXAGDWXzHynNp59WMOkcy8jKhb1C8cHe3D4hojYROgB/ztwyhprOntVBv4RMGDrPLJHFMPxsx4FDW/issn/kkhNOD8NuRO6Sx9QqbXI0ahPzFc8G2edkiV9siw1rgXFXkwTX4722wrjzTTaFiJjelQTbVOvoFyn1ax3nKEvdimG7xjmo5haT7qekZmHBNDDHOqnfF+iW3FI9Zm0AxZcpVk90FNv19d562yYjf2MO8xxY5itVeSVIj1ga7TjUvViXcDhYQYLIbW2SebswqKiqCI7iwGuiz7evCzqqNco0SPwB1hELgBhatIKjSwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BZ9DDfEtZf1cRTgI1GPp+WCaxta9n1fDGueAt0DNbwM=;
 b=hJQYlKjNBdtwyKpDwIYcZLWkMyN0ZPpUl8VtN6Fc9Xgz/jT6EeSrVdLtPkV14Mhx5LkeZ+YS8Af/KkQ6Z0VBNCb35Uw1ZLm+q871cbuWgzQ5cLODtuknv/o76QsXsElOPvZ77W8AVsUWdavWMfP5bcQwOZFK5Lg1Qf8J7qMY2OQ=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT3PR01MB6145.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:5e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.12; Tue, 18 Jan
 2022 21:42:33 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.014; Tue, 18 Jan 2022
 21:42:33 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, linux-arm-kernel@lists.infradead.org,
        michal.simek@xilinx.com, daniel@iogearbox.net, andrew@lunn.ch,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net v3 9/9] net: axienet: increase default TX ring size to 128
Date:   Tue, 18 Jan 2022 15:41:32 -0600
Message-Id: <20220118214132.357349-10-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220118214132.357349-1-robert.hancock@calian.com>
References: <20220118214132.357349-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:300:117::19) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db01e330-fa66-44b4-d806-08d9dacb6fa3
X-MS-TrafficTypeDiagnostic: YT3PR01MB6145:EE_
X-Microsoft-Antispam-PRVS: <YT3PR01MB6145B8DD9510D7DC1356251EEC589@YT3PR01MB6145.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LnjQXYGxJpjgqyiUGFgUqbWXJxaH0/+a9uH56yflNTZOi37sEQ2+wO4slpbpXMTGVZHBf5chHwOSPvoQjbHDwgjesEHo+kbZ1rPqXBHce/fmdPhasv3jXr23FqMoRAZs5FroAAz3zPNvD+TTipXwAHsUQwX0Vj3wlLHMDKms1bJgCSGU9hC1C2mlavnmElDvsSu/+sIo5Hzz/SA7x5fY7qs5V0lxrEl6PbWAepEjYw+H2OlCUI4HnjxhtU1pmBOvm8NWBEpxVhS9vkFfCNU60imypVN8WwBYzAiuV1cn05PKxJWrJuJcM55aDIYu4xdij5cDRjAT4voyOgAXtZ/tQp6+gF5Tk4lcAQEvK8T+833pG6temDGvc4yg8OLTy95ynS8OLLpO+eGJmxlQGEIvrw4DuGifnmhvq7+YyUB0F5hakCNwgLJuT2muGYbmzYQ1E5iEiJm+mZIOtaYqK8W2alb65cNs+xiwcHxWWAYu6NwxROqWawqUrssKxPH5a3u2FFEnx6HhuYE47i5vWvtfy2LiRpvrO1XmmCMePXKE8H1KxHC2rFhlhvwhkR4SEfG9vF3kuh3dpmEoCJoUV+EWrVbS6JceeWqrldRzzcldOygziA3DMzhpizZQLqLLodwxiSGNMlwnKRT0BODRybXbgl3C/OIMbYZyzoEp3jc7ziu5F9kogKYrdkXKcw7mtk5a013GTDGxcOOgBFj94rOSqA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(44832011)(26005)(38100700002)(8676002)(38350700002)(83380400001)(107886003)(2906002)(6512007)(4326008)(6506007)(1076003)(36756003)(186003)(86362001)(66476007)(6486002)(66946007)(66556008)(52116002)(8936002)(2616005)(5660300002)(316002)(508600001)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8faPm1R6uXmHHU7QPz/J7O4HJDRnWjhW6exZwWA31TFemt9bWS20W6YPEyv1?=
 =?us-ascii?Q?yZEG1u/bEB2NbYgFLPPhp2Mvb/UWBfp4Ud0dNLSHgLS//And5gTZ1cRSzxNW?=
 =?us-ascii?Q?w3lqShPmPeqB0db0nafE84E0zVQqmTRN6fu4cYZFzGKi8K1TfhWhJqGpwGj/?=
 =?us-ascii?Q?fsEPero3dsG12qvP4hWaT/1aDvlOAGoSdm2zkB2T7uFcs15d5hET6wRqMrE/?=
 =?us-ascii?Q?U+79mjfV6ufianw7e/HgxYw3FYrtPDSy+/br3VDW8gU7QFhKFr6MmGUBUsna?=
 =?us-ascii?Q?bCbklFV9+h3Roci9DJDSWdAeJ++TNICG0ljMjOLKmQ7LAHz8OlWxRqbtmw6s?=
 =?us-ascii?Q?TCGjPwM23gk6OKeCMDXk40nKkfh8qvMtpGGZrmCCecSfrSuXdb8PLQ648Rcn?=
 =?us-ascii?Q?MRLrYOaTvUA/valgNHjlyKSbKmtl2PZHq3IDkBbWzeAd/BZtjxGd895v4mhu?=
 =?us-ascii?Q?wVrl+KP0+KBoWTMjMoEL+s5hH5frniMtUFAGpOnbn4QPntcKUlSJ/nYgXgFD?=
 =?us-ascii?Q?edA/mOxxciKw6QWZ4QUpTi4Nx8KhhVfM+IPT5P1EvcCk6WTTfQtG0vaQV22u?=
 =?us-ascii?Q?AERnMmvMpidC0uSUA1R8eRhBpyGOh5eaPyYs5O6GcA8xAts5EshT6FBJhLWD?=
 =?us-ascii?Q?w6St5hQ+5AdOzkrly7kTJJ7j7bUgKti6LzQE8HCeO46zfSLxV4h0rQOi3nMn?=
 =?us-ascii?Q?okMTeqJ9yiLkV5Rju1Hpn6tGq4ITzqsRTQq1sr4KpRiYWVh1TtBm9cLr7P4i?=
 =?us-ascii?Q?6qTqLewbstobPdxhfeAPJBZE0sx81HhEaW7s8sl75+Ly0WgC/dfTRQkMfcjs?=
 =?us-ascii?Q?HhG1xIgi4QST3Qvo5tcpYdUYnWFkhD3uAG9HQyvzkrKT4uRpGLFGObVh83m6?=
 =?us-ascii?Q?vhO6Anfd2X3/7JALZj5sXzzImhxbPrPVBrOkZRAL+bQPjo8zHgy2UglXzkPR?=
 =?us-ascii?Q?9NhGYPdQXQc1/K37dlpxLO292P3FRGfWqc1g54W9cKYhRwP0N6X2WcUq8Erv?=
 =?us-ascii?Q?/8jbNIUmpd2X4i6H0LLDeIQGmNVqfDIQgTPSidG+sDLgmbN2WwP7awlyL0/G?=
 =?us-ascii?Q?jrl4iXGhnyhlKyMsdDTQD8n0/th8Vdb0vWDOtKir61c7Ujj3S+9sOPKD64u6?=
 =?us-ascii?Q?8ZchdF+9S8NN1Ubq1JK8v5zknii0RpuYwyUP71Id9u3KFWwOLCppPuTZ6m6J?=
 =?us-ascii?Q?8iiC9aC8V5PRYvLhAqaXI4BRDM5bGU94GJ+8jMCqpUSZ9A0KigWbO6AwZk9+?=
 =?us-ascii?Q?Q70Ri5FSvlX7ZQ16sEEc2yJa+OP3mq3mmqfMeTdfpeGw7KLrMGj7QC/6RFXF?=
 =?us-ascii?Q?l1psibkVuL9ZIFbUVd9aR5G1+1LV5AkhkhQDsJDjJ0nBKY4ntYc4IBdbQIuj?=
 =?us-ascii?Q?SMWuPUy391xgd6EYXV2TPuaUPkAfn2oT/4TxKI/oy9HqPkizeIKJGyP4FAxs?=
 =?us-ascii?Q?gl30QaP8SgT7HPX9aSasoUfjn16i+VeboZwViqwlnb+JdSASn1UNeNq/mK0Z?=
 =?us-ascii?Q?KYleUxawMfPjXD4wdvqvh+7LsfbDTmdjwMiDVY/oxauAB7T/ar7FDtY2pbUa?=
 =?us-ascii?Q?EFXz2Ank2j0cNDwIIvWaNQb793GX8G9hBJQDLeAuha5rcEqQywn/tVUMeRI1?=
 =?us-ascii?Q?OgcZzaUdO3J7MYsbfMVGsPBi0Iku06IOS+iPQ7ULXIts9xOGuibLusucuJFP?=
 =?us-ascii?Q?RXw5o+XKxqHjHoz9PXq/vR2N+w4=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db01e330-fa66-44b4-d806-08d9dacb6fa3
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2022 21:42:33.7423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CZHnXyRp8Cba7t4pd/K9VTJ2yj0jrnUl+fQECevofvz3FysKPXRjSs9ROqIRtvPwkBib7mW0kptiDxt4O3zBf93HWCTiUuc/nkESHSnQEFk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB6145
X-Proofpoint-ORIG-GUID: NxZL487RlxrGCCVsKsC8tbe8nGi0Megt
X-Proofpoint-GUID: NxZL487RlxrGCCVsKsC8tbe8nGi0Megt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_05,2022-01-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 suspectscore=0 impostorscore=0 lowpriorityscore=0 mlxlogscore=673
 clxscore=1015 priorityscore=1501 malwarescore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180122
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
index b4f42ee9b75d..377c94ec2486 100644
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

