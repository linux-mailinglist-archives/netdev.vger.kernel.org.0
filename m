Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 011286E7EC9
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 17:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbjDSPpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 11:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233693AbjDSPo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 11:44:26 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2078.outbound.protection.outlook.com [40.107.243.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3282A5F0
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 08:44:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RgKE1Tar85qx3iB3SbdB/RJbCwhz/vCre2eJSBq1wNyNSzXk/f5hAM9xB60qh1SmLPrqVrW9gAJ7cNluLV7DPgEjpofvTXqUFKBcBKDGHl20fmIQDK6cbrvMqv+VNeICOZErAe69OA2Bhj+a9wh+RYQTwqG8CZonJlZ9x7LjOelT8I8JZo2OX1Yg+2QLrFlJT6MWJF1gV5GlfQ+/dOFjPex99TCtsRVWgKvnnRIMGclXVysy9U5WH2cSBhlFholzPAemlMbY7fBzaaeB6YIWvPRJOQTRG9YW8BjTZucwD6NWYirwv23FllbsyjyWnjP/aA1othD0aH7tZhZRIDAPdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vi7s0RwPyhqvcDYs8aWPVO2k74KjD0DauGSmUPadOrg=;
 b=By/Yqg640J5+pr2p2hDwVoYbwXvnc1nBfR/KMxjHpqhZRqxAzwSsNaZB7vNNZ1z54RkIQh4bsy5FV7FbE2CVjqU24Fj91ZtJVUixQi3FY4tOo8qHpzx5jBxy+nDwZK/LBIDFCBylPw4l8bm+ipuIYoDlmACwx8s/OuMpG0qv3OTmxnWFsDl9VHAsFVk+G15gk7Um4FlwY/5QX4f60K3o++NgEsu3PvS+kmwg9wd+IDOql7MMzQZ0aOFY+5IvNL/BIqY79bNgqj1RpnQVBVCPvFOyGGTkfBppn16erA2ecYrAKEirr8Z0TmlgLaz9o8/dlPt6W3Gyy70Iyp5n0oA7Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vi7s0RwPyhqvcDYs8aWPVO2k74KjD0DauGSmUPadOrg=;
 b=RHAjTM71akKGUK6IW739+yWAGGkUmwLIkk5iR9obkA/WsaOdsCrHDyj5UHUs1ehcBP9eVgxwKQtDPJsT4brnd6L8aBeY8fD0/z94RS6+VqnZUWWwPlbhFX4afh72WTwhXaNa2TSe7q5LpCDJ3UG6L3Ud5+dGYoqZgAeohE8Sko9eoWVoiUQE721OEzROSr+HLpy2C/Smr4BPR9Dbs0NjU6YycewkX2c4bSbHw16gCwFRyA88N6J5/UQww76krJ/VvNT6B3t5bt1UeQ+uE/ajRMWgmk2gz7PS/282FzqiRhe1CIf8dJMhnxY9D/hy/Xqz8aQfTIm5XnfU2pw9NJu5SQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SA0PR12MB4446.namprd12.prod.outlook.com (2603:10b6:806:71::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Wed, 19 Apr
 2023 15:44:19 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697%5]) with mapi id 15.20.6319.022; Wed, 19 Apr 2023
 15:44:19 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com,
        netdev@kapio-technology.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2] ip: bridge_slave: Fix help message indentation
Date:   Wed, 19 Apr 2023 18:43:59 +0300
Message-Id: <20230419154359.2656173-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P193CA0022.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:800:bd::32) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SA0PR12MB4446:EE_
X-MS-Office365-Filtering-Correlation-Id: 86f93b25-f988-468f-27c9-08db40ecf07d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pBLWjddKCKgVFeR7ONZ7ZtF9b+NSRszad0wVKBp8Pdt/C+jQk4fUxxUkI1z3tiefJJrXn5ptwR9KZtvgRFeK4ypD7g4bzZ2SnQWyjpNMI38I/kQXM1zcyeQYBkDJPKwhwfs1AwwmCndhmouqrC7GN9BQRtZfB9He1XW5xzuIeD8d/NfIQueSv7int11pLnx1d36KYg0UbUYaa80aAVPNMYQgWOnDTJxHcbk0v7EHS7cZBjnXR1F+16sLCZSMv3dkwOdI4XXIIdDPTw4wc6zCCl5lmlAijeggL2y/OUpmo+E9oyRwhHmSk/1AF0uVJHC8342uoI2ZkoG2nSlawCUDF25LUxbfWQ1GokE/5cfRrgyfRCPXVo5wVmSKBN7jYP+og0MOzkuuKVgR9g6RIZWmF/IhNB0PLrzlUBZJQU6z3blTPBIf+EQBserXi6F1PEu/vr63tOZNAfiO1tVORPmxhKdm3A0yDRkYaYvKEZddXbGYCmX1wcO6hvetjCyDq4WdwjvrqVI6O6Dj6WA1lTJDuJLXayGbGDABgSYqgjk88zFbgzAVmfrKHEL9jMxnozUh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(346002)(376002)(396003)(366004)(451199021)(8936002)(38100700002)(36756003)(8676002)(2906002)(86362001)(5660300002)(478600001)(6486002)(6666004)(186003)(107886003)(2616005)(6506007)(1076003)(66946007)(66476007)(6512007)(26005)(316002)(6916009)(83380400001)(66556008)(41300700001)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SpKYb6Zh5CDmlWLqjd/Br021xbTZPVBqlSsx8ahonLqKHQaQi2PtAxGSEF7d?=
 =?us-ascii?Q?NNNOh9WFR1YmkC2O0y7aCC8WR/U0MBqOSH4GItREGmTJ614HIVv5u0P8oLu4?=
 =?us-ascii?Q?Umk/SLf8sVxXmc4eXTx2ClMGKdWooFK4SqEASWl8Bdybw8qs/z5h+9I16kJY?=
 =?us-ascii?Q?i73JC8O/7Y3obWdFJol4fxXte28yFTt2EktHWpSXwCWCKlsBeStFlUKTnV//?=
 =?us-ascii?Q?7/giaE4YOJdm+/uBI6NR6dVrm27hSWscqSuDgJdoHy/HLo4LIhejlm6wM9OX?=
 =?us-ascii?Q?589AQuRVYfsub6dWgShrj0D8HdyjDSReqAQPx6Z5M0ZJEC1Ib2ywcfsp0SNP?=
 =?us-ascii?Q?KyezaLsh3xWOUHvNPsgrS0044bEAV26YYukm1pzd+LscUXQpa+ePpY93RbRD?=
 =?us-ascii?Q?Jx/PUf5fj8yv0w0BT/9Jshz8BznXilkLE0PQf5KgjE3HhqwvHkixtZgWp23T?=
 =?us-ascii?Q?ojI5fkk0qa2aqilbPYZ8Zcz0TCjAvBVTy9scpb8rkKsVk8JB6SEWeNkCIgQF?=
 =?us-ascii?Q?6SjIIVgqEigExyjyFJPwxhoK0JhB21aIydEi0c7AhLM+8yjsQIJR+Ti+q83e?=
 =?us-ascii?Q?dXPaSs1CqyF1mqthpWKMvbonlOo0iEuP6NBG4tne1RBM9vAdR1ZIsOjuvDg4?=
 =?us-ascii?Q?RqJidn8bQb4ceJ5myOPL2Cl/VkBFTorTSsm049wjiBuowvTHY7tFYBtba7d9?=
 =?us-ascii?Q?+5hVN45OF+a2Ni18Yvl9u3+VYTQAnGvCkbBDqJaFdV0/kMyC7ZibBNm1B15C?=
 =?us-ascii?Q?j5PGf/Bz3cwLtVjYTKzJRL2A1Fn7ydawQE9quELUsAjCWG6j0H8+93bCcOFx?=
 =?us-ascii?Q?isr0X+6BGC7X19PcU8GR61JWPZX4fp8jB5ewJ1cNIZDMVUi/dxjp2Wyx/jaf?=
 =?us-ascii?Q?o92iTpvbEpK5FFgyrdSO/LH3J9wGPBxU62nQAMWirwnwGT51L6lQ/eW2m+5r?=
 =?us-ascii?Q?kvpELQJa3alC1A2WV9LQL98D8le1aePGCuOz2KshpgNK3NTemN2NW8GeIs7e?=
 =?us-ascii?Q?EKafU3+swWjNaIBAVArcsgL/ohmvbCuw7nAu7iIrtdf2jKKMmTKN8aevnbvU?=
 =?us-ascii?Q?vLGUx6zxcGafM/YF+c1DuyTGZCLN844trDQ8sl3/FUGNA9Au+ADwhVwcpyts?=
 =?us-ascii?Q?8IeInLdr7zcSdSXtxcfXdx5ZRRc1IRD4/x24ocoe4CwZDH6GlaBMvVAHQutZ?=
 =?us-ascii?Q?8NL2XwiQL9iqnR53gTT9/O+M+6Ng9Ay/RuUt/7B5X/KRMESxmyJn6e/hvzs3?=
 =?us-ascii?Q?DZtJcOBIdcuXgy/RXYsiNRy+qT5p6q92NqeZpXZsvgfTymsR5lxf/HGcPtv3?=
 =?us-ascii?Q?UqGBQ0yFwb/P0hJDuDUYflRbIErV0lwNnmdmsZe61JwTczu4Di5QgBUHQJSx?=
 =?us-ascii?Q?d63z2JL2C4Ltm9QZfS17WOFHuDhF9BGKh1Z8Mqzde3h2HWQ+G1Ry6Jel+zlM?=
 =?us-ascii?Q?f/0RY1ySPIp2LUtwtz2LQnvUg69pGl3Yrmy8OwUroXkbk3nzhrBHkZc8qSfn?=
 =?us-ascii?Q?TqxQYFexxyTuFWCMQHWja2sStk1ErFrBDXHNgtVR5gUMJK3zpD0b5+P206Ds?=
 =?us-ascii?Q?uxOJpZEyB4XTLmeMasL3xjPQeJLCUKU50gmBN1Pd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86f93b25-f988-468f-27c9-08db40ecf07d
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 15:44:19.5706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vU5Q9b4d9hSatU6w/xvvB99qV8plhZvr+cOELOiGzstxKkGh7mxw9l+lc7bE6mEE9n1I/DpUXWZYgZv9JhbJIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4446
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use tabs instead of spaces to be consistent with the rest of the
options.

Before:

$ ip link help bridge_slave
Usage: ... bridge_slave [ fdb_flush ]
[...]
                        [ vlan_tunnel {on | off} ]
                        [ isolated {on | off} ]
                        [ locked {on | off} ]
                       [ mab {on | off} ]
                        [ backup_port DEVICE ] [ nobackup_port ]

After:

$ ip link help bridge_slave
Usage: ... bridge_slave [ fdb_flush ]
[...]
                        [ vlan_tunnel {on | off} ]
                        [ isolated {on | off} ]
                        [ locked {on | off} ]
                        [ mab {on | off} ]
                        [ backup_port DEVICE ] [ nobackup_port ]

Fixes: 05f1164fe811 ("bridge: link: Add MAC Authentication Bypass (MAB) support")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 ip/iplink_bridge_slave.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ip/iplink_bridge_slave.c b/ip/iplink_bridge_slave.c
index 43b429485502..66a67961957f 100644
--- a/ip/iplink_bridge_slave.c
+++ b/ip/iplink_bridge_slave.c
@@ -40,7 +40,7 @@ static void print_explain(FILE *f)
 		"			[ vlan_tunnel {on | off} ]\n"
 		"			[ isolated {on | off} ]\n"
 		"			[ locked {on | off} ]\n"
-		"                       [ mab {on | off} ]\n"
+		"			[ mab {on | off} ]\n"
 		"			[ backup_port DEVICE ] [ nobackup_port ]\n"
 	);
 }
-- 
2.37.3

