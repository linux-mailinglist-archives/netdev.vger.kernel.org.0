Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBF296C323A
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 14:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbjCUNDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 09:03:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjCUNDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 09:03:40 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2044.outbound.protection.outlook.com [40.107.212.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D83A4D607
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 06:03:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fL1xXVt09Psp8ZlTh9f1MYWdbS8syNPAEsaftFxlrxOFxo8Xmq2AFgKJuVhy1QhvsWMnItEv666jmtuf8InWm/KUWqyMcDEXmNAX4UaFfi/m3IkfBj2JcyA4wcMtR8cEiPl4VwydxhnW6abeSyYPighBq3bVZoYriep2G1wPdVqGzxu1V1Uz+xHx2nwnY7v43w/R2t56HRbwYbIkF4qdZVh0Z9JgmK7GWuBtM93Wyr4aCrTAdTCgVs02+SDdP64qGcawKryMSiU5JylEl9q8SA18QcH/k5WEnbDZEBGU6otgxhfrurpEKctpEiuGFmQQlh605qMV/S1sQsiq2H4IRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Z+Qv+tMrx5vgPNjFWzabUosmZXDsDz0BGr6CmtpHu4=;
 b=DsNSZFD/ULkYxTsUTErk5sDyIrWZT8WDgJNZRuQoKrvGo448jmuiLF4QC9VpotD3Xzb9Hc8X8yaIo0YxpqOVs61z2bZfgTXpF0EkKr5ZCGQQ327lazcONIKrgbn1QnOe3XJ4XdGidfg0hXmRQCxj9HqRsKpH5eJjx3T08qPkFmgac/QCuhm9gB8gWr+8qp1jBq/E3C/Pc31Rss75Uelb9dhC9zwJDPNZhEdD6Urn/OrJKBb3jP3ZcIvOg1f7gRGiLlUA9HSFuN0MAzKTLOzvHd7YJ1vkri5ktTlxP9Rz/eTWAby/HDsi2uwITJlHRvAbkON6hcJTa/6bJQXm3ypgKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Z+Qv+tMrx5vgPNjFWzabUosmZXDsDz0BGr6CmtpHu4=;
 b=pQJgNV8JV/Zj0cS5R9SnqnIF3nntxZYAHegWsLa8HRUWNH+q2XgvJ0/gbCoBuT7Mnbzr5R8J1mUAAHQBqGYb1Z0PfIIKwnMwlDTG1+Cm36uF/yxg3Y3fLp0WabVtL4Ws7sTlEOwrZ9k/Wi9mC73vnGw+qbxMcZjLgicTENJIHBxjPsi9t/lsLd1nmuC2Yam8Jd+JymC7r+d6sOGgijmgslap/ad9FLA9EdpZOtLIpS086gMS02Cd8qX5Zyl1JGDmZbb70zm7Jpyo7L5J5R/2D9NZv94VpJTcPi6S67KYi34plgmAWMYP5iKaV5whYzaKm3JXIEWK/I4BSBe4TkO0pg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM8PR12MB5478.namprd12.prod.outlook.com (2603:10b6:8:29::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 13:02:58 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%5]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 13:02:58 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, razor@blackwall.org,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2-next 7/7] bridge: mdb: Document the catchall MDB entries
Date:   Tue, 21 Mar 2023 15:01:27 +0200
Message-Id: <20230321130127.264822-8-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230321130127.264822-1-idosch@nvidia.com>
References: <20230321130127.264822-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0202CA0028.eurprd02.prod.outlook.com
 (2603:10a6:803:14::41) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DM8PR12MB5478:EE_
X-MS-Office365-Filtering-Correlation-Id: da05d515-8f20-4074-8858-08db2a0c9814
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qFkfDIn3hRZzlG7mutIMv4EsLFvMIYRLmpkAIaru+RHmOn4TXhAcmMXGd+7jPKf2wgPBY6Y8OL+RZFjJle61sig5rJteNjDAC3OgBmXT80JQGDuB6NrId4oj+HC4uYYtMl3lgBimtty5gsEQoRGSY7glVtDgB8x78SZfgBcrKgF5P7hoF1t78pHaz/Moiwz3H1NJHjEAVcloD7Ax525ns2LI0OJYn3HSsI+oclF/2N6racxlQRoLt/D5s0Swg2Upc0a8/Gi1QTJZxSTw5X7oqJ7MWCUO0P/NkWTLz7QzIrMhZ/34KdmM9awi+S8AMlWFdzRtpe+v5SDs//HsUnJtK4ETMXl0qHiEUGOyI2IPaTzpZzTP1fswuiWQp7w6ZlBd98d8Fd4WnCvZCyAR0+oxO/OJPGQa0rP2zElcHi8/un6FvSjOABnWP4/n0zGQKH8GxgJwaD+TENVZCw9k2037s9Av7H2GHEbBaLlYqE6mCLzf4e8ZTylU6T4bSFLxRtew4DxalGHwNSXVpwE29Uv+Ha51KmmRXo3xvQbT0RdQ4okU7w+YGfkvlO802CtIzvZH3SBP03MexF9Pga6PfDVty+qmZFASfu+LHG+LmTyHJhnpBUxgrN+jleF1qwt+voWEuJhY57DGV2lwsMOa8kJDchTD2ROQtaMuXebE+qnukRhAnQu74oALVviihj/4nrb0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(366004)(39860400002)(396003)(136003)(451199018)(8936002)(41300700001)(5660300002)(36756003)(86362001)(38100700002)(4326008)(2906002)(83380400001)(6506007)(1076003)(6512007)(478600001)(107886003)(6666004)(186003)(6486002)(26005)(966005)(8676002)(66476007)(66556008)(66946007)(6916009)(2616005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/Jzk3n7W9/5z3Ghb3KAJE8JVPaQjyGqw0y8kpu1N0fLY0raqGuO/12fzDa4M?=
 =?us-ascii?Q?635ETJse/9GcvNXLS5sqfjPxuayJhFj0CbogMxlBcHyD2x2u5tsXOOFffgUV?=
 =?us-ascii?Q?Y9A2ovSWREA69D4kDWXgBLUYcZ+tPaQ6Ow0uNV9kvc6mkHtPd+siluteOBNO?=
 =?us-ascii?Q?VxeOW6wz0O53K5D5ozrLzjd7tWMYyYg+9hJ+Qx+bD3Xy8f84xi/kKrZoSQ62?=
 =?us-ascii?Q?baVOsGrGAAxxA/mOd597TyXQkripdnvUjRokOzrxiGiCClN1EI0qgUMIXWGu?=
 =?us-ascii?Q?4SR4CSVBK1SKb3FQ/Oh+L/OdVl1TnHfrytk3ehX025oUntb5njJIWfeg3y2u?=
 =?us-ascii?Q?IhF8pyJyogkmWYyxZshNIV3eirQLrmjWealJvO3vtljahwucnb57qMByGlJ4?=
 =?us-ascii?Q?SBX9qOIfYdX/90NymxyRcbINDGMFlQ4eoSMErUdofAtD76hw5I/O02m8DRo1?=
 =?us-ascii?Q?TM4MkpbBgEmK+yxH9y8CvfzEnLzQhuA1FYZjS3fp34Ld0Rmx10ZHZ47tDQwW?=
 =?us-ascii?Q?b/ZNO7u2kOSpVngPBn7H2UjrD4jxPbkUhztYOMdpXdFi9btVzexxsivTNNRr?=
 =?us-ascii?Q?t2vDSUQ62ZcJwKB3i6/p2irDKWjZL/+uQtU6rposRNwuMfAuDxZ5Z0do5v3h?=
 =?us-ascii?Q?ltYT6euII9s5ewwjGyi9Q0dyML4eX8YPEUNuVLg8+1nUi+7uC2ssZaciNvCF?=
 =?us-ascii?Q?qs1R94jm4Wr40aOQb3MQ0iIpqfm+3+/VAXZrsV/boX9YyY6RH2NFyTcI+bMk?=
 =?us-ascii?Q?qV0KsS9pk5MGmGAInHHFI+HYyw8LvUWsJQLwm1V4Yv/Y6F6rOrOPzI6Ezhxm?=
 =?us-ascii?Q?vjcqPU8sPpx3qe3FRqsgoBY9zAYJzid0S/TxGVBQYOpdzlg8MxyNiABcAJ6v?=
 =?us-ascii?Q?a09vFC7K8uwOqXYXBWwtVqWlImkr22nDoon+lpmQKTvMrYyKMkjVO45QOSR5?=
 =?us-ascii?Q?4UmvbOVFUb31nJ8NXIolgp8nRc0srwZy1GSb9DLDLmJ3yuLIefriAYJ3+e5r?=
 =?us-ascii?Q?Em2NOWF548nMpwnCEDvGjaedOfuTv0BiD+GhhmAouX6jKw+3T+/35ULzyS57?=
 =?us-ascii?Q?RKaPLkoaI8ma1wJaqkXIfnS1Sf5RHIIXgLtjR5CsDzYoeH/EqFJ0b7MtMY3c?=
 =?us-ascii?Q?Qjdb9QFz54gfguDH47bIVwd7ePDn77qQu/SECXZ8wviCNV2HsI5I9Oi9NjRx?=
 =?us-ascii?Q?Vj3wSjjjtptG5mYx8p19IjdhsxzaiRLadDM4qlY6a+ZwMBizpG9lNuILGY2g?=
 =?us-ascii?Q?0uVc9ZFyV+H+ZFtvsrprw7Gw2JCUBjeMQI42E9dS4+Z0y4NqoGDjWnYnVhJy?=
 =?us-ascii?Q?CdYAKjnFqPM62qrejIBHTbMqoaSKp0sV2oo0UIfkIpUpNV1GEHVa0Wf7chtL?=
 =?us-ascii?Q?D1irbTnRlAPMVhSBjNz3B5guFeQCmCScpEru0vrva+7SzmJssg4A4DmwBpsC?=
 =?us-ascii?Q?Yjwr87weNR78h/KQ00+U16csorhoW+JCA5b7BFcCeA7V2XtPf3MqsSmpEgdt?=
 =?us-ascii?Q?QDxAbg0QqabFOtSPHDp6ZPR9LDWlLW6l5LaZzohdV7RD9oSBhQ55gogxuPxB?=
 =?us-ascii?Q?xr/mOgkz/6XNbhCMYDu3dP0Mrhtmft9l4/FD6sp4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da05d515-8f20-4074-8858-08db2a0c9814
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 13:02:58.7669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3uqG5a60qbAdxhErbO4tGjfR+g9bHSu4kz2yCpwGccEvue/xS91Iob578YSXEKJUR2m/ZBGEJqUavebalEOAHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5478
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the catchall MDB entries used to transmit IPv4 and IPv6
unregistered multicast packets.

In deployments where inter-subnet multicast forwarding is used, not all
the VTEPs in a tenant domain are members in all the broadcast domains.
It is therefore advantageous to transmit BULL (broadcast, unknown
unicast and link-local multicast) and unregistered IP multicast traffic
on different tunnels. If the same tunnel was used, a VTEP only
interested in IP multicast traffic would also pull all the BULL traffic
and drop it as it is not a member in the originating broadcast domain
[1].

[1] https://datatracker.ietf.org/doc/html/draft-ietf-bess-evpn-irb-mcast#section-2.6

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 man/man8/bridge.8 | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index 9753ce9e92b4..4006ad23ea74 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -1013,6 +1013,12 @@ device creation will be used.
 device name of the outgoing interface for the VXLAN device to reach the remote
 VXLAN tunnel endpoint.
 
+.in -8
+The 0.0.0.0 and :: MDB entries are special catchall entries used to flood IPv4
+and IPv6 unregistered multicast packets, respectively. Therefore, when these
+entries are programmed, the catchall 00:00:00:00:00:00 FDB entry will only
+flood broadcast, unknown unicast and link-local multicast.
+
 .in -8
 .SS bridge mdb delete - delete a multicast group database entry
 This command removes an existing mdb entry.
-- 
2.37.3

