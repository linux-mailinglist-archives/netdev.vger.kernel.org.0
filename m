Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC9F74E2F64
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 18:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351416AbiCURw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 13:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351624AbiCURwu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 13:52:50 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2045.outbound.protection.outlook.com [40.107.243.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 563C554BEF
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 10:51:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TsI6hFvx4DNmClr6HYg82QGN1mr4k/worlCf1J3+P69rYjA3tx4mLjjzNF0Im8eOq7uZNs1wNrvl0ppMOqFWzvW+x3+UAGGJDxh8luHZnsXjmoEklA2wUbmL6+lmXeGno1uBtbyPH6ybgDyKw+GKoCqVpYZaKUDQdGHKVxK0CTWatu8Z/i5VHF0C8nphMrw0kEcL9MdLOsu/H7EWvn74dDgRuxHOq9XxbyVos9bRPhIAcC+gN6uTOIsfYgveU+Xcc4i74jHmqpZ3KR3I57fxCr34DcSG1WTA2pUjaoHn0qA5+IeUKrjMpURZz+5UXBzsLWldLCodC+/NWHq6+S8WEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cFG287t5Ves6v5P2/3X6gJH4pAG+Pm46e7utiKeZ2mA=;
 b=ITgIbcr5EpQsIRHOlJZe4MvAfcOfbRj7WGe5oHeqQ+G5ce8dJGnE+3bZy3/l03o+DXjHOXOnWhbif7v7vyMUFzn4OS4cexTypuoQhO0CLerTqTiZyR+PWucBSqU9XXalXD4nKeJUllw7yn4Sl5C1lljqfLwo6E19ercdku3I00yV9Jl+dA4Ers/QvR0DvCxHCLn99A5h5tkZa3CqSjDJKGtFYlD5lHBPpyIGVAABU37XJeiM/m0gbbl+JD63h/zc1tq9xDD1RQQY8hasrkOU/kEFjOxiKe8lTLY2N1zvEQ/Wv2IbjWV/eII8B5hXz6eOGO0cEqUfG/y1Mz+Fe+PIbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cFG287t5Ves6v5P2/3X6gJH4pAG+Pm46e7utiKeZ2mA=;
 b=IaiF036bjmJwOHLk9yW2WTfC0Ujkn482Jv3O7EX7kW/WePfZHRsh+SI6TMefopMpl2PumB0foqmRvhzoZPDLUUD5Ih8D+vb6TRLJHxGQUFWyVXBoqJeXb0ZdzdeNMwpk0nI4XW+S8gCGl196Jv/T536cK4IMorUreOaI4gTgzzcoJ6quWw2qMVH74Jv2fucGvVvX7a0ljR1Pvl5s054grKfE935+PXTl+ep48sN8Vk9zHMZO2qKGuboOnW1HKcHsr9+XUxi3fyUIfV6Kl5/fJdHB63XHN/LuuUBeRcaKyv8+H7uV4Cmf7w/75GqQnuvRysue8d/99pu6pD2c8yMsgw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by MN2PR12MB2864.namprd12.prod.outlook.com (2603:10b6:208:ac::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.15; Mon, 21 Mar
 2022 17:51:20 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::151f:fa37:1edb:fad1]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::151f:fa37:1edb:fad1%6]) with mapi id 15.20.5081.023; Mon, 21 Mar 2022
 17:51:20 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        schultz.hans@gmail.com, razor@blackwall.org, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/2] selftests: forwarding: Disable learning before link up
Date:   Mon, 21 Mar 2022 19:51:01 +0200
Message-Id: <20220321175102.978020-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220321175102.978020-1-idosch@nvidia.com>
References: <20220321175102.978020-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0502.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1ab::21) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b10edae0-a35c-4504-5ef3-08da0b6367ea
X-MS-TrafficTypeDiagnostic: MN2PR12MB2864:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB2864DF23C2607863AA9BBA7CB2169@MN2PR12MB2864.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eUc9AVeqUe8D8J/x1qC+QHolE04ZOL/pV5cRoagL+G0vnVpKCdacufcp37WQbwCLKNeyDvbOCrdZYbIxMgsQf9rqTAts+BwzR466IjEgQ0Kw+OhshVT/6N8sN9zabPDOJTtt8kvLSRAxJ4Yf/BFPQivoWa/M3Lo3wiUqyYePqW4yXKxR2sOK2Orpq4LC9SmNdHjEDGOhwbJ400F4piB6sCDjvQUCJR/7KJKGpM9v/MzQxN+zBzxUtRGNpzak8gH2y0uL5DAh1AuEG4dQudkS+N7lUdmxwOzlP5ckDLs9lNYjwGOM/L4ildxeSXfyR2gDKCudKuHJkFFFqy1ct9B1ISYoKP33yXeg4FnemqZ0Xj8c42hCC4cDNvj1R6db/FKAs6L7HaaBwKreBxCiSP5mnT+gxHSuEtKcal+p2W7QYlPlGdTMYwZUywJskN+7uTi4HKcg2ivD6vRyGZ+OxcT28InX6fb5/ixq0MvakCtipTG/KMcIXOj46BbgYjjvqYNZwaLfD0u6L6w+uvawYF1R30EegTrDazbqDA0vd833QAV6F/3nNIrvC7cRcb5OUNq3LsbQ3qWJN4F/yby99plaTskzZ9k8OVBM3cNPGfdOJ/UKxW4prcPN9/ULLQDw5FWqZ3tWAY8kCjDVp7ZtcBQM0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(8936002)(186003)(86362001)(6916009)(2906002)(316002)(5660300002)(6666004)(107886003)(36756003)(6506007)(1076003)(508600001)(83380400001)(6512007)(6486002)(66556008)(66476007)(8676002)(4326008)(66946007)(26005)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?777LAfQ9yDrB0nwS7+Lyh9P/ZseB5XybQS66WK17YzJ5ON39hXEDSMlcR7pj?=
 =?us-ascii?Q?CGaZVR+B1zHp9AmEknQZK0nFYsOrj/VAj0NkrA/vbrZLee0+06Wmxi71DJNT?=
 =?us-ascii?Q?LapBvgei2/DDkRRid+Hoh6iszWKLy1c5HC2VsvXN+g1r06eG6TsbC9N0WFeG?=
 =?us-ascii?Q?h5HQRvrp//IuUi/C3aM5G9oDSoBeXdS+qhwuRs/g+BJNZATdjmgFEFFJtSVM?=
 =?us-ascii?Q?noBcesgWr6FOYvF95BOKbPuySD8Oy4dcNrV/+VVy+1a9JRO5PADdXZhVACSl?=
 =?us-ascii?Q?Hb4CUkMRX3ASdHjHRK61Aad+TrUfcHQyN0lic2D2nwke5Cg+7TD/Sh8ro0Fv?=
 =?us-ascii?Q?OV85CQf4rZ+6Or5g/puygyHKA0UpgsDzT6ngheASaTGCaCO1kMdjvFcLVMpN?=
 =?us-ascii?Q?G4trQB00w0CvM1xJNTUBuWccUVIVj4eUGnrh/4i6qixsMDjKxTBsjR4qlLjz?=
 =?us-ascii?Q?ASdiXaBDe2y4Ath04HsKrl+Y9m7BpHTcQ9VuIsMrsdy3PHPJRgVQ3CAB1L+S?=
 =?us-ascii?Q?mtzbQLFy+5mVIbljYdJsQXc0j9hzRzkGPA7QZcNu/MEpxVHE6qsG/RLkTk5m?=
 =?us-ascii?Q?MAA+Kwf7zILMicKIZ3syEucJZ5ZSWZRzYRxSy1cDmgwzwpQjc2PogjaxBoHF?=
 =?us-ascii?Q?v9oEtYkBV+o4VXawu70Q/lItTRhcNT1hLX8txd1CLVTMn/IUMXnUiUEFr95H?=
 =?us-ascii?Q?Hc2wYQdlwQDUFGjGFdliYbXaRR9IsnqvedCVs9EePeciWKznbG5G3NFbsOYZ?=
 =?us-ascii?Q?G3iyTWeO0XFOeK0hJu2wtLWiQHkzby5wO2bnzzAw6RLLFxv1qBq6Wo6zDbeY?=
 =?us-ascii?Q?oaZTMOlr+ZNRAj8PShNYXWmyB2q1gskyk88k+8o+ee6KEtiia/6p77H8H4Wn?=
 =?us-ascii?Q?CCG20Gj6NTHFcAiCg2xwl1d32/Aj0iNse5AySgS8dmE1sVw06H2mdlLeeGHC?=
 =?us-ascii?Q?XMiW1dztXV/Irm8DBYjzz4uSfuBeGh5viCCfjYtIYYRlv+MOb1bMBzwbqraG?=
 =?us-ascii?Q?Il+9ucoL1qi5qEWYo1bQ6pMZoGvLeEQS2W+BooVAh7FyJTyq+a+H2Sipa2P/?=
 =?us-ascii?Q?G6scstAMs31ujW2yLsc4MYjyynsPrb7HnRt3ZkEaNRcJA6jIL0EQb4P+bzwK?=
 =?us-ascii?Q?wD/pDpUvDNiqRuh6zqrg6Ddq4ZVIGxOCW2g743Z2sFVX+sImvEluqGSOz7pl?=
 =?us-ascii?Q?0MPyb7YVd5ynj/WqKT8SePuHMM4rMUo3LKrFvp+qfUuwiBf18fo1jDgLw7AJ?=
 =?us-ascii?Q?DtuY/R6Xib/x3UADgH8WS7hScY7KiybO/hEzrbd2eCwX25LWArHQ4fbIjH8m?=
 =?us-ascii?Q?nol6/5Gp4yYrXiBB3nOZRECL/RRZuko+NMrHXp5lsPnN0TbakYipKSo72FuL?=
 =?us-ascii?Q?oJJQc0rQgf/eA4qkbCQHxiSQS7bfk7Mj8UjZfa4uXRvP19c5/toEx0FsnU+v?=
 =?us-ascii?Q?lUKdAAMNgcLuZpVq7bllTzSR1d5FCyuZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b10edae0-a35c-4504-5ef3-08da0b6367ea
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 17:51:20.0052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hNVnoiTqVAyeAYvDtEervm/jLxzWcG/M57D82WhRfZe6a75XnNljZawOdz9PscUwbA0UIFITFnQO45qZFBEkxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2864
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Disable learning before bringing the bridge port up in order to avoid
the FDB being populated and the test failing.

Before:

 # ./bridge_locked_port.sh
 RTNETLINK answers: File exists
 TEST: Locked port ipv4                                              [FAIL]
         Ping worked after locking port, but before adding FDB entry
 TEST: Locked port ipv6                                              [ OK ]
 TEST: Locked port vlan                                              [ OK ]

After:

 # ./bridge_locked_port.sh
 TEST: Locked port ipv4                                              [ OK ]
 TEST: Locked port ipv6                                              [ OK ]
 TEST: Locked port vlan                                              [ OK ]

Fixes: b2b681a41251 ("selftests: forwarding: tests of locked port feature")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 tools/testing/selftests/net/forwarding/bridge_locked_port.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_locked_port.sh b/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
index 6e98efa6d371..67ce59bb3555 100755
--- a/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
@@ -41,11 +41,11 @@ switch_create()
 	ip link set dev $swp1 master br0
 	ip link set dev $swp2 master br0
 
+	bridge link set dev $swp1 learning off
+
 	ip link set dev br0 up
 	ip link set dev $swp1 up
 	ip link set dev $swp2 up
-
-	bridge link set dev $swp1 learning off
 }
 
 switch_destroy()
-- 
2.33.1

