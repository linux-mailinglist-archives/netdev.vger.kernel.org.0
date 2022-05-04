Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAADF51975C
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 08:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344921AbiEDGdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 02:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235785AbiEDGdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 02:33:37 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2082.outbound.protection.outlook.com [40.107.101.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E2E82018B
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 23:29:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oy1Gcalc7C5PMtwq8ZxvYGv+bVsIi4/B4lDry4EoQv7+7rg0yExAqt73iziqgyk81qTk1BVHgQkNz+gtwEz1gILa6/SRPgHtuN4xhaaITdP7QWHHppbG8hWiQac3t9wO/p677tYwJdf3MNYJ+uZX0WnuPIjmwAytGFYGjy+ZVH1ZlZ1yQ205teJvJSN+lQyXvi9FISKvG1TPdYDOioK8+6u5qoxVX56PwgHGC4MpOoGqQbbRS0czXcuBONx+7WGyoSnLWdc+t+DFaEnmeGleyAqCxNYNkLckwktmdS3hPrwmGtzewu5DczEFItNMpxP4311sn/QxT9tMYfh9Cm8kDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yAeArEl2QMlV4mb9hrm404qQsXiWRrGnM/IFWJ4AQzU=;
 b=mS4HkZ62XLpkrkkgmbp/f0w7RXqFVpovtg13bnyYzfNZgOrpxjTltCTg7Yt/GuHVKuHa0WM8hMLrwIQD6ynoLpYyp9MKS0O8+o5591p0F1w7PF1I0p7iPdfbpu2Xlc1ZRMnVrA3OyUR1Lfw7W3vqB4XpHBGwBQStF53ZAbsmtBvo2Kpr7OcdE5f6dywJSWYDnprQ1ZeqU7lmxY/gGaHIO9A0W7gvlsc/KX9zC3OeooHbUkpYt03LIEuKkAFYLt6J4J01SP3DqT8aXGa6QFHaed1eKGwv7CKmv6D0FPyQcshTSizEuFaZ+7nlJt+U7UlL/Q2wcxrofN/UDxQ1ZHSCBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yAeArEl2QMlV4mb9hrm404qQsXiWRrGnM/IFWJ4AQzU=;
 b=pE9+ZSsxJq7/+b5Qg7+eDDGvFzHIWtRUWJP8JOv5jWJHSg/7Jo3ZKfPHT8SO3mhbue9jhJ+vbZ+a9xwAhO1k5c5FvAUDUUWz+GPdwHaZK5iuDV/Nkurt2IZbiyt3wjNVH/gnmU8kfH99JtWfNwO3Fq5rHddJT7eZ6Qz/HFtC83kqvFyqaepqWKf+GTHQHhuAYkd99qbZjz/IgvKRu9O9Bbz6cC9EiF6WvLhz/uRrX0WwbXMcwW8xTfVm8pMv7VwTC/fO2aIdnZjnRyFBniG3Qe4pQ2/yqMrZMSfd6vLoFN/1Oz2O4pGJqHQ2lPy+glt4/tKynxKznW/rAzaYYWdf/Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DM6PR12MB4745.namprd12.prod.outlook.com (2603:10b6:5:7b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Wed, 4 May
 2022 06:29:58 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331%7]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 06:29:58 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/8] selftests: router_vid_1: Add a diagram, fix coding style
Date:   Wed,  4 May 2022 09:29:03 +0300
Message-Id: <20220504062909.536194-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504062909.536194-1-idosch@nvidia.com>
References: <20220504062909.536194-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0156.eurprd09.prod.outlook.com
 (2603:10a6:803:12c::40) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ddcac64-8e2e-409d-14c3-08da2d9782c1
X-MS-TrafficTypeDiagnostic: DM6PR12MB4745:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4745F68D0FF8F060AFD4ADF2B2C39@DM6PR12MB4745.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B+BlY19xWQmCPrzcasXQYlG1xYYXdOMbxbCs8GdDRwJ8SRYHl8QBjqPVlvc/hK7dtYhVIXlTYzOwwC0/P/vIlA8SdtvHkmd3c2/Ybvxk7/r9JlVijS43ttEfToDCLEFOUTYr6nkMs3JnNdvUZCjMrW6ozO14Vy9I000YFn9a/BVLe2uJAXp7q+Hgq/dElCPdOtHaUQ+ADZmceqvBXZgUTzUs1ET7J57CtaRYRcZwp69GQidkdju7zkS5rZsB9S7zP+yrJvUKuhxvMdCBAlni3gpdzXbdzePBLQPWmMDNiy2ab9FN/opEFcrwgZc1MNPOjR4jbg0KNGYxki4P5vYuIKZ8VrTUwQqzQUf+l2FW/ugx4ZNz0gMmOHhyXwfUgdSnd0lctIZasUPN5cBsscHlQHOBnNAFk6ZOtuJ02sLQ/V+I5IGEGbUeoZWathABKLGAEoWGFz/SLyEaAMGbJz0+Bq6R0FAQNMuw3qyXCRI5V76+Zmj/sT0b6sO1JP/EBSSjyjDBmU0BjQE4k/IJtiONzAJRlEe7x2mCrjY0QdcH9e+9N2A6/UfpBRf33+F0NhfzEgm+J8+VFDXioQ0KUdGbUyMV5q/hYuYFQFgYGpesVO0++TIugvDOAa50exazDzfnCQy687z3TZ35Nq9FhDLNlg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(6486002)(316002)(66556008)(8676002)(66476007)(4326008)(5660300002)(6506007)(6916009)(508600001)(86362001)(36756003)(38100700002)(1076003)(186003)(6666004)(26005)(6512007)(8936002)(107886003)(2616005)(66574015)(2906002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z+2AVc1qw6OneclDLsX8I9yLWivtLw4V10fNQYXjzOcJI2fE4Pgyse0VS9jU?=
 =?us-ascii?Q?zSYzbXy7u/P/U+rEv1TB/ERDSqkng3y1jer3IsM5R/tfbksmDAuHFI2b9M5M?=
 =?us-ascii?Q?KxRQQqTSqPD07ZMXPux2zKiS9OXUbE3AQ0TaLf1dhzLeGojBEdVCyseY7hWj?=
 =?us-ascii?Q?jwtfMWCQ6P0jFcCbbfGRp0oXhQs38ybWlNaz6pciKt1z50LUKOuVj89e1Nx5?=
 =?us-ascii?Q?6niqAzTy5Mb+/zhQAy7gqwdZtbXNQphTemKRVxho+xIDbnWyp5N3HRKiMvf7?=
 =?us-ascii?Q?UPfFMEAP+tuznx4vhdWPEbzgRE2Kl4DoEppvZildr83a6fzA5is8p1G1+QO0?=
 =?us-ascii?Q?1FE4dDsPlcYiSMWPfK872DtmaZEa5TK1BxB+re8Fx0bU2bOWovXBPsUWGN1k?=
 =?us-ascii?Q?BQ7CDGXTMKfkIHsktK/ZvMxbL5xTFrJ1294NQjlBtqIG/bzdCBCCM1JBHi1E?=
 =?us-ascii?Q?EozqlkYIH9yIZ33fXXmxtiRfr2CFOxMOLFlXr7CuGkdcod8c39WJCLZIW3QO?=
 =?us-ascii?Q?ry8Z/c3DTLFdkddo0ZU2htlYR5CZkEsmFFTVmddfJRyIyW7Usni8JtUlAGXR?=
 =?us-ascii?Q?GfDE1E+GdaQPpwXndwqPfwYUjoTjSa1SlwOaLYBvp2vkemVV/DnEcp2+ZTxY?=
 =?us-ascii?Q?TVfV0xt7aYUKqsb2+I8avAF3+veWZnJmVJDy7aOQK0At7mPYGDxuOWzsb9je?=
 =?us-ascii?Q?qEI7gNc3EczSD5UvF8hASE5tqD0c0BQycKyS+BZUR8msKXdwPqUjzQjBHsv7?=
 =?us-ascii?Q?mov79xHLAuCuSD1nDfvO+9u0RSfL69laeVow7EMUbD4pkEcjKyUyDKu2i5aw?=
 =?us-ascii?Q?8gE9KMjFN+wq8LIoH08dHrRT5cnrJUeS6Fvrv2zcGdUJm5rh22iZJJeDUDa2?=
 =?us-ascii?Q?WTKtkE4vhBAzDvJwIN5r21DH9k27kkzOqsdOltBqxy9kPtX3JvIP6xe8iO/w?=
 =?us-ascii?Q?0F3KZN+KQ5/Y5gGylB+hQpkJyaEYR2BYYG253Kg/sHC8bR+KP7miK2+zLBzD?=
 =?us-ascii?Q?k2yKi4f2jgMYb0G8wmOSw1D3SD69SdrpIiNEY+gzZSCGIcF1yHMQDPIamLB0?=
 =?us-ascii?Q?virMo9oNgOe82XtcZSW7no12M4R7hRA7xuyWO4v3Z9+Y423whueanreeZuRz?=
 =?us-ascii?Q?rBElM9XsFJCIPsytzo4GvDXOV+bsbbVSeTTuxheqYcsU76WtAadhBYjvBTYs?=
 =?us-ascii?Q?2G3Grh80hm1JjOApK3M+SYesFnQB2d/2MIk2XyvxYRoG4xfdJsi71ArI1veu?=
 =?us-ascii?Q?uezmHt3kAADjH+JNYOqGYNF0OjPfMEqsslb0BAQ2oQSSN4eaE0BGaXoCD+8i?=
 =?us-ascii?Q?c5H6PPy5r42fCABjk5X94poyZbL9mS3vrWCI+gNMfA94Yy4os2kUiwszMgXQ?=
 =?us-ascii?Q?pWSsWzGvZ2AqKf8pPDeIWjRG+89iWNwIoNlCLZOT+bzgQzmDwTGoES0pyWXG?=
 =?us-ascii?Q?EAtPWV89C90UfZBjAfHX4yGi/8Ze/i8sMWPh7PeuAtiJvWr990oimzYYVQmT?=
 =?us-ascii?Q?1/PKon9PhjW4pYsZ4AtyA+kED9XPmUZWMc40cGlQUTuw+zVvAR1cNTxovkN8?=
 =?us-ascii?Q?G/MfAUg1/bFrYo31FhpcAwR7Ocpsu51QCblGV40ZQAtC2LIK2tGZvE/5FzuW?=
 =?us-ascii?Q?zhH6wRPiU0A4FoVWnu7WEY+OAgvfAw7HmT/p3O3vX/YTgzMKGou73f0PJQQE?=
 =?us-ascii?Q?flVC/aRZWW2ox3R5LnaV+4XU+DEKD75ygURQV54xGbWhywpmpnhcx84ieeJT?=
 =?us-ascii?Q?VqEUA5Wj4w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ddcac64-8e2e-409d-14c3-08da2d9782c1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 06:29:58.4130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PqpXCqixl1x9MBvEcb3sWqr/JlDwmOYzPxEILDBK+xeOyYPz+oA4yB3jAr3lC7RyS/ac2Zcm+U9rb6ozYD6NpA==
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

While at it, fix the list of tests so that the test names are enumerated
one at a line.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../selftests/net/forwarding/router_vid_1.sh  | 27 ++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/router_vid_1.sh b/tools/testing/selftests/net/forwarding/router_vid_1.sh
index a7306c7ac06d..865c9f7d8143 100755
--- a/tools/testing/selftests/net/forwarding/router_vid_1.sh
+++ b/tools/testing/selftests/net/forwarding/router_vid_1.sh
@@ -1,7 +1,32 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
-ALL_TESTS="ping_ipv4 ping_ipv6"
+# +--------------------+                     +----------------------+
+# | H1                 |                     |                   H2 |
+# |                    |                     |                      |
+# |            $h1.1 + |                     | + $h2.1              |
+# |     192.0.2.2/24 | |                     | | 198.51.100.2/24    |
+# | 2001:db8:1::2/64 | |                     | | 2001:db8:2::2/64   |
+# |                  | |                     | |                    |
+# |              $h1 + |                     | + $h2                |
+# |                  | |                     | |                    |
+# +------------------|-+                     +-|--------------------+
+#                    |                         |
+# +------------------|-------------------------|--------------------+
+# | SW               |                         |                    |
+# |                  |                         |                    |
+# |             $rp1 +                         + $rp2               |
+# |                  |                         |                    |
+# |           $rp1.1 +                         + $rp2.1             |
+# |     192.0.2.1/24                             198.51.100.1/24    |
+# | 2001:db8:1::1/64                             2001:db8:2::1/64   |
+# |                                                                 |
+# +-----------------------------------------------------------------+
+
+ALL_TESTS="
+	ping_ipv4
+	ping_ipv6
+"
 NUM_NETIFS=4
 source lib.sh
 
-- 
2.35.1

