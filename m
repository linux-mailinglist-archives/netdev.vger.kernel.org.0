Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF5B6D6D40
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 21:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235959AbjDDThf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 15:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235350AbjDDThd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 15:37:33 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2111.outbound.protection.outlook.com [40.107.220.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 942A7AC
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 12:37:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RMSD5hOmCQH/xDN8SKUt/MiRo1jNrS/RbkXpAwF8whm6Ns2R8ExBApMD7uIC5ZB3c7Ws7T2oXjSQg7RK7djxvp97lCu9MEquJ74J2FCEXE7z1vzNVpiD/Xo706GxcIxiiqZ3RMJQfHbTvymfXsvngocUFKGbFAMlC/z1GjzrvNrQ+ho6Cw459ypQR8q8JC7vhxJF8PRCCgG26frpU2BW/aoyp/ZlOE206zwfcZUS2imKDFJ8DYobBNFrc5sRH9mRCnPwpwA0AqW2fMP8dOuX5KPiPeul5sM88LvnOgA7GRwLN5FDsABnHYgZUwJyvQ+1VlrEbpIU2jbK7YLdsFtUzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xQ7DhYjFX2mYBBuRCxfQUM6d+naM6srg35m1tQIBU1I=;
 b=ne35dlgfdsm8UsWiS3IwOd/wBnsmqSMgvyVZ2ymzhruiDVb/QvAGJpatV8LVcJadPe+g4SCiRcMhK7yNt78msuygl3l//WMZcHlLPFoagWlaVBCRNaUIRxl2Z3uFLl6DvhHpESs90+9ocNSB5xqHvkHgnU2haTkUlrkANdB5JjAedfeqBrhDNjE6Y0SIZJ3JZIuCeOI2xQHG9o1Tb8//IQL3CUvKLHTOeZCl7OAl3fWLUeomZOoyALb9TmZ8kOjxOetEy0M+QU7S5PE0hPNc13CXuKCGhf/WWcQ9lAbhZsjXKOKhn+v/escjZrRLx6DO3le5V+2CxEvUoYTJsoS0Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xQ7DhYjFX2mYBBuRCxfQUM6d+naM6srg35m1tQIBU1I=;
 b=OgoANcdVjtJPxR+V762oS5a3EXqqO1GgMsX4LiPqd/M2y6OvjsSjDxTbmrwDtijHDb80mvjqI5WDNDIcBT3Y9PLWIlxHbGZ5+Frs3YCi1lR27La+Lq8gcjix9casTgfnaxM6VPc/qnS+vXd0ECqZB7SfObIHUO+itHmQQq/gjN4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4841.namprd13.prod.outlook.com (2603:10b6:510:a0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Tue, 4 Apr
 2023 19:37:29 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.035; Tue, 4 Apr 2023
 19:37:29 +0000
Date:   Tue, 4 Apr 2023 21:37:22 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] net: thunderbolt: Fix sparse warnings
Message-ID: <ZCx8coVLCObBVujf@corigine.com>
References: <20230404053636.51597-1-mika.westerberg@linux.intel.com>
 <20230404053636.51597-2-mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404053636.51597-2-mika.westerberg@linux.intel.com>
X-ClientProxiedBy: AS4P189CA0026.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5db::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB4841:EE_
X-MS-Office365-Filtering-Correlation-Id: bb06f0b2-07a6-4dc6-20a5-08db35440695
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rlCtrrvpUjmvGx2AkjfHB/+50YJAPSWAsL8ngNEotAtkXnqpwbHYcNyAHIWsLe+eZSE6rQhfV+JAq1mOv3YcKPbkLdynRV1p9/qS8AduRgLqcZ39OcEgky7sWlAFlq4Q4FuLF9b3gi7WA9Xgj3p9wp5TL+2FUpqvaKfbyj3Jzaxeuuod+tTvOiR6wdEgGk9HWgqaGHkoHfZNleUndYFK0i3G0QRhR1V5U2+8M2CMKfyp42o2xZ8f6AOEAyUUjdiRqgCNyuR92Yk+h7/E4ms/o/9jPVrLPIKEf83s6kB4g4PmmWP01EC7uYi7y9n8v0Olw+WR0REMYza08PkkeonxloLnjkN/1tNA5NWsIuUCD193VVu27zboY/vBHrSlUL4kXyFKjQoF8HHW1CAPpOJfI3QUgVxq1i9OGd8yRIHduIVVg0V9j1he/KBk7Ew39NeIL3+2BFp22mlF8KshRGGIQHB7miFFnubiQm59/tNxZ3ttK0THqu3O5UHnL3Ddfa0aaOWVWoa7vk9RhvPI2SnI9o5lkwYsjHaWk3LdXSf9fKWJqaOs5HHwf9qkM/8PIJKkFphebZdxEsIvmf5LqNn2XOw12B0f99YUc7rN6zEBhgk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(39840400004)(376002)(136003)(396003)(451199021)(6666004)(2616005)(83380400001)(186003)(6506007)(6512007)(66476007)(66556008)(8676002)(4326008)(66946007)(86362001)(38100700002)(6916009)(2906002)(44832011)(41300700001)(478600001)(316002)(54906003)(5660300002)(36756003)(8936002)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CUoDegKin+J2LABXA3aP87K3QO9AR5fypSYxjs2fr2HIG0vyCJCRNU606gp0?=
 =?us-ascii?Q?nGZb2w51dfGazdggUu7WZizU74VBnLOU2RXRAgdsyVJQmfeTayULF/587fyp?=
 =?us-ascii?Q?2iPkPN/TqqzjfWgoVP7C33P88c+ezH9qjvl+QSzefbtdDGJLCDkkNB7XsVQb?=
 =?us-ascii?Q?5NVDZb+LFs71qOt0SC2ykMTOrLnkgT//ra5BY/EhrrNxK2pDXQ1nFfvFjy3d?=
 =?us-ascii?Q?kvKc50/oIa+2cKQ/pxNvkYDLOfmGBlY25zFKWfR6J9ZE56nQz+u2/bsfBrev?=
 =?us-ascii?Q?0kSMWdvUPlZIBXNOYc5rbaPXp50xb8ONlpFH9oxtjHOUMtCWG9CftvVEb3nq?=
 =?us-ascii?Q?1s/pP76xBG0JCo6ehBo4+SbRoaGddDiMbp+w3uNzG/UrsX49yuZCbfh/TXtl?=
 =?us-ascii?Q?nCLFGK8gaobdRlxbwjSoyqhN2uGLm1EJk+vV5oL4FYyjNf0dL+pISS/Fbi04?=
 =?us-ascii?Q?fqaVYgmtT5swztAthX7MvULyJov5EZnVYOBUn1XGJETI4cegeRBhQdhw3R3x?=
 =?us-ascii?Q?Taoo/hfbGfmVqUO+v1743PoRPz9U3x8grJMUTT8jd20EeZ4T02oXJiGyxnKp?=
 =?us-ascii?Q?mdKiKPgUjdqy7VzlMy9GYzeONY1OSBofLx+Hq93u46fHZs6Aphb4lUb96QV8?=
 =?us-ascii?Q?wuL9F8FyeEnQRIb9sIoIr2zW8Bcr5bIbjZ5FQub9L25xGIEIpBOMkxeu9S5h?=
 =?us-ascii?Q?k3/k/KXmst87eY66tny2fwpTsAxMiNXyc9M9NyPJX3w1ea87l/uibBzM1HcP?=
 =?us-ascii?Q?HvMgBCSFwBdccar/sP08tc7hbdX3gQ6bR8/lfR5ZT4pssmqHeTi/piy963Um?=
 =?us-ascii?Q?+dxGUIWIBSgFpMxy9kyeUfk2P1RDZHIf6M2ltQ7t2vOVDCToOAeBShoMTFIZ?=
 =?us-ascii?Q?Y4XZYvw0/XCrnHPnt/vri9CsG5wwfOu6M7H2CUJl+37YE+xYmXEtRZOCSuye?=
 =?us-ascii?Q?rdZ/nHdjxcg9IBgv8HNKNxaZJKkCosuG8QthhXRret+KsmMRXOw9/3v9xk1U?=
 =?us-ascii?Q?NSxvx+HH3mAubGnf5bl/6wGufkY7+jZjMcNOfgZ9agLIeV2KXGB8cbuhQAY/?=
 =?us-ascii?Q?YIVO7JTvBG7jE7jb2x/zyIdZYO9pB8VP4Zr+SoQ2s+G3yEN4EHvx0wFzrfef?=
 =?us-ascii?Q?hwCSlXdheR3NsHyU8XphquQ2ySIBLx2Y5fytrg8/pYbDN3afsJzLv1ebosc5?=
 =?us-ascii?Q?Gliuc2n/qAqBLi9R/uO7a7w6zUjOAXLAQ+JqggAsTtDJrmIE/yrZcKjnlObT?=
 =?us-ascii?Q?lI4lPfsxmzMyaGKNKFtM/ehCJhfGRVMjyspm7mx64Y9TlzwEo0zxT0vFEII0?=
 =?us-ascii?Q?YyF40gYilTJBEQGZEfalUfCtmViLZyOvziz3hEhBOjJpcsTO37hT9Q6dajoT?=
 =?us-ascii?Q?/OBPAsIzQZsjKdpsvD2kxWjZUHfVYeMyAuap0WgcZrOYTxLo5v4UDl4AzWKa?=
 =?us-ascii?Q?0B9DKCLEhiPRPtzD5Yps62GGRRdflbytNlIP3d+ppg1BCNMxvSEyvkUuJ57N?=
 =?us-ascii?Q?TJcJepS4W7Ksx1g+Xz/pLqBRYkT3CLIhmb91wDNpb+liGZrMZs8xOW8uQObH?=
 =?us-ascii?Q?ktmZPErCdvuSnaIKrp+bDiU3omKKnaY5FxV9Gs0/ff6W4IUp+OB9auRib08P?=
 =?us-ascii?Q?l8xf7L785RbX03JrABcOxaTJShUbeDIsVai5ab8nYJRWVGajSxxm412xHOrD?=
 =?us-ascii?Q?XTRalw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb06f0b2-07a6-4dc6-20a5-08db35440695
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2023 19:37:28.9991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KSSaEafIlpNmFX1c2G1VmUiVs/TrfYXs1O/imlMxySuo0X9HvMkFHxR+hGp33dOvUmDe4nOTIHFY33nzujCKB5PFLJlXAnVcgIFy4v0NpW4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4841
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 08:36:35AM +0300, Mika Westerberg wrote:
> Fixes the following warnings when the driver is built with sparse
> checks enabled:
> 
> drivers/net/thunderbolt/main.c:767:47: warning: restricted __le32 degrades to integer
> drivers/net/thunderbolt/main.c:775:47: warning: restricted __le16 degrades to integer
> drivers/net/thunderbolt/main.c:776:44: warning: restricted __le16 degrades to integer
> drivers/net/thunderbolt/main.c:876:40: warning: incorrect type in assignment (different base types)
> drivers/net/thunderbolt/main.c:876:40:    expected restricted __le32 [usertype] frame_size
> drivers/net/thunderbolt/main.c:876:40:    got unsigned int [assigned] [usertype] frame_size
> drivers/net/thunderbolt/main.c:877:41: warning: incorrect type in assignment (different base types)
> drivers/net/thunderbolt/main.c:877:41:    expected restricted __le32 [usertype] frame_count
> drivers/net/thunderbolt/main.c:877:41:    got unsigned int [usertype]
> drivers/net/thunderbolt/main.c:878:41: warning: incorrect type in assignment (different base types)
> drivers/net/thunderbolt/main.c:878:41:    expected restricted __le16 [usertype] frame_index
> drivers/net/thunderbolt/main.c:878:41:    got unsigned short [usertype]
> drivers/net/thunderbolt/main.c:879:38: warning: incorrect type in assignment (different base types)
> drivers/net/thunderbolt/main.c:879:38:    expected restricted __le16 [usertype] frame_id
> drivers/net/thunderbolt/main.c:879:38:    got unsigned short [usertype]
> drivers/net/thunderbolt/main.c:880:62: warning: restricted __le32 degrades to integer
> drivers/net/thunderbolt/main.c:880:35: warning: restricted __le16 degrades to integer
> drivers/net/thunderbolt/main.c:993:23: warning: incorrect type in initializer (different base types)
> drivers/net/thunderbolt/main.c:993:23:    expected restricted __wsum [usertype] wsum
> drivers/net/thunderbolt/main.c:993:23:    got restricted __be32 [usertype]
> 
> No functional changes intended.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

