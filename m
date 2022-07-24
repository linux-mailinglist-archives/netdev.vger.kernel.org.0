Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7A457F3E3
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 10:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239091AbiGXIFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 04:05:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239243AbiGXIFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 04:05:04 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2080.outbound.protection.outlook.com [40.107.220.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A57CD1A04D
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 01:05:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=brSiF6gB5iI4t+ks9uR8s77yeWkgCLQL8OT4haMv7eO4d1eVP0f/FtuNa7Y0DFh9M8N8/wUR+ZdACMUaYFuyDxZqjOiw1ZW3b5T+NIHGXEWciaAq6mp+XcfP3YhdgWxcmuKM138MSazvAH27JN27VrHdfejiOJNwmWbeFgF9HudETd1EZUUldCInXFprEJyq44xI3W3PeRZH2azkUqTcPe4GKuuaiuRz+Q9zhQ4BNkFUuY8JIM+QENfuDxuzJByNcmTZtcQa6bEnkWb8D/f7sxMDM13ME6t9c2aNaO52ESxyZsxHMeteYHKfpskNmeF0lMXZvAb4T2GX/KHX9scTVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=thFIEs7+9ZWKUkoD81BwCXe9p2jWuOJPJ6ifa4pbVXI=;
 b=k2OKYUZSoy4ZBLN8erHncHDXrBHBfGKCCPu+ZmLXEQ0+5Mzom8ZgZqVx11Y2REtQMf1IAitn2NO4oRgcI5Pb7mD/PXvyyXPFB+5T03V6ZnjAk7HQkO8CvLToOB8S9Qq9+a58n/GoQKTmmtLAVxFl13ffojjqS8YADhSVtZTk9HuqS2yw94nBdbuEnQhR5xvtqrL1o39p3Ohu5oGqlwacCOtl6ypQbX7zt4xOaheU2Z7IqrPD6i4lO8ZCGBkiFPwiHf3p7jkT3H+VlCqQsgJsj1V1tkGXqJM4ZM8eXpWGoNnPBfCj5AUy1Z8MAWJHdtyoxdvulHQ4zIFVV5Ty9Jcbkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=thFIEs7+9ZWKUkoD81BwCXe9p2jWuOJPJ6ifa4pbVXI=;
 b=D1yDQ6bNfB+xEtHHOix2eRiGikh5bxItHrilyCbkbSMhL/VYcWfoCymLbmOQ6lA2IPwX8gvNCyW7KE/jUncfcKnuZWpl2AUqBCqG17uCmoLIFqgu2d/NJRCUehOUpJ+mvbFgI3wl7U8JROHt/9dq6cb2eeZqxKaazaG67UhlEw82dlrbS7STUy+Y2Lyc0aL99DxYP4fTi9NAEIXfPAYcEyN8zxnjZo/kqlBY4t/3DApt9/xfarTL4kXBNbMq9CviTacyvOQejLCfid31gA2DP9+JWSPg4A+GNz1u7Sx7IaM2YuIzabZopn/yJROU1qvE6izSAWlF7OtyOKUdaPt4ug==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CH2PR12MB3877.namprd12.prod.outlook.com (2603:10b6:610:27::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Sun, 24 Jul
 2022 08:05:00 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5458.020; Sun, 24 Jul 2022
 08:05:00 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        danieller@nvidia.com, richardcochran@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 07/15] mlxsw: spectrum: Fix the shift of FID field in TX header
Date:   Sun, 24 Jul 2022 11:03:21 +0300
Message-Id: <20220724080329.2613617-8-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220724080329.2613617-1-idosch@nvidia.com>
References: <20220724080329.2613617-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0359.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:d::35) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e3aab63a-c85e-4392-6a40-08da6d4b3493
X-MS-TrafficTypeDiagnostic: CH2PR12MB3877:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iWO+Jg3vgoC9mL9pVmqoqJBgJSNhS5fJfXSRexaphNnR2/XMO6/+7NxJ6LQ30OBALRlMEYKmxbhAbfxxi2cowwVBBa9KZY6MlUgHFW+un3AvTkKfJm9uW3pLfURaNc4tTl0WC5iWHKyqHceFsIiWNCFn29spuIrasWO8KxUvSFsbp50auUOLOViqhqP4V3/diLpSnzutDTd1X6PHzwnPFozUpwy9GRQnx7FrZrOyzYTFjxUWvytGEF9PdLFiBhrUSEPOoYg0tJDM6Bh5mVwUeI5s5CwHwhXza5hW1eBKvPPgtZiy+5IQwCwwXZVEhR7bisjimhbAT6+obnjfN4M4WzTIL5xk5Od6TalRSIU+mDMO0ADaUXjEwyJWFbi1mbBAwm88QLE2bScxQb5IN7NX1/8ev3t5WxSfojeKq2HlKHxgDrLtCxNz99dsfBnzuh24fisLHgMVZk4CAhy7PIR5TOWGettPTL3UN0uiuHpLGMUFozN3/EkHg9T10iCmep8PjqIsg2AApy5ysesEru9qZgZCA8eeYQp1bLMgaAtgtdjMS2BYuVZKGzTvCfduP2PT+QSL4qaC5fg2TEgLxBM70csxGhXBgrhKo/k+rrct0YWjeP1Ho0TZx7UH20C56R09zfn4sWMAkXsUOgezrxL1Q0i6CtYBrkPXyk5Oy1rHDPe4rRrC9ncJT6jEAwTdRJI/pQAksegHdHG1yNNrrU6tTGgQ9WC69/8ADCHEDuUHoRk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(366004)(396003)(136003)(376002)(186003)(1076003)(2616005)(107886003)(83380400001)(4326008)(66946007)(66476007)(6916009)(8676002)(66556008)(36756003)(6512007)(41300700001)(6666004)(6506007)(26005)(2906002)(86362001)(38100700002)(5660300002)(316002)(8936002)(6486002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CYv49as6BWMQIg3C0dWdwqVCTL7pS31HfLtHvGL5VuGGWoASuRQ5LYOzHcdG?=
 =?us-ascii?Q?JY+ryCClD+aIa8h9nRYegHAE8rj/pd7Dk9onrNXlrhShw7gKXd7KasZk7FtD?=
 =?us-ascii?Q?BlvHxS7B1wA3vYXts5WZl1/VoXZ7EbZnHQdAA9FkoQn78dy5FG6ouFpfcKPa?=
 =?us-ascii?Q?ZQo2j4Mj0YHgtlxIwRaPl3wv2FYut/yih00j7elxemwRFXEF6qQDoOJPogwI?=
 =?us-ascii?Q?PTK0nbbS7Kyqb/Z3RSyE+1tqzYTKfQ4qM3PlET5drmE/9kAW6GrJzCh5sELW?=
 =?us-ascii?Q?0andXW9oK3PThml0QLkD2jPnwsn4rXiHnKGTm/mSAaisHQ4i+Kj+nlRwiMrd?=
 =?us-ascii?Q?37hFRGFxsAdIw7oVhjdwTgPZGx6NcV+JHt7B33Fcu99Zwc78zyzUThUyTGJE?=
 =?us-ascii?Q?vlx/ganLGhnq7iRFLFvs3QjaaVkFK7jkBz5W75NW5DxuTk5oHeFXhGkUZ6FM?=
 =?us-ascii?Q?nV92a2EkUwpB88jJJIe5TjD29lf9OP/T926SlKn9UoHDanBSPS+IC3ppOgnd?=
 =?us-ascii?Q?QTnM7P4mQuX3C3iufZLkTehjmr+yOt1UkC4CHTLEA6vJrpnNd2/X8sz0rmvC?=
 =?us-ascii?Q?eyktM/1G+gzqDBxoG/7IJu1SxnOUN/yiyOhPZqNHx8WR5a+LJNVN5oxWyeZR?=
 =?us-ascii?Q?PAplU51eUa0cgR3pclOMxGAqC7OyFYyoh2e/hGGJYcUIEch06GafFop2weqW?=
 =?us-ascii?Q?BzhmNTIUDPtCqLBHDfjNLOu+t/7fVZjFGbqT7BnzRXEMF9f+ueAMG56ZzTg8?=
 =?us-ascii?Q?bB93h6YSkkZMdvD1PN0QZFGpFaZbX7zlOSs5XpoPl8XKMYo7bQMYMxyiaSdc?=
 =?us-ascii?Q?PjXS1EbvIS0Cp0jCwPyud4O5vykoyx5nV456dxKVUxwm6GqaYUWTnkmkUs/Y?=
 =?us-ascii?Q?pizQHM6itR053q3tFv7mHfB484pyk4MYPokGg/Kd0dqVp+i7cmPyXZalDflM?=
 =?us-ascii?Q?MBOz2Ww/r1URT4JkQqZ3ek/jBLeZcHSIkSk2UJ9LLADtSmuXAzbihTek9fj4?=
 =?us-ascii?Q?e0tCFzOtSt7aBIMy7/wfpvo26zHuLr5UrGpzMXAFEbg/FkSQh+xGlHSRTmwg?=
 =?us-ascii?Q?0Ic85MJAXPnxDW7NwIqIgjmi4ay31s211hlmhQh+6dYj6lm98l0UmMudCZTF?=
 =?us-ascii?Q?FKDW/d0N5JuLM/c4htodF8u3EBNWpvwg6H+BDMdnIdIUFrf8kW9BMMd/7Zjc?=
 =?us-ascii?Q?FbMhS4riR+ve88nOF+mjnYdU3z2ngNtE6kwXQSpNbJJI6uG/Uj1MoZJfYge4?=
 =?us-ascii?Q?nnXSrY0oqA1LZhhbk2yHGgXqy4bEt3PaFV2j5hNhOFHHukYEQYSnLPqAPBz+?=
 =?us-ascii?Q?rMeq8pBTUL8Jh1OJxCSkKI7FqMNK1LLT8oooET7B36irpcSFPKwtKPPGV/q3?=
 =?us-ascii?Q?lqD9Enj0YpY1KY77GewWFK+iHYBgIqSx6Nkh00/gxxTCVqbO05jSFaj4hWm1?=
 =?us-ascii?Q?uIc0Z97aydx6a2HLGLYfH6rbx+mDN+aiulw2qUuuqmf3TPw5z/iBCYxSJolE?=
 =?us-ascii?Q?8G0VDIWqveKRpr9bWHTDhrhNSze9yacmIQuotprEePcjq4JxNmAJaksDERLC?=
 =?us-ascii?Q?XGMm3r9wj5yLTZ4TK9+iPx9IhK+OJT1UM3nRUHzS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3aab63a-c85e-4392-6a40-08da6d4b3493
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2022 08:05:00.0741
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pyt4PVcvV48i679kXVml7moy41T1DPXJ5PxVefPNuWjDTlP8E2C8puJ8nkCptWakuKpGoe+rrq0EyGwl+ePgsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3877
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Currently, the field FID in TX header is defined, but is not used as it is
relevant only for data packets. mlxsw driver currently sends all
host-generated traffic as control packets and not as data packets.

In Spectrum-2 and Spectrum-3, the correction field of PTP packets which
are sent as control packets is not updated at egress port. To overcome this
limitation while adding support for PTP, some packets will be sent as data
packets.

Fix the wrong shift in the definition, to allow using the field later.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index fa48b2631ea8..bd7552e8dd5c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -166,7 +166,7 @@ MLXSW_ITEM32(tx, hdr, port_mid, 0x04, 16, 16);
  * set, otherwise calculated based on the packet's VID using VID to FID mapping.
  * Valid for data packets only.
  */
-MLXSW_ITEM32(tx, hdr, fid, 0x08, 0, 16);
+MLXSW_ITEM32(tx, hdr, fid, 0x08, 16, 16);
 
 /* tx_hdr_type
  * 0 - Data packets
-- 
2.36.1

