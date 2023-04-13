Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22BE06E03A1
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 03:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjDMBXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 21:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjDMBXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 21:23:05 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2062.outbound.protection.outlook.com [40.107.94.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D514E5A
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 18:23:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UM4o/JvM1SUwHlIEfLJprvnrnVYdK1lgcgI/yfYgPVHW0NO93FqBayMLNkh3XFkRJO9RUTs1cAfNZJNrN5QRBrjU6ZKgfTIiVoc/q17/TspaMrrYNziDJCh+HByjdnpDmDQTlJfzAqDH9VhOpDNxKyDKkjjS+w6N75cOU6eWvWnXqyUoumcYarn4R5hAjBYqS1guX3KxWm0kpbZYjPAKpUgmzjYl8UkKZ3fdmOzEEZeo7FJKRg7VsK3fxASMSZQQiG2So+irWLz0qK1Gg2z1YbkZvvdaBkpPT0UeTn1BKzwbzNc6MMh9d9NAeesGdDCuCDfPBqkO1LM2NIhuP2rdSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gloabLsSSs4Hq+luZzNnDgMd0uPPUoDv5pC4Rd9lFC0=;
 b=ip8Ll4mncARCsUCXqCrK8NQyTfM6YL2U/+DYaFW8llbxEfaoQayaj1ggKn5zCKk2oy38wovqr0sXKKAxkctchPOyALo/ZrBC2qmYeTjKmmu2MxBv/dZCGNDI+8LP7hEeiTgYEYo+/Cgau4LY75f99Yd78KwIlQUr6lkKwiy+CXCkS+rKjlTq69JHNwHguCPvUkVYvh/mvxKwkIAHlHgZusRW6mYeHS2QpF6NCL7mGbB4BHehskVL+IFAU7eiscr8lVPcaAvvGfUxghZxbE98uJPJ0y5/iVm3ErSI6jVMx1fkEtu4yh8JEMTBCJUcPn7SQbQEMRhUSj5nYsM1BheEYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gloabLsSSs4Hq+luZzNnDgMd0uPPUoDv5pC4Rd9lFC0=;
 b=c+sCLUKBbEW65X28xl9SED53+5VfAWkgl2QzSNkwQ/DupEKOMAAYiWpdChIdYcvvpMN7ctDpJjr/yMEFs61yWW+ksxsbA6T2kgmL/oPTjJKuDIGhnuzXSG1YMbUY6hJiDuG4+pcJWuTXpnzzdDBKOKQG41saBLaMcqkd7zUJPbjYuZOIUqyOO6f1+JtJ70+WFe0+PeOofwsrDFKRUrK8ORUhoBbph0wpod7x2wcsEBTjQxSy+FRSRYpkeyuzAoz1jIous3IuU/Hy15xpMOZYft0vWIxt4ZzcX2G2kmGBLu5feOc5CewlwAN/EhmZyvAbdXE5cCjTRBbSWAivL8Q2zw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by MN2PR12MB4335.namprd12.prod.outlook.com (2603:10b6:208:1d4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.28; Thu, 13 Apr
 2023 01:22:59 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::f6e3:c3af:67f9:91e9]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::f6e3:c3af:67f9:91e9%6]) with mapi id 15.20.6277.036; Thu, 13 Apr 2023
 01:22:58 +0000
From:   Rahul Rameshbabu <rrameshbabu@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Stanislav Fomichev <sdf@google.com>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>
Subject: [PATCH net-next 1/2] tools: ynl: Remove absolute paths to yaml files from ethtool testing tool
Date:   Wed, 12 Apr 2023 18:22:51 -0700
Message-Id: <20230413012252.184434-1-rrameshbabu@nvidia.com>
X-Mailer: git-send-email 2.38.4
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0016.namprd21.prod.outlook.com
 (2603:10b6:a03:114::26) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|MN2PR12MB4335:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ac64842-2643-4cb8-efb3-08db3bbd9dd4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N5neT9lazse+9rgLRbDv6iHm1vj5esssaSwlS6i3/5V6DNVKNoNJEAvaLgnFStN8sZhr2Q+DqBhCJrr8YRbaSf2RMweVTi1FUQ3gE3FTUnxyA5qW1UePQzBs1A0MfEPfEhid3Cs3OtoVi3n1e2aIzriSm/kML+OQ9gY3/LXQfNPJyDCj1rHPli1V6+KM4OXMdnv/xBqTILcCkhfGEyI/3cCOrvp3T/TqEfxwosk0krOu5Gt79Jd3TqWaGrF9YdUcXItHViaayMaj0t5B1yNA559LCOxGaPOfxZAq+SbwoOPVfoV8sZ6TSb1mZlU66IzL9ZD/TqvJ6mTM3YaNeJ4aC7dEScVo0Q/HK0cNA+cJKtW2oWEiH99AF+MC+fMVdxQf0yaVdBwRIHs4sYOPfW4rG1Y+sgYy10B2YvRqTlH41pXFD5IFLbCz7KbMnhKLfCffj96alDTqvqp7kHcZ8sc/b6xRqAPFOOPZvnY9yC4Mrz5KC4+5AVXs47/uR1UU8+lgru1JwTLDRGimk12zBaO+rrzyTq+DYz/COD3AZ1QFlYF8kYv5hvzjXPfN4E9Ie3L+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(136003)(39860400002)(396003)(346002)(451199021)(478600001)(36756003)(38100700002)(5660300002)(2906002)(316002)(8936002)(8676002)(86362001)(66556008)(41300700001)(66946007)(6916009)(4326008)(66476007)(83380400001)(107886003)(54906003)(26005)(186003)(6512007)(1076003)(6666004)(6506007)(2616005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fqWuRG65nJmw/dgVrUha8XuMo2RO9iyM92SYgMi17d++sjC0Dv/nozOgBWDz?=
 =?us-ascii?Q?A6Ct1DhuzPhXIVrmuJwEPdNojFz5xwwieHsgbCj1f5RpftrOHG19UepJlS6n?=
 =?us-ascii?Q?2eN/APC0Gqenfx5tRo6o3kVk1XTBqiN+uWGXk8VgDXwVnPp/WPMCjmhnuvbM?=
 =?us-ascii?Q?sEI7gRH6HPm8q5kryErT+uIwcPu8Ze6U+JTUXcFS47VdsR5d/xf763zoDk9p?=
 =?us-ascii?Q?eCjtBtK7gLA+0mVt2qW6YvPfPscxFYskfJvJnkdoGaGCn49Yq1VNYml4nJzo?=
 =?us-ascii?Q?Hq7sPZllL9HTQCecAd1DzbP/3x8vytBMZkT1z9FsqHPmprOgi1ZhRaQz37mp?=
 =?us-ascii?Q?eOPv6U5iP+TJb/LgXhjhIKex8NhDL9LpQy5pElF8jFY+Otpn1Lt9SLYyWaTP?=
 =?us-ascii?Q?a4m8yulINdkeMu/cxcLFOwgUmpO/W0EHvyx/O7WScwLzmOd7Z1QSvGrM9Ip7?=
 =?us-ascii?Q?OT3n8kmeccskVEGHdFGSSXZh4wKUORYEQCuZbhEhlcVcxKoPqj/pHPIOKbnI?=
 =?us-ascii?Q?lW654TCqSn77EKJxf39N2N34hPzQCCv3xH1AMCBWETPpYPd0CvwcOhmA/oCm?=
 =?us-ascii?Q?KmSORxqiYjKZ5Hxmcwv5QviL4SlIv0vypRp3PEKFXTqk7hx1szjj+LWujWPK?=
 =?us-ascii?Q?UJru/9RTdq7nNYDZYhoXoiTqgqSjbRTWs61O40R1i6hvJl+ZGVzcidnQY6Uq?=
 =?us-ascii?Q?+cjzljGrlmDxPI+S48bEiFqeON1NGuSx/sdI4KGC6PG9nkZ/d19w0uZNUm7E?=
 =?us-ascii?Q?me03EsC7a7X/bn9DEHcrZBjoZGuCp3MmIGspl7HDBeUutjI2M8vHWODHgpqT?=
 =?us-ascii?Q?TO3MeuQ7Hj7elK86RjO0+QQE6wa3Ngw5uSVKizZcevLSntJPrtxPQaE2vDKY?=
 =?us-ascii?Q?eyoz3ziCjYcIi8CaNGtj8SdrW9HrdxihCsByA38Uk7G3YU81qck/HpTD0luZ?=
 =?us-ascii?Q?j2UsZjsYXrlFBSqSzFRUaVDkIMc3UeJXzDtC/7XzknjCias8GSRZ53j0cLxk?=
 =?us-ascii?Q?HC5vqqHQc7TQ8PuQm5CQGBJlFT1wUp7nXTPHF1xdkZbzRfE5flTmzQQNsSqO?=
 =?us-ascii?Q?VV5yizdixJ5XGtVazFHp0yo5pEnpKtGRxPZZV99JhiiC3ayIOA8sKR4cl1B4?=
 =?us-ascii?Q?DYmtFQFxhrWEkbOw+P1E2hNuLZve+qee7tmRRz6DHtXgyi6GWMPj9RNozcdD?=
 =?us-ascii?Q?dHJMAcbRlNUw77GvPcaXEAO98dsZYE9j4tBJdTxHmcOzbD/rxurnkNylDCyD?=
 =?us-ascii?Q?J/ouRv/Z8E1IuQIJdcYeEziCsyLwwt9ikktrTyavOtxiuf5OZNblEjzw1mbx?=
 =?us-ascii?Q?VxRdRflU1eZfP1iwQInTxuusqKvKXNWaqHJb7DQtkO3SRMSqdDpAaNpR71pP?=
 =?us-ascii?Q?/2ACJMg2sFkRBt+QqXOBGNVFxMwdSoKpxppXNXMArQYwRa2OurgXfJhUAX17?=
 =?us-ascii?Q?129KK7QwyH8Mmk46/OaxgN4WpSP6XujyexCZ/dutvBqeAU6W9xW1vodu5mts?=
 =?us-ascii?Q?Jeu8s9EDyWbrIdEvLHSR1j6cDJSGJdChDsjtMB8JEUsZ1cg/taqVLjcLYGHu?=
 =?us-ascii?Q?miAnnemzkMr4M7Em4uqMSafVaCITiaFl50nQqBH9EB51C1VnL3ywwLw3JK0Q?=
 =?us-ascii?Q?3g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ac64842-2643-4cb8-efb3-08db3bbd9dd4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 01:22:58.7311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Dmz6BgyMrRNlR/7J2GuYjyGhnPAiivLQyxtw7x8L3oxue2xhoC6r5cZwGVzJhQuBsS6YErHLZv0Bt7h/ijODg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4335
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Absolute paths for the spec and schema files make the ethtool testing tool
unusable with freshly checked-out source trees. Replace absolute paths with
relative paths for both files in the Documentation/ directory.

Issue seen before the change

  Traceback (most recent call last):
    File "/home/binary-eater/Documents/mlx/linux/tools/net/ynl/./ethtool", line 424, in <module>
      main()
    File "/home/binary-eater/Documents/mlx/linux/tools/net/ynl/./ethtool", line 158, in main
      ynl = YnlFamily(spec, schema)
    File "/home/binary-eater/Documents/mlx/linux/tools/net/ynl/lib/ynl.py", line 342, in __init__
      super().__init__(def_path, schema)
    File "/home/binary-eater/Documents/mlx/linux/tools/net/ynl/lib/nlspec.py", line 333, in __init__
      with open(spec_path, "r") as stream:
  FileNotFoundError: [Errno 2] No such file or directory: '/usr/local/google/home/sdf/src/linux/Documentation/netlink/specs/ethtool.yaml'

Fixes: f3d07b02b2b8 ("tools: ynl: ethtool testing tool")
Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
---
 tools/net/ynl/ethtool | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/net/ynl/ethtool b/tools/net/ynl/ethtool
index 5fb1d670693a..6c9f7e31250c 100755
--- a/tools/net/ynl/ethtool
+++ b/tools/net/ynl/ethtool
@@ -152,8 +152,8 @@ def main():
     global args
     args = parser.parse_args()
 
-    spec = '/usr/local/google/home/sdf/src/linux/Documentation/netlink/specs/ethtool.yaml'
-    schema = '/usr/local/google/home/sdf/src/linux/Documentation/netlink/genetlink-legacy.yaml'
+    spec = '../../../Documentation/netlink/specs/ethtool.yaml'
+    schema = '../../../Documentation/netlink/genetlink-legacy.yaml'
 
     ynl = YnlFamily(spec, schema)
 
-- 
2.38.4

