Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A819E434A21
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 13:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbhJTLiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 07:38:51 -0400
Received: from mail-eopbgr130045.outbound.protection.outlook.com ([40.107.13.45]:17770
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229548AbhJTLiu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 07:38:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QrZ7XGet0Z//E6TcVtIv8LAEOGhBioDivZVqCmfi4iHQAOlFPl93j23VeoRWZ1S3dIHti/yRTQVsH8fiO8jh2Q5eT2HR4uj+dn5nnuPc4SYJVStiFT62SY932vI7MJ0fIzS+AC405YThWGNea3vfczx3nG+y9+BRrmYsXElNeM5qUJR+IkYFFjqZDWCkZyHaQVrkZUxf/1boUF5D72c1CtL3iMB82cDZK7+S2uu4RIenwZ3t/iuncD2us3Aog223jHXOjN/4DvNtoFsWQN5Pm0GKNMGVx2n6t2kRIaUyP2y4sy3gnv1yGvcz2DPCdxbdF86PTDq40gF5o5tJs2OETw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WjigoY0w1fF5i4mGoPKBfuocLweFptPM38lemcqp86g=;
 b=RNXT3lC0/m0XKtmh37BwyCZpTpcu52pJN2RMeNguQxY2RHqlgvhAq2S96BMdYcX7w7LlnOY9ov+91UvpWVuJsYLEOZMakaTVv7SWZ6jm8v29gv5ImBVflmGoXuwM8J7J9hcxn9Ze01TVoz1vvXMuJA8sP5Y4XnUoPPdI9v3/jFO8US7CtKWh77X9b49C+NJzgxQS7u33lLMVpe/h4We16Icz90pdwkpOv4WzCxLIiwXk3RdkO+J8rizkhCF1qam1z68YETIm8HMcyc3fAfyK9O4TvVlCx1sekRGvTQgd8sUl+HW5wwbTIeNy8Be/QsNdqflGM5PAC5dmGj9kSbJCCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WjigoY0w1fF5i4mGoPKBfuocLweFptPM38lemcqp86g=;
 b=RE85UKflcF+MIOhQpMJYEPGcJV61rZzmR4Epym3D6s77c4LM1HTRx4UA7/uUhSoZwhIDQa2tR8lWPbFfxB3+UW4KhoBn2Go9ULRfmMsQ9M/oeUi+axS3+DxPoJQjQIy2jzYB1SGHbUdc7sskfuITMkpxY9E8HspbhtXobSzaLCI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4685.eurprd04.prod.outlook.com (2603:10a6:803:70::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Wed, 20 Oct
 2021 11:36:31 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Wed, 20 Oct 2021
 11:36:31 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
Cc:     Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        Li Yang <leoyang.li@nxp.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: [PATCH devicetree 0/3] Update SJA1105 switch RGMII delay bindings
Date:   Wed, 20 Oct 2021 14:36:10 +0300
Message-Id: <20211020113613.815210-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0036.eurprd03.prod.outlook.com
 (2603:10a6:208:14::49) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR03CA0036.eurprd03.prod.outlook.com (2603:10a6:208:14::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18 via Frontend Transport; Wed, 20 Oct 2021 11:36:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fbfc75c4-6bfc-4d4f-2946-08d993bddcc2
X-MS-TrafficTypeDiagnostic: VI1PR04MB4685:
X-Microsoft-Antispam-PRVS: <VI1PR04MB4685F498849E40ABBB9F556DE0BE9@VI1PR04MB4685.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RZ79UTCXEaZ0ijfIYbOpLtJfgvzv6hTj9JR+riGBg6KO3rnTAebd1NTWJkE3SuqFFO83//KNzZt3P1qlAFoFIttTNLsEe1KRRfJm/26Ze3ofIntZ9cxxViNKac9dNjT3e/2scz1xEn55VRnN+XhD1f2CkdvKhmtsOIS9Ig9nltpLaulD8rT1gNHnfbPuBXXk7XFHwz9Zzc3xYPnP5poOBJioaKnqieFWtYxGhR6T/UrHU2FxXyxJmBhgSXsiL6TVZfZYD9YPKwdSShgdv2RlMn5NRrxmJ2Lr0Ufgo6gdtQD307A4KX41BG3UBkGjmB80MTk1Dp/GRTWh/Cu45T7tqBHrWWjSXVdgPN9M8f3Afg6IxcXauklK4s5io/qDe65ltXGoERHxuZMw2A+sJV/Cx3js6XcyCRY6Q8zyDI2fbx3UgjYmvcslvuh5heFmNvbaZltbTHrBRkheFxW/WXYOkhivAWnOTpGu5IyqRf7+U167n0ytKZRPaFFJLsHmT1Vx/AD57aO/2xyP2lt3h7UfiEKNiR4VzYZ39tv0ffbTArGZzd4vy6i9NUhwWZ5wyawSBxTCrHdf5O4aAbx+dPR62SYLuKEmwANqKcyJj+5No+2n6/5OydhdzCvRtHTmKW+UVVYYzZwxVLI/ZypbWiaD2tCuRlPOp0NaZNs1r1fYiWLqDcWiDbrFwdyNIJULPomQHICWQbOFChjnWdqo5ti5SflspyYDnRO4F9tT3tVHnTfGhE645tUGGy8DbQcHfFohxs6ZQzfpIoTxjrcYB74kljyVnDKR0FbgpLoa8uQzzng=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(8676002)(4326008)(6512007)(956004)(15650500001)(66946007)(2906002)(44832011)(186003)(966005)(8936002)(2616005)(86362001)(5660300002)(316002)(6506007)(52116002)(508600001)(4744005)(26005)(38100700002)(38350700002)(6486002)(54906003)(1076003)(6666004)(66556008)(83380400001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fezNQtZa+0ic9OR79XxwggOWPTxJ+pmUDB4ziJESm1WBfawrPQ3v7kiwL/6T?=
 =?us-ascii?Q?bq0vuyAH1vkIzF/0sHtaHOBYyZyJenspkRhU+ON1wpC6tEsHoR/0EZdAxT/Q?=
 =?us-ascii?Q?1DCEHdbL4XFCZ63VjqYdN/GRq6xriEfNPgNXsXrkAodQSUVSnrBhMGCDlV9d?=
 =?us-ascii?Q?PbvLwGqr7hZUCAO44ru9VEznq24o7uGdtapEL+F8ZBH1Iy4m830czO+2oeGK?=
 =?us-ascii?Q?OxWRbkO5Q/Ao0idEYSuqam30fF0w5NZCtcHjsWRi46BoX3qmcUv4eyb0zkbK?=
 =?us-ascii?Q?2GyU3+/F6hlc7C/7pbsTFznQ14THJ9Xr2RDH+zCG9snJklfv1oMlYfo7w+MZ?=
 =?us-ascii?Q?xZ4SxPT5Va4JBhRb9c6Pc1z79QScDO9yllMjFf7gaIJYvDJ92aBujeLNQcVM?=
 =?us-ascii?Q?Xe5vAm9hiezFL0zRB626k1GYQb/nkeOkLLvQ80JhxftsKTtgrmb9uoNw9neA?=
 =?us-ascii?Q?oFs3OSVouDHm/q5dIswof55sZP6obIZFsexhzkMeEun+LQoa7u6q0K9rjjg+?=
 =?us-ascii?Q?D5Oz7Sph2GKFoFdyva2RhtRlKCwzq4QdS/lIuGMhMg1EZTpkAeuFQ3WL1DOO?=
 =?us-ascii?Q?+6MJPqrtafUYytOmTK3PopCzlV026DmgpDEVkXTfQcIoHKAJvcoEqGVKNlTw?=
 =?us-ascii?Q?Dg8IUKmheVhaKjul/VikNmeDlYMicLOjFeacjy6mvr9zLGi+uw05qvvU3Wve?=
 =?us-ascii?Q?kSrb1Lb4vaz4xooXclcEDIWEQcBzFKhpuwfZpdFZXCrXS3c/FqMt7hr9qEj6?=
 =?us-ascii?Q?BkdBdoQeZu4W+6isL1r5fCsdU5dZFqHUrqq4AdEY96Qcs/zAZPlR4UJK+ibQ?=
 =?us-ascii?Q?/Ob1gzUKhAqe41gfQwss2Ab3QCNbzL1+9a8zP64qnLKbfzxxxq0Bg+2ugryC?=
 =?us-ascii?Q?5/u9zWIYu28KNx3Ct+HA4yuMx2vo1NJdObE9u1W9xq/tzQCDwHPjELi9sXsG?=
 =?us-ascii?Q?KhlrLZWUqJzKwL6dQbLC1IZ8hS+H1FhfNTuukRxl1ZZgbSWuD78SumczmK3H?=
 =?us-ascii?Q?iZcV5mtABo3f4QvrhsNHwMqSJv69dHCgvNICYgLLuS86LuTUAFLYithzTAxq?=
 =?us-ascii?Q?1xGyxVj2uBdEFrrBn00nxDv8R6ND+MgxrX9EKT+E1KDwSC9mn6roOi5c63yu?=
 =?us-ascii?Q?3M2Zte7QjDm39VU0GMWRBZXVDchgRJED93bVXP1W4LM+rxCHRMg2LPXejJN0?=
 =?us-ascii?Q?OjV5MaNqCnsRun42vDf/o6qdN9jSiIClpvsyldXh8ySziUvf327xZpbWejUk?=
 =?us-ascii?Q?x8SC0j1uPyx/0MGi/83bY02G+eOUfRzHTAVKbjYIfCF+BDwe6dLMc2MdePPO?=
 =?us-ascii?Q?8CKBixdPUV/EjJzrK4LFw6rQPDbIBEipJ8xvFQVE1zzrj+SJ8i2uMCuG1y2Y?=
 =?us-ascii?Q?YlVqsJxDggsZk0j1mt09Q0BVs0dHprmSBsCYNdypU0SPK0dRv6JlbYB7Pzyj?=
 =?us-ascii?Q?iSe73VUyfhMQUVoAcBaaT6QD7hFcqd+Ucj35WmWzKFFKn+/FZq3MTvnkFX3D?=
 =?us-ascii?Q?s2u1/3mm2zDxYlOCF9QD5m3CX3y3iNzJoyYUgs3pbna+81oaH5uPQbL8i0rE?=
 =?us-ascii?Q?LzAa51WrtZuWfawLaJft/k9FZpzU26Kz0zZMINJRqO2x8ZgQWT3kbP7VQ8iE?=
 =?us-ascii?Q?+Xr4PbqKNT3bSjkCK36Ot4Q=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbfc75c4-6bfc-4d4f-2946-08d993bddcc2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 11:36:31.3378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tOc5wSBpfRcgVqsxszuxApK25s02RCxVVW0drRSeen7UijJIwncPgHOcm/5A0uURDERoiQgLQysoFBsD7UZlJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4685
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sja1105 driver has received a set of new DT bindings for RGMII
delays, and it warns when the old ones are in use:
https://patchwork.kernel.org/project/netdevbpf/cover/20211013222313.3767605-1-vladimir.oltean@nxp.com/

This patch set adds the new bindings to the in-kernel device trees.
It would be nice if these patches could make it for v5.16, so that we
don't have warnings in the kernel log.

Vladimir Oltean (3):
  ARM: dts: imx6qp-prtwd3: update RGMII delays for sja1105 switch
  ARM: dts: ls1021a-tsn: update RGMII delays for sja1105 switch
  arm64: dts: lx2160abluebox3: update RGMII delays for sja1105 switch

 arch/arm/boot/dts/imx6qp-prtwd3.dts                    | 2 ++
 arch/arm/boot/dts/ls1021a-tsn.dts                      | 2 ++
 arch/arm64/boot/dts/freescale/fsl-lx2160a-bluebox3.dts | 4 ++++
 3 files changed, 8 insertions(+)

-- 
2.25.1

