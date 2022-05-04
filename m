Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8298E51975D
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 08:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344929AbiEDGdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 02:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344925AbiEDGdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 02:33:40 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2063.outbound.protection.outlook.com [40.107.101.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6BDB1FCE5
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 23:30:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VST7D/JCAbsBTIOHdIl+f8tphw6UKblc99JDhpf3pLFQJtk5aj8EQpxKqr8N98YAbGoZKjcyJpQXNAsnOe8JlL0ln8Upuv5Ttfk3eCbclUSZEGRjj4pADYBey9Z7HfUc2gqx6Xg2uxHa5aYnMx4hxhYD09PL0KucQziS99QsILw8t6JZtzNFqxfu926KIbW11PFi3nBoSDtEgKfRLMe3cguVjNkI1GuRorrjQNfOv0sfIPtMRqzifhb7unWsla+ZhQ7AtAuckz7EgK7ThONQ2sGGio4eH+2pdzeUDif8NZZ51We5NNRVOoCZ1qTOqq/L+IHZp8oTs/FnRhGFr/XNTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IyQrbPkR6O/gLLhjnFQBAl72imFrazZ88Cafv/nFRj8=;
 b=EUwRj8KQTe4WYUxYnGg7qr6+lm8TJLXZrmr+R5mIdCLjA0nAle71TFIJNIEvhPcxr4Yq4ZZFlQPkK4dYjtWfVApIj3SoJ9QH8Yy8JTzcjRR8C4eY+06+HOBvkI5WFhhQC4F/nHCEs1ep1Cf22DvWmKxuSWFijjNHuLrzUATrESOLGQT4nnuz0VP2ORu3WW2v9qysvJGTKH2CUg5nc9kiKywtLnQlXuzHUvWzWM6A3pzbpIyRqdaYPw/9drJGGS3pJQ5/FLzdROmUuI2AADlwSDdZRmPlSHp5itsBFhIE0OkjMJrrhqm2UKpJLbneUq2HU59c9opSU2tEZx27rM5ygg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IyQrbPkR6O/gLLhjnFQBAl72imFrazZ88Cafv/nFRj8=;
 b=lxLrmGd8zTHy4XEivn0apEFjRBzvqUspAQQ8OKVsPKQGaWhQJgh0qQCZ2/KuRwTc0BjPzq9zklWG3iVqM+1Iol/rZpDoeteVbVDWAyDXiIg6EOFyRTVqs3FDosAdqFMVxG7tVNmGIL90+eWIbSqLkmakI1NHlCu8fKYCFyETU/G/8RtomsHuOtzmRPsHH9kd49i9WjEnXqg8TspgjzbcGgmIHbYuOwPTZf802d7DAXhg9WbSE5Pci49r8cy0eArmXYcypBtqZ/1KPaTn9IMqo5uXPurxbUpEmzydya0Qcy3xY2Yd9fzn1QkE4nmr3QFDa9gcoUxvKuqEHz9gdGYHtA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DM6PR12MB4745.namprd12.prod.outlook.com (2603:10b6:5:7b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Wed, 4 May
 2022 06:30:04 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331%7]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 06:30:04 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/8] selftests: router.sh: Add a diagram
Date:   Wed,  4 May 2022 09:29:04 +0300
Message-Id: <20220504062909.536194-4-idosch@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504062909.536194-1-idosch@nvidia.com>
References: <20220504062909.536194-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0199.eurprd06.prod.outlook.com
 (2603:10a6:802:2c::20) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7cc292a1-9f16-4616-4d5e-08da2d978663
X-MS-TrafficTypeDiagnostic: DM6PR12MB4745:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4745B665365186F35B143089B2C39@DM6PR12MB4745.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gy0We7BR1WcAnwCFu4r5eX59vTACgbgOBX0c+MnYM2IvfsoemGg2jhm83/d8WZQG3b/URkK9d7uUIf+MFFmY4UlBaYSvDGyabUKiYi2unMthIA8Uj0ufzgvNlzB11WSYilRJjPXWkUp/4RYSHKR+uVgdxlnIZtLqZO5jtK2xtTF2x9EWKLfniAV/7+VEbzglNnz/rgjRo+hx7ryzDdN4Mq+NtfZFB8OQLf3GuGIUlAmXk2NfQWW1Zgbusyc34WPupwOoepRRBYRlqjpCFNUHiSJCRzQ7LgU1Ifo49GbT1cOQhB3bfd9GHgZrRCXzsp5LT9G/J/wXF1YMKVA2fc+Dc0LkY9yFytLHHKtPXUbC7Viq9fEZaU+5JfhZVtQ3FneTVEwOHd+fI89aHjWUf7FZJU8GHY8LNR149+bn6YlUtX+mwMB4QWhqb6bCSSIQU+mfX3IoD3h5HEC2wwnHzPFzeQq7vCVMFxSyAZJVTU+Hsrm9pqDz1eqDUd0wLGix+G41tEuTsa1MSL3ZHNdCtTTzDpSWAKV3vfKeVim+3Fhqcq4gFYqipVgy0oqXo+LmUlfq1YMk2Yk9d3ZoFb9TSP+xRh5oaqbLdP4Yc+Q1uxRg5TMN5yDbMDQvHjhGOc1z5KIICGdDiHPRMpHf7PtVqT51kw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(6486002)(316002)(66556008)(8676002)(66476007)(4326008)(5660300002)(6506007)(6916009)(508600001)(86362001)(36756003)(38100700002)(1076003)(186003)(26005)(6512007)(8936002)(107886003)(2616005)(66574015)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gI+mGKjEw+OQaz3kz1RpJr8WdHY9OcLlUAz1/zhN3wMYZkiRA+TNv5vJtxD0?=
 =?us-ascii?Q?5Q/PSkERe9S6bjDYh4a+59ub22d8Fo3ndTLIa5DTW35NN+9EwWnRNIXOgygp?=
 =?us-ascii?Q?/OdOj4zcODUBh4HCsy6/3ALXqKLWH0X9qgePg8/igJ+IldJ0Vfwu4USL2PYQ?=
 =?us-ascii?Q?t3jnQ6RDu7enYq4bTN0BBMle6WBoeBdVD99Af3siA/w6SNvtGCNYKKV/poQ+?=
 =?us-ascii?Q?SG6enzVsfSashk1GcSW3hyW/jMvzJwLqcupULcm+QgFl7KJUfNHX7u5M/fAL?=
 =?us-ascii?Q?Sv9VACF29/9PouK+G5aRZnbfXP/6GqGM3fozop9b6ghzV5XW0nzxBsFi8MqZ?=
 =?us-ascii?Q?WL18HHvV5FvLozp3J5LwtPe4TaTyvGrMZmkfgzaQmXxOMGWcoQGmrk2QGoR2?=
 =?us-ascii?Q?CGOFRBO5ptEZ8IAgVtFWl/Y66e6K/rI+nAeSjzi2seNFf6VCYROHAd9JAZeq?=
 =?us-ascii?Q?DycgNWO7BmCwkgxYBFu0C/jWhdtWluh42MLeM98zC9YwX5srKoEoXyRiB/AE?=
 =?us-ascii?Q?6VAdEZdvUMnMhTSag4zwzN8szJezIjpHpteu4FksCn4M2uM/mTJWoKa0NpOE?=
 =?us-ascii?Q?qXnqGQ3gYCTuOo1oPPNg7pps9mTO67nYCG17OdkkgwHEaxzIhMozvAmXUgJM?=
 =?us-ascii?Q?cqDju/1MNp2m0m3DfkEwEluJZ59ymwhsR8b4WeyqUq1lAoW7k5TCUPKiaRhL?=
 =?us-ascii?Q?dWqVie1JE+to1ASuM9jN9JKwg7mZ58/tFSoNOfEtSIdRHce0p8PZp1YLQQJq?=
 =?us-ascii?Q?X1BzdaFbypbHxuO66S2RUIH7Ji9v2d07nOHBGp8rx0J6QWDcXANVCU5W9LXq?=
 =?us-ascii?Q?hHf7gyMTnILwB8krxGKizRbs/G/o4jmmycLLACoQ8fsbYYJ1obHaBzZ90bCL?=
 =?us-ascii?Q?DLSQdjRddFV5PVm+niXS8XIWhwi0qTQih1WQciJFCPfa/wN9aPnbINS2eM0o?=
 =?us-ascii?Q?PZcuRCJlID/QS6OusqRabgQ5bDCpAwX7fOrUoWftQBJwrX2jTLufAweisxUS?=
 =?us-ascii?Q?JvYJm9li3pMobYlU6ZoGJ8SgQ4qaLdofgpMiK/rcudVpbmOV2CUnPkZbyBBa?=
 =?us-ascii?Q?uAKVGxwjGmT82iEUken1bqF+5miZNVhbdJSEzMVjGA5sbl0cAUpoKLGPbMIZ?=
 =?us-ascii?Q?uoKJx09pCzAADaW6NJthV7j03BhbvcrRBNHSVCrDXM7bue6h7siZFWgRzkV4?=
 =?us-ascii?Q?q6IVGjJs4GdDFpeNS1MiWTVXauGrwT9PzxlBDAcSmHY2Ll8phI5cfhxo22sc?=
 =?us-ascii?Q?VYR+W9nwnQj4i9n8T6lN4aF1RkONMUf5atc2j5vg0wTE6j/qg6Zw2laMg81/?=
 =?us-ascii?Q?SyChjRcC5tDNnZm8a+AQiF+7texcR4pHlhfMzKMNNMuOvfycBoTpjet664AQ?=
 =?us-ascii?Q?/RJK4FkPWTgG5TtjXZkKaVXrSUVeuD8lVK0OuN/9oYIlVtsHSnEvgsmCm1Y2?=
 =?us-ascii?Q?1UV/RLuzWCJqneYw7O4TfQz5hl1PHsr1J5wQxpoWGi9SZUXovfQYGJSUTOkJ?=
 =?us-ascii?Q?GWaQW0las3c0DEyqepQM3xFVZP8kOjEZvtlm2geH9Jig//Q/o5UhJpXBxDsB?=
 =?us-ascii?Q?MHJxwtr34NRAUVDtXVfe9BOTEKAF1/w54s4hjGrbd43rBgUo9k1bL+uTKSuF?=
 =?us-ascii?Q?QcG91s90rF+QzcFf0eM/JbFIv+MXbLrIX4lrnniaej0123yNgNkQ/z8asToD?=
 =?us-ascii?Q?owUN0bp/5SmAA9fYEd8I+4guj8Iq/mA3v6SffTL/YfAd6YIviNw9+1u4KZzB?=
 =?us-ascii?Q?ppWmiGQPKw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cc292a1-9f16-4616-4d5e-08da2d978663
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 06:30:04.5093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 35Znc14hSnYsWldn6CTV5/7CXbpnnAJA86GTE9/BKxQFCEWXYKMCp2tRR2+aTZ6S6huzSmZmrKqFwMULGu079Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4745
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

It is customary for selftests to have a comment with a topology diagram,
which serves to illustrate the situation in which the test is done. This
selftest lacks it. Add it.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../testing/selftests/net/forwarding/router.sh | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/router.sh b/tools/testing/selftests/net/forwarding/router.sh
index 057f91b05098..b98ea9449b8b 100755
--- a/tools/testing/selftests/net/forwarding/router.sh
+++ b/tools/testing/selftests/net/forwarding/router.sh
@@ -1,6 +1,24 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
+# +--------------------+                     +----------------------+
+# | H1                 |                     |                   H2 |
+# |                    |                     |                      |
+# |              $h1 + |                     | + $h2                |
+# |     192.0.2.2/24 | |                     | | 198.51.100.2/24    |
+# | 2001:db8:1::2/64 | |                     | | 2001:db8:2::2/64   |
+# |                  | |                     | |                    |
+# +------------------|-+                     +-|--------------------+
+#                    |                         |
+# +------------------|-------------------------|--------------------+
+# | SW               |                         |                    |
+# |                  |                         |                    |
+# |             $rp1 +                         + $rp2               |
+# |     192.0.2.1/24                             198.51.100.1/24    |
+# | 2001:db8:1::1/64                             2001:db8:2::1/64   |
+# |                                                                 |
+# +-----------------------------------------------------------------+
+
 ALL_TESTS="
 	ping_ipv4
 	ping_ipv6
-- 
2.35.1

