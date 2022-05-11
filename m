Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADF45231F2
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 13:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbiEKLjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 07:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbiEKLjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 07:39:47 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2100.outbound.protection.outlook.com [40.107.244.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF3A67D04
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 04:39:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bPysoJ73wy3IsK8r93X5PgxFfU2HgUCtPvnxULDLBJDakZNQoY9qgiuNoij0N0Cpp7nwMs7a9LsW/h7okDcOvX13UIi1yZgyM6mhW9M03SLZYBL1I4UkbuTnBAHOPZ1/NXbXyCbZEqpK8DLmbaLtVp1MzpHjPMWL+C69UXZo9Jaq62Whkj9bIuManM4neNqjXlN4y7G5o3WWQWnUI3XZtVKg7vUQ+8GQlwotIkS9LuZSTynenGZHS80LtNIVzRhNEZoFLoZSNUPOxsf7jKtj5N7/biCY2IfgvAIbme7+dVbZrHgGZAqWYgtSo6LMYu6rdGTyZNWdVj8Qj2awxjMl8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZeRRTKuoG9wS/i9jimd56B0NMYsqqrpUcep+RsS6stw=;
 b=Nz50tWQ9s1OGlyGRKnZ+enMly2ung54PZit15u+1JvcU/PfdvCVObRMFNL3rlu0X04ZetqQtRLbf8HD5CnWBmfDsCgajLh4n2d/VwmmwXcCJnNl0e/GXqcRy8EgdznvMxcZq4CHRmF2W+WXHiBROBrMt8euB1XBQlStmHP6g0JBCq+yZuol4RgaGPPNfkN3MVJZZO+d50jtRm7BLOdX7rGOZAnZqf4zlxPfDI9t88+Ft8bX0KlxuCcy5DNO6IabHtp7UB3dB8z4ElVaupgEdbpP9bT8ZDWGoRo7X0iJh1FMcMI4yzODdx04+I08ekDL4QsjPvYlq0TPZdilaBPWQFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZeRRTKuoG9wS/i9jimd56B0NMYsqqrpUcep+RsS6stw=;
 b=SuYAbKkOS7Ft6Lj0JCfrgbK1TUNS07zy7BiNUvd0aOJvOxWveygG4B/4mwMKmkmrEYchm1gQsZf0lMkiurrYL0jpxGNPe05Cigpp6s7PKDTOL309I3hGcToHkxt0/PaxKxUjtW9Zalht+K7jXkvQeeKbTHwhXtGMkZCWM6URwqo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB2972.namprd13.prod.outlook.com (2603:10b6:5:19a::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.12; Wed, 11 May
 2022 11:39:45 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94%3]) with mapi id 15.20.5250.012; Wed, 11 May 2022
 11:39:44 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Bin Chen <bin.chen@corigine.com>
Subject: [PATCH v2 net-next 0/2] *nfp: VF rate limit support 
Date:   Wed, 11 May 2022 13:39:30 +0200
Message-Id: <20220511113932.92114-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0054.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::34) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae92cf59-185a-45d7-2846-08da3342f1dd
X-MS-TrafficTypeDiagnostic: DM6PR13MB2972:EE_
X-Microsoft-Antispam-PRVS: <DM6PR13MB2972B6B267B0AEC45746F3AAE8C89@DM6PR13MB2972.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IJvhvY0uq5ZiMumFWvaw2uKXoW9H9fV/VJCJ+R6bF8OU6d65MsMU5vyPEtnoSiDAAPOr7XWMHECpRiRnKwirjaBuEYXeaPZ1MZzhDA4eeb3+6DEeiD9Z2ZWHHMQRBAmc00FCK+KTy/Tt6ECSZlLakezC/wXK69qHs2P+loshPO1BKz8ygA73IXyyWHYcA8KiRV1dFQbvzpYxKMn7rm+2r+z6ekszTFoBnrcG4KBmGqFlCJXeE3W0eFmr7QEHtx/dNPTqZdFivFcrNZJvVHEMpouzjbPT6OMlI8F7pBWKoixHJv6y7PLjsLbU9SODmaBKTmsJwDz842zrDmYQ2yuiLyQ8x0eeeBt04XwpxV0PTkngqzt03e224U4ofISogZpB0QYuI9M8h2afPlui60rCH9k9DI0U/oHP07/SWo/mGsuBvn+h+CpANXyWRlZ1DDRmPyjMH8000XCafWlkE4jqjCI61t7OoBULk87lCM7V08bj7YOavINiPec7Uk5UaSd/7iiRGFyGFU33bCzJyGF6osi+MmzKjXjrKDWbVnSm/vRbSqGgq/YEjnaoLQrIi8gvGaKEmEXN0HbtBR3VnCHeyr2H3BYmSAKcb7xAfi9NLecnN5kHi9rM6hozId1d7LUnNJai6WaDDIoBn9WMzNw9GQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(346002)(366004)(136003)(396003)(39840400004)(38100700002)(1076003)(508600001)(107886003)(6486002)(83380400001)(110136005)(316002)(186003)(8676002)(52116002)(6666004)(6506007)(36756003)(2906002)(6512007)(4743002)(66556008)(66476007)(44832011)(66946007)(4744005)(2616005)(5660300002)(86362001)(8936002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?de5Rsy3Qm49paGd/kLhMFTBhrPW7OlbUktN0N45tsNGkVmHdDQmE948IDi4c?=
 =?us-ascii?Q?quq4ob7PSa9zN0Sa9aa7zppu6jZUZCa9CylXdrdAHJfFBRR6QOmpwO+kjnfJ?=
 =?us-ascii?Q?IimQpdE44qrTvBd547YQl5JHDDrY+9zdqKja9F5Yve08leUulsy9ZsBE4Mod?=
 =?us-ascii?Q?AS9WAaXu7KXG1JoSQG01ugZXSYnBN0TXJQSAA3XFrw3CSZNUEPr9oRQ08Wr/?=
 =?us-ascii?Q?V3IAAF+Y4+tURGQfyPxJ4aN4y+hFqDF0Lkc0khRwavygxKZugyfXVVeZ+JWU?=
 =?us-ascii?Q?4nt+aoa4JQsXvp8k+mFhO1q8wM2mtOCBxV98H6+nWu/irJrMB0KFhQ/IJqkV?=
 =?us-ascii?Q?B0g86vFz3OkSnQfaHbXDjUJkUmIg2f1UQADEuOlc9+rRzRYJGqkev37qG9dX?=
 =?us-ascii?Q?jMwOwOUy2H5yhv19j0SbXCOrJUNoguf1X9k2BBqvraCOot9hVKvLMEh3E2rm?=
 =?us-ascii?Q?2FjggFmgK0iwymAfS1p/PY//tefE2ngE1Rl31ldRJHHG4Sk+scCzgEnI8r45?=
 =?us-ascii?Q?1BLevJ1Q//YB4MNg+1KH3ys7yRwogDQEeZXrXU6Yg2jttNTA7Mp9ZR/hzWIM?=
 =?us-ascii?Q?VufElRj96tv42FeIjbeippD0i1mNhn7oSIaSGJvppnVJq61pNkWU2UYi4XIP?=
 =?us-ascii?Q?5bqph6wZYrwJNgdbBbj+QKgxtmhbNKmBANCCpGNNSvCy156r9F8mawHs3UIi?=
 =?us-ascii?Q?XTDs6ET7q+WyEvE3NUn+OFzCrQ2FtQ1FYZHmFSj4Nw7qW0a2fuqBg/NxrTkh?=
 =?us-ascii?Q?02GGzQOqosOWpKk6/TAI9lvAZRHlox4zn+4s1ffPD70P9kXGOk56AhEM5ZSR?=
 =?us-ascii?Q?7+BfYozNIFt6uhv/Vk5taAoX/hM1WWQ28RkChsF5auq3Zf54iBWLS8YyeWAh?=
 =?us-ascii?Q?8tNn4ckC4EX/53pkdCgqUbzTtEmW1aRqjNHHGcNzyQSBmJFw8W6VlvgAT3HK?=
 =?us-ascii?Q?MOpS4a9y3fxzhWTDonrhreN5k6akIAoUzvlXsM+QJXGoLmizESVi0lD+8peT?=
 =?us-ascii?Q?unvB3SNy+4HJgr/E1o8IgpAzt8dGC9tPJVK1/u058Jv9lxoBWQ/v9UeD3zML?=
 =?us-ascii?Q?y+ORbUPQg/Wg7QyNfnYPGnYjeNUk49RWu8bgmZTbF3h3B8T9Q7z5FeHR7hhR?=
 =?us-ascii?Q?ssXUIvvSXGocJw5mKxPUg66kHTi671JIz5mp9nzTsCypyNI8fOows1r0pm1P?=
 =?us-ascii?Q?IKsJ4hGM0ltaltQfKMRksYJs2rYPKtihc4QhfDAHXos9gSsHlxB2TUGudJ1h?=
 =?us-ascii?Q?3DBCn6L9MlYq5v+0IV80tY4efT1F+4hB+OLoL1sNtVoq+dQ+4EOS+FKRzkHg?=
 =?us-ascii?Q?KZRfxe23vzSfH9cO+H4fMnHhiif7DDRVkzRtgAEoHT8u8Ti8C2Lkc+MKVfGE?=
 =?us-ascii?Q?3pGh5IqpTQks9zmQp3snk+3P7zSYae0IgPspZZ4+SqZFZVvfjGNP+0zKmRLR?=
 =?us-ascii?Q?zABpm/cGSP0zk/2RQREwHSb/y7qFqpflCf6ehICzW0nbfNL/1VDsGZlvM9kJ?=
 =?us-ascii?Q?kgmiw2DF1E/hvunx37s5wLlN0t3sNWP23413is2SMaLXPyVTLQongz812YAv?=
 =?us-ascii?Q?gOU73kQhdp5BIA3I6EWwDIlmHu9n1PTegnS2sJQ9+G3D+NH9cAH+UhUmPIvS?=
 =?us-ascii?Q?9hTUNrRhvBkmGpmSKfHNpsIKAhTl8hdnFGn7hIdluRFghKgm40WSoBYGW/pR?=
 =?us-ascii?Q?om5rvgoS+6RNxmOzZmcOnXHuxe/mUA9Hwj2zGV2zpSjWOcmfPg0BQXte+5bB?=
 =?us-ascii?Q?hx73t5PqVVZg/pqKME0zm8HDY7u01bEzwlYGQ5LbGxeEp8ouq8JwgF3fjOoL?=
X-MS-Exchange-AntiSpam-MessageData-1: 93jkaeU624VlPSJmqJYgdqKAEc3FE4wyy60=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae92cf59-185a-45d7-2846-08da3342f1dd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 11:39:44.8744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: apJd5A0ozbcsiiA52RO7+PKO/IJ8oXjcINm/Lm8quAVv/yz+u//C5wAsjoxssHeNhSsvdl6VZqkYAcWtmE+LyMx7hs71mQyFQFXqhkXi+Pc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB2972
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this short series adds VF rate limiting to the NFP driver.

The first patch, as suggested by Jakub Kicinski, adds a helper
to check that ndo_set_vf_rate() rate parameters are sane.
It also provides a place for further parameter checking to live,
if needed in future.

The second patch adds VF rate limit support to the NFP driver.
It addresses several comments made on v1, including removing
the parameter check that is now provided by the helper added
in the first patch.

Bin Chen (2):
  rtnetlink: verify rate parameters for calls to ndo_set_vf_rate
  nfp: VF rate limit support

 .../ethernet/netronome/nfp/nfp_net_common.c   |  1 +
 .../ethernet/netronome/nfp/nfp_net_sriov.c    | 48 ++++++++++++++++++-
 .../ethernet/netronome/nfp/nfp_net_sriov.h    |  9 ++++
 net/core/rtnetlink.c                          | 28 +++++++----
 4 files changed, 74 insertions(+), 12 deletions(-)

-- 
2.30.2

