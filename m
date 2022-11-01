Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7161D615271
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 20:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiKATj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 15:39:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiKATj4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 15:39:56 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59CE5101DB
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 12:39:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j/grlot/TOe0qU6+KYgGyAI7j0s2MjWtHpEgy7Z/+CkPRx57vlpoWKgiM23NyhczTnMNMaJLQ6OzRIXCM0lYk0CIXhcsjwzHBi8YohEHWLFqWF8wlx5aZM2govaomSBIFwmfWwCXNlfL3BsetmtTKNLnxrHGSOu3PrC77I6Z3iRA8y2Kx1qhJ/zcy/kjNxveuxofkpFJ0X+EVYtUARf5IR3UckIxNSGrbBdBXlbT45nNBH6MKvKgrCpWMji+92EI/zCURofdZesP+YGrA9g5ZAZDS50j5yW6QsKJqpHSyrfmAUyz7skrJQ5tcrIBBps+4MqQZKOQFjc+0mSIqtQMpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xHbYCIWMhA6l09LiALAANqrPHZSYZKq7H7AjC56bCpY=;
 b=TACp5CT6HeQFq5roymfZdXr8fAjkpQOYFAARGr8Luc3AUQmvhrAe1bmsKDJ4XiPRsMEV3IcaMjgnDjogkbtPcfnkJdGWv2UIcSU407ccOWQOosv16KbZshC+Izj5fbLBd4+2H0Jca76+h0OQTlodBknsYB/ZBr1AO32eQ4JdCZt9sRwiKwu7a08rzKVeQ5IS24tOZUB9WCupi+60WY2RiCL0ES+cL/eqprRPSp5KoGaqK9ifHH6RDcwMuWLE9wVhiy/ScyZrqbop+Eux80F2pT8qQ97HrLKUaxxBGLzJBQv0TpwOQPHJqok9HGUY5IL7+7ZNJT7dtPgKVEsiASYv9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xHbYCIWMhA6l09LiALAANqrPHZSYZKq7H7AjC56bCpY=;
 b=tKPcJfwUih/+MQeOO9m95gywE+Q9MZn+fsyk0TPGX1pWLDnCD4WbBpDqqTwZpHoBcNDZVADPxNLXtIW19DspMe1X7xFxH9kC7fMAxxwbseLwfbsWGG2Kyio64wj3aUllHBORH45RQAJ8oBl8FyXjqawVt47XwZYcV9rGCTTFOnjKvYKZpANj/dbTLd35p3irdyw+veEkbDkwvLz0jO417ZaW9RbFp6FR528rbFpqP5dLEMzW/7W6qyIe4tbRmUyUmQp3qnS3UJG0dTi1jfOiaLTeU6jL6REpywKtUl0bFZHplYluJu0mp1m876lbS5sKlDX5t6bZP1IC/imlSvw6tg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CY5PR12MB6382.namprd12.prod.outlook.com (2603:10b6:930:3e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.18; Tue, 1 Nov
 2022 19:39:52 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::3409:6c36:1a7f:846e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::3409:6c36:1a7f:846e%4]) with mapi id 15.20.5769.019; Tue, 1 Nov 2022
 19:39:52 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        netdev@kapio-technology.com, vladimir.oltean@nxp.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/2] bridge: Add MAC Authentication Bypass (MAB) support
Date:   Tue,  1 Nov 2022 21:39:20 +0200
Message-Id: <20221101193922.2125323-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0053.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:5a::42) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|CY5PR12MB6382:EE_
X-MS-Office365-Filtering-Correlation-Id: 54485c31-8997-4ea5-c8c1-08dabc40d862
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xNPt5ImsSz3//YXOOwP6raHXj85K5jV5IXYPUgwyu/Sn8UtXudaPiAUeBlaJpKunGvZkpwtzzzSrId8c0+Qlq9dvIGZUgOXjrOk6S4KxDRwz9VEbaJiQvkbHMUjR0v2ghM5H0RJZMu3iWUsNP9ZUA05+tQbPrwRFrYK3hrJREHYIRdv7K3HQMF12SD8ufxcCQEcCYW6XJRULq0gWuYFeq25IEY8GyLd7F6dq/VUjPPtOC9oWLK7FNZB5X5XbRqVZEOdemXCyHFL7hzBjsw4qXlY5Je86IlqcOnKSNBu4WtcaOO999+xS0sx0B/W7sXUiI7Rcf/N9nPAWB+P380fvz/2LWaVQoP3X6H40OvtiS3F6pwdZ39OE0GkHxAYbPPNfLXjxVVeKhfG7zxwNcDjYNrcw5GchtqHlwyv9JDuB6Jg1cUv6nVtWLK24Ex+IEkLxzWWBr2FQ0/UUjxMrMMNjnAMGjLSGt6ZfcAvjNuBy5QG765BK+7WFymF4cEOMj3YG8F5cIZgG2evm7PIdsUlKGJZ0HMsIK3ms83g1S4cqDXWVkA9SZmQ47kmqLSbfxZMnxlaKHqo0oaPwzvgQc6+DBbangQusDScsAHl5Gb9jFX07qxorfXWfZQtHoAfFy8PuAbJLrGjDnP8rOxH+aUF+mBU7cMBUk4AOy/kvd78gWeGX/vY5ZhrNX4AcVGOeOUneWY/e/WfdTA7wBwgrvZqA0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(366004)(346002)(136003)(396003)(451199015)(2616005)(186003)(1076003)(8936002)(5660300002)(4744005)(2906002)(6512007)(41300700001)(26005)(38100700002)(86362001)(83380400001)(36756003)(316002)(107886003)(6666004)(478600001)(4326008)(8676002)(6506007)(6486002)(66476007)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bar6K0jQPS1a8ZDu4h1PGEHEayezbvk45AHhiR7va+6Xcjt7NFhHCdwsQjZJ?=
 =?us-ascii?Q?+P1vIOzGDgzXjw0dbgX5fLQG+6VAoSyWVOnp7QeeQY+PGUJbXv0AIqhrQOSK?=
 =?us-ascii?Q?Jwr2oDnHTdqN9K+8dZkIOxoWdgw2fGPQnIWee7FUTcg7HrSbyzXMlGX0mlxg?=
 =?us-ascii?Q?6Q+ROSiVnmUJRPW79eMmwZJF235xhfY6rawNQ+6tvmIzRyrc5O8zfxJK76KN?=
 =?us-ascii?Q?UM0H0PNKzYOoNb7oLls8ld1fB5h3U4WjOABjaBVShOohcyzW6nBpCfjoWsko?=
 =?us-ascii?Q?8tSGH0Z2zq4MkogT35Rfk3mbFjFiZ/O8VCj+rTSsnmE8DO4AInM7CxdWepag?=
 =?us-ascii?Q?oKYUvADl4yx3SlU57WXWA+elY/S55PJPd2Vl6tC4CuJHqgpNzcxEhcan3BIS?=
 =?us-ascii?Q?Yb0GZrIKte29V6NScDy0ZYy4IF632MbBYr0o3EaeULa5HXgnXXScvafp2CE4?=
 =?us-ascii?Q?FGm+xlU2dRBbsDoZLXmlXs6Jvu3XQlvfwWKvwCjt+O+JxNJ72mmcmMRJThqW?=
 =?us-ascii?Q?bm/F32wWCZEKfaVLJRcxO7bIR1btNgzEU7nbT5q4pelQGE4+VPQMfMKS8A7O?=
 =?us-ascii?Q?3k05kuDS/LU05RUZOPHrhATLegVyWocyDvsDI4r9O8koP/b4F7Y5/1k+vUvX?=
 =?us-ascii?Q?yQbD0WJv8S3LAL76zymb10n9MdcERXxYLKsntibbV9Ykwcx3g0SuZlLCfCrj?=
 =?us-ascii?Q?XWnHXrTRhXqooGJdOI/kzEdl6C7AIkMSXsbn5OKCN4ehYP83IPv1eCSWBEAf?=
 =?us-ascii?Q?KGXQHog8APdNLbTaM7srGW3ooUTyD9qHPzxQL9P26Jm2BbeQ6uOLrdwWDTNN?=
 =?us-ascii?Q?aiv2L/Yv6YkapNuSa9wT6JnsLHtG9SfKBOx/d2tJrT3Ksyd40mQVLueH2tmW?=
 =?us-ascii?Q?mpHiGfgllj6xIS/85LlzJEDaby5cXtnXR5Vbuv+uLoAhCZJYIPmCXXksSb99?=
 =?us-ascii?Q?OXP4X/zjqmvNtX3seEBxwBBKxuzfB1XFTxJmBm8fnDw3HvAwMxp1OqowvWiH?=
 =?us-ascii?Q?YU7aUw6dfXQOi3NNn6BgcLM/v+WW6OsWXRDBK4JS7GfXFCSAcbORHzQNVlyH?=
 =?us-ascii?Q?pF1JbJi+9bfj6diFEVjvDqR/tqgNcWXVjSaiFeV9HAKI3CToBHJEZhjUhI4l?=
 =?us-ascii?Q?YceTFMHsrdJB2GSo2LRZyMTW2fZPQk2YdnbsC7DFxvsDfdZTjnYl31xCc+ha?=
 =?us-ascii?Q?O1vGJIEAajyrfoZUWPOwSrnG1S0NpzBYopb1AmUDV3+HZIV35/iqcOnGLMPt?=
 =?us-ascii?Q?qcSG6ILDEoYY/vmQizdgFgfrDI1oi/dmJMLYby7iEv/pOxu/0RUBvI0NRJrx?=
 =?us-ascii?Q?csvhaN5dhagHUT7a05T3haXmuLLpjYhI0/gK0OjZ0tkCnn4loKYTWSLq6EPn?=
 =?us-ascii?Q?FVXM21svr2/0l7TXE/TLeo1e8PdHEQiSrhF/WQQmMSkazL+lfyeAunF8bZjR?=
 =?us-ascii?Q?cUUJRxfZ24ayfQJXvbc0aVYI+mpcPp2qWiBH1f2yLzWBZVuXeuOI6zEl3ket?=
 =?us-ascii?Q?MaP3EHwyZsxJv4sgvAnTNmdaic9js/MPSYbZmBUV480z1iW0yMjXH84pQwQD?=
 =?us-ascii?Q?fhuuJxjc9abxsri3NEYBAwssj83atDDFbQc6r5ac?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54485c31-8997-4ea5-c8c1-08dabc40d862
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2022 19:39:52.1721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2oYCYAYE3yh17lyEGiuvPSrYIbZ3LfOK9coX1YIPgZOgIli0wKbRb5CzmnM1jEGUUTBwJwjf3RvhQGk7ra7pYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6382
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch #1 adds MAB support in the bridge driver. See the commit message
for motivation, design choices and implementation details.

Patch #2 adds corresponding test cases.

Follow-up patchsets will add offload support in mlxsw and mv88e6xxx.

Hans J. Schultz (2):
  bridge: Add MAC Authentication Bypass (MAB) support
  selftests: forwarding: Add MAC Authentication Bypass (MAB) test cases

 include/linux/if_bridge.h                     |   1 +
 include/uapi/linux/if_link.h                  |   1 +
 include/uapi/linux/neighbour.h                |   8 +-
 net/bridge/br_fdb.c                           |  24 +++
 net/bridge/br_input.c                         |  21 ++-
 net/bridge/br_netlink.c                       |  21 ++-
 net/bridge/br_private.h                       |   3 +-
 net/core/rtnetlink.c                          |   5 +
 .../net/forwarding/bridge_locked_port.sh      | 155 +++++++++++++++++-
 tools/testing/selftests/net/forwarding/lib.sh |   8 +
 10 files changed, 241 insertions(+), 6 deletions(-)

-- 
2.37.3

