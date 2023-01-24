Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A160667A07D
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 18:49:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231538AbjAXRts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 12:49:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234246AbjAXRtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 12:49:14 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2048.outbound.protection.outlook.com [40.107.20.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D5FE4F373;
        Tue, 24 Jan 2023 09:48:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rns0y7+miTD1kXevhaNexmg7MyZkZWW8XQTgqiuKGIrXC+Ygb7Zoxio8n7bOLtKpDcPcAMpCTQ4K3wKmHf90hKBu+TDloHoqd6Vx6J30g3DwMqoPqMVpm2w3yoZg6SnY+JSgraidLgUOjQnXcSbN07arRoLG7LGXCTg31rg+6Yz1/IfNy5wbG/D0sg3qQLICEb8lIfMKpRlCoNNgkPDYnw6gu7MQ1wFhx6g4sCTNZn/X4JltblvR05XnJMAgiJapceJvM1CBUv6uMAhinxlRi7FwAPXLNbtCT5QVK9NsRekMQOvxJ/2gMEFzg6qUcSLNqr30bpR+CYlE2XoZsqVFVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zWDVW0cZffkdbMJR3+D2lBh6Hgf67AxhilbitEfC4P0=;
 b=Tqi9BuAv3VxCZIOE4Zet3V9cf5CRmwvLryaO3m0XjcGWLXwT8//5tfXjrFRQ44oyASFnIqp4Iu+3OZ5NmZKET4HaIyqQFXcOllG2d4gg2Ywsj+RKuD+gCqEjU9bJc7pUK65/d6wO8w5lvazVf1ODpBi/+k8dxPX75ZXOBqfX5BoxmCWeSEuDv+O7P1Fv2fVZwMd+dNOhrvA8eP6x1XD8dq3EUoY2TyVe/RBn++b6hvaJFLp448YSPjebJJc7CtnUFfZdnssZEJMFAEKFFjltYGt3Sny0iTGsUEbrCXKwHOWf9zBHezHZSVSK9nnKsmvIpfXSMLnCuYrU+CiITfjBRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zWDVW0cZffkdbMJR3+D2lBh6Hgf67AxhilbitEfC4P0=;
 b=BkWqrW4fdqjydM3BOTcw4aI4YPUDHOHYdYE4w3UCwQHtUUv2L44dklYYvKfYmb3FQXM0uDWdtDcdNJedo/QYBmmI7T4s0d0q1En47FCCFpJdDlRZX6vxNKe6GdCOF1gpXuR0XOg/RL+9zu/yi8OKoikoQUjO0XhLt7Bd3UItfM3nXT31qfOr8ALZIxnVgvxIdVDX509B0PcHJjyyhxJOySWRPL99huibociP+G1m8jK1eQpXLVmGx4Pa4elziZcghJIsTL/li/Pwae0iPs1u3qZBi+B1a30Q5O4cgNpGM/hXGfEp8KMPdOEvMPG8iv+ZpVnuHAbAIYouWnCJdnVOWg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by DU0PR03MB8785.eurprd03.prod.outlook.com (2603:10a6:10:412::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 17:48:25 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::6b03:ac16:24b5:9166]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::6b03:ac16:24b5:9166%2]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 17:48:25 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        linux-arm-kernel@lists.infradead.org
Cc:     netdev@vger.kernel.org, Madalin Bucur <madalin.bucur@nxp.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH] arm64: ls1046ardb: Use in-band-status for SFP module
Date:   Tue, 24 Jan 2023 12:47:57 -0500
Message-Id: <20230124174757.2956299-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0275.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::10) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|DU0PR03MB8785:EE_
X-MS-Office365-Filtering-Correlation-Id: a30cb61d-d746-473a-e893-08dafe333123
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /oWXYfXBsJfYZyytILG9E7S6clE6vCOUuWDlOpvJjK92T3h2AmDd9EvpabXflOH3NoZA8DAoqid26l6xIBK61RjvFybJyE5vxBkg195mAgzLzHBX57DLFTk1uBcsAVBPpHPCbdSZD6ov7WBLwHJqUmBdUjT8uMOeeB+vKmkRyJIOPow+Hih9ak9LFuhyrLeTr9b2V8iQMvDCsmslNB6z7hciqZz0Z0KCOYPNaGWBifykSYX1ipQKrEkHhaSxRAw+NNnt28KdYLvtyDbHOGIKO5y8+jhiUhErtDNJb50/MGP5m4WJY9NnmwP3IGlFp4CRIGA79bUBve1S/L+ddLHy81cYVfGy0lRRbI6Z1MGZ69/lR7uxFHJIUqWJIW/XvTpityt/jfKK9CGNQj4y4YFvqpg5sMMpN+KHNBkH7Lqo1Vfsx2fTWKSeNAjKK7yf+nHWeblBLhAq8UkIIDq6TCI6QQFAYqeEyjLTuZ/OV55dg0ObCOwtDQkD8VsA97EhXzp7ZPzsn3FCL5OjTRONDp9crOmbxqTOxU8XDNkk1OJu5qdUmxFo7gTGK94qKfZApm2BB82ZHU+KhnYzRvJ4fCgAWeb5DBd6zbtpr8TcW9Djo5G35q6Lk/LnciiE9p0igRur/iM3pCk6NZK7AHVvLxekf6y8xFNRuTfuGGatNZXRPQNPnCmVS8Dfwuwj/KLF1xpzzA1Xl0xtkBWO/NF/BYdofxe/DodXUk2o2RY54qdG/74=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(39850400004)(376002)(346002)(366004)(451199015)(83380400001)(86362001)(38100700002)(38350700002)(2906002)(41300700001)(5660300002)(8936002)(4326008)(44832011)(54906003)(6506007)(107886003)(6666004)(1076003)(186003)(2616005)(6512007)(8676002)(66946007)(316002)(66556008)(110136005)(478600001)(6486002)(52116002)(66476007)(26005)(966005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?csgkcjTKKGfvgjPQXXojUnr8ROwxXOfo4altFWZSgXxnNZr1EakJqCPfYnXh?=
 =?us-ascii?Q?tOH9qdKPAl9iV0Z3C6+qbTf+URmIDzbSYPqHT8eVHC6iUGyGbWfRuDrlRps1?=
 =?us-ascii?Q?2I5Nqg8gKpU2bnkubIYy+vIpVr4CXGGtRktpTI7dW2M33nrfp+qRk/3/X+C1?=
 =?us-ascii?Q?6AsaVSzqbEP1crWsOLLTsnDQbTOF0RKPJsCAPqz4Yl0VZNO7/vsGfp4rO85I?=
 =?us-ascii?Q?twi7z1aw9KHkHTfR9M6VXTCS6CJOV/gXlYLywjgfG/4QHrNtJLqnCEx//24N?=
 =?us-ascii?Q?ADv+L4dOjLpWrq0TPP9YpYbV3TXJfmfZYgqhbBCnGNBxPBo1ZpFjOqe7XNpj?=
 =?us-ascii?Q?BObMDZwOHkeV12GBKBm91HMpATQv2YVpaWzexH1psrmv4d5sKcPTCwGrnGHg?=
 =?us-ascii?Q?vgNMXrKlkok/mAlbeQltR6PRkmcotsvPho36aD7Bps2e1NsQKMgAVqGZbwrC?=
 =?us-ascii?Q?zcpDgFXATTMh85ouFdSGevxd//xkKXXYmeCwUR0biyRqT3I76Ec0ChO+2h24?=
 =?us-ascii?Q?oavzpJQXcrX7PQzEOYUK4OkvstKObnkSFG9eMS1Ve5MdFuYIpiozz9y9ZVp4?=
 =?us-ascii?Q?8TNyKJiMFGIDnrOE6YiivpyGjWRQCn29CZcCU4ii4JbfKeBM02B8Ys0B3Wz2?=
 =?us-ascii?Q?G6KmZIKwJ+umNxbq+qubCjvWnEJ1Vn1PVRQUHipaIEhXUIVfU1SufKsS5sV9?=
 =?us-ascii?Q?QaMekWAUQHEzRQngn4QedkNBElUewRXJ6a2th03+PaJiCqzFJt+0G+fuDR4Y?=
 =?us-ascii?Q?ijpVrq4dLZJBQ0jBJZN+K0zqWL8pdJOrev1h6dSmv2SSmFVr6Iznm+kciSLQ?=
 =?us-ascii?Q?iJyZIUkbNs8cKxXIHcXCdzSVbzwvRdYMWE437PogS0H5TGguVTQlXb3qjRBX?=
 =?us-ascii?Q?zJE1OqXdSB8WOkAgmKYrd7Vrh45628wcWl58L7InhRUsKFQIVuOmtjYz8tcr?=
 =?us-ascii?Q?vqnWgBHGZ/XOTscFibeBBZThvaowJjrMZ7ciwHkvk02qE5xoJ5M9TXM6rYZi?=
 =?us-ascii?Q?ITqzsEJQsViI1tCZCWbAPAB6D5b67lhjL/MVi5AwHCNAiZ1e8yGc0nq86ZaK?=
 =?us-ascii?Q?SLG0bE+KSwMzzQoVLSGwKworvy/PGMtZ7F1h6XhlFUvcmjvJw9ALJF+Rnnzf?=
 =?us-ascii?Q?pcTrMAoZrufJoC0xtv8w2/ZhM0bqBEDknpQocu1qMtsLu3pYUMbr7ZvNw7+C?=
 =?us-ascii?Q?Yz+kGcWZO0sMrpYokLbKVvH7i80Q+Yn92M/8Sd5Ee7XT1J/8XV7tacwXdyoS?=
 =?us-ascii?Q?fy0849t71E/80uV5ySjw6v2d/EW7Cj1Nl9J24BLgxazO4Vi0gBazS0WvJBHD?=
 =?us-ascii?Q?vs9YSZTUegfl2kUjNpqLwb+/9FfTmdyEl0Eg4dPejOwLZlEl9/eYMVmzRZmx?=
 =?us-ascii?Q?gl7Duh8mMnLAi8Ltauq1fno1GsIYTr1Z7vuYtI2/PkdMBryBVT62NYQRV4ik?=
 =?us-ascii?Q?R7CZWJWTMHUF0fIN97fO5zTBRf91TBv4pfqIeKFAZ89HF/tLJt/hkXCZXtWM?=
 =?us-ascii?Q?oxTJXiiQyJZ1mSp79FpltifygHar+/yxJ678+IbAqpSaNSdOwGivJt8i7PoU?=
 =?us-ascii?Q?qZzV/7AN6dLtSmDET1n8mEcS+86Ol+z3opknNaaRJET25gS34lc3EJptbHXW?=
 =?us-ascii?Q?jA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a30cb61d-d746-473a-e893-08dafe333123
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 17:48:24.9445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4u4sxc+TblJeQ66rajMi5Kf3qxzccsfjnh9DtfiEfTX2yzy4qGlB1SBp4h+Xm3cCTEOb/7LCMj4CvqOpF/MWxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR03MB8785
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net10 is connected to an SFP module. Unfortunately, the I2C lines are
not connected due to an address conflict. Now that DPAA uses phylink, we
can use in-band-status. This lets us determine whether the link is up or
down instead of assuming it is up all the time. Also fix the phy mode
while we're here.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---
This should likely go through Shawn Guo's tree, although it could also
go through net-next. It will conflict with [1] which modifies the
adjoining lines and is likely to go through the phy tree.

[1] https://lore.kernel.org/linux-phy/Y8pLjLWjv0nJa+ww@matsya/T/#m54a5ed1450322df1499836edbb561bc4d6daf4d8

 arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts b/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
index 7025aad8ae89..07f6cc6e354a 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
@@ -153,8 +153,8 @@ ethernet@f0000 { /* 10GEC1 */
 	};
 
 	ethernet@f2000 { /* 10GEC2 */
-		fixed-link = <0 1 1000 0 0>;
-		phy-connection-type = "xgmii";
+		phy-connection-type = "10gbase-r";
+		managed = "in-band-status";
 	};
 
 	mdio@fc000 {
-- 
2.35.1.1320.gc452695387.dirty

